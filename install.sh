#!/bin/bash

set -e

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

determine_script_location_dir

install_item() {
  local __item="$1"
  local __answer="n"

  COUNTER=$((COUNTER+1))
  read -p "${COUNTER}) Would you like to create symlink for ${__item} (y/N)? " __answer

  if [[ "$__answer" == "y" ]]; then
    echo "Creating symlink to '${SCRIPT_DIR}/${__item}' from '~/${__item}' ..."

    if ! ln -s "${SCRIPT_DIR}/${__item}" ~/"${__item}"; then
      echo ""
      read -p "Try to force create (ln -sf) the symlink and overwrite your existing file (y/N)? " __answer

      if [[ "$__answer" == "y" ]]; then
        echo "Force creating symlink ..."

        if ! ln -sf "${SCRIPT_DIR}/${__item}" ~/"${__item}"; then
          echo "Error: Could not create symlink ${__item}!"
        else
          echo "Symlink ${__item} has been created successfully"
        fi

      else
        echo "Skipping symlink ${__item} ..."
      fi

    else
      echo "Symlink ${__item} has been created successfully"
    fi

  else
    echo "Skipping symlink ${__item} ..."
  fi

  echo ""
}

main() {
  echo "This script will link individual files from dotfiles to your home directory"
  echo "and will prompt you before each script."
  echo ""

  install_item ".zshrc"
  install_item ".vimrc"
  install_item ".tmux.conf"
  install_item ".tmux"
  install_item ".alacritty.yml"
  install_item ".config/starship.toml"

  echo "Finished creating symlinks!"
}

main "$@"
