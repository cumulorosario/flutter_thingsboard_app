"""
Cúmulo — servicio de alarmas críticas.

Recibe las alarmas desde la cadena de reglas de ThingsBoard y, si son de una
severidad crítica, las manda a la app Cúmulo Monitoreo como mensaje de Firebase
"solo datos". Eso despierta el código nativo de la app aunque esté cerrada y
muestra la pantalla completa con sonido de alarma.

Endpoints:
  POST /critica  (interno, lo llama la cadena de reglas)  -> envía la alarma
  POST /accion   (público vía Caddy en /cumulo-alertas/accion) -> reconocer/resolver
  GET  /salud    (interno)                                -> estado del servicio

Los celulares se toman de las sesiones móviles que la propia app registra en
ThingsBoard al iniciar sesión (tabla user_settings, tipo MOBILE).
"""
import hashlib
import hmac
import json
import logging
import os
import threading
import time
import uuid

import psycopg2
import requests
from flask import Flask, jsonify, request
from google.auth.transport.requests import Request as GoogleRequest
from google.oauth2 import service_account

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
log = logging.getLogger("cumulo_alertas")

# ---------------------------------------------------------------------------
# Configuración (variables de entorno)
# ---------------------------------------------------------------------------
PG = dict(
    host=os.environ.get("PG_HOST", "postgres"),
    dbname=os.environ.get("PG_DB", "thingsboard"),
    user=os.environ.get("PG_USER", "postgres"),
    password=os.environ.get("PG_PASS", ""),
)
TB_URL = os.environ.get("TB_BASE_URL", "http://thingsboard-ce:8080")
TB_USER = os.environ.get("TB_USERNAME", "")
TB_PASS = os.environ.get("TB_PASSWORD", "")
CREDENCIALES = os.environ.get("FIREBASE_CREDENTIALS", "/run/secrets/firebase.json")
SECRETO = os.environ.get("ALERTAS_SECRET", "").encode()
URL_ACCION = os.environ.get(
    "PUBLIC_ACTION_URL", "https://monitoreo.cumuloingenieria.com.ar/cumulo-alertas/accion")
SEVERIDADES = {s.strip().upper() for s in os.environ.get("CRITICAL_SEVERITIES", "CRITICAL").split(",") if s.strip()}
VALIDEZ_HORAS = int(os.environ.get("FIRMA_VALIDEZ_HORAS", "72"))
CUSTOMER_NULO = "13814000-1dd2-11b2-8080-808080808080"  # cliente "vacío" de ThingsBoard

app = Flask(__name__)


# ---------------------------------------------------------------------------
# Utilidades
# ---------------------------------------------------------------------------
def _id(valor):
    """ThingsBoard manda los IDs como {"id": "...", "entityType": "..."} o como texto."""
    if isinstance(valor, dict):
        return valor.get("id")
    return valor


def firmar(alarm_id: str, accion: str, vence: str) -> str:
    msg = f"{alarm_id}|{accion}|{vence}".encode()
    return hmac.new(SECRETO, msg, hashlib.sha256).hexdigest()


def firma_valida(alarm_id: str, accion: str, vence: str, firma: str) -> bool:
    if not SECRETO or not firma:
        return False
    try:
        if int(vence) < time.time():
            return False
    except (TypeError, ValueError):
        return False
    return hmac.compare_digest(firmar(alarm_id, accion, vence), firma)


def db():
    return psycopg2.connect(connect_timeout=5, **PG)


def tokens_destinatarios(tenant_id: str, customer_id: str | None) -> list[str]:
    """Celulares de los administradores del tenant y de los usuarios del cliente dueño del equipo."""
    sql = """
        SELECT DISTINCT jsonb_object_keys(us.settings -> 'sessions') AS token
        FROM user_settings us
        JOIN tb_user u ON u.id = us.user_id
        WHERE us.type = 'MOBILE'
          AND jsonb_typeof(us.settings -> 'sessions') = 'object'
          AND u.tenant_id = %s
          AND (u.authority = 'TENANT_ADMIN'
               OR (u.authority = 'CUSTOMER_USER' AND u.customer_id = %s))
    """
    cliente = customer_id if customer_id and customer_id != CUSTOMER_NULO else None
    with db() as con, con.cursor() as cur:
        cur.execute(sql, (tenant_id, cliente))
        return [fila[0] for fila in cur.fetchall()]


def nombre_origen(originator_id: str | None) -> str | None:
    if not originator_id:
        return None
    with db() as con, con.cursor() as cur:
        for tabla in ("device", "asset"):
            cur.execute(f"SELECT name FROM {tabla} WHERE id = %s", (originator_id,))
            fila = cur.fetchone()
            if fila:
                return fila[0]
    return None


# ---------------------------------------------------------------------------
# Firebase
# ---------------------------------------------------------------------------
_fcm_lock = threading.Lock()
_fcm_cred = None


def fcm_credencial():
    global _fcm_cred
    with _fcm_lock:
        if _fcm_cred is None:
            _fcm_cred = service_account.Credentials.from_service_account_file(
                CREDENCIALES, scopes=["https://www.googleapis.com/auth/firebase.messaging"])
        if not _fcm_cred.valid:
            _fcm_cred.refresh(GoogleRequest())
        return _fcm_cred


def enviar_fcm(token: str, datos: dict) -> str:
    """Devuelve 'ok', 'invalido' o 'error'."""
    cred = fcm_credencial()
    url = f"https://fcm.googleapis.com/v1/projects/{cred.project_id}/messages:send"
    cuerpo = {"message": {
        "token": token,
        "android": {"priority": "high", "ttl": "3600s"},
        "data": {k: str(v) for k, v in datos.items()},
    }}
    r = requests.post(url, json=cuerpo, timeout=10,
                      headers={"Authorization": f"Bearer {cred.token}"})
    if r.status_code == 200:
        return "ok"
    if r.status_code in (400, 404) and ("UNREGISTERED" in r.text or "INVALID_ARGUMENT" in r.text):
        return "invalido"
    log.error("FCM %s: %s", r.status_code, r.text[:300])
    return "error"


# ---------------------------------------------------------------------------
# ThingsBoard (para reconocer / resolver)
# ---------------------------------------------------------------------------
_tb = {"token": None, "vence": 0.0}


def tb_token() -> str:
    if _tb["token"] and _tb["vence"] > time.time() + 60:
        return _tb["token"]
    r = requests.post(f"{TB_URL}/api/auth/login", json={"username": TB_USER, "password": TB_PASS}, timeout=10)
    r.raise_for_status()
    _tb["token"] = r.json()["token"]
    _tb["vence"] = time.time() + 50 * 60
    return _tb["token"]


def tb_estado_alarma(alarm_id: str) -> dict | None:
    r = requests.get(f"{TB_URL}/api/alarm/info/{alarm_id}",
                     headers={"X-Authorization": f"Bearer {tb_token()}"}, timeout=10)
    return r.json() if r.status_code == 200 else None


def tb_accion(alarm_id: str, accion: str) -> int:
    ruta = "ack" if accion == "ack" else "clear"
    url = f"{TB_URL}/api/alarm/{alarm_id}/{ruta}"
    r = requests.post(url, headers={"X-Authorization": f"Bearer {tb_token()}"}, timeout=10)
    if r.status_code == 401:
        _tb["token"] = None
        r = requests.post(url, headers={"X-Authorization": f"Bearer {tb_token()}"}, timeout=10)
    return r.status_code


# ---------------------------------------------------------------------------
# Endpoints
# ---------------------------------------------------------------------------
@app.post("/critica")
def critica():
    alarma = request.get_json(force=True, silent=True) or {}
    alarm_id = _id(alarma.get("id"))
    severidad = str(alarma.get("severity", "")).upper()
    estado = str(alarma.get("status", "ACTIVE_UNACK")).upper()
    if not alarm_id:
        return jsonify(ok=False, error="La alarma no tiene id"), 400
    if severidad not in SEVERIDADES:
        return jsonify(ok=True, ignorada=f"severidad {severidad}")
    if estado != "ACTIVE_UNACK":
        return jsonify(ok=True, ignorada=f"estado {estado}")

    tenant_id = _id(alarma.get("tenantId"))
    customer_id = _id(alarma.get("customerId"))
    dispositivo = alarma.get("originatorName") or nombre_origen(_id(alarma.get("originator"))) or "Dispositivo"
    tokens = tokens_destinatarios(tenant_id, customer_id)
    if not tokens:
        log.warning("Alarma %s: no hay celulares registrados para avisar", alarm_id)
        return jsonify(ok=True, enviados=0, total=0)

    vence = str(int(time.time()) + VALIDEZ_HORAS * 3600)
    datos = {
        "cumulo_critical": "1",
        "alarmId": alarm_id,
        "alarmType": alarma.get("type", "Alarma"),
        "severity": severidad,
        "deviceName": dispositivo,
        "createdTime": alarma.get("createdTime", int(time.time() * 1000)),
        "actionUrl": URL_ACCION,
        "exp": vence,
        "sigAck": firmar(alarm_id, "ack", vence),
        "sigClear": firmar(alarm_id, "clear", vence),
    }
    resultados = [enviar_fcm(t, datos) for t in tokens]
    enviados = resultados.count("ok")
    log.info("Alarma %s (%s, %s): enviada a %d de %d celulares (%d tokens vencidos)",
             alarm_id, severidad, dispositivo, enviados, len(tokens), resultados.count("invalido"))
    return jsonify(ok=True, enviados=enviados, total=len(tokens), vencidos=resultados.count("invalido"))


@app.post("/accion")
def accion():
    d = request.get_json(force=True, silent=True) or {}
    alarm_id, acc, vence, firma = d.get("alarmId"), d.get("accion"), str(d.get("exp", "")), d.get("sig", "")
    if acc not in ("ack", "clear") or not alarm_id:
        return jsonify(ok=False, error="Solicitud inválida"), 400
    if not firma_valida(alarm_id, acc, vence, firma):
        log.warning("Firma inválida o vencida para %s %s", acc, alarm_id)
        return jsonify(ok=False, error="Firma inválida o vencida"), 403
    try:
        uuid.UUID(str(alarm_id))
    except ValueError:
        return jsonify(ok=False, error="La alarma no existe en ThingsBoard"), 404
    try:
        codigo = tb_accion(alarm_id, acc)
    except Exception as e:  # noqa: BLE001
        log.error("Error llamando a ThingsBoard: %s", e)
        return jsonify(ok=False, error="ThingsBoard no respondió"), 502
    log.info("Acción %s sobre %s desde la app: ThingsBoard respondió %s", acc, alarm_id, codigo)
    if codigo == 200:
        return jsonify(ok=True)
    # ThingsBoard responde 400 si la alarma ya estaba reconocida/resuelta.
    # Se confirma consultando su estado real antes de informar éxito.
    if codigo == 400:
        info = tb_estado_alarma(alarm_id)
        if info and ((acc == "ack" and info.get("acknowledged")) or (acc == "clear" and info.get("cleared"))):
            return jsonify(ok=True, aviso="La alarma ya estaba en ese estado")
    if codigo == 404:
        return jsonify(ok=False, error="La alarma no existe en ThingsBoard"), 404
    return jsonify(ok=False, error=f"ThingsBoard respondió {codigo}"), 502


@app.get("/salud")
def salud():
    estado = {"severidades": sorted(SEVERIDADES), "secreto": bool(SECRETO)}
    try:
        with db() as con, con.cursor() as cur:
            cur.execute("SELECT count(*) FROM user_settings WHERE type = 'MOBILE'")
            estado["usuarios_con_app"] = cur.fetchone()[0]
        estado["base_de_datos"] = True
    except Exception as e:  # noqa: BLE001
        estado["base_de_datos"] = f"error: {e}"
    try:
        estado["firebase_proyecto"] = fcm_credencial().project_id
    except Exception as e:  # noqa: BLE001
        estado["firebase_proyecto"] = f"error: {e}"
    try:
        tb_token()
        estado["thingsboard"] = True
    except Exception as e:  # noqa: BLE001
        estado["thingsboard"] = f"error: {e}"
    estado["ok"] = all(v is True for k, v in estado.items() if k in ("base_de_datos", "thingsboard", "secreto")) \
        and not str(estado.get("firebase_proyecto", "")).startswith("error")
    return jsonify(estado)


if __name__ == "__main__":
    if not SECRETO:
        log.warning("ALERTAS_SECRET vacío: los botones Reconocer/Resolver no van a funcionar")
    log.info("Servicio de alarmas críticas. Severidades: %s", ", ".join(sorted(SEVERIDADES)))
    from waitress import serve
    serve(app, host="0.0.0.0", port=5556)
