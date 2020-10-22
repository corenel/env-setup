#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi
if [ -z $VERSION_SOURCED ]; then
  source include/version.sh
fi

prompt_default OPENCV_VERSION "OpenCV Version [${OPENCV_VERSION}]"

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
sudo apt-get install -yq ffmpeg
sudo apt-get install -yq libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev libgstreamer-plugins-bad1.0-dev
sudo apt-get install -yq libgoogle-glog-dev libgflags-dev
sudo apt-get install -yq unzip
sudo apt-get install -yq python-dev python-numpy python-py python-pytest
sudo apt-get install -yq python3-dev python3-numpy python3-py python3-pytest

status "Downloading source code of OpenCV"
pushd ${TMP_DIR}
if [[ ! -d "opencv-${OPENCV_VERSION}" ]]; then
  wget --no-check-certificate https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip -O opencv.zip
  unzip opencv.zip
fi
if [[ ! -d "opencv_contrib-${OPENCV_VERSION}" ]]; then
  wget --no-check-certificate https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip -O opencv_contrib.zip
  unzip opencv_contrib.zip
fi

status "Building OpenCV"
cd opencv-${OPENCV_VERSION}
mkdir -p build && cd build

install_opencv_embedded_gpu() {
  echo 'Build OpenCV on Embedded with CUDA'
  CUDA_ARCH="6.2"
  prompt_default CUDA_ARCH "CUDA Arch [${CUDA_ARCH}]"
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="/usr/local" \
    -DBUILD_PNG=OFF \
    -DBUILD_TIFF=OFF \
    -DBUILD_TBB=OFF \
    -DBUILD_JPEG=OFF \
    -DBUILD_JASPER=OFF \
    -DBUILD_ZLIB=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_python2=ON \
    -DBUILD_opencv_python3=ON \
    -DENABLE_NEON=ON \
    -DWITH_OPENCL=OFF \
    -DWITH_OPENMP=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_GSTREAMER=ON \
    -DWITH_CUDA=ON \
    -DWITH_NVCUVID=OFF \
    -DWITH_CUBLAS=ON \
    -DENABLE_FAST_MATH=1 \
    -DCUDA_FAST_MATH=1 \
    -DWITH_GTK=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -DCUDA_ARCH_BIN=${CUDA_ARCH} \
    -DCUDA_ARCH_PTX="" \
    -DINSTALL_C_EXAMPLES=OFF \
    -DINSTALL_PYTHON_EXAMPLES=OFF \
    -DINSTALL_TESTS=OFF \
    -DOPENCV_ENABLE_NONFREE=ON \
    -DOPENCV_GENERATE_PKGCONFIG=YES \
    .. && \
    make && \
    sudo make install
}

install_opencv_embedded_cpu() {
  echo 'Build OpenCV on Embedded without CUDA'
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="/usr/local" \
    -DBUILD_PNG=OFF \
    -DBUILD_TIFF=OFF \
    -DBUILD_TBB=OFF \
    -DBUILD_JPEG=OFF \
    -DBUILD_JASPER=OFF \
    -DBUILD_ZLIB=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_python2=ON \
    -DBUILD_opencv_python3=ON \
    -DENABLE_NEON=ON \
    -DWITH_OPENCL=OFF \
    -DWITH_OPENMP=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_GSTREAMER=ON \
    -DENABLE_FAST_MATH=1 \
    -DWITH_GTK=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DINSTALL_C_EXAMPLES=OFF \
    -DINSTALL_PYTHON_EXAMPLES=OFF \
    -DINSTALL_TESTS=OFF \
    -DOPENCV_ENABLE_NONFREE=ON \
    -DOPENCV_GENERATE_PKGCONFIG=YES \
    .. && \
    make && \
    sudo make install
}

install_opencv_desktop_gpu() {
  echo 'Build OpenCV on PC with CUDA'
  CUDA_ARCH="6.1"
  prompt_default CUDA_ARCH "CUDA Arch [${CUDA_ARCH}]"
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="/usr/local" \
    -DBUILD_PNG=OFF \
    -DBUILD_TIFF=OFF \
    -DBUILD_TBB=OFF \
    -DBUILD_JPEG=OFF \
    -DBUILD_JASPER=OFF \
    -DBUILD_ZLIB=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_python2=ON \
    -DBUILD_opencv_python3=ON \
    -DWITH_OPENCL=OFF \
    -DWITH_OPENMP=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_GSTREAMER=ON \
    -DWITH_CUDA=ON \
    -DWITH_NVCUVID=OFF \
    -DWITH_CUBLAS=ON \
    -DENABLE_FAST_MATH=1 \
    -DCUDA_FAST_MATH=1 \
    -DWITH_GTK=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -DCUDA_ARCH_BIN=${CUDA_ARCH} \
    -DCUDA_ARCH_PTX="" \
    -DINSTALL_C_EXAMPLES=OFF \
    -DINSTALL_PYTHON_EXAMPLES=OFF \
    -DINSTALL_TESTS=OFF \
    -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VERSION}/modules \
    -DOPENCV_ENABLE_NONFREE=ON \
    -DOPENCV_GENERATE_PKGCONFIG=YES \
    .. && \
    make && \
    sudo make install
}

install_opencv_desktop_cpu() {
  echo 'Build OpenCV on PC without CUDA'
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="/usr/local" \
    -DBUILD_PNG=OFF \
    -DBUILD_TIFF=OFF \
    -DBUILD_TBB=OFF \
    -DBUILD_JPEG=OFF \
    -DBUILD_JASPER=OFF \
    -DBUILD_ZLIB=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_python2=ON \
    -DBUILD_opencv_python3=ON \
    -DWITH_OPENCL=OFF \
    -DWITH_OPENMP=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_GSTREAMER=ON \
    -DENABLE_FAST_MATH=1 \
    -DWITH_GTK=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VERSION}/modules \
    -DINSTALL_C_EXAMPLES=OFF \
    -DINSTALL_PYTHON_EXAMPLES=OFF \
    -DINSTALL_TESTS=OFF \
    -DOPENCV_ENABLE_NONFREE=ON \
    -DOPENCV_GENERATE_PKGCONFIG=YES \
    .. && \
    make && \
    sudo make install
}

if [[ "$(uname -m)" == "x86_64" ]]; then
  if [ -x "$(command -v nvcc)" ]; then
    confirm install_opencv_desktop_gpu "Install OpenCV on PC with CUDA"
  else
    confirm install_opencv_desktop_cpu "Install OpenCV on PC without CUDA"
  fi
else
  if [ -x "$(command -v nvcc)" ]; then
    confirm install_opencv_embedded_gpu "Install OpenCV on Embedded with CUDA"
  else
    confirm install_opencv_embedded_cpu "Install OpenCV on Embedded without CUDA"
  fi
fi

popd
