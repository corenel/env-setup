#!/usr/bin/env bash

sudo add-apt-repository -y ppa:papirus/papirus
sudo add-apt-repository -y ppa:noobslab/themes
sudo find /etc/apt/sources.list.d/ -type f -name "*.list" -exec sed -i.bak -r 's#deb(-src)?\s*http(s)?://ppa.launchpad.net#deb\1 http\2://launchpad.proxy.ustclug.org#ig' {} \;
sudo apt-get update
sudo apt-get install -y unity-tweak-tool \
  arc-flatabulous-theme \
  papirus-folders papirus-icon-theme
