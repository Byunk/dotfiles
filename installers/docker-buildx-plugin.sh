#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "$SCRIPT_DIR/common.sh"

UPGRADE="${UPGRADE:-false}"

PACKAGE="docker buildx plugin"
OS=$(getos)
ARCH=$(getarch)
VERSION="v0.16.2"

info "Installing $PACKAGE $VERSION"

if checkcmd "$PACKAGE" && [ "$UPGRADE" = false ]; then
  success "$PACKAGE is already installed"
  exit 0
fi

if ! checkcmd "docker"; then
  error "docker is not installed"
fi

if [[ "$OS" == "darwin" ]]; then
  success "macOS does not need to install $PACKAGE"
  exit 0
fi

RELEASE_URL="https://github.com/docker/buildx/releases/download/$VERSION/buildx-$VERSION.$OS-$ARCH"
INSTALL_PATH="$HOME/.docker/cli-plugins"
mkdir -p "$INSTALL_PATH"

info "Downloading $PACKAGE from $RELEASE_URL"
if ! curl -sSL -o "$INSTALL_PATH/docker-buildx" "$RELEASE_URL"; then
  error "Failed to download $PACKAGE"
fi

chmod +x "$INSTALL_PATH/docker-buildx"

info "Creating a builder instance"
if ! docker buildx create --name multiarch --driver docker-container --use; then
  error "Failed to create a builder instance"
fi

success "Successfully installed $PACKAGE $VERSION"
