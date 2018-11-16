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

# Source powerline
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

# Syntax-highlight code for copying and pasting.
# Requires highlight (`brew install highlight`).
function pretty() {
  pbpaste | highlight --syntax=$1 -O rtf | pbcopy
}

# Git aliases.
alias gs='git status'
alias gc='git commit'
alias gp='git pull --rebase'
alias gcam='git commit -am'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Git upstream branch syncer.
# Usage: gsync master (checks out master, pull upstream, push origin).
function gsync() {
  if [[ ! "$1" ]] ; then
      echo "You must supply a branch."
      return 0
  fi

  BRANCHES=$(git branch --list $1)
  if [ ! "$BRANCHES" ] ; then
     echo "Branch $1 does not exist."
     return 0
  fi

  git checkout "$1" && \
  git pull upstream "$1" && \
  git push origin "$1"
}

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

# Super useful Docker container oneshots.
# Usage: dockrun, or dockrun [centos7|fedora27|debian9|debian8|ubuntu1404|etc.]
dockrun() {
  docker run -it geerlingguy/docker-"${1:-ubuntu1604}"-ansible /bin/bash
}

# Enter a running Docker container.
function denter() {
  if [[ ! "$1" ]] ; then
      echo "You must supply a container ID or name."
      return 0
  fi

  docker exec -it $1 bash
  return 0
}

# Docker image visualization (usage: `dockviz images -t`).
alias dockviz="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"

# Delete a given line number in the known_hosts file.
knownrm() {
  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
    echo "error: line number missing" >&2;
  else
    sed -i '' "$1d" ~/.ssh/known_hosts
  fi
}

# Ask for confirmation when 'prod' is in a command string.
prod_command_trap () {
  if [[ $BASH_COMMAND == *prod* ]]
  then
    read -p "Are you sure you want to run this command on prod [Y/n]? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      echo -e "\nRunning command \"$BASH_COMMAND\" \n"
    else
      echo -e "\nCommand was not run.\n"
      return 1
    fi
  fi
}

shopt -s extdebug
trap prod_command_trap DEBUG

