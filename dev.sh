#!/usr/bin/env bash
# Start Hugo dev server + Cloudflare Tunnel for dev.cbarabbitry.com
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v cloudflared &>/dev/null; then
  echo "ERROR: cloudflared is not installed."
  echo "Install it from: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/"
  exit 1
fi

# Validate tunnel credentials exist
TUNNEL_ID=$(grep '^tunnel:' "$SCRIPT_DIR/.cloudflared/config.yml" | awk '{print $2}')
CREDS_FILE="$HOME/.cloudflared/$TUNNEL_ID.json"
if [ -z "$TUNNEL_ID" ]; then
  echo "ERROR: Could not read tunnel ID from .cloudflared/config.yml"
  exit 1
fi
if [ ! -f "$CREDS_FILE" ]; then
  echo "ERROR: Tunnel credentials not found: $CREDS_FILE"
  echo "Run: cloudflared tunnel login"
  exit 1
fi

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
cloudflared tunnel --config "$SCRIPT_DIR/.cloudflared/config.yml" run

# If cloudflared exits, kill Hugo too
kill $HUGO_PID 2>/dev/null
