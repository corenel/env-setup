#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

AXEL_VERSION=2.15
TMP_DIR=/tmp

prompt_default AXEL_VERSION "Axel Version [${AXEL_VERSION}]"

URL=https://github.com/axel-download-accelerator/axel/releases/download/v${AXEL_VERSION}/axel-${AXEL_VERSION}.tar.gz

# uninstall installed packages
sudo apt-get remove -y axel

# install dependencies
sudo apt-get install -y libssl-dev

# download source
pushd ${TMP_DIR}
if [[ ! -d "axel-${AXEL_VERSION}" ]]; then
    wget $URL
    tar xvf "axel-${AXEL_VERSION}.tar.gz"
fi

# build tmux and install
cd "axel-${AXEL_VERSION}"
./configure && make -j$nproc
sudo make install
popd
