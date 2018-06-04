#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

if [ -z $SYSTEM_VARIABLES_SOURCED ]; then
  source include/system_variables.sh
fi

ROBOT_SETUP_DIR=$HOME/.env-setup
ROBOT_SETUP_REPO=git@github.com:corenel/env-setup.git
NVIM_SETUP_REPO=git@github.com:corenel/ysvim.git
DOTFILE_BASEDIR=${ROBOT_SETUP_DIR}/dotfiles

symlink() {
  src=$1
  dst=$2

  if [ -e ${dst} ]; then
    if [ -L ${dst} ]; then
      # Already symlinked -- I'll assume correctly.
      return
    else
      # Rename files with a ".old" extension.
      echo "$dst already exists, renaming to $dst.old"
      backup=${dst}.old
      if [ -e ${backup} ]; then
        echo "Error: $backup already exists. Please delete or rename it."
        exit 1
      fi
      mv -v ${dst} ${backup}
    fi
  fi
  ln -sf ${src} ${dst}
}

link_dotfiles() {
  local BASE_DIR=$1

  pushd ${BASE_DIR}
  for path in .*; do
    case ${path} in
    . | .. )
      continue
      ;;
    *)
      symlink ${BASE_DIR}/${path} $HOME/${path}
      ;;
    esac
  done
  popd
}

link_common_dotfiles() {
  # create symbol links from $basedir to $HOME
  pushd ${DOTFILE_BASEDIR}/common
  status "Creating symlinks..."
  for path in .*; do
    case ${path} in
    . | .. | .git | .gitignore | .gitignore.example | .gitconfig.example | .ssh)
      continue
      ;;
    *)
      symlink ${DOTFILE_BASEDIR}/common/${path} $HOME/${path}
      ;;
    esac
  done
  popd

  # init global gitconfig and gitignore
  cp -v "$DOTFILE_BASEDIR/common/.gitconfig.example" "$HOME/.gitconfig"
  cp -v "$DOTFILE_BASEDIR/common/.gitignore.example" "$HOME/.gitignore"

  # setup ssh key
  # cp -v -r "$DOTFILE_BASEDIR/.ssh" "$HOME/"
  # sudo chmod 0700 $HOME/.ssh/id_rsa
}

link_linux_dotfiles() {
  link_dotfiles ${DOTFILE_BASEDIR}/linux
}

link_macos_dotfiles() {
  link_dotfiles ${DOTFILE_BASEDIR}/macos
}

init_repo() {
  if confirmation "Install dotfiles in offline mode"; then
    # copy git repo
    if [ ! -d ${ROBOT_SETUP_DIR} ]; then
      REPO_TOPLEVEL=$(git rev-parse --show-toplevel)
      cp -r -v ${REPO_TOPLEVEL} ${ROBOT_SETUP_DIR}
    fi
  else
    # clone or update git repo
    if [ -d ${ROBOT_SETUP_DIR}/.git ]; then
      echo "Updating dotfiles using existing git..."
      cd ${ROBOT_SETUP_DIR}
      git pull --quiet --rebase origin master
      git submodule update --init --recursive --remote
    else
      echo "Checking out dotfiles using git..."
      rm -rf -v ${ROBOT_SETUP_DIR}
      git clone --quiet --depth=1 ${ROBOT_SETUP_REPO} ${ROBOT_SETUP_DIR}
      git submodule update --init --recursive --remote
    fi
  fi
}

setup_nvim() {
  pushd /tmp
  git clone $NVIM_SETUP_REPO
  pushd /tmp/ysvim
  ./install.sh
  popd
  popd
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
