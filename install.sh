#!/bin/bash

export DOT_DIR=~/dotfiles
export DOT_BACKUP_DIR=~/dotfiles.bu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Utils
source ${SCRIPT_DIR}/scripts/utils/print.sh
source ${SCRIPT_DIR}/scripts/utils/path.sh
source ${SCRIPT_DIR}/scripts/utils/wrapper.sh

# Core
source ${SCRIPT_DIR}/scripts/core-common.sh
source ${SCRIPT_DIR}/scripts/core-linux.sh


# Install core utils wihtout package manager
function suse-install() {
	verify_script_dir

	if [[ "$OSTYPE" != "linux"* ]]; then
		red_echo "You are not using linux! OSTYPE == $OSTYPE"
		exit 1
	fi

	if [[ ! -f /usr/bin/zypper ]]; then
        red_echo "zypper not found"
        exit 1
    fi

	selection_dir

	if selection_prompt "git"; then
		zypper in git-core
		install-git-config
	fi

	if selection_prompt "tmux"; then
		zypper install tmux
		install-tmux-config
	fi

	if selection_prompt "zsh"; then
		zypper install zsh
		install-zsh-config
	fi

	if selection_prompt "nvim"; then
		install-nvim
		install-nvim-config
		install-vimplug
	fi
}

# Install core utils with ubuntu's package manager 'apt'
function ubuntu-install() {
	verify_script_dir
	
	if [[ "$OSTYPE" != "linux"* ]]; then
		red_echo "You are not using linux! OSTYPE == $OSTYPE"
		exit 1
	fi

	if [[ ! -f /usr/bin/apt ]]; then
        red_echo "apt not found"
        exit 1
    fi

	apt update -y

    if [[ ! -f /usr/bin/curl ]]; then
		apt install curl -y
	fi

	selection_dir

	if selection_prompt 'git'; then
		if [[ ! -f /usr/bin/git ]]; then
			apt install git -y
		fi
		install-git-config
	fi

	if selection_prompt "tmux"; then
		apt install tmux -y
		install-tmux-config
	fi

	if selection_prompt "zsh"; then
		apt install zsh -y
		chsh -s $(which zsh)
		install-zsh-config
	fi

	if selection_prompt "nvim"; then
		# Prerequisites for appimage
		apt install fuse -y && apt install libfuse2 -y

		install-nvim
		install-vim-config
		install-nvim-config
		install-vimplug

		# Install plugins
		NVIM="$BASEDIR/nvim"
    	$NVIM -c PlugInstall -c q -c q
	fi
}

# Install core utilities for macOS
function macos-install() {
	verify_script_dir

	if [[ "$OSTYPE" != "darwin"* ]]; then
		red_echo "You are not using macOS! OSTYPE == $OSTYPE"
		exit 1
	fi

	if selection_prompt 'homebrew'; then
		if [[ ! $(brew --version) ]]; then
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		fi
		brew bundle --file ${DOT_DIR}/homebrew/Brewfile
	fi

	if selection_prompt 'macOS system settings'; then
		. "${DOT_DIR}/macos/macos-settings.sh"
	fi

	yellow_echo 'It replaces the existing preferences.
	Do you want to proceed?'
	if selection_prompt 'Iterm'; then
		mv ${DOT_DIR}/iterm/com.googlecode.iterm2.plist "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
	fi

	yellow_echo 'Ending installation...'
}

function delete_backup() {
	yellow_echo "Deleting ${DOT_BACKUP_DIR}..."
	rm -rf $DOT_BACKUP_DIR
}

function help() {
  green_echo "
                    Dotfiles Utility Script Usage

  ===================================================================

  Syntax: ./dotfiles-util.sh <arg>
  -------------------------------------------------------------------

  args:
	--ubuntu              : Deploy core utilities for Ubuntu
    --macos               : Deploy configuration symlinks for macOS and related utilities
	--suse                : Deploy core utilities for SUSE
    --delete-backup       : Delete $DOT_BACKUP_DIR
  "
}

function main() {
	case $1 in
		"--ubuntu")
			ubuntu-install
		;;
		"--macos")
			macos-install
		;;
		"--suse")
			suse-install
		;;
		"--delete-backup")
			delete_backup
		;;
		"--help")
			help
		;;
		*)
			red_echo 'Invalid option'
			help
		;;
	esac

	exit 0
}

main $@

