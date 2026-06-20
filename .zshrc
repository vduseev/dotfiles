# Zsh Configuration
# https://github.com/vduseev/dotfiles
#
# Copyright: 2017- Vagiz Duseev (@vduseev)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# --- Debug ------------------------------------------------------------------

__time_test() {
  if [[ -n $DOTFILES_DEBUG ]]; then
    >&2 printf "[$(date +'%T.%N')] $1\n"
  fi
}

__time_test "Start"

# --- General ----------------------------------------------------------------

export EDITOR=vim

# Language for compatibility with Mosh
# See: https://github.com/mobile-shell/mosh/issues/793#issuecomment-368755189
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Force emacs mode
# See: https://unix.stackexchange.com/questions/197839/why-does-exporting-vim-as-editor-in-zsh-disable-keyboard-shortcuts
bindkey -e
set -o emacs

# --- Paths ------------------------------------------------------------------

# Replicate behavior of path_helper (populate from /etc/paths, /etc/paths.d)
__path=()
__path+=("${(@f)$(</etc/paths)}")
for f in /etc/paths.d/*(.N); do
  __path+=("${(@f)$(<$f)}")
done
export PATH="${(j/:/)__path}"

# Homebrew
if [[ -d "/opt/homebrew/bin" ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

# uv-installed tools and other user-local binaries
if [[ -d "$HOME/.local/bin" ]] then
  export PATH="$HOME/.local/bin:$PATH"
fi

# --- Languages & Technologies -----------------------------------------------

# JavaScript

if [[ -d "$HOME/.bun/bin" ]]; then
  export PATH="$HOME/.bun/bin:$PATH"  
fi

__time_test "Done: JavaScript"

# Rust

if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

__time_test "Done: Rust"

# Java

if [[ -d "/opt/homebrew/opt/openjdk/bin" ]]; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi

__time_test "Done: Java"

# Go

if [[ -d "$HOME/go/bin" ]]; then
  export PATH="$HOME/go/bin:$PATH"
fi

__time_test "Done: Golang"

# Flutter

if [[ -d "$HOME/Projects/flutter/flutter/bin" ]]; then
  export PATH="$HOME/Projects/flutter/flutter/bin:$PATH"
  export PATH="$HOME/.pub-cache/bin:$PATH"
fi

if [[ -d "$HOME/.shorebird" ]]; then
  export PATH="/Users/vduseev/.shorebird/bin:$PATH"
fi

if which flutter &> /dev/null; then
  alias f="flutter"
  alias fr="flutter run"
  alias frd="flutter run --dart-define-from-file"
  alias fbr="flutter pub run build_runner build --delete-conflicting-outputs"
fi

__time_test "Done: Flutter"

# PostgreSQL

if [[ -d "/opt/homebrew/opt/libpq" ]]; then
  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi

__time_test "Done: PostgreSQL"

# --- Shell tools ------------------------------------------------------------

# Direnv
if which direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

__time_test "Done: Direnv"

# Starship
if which starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

__time_test "Done: Starship"

# Atuin
if which atuin &> /dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

__time_test "Done: Atuin"

# Nix
if [[ -d "/nix/var/nix/profiles/default/bin" ]]; then
  export PATH="/nix/var/nix/profiles/default/bin:$PATH"
fi
if [[ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]]; then
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

__time_test "Done: nix"

# --- Aliases ----------------------------------------------------------------

# Directory navigation
alias l="ls -lha"
alias ll="ls -lh"
alias tree="tree -a"

# Connections
alias ussh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# Git
alias g="git"

# Containers
alias p="podman"
alias pc="podman compose"
alias k="kubectl"
alias d="docker"
alias dc="docker compose"

__time_test "Done: Aliases"

# --- Load user supplied config ----------------------------------------------

if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

__time_test "Done: Local zshrc config"
