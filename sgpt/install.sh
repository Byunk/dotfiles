#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

PACKAGE="shell-gpt"
VERSION=$(getVersion "$PACKAGE")

info "Installing $PACKAGE..."

pip install -U "$PACKAGE"

success "Installed $PACKAGE"