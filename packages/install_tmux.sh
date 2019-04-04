#!/usr/bin/env bash

TMUX_VERSION=2.8
LIBEVENT_VERSION=2.1.8
TMP=/tmp

# uninstall installed tmux
sudo apt-get remove -y tmux
sudo apt-get remove -y 'libevent-*'

# install libncurses
sudo apt-get install -y libncurses5-dev

# download source
mkdir -p $TMP
cd $TMP

if [[ ! -d "tmux-$TMUX_VERSION" ]]; then
    wget "https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/tmux-$TMUX_VERSION.tar.gz"
    tar xvzf "tmux-$TMUX_VERSION.tar.gz"
fi

if [[ ! -d "libevent-$LIBEVENT_VERSION-stable" ]]; then
    wget "https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION-stable/libevent-$LIBEVENT_VERSION-stable.tar.gz"
    tar xvzf "libevent-$LIBEVENT_VERSION-stable.tar.gz"
fi

# install libevent
cd "libevent-$LIBEVENT_VERSION-stable"
./configure && make
sudo make install
cd ..

# build tmux and install
cd "tmux-$TMUX_VERSION"
./configure && make
sudo make install
