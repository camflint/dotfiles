# Uncomment me and run 'zprof' in a new interactive shell to profile startup.
#zmodload zsh/zprof

# Source common configuration.
source $HOME/.profile

# Keybindings.
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

# Disable XON/XOFF to let through <C-S> key events.
bindkey -r '\C-s'

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

# zinit!
source $HOME/.zinit/bin/zinit.zsh

# Load plugins here....

zinit light zsh-users/zsh-autosuggestions
#zinit ice wait'' atinit'zpcompinit' silent; zinit light zdharma/fast-syntax-highlighting
zinit light zdharma/fast-syntax-highlighting

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
zinit ice wait silent; zinit load zsh-users/zsh-syntax-highlighting

# FZF+zsh integration (diff. locations depending on OS).
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && \
  source /usr/share/doc/fzf/examples/key-bindings.zsh
setopt IGNORE_EOF  # disable default CTRL+D behavior
bindkey '^f' fzf-file-widget
bindkey '^d' fzf-cd-widget

# Run a command and then enter interactive mode, e.g.
#   RUN=ls zsh
if [[ -v RUN ]]; then
  exec $RUN  # this joins the child shell
fi

# Otherwise, start a new session in tmux - provided this is a top-level
# interactive shell session.
if [ -z "$TMUX" ]; then
  # Connect to the main tmux session group with a new session. Creates the session
  # group if necessary.
  TMUX_MAIN_SESSION_GROUP_NAME=main
  if tmux list-sessions -F '#{session_name}' | grep -q -w "$TMUX_MAIN_SESSION_GROUP_NAME"; then
    # subsequent session destroy when no clients attached (prevents zombie session
    # buildup)
    $(which tmux) new-session -t "$TMUX_MAIN_SESSION_GROUP_NAME" \; set-option destroy-unattached on
  else
    # first session keepalive
    $(which tmux) new-session -t "$TMUX_MAIN_SESSION_GROUP_NAME"
  fi
fi
