# # Oh-My-ZSH {{{

# # load oh-my-zsh
# [ -f $HOME/.zshrc.oh-my-zsh ] && source $HOME/.zshrc.oh-my-zsh

# # }}} Oh-My-ZSH

# Zinit {{{

# load zinit
[ -f $HOME/.zshrc.zinit ] && source $HOME/.zshrc.zinit

# }}} Zinit

# GENERAL CONFIG {{{

# load general config
[ -f $HOME/.zshrc.general ] && source $HOME/.zshrc.general

# }}} GENERAL_CONFIG

# CUSTOM CONFIG {{{

# load specific config
[ -f $HOME/.zshrc.custom ] && source $HOME/.zshrc.custom

# }}} CUSTOM_CONFIG

# LOCAL CONFIG {{{

# load specific config
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local

# }}} LOCAL_CONFIG

# Don't end with errors.
true
