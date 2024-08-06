#!/bin/bash

# getArch discovers the architecture for this system.
getArch() {
	local ARCH=$(uname -m)
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
	local OS=$(echo $(uname) | tr '[:upper:]' '[:lower:]')
	case "$OS" in
	# Minimalist GNU for Windows
	mingw* | cygwin*) OS='windows' ;;
	esac
	echo "$OS"
}

# hasCommand checks if a command exists in the PATH.
hasCommand() {
	local command="$1"
	type "$command" &>/dev/null && echo true || echo false
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
	local isGreater=$(printf '%s\n' "$v1" "$v2" | sort -V -C)
	if [ "$isGreater" ]; then
		echo true
	else
		echo false
	fi
}

# logInfo logs an info message.
logInfo() {
	local message="$1"
	echo "[INFO]: $message"
}

# logErrorAndExit logs an error message and exits the script.
logErrorAndExit() {
	local message="$1"
	logError "$message"
	exit 1
}

# logError logs an error message.
logError() {
	local message="$1"
	local RED='\033[0;31m'
	local NC='\033[0m'
	echo -e "${RED}[ERROR]: $message${NC}" >&2
}