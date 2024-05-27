#!/bin/bash
set -e

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

source "${DOTFILES_ROOT}/scripts/common.sh"

PACKAGE="fzf"

if is.linux && is.amd; then
	uri="https://github.com/junegunn/fzf/releases/download/0.52.1/fzf-0.52.1-linux_amd64.tar.gz"
	curl -LO $uri $PACKAGE
	tar -xzvf $PACKAGE
	mv $PACKAGE /bin/$PACKAGE
fi
