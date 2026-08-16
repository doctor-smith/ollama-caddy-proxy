FROM caddy:2

USER root

RUN apk add --no-cache curl busybox-suid

COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /start.sh
COPY warmup.sh /warmup.sh

RUN chmod +x /start.sh /warmup.sh

ENTRYPOINT ["/start.sh"]