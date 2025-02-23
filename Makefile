SHELL := /bin/bash

.PHONY: help
help: ## Show this help
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: scripts/install.sh ## Install dotfiles
	@$<

install-packages: ./Brewfile ## Install packages
	@brew bundle

macos-setting: scripts/macos-setting.sh ## Macos system setting
	@$<

check-scripts: ## Run shellcheck on all scripts
	@find . -type f -name "*.sh" -not -path "*/zsh/.antidote/**/*" -exec shellcheck {} +

install-homebrew:
	@/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
