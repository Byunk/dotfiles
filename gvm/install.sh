#!/bin/bash
set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

logInfo "Installing gvm..."

bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

logInfo "gvm installed successfully"
