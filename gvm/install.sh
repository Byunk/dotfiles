#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

PACKAGE="gvm"

info "Installing $PACKAGE..."

bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

success "Installed $PACKAGE"
