# Personalización Cúmulo Ingeniería

Esta rama (`cumulo`) es la app oficial de ThingsBoard **sin modificar**, más esta
carpeta. Todo lo propio de Cúmulo vive acá y se aplica recién al compilar:

| Archivo | Qué contiene |
|---|---|
| `configs.json` | Servidor (`https://monitoreo.cumuloingenieria.com.ar`), nombre y paquete de la app |
| `branding/images/` | Logo completo, símbolo y piezas del indicador de carga |
| `branding/launcher/` | Ícono de la app y pantallas de inicio (splash) |
| `l10n/intl_es.arb` | Traducción al español |
| `scripts/aplicar.py` | Copia la marca, cambia colores, agrega el español |

El workflow `.github/workflows/build-android.yml` corre `aplicar.py` antes de
compilar, en cada cambio que se sube a esta rama.

## Compilar en la PC

```bash
python3 cumulo/scripts/aplicar.py
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
flutter build apk --release --dart-define-from-file=cumulo/configs.json
```

`aplicar.py` modifica archivos del proyecto: no los subas con commit. Para
volver a los originales:

```bash
git checkout -- assets lib flutter_native_splash.yaml && git clean -f lib
```

## Actualizar a una versión nueva de ThingsBoard

1. Verificar en https://thingsboard.io/docs/mobile/compatibility/ qué versión de
   la app corresponde a la versión del servidor.
2. Traer esa versión del repositorio oficial y mezclarla en esta rama:
   ```bash
   git remote add upstream https://github.com/thingsboard/flutter_thingsboard_app.git
   git fetch upstream
   git merge upstream/release/1.8.1      # la versión que corresponda
   ```
   Como los archivos originales no tienen cambios, no debería haber conflictos.
3. Si cambió la versión de Flutter (archivo `.fvmrc`), actualizarla en el workflow.
4. Subir la rama. Si `aplicar.py` falla, indica exactamente qué reemplazo no
   encontró; hay que ajustar solo esa línea del script.
5. Si la versión nueva agregó textos, el script avisa cuáles quedan en inglés:
   agregarlos a `l10n/intl_es.arb`.
