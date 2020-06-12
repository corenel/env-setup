#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi
if [ -z $VERSION_SOURCED ]; then
  source include/version.sh
fi

prompt_default TMUX_VERSION "Tmux Version [${TMUX_VERSION}]"
prompt_default LIBEVENT_VERSION "Libevent Build [${LIBEVENT_VERSION}]"

# uninstall installed tmux
sudo apt-get remove -y tmux
sudo apt-get remove -y 'libevent-*'

# install libncurses
sudo apt-get install -y libncurses5-dev

# download source
pushd ${TMP_DIR}
if [[ ! -d "tmux-${TMUX_VERSION}" ]]; then
    wget "https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz"
    tar xvzf "tmux-${TMUX_VERSION}.tar.gz"
fi

if [[ ! -d "libevent-${LIBEVENT_VERSION}-stable" ]]; then
    wget "https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VERSION}-stable/libevent-${LIBEVENT_VERSION}-stable.tar.gz"
    tar xvzf "libevent-${LIBEVENT_VERSION}-stable.tar.gz"
fi

# install libevent
cd "libevent-${LIBEVENT_VERSION}-stable"
./configure && make
sudo make install
cd ..

# build tmux and install
cd "tmux-${TMUX_VERSION}"
./configure && make
sudo make install

popd
