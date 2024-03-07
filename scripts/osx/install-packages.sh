#!/bin/bash
set -e

CURR_DIR=$(dirname "$0")
BASE_DIR="${CURR_DIR}/.."

source "${BASE_DIR}/common/common.sh"

function check.os() {
    [[ "${OSTYPE}" != "darwin"* ]] && exit.script "Invalid OS"
}

function install() {
    check.os
    check.env "DOT_DIR"
    check.command "brew"

    brew bundle --file ${DOT_DIR}/homebrew/Brewfile
}

check.os
install