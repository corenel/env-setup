#!/usr/bin/env bash

sudo add-apt-repository -y ppa:nilarimogard/webupd8
sudo find /etc/apt/sources.list.d/ -type f -name "*.list" -exec sed -i.bak -r 's#deb(-src)?\s*http(s)?://ppa.launchpad.net#deb\1 https://launchpad.proxy.ustclug.org#ig' {} \;
sudo apt-get update
sudo apt-get install -y \
  syspeek
  # classicmenu-indicator \
