#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

if [ -z $SYSTEM_VARIABLES_SOURCED ]; then
  source include/system_variables.sh
fi

update_apt() {
  # Automatically update keys
  status 'Update apt-key...'
  sudo apt-key update

  # Automatically clean
  status 'Clean apt packages...'
  sudo apt-get clean

  status 'Update apt package list...'
  sudo apt-get update

  status 'Upgrade apt packages...'
  sudo apt-get upgrade -y

  status 'Remove apt unnecessary packages...'
  sudo apt-get -y autoremove --allow-unauthenticated
}

use_mirror_sources() {

  SOURCES_LIST_PATH="/etc/apt/sources.list"

  if confirmation "Replace ubuntu-port sources"; then
    sudo sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' "$SOURCES_LIST_PATH"
  fi

  if confirmation "Replace ubuntu sources"; then
    sudo sed -i 's/http:\/\/.*archive.ubuntu.com/http:\/\/mirrors.ustc.edu.cn/g' "$SOURCES_LIST_PATH"
    sudo sed -i 's/http:\/\/.*security.ubuntu.com/http:\/\/mirrors.ustc.edu.cn/g' "$SOURCES_LIST_PATH"
  fi

  if confirmation "Replace debian sources"; then
    sudo sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' "$SOURCES_LIST_PATH"
    sudo sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' "$SOURCES_LIST_PATH"
  fi

  if  confirmation "Add debian backports sources"; then
    if ! grep -q "stretch-backport" "$SOURCES_LIST_PATH"; then
      echo 'deb http://mirrors.ustc.edu.cn/debian/ stretch-backports main contrib non-free' | sudo tee -a "$SOURCES_LIST_PATH"
      echo 'deb-src http://mirrors.ustc.edu.cn/debian/ stretch-backports main contrib non-free' | sudo tee -a "$SOURCES_LIST_PATH"
    fi
  fi

  if confirmation "Add debian updates sources"; then
    if ! grep -q stretch-updates "$SOURCES_LIST_PATH"; then
      echo 'deb http://mirrors.ustc.edu.cn/debian/ stretch-updates main contrib non-free' | sudo tee -a "$SOURCES_LIST_PATH"
      echo 'deb-src http://mirrors.ustc.edu.cn/debian/ stretch-updates main contrib non-free' | sudo tee -a "$SOURCES_LIST_PATH"
    fi
  fi

  # if confirmation "Replace launch ppa sources"; then
  #   sudo apt-get install -y apt-transport-https
  #   sudo find /etc/apt/sources.list.d/ -type f -name "*.list" -exec sed -i.bak -r 's#deb(-src)?\s*http(s)?://ppa.launchpad.net#deb\1 https://launchpad.proxy.ustclug.org#ig' {} \;
  # fi

  if confirmation "Use https USTC mirror"; then
    sudo apt-get install -y apt-transport-https
    sudo sed -i 's/http:\/\/mirrors.ustc.edu.cn/https:\/\/mirrors.ustc.edu.cn/' "$SOURCES_LIST_PATH"
  fi
}

enable_full_deb_repo() {
  sudo sed -i 's/#\ deb/deb/g' /etc/apt/sources.list
}

install_homebrew() {
  # install homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # use mirror repo for HomeBrew
  git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
  git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
  brew update
  echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.bash_profile
  source ~/.bash_profile

  brew update
}

case $OS_TYPE in
  Linux*)
    confirm enable_full_deb_repo "Enable all deb repo (include source)"
    confirm use_mirror_sources "Replace APT and PPA repo to china mirror"
    confirm update_apt "Update package list and upgrade"
    ;;
  Darwin*)
    confirm install_homebrew "Install HomeBrew as package manager"
    ;;
  *)
    echo "OS $OS_TYPE is not supported"
esac
