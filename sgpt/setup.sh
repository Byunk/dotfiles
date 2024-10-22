#!/bin/bash
set -euo pipefail

source "$DOTFILES_ROOT/scripts/common.sh"

if [ ! -d "$HOME/.config/shell_gpt" ]; then
  error "$HOME/.config/shell_gpt does not exist."
fi

substitute() {
  local key="$1"
  local new_value="$2"

  sed -i '' "s|^\($key=\).*|\1$new_value|" "$HOME/.config/shell_gpt/.sgptrc"
}

DEFAULT_MODEL="gpt-4o-mini"
ROLE_STORAGE_PATH="$DOTFILES_ROOT/sgpt/roles"
OPENAI_FUNCTIONS_PATH="$DOTFILES_ROOT/sgpt/functions"

info "Setting up sgpt..."

substitute "DEFAULT_MODEL" "$DEFAULT_MODEL"
substitute "ROLE_STORAGE_PATH" "$ROLE_STORAGE_PATH"
substitute "OPENAI_FUNCTIONS_PATH" "$OPENAI_FUNCTIONS_PATH"

success "sgpt setup complete"