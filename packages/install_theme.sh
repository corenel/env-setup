#!/usr/bin/env bash

# Arc Faltabulous theme
cd $HOME/Downloads
sudo rm -rf /usr/share/themes/{Arc-Flatabulous,Arc-Flatabulous-Darker,Arc-Flatabulous-Dark}\nrm -rf ~/.local/share/themes/{Arc-Flatabulous,Arc-Flatabulous-Darker,Arc-Flatabulous-Dark}\nrm -rf ~/.themes/{Arc-Flatabulous,Arc-Flatabulous-Darker,Arc-Flatabulous-Dark}
git clone https://github.com/andreisergiu98/arc-flatabulous-theme && cd arc-flatabulous-theme
./autogen.sh --prefix=/usr --disable-transparency
sudo make install

# Papirus icon theme
cd $HOME/Downloads
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install-papirus-root.sh | sh
