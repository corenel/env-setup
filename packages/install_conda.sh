#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

if [ -z $SYSTEM_VARIABLES_SOURCED ]; then
  source include/system_variables.sh
fi

MINICONDA_INSTALL_DIR=$HOME/miniconda3

case $OS_TYPE in
  Linux*)
    # MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    MINICONDA_URL=https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
    ;;
  Darwin*)
    # MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
    MINICONDA_URL=https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
    ;;
  *)
    echo "OS $OS_TYPE is not supported"
esac

install_miniconda() {
  pushd ${TMP_DIR}
  if [[ ! -f "miniconda.sh" ]]; then
      wget -O miniconda.sh "${MINICONDA_URL}"
  fi
  chmod +x miniconda.sh
  ./miniconda.sh -b -p $MINICONDA_INSTALL_DIR
  popd
}

set_conda_mirror() {
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
  conda config --set show_channel_urls yes
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/menpo/
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
}

confirm install_miniconda "Install miniconda3"
confirm set_conda_mirror "Setup china mirror for conda"
