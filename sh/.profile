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
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -al'
alias rg='rg --hidden --smart-case'
alias base16="base16-universal-manager --config=\"$HOME/.config/base16/config.yaml\""

# Locale.
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Path completion.
export CDPATH=.:~:~/Projects:~/Library/Mobile\ Documents/com~apple~CloudDocs
if [[ -d "$HOME/code" ]]; then
    for d in $HOME/code/*; do
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
#export PATH=/Users/cameron/Library/Python/3.7/bin:$PATH

# Tmux.
alias tmux="tmux -2 -u"  # Force 256 colors and UTF-8.

# FZF.
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --smart-case --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--bind=ctrl-j:down,ctrl-k:up'

# Work machine setup.
if [[ `hostname` == 'C02Y777XJG5H' ]]; then
    export VAULT_CAPATH=/Users/$USER/code/convoyinc/ops/credentials/convoy-vault-ca.cert.pem
    #export VAULT_ADDR=https://mcp.greypoint.co:8200 # Does not work on OSX. See below.
    export VAULT_ADDR=https://10.10.27.22:8200

    export PGHOST=localhost
    export PGPORT=5432
else
    export DIGITAL_OCEAN_TOKEN=841bf46a5f685dab3f76013f86cb8639a9350d9ea24fea39c98afc48b05bd72f
    export PIPENV_VENV_IN_PROJECT=1
fi

# Node.js, npm, nvm, etc.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
export PATH="./node_modules/.bin:$PATH"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# Colorscheme selection.
base16_nord
