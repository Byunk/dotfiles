#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

PACKAGE="helm"
OS=$(getOS)
ARCH=$(getArch)
VERSION=$(getVersion "$PACKAGE")
RELEASE="https://get.helm.sh/helm-$VERSION-$OS-$ARCH.tar.gz"

info "Installing $PACKAGE..."

ARCHIVE="/tmp/helm.tar.gz"

curl -fsSL -o "$ARCHIVE" "$RELEASE"
tar -C /tmp -xvzf "$ARCHIVE"
mv "/tmp/$OS-$ARCH/helm" "$DOTFILES_ROOT/bin/helm"
rm "$ARCHIVE"
rm -rf "/tmp/$OS-$ARCH"

success "Installed $PACKAGE $VERSION"
