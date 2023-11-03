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

# --- Oh My Zsh ---------------------------------------------------------------

# Path to your oh-my-zsh installation.
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    export ZSH="$HOME/.oh-my-zsh"
    source $ZSH/oh-my-zsh.sh
fi

# --- General -----------------------------------------------------------------

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

# --- Individual history for each terminal window -----------------------------

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

# --- Themes ------------------------------------------------------------------

ZSH_THEME="robbyrussell"

# --- Plugins -----------------------------------------------------------------

plugins=(git)

# Starship
if which starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Pyenv
if which pyenv &> /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# Ruby
if which rbenv &> /dev/null; then
    eval "$(rbenv init -)"
fi

# EdgeDB
if [[ -d "$HOME/.edgedb/bin" ]]; then
    export PATH="$HOME/.edgedb/bin:$PATH"
fi

# Rust
if [[ -d "$HOME/.cargo/bin" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Nvm
if [[ -d "/opt/homebrew/opt/nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
fi

# --- Functions ---------------------------------------------------------------

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

# --- Aliases -----------------------------------------------------------------

# Directory navigation
alias ll="ls -lha"

# Docker and kubernetes
alias d="docker"
alias dc="docker compose"
alias k="kubectl"

# Git
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gpft="git push --follow-tags"

# Infrastructure as code
alias tf="terraform"

# Terminal
alias mux="tmuxinator"

# Connections
alias ussh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# --- Load user supplied config -----------------------------------------------

if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi


## [Completion] 
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/vduseev/.dart-cli-completion/zsh-config.zsh ]] && . /Users/vduseev/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

