# Default variables
export SHELL="bash"
export EDITOR="vim"
export VISUAL="vim"

# Use colors.
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Custom $PATH with extra locations.
export PATH=/bin:/sbin
export PATH=/usr/bin:/usr/sbin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Include alias file (if present) containing aliases for ssh, etc.
if [ -f ~/.bash_aliases ]
then
  source ~/.bash_aliases
fi

# Include function file (if present)
if [ -f ~/.bash_functions ]
then
  source ~/.bash_functions
fi

# Configure Homebrew
if [[ "$OSTYPE" =~ "darwin" ]]; then
  # Tell homebrew to not autoupdate every single time I run it (just once a week).
  #export HOMEBREW_AUTO_UPDATE_SECS=604800

  brew_prefix=`brew --prefix`
  if [ -f $brew_prefix/etc/bash_completion ]; then
    source $brew_prefix/etc/bash_completion
  fi
fi

# Turn on kubectl autocomplete.
#if [ -x "$(command -v kubectl)" ]; then
#  source <(kubectl completion bash)
#fi

# Use nvm.
#export NVM_DIR="$HOME/.nvm"
#if [ -f "$brew_prefix/opt/nvm/nvm.sh" ]; then
#  source "$brew_prefix/opt/nvm/nvm.sh"
#fi

# Add Java interpreter
#export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home "
#export PATH="$JAVA_HOME/bin:$PATH"

# Use rbenv.
if command -v "rbenv" > /dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# pyenv location
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize pyenv
# When pyenv is not initialized yet, the `type -t pyenv` command
# return file as a type for the pyenv executable.
# Contrary to that, when initialized, `type -t` for pyenv returns
# "function" as a type.
# This prevents pyenv from entering an infinite loop if initialization.
if [ -n "$(type -t pyenv)" ] && [ "$(type -t pyenv)" = "file" ]; then
  # If command exists, then init (hmmm... doesn't make much sense, does it?)
  if command -v "pyenv" > /dev/null 2>&1; then
    eval "$(pyenv init -)"
  fi
fi

# Initialize Poetry
#export PATH="$HOME/.poetry/bin:$PATH"

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

# Initialize tmuxinator auto-completion
if [ -f '$HOME/.lib/tmuxinator/tmuxinator.bash' ]; then
  source $HOME/.lib/tmuxinator/tmuxinator.bash
fi

export KUBECONFIG=$HOME/.kube/config
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi