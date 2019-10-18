# Options.
setopt auto_cd
setopt extended_glob

# Variables.
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

# Aliases.
alias e=vifm
alias v=vim
alias fm=vifm
alias l=less
alias ll='ls -l'
alias la='ls -a'

# Vim mode.
bindkey -v
export KEYTIMEOUT=1

# Keybindings.
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

# Load function-based completion system.
autoload -U compinit
compinit

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# call nvm use automatically whenever you enter a directory that contains an .nvmrc file
autoload -U add-zsh-hook
load-nvmrc() {
 if [[ -f .nvmrc && -r .nvmrc ]]; then
   nvm use >/dev/null
 elif [[ $(nvm version) != $(nvm version default)  ]]; then
   nvm use default >/dev/null
 fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
