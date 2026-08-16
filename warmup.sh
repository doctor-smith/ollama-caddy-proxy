
#!/bin/sh
set -eu

# Validate required environment variables
if [ -z "${OLLAMA_SERVER_URL:-}" ]; then
    echo "Error: OLLAMA_SERVER_URL is not set" >&2
    exit 1
fi

# Set default value if not provided
: "${WARMUP_MODEL:=qwen3-coder:latest}"

curl -s http://127.0.0.1:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{"model":"'"${WARMUP_MODEL}"'","prompt":"ping","stream":false}' >/dev/null || true