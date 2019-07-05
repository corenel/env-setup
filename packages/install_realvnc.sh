#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

REALVNC_VERSION=6.4.1
TMP_DIR=/tmp

prompt_default REALVNC_VERSION "RealVNC Server Version [${REALVNC_VERSION}]"

# install xfce4 desktop environment
status "---- install xfce ----"
sudo apt-get update
sudo apt-get install xfce4
status "avaliable desktop envs:"
grep Exec= /usr/share/xsessions/*.desktop

# install realvnc server for virtual mode
status "---- install realvnc server ----"
pushd ${TMP_DIR}
wget https://www.realvnc.com/download/file/vnc.files/VNC-Server-${REALVNC_VERSION}-Linux-x64.deb
sudo dpkg -i VNC-Server-${REALVNC_VERSION}-Linux-x64.deb
sudo vnclicense -add X4FS7-483JZ-C8HVQ-DJE9J-HG4DA

# setup vncserver
status "---- setup vncserver ----"
# sudo vncpasswd -virtual
echo -e "#!/bin/sh\nDESKTOP_SESSION=xfce\nexport DESKTOP_SESSIO\nstartxfce4\nvncserver-virtual -kill $DISPLAY" | sudo tee /etc/vnc/xstartup.custom
echo -e "-geometry 1920x1080\n# -extension RENDER" | sudo tee /etc/vnc/config.custom
echo '_connectToExisting=1' | sudo tee /etc/vnc/config.d/vncserver-virtuald
sudo chmod +x /etc/vnc/xstartup.custom
# echo 'Permissions=root:f,%teachers:d,%pupils:v' | sudo tee -a /root/.vnc/config.d/vncserver-virtuald
# echo 'DaemonPort=6051' | sudo tee -a /root/.vnc/config.d/vncserver-virtuald
sudo systemctl start vncserver-virtuald.service
sudo systemctl enable vncserver-virtuald.service

popd
