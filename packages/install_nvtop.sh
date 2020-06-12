#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

# install dependencies
# sudo apt install -y cmake libncurses5-dev libncursesw5-dev git
sudo apt install -y libncurses5-dev libncursesw5-dev git

# get latest source
pushd ${TMP_DIR}
git clone https://github.com/Syllo/nvtop.git

# build cmake
mkdir -p nvtop/build && cd nvtop/build
cmake ..
make
sudo make install

# show
nvtop

popd

