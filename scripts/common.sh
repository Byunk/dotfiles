#!/bin/bash
# Get OS (Linux, Darwin)
get_os() {
	echo "$(uname -s)"
}

# Get Archtype (x86_64, arm64)
get_arch() {
	echo "$(uname -m)"
}

exist_command() {
	local executable="$1"
	command -v "$executable" &>/dev/null 2>&1
}

install_with_linux_package_manager() {
	local package="$1"
	exist_command "$package" && return

	if exist_command "apt"; then
		apt update && apt install "$package" -y
	elif exist_command "zypper"; then
		zypper install -y "$package"
	else
		echo "ERROR: No available package manager found"
		exit 1
	fi
}

function install.with.linux.package.manager() {
	"$(uname -s)" != "Linux" && exit.script "Expect Linux but Wrong OS"

	local package=$1
	exist.command "${package}" && return

	if exist.command "apt"; then
		apt update && apt install "${package}" -y
	elif exist.command "zypper"; then
		zypper install -y "${package}"
	else
		exit.script "No available package manager found"
	fi
}

function is.linux() {
	[[ "$(uname -s)" == "Linux" ]]
}

function is.amd() {
	[[ "$(uname -m)" == "x86_64" ]]
}
