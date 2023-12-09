#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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

function ask_for_directory() {
    echo
    echo "Choose your installation directory"
    select dir in "(/usr/bin)" "(~/.local/bin)"; do
        case $dir in
            "(/usr/bin)" )
                BASEDIR="/usr/bin"
                SHAREDIR="/usr/share"
                return 0
            ;;
            "(~/.local/bin)" )
                BASEDIR="$HOME/.local/bin"
                SHAREDIR="$HOME/.local/share"
                return 0
            ;;
        esac
    done
}

function check_if_installed() {
    if [[ $(which $1) ]]; then
        echo "$1 is already installed"
        return 0
    fi
    return 1
}

function ubuntu-install() {
    if [[ "$OSTYPE" != "linux"* ]]; then
        echo -e "\033[0;31mYou are not using linux! OSTYPE == $OSTYPE\033[0m"
        exit 1
    fi

    if [[ ! -f /usr/bin/apt ]]; then
        echo -e "\033[0;31mapt not found\033[0m"
        exit 1
    fi

    apt update -y

    if ask_for_installation "zsh" && ! check_if_installed "zsh"; then
        apt install zsh -y
    fi

    if ask_for_installation "tmux" && ! check_if_installed "tmux"; then
        apt install tmux -y
    fi

    # Apt does not support the lastest version of neovim
    # Therefore, appimage is used instead
    if ask_for_installation "neovim" && ! check_if_installed "nvim"; then
        apt install fuse -y && apt install libfuse2 -y && apt install curl -y

        local CURL="/usr/bin/curl"
        local CURLARGS="-L0"
        $CURL $CURLARGS "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage" > nvim.appimage
        
        local CHMOD="/bin/chmod"
        local CHMODARGS="u+x"
        $CHMOD $CHMODARGS "nvim.appimage"

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

        # Install VimPlugs
        sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    fi
}

function mac-install() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "\033[0;31mYou are not using macOS! OSTYPE == $OSTYPE\033[0m"
        exit 1
    fi

    if [[ ! -f /usr/bin/brew ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew update -y

    if ask_for_installation "zsh" && ! check_if_installed "zsh"; then
        brew install zsh
    fi

    if ask_for_installation "tmux" && ! check_if_installed "tmux"; then
        brew install tmux
    fi

    if ask_for_installation "neovim" && ! check_if_installed "nvim"; then
        brew install neovim
    fi

    if ask_for_installation "homebrew bundle"; then
        brew bundle --file ${SCRIPT_DIR}/homebrew/Brewfile
    fi
}

function suse-install() {
    if [[ "$OSTYPE" != "linux"* ]]; then
        echo -e "\033[0;31mYou are not using linux! OSTYPE == $OSTYPE\033[0m"
        exit 1
    fi

    if [[ ! -f /usr/bin/zypper ]]; then
        echo -e "\033[0;31mzypper not found\033[0m"
        exit 1
    fi

    if ask_for_installation "zsh" && ! check_if_installed "zsh"; then
        zypper install zsh
    fi

    if ask_for_installation "tmux" && ! check_if_installed "tmux"; then
        zypper install tmux
    fi

    if ask_for_installation "neovim" && ! check_if_installed "nvim"; then
        zypper install neovim
    fi
}

function main() {
    ask_for_directory
    echo

    echo "Which OS are you using?"
    select os in "Ubuntu" "macOS" "SUSE"; do
        case $os in
            Ubuntu ) ubuntu-install; break;;
            macOS ) mac-install; break;;
            SUSE ) suse-install; break;;
        esac
    done
}

main