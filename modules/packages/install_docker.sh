#!/usr/bin/env bash

# remove old version
sudo apt-get remove docker docker-engine docker.io

# add repository
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce

# test hello-world
sudo docker run hello-world

# non-root user
sudo groupadd docker
sudo usermod -aG docker $USER
docker run hello-world
