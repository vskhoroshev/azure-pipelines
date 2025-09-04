#!/usr/bin/env bash

set -euo pipefail
shopt -s nocasematch

: "${DOCKER_REGISTRY_SERVER:?'variable must be set'}"
: "${DOCKER_REPOSITORY_NAME:?'variable must be set'}"
: "${DOCKER_SOURCE_TAG:?'variable must be set'}"
: "${DOCKER_ARCHIVE_FILE:?'variable must be set'}"

SCRIPTS_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPTS_ROOT_DIR}/lib/docker.sh"

declare -a docker_images=()
docker_tags="${DOCKER_TAGS:-${DOCKER_SOURCE_TAG}}"

while IFS= read -r -d '' tag; do
  if [[ "${tag}" =~ [^[:space:]] ]]; then
    docker_images+=("${DOCKER_REGISTRY_SERVER}/${DOCKER_REPOSITORY_NAME}:${tag}")
  fi
done < <(xargs printf '%s\0' <<< "${docker_tags}" | tr ',' '\0')

mkdir -p "$(dirname "${DOCKER_ARCHIVE_FILE}")"

docker::command image save -o "${DOCKER_ARCHIVE_FILE}" "${DOCKER_SAVE_OPTIONS:-} ${docker_images[*]}"
