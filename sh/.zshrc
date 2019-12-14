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
PS1="%{$fg_bold[white]%}%{$reset_color%} "

# Prefix each new prompt with a newline, except right after the shell is
# spawned.
function precmd() {
  if [[ -z "$NEWLINE_BEFORE_PROMPT" ]]; then
    NEWLINE_BEFORE_PROMPT=1
  elif [[ "$NEWLINE_BEFORE_PROMPT" == "1" ]]; then
    echo -n $'\n'
  fi
}

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

# Add'l completion definitions.
compdef vman="man"

# Plugin zsh-syntax-highlighting must come last.
zplugin ice wait silent; zplugin load zsh-users/zsh-syntax-highlighting

# FZF+zsh integration.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Run a command and then enter interactive mode, e.g.
#   RUN=ls zsh
if [[ -v RUN ]]; then
  eval $RUN
fi
