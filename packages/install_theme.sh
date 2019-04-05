#!/usr/bin/env bash


if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

install_unity_theme() {
  sudo add-apt-repository -y ppa:papirus/papirus
  sudo add-apt-repository -y ppa:noobslab/themes
  sudo find /etc/apt/sources.list.d/ -type f -name "*.list" -exec sed -i.bak -r 's#deb(-src)?\s*http(s)?://ppa.launchpad.net#deb\1 https://launchpad.proxy.ustclug.org#ig' {} \;
  sudo apt-get update
  sudo apt-get install -y \
    unity-tweak-tool \
    gnome-tweak-tool \
    arc-flatabulous-theme \
    papirus-folders papirus-icon-theme
}

install_gnome_terminal_theme() {
  bash -c  "$(wget -qO- https://git.io/vQgMr)"
}

confirm install_unity_theme "Install theme and icons for Unity"
confirm install_gnome_terminal_theme "Install theme for Gnome Terminal"
