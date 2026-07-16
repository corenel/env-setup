#!/usr/bin/env bash

if [ -z "${COMMON_SOURCED}" ]; then
  # shellcheck disable=SC1091
  source include/common.sh
fi

if [ -z "${SYSTEM_VARIABLES_SOURCED}" ]; then
  # shellcheck disable=SC1091
  source include/system_variables.sh
fi

ROBOT_SETUP_DIR=$HOME/.env-setup
ROBOT_SETUP_REPO=https://github.com/corenel/env-setup.git
NVIM_SETUP_REPO=https://github.com/corenel/ysvim.git
DOTFILE_BASEDIR=${ROBOT_SETUP_DIR}/dotfiles

symlink() {
  src=$1
  dst=$2

  if [ -e "${dst}" ]; then
    if [ -L "${dst}" ]; then
      # Already symlinked -- I'll assume correctly.
      return
    else
      # Rename files with a ".old" extension.
      echo "$dst already exists, renaming to $dst.old"
      backup=${dst}.old
      if [ -e "${backup}" ]; then
        echo "Error: $backup already exists. Please delete or rename it."
        exit 1
      fi
      mv -v "${dst}" "${backup}"
    fi
  fi
  ln -sfn "${src}" "${dst}"
}

herdr_is_running() {
  if ! command -v herdr >/dev/null 2>&1; then
    return 1
  fi

  herdr session list --json 2>/dev/null | grep -Eq '"running"[[:space:]]*:[[:space:]]*true'
}

link_herdr_config() {
  local SOURCE_DIR=$1
  local TARGET_DIR=$2

  if [ -L "${TARGET_DIR}" ]; then
    local LINK_TARGET
    LINK_TARGET=$(readlink "${TARGET_DIR}")

    if [ "${LINK_TARGET}" != "${SOURCE_DIR}" ]; then
      echo "Error: ${TARGET_DIR} is symlinked to ${LINK_TARGET}, not ${SOURCE_DIR}."
      echo "Refusing to replace an unrelated Herdr configuration directory."
      exit 1
    fi

    if herdr_is_running; then
      echo "Error: Herdr is running while ${TARGET_DIR} points into the dotfiles checkout."
      echo "Stop all Herdr sessions, then rerun the dotfile setup to migrate its runtime state."
      exit 1
    fi

    rm -v "${TARGET_DIR}"
    mkdir -p "${TARGET_DIR}"

    # The old directory link let Herdr write runtime state beside config.toml.
    # Move those entries into the new real directory before linking the config.
    (
      shopt -s dotglob nullglob
      for runtime_path in "${SOURCE_DIR}"/*; do
        if [ "$(basename "${runtime_path}")" = "config.toml" ]; then
          continue
        fi
        mv -v "${runtime_path}" "${TARGET_DIR}/" || exit 1
      done
    ) || exit 1
  elif [ -e "${TARGET_DIR}" ]; then
    if [ ! -d "${TARGET_DIR}" ]; then
      echo "Error: ${TARGET_DIR} already exists and is not a directory."
      exit 1
    fi
  else
    mkdir -p "${TARGET_DIR}"
  fi

  symlink "${SOURCE_DIR}/config.toml" "${TARGET_DIR}/config.toml"
}

link_xdg_config_dotfiles() {
  local BASE_DIR=$1
  local CONFIG_DIR="${BASE_DIR}/.config"
  local TARGET_CONFIG_DIR="${HOME}/.config"

  if [ ! -d "${CONFIG_DIR}" ]; then
    return
  fi

  if [ -e "${TARGET_CONFIG_DIR}" ] || [ -L "${TARGET_CONFIG_DIR}" ]; then
    if [ ! -d "${TARGET_CONFIG_DIR}" ]; then
      echo "Error: ${TARGET_CONFIG_DIR} already exists and is not a directory."
      exit 1
    fi
  else
    mkdir -p "${TARGET_CONFIG_DIR}"
  fi

  pushd "${CONFIG_DIR}" || exit 1
  for path in * .*; do
    case ${path} in
    . | ..)
      continue
      ;;
    esac

    if [ ! -e "${path}" ] && [ ! -L "${path}" ]; then
      continue
    fi

    case ${path} in
    herdr)
      link_herdr_config "${CONFIG_DIR}/${path}" "${TARGET_CONFIG_DIR}/${path}"
      ;;
    *)
      symlink "${CONFIG_DIR}/${path}" "${TARGET_CONFIG_DIR}/${path}"
      ;;
    esac
  done
  popd || exit 1
}

link_dotfiles() {
  local BASE_DIR=$1

  pushd "${BASE_DIR}" || exit 1
  for path in .*; do
    case ${path} in
    . | .. | .config)
      continue
      ;;
    *)
      symlink "${BASE_DIR}/${path}" "${HOME}/${path}"
      ;;
    esac
  done
  popd || exit 1
  link_xdg_config_dotfiles "${BASE_DIR}"
}

link_common_dotfiles() {
  # create symbol links from $basedir to $HOME
  pushd "${DOTFILE_BASEDIR}/common" || exit 1
  status "Creating symlinks..."
  for path in .*; do
    case ${path} in
    . | .. | .config | .git | .gitignore | .gitignore.example | .gitconfig.example | .ssh)
      continue
      ;;
    *)
      symlink "${DOTFILE_BASEDIR}/common/${path}" "${HOME}/${path}"
      ;;
    esac
  done
  popd || exit 1
  link_xdg_config_dotfiles "${DOTFILE_BASEDIR}/common"

  # init global gitconfig and gitignore
  cp -v "$DOTFILE_BASEDIR/common/.gitconfig.example" "$HOME/.gitconfig"
  cp -v "$DOTFILE_BASEDIR/common/.gitignore.example" "$HOME/.gitignore"

  # setup ssh key
  # cp -v -r "$DOTFILE_BASEDIR/.ssh" "$HOME/"
  # sudo chmod 0700 $HOME/.ssh/id_rsa
}

link_linux_dotfiles() {
  link_dotfiles "${DOTFILE_BASEDIR}/linux"
}

link_macos_dotfiles() {
  link_dotfiles "${DOTFILE_BASEDIR}/macos"
}

init_repo() {
  if confirmation "Install dotfiles in offline mode"; then
    # copy git repo
    if [ ! -d "${ROBOT_SETUP_DIR}" ]; then
      REPO_TOPLEVEL=$(git rev-parse --show-toplevel)
      cp -r -v "${REPO_TOPLEVEL}" "${ROBOT_SETUP_DIR}"
    fi
  else
    # clone or update git repo
    if [ -d "${ROBOT_SETUP_DIR}/.git" ]; then
      echo "Updating dotfiles using existing git..."
      cd "${ROBOT_SETUP_DIR}" || exit 1
      git pull --quiet --rebase origin master
      git submodule update --init --recursive --remote
    else
      echo "Checking out dotfiles using git..."
      rm -rf -v "${ROBOT_SETUP_DIR}"
      git clone --quiet --depth=1 "${ROBOT_SETUP_REPO}" "${ROBOT_SETUP_DIR}"
      git submodule update --init --recursive --remote
    fi
  fi
}

setup_nvim() {
  pushd /tmp || exit 1
  git clone -b refactor "${NVIM_SETUP_REPO}"
  pushd /tmp/ysvim || exit 1
  ./install_refactored.sh
  popd || exit 1
  popd || exit 1
}

confirm init_repo "Initialize dotfiles repo"
confirm link_common_dotfiles "Link common dotiles"

case $OS_TYPE in
  Linux*)
    confirm link_linux_dotfiles "Link dotiles for Linux"
    ;;
  Darwin*)
    confirm link_macos_dotfiles "Link dotiles for macOS"
    ;;
  *)
    echo "OS $OS_TYPE is not supported"
esac

confirm setup_nvim "Setup nvim"
