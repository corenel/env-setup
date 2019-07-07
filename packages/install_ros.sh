#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

export ZJUDANCER_ROS_DISTRO=melodic
prompt_default ZJUDANCER_ROS_DISTRO "ROS Distro [${ZJUDANCER_ROS_DISTRO}]"

# use USTC mirror for higher downloading speed
# sudo sh -c '. /etc/lsb-release && echo "deb https://mirrors.ustc.edu.cn/ros/ubuntu/ $DISTRIB_CODENAME main" > /etc/apt/sources.list.d/ros-latest.list'
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update
sudo apt-get install -y \
  ros-${ZJUDANCER_ROS_DISTRO}-ros-base \
  python-rosinstall python-rosinstall-generator python-wstool \
  ros-${ZJUDANCER_ROS_DISTRO}-image-transport \
  ros-${ZJUDANCER_ROS_DISTRO}-tf2 \
  ros-${ZJUDANCER_ROS_DISTRO}-tf2-geometry-msgs

sudo rosdep init
rosdep update

# if you use bash, replace .zshrc with .bashrc
# echo 'source /opt/ros/${ZJUDANCER_ROS_DISTRO}/setup.zsh' >> ~/.zshrc
# source ~/.zshrc
