#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

TMP_DIR=/tmp
FFMPEG_VERSION=4.2.1

prompt_default FFMPEG_VERSION "CMake Version [${FFMPEG_VERSION}]"

# purge installed ffmpeg
if confirmation "Purge installed ffmpeg"; then
  sudo apt remove --purge --auto-remove ffmpeg
fi

# install dependencies
sudo apt-get install yasm libx264-dev libx264-dev \
  libvpx-dev libfdk-aac-dev libmp3lame-dev libopus-dev \
  libass-dev libvorbis-dev

# get latest ffmpeg source
pushd ${TMP_DIR}

# git clone https://git.ffmpeg.org/ffmpeg.git

# wget -O ffmpeg-snapshot.tar.bz2 \
#   https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
#   tar xjvf ffmpeg-snapshot.tar.bz2

wget -O ffmpeg-${FFMPEG_VERSION}.tar.bz2 \
  https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 && \
  tar xjvf ffmpeg-${FFMPEG_VERSION}.tar.bz2

# build ffmpeg
cd ffmpeg
if [ -x "$(command -v nvcc)" ]; then
  git clone git@github.com:FFmpeg/nv-codec-headers.git && \
    cd nv-codec-headers && \
    sudo make install && \
    cd ..
  ./configure \
    --enable-gpl \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree \
    --enable-cuda \
    --enable-cuvid \
    --enable-nvenc \
    --enable-nonfree \
    --enable-libnpp \
    --extra-cflags=-I/usr/local/cuda/include \
    --extra-ldflags=-L/usr/local/cuda/lib64 && \
    make -j -s && \
    sudo make install
else
  ./configure \
    --enable-gpl \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree && \
    make -j -s && \
    sudo make install
fi

# show ffmpeg version
ffmpeg -version

popd
