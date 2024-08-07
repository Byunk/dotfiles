#!/bin/bash
set -euo pipefail

source "$(dirname "$(dirname "$0")")/scripts/common.sh"

logInfo "Installing pyenv..."

curl https://pyenv.run | bash

logInfo "pyenv installed successfully"
