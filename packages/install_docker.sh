#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

install_docker() {
  # remove old version
  sudo apt-get remove docker docker-engine docker.io containerd runc

  # add repository
  sudo apt-get update
  sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository \
    "deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu/ \
    $(lsb_release -cs) \
    stable"
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io

  # test hello-world
  # sudo docker run hello-world

  # non-root user
  sudo groupadd docker
  sudo usermod -aG docker $USER
  warning "Please log out and log in to take effects"
  # docker run hello-world
}

install_nvidia_docker() {
  warning "Note that with the release of Docker 19.03, usage of nvidia-docker2 packages are deprecated since NVIDIA GPUs are now natively supported as devices in the Docker runtime. If you are an existing user of the nvidia-docker2 packages, use `update_with_nvidia_docker2` function."
  # Add the package repositories
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  # Install the package
  sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
  sudo systemctl restart docker

  # Test nvidia-smi with the latest official CUDA image
  docker run --gpus all nvidia/cuda:9.0-base nvidia-smi
}

update_with_nvidia_docker2() {
  # On debian based distributions: Ubuntu / Debian
  sudo apt-get update
  sudo apt-get --only-upgrade install docker-ce nvidia-docker2
  sudo systemctl restart docker

  # Test nvidia-smi with the latest official CUDA image
  docker run --gpus all nvidia/cuda:9.0-base nvidia-smi
}


confirm install_docker "Install docker"
confirm install_nvidia_docker "Install nvidia-docker"
