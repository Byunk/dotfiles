# dotfiles

Collection of dotfiles that I use to maintain with minimal effort.

## Usage

Clone this repository into your home directory.

```sh
cd dotfiles

# For linux without package manager
./install.sh --install

# For mac os
./install.sh --macos-install

# For configuration dotfiles
./install.sh --install-config
```

For update, use `update.sh`

```sh
update iterm config
./update.sh --iterm

update todo.txt-cli
./update.sh --todo
```

## Configuration

### Iterm

If you want to save the Iterm preferences do not directly save preference on `dotfiles/iterm`. Indeed, copy on `~/Library/preferences/` directory and commit `dotfiles`. (`general` -> `preferences` -> `Save Current Settings to Folder`)

## Awesome List

### Command Line Tools

- [lf](https://github.com/gokcehan/lf)
- [neovim](https://github.com/neovim/neovim)
- [tmux](https://github.com/tmux/tmux)
- [zsh]()

### GUI for macOS

- [alfred](https://www.alfredapp.com/)
- [hiddenbar](https://github.com/dwarvesf/hidden)
- [rectangle](https://rectangleapp.com/)
- [flycut](https://github.com/TermiT/Flycut)
