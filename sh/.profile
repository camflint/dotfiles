# Use the vim editor by default for git, bash, etc.
export EDITOR=vim
export GREP=rg
export FIND=fd

export PATH="$HOME/.local/share/vim/plugged/vim-superman/bin:$PATH"

# Locale.
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Disable XON/XOFF to let through <C-S> key events.
stty -ixon

# CDPATH: iCloud.
export CDPATH=.:~:~/Projects:~/Library/Mobile\ Documents/com~apple~CloudDocs

# CDPATH: Git repos.
if [[ -d "$HOME/code" ]]; then
    for d in $HOME/code/*; do
        if [[ -d ${d} ]]; then
            export CDPATH="$d:$CDPATH"
        fi
    done
fi

# CDPATH: Boxcryptor.
box="$HOME/Boxcryptor/iCloud Drive (Mac & PC only)"
if [[ -d $box ]]; then
  export CDPATH="$box:$CDPATH"
  for d in $box/*; do
    if [[ -d ${d} ]]; then
        export CDPATH="$d:$CDPATH"
    fi
  done
fi

# symlink: Google Drive.
[ ! -L "$HOME/icloud" ] &&\
    ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/icloud"
[ ! -L "$HOME/gdrive_convoy" ] &&\
    ln -s "/Volumes/GoogleDrive/My Drive" "$HOME/gdrive_convoy"
[ ! -L "$HOME/gdrive" ] &&\
    ln -s "/Volumes/GoogleDrive/My Drive/Bridge" "$HOME/gdrive"

# symlink: Notes.
[ ! -L "$HOME/notes_convoy" ] &&\
  ln -s "$HOME/gdrive_convoy/notes" "$HOME/notes_convoy"
[ ! -L "$HOME/notes" ] &&\
  ln -s "$HOME/gdrive/notes" "$HOME/notes"

# GNU tools.
GNU_PATH=/usr/local/opt/coreutils/libexec/gnubin
GNU_PATH=$GNU_PATH:/usr/local/opt/gnu-sed/libexec/gnubin
GNU_PATH=$GNU_PATH:/usr/local/opt/gnu-tar/libexec/gnubin
[[ -d "$GNU_PATH" ]] && export PATH="$GNU_PATH:$PATH"

GNU_MANPATH=/usr/local/opt/coreutils/libexec/gnuman
GNU_MANPATH=$GNU_MANPATH:/usr/local/opt/gnu-sed/libexec/gnuman
GNU_MANPATH=$GNU_MANPATH:/usr/local/opt/gnu-tar/libexec/gnuman
[[ -d "$GNU_MANPATH" ]] && export MANPATH="$GNU_MANPATH:$MANPATH"

TEXINFO_PATH=/usr/local/opt/texinfo/bin
[[ -d "$TEXINFO_PATH" ]] && export PATH="$TEXINFO_PATH:$PATH"

# Homebrew.
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Python.
alias python="python3"
alias pip="pip3"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Golang.
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# FZF.
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --ignore-case --glob "!.git/*" "!node_modules/*"'
export FZF_DEFAULT_OPTS="
--bind='ctrl-d:page-down,ctrl-u:page-up'
--bind='ctrl-j:down,ctrl-k:up'
--bind='ctrl-n:down,ctrl-p:up'
--bind='alt-n:preview-down,alt-p:preview-up'
--bind='alt-d:preview-page-down,alt-u:preview-page-up'
--bind='?:toggle-preview'
--bind='alt-w:toggle-preview-wrap'
"

export FZF_CTRL_T_COMMAND='"$(command which fd)" --type f --type d --type l --hidden --no-ignore --follow --color never . 2> /dev/null'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}' --preview-window=right:67% --height=80%"

export FZF_ALT_C_COMMAND='"$(command which fd)" --type d --hidden --no-ignore --follow --color never . 2> /dev/null'
export FZF_ALT_C_OPTS="--preview 'tree -a -C -L 1 {} | head -100' --preview-window=right:67% --height=80%"

# Node.js, npm, nvm, etc.
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
