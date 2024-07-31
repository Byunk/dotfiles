#!/bin/bash

set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

VERSION="3.3a"
RELEASE="https://github.com/nelsonenzo/tmux-appimage/releases/download/$VERSION/tmux.appimage"

logInfo "Installing tmux..."

OS=$(getOS)
if [[ "$OS" != "linux" ]]; then
	logErrorAndExit "This script is only for Linux"
fi

if ! hasCommand "fusermount"; then
	logErrorAndExit "fusermount is required to run Neovim\nhttps://github.com/AppImage/AppImageKit/wiki/FUSE"
fi

curl -sSL -o /tmp/tmux.appimage "$RELEASE"
chmod u+x /tmp/tmux.appimage
mv /tmp/tmux.appimage "$(dirname "$(dirname "$0")")/bin/tmux"

logInfo "tmux installed successfully"
