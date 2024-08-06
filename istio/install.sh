#!/bin/bash
set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

logInfo "Installing istio..."

pushd "$(dirname "$(dirname "$0")")/bin"
curl -L https://istio.io/downloadIstio | sh -
popd

logInfo "istio installed successfully"
