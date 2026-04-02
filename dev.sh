#!/usr/bin/env bash
# Start Hugo dev server + Cloudflare Tunnel for dev.cbarabbitry.com
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v cloudflared &>/dev/null; then
  echo "ERROR: cloudflared is not installed."
  echo "Install it from: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/"
  exit 1
fi

# Auto-discover tunnel credentials from ~/.cloudflared/*.json
CREDS_FILE=$(ls "$HOME/.cloudflared/"*.json 2>/dev/null | head -1)
if [ -z "$CREDS_FILE" ]; then
  echo "ERROR: No tunnel credentials found in ~/.cloudflared/"
  echo "Run: cloudflared tunnel login"
  exit 1
fi
TUNNEL_ID=$(python3 -c "import json,sys; print(json.load(open('$CREDS_FILE'))['TunnelID'])" 2>/dev/null)
if [ -z "$TUNNEL_ID" ]; then
  echo "ERROR: Could not read TunnelID from $CREDS_FILE"
  exit 1
fi
echo "Using tunnel: $TUNNEL_ID"

# Build a temp config with the discovered tunnel ID
TMP_CONFIG=$(mktemp /tmp/cloudflared-config-XXXXXX.yml)
trap 'rm -f "$TMP_CONFIG"' EXIT
{ echo "tunnel: $TUNNEL_ID"; cat "$SCRIPT_DIR/.cloudflared/config.yml"; } > "$TMP_CONFIG"

# Kill any existing Hugo server
if pgrep -x hugo > /dev/null 2>&1; then
  echo "Killing existing Hugo server..."
  pkill -x hugo > /dev/null 2>&1 || true
  sleep 1
fi

# Start Hugo in the background
echo "Starting Hugo dev server on http://localhost:1313 ..."
hugo server --baseURL "https://dev.cbarabbitry.com" --appendPort=false &
HUGO_PID=$!

# Give Hugo a moment to start
sleep 1

# Start Cloudflare Tunnel
echo "Starting Cloudflare Tunnel -> dev.cbarabbitry.com ..."
cloudflared tunnel --config "$TMP_CONFIG" run

# If cloudflared exits, kill Hugo too
kill $HUGO_PID 2>/dev/null
