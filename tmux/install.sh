#!/bin/bash
set -e

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

source "${DOTFILES_ROOT}/scripts/common.sh"

PACKAGE="tmux"

if [ "$(uname -s)" == "Linux" ]; then
	install.with.linux.package.manager "${PACKAGE}"
fi