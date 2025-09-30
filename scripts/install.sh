#!/bin/bash
set -euo pipefail

CURR_DIR="$(dirname "$0")"
# shellcheck disable=SC1091,SC1090
source "$CURR_DIR/common.sh"

ROOT_DIR=$(dirname "$CURR_DIR")

CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.backup"

mkdir -p "$CONFIG_DIR"
mkdir -p "$BACKUP_DIR"

git submodule update --init --recursive

# gitconfig

TEMPLATE_GITCONFIG="$ROOT_DIR/gitconfig.local.template"
LOCAL_GITCONFIG="$ROOT_DIR/gitconfig.local"

if ! [[ -f "$LOCAL_GITCONFIG" ]]; then
  info ".gitconfig not found, creating one"

  case "$OSTYPE" in
  darwin*) GIT_CREDENTIAL_HELPER='osxkeychain' ;;
  *) GIT_CREDENTIAL_HELPER='cache' ;;
  esac

  read -r -p "Enter your git username: " GIT_USERNAME
  read -r -p  "Enter your git email: " GIT_EMAIL

  sed \
    -e "s/AUTHORNAME/$GIT_USERNAME/g" \
    -e "s/AUTHOREMAIL/$GIT_EMAIL/g" \
    -e "s/GIT_CREDENTIAL_HELPER/$GIT_CREDENTIAL_HELPER/g" \
    "$TEMPLATE_GITCONFIG" \
    >"$LOCAL_GITCONFIG"

  info ".gitconfig created"
fi

# netrc

LOCAL_NETRC="$ROOT_DIR/netrc.local"

create_netrc_machine() {
  local machine="$1"
  local login="$2"
  local password="$3"

  {
    echo "machine $machine"
    echo "  login $login"
    echo "  password $password"
    echo ""
  } >>"$LOCAL_NETRC"
}

if ! [[ -f "$LOCAL_NETRC" ]]; then
  info ".netrc not found, creating one"

  read -r -p  "Enter your GitHub username: " GITHUB_USERNAME
  read -r -p  "Enter your GitHub token: " GITHUB_TOKEN

  create_netrc_machine "github.com" "$GITHUB_USERNAME" "$GITHUB_TOKEN"

  while true; do
    read -r -p  "Do you want to add a machine to .netrc? (y/n): " ADD_MACHINE
    if [[ "$ADD_MACHINE" != "y" ]]; then
      break
    fi

    read -r -p  "Enter your netrc machine: " NETRC_MACHINE
    read -r -p  "Enter your netrc login: " NETRC_LOGIN
    read -r -p  "Enter your netrc password: " NETRC_PASSWORD

    create_netrc_machine "$NETRC_MACHINE" "$NETRC_LOGIN" "$NETRC_PASSWORD"
  done
fi

backup() {
  local source="$1"
  local target
  target="$BACKUP_DIR/$(basename "$source")"

  if [[ -L "$source" ]]; then
    warn "It's a symlink, skipping backup and removing $source"
    rm "$source" || (error "Failed to remove $source" && exit 1)
    return
  else
    mv "$source" "$target" || (error "Failed to backup $source to $target" && exit 1)
  fi
}

install() {
  local source
  local target="$2"
  source=$(realpath "$1")

  if [[ -e "$target" ]]; then
    backup "$target"
  fi

  ln -sf "$source" "$target" || (error "Failed to create symlink $source -> $target" && exit 1)

  info "Installed $source -> $target"
}

for dir in "$ROOT_DIR/config"/*; do
  if [[ -d "$dir" ]]; then
    config_name=$(basename "$dir")
    config_dir="$CONFIG_DIR/$config_name"

    install "$dir" "$config_dir"
  fi
done

# Directories
install "$ROOT_DIR/nvim" "$CONFIG_DIR/nvim"
install "$ROOT_DIR/zellij" "$CONFIG_DIR/zellij"
install "$ROOT_DIR/zsh" "$CONFIG_DIR/zsh"
install "$ROOT_DIR/claude/agents" "$HOME/.claude/agents"
install "$ROOT_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Files
install "$ROOT_DIR/gitconfig.local" "$HOME/.gitconfig.local"
install "$ROOT_DIR/gitconfig" "$HOME/.gitconfig"
install "$ROOT_DIR/gitignore" "$HOME/.gitignore"
install "$ROOT_DIR/netrc.local" "$HOME/.netrc"
install "$ROOT_DIR/zshenv" "$HOME/.zshenv"

if [[ "$OSTYPE" == "darwin"* ]]; then
  install "$ROOT_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
fi

echo ""
info "Installation complete"
info "source ~/.config/zsh/.zshrc"
