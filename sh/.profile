# Use the vim editor by default for git, bash, etc.
export EDITOR=vim

# Locale.
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Disable XON/XOFF to let through <C-S> key events.
bindkey -r '\C-s'
stty -ixon

# Path completion.
export CDPATH=.:~:~/Projects:~/Library/Mobile\ Documents/com~apple~CloudDocs
if [[ -d "$HOME/code" ]]; then
    for d in $HOME/code/*; do
        if [[ -d ${d} ]]; then
            export CDPATH="$d:$CDPATH"
        fi
    done
fi
box="$HOME/Boxcryptor/iCloud Drive (Mac & PC only)"
if [[ -d $box ]]; then
  export CDPATH="$box:$CDPATH"
  for d in $box/*; do;
    if [[ -d ${d} ]]; then
        export CDPATH="$d:$CDPATH"
    fi
  done
fi

# Keybindings.
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

# GNU tools.
GNU_PATH=/usr/local/opt/coreutils/libexec/gnubin
GNU_PATH=$GNU_PATH:/usr/local/opt/gnu-sed/libexec/gnubin
GNU_PATH=$GNU_PATH:/usr/local/opt/gnu-tar/libexec/gnubin
export PATH="$GNU_PATH:$PATH"

GNU_MANPATH=/usr/local/opt/coreutils/libexec/gnuman
GNU_MANPATH=$GNU_MANPATH:/usr/local/opt/gnu-sed/libexec/gnuman
GNU_MANPATH=$GNU_MANPATH:/usr/local/opt/gnu-tar/libexec/gnuman
export MANPATH="$GNU_MANPATH:$MANPATH"

# Python.
alias python="python3"
alias pip="pip3"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Golang.
export PATH=$HOME/go/bin:$PATH

# Homebrew.
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# FZF.
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --smart-case --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--bind=ctrl-j:down,ctrl-k:up'

# Node.js, npm, nvm, etc.
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
export PATH="./node_modules/.bin:$PATH"

# External sources.
for name in ".sources" ".sources_local"; do
  if [[ -d "$HOME/$name" ]]; then
    for src in $HOME/$name/*; do
      . $src
    done
  fi
done

# Externals scripts to be made available on the PATH.
if [[ -d "$HOME/.scripts" ]]; then
    export PATH="$HOME/.scripts:$PATH"
fi

