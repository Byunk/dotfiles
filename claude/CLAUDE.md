# Language Guidelines

Follow language-specific best practices and style guides.

## Python

- Do not add module level docstring since it seems written by AI
- Do not add docstring for testing code
- Use `from __future__ import annotations` instead of quoted types

Always use the following tools for Python development:

- `uv` for package management
- `ruff` for linting and formatting
- `pytest` for testing

## JavaScript/TypeScript

Always use the following tools for JavaScript/TypeScript development:

- `pnpm` for package management
- `eslint` and `prettier` for linting and formatting
- `vitest` for testing

## Rust

Always use the following tools for Rust development:

- `cargo` for building and dependency management
- `clippy` for linting
- `cargo test` for testing
