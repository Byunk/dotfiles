#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

VERSION="v0.40.0"

info "Installing nvm..."

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$VERSION/install.sh | bash

info "nvm installed successfully"
