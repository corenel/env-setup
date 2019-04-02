#!/usr/bin/env bash

PACKAGE=axel
VERSION=2.15
URL=https://github.com/axel-download-accelerator/axel/releases/download/v$VERSION/axel-$VERSION.tar.gz
TMP=$HOME/.tmp

# uninstall installed packages
sudo apt-get remove -y axel

# install dependencies
sudo apt-get install -y libssl-dev

# download source
if [[ -d $TMP ]]; then
    mkdir -p $TMP
fi
cd $TMP

if [[ ! -d "axel-$VERSION" ]]; then
    wget $URL
    tar xvf "axel-$VERSION.tar.gz"
fi

# build tmux and install
cd "axel-$VERSION"
./configure && make -j$nproc
sudo make install
