#!/bin/bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

PACKAGE="tmux"
OS=$(getOS)
ARCH=$(getArch)
VERSION=$(getVersion "$PACKAGE")
RELEASE="https://github.com/nelsonenzo/tmux-appimage/releases/download/$VERSION/tmux.appimage"

info "Installing $PACKAGE..."

if [[ "$OS" == "darwin" ]]; then
  error "This script is not for macOS"
fi

if ! hasCommand "fusermount --version"; then
  error "fusermount is required to run $PACKAGE\nhttps://github.com/AppImage/AppImageKit/wiki/FUSE"
fi

AppImage="/tmp/tmux.appimage"

curl -sSL -o "$AppImage" "$RELEASE"
chmod u+x "$AppImage"
mv "$AppImage" "$DOTFILES_ROOT/bin/tmux"

success "Installed $PACKAGE $VERSION"
