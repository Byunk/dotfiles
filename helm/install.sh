#!/bin/bash
set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

logInfo "Installing helm..."

RELEASE="https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3"

curl -fsSL -o /tmp/get_helm.sh "$RELEASE"
chmod 700 /tmp/get_helm.sh
/tmp/get_helm.sh
rm /tmp/get_helm.sh

logInfo "helm installed successfully"
