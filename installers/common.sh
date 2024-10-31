#!/bin/bash

currdir() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

checkcmd() {
  command -v "$1" &>/dev/null
}

getarch() {
  local ARCH
  ARCH=$(uname -m)
  case $ARCH in
  armv5*) ARCH="armv5" ;;
  armv6*) ARCH="armv6" ;;
  armv7*) ARCH="arm" ;;
  aarch64) ARCH="arm64" ;;
  x86) ARCH="386" ;;
  x86_64) ARCH="amd64" ;;
  i686) ARCH="386" ;;
  i386) ARCH="386" ;;
  esac
  echo "$ARCH"
}

getos() {
  local OS
  OS=$(uname | tr '[:upper:]' '[:lower:]')
  case "$OS" in
  # Minimalist GNU for Windows
  mingw* | cygwin*) OS='windows' ;;
  esac
  echo "$OS"
}

# get the latest release tag from github
# https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'
}

# compare two versions
# return 0 if v1 == v2
# return 1 if v1 > v2
# return 2 if v1 < v2
vercomp() {
  if [ "$1" = "$2" ]; then
    return 0
  fi

  local IFS=.
  local i ver1=("$1") ver2=("$2")
  # fill empty fields in ver1 with zeros
  for ((i = ${#ver1[@]}; i < ${#ver2[@]}; i++)); do
    ver1[i]=0
  done
  for ((i = 0; i < ${#ver1[@]}; i++)); do
    if ((10#${ver1[i]:=0} > 10#${ver2[i]:=0})); then
      return 1
    fi
    if ((10#${ver1[i]} < 10#${ver2[i]})); then
      return 2
    fi
  done
  return 0
}

## Logging functions

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

info() {
  local message="$1"
  printf "\r  [ INFO ] %s\n" "${message}"
}

success() {
  local message="$1"
  printf "\r  [ ${GREEN}OK${NC} ] %s\n" "${message}"
}

warn() {
  local message="$1"
  printf "\r  [ ${YELLOW}WARN${NC} ] %s\n" "${message}"
}

user() {
  local message="$1"
  printf "\r  [ ${YELLOW}??${NC} ] %s " "${message}"
}

error() {
  local message="$1"
  printf "\r  [ ${RED}ERROR${NC} ] %s\n" "${message}"
  exit 1
}
