#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "$SCRIPT_DIR/common.sh"

UPGRADE="${UPGRADE:-false}"

PACKAGE="gvm"

info "Installing $PACKAGE"

if checkcmd "$PACKAGE" && [ "$UPGRADE" = false ]; then
  success "$PACKAGE is already installed"
  exit 0
fi

bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

success "Successfully installed $PACKAGE $VERSION"
