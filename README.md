# dotfiles

Personal collection of "dotfiles" (configuration files that usually reside in your home directory).

![Demo Terminal](https://raw.githubusercontent.com/vduseev/dotfiles/docs/dotfiles-demo.gif)

[![Supported Platform](https://img.shields.io/badge/platform-macos_|_linux-blue.svg)](https://shields.io/)

**Table of Contents**

* <a href="#key-benefits">Key benefits of this setup</a>
* <a href="#target-audience">Target audience</a>
* <a href="#requirements">Requirements</a>
  * <a href="#fonts">Fonts</a>
  * <a href="#shell">Shell</a>
  * <a href="#shell-prompt">Shell prompt</a>
  * <a href="#terminal-multiplexer">Terminal multiplexer</a>
  * <a href="#terminal">Terminal</a>
  * <a href="#keyboard-mapping">Keyboard mapping</a>
* <a href="#installation">Installation</a>
  * <a href="#clone-repository">Clone repository</a>
  * <a href="#create-symlinks">Create symlinks to config files</a>
    * <a href="#wizard-script">Wizard helper script</a>
    * <a href="#manual-symlinks">Manual symlinks</a>
  * <a href="#customization">Customization</a>
* <a href="#cheat-sheet">Cheat sheet</a>
  * <a href="#shell-shortcuts">Shell shortcuts</a>
  * <a href="#navigate-buffers">Navigate buffers</a>
  * <a href="#tmux-shortcuts">Tmux shortcuts</a>

<a id="key-benefits"></a>

## Key benefits of this particular setup

* It is designed to work everywhere
* Everything you learn to operate this, works on all Linux machines
* You can install just only parts of it
* Works with any modern terminal

<a id="target-audience"></a>

## Who is this for?

* You work a lot with a terminal
* You use vim whenever you can
* You love yourself some fancy terminal UI
* You use tmux

<a id="requirements"></a>

## Requirements

Here is what needs to be installed on your machine before you can proceed with the dotfiles setup.

| Requirement | What is it |
| - | - |
| [Nerd Fonts](https://www.nerdfonts.com/#home) | fonts for developers with icons and symbols |
| [Starship](https://starship.rs/) | interactive, beautiful and fast command line prompt written in Rust |
| [Zsh](https://en.wikipedia.org/wiki/Z_shell) | extended bourne shell with many improvements |
| [tmux](https://github.com/tmux/tmux) | terminal multiplexer |
| [Alacritty](https://alacritty.org/) | fast optimized terminal emulator |
| [vim](https://www.vim.org/) | screen based text editor |

*Installation instructions for macOS are provided below*.

<a id="fonts"></a>

### Fonts

This is a set of special extended mono fonts that contain all kinds of special
signs and symbols to be used for fancy graphics inside your terminal.

99% of terminals can't draw random graphics. So if you want do draw a beautiful arrow,
you need to have that glyph in your font. Nerd Fonts is one of the best collection
of such fonts.

```shell
# Add repository with fonts to Homebrew
brew tap homebrew/cask-fonts

# Install individual fonts (replace <FONT NAME> with actual name of the font)
brew install --cask font-<FONT NAME>-nerd-font
```

Here are a couple of fonts that I use:

* [Lekton](https://www.programmingfonts.org/#lekton)
* [Inconsolata](https://www.programmingfonts.org/#inconsolata)
* [Hack](https://www.programmingfonts.org/#hack)
* [Noto](https://www.programmingfonts.org/#noto)

To install `hack` font, for example, execute the command above like this:

```shell
brew install --cask font-hack-nerd-font
```

<a id="shell"></a>

### Shell

We are using Zsh as a shell. There are two main reasons for that:

1. It is fully compatible with Bash 4.0.
1. It is installed by default on macOS.

Unlike with `fish` shell or some other alternatives, you don't need
to learn new syntax or change your scripts. Everything you learn
with Zsh applies to Bash. Every Sh and Bash script can be executed
by Zsh without a change.

If you use Bash, you can replicate some of what is configured here
in `.zshrc` in your `.bashrc` config file.

<a id="shell-prompt"></a>

### Shell prompt

Starship is the shell prompt. Instead of a boring `$` sign at the start of your
prompt you can have all kinds of stuff: which git branch you are on, what version
of Node or Python you are using, which Kubernetes cluster you are connected to.

Starship is a fast and smart prompt written in Rust.

```shell
brew install starship
```

<a id="terminal-multiplexer"></a>

### Terminal multiplexer

Even when working as a developer, you rarely need more than a few Terminal tabs.
You can easily achieve that with modern terminals. As most of them provide tab functionality.

However, eventually you reach the point where your terminal won't cut it anymore:

* Have your command running in the background with terminal closed.
* Keep dozens of terminals open simultaneously and jump between them.
* All your terminals are restored automatically after restart.
* And much much more...

Tmux has a steep learning curve but it is worth it. Especially when you do DevOPS/SRE
kind of work or technical support.

```shell
brew install tmux
```

<a id="terminal"></a>

### Terminal

At the moment, or at least until [Ghostly](https://mitchellh.com/ghostty) is released,
[Alacritty](https://alacritty.org) is the fastest and most advanced terminal emulator you can find.

Alternatives:
- iTerm2
- Standard macOS terminal

```shell
brew install alacritty
```

<a id="keyboard-mapping"></a>

### Adjust your keyboard mapping

On macOS it makes a lot of sense to remap some of the keys to make the
keyboard more suitable for terminal based workflow.

In particular, I highly recommend remapping the <kbd>Caps Lock</kbd> key
to <kbd>Ctrl</kbd> in Settings.

Since many shortcuts in this config use <kbd>Ctrl</kbd> for navigation in the terminal
it is very useful to change the meaning of the <kbd>Caps Lock</kbd> key to instead work
like <kbd>Ctrl</kbd>.

In that case you don't have to look for the <kbd>Ctrl</kbd> with your left pinky each time
you want to press it. It really speeds the workflow up, less error prone, and much more convenient.

* Go to *System Settings* of macOs
* Choose *Keyboard*
* Click "Keyboard Shortcuts..."
* Choose *Modifier Keys...*
* Choose `^ Control` from the dropdown for *Caps Lock Key*.
* Click *OK*

*Note: you will need to configure a remap for every new keyboard you connect to you macOS.*

<a id="installation"></a>

## Installation of the dotfiles

<a id="clone-repository"></a>

### Clone the repository

Clone this repository to the desired destination directory. For example, here we clone it into Home directory:

```shell
$ git clone https://github.com/vduseev/dotfiles.git ~/.dotfiles
```

<a id="create-symlinks"></a>

### Create symlinks in the home directory

<a id="wizard-script"></a>

#### Using the `install.sh` wizard script

To simplify the whole configuration process, you can use an interactive
`install.sh` script available in this repository.

The script is very-very careful and will prompt you for confirmation
at every step. It will ask whether you want to install every specific config part.
And it will offer to backup, delete or ignore any existing files or symlinks,
if it finds any.

```shell
$ ./install.sh

This script will install and link individual items from dotfiles
to your home directory and will prompt you at each step.

If you wish to install a single item, specify it as an argument
to this script. For example: ./install.sh zsh

Available config items to install: zsh, vim, tmux, alacritty, starship

1) Would you like to set up zsh? (y/N)
```

The script also allows you to install a specific config individually.

```shell
$ ./install.sh vim

Creating a symlink at '~/.vimrc' pointing to '~/.dotfiles/.vimrc' ...

Can't proceed. File or directory already exists at ~/.vimrc.
Would you like to rename it (r), delete it (d), or skip (N)? (r/d/N) d
Removed existing ~/.vimrc successfully.
Symlink at ~/.vimrc has been created successfully!
```

<a id="manual-symlinks"></a>

#### Configure symlinks manually

You can create individual symlinks manually, of course. For example, here is one for `vim`:

```shell
$ cd ~
$ ln -s ~/.dotfiles/.vimrc
```

<a id="customzation"></a>

### Customization

Do not change linked files! Use `local` customizations instead!

Configs for alacritty, bash, zsh, tmux are capable of loading user defined config files
with settings that will compliment or overwrite settings implemented in this repository
without having to fork it.

Put your own settings into the following files and they will be automatically loaded
and will overwrite settings implemented in this repository.

* Alacritty: `~/.config/alacritty/alacritty.local.toml`
* Tmux: `~/.tmux.local`
* Bash: `~/.bashrc.local`
* Zsh: `~/.zshrc.local`

<a id="cheat-sheet"></a>

## Cheat sheet

<a id="shell-shortcuts"></a>

### Shell keyboard shortcuts

This navigation is based on Emacs and is common for all terminals and computers in general.
This is not a part of this config and is placed here for information.

| Shortcut | Action |
| - | - |
| <kbd>Ctrl + a</kbd> | Move to the start of the command line |
| <kbd>Ctrl + e</kbd> | Move to the end of the command line |
| <kbd>Ctrl + u</kbd> | Delete everything to the left of cursor position |
| <kbd>Ctrl + w</kbd> | Delete one word to the left |
| <kbd>Alt/Option + f</kbd> | Move one word forward |
| <kbd>Alt/Option + b</kbd> | Move one word backwards |
| <kbd>Ctrl + l</kbd> | Clean current terminal window of all text |

<a id="navigate-buffers"></a>

### Navigate buffers in `vim` or inside screen outputs from commands such as `man` or `less`.

These navigation shortcuts work in `vim`, in `man` pages, while reading output of `less` or `more` commands, etc.
This is not a part of this config as well and is placed here for information.

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

<a id="tmux-shortcuts"></a>

### Tmux shortcuts

Tmux is a terminal multiplexer. It allows you to run multiple virtual terminal windows inside a single actual terminal.
Tmux starts a process that runs in the background and then attaches to it.
Thanks to this, you can close your terminal or detach from a session and it will continue to run in the background
unless you turn off your computer.

Main benefits of `tmux` are that you only need one actual terminal window open and that it can run sessions in the background.
However, you also navigate between virtual terminals faster and you can create preconfigured sessions for your projects
using tools like `tmuxinator` or use [`tmux-continuum`](https://github.com/tmux-plugins/tmux-continuum) to restore
all your terminals to last saved state after you restart tmux or computer.

* To start new untitled session: `tmux`
* Start new session with a name (e.g. home): `tmux new -s home`
* Attach to existing session from terminal: `tmux a -t home`
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

