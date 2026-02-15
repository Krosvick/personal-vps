# HomeOS Infrastructure (Tailscale Edition)

This repository contains the Docker-based infrastructure for a personal HomeOS running on an ARM Oracle VM (Ubuntu), connected securely via Tailscale.

## Components
- **Tailscale**: Secure private networking (WireGuard). No public ports needed.
- **Home Assistant**: Smart home hub (running in `host` network mode).
- **Watchtower**: Automated updates for all containers *except* Home Assistant.
- **UFW Config**: Hardened firewall script tailored for Tailscale.

## Automated Deployment (GitHub Actions)

### 1. Setup GitHub Secrets
Go to your repo **Settings > Secrets and Variables > Actions** and add:
- `SSH_HOST`: Your Oracle VM Public IP.
- `SSH_USER`: `ubuntu`.
- `SSH_PRIVATE_KEY`: Your SSH private key.
- **`TS_OAUTH_ID`**: Tailscale OAuth Client ID.
- **`TS_OAUTH_SECRET`**: Tailscale OAuth Client Secret.
- `TZ`: Your timezone (e.g., `Europe/Madrid`).

### 2. Generate Tailscale OAuth Client
1. Go to [Tailscale OAuth Settings](https://login.tailscale.com/admin/settings/oauth).
2. Generate a client with `devices:write` scope.
3. (Optional) Assign a tag like `tag:server`.

### 3. Initial Server Setup
On your Oracle VM, run these once:
```bash
# Clone the repo
git clone <your-repo-url> ~/infra-homeos
cd ~/infra-homeos

# Setup Firewall
sudo chmod +x scripts/setup-firewall.sh
sudo ./scripts/setup-firewall.sh
```

## Important: Disable Key Expiry
By default, Tailscale nodes require re-authentication every 180 days. To make this permanent:
1. Go to the [Tailscale Admin Console](https://login.tailscale.com/admin/machines).
2. Find `homeos-vps`.
3. Click the three dots (...) and select **Disable Key Expiry**.

## Reaching Your Home Network
1. Install Tailscale on a device at home.
2. Run: `sudo tailscale up --advertise-routes=192.168.1.0/24`.
3. Approve the routes in the Tailscale Admin Console.

## Management
- **Logs**: `docker compose logs -f`
- **HA Config**: Found in `./homeassistant/`.
