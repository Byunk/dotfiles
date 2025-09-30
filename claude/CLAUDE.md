# Language Guidelines

Follow language-specific best practices and style guides.

## General

- Include `.editorconfig` in the root of the project

### .editorconfig Template

```
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2
```

Based on the template, create a `.editorconfig` file in the root of the project and include specific settings for the language you are working in.

## Python

Always use the following tools for Python development:

- `uv` for package management
- `ruff` for linting and formatting
- `pytest` for testing
- `pre-commit` for git hooks
- `Makefile` for developer convenience

### Makefile Template

```makefile
# Variables

## general variables
OSTYPE ?=$(shell uname | tr '[:upper:]' '[:lower:]')

# Commands

### General Commands:
PHONY: help
help: ## Display this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$|^### .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; { \
		if ($$0 ~ /^### /) { \
			printf "\n\033[1m%s\033[0m\n", substr($$0, 5); \
		} else if ($$0 ~ /^[a-zA-Z_-]+:.*?## /) { \
			printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2; \
		} \
	}'

### Testing
PHONY: test
test: TEST_FILES ?= tests
test: ## Run tests
	uv run pytest $(TEST_FILES)

### Development
PHONY: format
format: ## Format code
	uv run ruff format

PHONY: lint
lint: ## Run linting
	uv run ruff check --fix
```

### pre-commit Template

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v6.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.13.2
    hooks:
      - id: ruff-check
      - id: ruff-format
```

## JavaScript/TypeScript

- Always use `pnpm` instead of `npm`
- Always use `eslint` and `prettier` for linting and formatting
- Always use `vitest` for testing

## Rust

- Always use `cargo` for building and dependency management
- Always use `clippy` for linting
- Always use `cargo test` for testing
