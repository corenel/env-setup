#!/usr/bin/env bash

tmux_ver=2.6
libevent_ver=2.1.8
TMP=$HOME/.tmp

# uninstall installed tmux
sudo apt-get remove -y tmux
sudo apt-get remove -y 'libevent-*'

# install libncurses
sudo apt-get install -y libncurses5-dev

# download source
mkdir -p $TMP
cd $TMP

if [[ ! -d "tmux-$tmux_ver" ]]; then
    wget "https://github.com/tmux/tmux/releases/download/$tmux_ver/tmux-$tmux_ver.tar.gz"
    tar xvzf "tmux-$tmux_ver.tar.gz"
fi

if [[ ! -d "libevent-$libevent_ver-stable" ]]; then
    wget "https://github.com/libevent/libevent/releases/download/release-$libevent_ver-stable/libevent-$libevent_ver-stable.tar.gz"
    tar xvzf "libevent-$libevent_ver-stable.tar.gz"
fi

# install libevent
cd "libevent-$libevent_ver-stable"
./configure && make -j$nproc
sudo make install
cd ..

# build tmux and install
cd "tmux-$tmux_ver"
./configure && make -j$nproc
sudo make install
