#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

if [ -z $SYSTEM_VARIABLES_SOURCED ]; then
  source include/system_variables.sh
fi

add_ppa_repo() {
  sudo apt-get install -yq software-properties-common
  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo apt-get update -yq
}

install_utils() {
  sudo apt-get install -yq --allow-unauthenticated \
    openssh-server wireless-tools git wget curl rsync \
    build-essential cmake ccache clang gdb \
    htop iotop iftop net-tools \
    xclip xsel autojump gawk \
    zsh tmux vim neovim supervisor
}

install_libs() {
  sudo apt-get install -yq \
    python3-dev python3-pip python-dev python-pip libudev-dev libx264-dev
}

install_python_pkgs() {
  sudo -H -E python -m pip install -U pip
  sudo -H -E python -m pip install -r modules/requirements.txt
  sudo -H -E python3 -m pip install -U pip
  sudo -H -E python3 -m pip install -r modules/requirements.txt
}

install_oh_my_zsh() {
  if [ ! -d $HOME/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
  if [ -d $HOME/.oh-my-zsh/custom ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions.git $HOME/.oh-my-zsh/custom/plugins/zsh-completions
  fi
}

install_zinit() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
}

install_tpm() {
  if [ ! -d $HOME/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
  tmux source $HOME/.tmux.conf
}

install_homebrew_pkgs() {
  # pkgs
  brew install \
    ack \
    ag \
    autojump \
    bfg \
    ccat \
    clang-format \
    cmake \
    cppcheck \
    dos2unix \
    ffmpeg \
    fzf \
    gcc \
    go \
    gpg \
    graphviz \
    gst-libav \
    gst-plugins-bad \
    gst-plugins-base \
    gst-plugins-good \
    gst-plugins-ugly \
    gst-rtsp-server \
    gstreamer \
    hadolint \
    htop \
    iperf3 \
    jq \
    m-cli \
    mosh \
    neofetch \
    neovim \
    nmap \
    node \
    nvm \
    opencv \
    openssh \
    pandoc \
    pdsh \
    plantuml \
    pip-completion \
    python \
    reattach-to-user-namespace \
    ripgrep \
    smartmontools \
    tldr \
    tmate \
    tmux \
    tree \
    universal-ctags \
    watch \
    wget \
    yapf \
    youtube-dl \
    zsh

  # fzf
  # /usr/local/opt/fzf/install
}

install_homebrew_casks() {
  brew tap homebrew/cask
  brew install --cask \
    115browser \
    1password \
    adobe-creative-cloud \
    alfred \
    araxis-merge \
    avira-antivirus \
    baidunetdisk \
    balenaetcher \
    bob \
    carbon-copy-cloner \
    cyberduck \
    devonthink \
    docker \
    drawio \
    fork \
    google-chrome \
    gswitch \
    iina \
    imagej \
    imazing \
    intel-power-gadget \
    iterm2 \
    karabiner-elements \
    lyricsx \
    mactex \
    mathpix-snipping-tool \
    microsoft-excel \
    microsoft-powerpoint \
    microsoft-word \
    mountain-duck \
    mounty \
    netnewswire \
    netron \
    nomachine \
    obsidian \
    omnigraffle \
    pdf-expert \
    setapp \
    skim \
    spotify \
    sublime-text \
    sunloginclient \
    surge \
    teamviewer \
    tencent-meeting \
    typora \
    uninstallpkg \
    visual-studio-code \
    vlc \
    vmware-fusion \
    vnc-viewer \
    wireshark \
    xld \
    xmind-zen \
    xquartz \
    zerotier-one \
    zoom
}

install_homebrew_fonts() {
  brew tap homebrew/cask-fonts
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
  ;;
Darwin*)
  confirm install_homebrew_pkgs "Install packages from HomeBrew"
  confirm install_homebrew_casks "Install softwares from HomeBrew Cask"
  confirm install_homebrew_fonts "Install fonts from HomeBrew"
  ;;
*)
  error "OS $OS_TYPE is not supported"
  exit 1
  ;;
esac

confirm install_python_pkgs "Install Python packages"
confirm install_oh_my_zsh "Install Oh-My-Zsh"
confirm install_zinit "Install Zinit"
confirm install_tpm "Install Tmux Plugin Manager"
