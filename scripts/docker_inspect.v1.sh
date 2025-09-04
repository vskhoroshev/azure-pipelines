#!/usr/bin/env bash

set -euo pipefail
shopt -s nocasematch

: "${DOCKER_REGISTRY_SERVER:?'variable must be set'}"
: "${DOCKER_REPOSITORY_NAME:?'variable must be set'}"
: "${DOCKER_SOURCE_TAG:?'variable must be set'}"

SCRIPTS_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPTS_ROOT_DIR}/lib/docker.sh"

docker_tags="${DOCKER_TAGS:-${DOCKER_SOURCE_TAG}}"

while IFS= read -r -d '' tag; do
  if [[ "${tag}" =~ [^[:space:]] ]]; then
    docker::command inspect "${DOCKER_INSPECT_OPTIONS:-} ${DOCKER_REGISTRY_SERVER}/${DOCKER_REPOSITORY_NAME}:${tag}"
  fi
done < <(xargs printf '%s\0' <<< "${docker_tags}" | tr ',' '\0')
