# General aliases.
alias r=ranger
alias v=vim
alias e=vim
alias g='grep -iER'
alias f=find
alias gt=git
alias fm='vifm .'

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PIPENV_VENV_IN_PROJECT=1

export DIGITAL_OCEAN_TOKEN=841bf46a5f685dab3f76013f86cb8639a9350d9ea24fea39c98afc48b05bd72f

# Homebrew.
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=/Users/cameron/Library/Python/3.7/bin:$PATH

# Tmux.
alias tmux="tmux -2 -u"  # Force 256 colors and UTF-8.

# Bash completion.
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# CDPATH.
export CDPATH=.:~:~/Projects:~/Library/Mobile\ Documents/com~apple~CloudDocs

