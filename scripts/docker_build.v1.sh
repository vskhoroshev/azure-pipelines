#!/usr/bin/env bash

set -euo pipefail
shopt -s nocasematch

: "${DOCKER_REGISTRY_SERVER:?'variable must be set'}"
: "${DOCKER_REPOSITORY_NAME:?'variable must be set'}"
: "${DOCKER_BUILD_FILE:?'variable must be set'}"
: "${DOCKER_SOURCE_TAG:?'variable must be set'}"
: "${DOCKER_PLATFORMS:?'variable must be set'}"

SCRIPTS_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPTS_ROOT_DIR}/lib/docker.sh"

declare -a docker_labels=()

if [[ -n "${DOCKER_LABELS:-}" ]]; then
  while IFS= read -r -d '' label; do
    [[ "${label}" =~ [^[:space:]] ]] && docker_labels+=(--label "${label}")
  done < <(xargs printf '%s\0' <<< "${DOCKER_LABELS}" | tr ',' '\0')
fi

docker::command buildx build \
  -f "${DOCKER_BUILD_FILE}" \
  -t "${DOCKER_REGISTRY_SERVER}/${DOCKER_REPOSITORY_NAME}:${DOCKER_SOURCE_TAG}" \
  --platform "${DOCKER_PLATFORMS}" \
  "${docker_labels[@]:+${docker_labels[@]}}" \
  "${DOCKER_BUILD_OPTIONS:-} '${DOCKER_BUILD_CONTEXT:-.}'"
