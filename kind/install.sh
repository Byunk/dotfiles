#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

PACKAGE="kind"
OS=$(getOS)
ARCH=$(getArch)
VERSION=$(getVersion "$PACKAGE")
RELEASE="https://kind.sigs.k8s.io/dl/v$VERSION/kind-$OS-$ARCH"

info "Installing $PACKAGE..."

TEMP_KIND_BINARY="/tmp/kind"

curl -sSL -o "$TEMP_KIND_BINARY" "$RELEASE"
chmod +x "$TEMP_KIND_BINARY"
mv "$TEMP_KIND_BINARY" "$DOTFILES_ROOT/bin/kind"

success "Installed $PACKAGE $VERSION"
