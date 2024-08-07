#!/bin/bash
set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

VERSION="v0.40.0"

logInfo "Installing nvm..."

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$VERSION/install.sh | bash

logInfo "nvm installed successfully"
