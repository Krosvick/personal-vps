#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Configuring UFW for HomeOS (Tailscale Mode)..."

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (Important!)
ufw allow 22/tcp comment 'SSH'

# Allow Tailscale traffic
# Tailscale uses UDP 41641 for direct connections (WireGuard)
ufw allow 41641/udp comment 'Tailscale Direct'

# Allow all traffic from the Tailscale interface (tailscale0)
# This allows your private devices to talk to HA
ufw allow in on tailscale0 comment 'Allow Tailscale internal'

# Home Assistant (mDNS and Discovery)
# Still needed for local network discovery if you bridge to home
ufw allow 8123/tcp comment 'Home Assistant Web UI'
ufw allow 5353/udp comment 'mDNS'
ufw allow 1900/udp comment 'SSDP'

# Enable Firewall
echo "y" | ufw enable

ufw status verbose

echo "--------------------------------------------------------"
echo "Tailscale setup complete. No public 80/443 ports needed."
echo "You can now reach Home Assistant via your Tailscale IP."
echo "--------------------------------------------------------"
