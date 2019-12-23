# Uncomment me and run 'zprof' in a new interactive shell to profile startup.
#zmodload zsh/zprof

# Source common configuration.
source $HOME/.profile

# Colored prompt.
autoload -U colors && colors
local lc=$'\e[' rc=m	# Standard ANSI terminal escape values
# typeset -AHg fg_dim
# for k in ${(k)color[(I)fg-*]}; do
#   fg_dim[${k#fg-}]="$lc${color[faint]};${color[$k]}$rc"
# done
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

zplugin light zsh-users/zsh-autosuggestions
#zplugin ice wait'' atinit'zpcompinit' silent; zplugin light zdharma/fast-syntax-highlighting
zplugin light zdharma/fast-syntax-highlighting

# Plugin options.
export FAST_HIGHLIGHT[whatis_chroma_type]=0
export ZSH_AUTOSUGGEST_USE_ASYNC=1

# Tab key accepts typeahead suggestions.
#bindkey '\t' autosuggest-accept

# Load function-based completion system.
autoload -U compinit
compinit

# Add'l completion definitions.
compdef vman="man"

# Plugin zsh-syntax-highlighting must come last.
zplugin ice wait silent; zplugin load zsh-users/zsh-syntax-highlighting

# FZF+zsh integration (diff. locations depending on OS).
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && \
  source /usr/share/doc/fzf/examples/key-bindings.zsh

# Run a command and then enter interactive mode, e.g.
#   RUN=ls zsh
if [[ -v RUN ]]; then
  eval $RUN
fi
