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

# --- General ----------------------------------------------------------------

export PATH="/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin"
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

# Add Homebrew path on MacOS
export PATH="/opt/homebrew/bin:${PATH}"

# --- Individual history for each terminal window ----------------------------

# Use arrows to scroll local history
bindkey "${key[Up]}" up-line-or-local-history
bindkey "${key[Down]}" down-line-or-local-history

up-line-or-local-history() {
  zle set-local-history 1
  zle up-line-or-history
  zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
  zle set-local-history 1
  zle down-line-or-history
  zle set-local-history 0
}
zle -N down-line-or-local-history

# --- Complimentary terminal tools -------------------------------------------

# Starship
if which starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# Atuin
if which atuin &> /dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# 1Password
if [[ -f "$HOME/.config/op/plugins.sh" ]]; then
  source "$HOME/.config/op/plugins.sh"
fi

# --- Languages & Technologies -----------------------------------------------

# Pyenv
if which pyenv &> /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  # eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  export ZSH_PYENV_VIRTUALENV=false
fi

# uv
if which uv &> /dev/null; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Node
if [[ -d "/opt/homebrew/opt/nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
fi

# Bun
if [[ -d "$HOME/.bun/bin" ]]; then
  export PATH="$HOME/.bun/bin:$PATH"  
fi

# Ruby
if which rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi

# Rust
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# Java
if [[ -d "/opt/homebrew/opt/openjdk/bin" ]]; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi

# Flutter
if [[ -d "$HOME/Projects/flutter/flutter/bin" ]]; then
  export PATH="$HOME/Projects/flutter/flutter/bin:$PATH"
  export PATH="$HOME/.pub-cache/bin:$PATH"
fi
if [[ -d "$HOME/.shorebird" ]]; then
  export PATH="/Users/vduseev/.shorebird/bin:$PATH"
fi

# PostgreSQL: psql without full database
if [[ -d "/opt/homebrew/opt/libpq" ]]; then
  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi

# --- Functions --------------------------------------------------------------

listeners() {
  if [[ $# -ne 1 ]]; then
    echo "Error: port number is required for listeners command"
    exit 1
  fi
  local __port="$1"
  if which sw_vers &> /dev/null; then
    # If MacOS X
    lsof -nP -iTCP -sTCP:LISTEN | grep "$__port"
  elif which netstat &> /dev/null; then
    # Linux
    netstat -plunt "$__port"
  else
    echo "Error: cannot find correct executable to find port listeners"
  fi
}

# --- Aliases ----------------------------------------------------------------

# Directory navigation
alias ll="ls -lha"

# Connections
alias ussh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# Git
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short"
alias gpft="git push --follow-tags"

# Containers
alias d="docker"
alias dc="docker compose"
alias k="kubectl"
alias p="podman"

# Other
alias dr="doppler run --"
alias f="flutter"
alias fr="flutter run"
alias frd="flutter run --dart-define-from-file"
alias fbr="flutter pub run build_runner build --delete-conflicting-outputs"

# --- Load user supplied config ----------------------------------------------

if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
