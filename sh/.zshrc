# Source common configuration.
source $HOME/.profile

# Colored prompt.
autoload -U colors && colors
local lc=$'\e[' rc=m	# Standard ANSI terminal escape values
# TODO: Remove this if zsh repo merges my PR.
typeset -AHg fg_dim
for k in ${(k)color[(I)fg-*]}; do
  fg_dim[${k#fg-}]="$lc${color[faint]};${color[$k]}$rc"
done
PS1="[%{$fg_dim[white]%}%(5~|%-1~/.../%3~|%4~)%{$reset_color%}] %# "

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

# Keybindings.
bindkey -v '^?' backward-delete-char
bindkey -a -s "gd" "igd\n"
bindkey -a -s "gf" "igf\n"
bindkey -a -s "fe" "ife\n"
bindkey -a -s "fv" "ifv\n"
bindkey -a -s "fs" "ifs "
bindkey -a -s "hs" "ihs\n"
bindkey -a -s "ts" "its\n"

# ZPlugin!
source $HOME/.zplugin/bin/zplugin.zsh

# Load plugins here....


# Load function-based completion system.
autoload -U compinit
compinit

# Plugin zsh-syntax-highlighting must come last.
zplugin light zsh-users/zsh-syntax-highlighting

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
