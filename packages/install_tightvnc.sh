#!/usr/bin/env bash

sudo apt-get install -y xfce4 xfce4-goodies tightvncserver

vncserver -kill :1

mv $HOME/.vnc/xstartup $HOME/.vnc/xstartup.bak & \
  mkdir -p $HOME/.vnc & \
  echo -e '#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
startxfce4 &
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &' > $HOME/.vnc/xstartup & \
  chmod +x $HOME/.vnc/xstartup

vncserver
