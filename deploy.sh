#!/bin/bash

# Ensure tailscale state directory exists
mkdir -p ./tailscale/state

# Start/Update containers
docker compose up -d --remove-orphans

echo "Deployment complete."
