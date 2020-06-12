#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi
if [ -z $VERSION_SOURCED ]; then
  source include/version.sh
fi

prompt_default EIGEN_VERSION "Boost Version [${BOOST_VERSION}]"
BOOST_VERSION=${BOOST_VERSION//./_}

pushd ${TMP_DIR}

# get latest source
wget https://dl.bintray.com/boostorg/release/1.70.0/source/boost_${BOOST_VERSION}.tar.gz
mkdir boost && tar --strip-components=1 -xzvf boost_${BOOST_VERSION}.tar.gz -C boost

# build and install
cd boost \
  && ./bootstrap.sh \
  && ./b2 stage threading=multi link=shared cxxstd=11 \
  && sudo ./b2 install threading=multi link=shared cxxstd=11 \
  && sudo ln -svf detail/sha1.hpp /usr/include/boost/uuid/sha1.hpp

popd
