#!/usr/bin/env bash

version=5.4.2
filename=zsh-$version.tar.gz

# install dependencies
sudo apt-get install -y git-core gcc make autoconf yodl libncursesw5-dev texinfo

# remove installed zsh
sudo apt-get remove --purge zsh

# enter temp directory
mkdir -p $HOME/.tmp
cd $HOME/.tmp

# check if zsh source directory exists
if [[ ! -d filename ]]; then
    wget "http://www.zsh.org/pub/zsh-$version.tar.gz" &&
    tar -xvf "zsh-$version.tar.gz"
fi

# bulid and install zsh
cd "zsh-$version"
make clean && make dist-clean
./configure --prefix=/usr \
            --mandir=/usr/share/man \
            --bindir=/bin \
            --sysconfdir=/etc/zsh \
            --infodir=/usr/share/info \
            --enable-maildir-support \
            --enable-etcdir=/etc/zsh \
            --enable-function-subdirs \
            --enable-site-fndir=/usr/local/share/zsh/site-functions \
            --enable-fndir=/usr/share/zsh/functions \
            --with-tcsetpgrp \
            --with-term-lib="ncursesw" \
            --enable-cap \
            --enable-pcre \
            --enable-readnullcmd=pager \
            --enable-custom-patchlevel=yuthon \
            LDFLAGS="-Wl,--as-needed -g"              &&
sudo make -j$nproc                                    &&
sudo make install

# set default
sudo update-alternatives --install /usr/bin/zsh zsh /bin/zsh-$version 1
sudo update-alternatives --set zsh /bin/zsh-$version
