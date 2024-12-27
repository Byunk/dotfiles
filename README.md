# dotfiles

Makes setting up a new machine a breeze.

## Prerequisites

- [homebrew](https://docs.brew.sh/Installation)

Clone this repository with `--recursive` flag.

```bash
git clone --recursive https://github.com/Byunk/dotfiles
```

## Usage

```bash
# Install all dotfile configurations
make install

# Install all packages
make install-packages

# Install macOS settings
make macos-setting
```

### Iterm2

`Settings > General > Settings > Check 'Load settings from a custom folder or URL' > Browse '/path/to/dotfiles/iterm' > Restart Iterm2`

> **NOTE**: Do not copy local changes into the directory. It messes up settings.
