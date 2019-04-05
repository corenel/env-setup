#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

sudo apt-get install -y fcitx fcitx-googlepinyin fcitx-mozc ibus-qt4
sudo apt remove -y fcitx-ui-qimpanel 

status "Please switch 'keyboard input method system' to 'fcitx'"
status "in 'System Settings' -> 'Language Support'"
