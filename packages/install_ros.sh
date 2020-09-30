#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi
if [ -z $VERSION_SOURCED ]; then
  source include/version.sh
fi

prompt_default ROS_CUSTOM_DISTRO "ROS Distro [${ROS_CUSTOM_DISTRO}]"

# use USTC mirror for higher downloading speed
# sudo sh -c '. /etc/lsb-release && echo "deb https://mirrors.ustc.edu.cn/ros/ubuntu/ $DISTRIB_CODENAME main" > /etc/apt/sources.list.d/ros-latest.list'
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update
sudo apt-get install -y \
  ros-${ROS_CUSTOM_DISTRO}-ros-base \
  python-rosinstall python-rosinstall-generator python-wstool \
  python-rosdep \
  ros-${ROS_CUSTOM_DISTRO}-image-transport \
  ros-${ROS_CUSTOM_DISTRO}-tf2 \
  ros-${ROS_CUSTOM_DISTRO}-tf2-geometry-msgs

sudo rosdep init
rosdep update

# if you use bash, replace .zshrc with .bashrc
# echo 'source /opt/ros/${ROS_CUSTOM_DISTRO}/setup.zsh' >> ~/.zshrc
# source ~/.zshrc
