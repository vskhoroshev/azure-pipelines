#!/usr/bin/env bash

set -euo pipefail
shopt -s nocasematch

: "${DOCKER_REGISTRY_SERVER:?'variable must be set'}"
: "${DOCKER_REGISTRY_NAME:?'variable must be set'}"
: "${DOCKER_REPOSITORY_NAME:?'variable must be set'}"
: "${DOCKER_SOURCE_TAG:?'variable must be set'}"

SCRIPTS_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPTS_ROOT_DIR}/lib/az.sh"
source "${SCRIPTS_ROOT_DIR}/lib/docker.sh"

az::command acr login -n "${DOCKER_REGISTRY_NAME}" "${DOCKER_LOGIN_OPTIONS:-}"

docker_tags="${DOCKER_TAGS:-${DOCKER_SOURCE_TAG}}"

while IFS= read -r -d '' tag; do
  if [[ "${tag}" =~ [^[:space:]] ]]; then
    docker::command image push "${DOCKER_PUSH_OPTIONS:-} ${DOCKER_REGISTRY_SERVER}/${DOCKER_REPOSITORY_NAME}:${tag}"
  fi
done < <(xargs printf '%s\0' <<< "${docker_tags}" | tr ',' '\0')
