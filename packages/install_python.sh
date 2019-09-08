#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

PYTHON_VERSION=3.7.3
TMP_DIR=/tmp

prompt_default PYTHON_VERSION "Python Version [${PYTHON_VERSION}]"

# install dependencies
sudo apt update
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev \
  libnss3-dev libssl-dev libreadline-dev libffi-dev wget

# get latest source
pushd ${TMP_DIR}
curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz
tar -xf Python-${PYTHON_VERSION}.tar.xz

# build
cd Python-${PYTHON_VERSION}
./configure --enable-optimizations
make -j 8
sudo make altinstall

# show cmake version
python3.7 --version

popd
