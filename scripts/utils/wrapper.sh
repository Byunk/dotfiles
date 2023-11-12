#!/bin/bash

function curl() {
	CURL="/usr/bin/curl"
	CURLARGS="-L0"
	HTTPURL="$1"

	if [[ ! -z "$3" ]]; then
		# If target directory is specified, download to target directory
		DIR="$3"
		$CURL $CURLARGS $HTTPURL > $DIR
	else
		# Else, download to current directory
		$CURL $CURLARGS $HTTPURL
	fi
}

function chmod() {
	CHMOD="/bin/chmod"
	CHMODARGS="u+x"
	FILE="$1"

	$CHMOD $CHMODARGS $FILE
}