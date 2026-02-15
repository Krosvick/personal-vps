#!/bin/bash

# Ensure tailscale state directory exists
mkdir -p ./tailscale/state

# Start/Update containers
docker compose up -d --remove-orphans

# Enable Tailscale SSH
echo "Enabling Tailscale SSH..."
docker exec tailscale tailscale set --ssh

echo "Applying firewall rules..."
sudo ./scripts/setup-firewall.sh

echo "Deployment complete."
