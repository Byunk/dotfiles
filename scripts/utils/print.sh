#!/bin/bash

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

