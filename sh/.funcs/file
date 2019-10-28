#!/usr/bin/env bash

fzffileedit() {
    if [[ -z $EDITOR ]]; then
        set EDITOR=vim
    fi

    file=$(fzf --header="[[file-edit (EDITOR: $EDITOR)]]")
    if [[ -n $file ]]; then
        $EDITOR $file
    fi
}

fzffilegrep() {
    file=$(rg --hidden --follow --glob '!.git/*'  --color=always $1 | fzf --ansi --header="[[file-grep (term='$1')]]" | awk -F: '{ print $1 }')
    if [[ -f $file ]]; then
        vifm --select $file
    fi
}

fzfgofile() {
    file=$(fzf --header="[[go-file (pwd: $PWD)]]")
    if [[ -f $file ]]; then
        vifm --select $file
    fi
}
