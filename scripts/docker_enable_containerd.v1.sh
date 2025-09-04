#!/usr/bin/env bash

set -euo pipefail
shopt -s nocasematch

SCRIPTS_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPTS_ROOT_DIR}/lib/docker.sh"

# See also:
# https://docs.docker.com/engine/storage/containerd/

# Add the following configuration to your /etc/docker/daemon.json configuration file.
echo; echo "##[command]Adding configuration to '/etc/docker/daemon.json'"
echo '{ "features": { "containerd-snapshotter": true } }' | sudo tee -a /etc/docker/daemon.json

# Restart the daemon for the changes to take effect.
echo; echo "##[command]Restarting Docker..."
sudo systemctl restart docker

# After restarting the daemon, running docker info shows that you're using containerd snapshotter storage drivers.
docker::command info -f "'{{ .DriverStatus }}'"
