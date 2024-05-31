#!/bin/bash
# 
# https://github.com/neovim/neovim/blob/master/INSTALL.md
# 

set -euo pipefail

curr_dir=$(dirname "$0")
base_dir=$(dirname "$curr_dir")

source "$base_dir/scripts/common.sh"

if [[ "$(get_os)" == "Linux" ]]; then
	if exist_command "apt"; then
		add-apt-repository ppa:neovim-ppa/unstable
	fi

	exist_command "nvim"
	if [[ "$?" != "0" ]]; then
		install_with_linux_package_manager "neovim"
	fi
fi
