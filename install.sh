#!/bin/bash

set -e

COMPONENTS=('zsh', 'bash', 'vim', 'tmux', 'starship', 'ghostty', 'atuin', 'nix')
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
  local __source="$1"
  local __target="$2"

  # Variables
  local __answer="n"
  local __short_source="${__source/"${HOME}"/~}"
  local __short_target="${__target/"${HOME}"/~}"
  local __echo_prefix=""

  if [[ -n "$NESTED_LEVEL" ]]; then
    __echo_prefix="  "
  fi

  echo "${__echo_prefix}action: ln -s '${__short_source}' '${__short_target}'"

  # Check if target symlink contains a directory
  if [[ "${__target%/*}" != "$__target" ]]; then
    local __dir="${__target%/*}"
    # Create directory if it does not exit
    if [[ ! -d "${__dir}" ]]; then
      mkdir -p "${__dir}"
    fi
  fi

  # Capture exit code and any output
  local __soft_create_output=$(ln -s "$__source" "$__target" 2>&1)
  local __soft_create_exit_code=$?
  if [[ $__soft_create_exit_code -eq 0 ]]; then
    echo "${__echo_prefix}success: symlink ${__short_target} created"
    return
  else
    echo "${__echo_prefix}error: ${__soft_create_output}"
  fi

  read -p "${__echo_prefix}fix: would you like to force it (ln -sf)? (y/N) " __answer

  if [[ "$__answer" != "y" ]]; then
    echo "${__echo_prefix}cancelled"
    return
  fi

  local __force_create_output=$(ln -sf "${__source}" "${__target}" 2>&1)
  local __force_create_exit_code=$?
  if [[ $__force_create_exit_code -eq 0 ]]; then
    echo "${__echo_prefix}success: symlink ${__short_target} created with -f flag"
    return
  else
    echo "${__echo_prefix}error: ${__force_create_output}"
  fi

  echo "${__echo_prefix}skipping"
}

prompt_installation() {
  # Arguments
  local __name="$1"

  # Variables
  local __answer="n"

  COUNTER=$((COUNTER+1))
  read -p "${COUNTER}. Configure symlinks for ${__name}? (y/N) " __answer
  
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

  if [[ -d "${__target}" ]]; then
    echo "${__echo_prefix}error: ${__target} directory already exists"
    read -p "${__echo_prefix}fix: would you like to delete it? (y/N) " __answer
    if [[ "$__answer" == "y" ]]; then
      rm -rf "${__target}"
      return 0
    else
      return 1
    fi
    return 1
  fi
  return 0
}

clone_tmux() {
  local __echo_prefix=""
  if [[ -n "$NESTED_LEVEL" ]]; then
    __echo_prefix="  "
  fi
  echo "${__echo_prefix}action: git clone https://github.com/gpakosz/.tmux.git ${HOME}/.tmux"
  local __clone_output=$(git clone https://github.com/gpakosz/.tmux.git "${HOME}/.tmux" 2>&1)
  local __clone_exit_code=$?
  if [[ $__clone_exit_code -eq 0 ]]; then
    echo "${__echo_prefix}success: cloned https://github.com/gpakosz/.tmux.git"
  else
    echo "${__echo_prefix}error: ${__clone_output}"
  fi
}

echo_help() {
  echo "vduseev/dotfiles: symlink dotfiles to home directory"
  echo ""
  echo "  Usage: ./install.sh [component]"
  echo "  - prompt for each component: ${0}"
  echo "  - symlink specific component: ${0} zsh"
  echo ""
  echo "  Components: ${COMPONENTS[@]}"
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
        echo "error: unknown component ${__choice}. Choose from: ${COMPONENTS[@]}"
        exit 1
    esac
    exit 0
  fi

  echo_help

  echo "Starting step-by-step installation (Ctrl+C to exit, ENTER to skip):"

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
}

main "$@"
