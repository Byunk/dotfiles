#!/bin/bash

set -euo pipefail

curr_dir=$(dirname "$0")
base_dir=$(dirname "$curr_dir")

source "$base_dir/scripts/common.sh"

if [ "$(get_os)" == "Linux" ]; then
	install_with_linux_package_manager "tmux"
fi
