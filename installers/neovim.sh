#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "$SCRIPT_DIR/common.sh"

UPGRADE="${UPGRADE:-false}"

PACKAGE="neovim"
OS=$(getos)
VERSION="$(get_latest_release neovim/neovim)"

info "Installing $PACKAGE $VERSION"

if checkcmd "$PACKAGE" && [ "$UPGRADE" = false ]; then
  success "$PACKAGE is already installed"
  exit 0
fi

if [[ "$OS" == "darwin" ]]; then
  brew install neovim
else
  # Check glibc version. It should be >= 2.31
  CURRENT_GLIBC_VERSION=$(getconf "GNU_LIBC_VERSION" | awk '{print $NF}')
  if [[ $(vercomp "2.31" "$CURRENT_GLIBC_VERSION") -lt 0 ]]; then
    error "glibc version is $CURRENT_GLIBC_VERSION, should be >= 2.31"
  fi

  # Check fusermount
  if ! checkcmd "fusermount"; then
    error "fusermount is not installed"
  fi

  RELEASE_URL="https://github.com/neovim/neovim/releases/download/$VERSION/nvim.appimage"
  APPIMAGE="/tmp/nvim.appimage"

  info "Downloading $PACKAGE from $RELEASE_URL"
  if ! curl -sSL -o "$APPIMAGE" "$RELEASE_URL"; then
    error "Failed to download $PACKAGE"
  fi

  chmod u+x "$APPIMAGE"

  TARGET_DIR="$HOME/.local/bin"
  mkdir -p "$TARGET_DIR"
  mv "$APPIMAGE" "$TARGET_DIR/$PACKAGE"
fi

success "Successfully installed $PACKAGE $VERSION"
