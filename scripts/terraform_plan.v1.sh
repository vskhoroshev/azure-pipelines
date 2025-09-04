#!/usr/bin/env bash

set -euo pipefail
shopt -s nocasematch

SCRIPTS_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPTS_ROOT_DIR}/lib/terraform.sh"

terraform_output=""

if [[ -n "${TERRAFORM_PLAN_FILE:-}" ]]; then
  mkdir -p "$(dirname "${TERRAFORM_PLAN_FILE}")"
  terraform_output="-out=${TERRAFORM_PLAN_FILE}"
fi

terraform::command plan -input=false "${terraform_output}" "${TERRAFORM_PLAN_OPTIONS:-}"
