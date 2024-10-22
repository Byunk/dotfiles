#!/bin/bash

# getArch discovers the architecture for this system.
getArch() {
	local ARCH
	ARCH=$(uname -m)
	case $ARCH in
	armv5*) ARCH="armv5" ;;
	armv6*) ARCH="armv6" ;;
	armv7*) ARCH="arm" ;;
	aarch64) ARCH="arm64" ;;
	x86) ARCH="386" ;;
	x86_64) ARCH="amd64" ;;
	i686) ARCH="386" ;;
	i386) ARCH="386" ;;
	esac
	echo "$ARCH"
}

# getOS discovers the operating system for this system.
getOS() {
	local OS
	OS=$(uname | tr '[:upper:]' '[:lower:]')
	case "$OS" in
	# Minimalist GNU for Windows
	mingw* | cygwin*) OS='windows' ;;
	esac
	echo "$OS"
}

# hasCommand checks if a command exists in the PATH.
hasCommand() {
	local command="$1"
	eval "${command}" > /dev/null 2>&1 && echo true || echo false
}

getCommand() {
	local package="$1"
	local command
	command=$(jq -r --arg package "$package" '.[] | select(.name == $package) | .command' "$DOTFILES_ROOT/dependency.json")
	echo "${command}"
}

getVersion() {
	local package="$1"
	local version
	version=$(jq -r --arg package "$package" '.[] | select(.name == $package) | .version' "$DOTFILES_ROOT/dependency.json")
	echo "${version}"
}

# compareVersion compares two versions.
# returns 1 if the first version is greater than or equal to the second version
compareVersion() {
	local v1="$1"
	local v2="$2"
	if [ "$v1" = "$v2" ]; then
        echo true
		return
    fi
	local isGreater
	isGreater=$(printf '%s\n' "$v1" "$v2" | sort -V -C)
	if [ "$isGreater" ]; then
		echo true
	else
		echo false
	fi
}

## Logging functions

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'


info() {
    local message="$1"
	printf "\r  [ INFO ] %s\n" "${message}"
}

success() {
	local message="$1"
	printf "\r  [ ${GREEN}OK${NC} ] %s\n" "${message}"
}

warn() {
	local message="$1"
	printf "\r  [ ${YELLOW}WARN${NC} ] %s\n" "${message}"
}

user() {
	local message="$1"
	printf "\r  [ ${YELLOW}??${NC} ] %s " "${message}"
}

error() {
	local message="$1"
	printf "\r  [ ${RED}ERROR${NC} ] %s\n" "${message}"
	exit
}
