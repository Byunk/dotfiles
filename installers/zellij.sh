#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "$SCRIPT_DIR/common.sh"

UPGRADE="${UPGRADE:-false}"

PACKAGE="zellij"
OS=$(getos)
ARCH=$(getarch)
if [[ "$ARCH" == "arm64" ]]; then
  ARCH="aarch64"
elif [[ "$ARCH" == "amd64" ]]; then
  ARCH="x86_64"
fi

VERSION="$(get_latest_release zellij-org/zellij)"

info "Installing $PACKAGE $VERSION"

if checkcmd "$PACKAGE" && [ "$UPGRADE" = false ]; then
  success "$PACKAGE is already installed"
  exit 0
fi

if [[ "$OS" == "darwin" ]]; then
  brew install "$PACKAGE"
else
  RELEASE_URL="https://github.com/zellij-org/zellij/releases/download/${VERSION}/zellij-${ARCH}-unknown-linux-musl.tar.gz"
  ARCHIVE="/tmp/$PACKAGE.tar.gz"

  info "Downloading $PACKAGE from $RELEASE_URL"
  if ! curl -sSL -o "$ARCHIVE" "$RELEASE_URL"; then
    error "Failed to download $PACKAGE"
  fi

  info "Extracting $PACKAGE"
  if ! tar -C /tmp -xvf "$ARCHIVE"; then
    rm -f "$ARCHIVE"
    error "Failed to extract $PACKAGE"
  fi

  TARGET_DIR="$HOME/.local/bin"
  mkdir -p "$TARGET_DIR"
  mv "/tmp/$PACKAGE" "$TARGET_DIR/$PACKAGE"
  rm -f "$ARCHIVE"
fi

success "Successfully installed $PACKAGE $VERSION"
