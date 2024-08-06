#!/bin/bash
set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

OS=$(getOS)
if [[ "$OS" != "linux" ]]; then
    logErrorAndExit "This script is only for Linux"
fi

ARCH=$(getArch)

# install docker buildx plugin
logInfo "Installing docker buildx plugin..."

VERSION="v0.16.2"
RELEASE="https://github.com/docker/buildx/releases/download/$VERSION/buildx-$VERSION.$OS-$ARCH"

mkdir -p "$HOME/.docker/cli-plugins"
curl -sSL -o "$HOME/.docker/cli-plugins/docker-buildx" "$RELEASE"
chmod +x "$HOME/.docker/cli-plugins/docker-buildx"

logInfo "docker buildx plugin installed successfully"
