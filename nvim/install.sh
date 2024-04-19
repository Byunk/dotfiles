#!/bin/bash
set -e

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

source "${DOTFILES_ROOT}/scripts/common.sh"

PACKAGE="neovim"

if [ "$(uname -s)" == "Linux" ]; then
	if exist.command "apt"; then
		add-apt-repository ppa:neovim-ppa/unstable
		apt update && apt install "${PACKAGE}" -y
	elif exist.command "zypper"; then
		zypper install -y "${PACKAGE}"
	fi
fi