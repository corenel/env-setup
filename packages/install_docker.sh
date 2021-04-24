#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

install_docker() {
  # install docker
  curl https://get.docker.com | sh \
    && sudo systemctl start docker \
    && sudo systemctl enable docker

  # non-root user
  sudo groupadd docker
  sudo usermod -aG docker $USER
  warning "Please log out and log in to take effects"
  # docker run hello-world
}

install_nvidia_docker() {
  warning "Note that with the release of Docker 19.03, usage of nvidia-docker2 packages are deprecated since NVIDIA GPUs are now natively supported as devices in the Docker runtime. If you are an existing user of the nvidia-docker2 packages, use `update_with_nvidia_docker2` function."
  # Add the package repositories
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  # Install the package
  sudo apt-get update && sudo apt-get install -y nvidia-docker2
  sudo systemctl restart docker

  # Test nvidia-smi with the latest official CUDA image
  docker run --gpus all nvidia/cuda:11.0-base nvidia-smi
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
