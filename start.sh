
#!/bin/sh
set -eu

# Validate required environment variables
if [ -z "${OLLAMA_SERVER_URL:-}" ]; then
    echo "Error: OLLAMA_SERVER_URL is not set" >&2
    exit 1
fi

# Set default values if not provided
: "${OLLAMA_SERVER_PORT:=443}"
: "${PROXY_PORT:=11434}"
: "${WARMUP_INTERVAL:=2}"
: "${WARMUP_MODEL:=qwen3-coder:latest}"

# Update Caddyfile with dynamic values
# Extract hostname from URL for Caddy configuration
HOSTNAME=$(echo ${OLLAMA_SERVER_URL} | sed 's|https://||' | sed 's|http://||')
sed -i "s|ai.solyton.org|${HOSTNAME}|" /etc/caddy/Caddyfile

# Update warmup.sh with dynamic model
sed -i "s|qwen3-coder:latest|${WARMUP_MODEL}|" /warmup.sh

# Cronjob for warmup
echo "*/${WARMUP_INTERVAL} * * * * /warmup.sh >/proc/1/fd/1 2>/proc/1/fd/2" > /etc/crontabs/root
crond -f -l 8 -L /dev/stdout &
CRON_PID="$!"

# One warmup shortly after startup
(sleep 3; /warmup.sh) &

# Start Caddy in foreground
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
CADDY_PID="$!"

trap 'kill "$CRON_PID" "$CADDY_PID" 2>/dev/null || true; wait' INT TERM

wait "$CADDY_PID"