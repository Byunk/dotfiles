#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

PACKAGE="pyenv"

info "Installing $PACKAGE..."

curl https://pyenv.run | bash

success "Installed $PACKAGE"
