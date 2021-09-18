# dotfiles

[![Supported Platform](https://img.shields.io/badge/platform-macos_linux-blue.svg)](https://shields.io/)

Personal collection of "dotfiles".

## Requirements

* Nerd Fonts installed on the system
* Starship command line prompt

## Installation

1. Clone this repository to the desired destination directory.

   ```shell
   git clone https://github.com/vduseev/dotfiles.git ~/.dotfiles
   ```

2. Link individual configs as you please.

   For example, create a symlink for `vim` configuration

   ```shell
   cd ~
   ln -s ~/.dotfiles/.vimrc
   ```

## Attributions

Tmux configuration is inspired and borrowed from excellent [config](https://github.com/gpakosz/.tmux) by
[Gregory Pakosz and other contributors](https://github.com/gpakosz/.tmux/graphs/contributors).

The only reason the original config is not used in combination with a supplied `.tmux.conf.local`
file is because tmux-continuum is forcefully enabled there, which messes up tmuxinator based windows.
