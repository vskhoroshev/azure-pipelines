#!/usr/bin/env bash

docker::command() {
  local -a command=("$(command -v docker)")
  local -a extra_args=()
  local string_args=""

  (( $# > 1 )) && extra_args=("${@:1:$#-1}")
  (( $# > 0 )) && string_args="${!#}"

  for arg in "${extra_args[@]}"; do
    [[ "${arg}" =~ [^[:space:]] ]] && command+=("${arg}")
  done

  if [[ -n "${string_args}" ]]; then
    while IFS= read -r -d '' arg; do
      [[ "${arg}" =~ [^[:space:]] ]] && command+=("${arg}")
    done < <(xargs printf '%s\0' <<< "${string_args}")
  fi

  echo; echo "##[command]${command[*]}"
  "${command[@]}"
}
