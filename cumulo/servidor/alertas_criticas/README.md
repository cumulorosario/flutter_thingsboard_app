# Servicio de alarmas críticas (`cumulo_alertas`)

ThingsBoard manda sus notificaciones como "notificación visible": con la app
cerrada, Android las muestra solo y el código de la app no se ejecuta. Para la
alarma crítica (pantalla completa + sirena hasta que alguien atiende) hace falta
un mensaje de **solo datos**, que siempre despierta el código nativo de la app.
Este servicio lo envía.

```
Alarma CRÍTICA ─► cadena de reglas ─► cumulo_alertas ─► Firebase ─► App (pantalla completa)
                                           ▲
App: Reconocer/Resolver ─► https://monitoreo.../cumulo-alertas/accion (firma HMAC)
```

- **Destinatarios:** administradores del tenant y usuarios del cliente dueño del
  equipo, con la app Cúmulo instalada y la sesión iniciada.
- **Severidades:** `CRITICAL` por defecto (variable `CRITICAL_SEVERITIES`).
- **Reconocer/Resolver** desde la notificación o la pantalla completa funciona
  sin sesión: cada mensaje lleva una firma válida 72 h solo para esa alarma.
  En el registro de auditoría de ThingsBoard la acción figura a nombre del
  usuario configurado en `TB_USERNAME`.

## Instalación en el VPS

En el servidor, dentro de `~/thingsboard`:

1. Copiar esta carpeta como `cumulo_alertas/` y la clave privada de Firebase
   (la misma que se cargó en ThingsBoard) como `cumulo_alertas/firebase.json`.
   El servicio corre sin privilegios, así que el archivo tiene que ser legible:
   `chmod 644 cumulo_alertas/firebase.json` (la carpeta `/root` ya es privada).
2. Agregar el secreto de las firmas al `.env`:
   ```bash
   echo "ALERTAS_SECRET=$(openssl rand -hex 32)" >> .env
   ```
3. Crear `docker-compose.alertas.yml` (ver abajo) y sumarlo a los archivos que
   usa Docker Compose:
   ```bash
   echo "COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.alertas.yml" >> .env
   ```
4. Publicar solo la ruta de acciones en Caddy (ver `Caddyfile` abajo).
5. `docker compose up -d --build cumulo_alertas caddy`
6. En la cadena de reglas: nodo **REST API Call** con URL
   `http://cumulo_alertas:5556/critica`, método POST, conectado a la salida
   *Created* de las alarmas (igual que el nodo del webhook de Vigia).
7. En el Centro de notificaciones, sacar la severidad **Crítica** de la regla
   de notificación normal, para no recibir dos avisos por la misma alarma.

### `docker-compose.alertas.yml`

```yaml
services:
  cumulo_alertas:
    build: ./cumulo_alertas
    restart: always
    environment:
      PG_PASS: ${PG_PASS}
      TB_BASE_URL: http://thingsboard-ce:8080
      TB_USERNAME: tenant@thingsboard.org
      TB_PASSWORD: ${TB_PASS}
      ALERTAS_SECRET: ${ALERTAS_SECRET}
      CRITICAL_SEVERITIES: CRITICAL
      PUBLIC_ACTION_URL: https://monitoreo.cumuloingenieria.com.ar/cumulo-alertas/accion
    volumes:
      - ./cumulo_alertas/firebase.json:/run/secrets/firebase.json:ro
    logging:
      driver: json-file
      options: { max-size: "20m", max-file: "3" }
    depends_on:
      - postgres
      - thingsboard-ce
```

### `Caddyfile`

```
monitoreo.cumuloingenieria.com.ar {
    handle /cumulo-alertas/accion {
        rewrite * /accion
        reverse_proxy cumulo_alertas:5556
    }
    handle {
        reverse_proxy thingsboard-ce:8080
    }
}
```

## Verificar

```bash
docker run --rm --network thingsboard_default curlimages/curl -s http://cumulo_alertas:5556/salud
```

Tiene que responder `"ok": true`, con el proyecto de Firebase y la cantidad de
usuarios que tienen la app con sesión iniciada.
