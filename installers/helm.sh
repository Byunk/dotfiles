#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "$SCRIPT_DIR/common.sh"

UPGRADE="${UPGRADE:-false}"

PACKAGE="helm"
OS=$(getos)
ARCH=$(getarch)
VERSION="$(get_latest_release helm/helm)"

info "Installing $PACKAGE $VERSION"

if checkcmd "$PACKAGE" && [ "$UPGRADE" = false ]; then
  success "$PACKAGE is already installed"
  exit 0
fi

RELEASE_URL="https://get.helm.sh/helm-$VERSION-$OS-$ARCH.tar.gz"
ARCHIVE="/tmp/$PACKAGE.tar.gz"

info "Downloading $PACKAGE from $RELEASE_URL"
if ! curl -sSL -o "$ARCHIVE" "$RELEASE_URL"; then
  error "Failed to download $PACKAGE"
fi

info "Extracting $PACKAGE"
if ! tar -C /tmp -xvzf "$ARCHIVE"; then
  rm -f "$ARCHIVE"
  error "Failed to extract $PACKAGE"
fi

TARGET_DIR="$HOME/.local/bin"
mkdir -p "$TARGET_DIR"
mv "/tmp/$OS-$ARCH/$PACKAGE" "$TARGET_DIR/$PACKAGE"
rm -f "$ARCHIVE"
rm -rf "/tmp/$OS-$ARCH"

success "Successfully installed $PACKAGE $VERSION"
