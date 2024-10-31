#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "$SCRIPT_DIR/common.sh"

UPGRADE="${UPGRADE:-false}"

PACKAGE="shellcheck"
OS=$(getos)

info "Installing $PACKAGE"

if checkcmd "$PACKAGE" && [ "$UPGRADE" = false ]; then
  success "$PACKAGE is already installed"
  exit 0
fi

if [[ "$OS" == "darwin" ]]; then
  brew install "$PACKAGE"
elif [[ -f /etc/os-release ]]; then
  . /etc/os-release
  case "$ID" in
  ubuntu)
    apt install -y "$PACKAGE"
    ;;
  suse | opensuse | sles | opensuse-leap)
    zypper install -y ShellCheck
    ;;
  esac
else
  error "Unsupported OS"
fi

success "Successfully installed $PACKAGE"
