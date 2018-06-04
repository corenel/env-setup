export DISABLE_AUTO_TITLE='true'
export ZSH=$HOME/.oh-my-zsh
export TERM=screen-256color
export GTEST_COLOR=1
export EDITOR='NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim'
# export CXX="ccache clang++"
# export CC="ccache clang"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"

ZSH_THEME="ys"

plugins=(git docker autojump zsh-autosuggestions zsh-syntax-highlighting zsh-completions)

[ -f $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh

# # automatically run tmux when starting shell
# if which tmux >/dev/null 2>&1; then
#     # if no session is started, start a new session
#     test -z ${TMUX} && tmux

#     # when quitting tmux, try to attach
#     while test -z ${TMUX}; do
#         tmux attach || break
#     done
# fi

# Alias
# edit config
alias sc="source $HOME/.zshrc"
alias st="tmux source $HOME/.tmux.conf"
alias zc="$EDITOR $HOME/.zshrc"
alias zcc="$EDITOR $HOME/.zshrc.custom"
alias zs="$EDITOR $HOME/.ssh/config"
alias zv="$EDITOR $HOME/.vim/vimrc"
alias zt="$EDITOR $HOME/.tmux.conf"
# pull updates
alias ud="cd $HOME/.dotfiles/ && git pull && cd -"
alias udp="cd $HOME/.dotfiles-personal/ && git pull && cd -"
alias uy="cd $HOME/.ysvim/ && git pull && cd -"
# quick jump
alias jd="[ -d $HOME/.dotfiles ] && cd $HOME/.dotfiles"
alias jdp="[ -d $HOME/.dotfiles-personal ] && cd $HOME/.dotfiles-personal"
alias jv="[ -d $HOME/.ysvim ] && cd $HOME/.ysvim"
alias jw="[ -d $HOME/Workspace ] && cd $HOME/Workspace"
alias jg="[ -d $HOME/Github ] && cd $HOME/Github"
alias jt="[ -d $HOME/.tmp ] && cd $HOME/.tmp"
# ls (from common-aliases)
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
# make
alias mk='make -j`nproc`'
alias mc='make clean'
# git
alias ci='git add . && git commit -m "ci" && git push'
# grep
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}'
alias hst='fc -El 0'
alias hsg='fc -El 0 | grep'
alias psg='ps ax | grep'
# head and tail
# alias -g H='| head'
# alias -g T='| tail'
# alias -g G='| grep'
# alias -g L="| less"
# alias -g M="| most"
# alias -g LL="2>&1 | less"
# alias -g CA="2>&1 | cat -A"
# alias -g NE="2> /dev/null"
# alias -g NUL="> /dev/null 2>&1"
# alias -g P="2>&1| pygmentize -l pytb"
# find
alias fd='find . -type d -name' # find directories in current path
alias ff='find . -type f -name' # find files in current path
alias fdr='sudo find / -type d -name' # find directories in root path
alias ffr='sudo find / -type f -name' # find files in root path
# dangerous operations with prompt and verbose
alias mv='mv -i -v'
alias rm='rm -i -v'
alias cp='cp -v'
alias chmod='chmod -v'
alias chown='chown -v'
alias rename='rename -v'
# tmux
alias t='tmux'
alias tls='tmux list-sessions'
alias tlp='tmux list-panes'
alias ta='tmux attach -t'
alias ts='tmux new -s'
alias tks='tmux kill-session -t'
alias tkw='tmux kill-window -t'
alias tload='tmuxp load'

tssh () {
  TPID=$(tmux list-panes -F "#{pane_active} #{pane_pid}" | awk "\$1==1 {\$1=\"\"; print}" | sed "s/^[ \\t]*//;s/[ \\t]*$//")
  TTTY=$(ps -ao pid,tty,args | sort | awk -v TPID=$TPID "\$1 == TPID {\$1=\"\"; \$3=\"\"; print}" | sed "s/^[ ]*//;s/[ ]*$//")
  TSSH=$(ps -ao pid,tty,args | sort | awk -v TTTY=$TTTY "\$2 ~ TTTY && \$3 ~ /ssh/ {\$1=\"\"; \$2=\"\"; print}" | sed "s/^[ \\t]*//;s/[ \\t]*$//")
  export TPID=$TPID
  export TTTY=$TTTY
  export TSSH=$TSSH
  print $TPID
  print $TTTY
  print $TSSH
 }

twcall () {
  for _pane in $(tmux list-panes -F '#{pane_id}'); do
    tmux send-key -t ${_pane} C-z "$1" Enter
  done
}

tscall () {
  for _pane in $(tmux list-panes -s -F '#{pane_id}'); do
    tmux send-key -t ${_pane} C-z "$1" Enter
  done
}

tacall () {
  for _pane in $(tmux list-panes -a -F '#{pane_id}'); do
    tmux send-key -t ${_pane} C-z "$1" Enter
  done
}

# python
alias py3='python3'
alias py2='python2'
alias pip3='python3 -m pip'
alias pip2='python2 -m pip'
alias pip3upgrade='pip3 install -U $(pip3 list --outdated --format=freeze | awk "{split($0, a, \"==\"); print a[1]}")'

# print info
alias dfh='df -hlT'
alias gput='watch -n 1 nvidia-smi'
alias tree='tree -F -A -I CVS'

# aria2c
alias ar='aria2c --conf-path=$HOME/.aria2/aria2.conf -D'

# nvim
alias v='NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim'
# alias vim='NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim'

# misc
replace_name () {
  file_pattern=$1
  before=$2
  after=$3
  for f in `find . -name "$file_pattern"`; do
    mv -i "${f}" "${f/$before/$after}";
  done
}

replace_content () {
  file_pattern=$1
  before=$2
  after=$3
  for f in `find . -name "$file_pattern"`; do
    sed -i "s/$before/$after/g" $f;
  done
}

replace_encoding () {
  file_pattern=$1
  before=$2
  after=$3
  mkdir -p converted
  for f in `find . -name "$file_pattern"`; do
    iconv -f $before -t $after > "converted/$f";
  done
}

# rsync
rto () {
  dsthost=$1
  relpath=$(pwd | sed "s#$HOME#\$HOME#g")
  parentdir=$(dirname $(pwd) | sed "s#$HOME#\$HOME#g")

  echo "rsync $relpath to $dsthost:$relpath ..."
  if [ -e "$(pwd)/exclude.txt" ] ; then
    rsync -avzP --exclude-from="$(pwd)/exclude.txt" $(pwd) $dsthost:$parentdir
  else
    rsync -avzP $(pwd) $dsthost:$parentdir
  fi
}

# proxy
export CUSTOM_HTTP_PROXY='http://localhost:6152'
export CUSTOM_SOCKS5_PROXY='socks5://localhost:6153'
proxy () {
  export http_proxy=$CUSTOM_HTTP_PROXY
  export HTTPS_PROXY=$http_proxy
  export HTTP_PROXY=$http_proxy
  export FTP_PROXY=$http_proxy
  export https_proxy=$http_proxy
  export ftp_proxy=$http_proxy
  export NO_PROXY="local-delivery,local-auth"
  export no_proxy=$NO_PROXY
  echo "Proxy on"
}

noproxy () {
  unset http_proxy
  unset HTTPS_PROXY
  unset HTTP_PROXY
  unset FTP_PROXY
  unset https_proxy
  unset ftp_proxy
  echo "Proxy off"
}

# custom
[ -f $HOME/.zshrc.custom ] && source $HOME/.zshrc.custom

# virtualenv
setup_venv() {
  export WORKON_HOME=$HOME/.virtualenvs
  if [ -f "$brew_prefix/bin/python3" ] ; then
    if [ -e "$brew_prefix/bin/virtualenvwrapper.sh" ] ; then
      export VIRTUALENVWRAPPER_PYTHON="$brew_prefix/bin/python3"
      source "$brew_prefix/bin/virtualenvwrapper.sh"
    fi
  else
    export VIRTUALENVWRAPPER_PYTHON=$(which python3)
    [ -f /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh
  fi

  # export PYTHONPATH="$VIRTUAL_ENV/usr/local/lib/python3.6/site-packages:$PYTHONPATH"
  export PKG_CONFIG_PATH="$VIRTUAL_ENV/usr/local/lib/pkgconfig/"
  export LD_LIBRARY_PATH="$VIRTUAL_ENV/usr/local/lib/:$LD_LIBRARY_PATH"
}
alias sv=setup_venv

# fzf
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
