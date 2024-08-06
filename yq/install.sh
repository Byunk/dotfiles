#!/bin/bash
set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

VERSION="v4.44.3"

logInfo "Installing yq ..."

OS=$(getOS)
ARCH=$(getArch)

BINARY="yq_${OS}_${ARCH}"
RELEASE="https://github.com/mikefarah/yq/releases/download/${VERSION}/$BINARY.tar.gz"

curl -sSL -o /tmp/yq.tar.gz "$RELEASE"
tar -C /tmp -xvzf /tmp/yq.tar.gz
mv "/tmp/$BINARY" "$(dirname "$(dirname "$0")")/bin/yq"
rm /tmp/yq.tar.gz

logInfo "yq installed successfully"
