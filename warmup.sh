#!/bin/sh
set -eu

curl -s http://127.0.0.1:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{"model":"qwen3-coder:latest","prompt":"ping","stream":false}' >/dev/null || true