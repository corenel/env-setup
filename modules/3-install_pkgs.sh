#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

if [ -z $SYSTEM_VARIABLES_SOURCED ]; then
  source include/system_variables.sh
fi

add_ppa_repo() {
  sudo apt-get install software-properties-common
  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo add-apt-repository -y ppa:jonathonf/python-3.6
  sudo add-apt-repository -y ppa:pi-rho/dev
  sudo find /etc/apt/sources.list.d/ -type f -name "*.list" -exec sed -i.bak -r 's#deb(-src)?\s*http(s)?://ppa.launchpad.net#deb\1 http\2://launchpad.proxy.ustclug.org#ig' {} \;
  sudo apt-get update
}

install_utils() {
  sudo apt-get install -y --allow-unauthenticated \
    build-essential openssh-server wireless-tools git \
    wget zsh htop vim curl cmake ccache clang autojump \
    xclip xsel neovim supervisor
}

install_libs() {
  sudo apt-get install -y \
    python3-dev python3-pip python-dev python-pip
}

install_python_pkgs() {
  pip install -U pip
  pip install -r requiremnts.txt
  pip3 install -U pip
  pip3 install -r requiremnts.txt
}

install_nerd_fonts() {
  pushd /tmp
  git clone https://github.com/ryanoasis/nerd-fonts.git
  ./install.sh
  popd
}

install_oh_my_zsh() {
  if [ ! -d $HOME/.oh-my-zsh ]; then
    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - --no-check-certificate)"
  fi
  if [ -d $HOME/.oh-my-zsh/custom ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  fi
}

install_tightvnc() {
  sudo apt-get install -y xfce4 xfce4-goodies tightvncserver
  vncserver -kill :1
  mv $HOME/.vnc/xstartup $HOME/.vnc/xstartup.bak
  mkdir -p $HOME/.vnc
  echo -e '#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &' >>$HOME/.vnc/xstartup
  vncserver
}

build_tmux() {
  tmux_ver=2.6
  libevent_ver=2.1.8

  # uninstall installed tmux
  sudo apt-get remove -y tmux
  sudo apt-get remove -y 'libevent-*'

  # install libncurses
  sudo apt-get install -y libncurses5-dev

  # download source
  pushd /tmp
  if [[ ! -d "tmux-$tmux_ver" ]]; then
    wget "https://github.com/tmux/tmux/releases/download/$tmux_ver/tmux-$tmux_ver.tar.gz"
    tar xvzf "tmux-$tmux_ver.tar.gz"
  fi

  if [[ ! -d "libevent-$libevent_ver-stable" ]]; then
    wget "https://github.com/libevent/libevent/releases/download/release-$libevent_ver-stable/libevent-$libevent_ver-stable.tar.gz"
    tar xvzf "libevent-$libevent_ver-stable.tar.gz"
  fi

  # install libevent
  if [[ -d "libevent-$libevent_ver-stable" ]]; then
    pushd "libevent-$libevent_ver-stable"
    ./configure && make -j8
    sudo make install
    popd
  fi

  # build tmux and install
  if [[ -d "tmux-$tmux_ver" ]]; then
    pushd "tmux-$tmux_ver"
    ./configure && make -j8
    sudo make install
    popd
  fi
  popd
}

install_homebrew_pkgs() {
  # pkgs
  brew install zsh autojump tmux\
    python pip-completion \
    watch cppcheck wget nvm gcc \
    htop reattach-to-user-namespace \
    ffmpeg cmake tree openssh \
    clang-format m-cli graphviz ccat \
    gpg ag ack fzf hadolint tldr

  # fzf
  /usr/local/opt/fzf/install

  # neovim
  brew install neovim
  brew install --HEAD universal-ctags/universal-ctags/universal-ctags
}

install_homebrew_casks() {
  brew tap caskroom/cask

  brew cask install \
    sublime-text calibre docker hammerspoon iina karabiner-elements skim \
    vnc-viewer xld intel-power-gadget android-file-transfer \
    xquartz mactex mounty sourcetree \
    google-chrome google-backup-and-sync \
    android-file-transfer typora aria2gui iterm2 maciasl mounty
}

install_homebrew_fonts() {
  brew tap caskroom/fonts
  brew cask install \
    font-source-code-pro \
    font-sourcecodepro-nerd-font font-sourcecodepro-nerd-font-mono \
    font-fira-code font-firacode-nerd-font font-firamono-nerd-font \
    font-meslo-for-powerline font-meslo-nerd-font font-meslo-nerd-font-mono \
    font-hack-nerd-font
}

case $OS_TYPE in
  Linux*)
    confirm add_ppa_repo "Add ppa repository"
    confirm install_utils "Install necessary utilities"
    confirm install_libs "Install necessary libraries"
    confirm install_python_pkgs "Install Python packages"
    confirm install_oh_my_zsh "Install Oh-My-Zsh"
    confirm install_tightvnc "Install TightVNC"
    confirm install_nerd_fonts "Install Nerd fonts"
    confirm build_tmux "Build tmux"
    ;;
  Darwin*)
    confirm install_homebrew_pkgs "Install packages from HomeBrew"
    confirm install_homebrew_casks "Install softwares from HomeBrew Cask"
    confirm install_homebrew_fonts "Install fonts from HomeBrew"
    confirm install_python_pkgs "Install Python packages"
    confirm install_oh_my_zsh "Install Oh-My-Zsh"
    ;;
  *)
    error "OS $OS_TYPE is not supported"
esac
