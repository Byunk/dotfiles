#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

PACKAGE="neovim"
OS=$(getOS)
ARCH=$(getArch)
VERSION=$(getVersion "$PACKAGE")
RELEASE="https://github.com/neovim/neovim/releases/download/$VERSION/nvim.appimage"

info "Installing $PACKAGE..."

if [[ "$OS" == "darwin" ]]; then
	error "This script is not for macOS"
fi

check_glibc_version() {
    local required_version="2.31"
    local current_version=$(getconf "GNU_LIBC_VERSION" | awk '{print $NF}')
    if ! compareVersion "$current_version" "$required_version"; then
        error "Neovim requires glibc version $required_version or later"
    fi
}

check_fusermount() {
	if ! hasCommand "fusermount"; then
		error "fusermount is required to run Neovim\nhttps://github.com/AppImage/AppImageKit/wiki/FUSE"
	fi
}

check_glibc_version
check_fusermount

AppImage="/tmp/nvim.appimage"
curl -sSL -o "$AppImage" "$RELEASE"
chmod u+x "$AppImage"
mv "$AppImage" "$DOTFILES_ROOT/bin/nvim"

success "Installed $PACKAGE $VERSION"