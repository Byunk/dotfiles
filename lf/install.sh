#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

PACKAGE="lf"
OS=$(getOS)
ARCH=$(getArch)
VERSION=$(getVersion "$PACKAGE")
RELEASE="https://github.com/gokcehan/lf/releases/download/$VERSION/lf-$OS-$ARCH.tar.gz"

info "Installing $PACKAGE..."

if [[ "$OS" != "linux" ]]; then
    error "This script is only for Linux"
fi

ARCHIVE="/tmp/lf.tar.gz"

curl -sSL -o "$ARCHIVE" "$RELEASE"
tar -C /tmp -xvzf "$ARCHIVE"
mv /tmp/lf "$DOTFILES_ROOT/bin/lf"
rm "$ARCHIVE"

success "Installed $PACKAGE $VERSION"