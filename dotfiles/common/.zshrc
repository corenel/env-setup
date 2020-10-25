# Oh-My-ZSH {{{
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="ys"

plugins=(
  git
  # sudo
  # docker
  # autojump
  # extract
  # copydir copybuffer copyfile cp
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  # colored-man-pages colorize
)

[ -f $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh

# }}} Oh-My-ZSH

# GENERAL CONFIG {{{

# load specific config
[ -f $HOME/.zshrc.general ] && source $HOME/.zshrc.general

# }}} GENERAL_CONFIG

# CUSTOM CONFIG {{{

# load specific config
[ -f $HOME/.zshrc.custom ] && source $HOME/.zshrc.custom

# }}} CUSTOM_CONFIG

# Don't end with errors.
true
