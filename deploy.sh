#!/bin/bash

# Ensure tailscale state directory exists
mkdir -p ./tailscale/state

# Start/Update containers
docker compose up -d --remove-orphans

# Disable Tailscale SSH (Balanced Approach: Use Standard SSH)
echo "Ensuring Tailscale SSH is disabled..."
docker exec tailscale tailscale set --ssh=false

echo "Applying firewall rules..."
sudo ./scripts/setup-firewall.sh

echo "Deployment complete."
