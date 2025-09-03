#!/bin/bash

# Stop on error, unset variable, or a failed command in the pipeline
set -euo pipefail

COMPONENTS=('zsh' 'bash' 'vim' 'tmux' 'starship' 'ghostty' 'atuin' 'nix')
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

create_symlink() {
  # Arguments
  local __original="$1"
  local __link="$2"

  # Variables
  local __answer="n"
  local __short_original="${__original/"${HOME}"/~}"
  local __short_link="${__link/"${HOME}"/~}"
  local __echo_prefix=""

  if [[ -n "$NESTED_LEVEL" ]]; then
    __echo_prefix="  "
  fi

  echo "${__echo_prefix}action: ln -s '${__short_original}' '${__short_link}'"

  # Check if symlink contains a directory
  if [[ "${__link%/*}" != "$__link" ]]; then
    local __dir="${__link%/*}"
    # Create directory if it does not exit
    if [[ ! -d "${__dir}" ]]; then
      mkdir -p "${__dir}"
    fi
  fi

  # On Linux and MacOS: ln -s [point-to-this-target] [from-this-link]

  local __soft_create_output=$(ln -s "$__original" "$__link" 2>&1)
  if [[ -z "$__soft_create_output" ]]; then
    echo "${__echo_prefix}success: symlink ${__short_link} created"
    return
  fi

  echo "${__echo_prefix}error: ${__soft_create_output}"
  read -p "${__echo_prefix}>> fix: would you like to force-create the symlink (ln -sf)? (y/N) " __answer
  if [[ "$__answer" != "y" ]]; then
    echo "${__echo_prefix}[x] cancelled"
    return
  fi

  local __force_create_output=$(ln -sf "${__original}" "${__link}" 2>&1)
  if [[ -z "$__force_create_output" ]]; then
    echo "${__echo_prefix}success: symlink ${__short_link} created with -f flag"
    return
  fi

  echo "${__echo_prefix}error: ${__force_create_output}"
  echo "${__echo_prefix}[x] skipping"
}

prompt_installation() {
  # Arguments
  local __name="$1"

  # Variables
  local __answer="n"

  COUNTER=$((COUNTER+1))
  read -p ">> ${COUNTER}. configure symlinks for ${__name}? (y/N) " __answer
  
  if [[ "$__answer" == "y" ]]; then
    return 0
  else
    return 1
  fi
}

ensure_target_dir_does_not_exist() {
  local __target="$1"
  local __echo_prefix=""
  if [[ -n "$NESTED_LEVEL" ]]; then
    __echo_prefix="  "
  fi

  if [[ ! -d "${__target}" ]]; then
    return 0
  fi

  echo "${__echo_prefix}error: ${__target} directory already exists"
  read -p "${__echo_prefix}>> fix: would you like to delete it? (y/N) " __answer
  if [[ "$__answer" != "y" ]]; then
    return 1
  fi

  local __remove_dir_output=$(rm -rf "${__target}" 2>&1)
  if [[ -n "$__remove_dir_output" ]]; then
    echo "${__echo_prefix}error: ${__remove_dir_output}"
    return 1
  fi

  echo "${__echo_prefix}success: removed ${__target} directory"
  return 0
}

clone_tmux() {
  local __echo_prefix=""
  if [[ -n "$NESTED_LEVEL" ]]; then
    __echo_prefix="  "
  fi

  echo "${__echo_prefix}action: git clone https://github.com/gpakosz/.tmux.git ${HOME}/.tmux"
  local __clone_output=$(git clone --quiet https://github.com/gpakosz/.tmux.git "${HOME}/.tmux" 2>&1)
  if [[ -n "$__clone_output" ]]; then
    echo "${__echo_prefix}error: ${__clone_output}"
    return 1
  fi

  echo "${__echo_prefix}success: cloned https://github.com/gpakosz/.tmux.git"
}

echo_help() {
  echo "vduseev/dotfiles: symlink dotfiles to home directory"
  echo ""
  echo "  Usage: ./install.sh [option]"
  echo "  - prompt for each option: ${0}"
  echo "  - symlink specific option: ${0} zsh"
  echo ""
  echo "  Options: ${COMPONENTS[@]}"
  echo ""
}

main() {
  # Arguments
  local __choice="${1:-}"

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
      bash)
        create_symlink "${SCRIPT_DIR}/.bashrc" "${HOME}/.bashrc"
        create_symlink "${SCRIPT_DIR}/.bash_profile" "${HOME}/.bash_profile"
        ;;
      vim)
        create_symlink "${SCRIPT_DIR}/.vimrc" "${HOME}/.vimrc"
        ;;
      tmux)
        if ! ensure_target_dir_does_not_exist "${HOME}/.tmux"; then
          echo "error: can't proceed with existing ${HOME}/.tmux directory"
          exit 1
        fi
        clone_tmux
        create_symlink "${HOME}/.tmux/.tmux.conf" "${HOME}/.tmux.conf"
        create_symlink "${SCRIPT_DIR}/.tmux.conf.local" "${HOME}/.tmux.conf.local"
        ;;
      starship)
        create_symlink "${SCRIPT_DIR}/.config/starship.toml" "${HOME}/.config/starship.toml"
        ;;
      atuin)
        create_symlink "${SCRIPT_DIR}/.config/atuin" "${HOME}/.config/atuin"
        ;;
      ghostty)
        create_symlink "${SCRIPT_DIR}/.config/ghostty" "${HOME}/.config/ghostty"
        ;;
      nix)
        create_symlink "${SCRIPT_DIR}/.config/nix" "${HOME}/.config/nix"
        create_symlink "${SCRIPT_DIR}/.config/home-manager" "${HOME}/.config/home-manager"
        ;;
      *)
        echo "error: unknown option ${__choice}. Choose from: ${COMPONENTS[@]}"
        exit 1
    esac
    exit 0
  fi

  echo_help

  trap 'printf "\n[x] interrupted by user\n"; exit 0' SIGINT
  echo "Installing all options one-by-one (Ctrl+C to exit, ENTER to skip):"

  NESTED_LEVEL="1"

  if prompt_installation "zsh"; then
    create_symlink "${SCRIPT_DIR}/.zshrc" "${HOME}/.zshrc"
  fi
  if prompt_installation "bash"; then
    create_symlink "${SCRIPT_DIR}/.bashrc" "${HOME}/.bashrc"
    create_symlink "${SCRIPT_DIR}/.bash_profile" "${HOME}/.bash_profile"
  fi
  if prompt_installation "vim"; then
    create_symlink "${SCRIPT_DIR}/.vimrc" "${HOME}/.vimrc"
  fi
  if prompt_installation "tmux"; then
    if ! ensure_target_dir_does_not_exist "${HOME}/.tmux"; then
      echo "error: can't proceed with existing ${HOME}/.tmux directory"
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
    create_symlink "${SCRIPT_DIR}/.config/atuin" "${HOME}/.config/atuin"
  fi
  if prompt_installation "ghostty"; then
    create_symlink "${SCRIPT_DIR}/.config/ghostty" "${HOME}/.config/ghostty"
  fi
  if prompt_installation "nix"; then
    create_symlink "${SCRIPT_DIR}/.config/nix" "${HOME}/.config/nix"
    create_symlink "${SCRIPT_DIR}/.config/home-manager" "${HOME}/.config/home-manager"
  fi

  echo "Finished!"
  trap - SIGINT
}

main "$@"
