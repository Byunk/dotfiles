#!/bin/bash

# Checks if the script is located in $DOT_DIR. Else, end the script
function verify_script_dir() {
	if [[ "$SCRIPT_DIR" != "$DOT_DIR" ]]; then
		red_echo "${DOT_DIR} directory not found"
		exit 1
	fi
}

function create_dir() {
	if [[ ! -d $1 ]]; then
		mkdir -p $1
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

	create_dir $(dirname $2)

	green_echo "Creating symlink for $1 at $2..."
	ln -s $1 $2
}

function selection_dir () {
	yellow_echo "Choose your installation directory"
	read -p "1(/usr/bin) / 2(~/.local/bin) " -n1 REPLY
	echo
	case $REPLY in
		"1")
			export BASEDIR="/usr/bin"
			export SHAREDIR="/usr/share"
		;;
		"2")
			export BASEDIR="$HOME/.local/bin"
			export SHAREDIR="$HOME/.local/share"
			create_dir $BASEDIR
			create_dir $SHAREDIR

			if [[ ! ":$PATH:" == *":$BASEDIR:"* ]]; then
				source ${SCRIPT_DIR}/set_path.sh $BASEDIR
			fi
		;;
		*)
			red_echo 'Invalid path'
			exit 1
		;;
	esac
	echo
}