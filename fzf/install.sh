#!/bin/bash
set -e

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

source "${DOTFILES_ROOT}/scripts/common.sh"

PACKAGE="fzf"
VERSION="0.52.1"

if is.linux && is.amd; then
	OS="linux_amd64"
	RELEASE="fzf-$VERSION-$OS.tar.gz"
	URI="https://github.com/junegunn/fzf/releases/download/$VERSION/$RELEASE"
	curl -LO $URI
	mkdir -p "$DOTFILES_ROOT/bin" && tar -xzvf "$RELEASE" -C "$DOTFILES_ROOT/bin"
fi
