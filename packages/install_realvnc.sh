#!/usr/bin/env bash

# install xfce4 desktop environment
echo "---- install xfce ----"
sudo apt-get update
sudo apt-get install xfce4
echo "avaliable desktop envs:"
grep Exec= /usr/share/xsessions/*.desktop

# install realvnc server for virtual mode
echo "---- install realvnc server ----"
cd $HOME/Downloads/
wget https://www.realvnc.com/download/file/vnc.files/VNC-Server-6.2.0-Linux-x64.deb
sudo dpkg -i VNC-Server-6.2.0-Linux-x64.deb
sudo vnclicense -add X4FS7-483JZ-C8HVQ-DJE9J-HG4DA

# setup vncserver
echo "---- setup vncserver ----"
# sudo vncpasswd -virtual
echo -e "#!/bin/sh\nDESKTOP_SESSION=xfce\nexport DESKTOP_SESSIO\nstartxfce4\nvncserver-virtual -kill $DISPLAY" | sudo tee /etc/vnc/xstartup.custom
echo -e "-geometry 1920x1080\n# -extension RENDER" | sudo tee /etc/vnc/config.custom
echo '_connectToExisting=1' | sudo tee /etc/vnc/config.d/vncserver-virtuald
sudo chmod +x /etc/vnc/xstartup.custom
# echo 'Permissions=root:f,%teachers:d,%pupils:v' | sudo tee -a /root/.vnc/config.d/vncserver-virtuald
# echo 'DaemonPort=6051' | sudo tee -a /root/.vnc/config.d/vncserver-virtuald
sudo systemctl start vncserver-virtuald.service
sudo systemctl enable vncserver-virtuald.service
