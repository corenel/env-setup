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
  if [ confirmation "Replace ubuntu-port sources" ]; then
    sudo sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
  fi

  if [ confirmation "Replace ubuntu sources" ]; then
    sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
  fi

  if [ confirmation "Replace debian sources" ]; then
    sudo sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
    sudo sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
  fi

  if [ confirmation "Replace launch ppa sources" ]; then
    sudo find /etc/apt/sources.list.d/ -type f -name "*.list" -exec sed -i.bak -r 's#deb(-src)?\s*http(s)?://ppa.launchpad.net#deb\1 http\2://launchpad.proxy.ustclug.org#ig' {} \;
  fi
}

enable_full_deb_repo() {
  sudo sed -i 's/#\ deb/deb/g' /etc/apt/sources.list
}

install_homebrew() {
  # install homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # use mirror repo for HomeBrew
  cd "$(brew --repo)" || return
  git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
  cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
  git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
  echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.bash_profile
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
