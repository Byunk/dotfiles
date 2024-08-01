#!/bin/bash
set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

logInfo "Installing kubectl..."

OS=$(getOS)
ARCH=$(getArch)
RELEASE="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/$OS/$ARCH/kubectl"

curl -sSL -o /tmp/kubectl "$RELEASE"
chmod u+x /tmp/kubectl
mv /tmp/kubectl "$(dirname "$(dirname "$0")")/bin/kubectl"

logInfo "kubectl installed successfully"
