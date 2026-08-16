
# Ollama Caddy Proxy

A Docker-based reverse proxy that forwards requests to an Ollama server using Caddy as the web server.

## Overview

This project provides a lightweight reverse proxy setup that:
- Uses Caddy 2 as the web server
- Forwards requests to an external Ollama instance
- Includes automatic model warming to keep the Ollama server responsive
- Configurable through environment variables for easy customization

## Features

- **Reverse Proxy**: Routes requests from local port to remote Ollama server
- **Automatic Warmup**: Keeps the Ollama model warm with periodic requests
- **Dockerized**: Easy deployment using Docker Compose
- **Configurable**: All settings can be adjusted via environment variables
- **Authentication**: Supports basic authentication for the Ollama server

## Requirements

- Docker
- Docker Compose

## Setup

1. Clone this repository and navigate to the project directory.

2. Create a `.env` file based on the example:
   ```bash
   cp .env.example .env
   ```

3. Edit the `.env` file with your specific configuration:
   ```env
   # Ollama Server Configuration
   OLLAMA_SERVER_URL=https://your-ollama-server.com
   OLLAMA_SERVER_PORT=443

   # Proxy Configuration
   PROXY_PORT=11434
   PROXY_HOST=127.0.0.1

   # Authentication
   OLLAMA_BASIC_AUTH=Bearer your-token-here

   # Warmup Settings
   WARMUP_INTERVAL=2
   WARMUP_MODEL=qwen3-coder:latest
   ```

4. Build and start the container:
   ```bash
   docker-compose up -d
   ```

5. The proxy will be available at `http://localhost:11434` (or your configured host/port)

## Configuration Options

| Variable | Default | Description |
|----------|---------|-------------|
| `OLLAMA_SERVER_URL` | - | URL of the Ollama server to proxy requests to (required) |
| `OLLAMA_SERVER_PORT` | `443` | Port of the Ollama server |
| `PROXY_PORT` | `11434` | Local port to expose the proxy |
| `PROXY_HOST` | `127.0.0.1` | Host to bind the proxy to |
| `OLLAMA_BASIC_AUTH` | - | Authentication token for the Ollama server (required) |
| `WARMUP_INTERVAL` | `2` | Minutes between warmup requests |
| `WARMUP_MODEL` | `qwen3-coder:latest` | Model to use for warmup requests |

## Usage

Once running, you can interact with the proxy using standard Ollama API calls:

```shell
bash curl [http://localhost:11434/api/generate](http://localhost:11434/api/generate)
-H "Content-Type: application/json"
-d '{"model":"qwen3-coder:latest","prompt":"Hello","stream":false}'
```

## License

This project is licensed under the MIT License.
