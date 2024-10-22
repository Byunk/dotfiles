#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

PACKAGE="docker buildx plugin"
OS=$(getOS)
ARCH=$(getArch)
VERSION=$(getVersion "$PACKAGE")
RELEASE="https://github.com/docker/buildx/releases/download/$VERSION/buildx-$VERSION.$OS-$ARCH"

info "Installing $PACKAGE..."

if [[ "$OS" == "darwin" ]]; then
    error "This script is not for macOS"
fi

mkdir -p "$HOME/.docker/cli-plugins"
curl -sSL -o "$HOME/.docker/cli-plugins/docker-buildx" "$RELEASE"
chmod +x "$HOME/.docker/cli-plugins/docker-buildx"

# create a builder instance
docker buildx create --name multiarch --driver docker-container --use || true

success "Installed $PACKAGE $VERSION"
