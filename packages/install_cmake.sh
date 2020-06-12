#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi
if [ -z $VERSION_SOURCED ]; then
  source include/version.sh
fi

prompt_default CMAKE_VERSION "CMake Major Version [${CMAKE_VERSION}]"
prompt_default CMAKE_BUILD "CMake Build [${CMAKE_BUILD}]"

# purge installed cmake
if confirmation "Purge installed cmake"; then
  sudo apt remove --purge --auto-remove cmake
fi

# install dependencies for SSL support
sudo apt-get install libcurl4-gnutls-dev zlib1g-dev

# get latest cmake source
pushd ${TMP_DIR}
wget https://cmake.org/files/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.${CMAKE_BUILD}.tar.gz
tar -xzvf cmake-${CMAKE_VERSION}.${CMAKE_BUILD}.tar.gz
cd cmake-${CMAKE_VERSION}.${CMAKE_BUILD}/

# build cmake
./bootstrap --system-curl # use system curl to enable SSL support
make
sudo make install

# show cmake version
cmake --version

popd
