# Source common configuration.
source $HOME/.profile

# Customize the prompt.
PS1BAK=$PS1
PS1="[\[\033[1;36m\]\w\[\033[0m\]]$ "

# Personal scripts and global functions.
if [[ -d "$HOME/.scripts" ]]; then
    export PATH="$HOME/.scripts:$PATH"
fi
if [[ -d "$HOME/.funcs" ]]; then
    for file in $HOME/.funcs/*; do
        . $file
    done
fi
#
# Node.js, npm, nvm, etc.
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Bash completion.
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

