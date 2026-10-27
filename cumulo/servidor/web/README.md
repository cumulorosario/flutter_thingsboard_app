# Marca Cúmulo en la web de ThingsBoard

ThingsBoard Community Edition no trae personalización de marca (eso es de la
edición paga). Acá la aplica **Caddy**, que ya está delante de ThingsBoard:

| Qué | Cómo |
|---|---|
| Logo de la barra y del inicio de sesión | Caddy sirve `archivos/logo_title_white.svg` en lugar de `/assets/logo_title_white.svg` |
| Ícono de la pestaña | `archivos/favicon.ico` en lugar de `/thingsboard.ico` |
| Título "Cúmulo Monitoreo" | Reemplazo en el HTML + `archivos/cumulo.js` (ThingsBoard cambia el título en cada página) |
| Colores de la app | Reemplazo de los colores de ThingsBoard en sus CSS/JS: `#305680`→`#3F6EA6`, `#527DAD`→`#6F99CA`, `#A7C1DE`→`#B2C5DB` |
| Detalles visuales | `archivos/cumulo.css` |

Los archivos de ThingsBoard no se modifican: al actualizar ThingsBoard la marca
se sigue aplicando. Para los reemplazos se usa una imagen de Caddy con el
módulo [replace-response](https://github.com/caddyserver/replace-response)
(ver `Dockerfile`). El workflow `probar-web.yml` la construye y la prueba en
GitHub cada vez que cambia esta carpeta.

## Instalación en el VPS

```bash
cd ~/thingsboard
R=https://raw.githubusercontent.com/cumulorosario/flutter_thingsboard_app/cumulo/cumulo/servidor/web
mkdir -p cumulo_web/archivos
for f in Dockerfile Caddyfile docker-compose.web.yml; do curl -fsSL $R/$f -o cumulo_web/$f; done
for f in cumulo.css cumulo.js favicon.ico logo_title_white.svg; do curl -fsSL $R/archivos/$f -o cumulo_web/archivos/$f; done
cp Caddyfile Caddyfile.antes-web
cp cumulo_web/Caddyfile Caddyfile
mv cumulo_web/docker-compose.web.yml .
sed -i 's/^COMPOSE_FILE=.*/&:docker-compose.web.yml/' .env
docker compose up -d --build caddy
docker compose logs --tail 20 caddy
```

El navegador guarda los estilos viejos: después de instalar, recargar con
**Ctrl + F5**.

## Volver atrás

```bash
cd ~/thingsboard
cp Caddyfile.antes-web Caddyfile
sed -i 's/:docker-compose.web.yml//' .env
docker compose up -d caddy
```

## Si ThingsBoard cambia sus colores

En una versión nueva los colores originales podrían ser otros. Se ven en
`ui-ngx/src/scss/constants.scss` del repositorio de ThingsBoard
(`$tb-primary-color`, `$tb-secondary-color`, `$tb-hue3-color`) y se actualizan
en el bloque `@estilos` del `Caddyfile`.
