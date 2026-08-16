#!/bin/sh
set -eu

# Cronjob every 10 minutes to keep the model warm
echo "*/2 * * * * /warmup.sh >/proc/1/fd/1 2>/proc/1/fd/2" > /etc/crontabs/root
crond -f -l 8 -L /dev/stdout &
CRON_PID="$!"

# One warmup shortly after startup
(sleep 3; /warmup.sh) &

# Start Caddy in foreground
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
CADDY_PID="$!"

trap 'kill "$CRON_PID" "$CADDY_PID" 2>/dev/null || true; wait' INT TERM

wait "$CADDY_PID"