#!/usr/bin/env bash

# use USTC mirror for higher downloading speed
sudo sh -c '. /etc/lsb-release && echo "deb https://mirrors.ustc.edu.cn/ros/ubuntu/ $DISTRIB_CODENAME main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get update
sudo apt-get install -y \
  ros-kinetic-ros-base \
  python-rosinstall python-rosinstall-generator python-wstool \
  ros-kinetic-image-transport ros-kinetic-tf2 ros-kinetic-tf2-geometry-msgs
# ros-kinetic-opencv3

sudo rosdep init
rosdep update

# if you use bash, replace .zshrc with .bashrc
# echo 'source /opt/ros/kinetic/setup.zsh' >> ~/.zshrc
# source ~/.zshrc
