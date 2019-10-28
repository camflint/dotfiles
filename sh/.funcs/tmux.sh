#!/usr/bin/env sh

function tmux-switch() {
  if [[ $# != 1 ]]; then
    # No arg: display picker.
    name=$(tmux ls | fzf | cut -d: -f1)
    if [[ -n $name ]]; then
      tmux attach -t $name
    fi
  else
    # One arg: switch to session, or create if not found.
    if tmux has-session -t $1 &> /dev/null; then
      tmux attach -t $1
    else
      tmux new-session -s $1 -n $1
    fi
  fi
}

alias t='tmux-switch'
