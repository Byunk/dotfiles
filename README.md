# dotfiles

Collection of dotfiles that I use to maintain with minimal effort.

## Usage

Clone this repository into your home directory.

```sh
cd dotfiles
./install.sh --install

# For mac os
./install.sh --macos-install 
```

When you install iterm configuration, set general - check Load preferences from a custom folder or URL to ~/dotfiles/iterm and save changes to Automatically.


## Configuration

### Iterm

If you want to save the Iterm preferences do not directly save preference on `dotfiles/iterm`. Indeed, copy on `~/Library/preferences/` directory and commit `dotfiles`. (`general` -> `preferences` -> `Save Current Settings to Folder`)

## Additional Dependencies

- Install [vim plug: vim plugin manager](https://github.com/junegunn/vim-plug) and execute `:PlugInstall` in `nvim`
