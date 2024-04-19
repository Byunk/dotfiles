#!/bin/bash
function exit.script() {
    local error_message=$1
    print.message "ERROR" "${error_message}"
    exit 1
}

function print.message() {
    local message_level=$1
    local message_str=$2

    case "${message_level}" in
    "ERROR")
        printf "\n\e[0;31mERROR: \e[m"
        ;;
    "WARNING")
        printf "\n\e[1;33mWARNING: \e[m"
        ;;
    *)
        printf "%s: " "${message_level}"
        ;;
    esac

    printf "%s\n" "${message_str}"
}

function exist.command() {
	local executable=$1
	command -v "${executable}" &> /dev/null 2>&1
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