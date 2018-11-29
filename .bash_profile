#
# .bash_profile
#
# @author Vagiz Duseev
# @see .inputrc
#

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

## Definition of the whole promt
#export PS1="${__BASH_PROMT_ROW_1}\n${__BASH_PROMT_ROW_2}"

# Initialize powerline
source /usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh

# Use colors.
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Custom $PATH with extra locations.
export PATH=/usr/local/bin:/usr/local/sbin:$HOME/bin:/usr/local/git/bin:$HOME/.composer/vendor/bin:$PATH

# PyEnv locations
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Add Java interpreter
export PATH="$HOME/.jvenv/versions/1.8.0_161/bin:$PATH"

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

# Include bashrc file (if present).
if [ -f ~/.bashrc ]
then
  source ~/.bashrc
fi

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Turn on Git autocomplete.
# brew_prefix=`brew --prefix`
brew_prefix='/usr/local'
if [ -f $brew_prefix/etc/bash_completion ]; then
  . $brew_prefix/etc/bash_completion
fi

# Turn on kubectl autocomplete.
if [ -x "$(command -v kubectl)" ]; then
  source <(kubectl completion bash)
fi

# Use nvm.
export NVM_DIR="$HOME/.nvm"
if [ -f "$brew_prefix/opt/nvm/nvm.sh" ]; then
  source "$brew_prefix/opt/nvm/nvm.sh"
fi

# Use rbenv.
if [ -f /usr/local/bin/rbenv ]; then
  eval "$(rbenv init -)"
fi

# Initialize pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

#shopt -s extdebug
#trap prod_command_trap DEBUG

