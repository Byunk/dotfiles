#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DOT_DIR="${SCRIPT_DIR}/.."

function ask_for_update() {
    echo
    echo "Would you like to update $1?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) return 0;;
            No ) return 1;;
        esac
    done
}

function update() {
    if ask_for_installation "iterm"; then
        cp ~/Library/Preferences/com.googlecode.iterm2.plist $DOT_DIR/iterm/
    fi
}

function main() {
    update
}

main