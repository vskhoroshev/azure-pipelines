#!/usr/bin/env bash

set -euo pipefail
shopt -s nocasematch

: "${VARIABLE_FILES:?'variable must be set'}"

while IFS= read -r -d '' file; do
  [[ "${file}" =~ [^[:space:]] ]] || continue

  if [[ ! -f "${file}" ]]; then
    echo "##[error]File '${file}' does not exist"
    exit 1
  fi

  echo; echo "##[command]Loading variables from '${file}'"

  while IFS='=' read -r key value || [[ -n "${key}" ]]; do
    if [[ -n "${key}" && ! "${key}" =~ ^[[:space:]]*# ]]; then
      echo "${key}=${value}"
      echo "##vso[task.setvariable variable=${key}]${value}"
    fi
  done < "${file}"
done < <(xargs printf '%s\0' <<< "${VARIABLE_FILES}" | tr ',' '\0')
