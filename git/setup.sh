#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

setup_gitconfig() {
  info "Setting up git..."

  if [ "$(getOS)" == "darwin" ]; then
    git_credential='osxkeychain'
  else
    git_credential='cache'
  fi

  user " - What is your github author name?"
  read -re git_authorname
  user " - What is your github author email?"
  read -re git_authoremail

  sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" "$DOTFILES_ROOT/git/gitconfig.local.symlink.example" > "$DOTFILES_ROOT/git/gitconfig.local.symlink"

  success "git setup complete"
}

if ! [ -f "$DOTFILES_ROOT/git/gitconfig.local.symlink" ]
then
  setup_gitconfig
else
  info "skipped git setup"
fi