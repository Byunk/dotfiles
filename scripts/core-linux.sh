#!/bin/bash

# Import Utils
source ${SCRIPT_DIR}/scripts/utils/print.sh
source ${SCRIPT_DIR}/scripts/utils/path.sh
source ${SCRIPT_DIR}/scripts/utils/wrapper.sh

function install-nvim () {
    # Install neovim
    # Check if neovim is already installed
    if [[ $(nvim --version) ]]; then
        green_echo "Neovim is already installed"
        return 0
    fi

    curl "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage" > nvim.appimage
    chmod "nvim.appimage"

    # Check if appimage is executable
    if [[ $(./nvim.appimage --version) ]]; then
        # if not executable, extract appimage
        ./nvim.appimage --appimage-extract
        mv squashfs-root "$SHAREDIR"
        ln -s "$SHAREDIR/squashfs-root/AppRun" "$BASEDIR/nvim"
        rm nvim.appimage
    else
        # if executable, move appimage to $BASEDIR
        mv nvim.appimage "$BASEDIR/nvim"
    fi
}