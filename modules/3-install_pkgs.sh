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
    build-essential openssh-server wireless-tools git \
    wget zsh htop vim curl cmake ccache clang autojump \
    xclip xsel neovim supervisor
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
    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - --no-check-certificate)"
  fi
  if [ -d $HOME/.oh-my-zsh/custom ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions.git $HOME/.oh-my-zsh/custom/plugins/zsh-completions
  fi
}

install_homebrew_pkgs() {
  # pkgs
  brew install zsh autojump tmux tmate \
    python pip-completion \
    watch cppcheck wget nvm gcc \
    htop reattach-to-user-namespace \
    ffmpeg cmake tree openssh \
    clang-format m-cli graphviz ccat \
    gpg rg ag ack fzf hadolint tldr

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
  ;;
esac
