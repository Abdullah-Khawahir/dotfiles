#!/bin/bash
# Arch Cloudflare Tunnel Setup Script (Robust)
# Usage: bash start-tunnels.sh

set -e

TUNNEL_NAME="mytunnel"
CONFIG_DIR="$HOME/.cloudflared"
CONFIG_FILE="$CONFIG_DIR/config.yml"

# Step 1: Install cloudflared
echo "Installing cloudflared..."
sudo pacman -Sy --needed cloudflared

# Step 2: Login to Cloudflare if no cert.pem
if [ ! -f "$CONFIG_DIR/cert.pem" ]; then
    echo "Logging into Cloudflare..."
    cloudflared login
else
    echo "Existing cert.pem found. Skipping login."
fi

# Step 3: Check if tunnel exists, create if not
if cloudflared tunnel list | grep -q "$TUNNEL_NAME"; then
    echo "Tunnel '$TUNNEL_NAME' already exists."
else
    echo "Creating tunnel '$TUNNEL_NAME'..."
    cloudflared tunnel create "$TUNNEL_NAME"
fi

# Step 4: Detect credentials file
CRED_FILE=$(find "$CONFIG_DIR" -type f -name "*.json" | head -n1)
if [ -z "$CRED_FILE" ]; then
    echo "No credentials file found. Please create the tunnel manually."
    exit 1
else
    echo "Found credentials file: $CRED_FILE"
fi

# Step 5: Extract Tunnel ID from credentials file
TUNNEL_ID=$(jq -r '.TunnelID' "$CRED_FILE")
if [ -z "$TUNNEL_ID" ]; then
    echo "Could not read Tunnel ID from $CRED_FILE"
    exit 1
fi

# Step 7: Create static config.yml if it doesn't exist
mkdir -p "$CONFIG_DIR"
if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" <<EOF
tunnel: $TUNNEL_ID
credentials-file: $CRED_FILE
ingress:
  - hostname: n8n.abdullah-khwahir.me
    service: http://localhost:5678
  - service: http_status:404
EOF
    echo "Created config.yml at $CONFIG_FILE"
else
    echo "Config file already exists at $CONFIG_FILE. Edit manually if needed."
fi

# Step 8: Setup symlink /etc/cloudflared → ~/.cloudflared
echo "Setting up symlink /etc/cloudflared → $CONFIG_DIR"
sudo rm -rf /etc/cloudflared
sudo ln -s "$CONFIG_DIR" /etc/cloudflared

# Step 9: Stop any running cloudflared service
sudo systemctl stop cloudflared || true

# Step 10: Run tunnel once in debug mode to verify
echo "Starting tunnel in debug mode..."
cloudflared tunnel --loglevel debug run "$TUNNEL_NAME" &

# Step 11: Install systemd service (only if debug run succeeds)
sleep 5
sudo cloudflared service uninstall || true
sudo cloudflared service install

# Step 12: Enable and start systemd service
sudo systemctl enable --now cloudflared
sudo systemctl status cloudflared --no-pager

echo "Cloudflare tunnel setup complete!"
echo "Edit $CONFIG_FILE to change hostname, port, or tunnel name."
