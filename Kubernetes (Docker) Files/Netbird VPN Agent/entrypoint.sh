#!/bin/bash
set -e

NETBIRD_TIMEOUT="${NETBIRD_TIMEOUT:-60}"
HORDE_USER="horde-docker"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

if [ -z "$NB_SETUP_KEY" ]; then
    log "ERROR: NB_SETUP_KEY environment variable is required"
    sleep 100
    exit 1
fi

log "Starting NetBird daemon..."
netbird service install 2>/dev/null || true
netbird service start
netbird up --setup-key "$NB_SETUP_KEY" --rosenpass-permissive

log "Waiting for NetBird connection..."
elapsed=0
while [ $elapsed -lt $NETBIRD_TIMEOUT ]; do
  if netbird status 2>/dev/null | grep -q "Management: Connected"; then
    if netbird status 2>/dev/null | grep -q "Signal: Connected"; then
      if ! netbird status 2>/dev/null | grep -q "NetBird IP: N/A"; then
        break
      fi
    fi
  fi
  sleep 2
  elapsed=$((elapsed + 2))
  log "Waiting for Netbird... (${elapsed}s)"
done

if [ $elapsed -ge $NETBIRD_TIMEOUT ]; then
  log "ERROR: NetBird failed to connect within ${NETBIRD_TIMEOUT} seconds"
  netbird status || true
  sleep 100
  exit 1
fi

log "NetBird connected, extracting IP address for Horde..."
NETBIRD_IP=""

NETBIRD_IP=$(netbird status --json 2>/dev/null | jq -r '.netbirdIp // empty' | cut -d'/' -f1)

if [ -z "$NETBIRD_IP" ]; then
  log "ERROR: Could not determine NetBird IP address"
  netbird status || true
  sleep 100
  exit 1
fi

log "Netbird connected with IP: $NETBIRD_IP"

export Horde__ComputeIp="$NETBIRD_IP"

log "Environment configured:"
log "  Horde__ComputeIp=$Horde__ComputeIp"

mkdir -p /home/horde-docker/.wine
chown -R horde-docker:horde-docker /home/horde-docker/.wine
export WINEPREFIX=/home/horde-docker/.wine
export WINEARCH=win64

log "Starting Horde Agent"

cd Agent
exec sudo -E -u $HORDE_USER dotnet HordeAgent.dll