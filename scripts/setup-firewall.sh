#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Applying Balanced Firewall for HomeOS..."

# Reset UFW to a clean state
ufw --force reset

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH Publicly (Required for GitHub Actions and easy management)
ufw allow 22/tcp comment 'SSH Public'

# Allow Tailscale traffic
# Tailscale uses UDP 41641 for direct connections (WireGuard)
ufw allow 41641/udp comment 'Tailscale Direct'

# Allow all traffic from the Tailscale interface (tailscale0)
# This allows your private devices to talk to HA
ufw allow in on tailscale0 comment 'Allow Tailscale internal'

# Local Network Discovery (mDNS and SSDP)
# Restricted to LAN only (adjust subnet if your LAN is not 192.168.1.x)
ufw allow from 192.168.1.0/24 to any port 5353 proto udp comment 'mDNS LAN only'
ufw allow from 192.168.1.0/24 to any port 1900 proto udp comment 'SSDP LAN only'

# Enable Firewall
echo "y" | ufw enable

ufw status verbose

echo "--------------------------------------------------------"
echo "Balanced Firewall applied."
echo "OPEN: Port 22 (SSH)"
echo "PRIVATE: 8123 (HA), 5353, 1900 (Tailscale/LAN only)"
echo "--------------------------------------------------------"
