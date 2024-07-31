#!/bin/bash
set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

VERSION="v0.10.1"
RELEASE="https://github.com/neovim/neovim/releases/download/$VERSION/nvim.appimage"

getGlibcVersion() {
	getconf "GNU_LIBC_VERSION" | awk '{print $NF}'
}

install() {
	curl -sSL -o /tmp/nvim.appimage "$RELEASE"
	chmod u+x /tmp/nvim.appimage
	mv /tmp/nvim.appimage "$(dirname "$(dirname "$0")")/bin/nvim"
}

logInfo "Installing Neovim..."

OS=$(getOS)
if [[ "$OS" != "linux" ]]; then
	logErrorAndExit "This script is only for Linux"
fi

GNU_LIBC_VERSION=$(getGlibcVersion)
if ! compareVersion "$GNU_LIBC_VERSION" "2.31"; then
	logErrorAndExit "Neovim requires glibc version 2.31 or later"
fi
if ! hasCommand "fusermount"; then
	logErrorAndExit "fusermount is required to run Neovim\nhttps://github.com/AppImage/AppImageKit/wiki/FUSE"
fi
install

logInfo "Neovim installed successfully"
