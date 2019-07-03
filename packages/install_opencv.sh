#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

OPENCV_VERSION=3.4.5
CUDA_VERSION="9-0"
CUDA_ARCH="6.2"
TMP_DIR=/tmp

prompt_default OPENCV_VERSION "OpenCV version [${OPENCV_VERSION}]"
prompt_default CUDA_VERSION "CUDA version [${CUDA_VERSION}]"
prompt_default CUDA_ARCH "CUDA arch [${CUDA_ARCH}]"

status "Install dependencies of OpenCV"
sudo apt-get install -yq \
  libglew-dev \
  libtiff5-dev \
  zlib1g-dev \
  libjpeg-dev \
  libpng12-dev \
  libjasper-dev \
  libavcodec-dev \
  libavformat-dev \
  libavutil-dev \
  libpostproc-dev \
  libswscale-dev \
  libeigen3-dev \
  libtbb-dev \
  libgtk2.0-dev \
  pkg-config
sudo apt-get install -yq gstreamer1.0* \
  libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev
sudo apt-get install -yq unzip
sudo apt-get install -yq python-dev python-numpy python-py python-pytest
sudo apt-get install -yq python3-dev python3-numpy python3-py python3-pytest

status "Downloading source code of OpenCV"
pushd ${TMP_DIR}
if [[ ! -d "opencv-${OPENCV_VERSION}" ]]; then
  wget --no-check-certificate https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
  unzip ${OPENCV_VERSION}.zip
fi

status "Building OpenCV"
cd opencv-${OPENCV_VERSION}
mkdir -p build && cd build
if [ ${ZJUDANCER_GPU} -eq "1" ]; then
  echo 'Build OpenCV on Jetson Tegra with CUDA'
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_PNG=OFF \
    -DBUILD_TIFF=OFF \
    -DBUILD_TBB=OFF \
    -DBUILD_JPEG=OFF \
    -DBUILD_JASPER=OFF \
    -DBUILD_ZLIB=OFF \
    -DBUILD_EXAMPLES=ON \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_python2=ON \
    -DBUILD_opencv_python3=ON \
    -DENABLE_NEON=ON \
    -DWITH_OPENCL=OFF \
    -DWITH_OPENMP=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_CUDA=ON \
    -DWITH_GTK=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -DCUDA_ARCH_BIN=${CUDA_ARCH} \
    -DCUDA_ARCH_PTX="" \
    -DINSTALL_C_EXAMPLES=ON \
    -DINSTALL_TESTS=OFF \
    .. && \
    make && \
    sudo make install
elif [ -x "$(command -v nvcc)" ]; then
  echo 'Build OpenCV on PC with CUDA'
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_PNG=OFF \
    -DBUILD_TIFF=OFF \
    -DBUILD_TBB=OFF \
    -DBUILD_JPEG=OFF \
    -DBUILD_JASPER=OFF \
    -DBUILD_ZLIB=OFF \
    -DBUILD_EXAMPLES=ON \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_python2=ON \
    -DBUILD_opencv_python3=ON \
    -DWITH_OPENCL=OFF \
    -DWITH_OPENMP=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_CUDA=ON \
    -DWITH_GTK=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -DCUDA_ARCH_BIN=${CUDA_ARCH} \
    -DCUDA_ARCH_PTX="" \
    -DINSTALL_C_EXAMPLES=ON \
    -DINSTALL_TESTS=OFF \
    .. && \
    make && \
    sudo make install
else
  echo 'Build OpenCV on PC without CUDA'
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_PNG=OFF \
    -DBUILD_TIFF=OFF \
    -DBUILD_TBB=OFF \
    -DBUILD_JPEG=OFF \
    -DBUILD_JASPER=OFF \
    -DBUILD_ZLIB=OFF \
    -DBUILD_EXAMPLES=ON \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_python2=ON \
    -DBUILD_opencv_python3=ON \
    -DWITH_OPENCL=OFF \
    -DWITH_OPENMP=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_GTK=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DINSTALL_C_EXAMPLES=ON \
    -DINSTALL_TESTS=OFF \
    .. && \
    make && \
    sudo make install
fi

popd
