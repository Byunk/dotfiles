#!/bin/bash

CURR_DIR=$(dirname "$0")
source "${CURR_DIR}/common/common.sh"

check.env "DOT_DIR"
BACKUP_DIR="${HOME}/dotfiles.bu"

function install() {
    mkdir -p "${BACKUP_DIR}"

    if [[ "${OSTYPE}" == "darwin"* ]]; then
        install.iterm.conf
        install.macos.setting
    fi

    install.git
}

# Creates a symlink from $1 to $2
function backup.and.symlink() {
    if [[ -e $2 ]]; then
        print.message "INFO" "Backup $2 to ${BACKUP_DIR}"
        mv "$2" "${BACKUP_DIR}/"
    fi

    mkdir -p "$(dirname $2)"
    ln -sf "$1" "$2"
}

function install.git() {
    backup_then_symlink "${DOT_DIR}/git/gitconfig" "${HOME}/.gitconfig"
    local username="$(ask "git username")"
    local email="$(ask "git email")"
    git config --global user.name "${username}"
    git config --global user.email "${email}"
}

function install.tmux() {
    backup_then_symlink "${DOT_DIR}/tmux/tmux.conf" "${HOME}/.tmux.conf"
}

function install.zsh() {
    backup_then_symlink "${DOT_DIR}/zsh/zshrc" "${HOME}/.zshrc"
    chsh -s "$(which zsh)"
}

function install.vim() {
    backup_then_symlink "${DOT_DIR}/vim/vimrc" "${HOME}/.vimrc"
}

function install.nvim() {
    backup_then_symlink "${DOT_DIR}/nvim" "${HOME}/.config/nvim"
    local NVIM="$(which nvim)"
    "${NVIM}" +PlugInstall +qall
}

function install.iterm.conf() {
    backup.and.symlink "${DOT_DIR}/iterm/com.googlecode.iterm2.plist" "${HOME}/Library/Preferences/com.googlecode.iterm2.plist"
}

function install.macos.setting() {
    source "${DOT_DIR}/macos/macos-settings.sh"
}

install
