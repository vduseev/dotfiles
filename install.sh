#!/bin/bash

set -e

COMPONENTS=('zsh', 'vim', 'tmux', 'starship')
SCRIPT_DIR=""
COUNTER=0

determine_script_location_dir() {
    local __source="${BASH_SOURCE[0]}"
    # resolve $__source until the file is no longer a symlink
    while [ -h "$__source" ]; do
        SCRIPT_DIR="$( cd -P "$( dirname "$__source" )" >/dev/null 2>&1 && pwd )"
        __source="$(readlink "$__source")"
        # if $__source was a relative symlink, we need to resolve it relative
        # to the path where the symlink file was located
        [[ $__source != /* ]] && __source="$SCRIPT_DIR/$__source"
    done
    SCRIPT_DIR="$( cd -P "$( dirname "$__source" )" >/dev/null 2>&1 && pwd )"
}

ensure_target_does_not_exist() {
  # Arguments
  local __target="$1"

  # Variables
  local __answer="n"
  local __short_target="${__target/"${HOME}"/~}"

  if [[ ! -e "${__target}" ]]; then
    return 0
  fi

  echo ""
  echo "Can't proceed. File or directory already exists at ${__short_target}."

  read -p "Would you like to back it up (b), delete it (d), or skip (N)? (r/d/N) " __answer
  if [[ "$__answer" == "b" ]]; then
    mv "${__target}" "${__target}.bckp" 
    echo "Renamed ${__short_target} to ${__short_target}.bckp successfully."
    return 0
  fi

  if [[ "$__answer" == "d" ]]; then
    rm -rf "${__target}"
    echo "Removed existing ${__short_target} successfully."
    return 0
  fi

  return 1
}

create_symlink() {
  # Arguments
  local __source="$1"
  local __target="$2"

  # Variables
  local __answer="n"
  local __short_source="${__source/"${HOME}"/~}"
  local __short_target="${__target/"${HOME}"/~}"

  echo "Creating a symlink at '${__short_target}' pointing to '${__short_source}' ..."

  # Check that target does not already exists
  if ! ensure_target_does_not_exist "${__target}"; then
    echo "Skipping ${__short_target} symlink because the file already exists."
    return
  fi

  # Check if target symlink contains a directory
  if [[ "${__target%/*}" != "$__target" ]]; then
    local __dir="${__target%/*}"
    # Create directory if it does not exit
    if [[ ! -d "${__dir}" ]]; then
      echo "Directory '${__dir}' does not exist. Creating it ..."
      mkdir -p "${__dir}"
    fi
  fi

  if ln -s "$__source" "$__target"; then
    echo "Symlink at ${__short_target} has been created successfully!"
    echo ""
    return
  fi

  read -p "Failed to soft create a symlink at '${__short_target}'. Would you like to try to force create it (ln -sf)? (y/N) " __answer

  if [[ "$__answer" != "y" ]]; then
    echo "Cancelling installation of the current item. User refused to force create a symlink at ${__short_target} ..."
    return
  fi

  echo "Force creating symlink ..."

  if ! ln -sf "${__source}" "${__target}"; then
    echo "Error: Could not create symlink at ${__short_target}!"
  else
    echo "Symlink ${__short_target} has been created successfully!"
    echo ""
  fi
}

prompt_installation() {
  # Arguments
  local __name="$1"

  # Variables
  local __answer="n"

  COUNTER=$((COUNTER+1))
  read -p "${COUNTER}) Would you like to set up ${__name}? (y/N) " __answer
  
  if [[ "$__answer" == "y" ]]; then
    echo "${__name} will be installed now ..."
    return 0
  else
    echo "Skipping installation of ${__name} ..."
    return 1
  fi
}

clone_tmux() {
  echo "Cloning .tmux configuration from https://github.com/gpakosz/.tmux.git ..."
  git clone https://github.com/gpakosz/.tmux.git "${HOME}/.tmux"
  echo "Successfully cloned .tmux configuration"
}

echo_help() {
  echo "This script will install and link individual items from dotfiles "
  echo "to your home directory and will prompt you at each step."
  echo ""
  echo "If you wish to install a single item, specify it as an argument "
  echo "to this script. For example: ./install.sh zsh"
  echo ""
  echo "Available config items to install: ${COMPONENTS[@]}"
  echo ""
}

main() {
  # Arguments
  local __choice="$1"

  determine_script_location_dir

  # Check installation argument
  if [[ -n "${__choice}" ]]; then
    case "${__choice}" in
      help | h | --help | -h | -help)
        echo_help
        ;;
      zsh)
        create_symlink "${SCRIPT_DIR}/.zshrc" "${HOME}/.zshrc"
        ;;
      vim)
        create_symlink "${SCRIPT_DIR}/.vimrc" "${HOME}/.vimrc"
        ;;
      tmux)
        if ! ensure_target_does_not_exist "${HOME}/.tmux"; then
          exit 1
        fi
        clone_tmux
        create_symlink "${HOME}/.tmux/.tmux.conf" "${HOME}/.tmux.conf"       
        ;;
      alacritty)
        create_symlink "${SCRIPT_DIR}/.config/alacritty/alacritty.toml" "${HOME}/.config/alacritty/alacritty.toml"
        create_symlink "${SCRIPT_DIR}/.config/alacritty/alacritty.base.toml" "${HOME}/.config/alacritty/alacritty.base.toml"
        ;;
      starship)
        create_symlink "${SCRIPT_DIR}/.config/starship.toml" "${HOME}/.config/starship.toml"
        ;;
      atuin)
        create_symlink "${SCRIPT_DIR}/.config/atuin/config.toml" "${HOME}/.config/atuin/config.toml"
        ;;
      *)
        echo "Unknown installation option: ${__choice}. Choose from: ${COMPONENTS[@]}"
        exit 1
    esac
    exit 0
  fi

  echo_help

  if prompt_installation "zsh"; then
    create_symlink "${SCRIPT_DIR}/.zshrc" "${HOME}/.zshrc"
  fi
  if prompt_installation "vim"; then
    create_symlink "${SCRIPT_DIR}/.vimrc" "${HOME}/.vimrc"
  fi
  if prompt_installation "tmux"; then
    if ! ensure_target_does_not_exist "${HOME}/.tmux"; then
      exit 1
    fi
    clone_tmux
    create_symlink "${HOME}/.tmux/.tmux.conf" "${HOME}/.tmux.conf"       
    create_symlink "${SCRIPT_DIR}/.tmux.conf.local" "${HOME}/.tmux.conf.local"
  fi
  if prompt_installation "starship"; then
    create_symlink "${SCRIPT_DIR}/.config/starship.toml" "${HOME}/.config/starship.toml"
  fi
  if prompt_installation "atuin"; then
    create_symlink "${SCRIPT_DIR}/.config/atuin/config.toml" "${HOME}/.config/atuin/config.toml"
  fi

  echo "Finished!"
}

main "$@"
