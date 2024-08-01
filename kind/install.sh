#!/bin/bash
set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

VERSION="v0.23.0"

logInfo "Installing kind..."

OS=$(getOS)
ARCH=$(getArch)
RELEASE="https://kind.sigs.k8s.io/dl/v0.23.0/kind-$OS-$ARCH"

curl -sSL -o /tmp/kind "$RELEASE"
chmod +x /tmp/kind
mv /tmp/kind "$(dirname "$(dirname "$0")")/bin/kind"

logInfo "kind installed successfully"
