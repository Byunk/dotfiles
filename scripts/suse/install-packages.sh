#!/bin/bash
set -e

CURR_DIR=$(dirname "$0")
BASE_DIR="${CURR_DIR}/.."

source "${BASE_DIR}/common/common.sh"

function check.os() {
    [[ "${OSTYPE}" != "linux"* ]] && exit.script "Invalid OS"
}

function install() {
    check.command "zypper"

    zypper update
    ! exist.command "zsh" && zypper install -y zsh
    ! exist.command "tmux" && zypper install -y tmux
    ! exist.command "nvim" && install.neovim
    ! exist.command "fzf" && zypper install -y fzf
}

function install.neovim() {
    zypper install -y neovim
    install.vimplug
}

function install.vimplug() {
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

check.os
install
