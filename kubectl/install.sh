#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

PACKAGE="kubectl"
OS=$(getOS)
ARCH=$(getArch)
VERSION=$(getVersion "$PACKAGE")
RELEASE="https://dl.k8s.io/release/$VERSION/bin/$OS/$ARCH/kubectl"

info "Installing $PACKAGE..."

TEMP_BINARY="/tmp/kubectl"

curl -sSL -o "$TEMP_BINARY" "$RELEASE"
chmod u+x "$TEMP_BINARY"
mv "$TEMP_BINARY" "$DOTFILES_ROOT/bin/kubectl"

success "Installed $PACKAGE $VERSION"