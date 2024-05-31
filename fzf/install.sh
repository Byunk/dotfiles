#!/bin/bash
set -euo pipefail

curr_dir=$(dirname "$0")
base_dir=$(dirname "$curr_dir")

source "$base_dir/scripts/common.sh"

version="0.52.1"
type=""

if [[ "$(get_os)" == "Linux" ]]; then
	type+="linux_"
else
	exit 0
fi

if [[ "$(get_arch)" == "x86_64" ]]; then
	type+="amd64"
elif [[ "$(get_arch)" == "arm64" ]]; then
	type+="arm64"
fi

release="fzf-$version-$type.tar.gz"
uri="https://github.com/junegunn/fzf/releases/download/$version/$release"

curl -LO $uri
mkdir -p "$base_dir/bin" && tar -xzvf "$release" -C "$base_dir/bin"
rm "$release"
