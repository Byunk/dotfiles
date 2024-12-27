SHELL := /bin/bash

.PHONY: help
help: ## Show this help
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: scripts/install ## Install dotfiles
	@$<

install-packages: ./Brewfile ## Install packages
	@brew bundle

macos-setting: scripts/macos-setting.sh ## Macos system setting
	@$<

check-scripts: ## Run shellcheck on all scripts
	@shellcheck -x -s bash **/*.sh
	@shellcheck -x -s bash scripts/*
