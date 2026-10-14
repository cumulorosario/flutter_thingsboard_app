#!/usr/bin/env python3
"""
Aplica la personalización de Cúmulo Ingeniería sobre el código original de
ThingsBoard (flutter_thingsboard_app), sin que esos cambios queden guardados
en los archivos originales del repositorio.

Uso (desde la raíz del proyecto, antes de compilar):

    python3 cumulo/scripts/aplicar.py

Qué hace:
  1. Copia logos, ícono y splash de cumulo/branding/ sobre assets/.
  2. Cambia la paleta de colores del tema.
  3. Ajusta tamaños del logo y el nombre de la app.
  4. Agrega el idioma español (cumulo/l10n/intl_es.arb) y lo fija por defecto.

Cada reemplazo verifica que el texto original exista. Si una versión nueva de
ThingsBoard cambió ese código, el script se detiene y dice exactamente qué
reemplazo falló, en vez de compilar una app a medio personalizar.
"""
import json
import re
import shutil
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]
CUMULO = RAIZ / "cumulo"

APP = "Cúmulo Monitoreo"
LOGO = "Logo Cúmulo Ingeniería"

errores = []


def leer(rel):
    return (RAIZ / rel).read_text(encoding="utf-8")


def escribir(rel, texto):
    (RAIZ / rel).write_text(texto, encoding="utf-8")


def reemplazar(rel, viejo, nuevo, regex=False, descripcion=""):
    """Reemplaza 'viejo' por 'nuevo' en el archivo; si no lo encuentra, lo anota como error."""
    texto = leer(rel)
    if regex:
        texto, n = re.subn(viejo, nuevo, texto)
    else:
        n = texto.count(viejo)
        texto = texto.replace(viejo, nuevo)
    if n == 0:
        errores.append(f"{rel}: no se encontró {descripcion or viejo[:80]!r}")
    else:
        escribir(rel, texto)


# ---------------------------------------------------------------------------
# 1. Marca: logos, ícono y splash
# ---------------------------------------------------------------------------
def aplicar_marca():
    for origen in (CUMULO / "branding" / "images").iterdir():
        destino = RAIZ / "assets" / "images" / origen.name
        if not destino.exists():
            errores.append(f"assets/images/{origen.name} ya no existe en esta versión")
            continue
        shutil.copyfile(origen, destino)
    for origen in (CUMULO / "branding" / "launcher").iterdir():
        destino = RAIZ / "assets" / "branding" / origen.name
        if not destino.exists():
            errores.append(f"assets/branding/{origen.name} ya no existe en esta versión")
            continue
        shutil.copyfile(origen, destino)
    # Error del archivo original: color con doble numeral
    reemplazar("flutter_native_splash.yaml", 'color: "##ffffff"', 'color: "#ffffff"')


# ---------------------------------------------------------------------------
# 2. Colores del tema
#    #3F6EA6 azul Cúmulo oscurecido (botones, contraste 5.3:1 con blanco)
#    #6F99CA azul del logo (acentos)
#    #1E3552 azul marino (títulos y barra superior)
# ---------------------------------------------------------------------------
ESCALA = {
    50: "0xFFECF0F6", 100: "0xFFD5DFEB", 200: "0xFFB2C5DB", 300: "0xFF90ABCB",
    400: "0xFF698EBA", 600: "0xFF376192", 700: "0xFF2F527C", 800: "0xFF274467",
    900: "0xFF1E3550",
}


def aplicar_colores():
    rel = "lib/config/themes/tb_theme.dart"
    reemplazar(rel, r"_tbPrimaryColorValue = 0x[0-9A-Fa-f]{8};",
               "_tbPrimaryColorValue = 0xFF3F6EA6;", regex=True,
               descripcion="_tbPrimaryColorValue")
    reemplazar(rel, r"_tbSecondaryColor = Color\(0x[0-9A-Fa-f]{8}\);",
               "_tbSecondaryColor = Color(0xFF6F99CA);", regex=True,
               descripcion="_tbSecondaryColor")
    reemplazar(rel, r"_tbDarkPrimaryColor = Color\(0x[0-9A-Fa-f]{8}\);",
               "_tbDarkPrimaryColor = Color(0xFF8FB3DC);", regex=True,
               descripcion="_tbDarkPrimaryColor")
    reemplazar(rel, r"_tbTextColorValue = 0x[0-9A-Fa-f]{8};",
               "_tbTextColorValue = 0xFF1E3552;", regex=True,
               descripcion="_tbTextColorValue")
    # Escala de tonos (las entradas 500/600 que usan constantes se dejan como están)
    texto = leer(rel)
    for tono, valor in ESCALA.items():
        texto = re.sub(rf"(\n\s*{tono}: )Color\(0x[0-9A-Fa-f]{{8}}\)", rf"\g<1>Color({valor})", texto)
    # En la escala clara, el tono 600 debe ser más oscuro que el 500
    texto = texto.replace("600: _tbSecondaryColor,", "600: Color(0xFF376192),", 1)
    # Acento: el naranja de ThingsBoard pasa al azul del logo
    texto = texto.replace("Colors.deepOrange", "const Color(0xFF6F99CA)")
    texto = texto.replace("scaffoldBackgroundColor: const Color(0xFFFAFAFA)",
                          "scaffoldBackgroundColor: const Color(0xFFF5F7FA)")
    escribir(rel, texto)


# ---------------------------------------------------------------------------
# 3. Logo más grande (el de Cúmulo es menos apaisado) y nombre de la app
# ---------------------------------------------------------------------------
def aplicar_textos_y_logo():
    reemplazar("lib/core/auth/login/login_page.dart",
               r"(ThingsboardImage\.thingsBoardWithTitle,\s*\n\s*height: )25,",
               r"\g<1>44,", regex=True, descripcion="alto del logo en el login")
    reemplazar("lib/core/auth/login/login_page.dart",
               "const SizedBox(height: 25),", "const SizedBox(height: 44),")
    reemplazar("lib/modules/dashboard/presentation/widgets/dashboards_appbar.dart",
               r"height: 24,(\s*\n\s*child: SvgPicture\.asset\(\s*\n\s*ThingsboardImage\.thingsBoardWithTitle,)",
               r"height: 32,\1", regex=True, descripcion="alto del logo en la barra")
    reemplazar("lib/modules/dashboard/presentation/widgets/dashboards_appbar.dart",
               "semanticsLabel: 'ThingsBoard Logo'", f"semanticsLabel: '{LOGO}'")
    reemplazar("lib/modules/more/more_page.dart",
               "Text('version: $ver')", "Text('versión: $ver')")
    # Nombre de la app en los idiomas que trae ThingsBoard
    for arb in sorted((RAIZ / "lib" / "l10n").glob("intl_*.arb")):
        rel = arb.relative_to(RAIZ).as_posix()
        reemplazar(rel, r'"appTitle":\s*"[^"]*"', f'"appTitle": "{APP}"', regex=True,
                   descripcion="appTitle")
    reemplazar("lib/generated/intl/messages_en.dart",
               r'"appTitle": MessageLookupByLibrary\.simpleMessage\("[^"]*"\)',
               f'"appTitle": MessageLookupByLibrary.simpleMessage("{APP}")',
               regex=True, descripcion="appTitle generado")
    reemplazar("lib/generated/l10n.dart",
               r"Intl\.message\('[^']*', name: 'appTitle'",
               f"Intl.message('{APP}', name: 'appTitle'", regex=True,
               descripcion="appTitle en l10n.dart")


# ---------------------------------------------------------------------------
# 4. Español: genera messages_es.dart a partir de cumulo/l10n/intl_es.arb
# ---------------------------------------------------------------------------
def _cadena_dart(s):
    return s.replace("\\", "\\\\").replace("'", "\\'").replace("\n", "\\n")


def _icu_a_dart(msg, comillas='"'):
    """Convierte un mensaje ICU (placeholders y plural) a una expresión de texto Dart."""
    salida, i = [], 0
    while i < len(msg):
        c = msg[i]
        if c == "{":
            # buscar la llave de cierre correspondiente
            prof, j = 0, i
            while j < len(msg):
                if msg[j] == "{":
                    prof += 1
                elif msg[j] == "}":
                    prof -= 1
                    if prof == 0:
                        break
                j += 1
            interior = msg[i + 1:j]
            m = re.match(r"\s*(\w+)\s*,\s*plural\s*,(.*)$", interior, re.S)
            if m:
                var, cuerpo = m.group(1), m.group(2)
                formas = dict(re.findall(r"(=1|one|other)\s*(\{(?:[^{}]|\{[^{}]*\})*\})", cuerpo))
                uno = formas.get("=1") or formas.get("one")
                otro = formas["other"]
                f = lambda t: "'" + _icu_a_dart(t[1:-1], "'") + "'"
                salida.append("${Intl.plural(" + var + ", one: " + f(uno) + ", other: " + f(otro) + ")}")
            else:
                salida.append("${" + interior.strip() + "}")
            i = j + 1
            continue
        if c == "\\":
            salida.append("\\\\")
        elif c == comillas:
            salida.append("\\" + c)
        elif c == "$":
            salida.append("\\$")
        elif c == "\n":
            salida.append("\\n")
        else:
            salida.append(c)
        i += 1
    return "".join(salida)


def aplicar_espanol():
    es = json.loads((CUMULO / "l10n" / "intl_es.arb").read_text(encoding="utf-8"))
    en_dart = leer("lib/generated/intl/messages_en.dart")

    # Funciones con parámetros en el archivo inglés: nombre -> parámetros
    funciones = dict(re.findall(r"static String (m\d+)\(([^)]*)\)", en_dart))
    cuerpo = en_dart[en_dart.index("<String, Function>{") + len("<String, Function>{"):en_dart.rindex("};")]
    claves = re.findall(r'^\s*"(\w+)":\s*(m\d+|MessageLookupByLibrary)', cuerpo, re.M)

    faltan = [k for k, _ in claves if k not in es]
    if faltan:
        print(f"AVISO: {len(faltan)} textos nuevos sin traducir (quedan en inglés): {', '.join(faltan)}")
        en_arb = json.loads(leer("lib/l10n/intl_en.arb"))
        for k in faltan:
            es[k] = en_arb.get(k, k)
    es["appTitle"] = APP

    funcs_es, entradas = [], []
    for clave, tipo in claves:
        if tipo == "MessageLookupByLibrary":
            entradas.append(f'    "{clave}": MessageLookupByLibrary.simpleMessage("{_icu_a_dart(es[clave])}"),')
        else:
            funcs_es.append(f"  static String {tipo}({funciones[tipo]}) =>\n      \"{_icu_a_dart(es[clave])}\";\n")
            entradas.append(f'    "{clave}": {tipo},')

    cabecera = en_dart[:en_dart.index("class MessageLookup")].replace("for a en locale", "for a es locale")
    salida = (cabecera
              + "class MessageLookup extends MessageLookupByLibrary {\n  String get localeName => 'es';\n\n"
              + "\n".join(funcs_es)
              + "\n  final messages = _notInlinedMessages(_notInlinedMessages);\n"
              + "  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{\n"
              + "\n".join(entradas) + "\n  };\n}\n")
    escribir("lib/generated/intl/messages_es.dart", salida)
    shutil.copyfile(CUMULO / "l10n" / "intl_es.arb", RAIZ / "lib" / "l10n" / "intl_es.arb")

    # Registrar el idioma
    rel = "lib/generated/intl/messages_all.dart"
    reemplazar(rel, "import 'messages_en.dart' as messages_en;\n",
               "import 'messages_en.dart' as messages_en;\nimport 'messages_es.dart' as messages_es;\n")
    reemplazar(rel, "  'en': () => new SynchronousFuture(null),\n",
               "  'en': () => new SynchronousFuture(null),\n  'es': () => new SynchronousFuture(null),\n")
    reemplazar(rel, "    case 'en':\n      return messages_en.messages;\n",
               "    case 'en':\n      return messages_en.messages;\n    case 'es':\n      return messages_es.messages;\n")
    reemplazar("lib/generated/l10n.dart",
               "      Locale.fromSubtags(languageCode: 'en'),\n",
               "      Locale.fromSubtags(languageCode: 'en'),\n      Locale.fromSubtags(languageCode: 'es'),\n")
    # La app siempre en español, sin importar el idioma del teléfono
    reemplazar("lib/thingsboard_app.dart",
               "supportedLocales: S.delegate.supportedLocales,\n",
               "supportedLocales: S.delegate.supportedLocales,\n        locale: const Locale('es'),\n")


if __name__ == "__main__":
    if (RAIZ / "lib" / "generated" / "intl" / "messages_es.dart").exists():
        sys.exit("La personalización ya está aplicada. Para volver a aplicarla, primero "
                 "restaurá los originales con: git checkout -- assets lib flutter_native_splash.yaml "
                 "&& git clean -f lib")
    aplicar_marca()
    aplicar_colores()
    aplicar_textos_y_logo()
    aplicar_espanol()
    if errores:
        print("\nNo se pudo aplicar la personalización completa. Revisar con esta versión de ThingsBoard:")
        for e in errores:
            print("  -", e)
        sys.exit(1)
    print("Personalización Cúmulo aplicada.")
