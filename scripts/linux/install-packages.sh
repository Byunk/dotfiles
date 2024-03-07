#!/bin/bash
set -e

CURR_DIR=$(dirname "$0")
BASE_DIR="${CURR_DIR}/.."

source "${BASE_DIR}/common/common.sh"

function check.os() {
    [[ "${OSTYPE}" != "linux"* ]] && exit.script "Invalid OS"
}

function install() {
    check.command "apt"

    apt update -y
    ! exist.command "zsh" && apt install zsh -y
    ! exist.command "tmux" && apt install tmux -y
    ! exist.command "nvim" && install.neovim
    ! exist.command "fzf" && apt install fzf -y
}

function install.neovim() {
    add-apt-repository ppa:neovim-ppa/unstable
    apt update
    apt install neovim -y
    install.vimplug
}

function install.vimplug() {
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

check.os
install
