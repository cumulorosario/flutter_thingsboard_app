# Caddy con el módulo replace-response, para aplicar la marca Cúmulo a la web
# de ThingsBoard sin modificar ThingsBoard.
FROM caddy:2.10-builder AS builder
RUN xcaddy build --with github.com/caddyserver/replace-response

FROM caddy:2.10
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
