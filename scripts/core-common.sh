#!/bin/bash

# Import Utils
source ${SCRIPT_DIR}/scripts/utils/print.sh
source ${SCRIPT_DIR}/scripts/utils/path.sh

function install-git-config () {
    # Copying git config
    CURRENT_FILES=("gitignore_global" "gitconfig")
    for FILE in ${CURRENT_FILES[@]}; do
        backup_then_symlink ${DOT_DIR}/git/${FILE} "$HOME/.${FILE}"
    done
}

function install-vim-config () {
    # Copying vim config
    backup_then_symlink ${DOT_DIR}/vim/vimrc ~/.vimrc
}

function install-nvim-config () {
    # Copying nvim config
    backup_then_symlink ${DOT_DIR}/nvim ~/.config/nvim
}

function install-vimplug () {
    # Install VimPlugs
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

function install-tmux-config () {
    # Copying tmux config
    backup_then_symlink ${DOT_DIR}/tmux/tmux.conf ~/.tmux.conf
}

function install-zsh-config () {
    # Copying zsh config
    backup_then_symlink ${DOT_DIR}/zsh/zshrc ~/.zshrc
    source ~/.zshrc
}
