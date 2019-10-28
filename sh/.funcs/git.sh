#!/usr/bin/env bash

# fshow - git commit browser
#   source: https://github.com/junegunn/fzf/issues/150
fzfgitshow() {
  local out sha q
  while out=$(
      git log --graph --color=always \
          --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" |
      fzf --ansi --multi --no-sort --reverse --query="$q" --print-query --header="[[git show]]"); do
    q=$(head -1 <<< "$out")
    while read sha; do
      [ -n "$sha" ] && git show --color=always $sha | less -R
    done < <(sed '1d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
  done
}

# fgst - pick files from `git status -s` 
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

# fzfgitstatus - git status
#   source: https://github.com/junegunn/fzf/wiki/examples
fzfgitstatus() {
  # "Nothing to see here, move along"
  is_in_git_repo || return

  local cmd="${FZF_CTRL_T_COMMAND:-"command git status -s"}"

  eval "$cmd" | FZF_DEFAULT_OPTS="--reverse $FZF_CTRL_T_OPTS" fzf -m "$@" --header="[[git status]]" | while read -r item; do
    echo "$item" | awk '{print $2}'
  done
  echo
}

