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
autoload -U compinit -d
compinit

# Plugin zsh-syntax-highlighting must come last.
zplugin ice wait'0'; zplugin load zsh-users/zsh-syntax-highlighting

# FZF+zsh integration.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
