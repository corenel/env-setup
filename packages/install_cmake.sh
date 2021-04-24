#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi
if [ -z $VERSION_SOURCED ]; then
  source include/version.sh
fi

prompt_default CMAKE_VERSION "CMake Version [${CMAKE_VERSION}]"

# purge installed cmake
if confirmation "Purge installed cmake"; then
  sudo apt remove --purge --auto-remove cmake
fi

# install dependencies for SSL support
sudo apt-get install zlib1g-dev libssl-dev # libcurl4-gnutls-dev

# get latest cmake source
pushd ${TMP_DIR}
wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz
tar -xzvf cmake-${CMAKE_VERSION}.tar.gz
cd cmake-${CMAKE_VERSION}/

# build cmake
./bootstrap --prefix=/usr/local # use system curl to enable SSL support
make
sudo make install

# show cmake version
cmake --version

popd
