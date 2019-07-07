#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

REALVNC_VERSION=6.4.1
REALVNC_LICENSE=X4FS7-483JZ-C8HVQ-DJE9J-HG4DA
TMP_DIR=/tmp

prompt_default REALVNC_VERSION "RealVNC Server Version [${REALVNC_VERSION}]"

# install xfce4 desktop environment
install_xfce() {
  sudo apt-get update
  sudo apt-get install xfce4
  status "avaliable desktop envs:"
  grep Exec= /usr/share/xsessions/*.desktop
}

# install realvnc server for virtual mode
install_realvnc() {
  pushd ${TMP_DIR}
  wget https://www.realvnc.com/download/file/vnc.files/VNC-Server-${REALVNC_VERSION}-Linux-x64.deb
  sudo dpkg -i VNC-Server-${REALVNC_VERSION}-Linux-x64.deb
  sudo vnclicense -add ${REALVNC_LICENSE}
  popd
}

# setup vncserver
setup_virtuald() {
  # sudo vncpasswd -virtual
  echo -e "#!/bin/sh\nDESKTOP_SESSION=xfce\nexport DESKTOP_SESSIO\nstartxfce4\nvncserver-virtual -kill $DISPLAY" | sudo tee /etc/vnc/xstartup.custom
  echo -e "-geometry 1920x1080\n# -extension RENDER" | sudo tee /etc/vnc/config.custom
  echo '_connectToExisting=1' | sudo tee /etc/vnc/config.d/vncserver-virtuald
  sudo chmod +x /etc/vnc/xstartup.custom
  # echo 'Permissions=root:f,%teachers:d,%pupils:v' | sudo tee -a /root/.vnc/config.d/vncserver-virtuald
  # echo 'DaemonPort=6051' | sudo tee -a /root/.vnc/config.d/vncserver-virtuald
  sudo systemctl start vncserver-virtuald.service
  sudo systemctl enable vncserver-virtuald.service
}

setup_service() {
  sudo sed -i "s/#WaylandEnable=false/WaylandEnable=false/g" /etc/gdm3/custom.conf
  warning "Please reboot in order to support remotely access the login screen."
  sudo systemctl start vncserver-x11-serviced.service
  sudo systemctl enable vncserver-x11-serviced.service
}

confirm install_realvnc "Install RealVNC"
confirm install_xfce "Install Xfce desktop environment"
confirm setup_virtuald "Setup VNC Server in Virtual Mode"
confirm setup_service "Setup VNC Server in Service Mode"
