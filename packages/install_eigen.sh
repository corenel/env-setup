#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi
if [ -z $VERSION_SOURCED ]; then
  source include/version.sh
fi

prompt_default EIGEN_VERSION "Eigen Version [${EIGEN_VERSION}]"

pushd ${TMP_DIR}

# get latest source
wget http://bitbucket.org/eigen/eigen/get/${EIGEN_VERSION}.tar.gz
mkdir eigen && tar --strip-components=1 -xzvf ${EIGEN_VERSION}.tar.gz -C eigen

# build and install
cd eigen && mkdir build && cd build && cmake .. && make && sudo make install

popd
