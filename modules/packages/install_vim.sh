#!/usr/bin/env bash

version="v8.0.1241"

# install dependencies
sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git \
    ruby-dev libperl-dev liblua5.1-0-dev luajit libluajit-5.1-2

# (Optional) use checkinstall to be able to easily uninstall vim
sudo apt-get install checkinstall

# remove installed vim
sudo apt-get remove --purge vim vim-runtime gvim vim-gnome vim-tiny vim-gui-common
sudo rm -rf /usr/local/share/vim /usr/bin/vim

# get vim source
mkdir -p $HOME/.tmp
cd $HOME/.tmp
wget "https://github.com/vim/vim/archive/$version.tar.gz"
tar -xvf "$version.tar.gz"

# if ./configure is failed due to lua, try symbol link manually
sudo ln -s /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 /usr/lib/x86_64-linux-gnu/libluajit-5.1.so
sudo ln -s /usr/include/lua5.1 /usr/include/lua

# build vim with python3 and lua support
cd "$version"
./configure --with-features=huge \
            --prefix=/usr/local \
            --enable-multibyte \
            --enable-largefile \
            --enable-gui=auto \
            --enable-cscope \
            --enable-fontset \
            --enable-fail-if-missing \
            --enable-rubyinterp=yes \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-python3interp=yes \
            --with-ruby-command=/usr/bin/ruby \
            --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
            --with-luajit \
            --with-x \
            --with-compiledby="yuthon" \
make -j$nproc
sudo make install

# set vim as default editor
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
sudo update-alternatives --set editor /usr/local/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
sudo update-alternatives --set vi /usr/local/bin/vim
