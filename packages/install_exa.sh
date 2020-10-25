#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi
if [ -z $VERSION_SOURCED ]; then
  source include/version.sh
fi

# enter temp directory
pushd ${TMP_DIR}
wget https://github.com/ogham/exa/releases/download/v${EXA_VERSION}/exa-linux-x86_64-${EXA_VERSION}.zip \
  && unzip exa-linux-x86_64-${EXA_VERSION}.zip \
  && sudo mv exa-linux-x86_64 /usr/local/bin/exa
popd
