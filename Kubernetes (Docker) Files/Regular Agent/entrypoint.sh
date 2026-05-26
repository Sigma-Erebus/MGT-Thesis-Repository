#!/bin/bash
set -e

HORDE_USER="horde-docker"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

PODNUMBER=$(echo $POD_NAME | grep -o '[0-9]*$')
COMPUTE_PORT=$((30013 + PODNUMBER))

export Horde__ComputePort=$COMPUTE_PORT

log "Environment configured:"
log "  Horde__ComputePort=$Horde__ComputePort"

mkdir -p /home/horde-docker/.wine
chown -R horde-docker:horde-docker /home/horde-docker/.wine
export WINEPREFIX=/home/horde-docker/.wine
export WINEARCH=win64

log "Starting Horde Agent"

cd Agent
exec sudo -E -u $HORDE_USER dotnet HordeAgent.dll