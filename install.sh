#!/bin/bash

export DOT_DIR=~/dotfiles
export DOT_BACKUP_DIR=~/dotfiles.bu

# Utils

function green_echo() {
	echo -e "\033[0;32m[Message] ${1}\033[0m"
}

function yellow_echo() {
	echo
	echo -e "\033[0;33m[Attention] ${1}\033[0m"
	echo
}

function red_echo() {
	echo
	echo -e "\033[0;31m[Fatal] ${1}\033[0m"
	echo
}

# Checks if the script is located in $DOT_DIR. Else, end the script
function verify_script_dir() {
	script_dir=$( cd -- "$( dirname -- ${BASH_SOURCE[0]} )" &> /dev/null && pwd )
	if [[ "$script_dir" != "$DOT_DIR" ]]; then
		red_echo "${DOT_DIR} directory not found"
		exit 1
	fi
}

# Prompts user yes/no for the installation of $1
function selection_prompt() {
	yellow_echo "Would you like to install $1 related files?"
	read -p "y/n? > " -n1 -r REPLY # -p for prompt, -n1 for reading 1 character, -r for reading literally
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		green_echo "Deploying $1 related files..."
		true
	else
		green_echo "Skipping $1 related files..."
		false
	fi
}

# Creates a symlink for $1 at $2
# If a file/dir already exists at $2, move to $DOT_BACKUP_DIR
# E.g.: backup_then_symlink ~/dotfiles/i3/config ~/.config/i3/config
function backup_then_symlink() {
	if [[ -e $2 ]]; then
		yellow_echo "Existing $2 will be moved to ${DOT_BACKUP_DIR}."
		mkdir -p $DOT_BACKUP_DIR
		mv $2 ${DOT_BACKUP_DIR}/
	fi

	if [[ ! -d $2 ]]; then
		mkdir -p $2
	fi

	green_echo "Creating symlink for $1 at $2..."
	ln -s $1 $2
}

function curl() {
	CURL='/usr/bin/curl'

	if [[ $# -lt 2 ]]; then
		red_echo "Invalid parameters for curl"
		exit 1
	fi

	if [[ ! -z "$3" ]]; then
		$CURL -s $1 $2 > $3
	else
		$CURL -s $1 $2
	fi
}

# Core

# Install core utils for linux without package manager
function install() {
	verify_script_dir

	if [[ "$OSTYPE" != "linux"* ]]; then
		red_echo "You are not using linux! OSTYPE == $OSTYPE"
		exit 1
	fi

	if selection_prompt 'neovim'; then
		yellow_echo "Select installation path"
		read -p "1(/usr/bin) / 2(~/.local/bin) " -n1 REPLY
		echo
		case $REPLY in
			"1")
				NVIM_DIR="/usr/bin"
			;;
			"2")
				NVIM_DIR="$HOME/.local/bin"
			;;
			*)
				red_echo 'Invalid path'
				exit 1
			;;
		esac

		green_echo "Installing neovim into $NVIM_DIR"
		echo

		if [[ ! -d $NVIM_DIR ]]; then
			mkdir $NVIM_DIR
		fi

		curl "-cL0" "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage" "$NVIM_DIR/nvim"

		/bin/chmod u+x "$NVIM_DIR/nvim"

		if selection_prompt 'VimPlug'; then
			sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
			nvim -c PlugInstall -c q -c q
		fi
	fi

	yellow_echo 'Ending installation...'
}

# Install core utilities for macOS
function macos-install() {
	verify_script_dir

	if [[ "$OSTYPE" != "darwin"* ]]; then
		red_echo "You are not using macOS! OSTYPE == $OSTYPE"
		exit 1
	fi

	if selection_prompt 'homebrew'; then
		brew bundle --file ${DOT_DIR}/homebrew/Brewfile
	fi

	if selection_prompt 'macOS system settings'; then
		. "${DOT_DIR}/macos/macos-settings.sh"
	fi

	yellow_echo 'It replaces the existing preferences.
	Do you want to proceed?'
	if selection_prompt 'Iterm';
		mv ${DOT_DIR}/iterm/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
	fi

	yellow_echo 'Ending installation...'
}


# Install configurations
function install-config() {
	verify_script_dir

	if selection_prompt 'git'; then
		CURRENT_FILES=("gitignore_global" "gitconfig")
		for FILE in ${CURRENT_FILES[@]}; do
			backup_then_symlink ${DOT_DIR}/git/${FILE} ~/.${FILE}
		done
	fi

	if selection_prompt 'vim'; then
		backup_then_symlink ${DOT_DIR}/vim/vimrc ~/.vimrc
	fi

	if selection_prompt 'Nvim'; then
		backup_then_symlink ${DOT_DIR}/nvim ~/.config
	fi

	if selection_prompt 'Tmux'; then
		backup_then_symlink ${DOT_DIR}/tmux/tmux.conf ~/.tmux.conf
	fi

	if selection_prompt 'Zsh'; then
		backup_then_symlink ${DOT_DIR}/zsh/zshrc ~/.zshrc
		source ~/.zshrc
	fi

	if selection_prompt 'Todo'; then
		backup_then_symlink ${DOT_DIR}/todo/todo.cfg ~/.todo.cfg
		source ~/.todo.cfg
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
	--insatll             : Deploy core utilities for Linux
    --install-config      : Deploy configuration symlinks for cross-platform utilities
    --macos-install       : Deploy configuration symlinks for macOS and related utilities
    --delete-backup       : Delete $DOT_BACKUP_DIR
  "
}

function main() {
	case $1 in
		"--install")
			install
		;;
		"--macos-install")
			macos-install
		;;
		"--install-config")
			install-config
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

