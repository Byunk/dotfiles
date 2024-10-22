#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

PACKAGE="yq"
OS=$(getOS)
ARCH=$(getArch)
VERSION=$(getVersion "$PACKAGE")
RELEASE="https://github.com/mikefarah/yq/releases/download/${VERSION}/yq_${OS}_${ARCH}.tar.gz"

info "Installing $PACKAGE..."

ARCHIVE="/tmp/yq.tar.gz"

curl -sSL -o "$ARCHIVE" "$RELEASE"
tar -C /tmp -xvzf "$ARCHIVE"
mv "/tmp/yq_${OS}_${ARCH}" "$DOTFILES_ROOT/bin/yq"
rm "$ARCHIVE"

success "Installed $PACKAGE $VERSION"
