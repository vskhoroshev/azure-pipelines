#!/usr/bin/env bash

set -euo pipefail
shopt -s nocasematch

SCRIPTS_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPTS_ROOT_DIR}/lib/docker.sh"

# See also:
# https://docs.docker.com/build/building/multi-platform/#install-qemu-manually

# Use the tonistiigi/binfmt image to install QEMU and register the executable types on the host.
docker::command run --privileged --rm tonistiigi/binfmt --install all
