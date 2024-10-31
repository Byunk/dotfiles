SHELL := /bin/bash

.PHONY: help
help: ## Show this help
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ./install.sh ## Install dependencies
	@$<

check-scripts: ## Run shellcheck on all scripts
	@shellcheck -x -s bash **/*.sh

test-opensuse: ## Run tests on openSUSE
	@docker build -t test-openSUSE -f Dockerfile.opensuse .
	@docker run --rm test-openSUSE
