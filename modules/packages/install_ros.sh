#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

if [ -z $SYSTEM_VARIABLES_SOURCED ]; then
  source include/system_variables.sh
fi

install_ros() {
  INSTALL_DIR=/tmp/installROS$JETSON_BOARD
  if [ "$JETSON_BOARD" != "TX1" ] && [ "$JETSON_BOARD" != "TX2" ]; then
    error "Unsupported device for ROS"
    return
  fi

  INSTALL_DIR=/tmp/installROS${JETSON_BOARD}
  INSTALL_URL=git@github.com:DancerDeps/installROS${JETSON_BOARD}.git
  git clone ${INSTALL_URL} ${INSTALL_DIR}
  if [ -d ${INSTALL_DIR} ]; then
    pushd ${INSTALL_DIR}
    ./installROS.sh
    sudo apt-get install -y \
      ros-kinetic-image-transport ros-kinetic-tf2 \
      ros-kinetic-tf2-geometry-msgs \
      ros-kinetic-opencv3 ros-kinetic-cv-bridge
    popd
  fi
}

confirm install_ros "Install ROS"
