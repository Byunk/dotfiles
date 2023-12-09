#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DOT_DIR="${SCRIPT_DIR}/.."
BACKUP_DIR=~/dotfiles.bu

function check_if_installed() {
    if [[ $(which $1) ]]; then
        return 0
    fi
    return 1
}

function ask_for_installation() {
    echo
    echo "Would you like to install $1?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) return 0;;
            No ) return 1;;
        esac
    done
}

# Creates a symlink for $1 at $2
function backup_then_symlink() {
    echo
    if [[ -e $2 ]]; then
        echo -e "\033[1;33mExisting $2 will be moved to ${BACKUP_DIR}.\033[0m"
        mv $2 ${BACKUP_DIR}/
    fi

    echo -e "\033[0;32mCreating symlink for $1 at $2...\033[0m"
    mkdir -p $(dirname $2)
    ln -sf $1 $2
}

function mac-install() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        return
    fi

    # Iterm config
    echo
    echo -e "\033[1;33mIt replaces your current iTerm2 config.\033[0m"
    if ask_for_installation "iTerm2"; then
        mv ~/Library/Preferences/com.googlecode.iterm2.plist ${BACKUP_DIR}/
        mv ${DOT_DIR}/iterm/com.googlecode.iterm2.plist ~/Library/Preferences/
    fi

    echo
    echo -e "\033[1;33mIt replaces your current macOS config.\033[0m"
    # macOS config
    if ask_for_installation "macOS system settings"; then
        . "${DOT_DIR}/macos/macos-settings.sh"
    fi
}

function install() {
    if check_if_installed "git"; then
        backup_then_symlink ${DOT_DIR}/git/gitconfig ~/.gitconfig
    fi

    if check_if_installed "tmux"; then
        backup_then_symlink ${DOT_DIR}/tmux/tmux.conf ~/.tmux.conf
    fi

    if check_if_installed "zsh"; then
        backup_then_symlink ${DOT_DIR}/zsh/zshrc ~/.zshrc
        chsh -s $(which zsh)
    fi

    if check_if_installed "nvim"; then
        backup_then_symlink ${DOT_DIR}/vim/vimrc ~/.vimrc
        backup_then_symlink ${DOT_DIR}/nvim ~/.config/nvim

        local NVIM=$(which nvim)
        $NVIM +PlugInstall +qall
    fi

    mac-install
}

function main() {
    mkdir -p $BACKUP_DIR

    install
}

main