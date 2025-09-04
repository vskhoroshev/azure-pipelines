#!/usr/bin/env bash

set -euo pipefail
shopt -s nocasematch

SCRIPTS_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPTS_ROOT_DIR}/lib/terraform.sh"

terraform::command init -input=false "${TERRAFORM_INIT_OPTIONS:-}"
