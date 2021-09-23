# dotfiles

Personal collection of "dotfiles" (configuration files that usually reside in your home directory).

![Demo Terminal](https://raw.githubusercontent.com/vduseev/dotfiles/docs/dotfiles-demo.gif)

[![Supported Platform](https://img.shields.io/badge/platform-macos_|_linux-blue.svg)](https://shields.io/)

<a id="requirements"></a>

## Requirements

| Requirement | What is it |
| - | - |
| [Nerd Fonts](https://www.nerdfonts.com/#home) | fonts for developers with icons and symbols |
| [Starship](https://starship.rs/) | interactive, beautiful and fast command line prompt written in Rust |
| Zsh & [Oh My Zsh](https://ohmyz.sh/) | configuration framework for Zsh |
| [tmux](https://github.com/tmux/tmux) | terminal multiplexer |
| [Alacritty](https://alacritty.org/) | fast optimized terminal emulator |
| Vim | Screen based text editor |

## Installation

1. Clone this repository to the desired destination directory. For example, here we clone it into Home directory:

   ```shell
   $ git clone https://github.com/vduseev/dotfiles.git ~/.dotfiles
   ```

2. Link individual configs as you please.

   You can use wizard script `install.sh` available in this repository:

   ```shell
   $ cd ~/.dotfiles
   $ ./install.sh

   This script will link individual files from dotfiles to your home directory
   and will prompt you before each script.

   1) Would you like to create symlink for .zshrc (y/N)?
   Skipping symlink .zshrc ...

   2) Would you like to create symlink for .vimrc (y/N)? y
   Creating symlink to '/Users/vduseev/Projects/dotfiles/.vimrc' from '~/.vimrc' ...
   Symlink .vimrc has been created successfully

   3) Would you like to create symlink for .tmux.conf (y/N)? y
   Creating symlink to '/Users/vduseev/Projects/dotfiles/.tmux.conf' from '~/.tmux.conf' ...
   ln: /Users/vduseev/.tmux.conf: File exists

   Try to force create (ln -sf) the symlink and overwrite your existing file (y/N)? y
   Force creating symlink ...
   Symlink .tmux.conf has been created successfully
   ```

   Or create individual symlinks manually. For example, here is one for `vim`:

   ```shell
   $ cd ~
   $ ln -s ~/.dotfiles/.vimrc
   ```

## Usage

### Command line

This navigation is based on Emacs and is common for all terminals and computers in general.
This is not a part of this config and is placed here just so you know.

| Shortcut | Action |
| - | - |
| <kbd>Ctrl + a</kbd> | Move to the start of the command line |
| <kbd>Ctrl + e</kbd> | Move to the end of the command line |
| <kbd>Ctrl + u</kbd> | Delete everything to the left of cursor position |
| <kbd>Alt/Option + f</kbd> | Move one word forward |
| <kbd>Alt/Option + b</kbd> | Move one word backwards |
| <kbd>Ctrl + l</kbd> | Clear current terminal of all text |

<a id="navigate"></a>

### Navigate buffers

This navigation shortcuts work in `Vim`, in `man` pages, while reading output of `less` or `more` commands, etc.
This is not a part of this config as well and is placed here for you interest.

| Shortcut | Action |
| - | - |
| <kbd>G</kdb> | Go to the enf of the file |
| <kbd>gg</kbd> | Go to the beginning of the file |
| <kbd>/</kbd> | Search mode (enter any word and press <kbd>Enter</kbd>) |
| <kbd>Ctrl + u</kbd> | Jump half page up |
| <kbd>Ctrl + d</kbd> | Jump half page down |
| <kbd>h</kbd> | Move one character to the left |
| <kbd>j</kbd> | Move one line down |
| <kbd>k</kbd> | Move one line up |
| <kbd>l</kbd> | Move one character to the right |
| <kbd>{</kbd> | Jump up to next empty line |
| <kbd>}</kbd> | Jump down to next empty line |

### Tmux

* Start new noname session: `tmux`
* Start new session with a name (e.g. home): `tmux new -s home`
* Attach to existing session from another terminal: `tmux a -t home`
* Kill session: `tmux kill-ses -t home`

| Combination                             | Meaning                                                           |
| -                                       | -                                                                 |
| <kbd>Ctrl + a</kbd>                     | Tmux **prefix**                                                   |
| prefix, <kbd>d</kbd>                    | Detach from current session (it will keep running in background)  |
| prefix, <kbd>c</kbd>                    | Create new window                                                 |
| prefix, <kbd>x</kbd>                    | Close current window                                              |
| prefix, <kbd>,</kbd>                    | Rename current window                                             |
| prefix, <kbd>j</kbd>                    | Next window                                                       |
| prefix, <kbd>k</kbd>                    | Previous window                                                   |
| prefix, <kbd>0/1/2/...</kbd>            | Jump to window with this ID                                       |
| prefix, <kbd>Tab</kbd>                  | Go to last window                                                 |
| prefix, <kbd>"</kbd>                    | Split into panes horizontally (part top, part bottom)             |
| prefix, <kbd>%</kbd>                    | Split into panes vertically (part left, part right)               |
| prefix, <kbd>h/j/k/l</kbd>              | Switch between panes                                              |
| prefix, <kbd>Enter</kbd>                | Enter copy mode                                                   |
| <kbd>v</kbd>                            | Begin selection *(in copy mode)*                                  |
| [Navigation keys](#navigate)            | Move around *(in copy mode)*                                      |
| <kbd>y</kbd>                            | Copy selection to system clipboard *(in copy mode)*               |
| <kbd>Escape</kbd>                       | Quit copy mode                                                    |
| <kbd>Ctrl + l</kbd>                     | Clear screen and history                                          |
| prefix, <kbd>f</kbd>                    | Find window                                                       |
| prefix, <kbd>s</kbd>                    | Overview of all open sessions                                     |
| prefix, <kbd>Ctrl + f</kbd>             | Find another session                                              |
| prefix, <kbd>Ctrl + s</kbd>             | Save session using tmux resurrect                                 |
| prefix, <kbd>Ctrl + r</kbd>             | Restore session                                                   |
| prefix, <kbd>m</kbd>                    | Toggle Mouse mode on/off                                          |
| prefix, <kbd>r</kbd>                    | Reload tmux configuration                                         |
| prefix, <kbd>I</kbd>                    | Install new plugins                                               |
| prefix, <kbd>U</kbd>                    | Update plugins                                                    |
| prefix, <kbd>Alt + u</kbd>              | Remove/uninstall plugins not on the plugin list                   |

## MacOS

This section describes how to install all the <a href="#requirements">requirements</a> above on MacOS using Homebrew.

* Homebrew must be installed
* Install Nerd Fonts

  ```shell
  # Add repository with fonts to Homebrew
  brew tap homebrew/cask-fonts

  # Install individual fonts (replace <FONT NAME> with actual name of the font)
  brew install --cask font-<FONT NAME>-nerd-font
  ```

  Here are couple of fonts that I use:

  * [Lekton](https://www.programmingfonts.org/#lekton)
  * [Inconsolata](https://www.programmingfonts.org/#inconsolata)
  * [Hack](https://www.programmingfonts.org/#hack)
  * [Noto](https://www.programmingfonts.org/#noto)

  To install `lekton` font, for example, execute the command above like this:

  ```shell
  brew install --cask font-lekton-nerd-font
  ```

* Install Starship

  ```shell
  brew install starship
  ```

* Install Oh-My-Zsh

  ```shell
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```

* Install tmux

  ```shell
  brew install tmux
  ```

* Install Alacritty

  ```shell
  brew install alacritty
  ```

* Remap <kbd>CapsLock</kbd> key to <kbd>Ctrl</kbd> in Settings

  Because many shortcuts in this config use <kbd>Ctrl</kbd> for navigation in the terminal
  it is very useful to change the meaning of the <kbd>CapsLock</kbd> key to instead work
  like <kbd>Ctrl</kbd>.

  In that case you don't have to look for the <kbd>Ctrl</kbd> with your left pinky each time
  you want to press it. It really speeds the workflow up, less error prone, and much more convenient.

  * Go to *System Preferences*
  * Choose *Keyboard*
  * Click *Modifier Keys...*
  * Choose `^ Control` from the dropdown for *Caps Lock Key*.
  * Click *OK*

## Attributions

Tmux configuration is inspired and borrowed from excellent [config](https://github.com/gpakosz/.tmux) by
[Gregory Pakosz and other contributors](https://github.com/gpakosz/.tmux/graphs/contributors).

The only reason the original config is not used in combination with a supplied `.tmux.conf.local`
file is because tmux-continuum is forcefully enabled there, which messes up tmuxinator based windows.
