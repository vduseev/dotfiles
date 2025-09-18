# Bash Configuration
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
export SHELL="bash"
export EDITOR="vim"
export VISUAL="vim"

# Language for compatibility with Mosh
# See: https://github.com/mobile-shell/mosh/issues/793#issuecomment-368755189
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# --- Prompt -----------------------------------------------------------------

# Use colors.
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Nicer prompt.
# \d - current day of the week
# \t - current time in 24h format
# \u - current user
# \h - hostname
# \w - current working directory
## Definition of promt colors
## https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
LIGHT_GREEN="\[\e[1;32m\]"
YELLOW="\[\e[1;33m\]"
RED="\[\e[0;31m\]"
LIGHT_BLUE="\[\e[1;34m\]"
LIGHT_GRAY="\[\e[0;37m\]"
LIGHT_CYAN="\[\e[1;36m\]"
NC="\[\e[0m\]" # no color

## Definition of promt segments
__BASH_PROMT_LOGO="\[\]"
__BASH_PROMT_DATETIME="${LIGHT_GREEN}\t (\d)"
__BASH_PROMT_GIT="${LIGHT_CYAN}\$(git branch 2>/dev/null | sed -n 's/* \(.*\)/\1 /p')"
__BASH_PROMT_USER_LOCATION="${YELLOW}\u ${RED}on ${LIGHT_BLUE}\h ${RED}at ${LIGHT_GRAY}\w"
__BASH_PROMT_SYMBOL="$"

## Definition of rows
__BASH_PROMT_ROW_1="${NC}┌─${__BASH_PROMT_DATETIME} ${__BASH_PROMT_USER_LOCATION} ${__BASH_PROMT_GIT}"
__BASH_PROMT_ROW_2="${NC}└─${__BASH_PROMT_SYMBOL} "

# Definition of the whole promt
export PS1="${__BASH_PROMT_ROW_1}\n${__BASH_PROMT_ROW_2}"

# --- Nix --------------------------------------------------------------------

if [[ -d "$HOME/.nix-profile" ]]; then
  # Expose nix binaries
  if [[ -d "$HOME/.nix-profile/bin" ]]; then
    export PATH="$HOME/.nix-profile/bin:$PATH"
  fi

  # Load nix profile settings
  if [[ -d "$HOME/.nix-profile/etc/profile.d" ]]; then
    for nix_profile_file in "$HOME/.nix-profile/etc/profile.d"/*.sh; do
      if [[ -f "$nix_profile_file" ]]; then
        source "$nix_profile_file"
      fi
    done
  fi
fi

# --- Complimentary terminal tools -------------------------------------------

# Starship
if which starship &> /dev/null; then
    eval "$(starship init bash)"
fi

# Atuin
if which atuin &> /dev/null; then
  eval "$(atuin init bash --disable-up-arrow)"
fi

# --- Languages & Technologies -----------------------------------------------

if [[ -f "$HOME/.kube/config" ]]; then
  export KUBECONFIG=$HOME/.kube/config
fi

# uv
if which uv &> /dev/null; then
   export PATH="$HOME/.local/bin:$PATH"
fi

# Rust
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# Flutter
if [[ -d "$HOME/projects/flutter/flutter/bin" ]]; then
    export PATH="$HOME/projects/flutter/flutter/bin:$PATH"
    export PATH="$HOME/.pub-cache/bin:$PATH"
fi
if [[ -d "$HOME/.shorebird" ]]; then
    export PATH="$HOME/.shorebird/bin:$PATH"
fi

# --- Aliases ----------------------------------------------------------------

# Directory navigation
alias ll="ls -lha"

# Connections
alias ussh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# Git
alias g="git"

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

if [[ -f "$HOME/.bashrc.local" ]]; then
  source "$HOME/.bashrc.local"
fi
