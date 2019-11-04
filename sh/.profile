# Use the vim editor by default for git, bash, etc.
export EDITOR=vim

# General aliases.
alias r=ranger
alias v=vim
alias e=vim
alias g='grep -iER'
alias f=find
alias gt=git
alias fm='vifm .'
alias d=docker
alias ls='exa --icons'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -al'
alias rg='rg --hidden --smart-case'
alias nater='tmuxinator'

# Locale.
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Source local-only files.
for file in "~/.profile_work" "~/.profile_home" "~/.profile_secrets"; do
  if [[ -f $file ]]; then
    source $file
  fi
done

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

# Personal scripts and global functions.
if [[ -d "$HOME/.scripts" ]]; then
    export PATH="$HOME/.scripts:$PATH"
fi
if [[ -d "$HOME/.funcs" ]]; then
    for file in $HOME/.funcs/*.sh; do
        . $file
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

# Tmux.
alias tmux="tmux -2 -u"  # Force 256 colors and UTF-8.

# FZF.
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --smart-case --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--bind=ctrl-j:down,ctrl-k:up'

# Node.js, npm, nvm, etc.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
export PATH="./node_modules/.bin:$PATH"

# Base16 colorscheme & customizations.
[[ -s "./base16.sh" ]] && \
  . "./base16.sh"
