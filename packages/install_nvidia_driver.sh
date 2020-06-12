#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi
if [ -z $VERSION_SOURCED ]; then
  source include/version.sh
fi

prompt_default NVIDIA_DRIVER_VERSION "NVIDIA Driver Version [${NVIDIA_DRIVER_VERSION}]"

# Add PPA source
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update

# Install the driver
sudo apt-get install nvidia-driver-${NVIDIA_DRIVER_VERSION}

# Warn to reboot
warning "Please reboot the host and run nvidia-smi to check the installation"
