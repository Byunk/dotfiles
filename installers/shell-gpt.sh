#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "$SCRIPT_DIR/common.sh"

UPGRADE="${UPGRADE:-false}"

PACKAGE="shell-gpt"

info "Installing $PACKAGE"

if checkcmd "$PACKAGE" && [ "$UPGRADE" = false ]; then
  success "$PACKAGE is already installed"
  exit 0
fi

if ! checkcmd "pip3"; then
  error "pip3 is not installed. Please install pip3 and try again."
fi

pip3 install -U "$PACKAGE"

success "Successfully installed $PACKAGE $VERSION"
