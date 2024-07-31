#!/bin/bash
set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

VERSION="r32"

logInfo "Installing lf..."

OS=$(getOS)
if [[ "$OS" != "linux" ]]; then
    logErrorAndExit "This script is only for Linux"
fi

ARCH=$(getArch)

RELEASE="https://github.com/gokcehan/lf/releases/download/$VERSION/lf-$OS-$ARCH.tar.gz"

curl -sSL -o /tmp/lf.tar.gz "$RELEASE"
tar -C /tmp -xvzf /tmp/lf.tar.gz
mv /tmp/lf "$(dirname "$(dirname "$0")")/bin/lf"
rm /tmp/lf.tar.gz

logInfo "lf installed successfully"
