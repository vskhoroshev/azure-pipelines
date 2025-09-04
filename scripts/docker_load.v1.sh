#!/usr/bin/env bash

set -euo pipefail
shopt -s nocasematch

: "${DOCKER_ARCHIVE_FILE:?'variable must be set'}"

SCRIPTS_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPTS_ROOT_DIR}/lib/docker.sh"

docker::command image load -i "${DOCKER_ARCHIVE_FILE}" "${DOCKER_LOAD_OPTIONS:-}"
