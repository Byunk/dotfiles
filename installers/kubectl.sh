#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "$SCRIPT_DIR/common.sh"

UPGRADE="${UPGRADE:-false}"

PACKAGE="kubectl"
OS=$(getos)
ARCH=$(getarch)
VERSION="$(curl -L -s https://dl.k8s.io/release/stable.txt)"

info "Installing $PACKAGE $VERSION"

if checkcmd "$PACKAGE" && [ "$UPGRADE" = false ]; then
  success "$PACKAGE is already installed"
  exit 0
fi

RELEASE_URL="https://dl.k8s.io/release/$VERSION/bin/$OS/$ARCH/kubectl"
TMP_BIN="/tmp/$PACKAGE"

info "Downloading $PACKAGE from $RELEASE_URL"
if ! curl -sSL -o "$ARCHIVE" "$RELEASE_URL"; then
  error "Failed to download $PACKAGE"
fi

chmod u+x "$TMP_BIN"

TARGET_DIR="$HOME/.local/bin"
mkdir -p "$TARGET_DIR"
mv "$TMP_BIN" "$TARGET_DIR/$PACKAGE"

success "Successfully installed $PACKAGE $VERSION"
