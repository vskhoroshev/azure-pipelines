#!/usr/bin/env bash

set -euo pipefail
shopt -s nocasematch

: "${DOCKER_REGISTRY_SERVER:?'variable must be set'}"
: "${DOCKER_REPOSITORY_NAME:?'variable must be set'}"
: "${DOCKER_SOURCE_TAG:?'variable must be set'}"
: "${DOCKER_TAGS:?'variable must be set'}"

SCRIPTS_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPTS_ROOT_DIR}/lib/docker.sh"

while IFS= read -r -d '' tag; do
  if [[ "${tag}" =~ [^[:space:]] ]]; then
    docker::command image tag \
      "${DOCKER_REGISTRY_SERVER}/${DOCKER_REPOSITORY_NAME}:${DOCKER_SOURCE_TAG}" \
      "${DOCKER_REGISTRY_SERVER}/${DOCKER_REPOSITORY_NAME}:${tag}"
  fi
done < <(xargs printf '%s\0' <<< "${DOCKER_TAGS}" | tr ',' '\0')
