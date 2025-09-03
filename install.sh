#!/bin/bash

# Stop on error, unset variable, or a failed command in the pipeline
set -euo pipefail

# Capture Ctrl+C and exit gracefully
trap 'printf "\n[x] interrupted by user\n"; exit 0' SIGINT

COMPONENTS=('zsh' 'bash' 'vim' 'tmux' 'starship' 'ghostty' 'atuin' 'nix' 'git')
SCRIPT_DIR=""
COUNTER=0
NESTED_LEVEL=""

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

  # Check if symlink target is within a directory (but not if the link itself ends with /)
  if [[ "${__link%/*}" != "$__link" && "${__link}" != */ ]]; then
    local __dir="${__link%/*}"
    # Create directory if it does not exit
    if [[ ! -d "${__dir}" ]]; then
      echo "${__echo_prefix}warning: directory ${__dir} does not exist, creating it"
      echo "${__echo_prefix}action: mkdir -p '${__dir}'"
      local __mkdir_output=$(mkdir -p "${__dir}" 2>&1)
      if [[ -z "$__mkdir_output" ]]; then
        echo "${__echo_prefix}success: directory ${__dir} created"
      else
        echo "${__echo_prefix}error: ${__mkdir_output}"
        exit 1
      fi
    fi
  fi

  # On Linux and MacOS: ln -s [point-to-this-target] [from-this-link]

  local __soft_create_output=$(ln -s "$__original" "$__link" 2>&1)
  if [[ -z "$__soft_create_output" ]]; then
    echo "${__echo_prefix}success: symlink ${__short_link} created"
    return
  fi

  echo "${__echo_prefix}error: ${__soft_create_output}"
  read -p "${__echo_prefix}>> fix: would you like to force-create ${__short_link} (ln -sf)? (y/N) " __answer
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
    return
  fi

  echo "${__echo_prefix}error: ${__target} directory already exists"
  read -p "${__echo_prefix}>> fix: would you like to delete it? (y/N) " __answer
  if [[ "$__answer" == "y" ]]; then
    local __remove_dir_output=$(rm -rf "${__target}" 2>&1)
    if [[ -z "$__remove_dir_output" ]]; then
      echo "${__echo_prefix}success: removed ${__target} directory"
      return
    else
      echo "${__echo_prefix}error: ${__remove_dir_output}"
      exit 1
    fi
  else
    echo "${__echo_prefix}error: can't proceed with existing ${__target} directory"
    exit 1
  fi
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

install_zsh() {
  create_symlink "${SCRIPT_DIR}/.zshrc" "${HOME}/.zshrc"
}

install_bash() {
  create_symlink "${SCRIPT_DIR}/.bashrc" "${HOME}/.bashrc"
  create_symlink "${SCRIPT_DIR}/.bash_profile" "${HOME}/.bash_profile"
}

install_vim() {
  create_symlink "${SCRIPT_DIR}/.vimrc" "${HOME}/.vimrc"
}

install_tmux() {
  ensure_target_dir_does_not_exist "${HOME}/.tmux"
  clone_tmux
  create_symlink "${HOME}/.tmux/.tmux.conf" "${HOME}/.tmux.conf"
  create_symlink "${SCRIPT_DIR}/.tmux.conf.local" "${HOME}/.tmux.conf.local"
}

install_starship() {
  create_symlink "${SCRIPT_DIR}/.config/starship.toml" "${HOME}/.config/starship.toml"
}

install_atuin() {
  create_symlink "${SCRIPT_DIR}/.config/atuin/config.toml" "${HOME}/.config/atuin/config.toml"
}

install_ghostty() {
  create_symlink "${SCRIPT_DIR}/.config/ghostty/config" "${HOME}/.config/ghostty/config"
}

install_nix() {
  create_symlink "${SCRIPT_DIR}/.config/nix/nix.conf" "${HOME}/.config/nix/nix.conf"
  create_symlink "${SCRIPT_DIR}/.config/home-manager/flake.nix" "${HOME}/.config/home-manager/flake.nix"
  create_symlink "${SCRIPT_DIR}/.config/home-manager/home.nix" "${HOME}/.config/home-manager/home.nix"
}

install_git() {
  create_symlink "${SCRIPT_DIR}/.gitconfig" "${HOME}/.gitconfig"
}

main() {
  # Arguments
  local __choice="${1:-}"

  determine_script_location_dir

  # Check installation argument
  if [[ -n "${__choice}" ]]; then
    case "${__choice}" in
      help | h | --help | -h | -help)
        echo_help;;
      zsh)
        install_zsh;;
      bash)
        install_bash;;
      vim)
        install_vim;;
      tmux)
        install_tmux;;
      starship)
        install_starship;;
      atuin)
        install_atuin;;
      ghostty)
        install_ghostty;;
      nix)
        install_nix;;
      git)
        install_git;;
      *)
        echo "error: unknown option ${__choice}. Choose from: ${COMPONENTS[@]}"
        exit 1
    esac
    exit 0
  fi

  echo_help
  echo "Installing all options one-by-one (Ctrl+C to exit, ENTER to skip):"

  NESTED_LEVEL="1"

  if prompt_installation "zsh"; then
    install_zsh
  fi
  if prompt_installation "bash"; then
    install_bash
  fi
  if prompt_installation "vim"; then
    install_vim
  fi
  if prompt_installation "tmux"; then
    install_tmux
  fi
  if prompt_installation "starship"; then
    install_starship
  fi
  if prompt_installation "atuin"; then
    install_atuin
  fi
  if prompt_installation "ghostty"; then
    install_ghostty
  fi
  if prompt_installation "nix"; then
    install_nix
  fi
  if prompt_installation "git"; then
    install_git
  fi

  echo "Finished!"
}

main "$@"
