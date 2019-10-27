# Source common configuration.
source $HOME/.profile

# Colored prompt.
autoload -U colors && colors
PS1="[%{$fg[yellow]%}%(5~|%-1~/.../%3~|%4~)%{$reset_color%}] %% "

# Options.
setopt auto_cd
setopt extended_glob

# Variables.
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

# Vim mode.
bindkey -v
export KEYTIMEOUT=1

# Load function-based completion system.
autoload -U compinit
compinit

# FZF+zsh integration.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# call nvm use automatically whenever you enter a directory that contains an .nvmrc file
autoload -U add-zsh-hook
load-nvmrc() {
 if ! [ -x "$(command -v nvm)" ]; then return; fi
 if [[ -f .nvmrc && -r .nvmrc ]]; then
   nvm use >/dev/null
 elif [[ $(nvm version) != $(nvm version default)  ]]; then
   nvm use default >/dev/null
 fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
