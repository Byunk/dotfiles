SHELL := /bin/bash

.PHONY: help
help: ## Show this help
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bootstrap: scripts/bootstrap ## Configure dotfiles
	@$<

install: scripts/install ## Install dependencies
	@$<

upgrade: scripts/upgrade ## Upgrade dependencies
	@$<

check-scripts: ## Run shellcheck on all scripts
	@shellcheck -x -s bash scripts/*.sh