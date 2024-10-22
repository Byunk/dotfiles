#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

PACKAGE="fzf"
OS=$(getOS)
ARCH=$(getArch)
VERSION=$(getVersion "$PACKAGE")
RELEASE="https://github.com/junegunn/fzf/releases/download/v$VERSION/fzf-$VERSION-${OS}_${ARCH}.tar.gz"

info "Installing $PACKAGE..."

if [[ "$OS" == "darwin" ]]; then
	error "This script is not for macOS"
fi

ARCHIVE="/tmp/fzf.tar.gz"

curl -sSL -o "$ARCHIVE" "$RELEASE"
tar -C /tmp -xvzf "$ARCHIVE"
mv /tmp/fzf "$DOTFILES_ROOT/bin/fzf"
rm "$ARCHIVE"

success "Installed $PACKAGE $VERSION"
