#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

ZSH_VERSION=5.4.2
TMP_DIR=/tmp

prompt_default ZSH_VERSION "Zsh Version [${ZSH_VERSION}]"

# install dependencies
sudo apt-get install -y git-core gcc make autoconf yodl libncursesw5-dev texinfo

# remove installed zsh
sudo apt-get remove --purge zsh

# enter temp directory
pushd ${TMP_DIR}

# check if zsh source directory exists
if [[ ! -d zsh-{ZSH_VERSION} ]]; then
    wget "http://www.zsh.org/pub/zsh-${ZSH_VERSION}.tar.gz" &&
    tar -xvf "zsh-${ZSH_VERSION}.tar.gz"
fi

# bulid and install zsh
cd "zsh-${ZSH_VERSION}"
make clean && make dist-clean
./configure \
  --prefix=/usr \
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
  LDFLAGS="-Wl,--as-needed -g" && \
  make && \
  sudo make install

# set default
sudo chsh /usr/bin/zsh ${USER}
# sudo update-alternatives --install /usr/bin/zsh zsh /bin/zsh-$version 1
# sudo update-alternatives --set zsh /bin/zsh-$version

popd
