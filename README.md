# dotfiles

Makes setting up a new machine a breeze.

## Usage

```bash
# Install Homebrew
make install-homebrew
# Install all packages with homebrew
make install-packages
# Install all dotfile configurations
make install
# Install macOS settings
make macos-setting
```

## Featured Tools

- [claude code](https://docs.anthropic.com/en/docs/claude-code/overview)
- [fzf](https://github.com/junegunn/fzf)
- [zellij](https://zellij.dev/)

## Claude Code

Agents are inspired by [agents](https://github.com/wshobson/agents)

### MCP Servers

- [context7](https://github.com/upstash/context7)

```bash
claude mcp add --transport http context7 https://mcp.context7.com/mcp
```

- [mcp-obsidian](https://github.com/MarkusPfundstein/mcp-obsidian)

1. Install Obsidian REST API plugin in your Obsidian
2. Get the API key from Obsidian REST API plugin settings
3. Start the server

```bash
claude mcp add --scope user --transport stdio obsidian --env OBSIDIAN_API_KEY='<your-api-key>' -- uvx mcp-obsidian
```

### Plugin Marketplace

- [anthropics/claude-code](https://github.com/anthropics/claude-code)
  - pr-review-toolkit
  - feature-dev
  - security-guidance
