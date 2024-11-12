# dotfiles

Makes setting up a new machine a breeze.

## Usage

Clone this repository with `--recursive` flag.

```bash
git clone --recursive https://github.com/Byunk/dotfiles
```

### Basic Usage

```bash
# Help
make help 

# Install packages and configs
make install

# Install macOS applications
make install-brew

# Config system settings for macOS
make macos-setting
```

### Iterm2

`Settings > General > Settings > Check 'Load settings from a custom folder or URL' > Browse '/path/to/dotfiles/iterm' > Restart Iterm2`

> **NOTE**: Do not copy local changes into the directory. It messes up settings.
