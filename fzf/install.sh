#!/bin/bash
set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

VERSION="0.54.2"

logInfo "Installing fzf..."

OS=$(getOS)
if [[ "$OS" != "linux" ]]; then
	logErrorAndExit "This script is only for Linux"
fi

ARCH=$(getgetArch_arch)

RELEASE=""https://github.com/junegunn/fzf/releases/download/v$VERSION/fzf-$VERSION-${OS}_${ARCH}.tar.gz""

curl -sSL -o /tmp/fzf.tar.gz "$RELEASE"
tar -C /tmp -xvzf /tmp/fzf.tar.gz
mv /tmp/fzf "$(dirname "$(dirname "$0")")/bin/fzf"
rm /tmp/fzf.tar.gz

logInfo "fzf installed successfully"
