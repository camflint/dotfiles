#!/usr/bin/env sh

# fzftmuxlist - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `fzftmuxlist` will allow you to select your tmux session via fzf.
# `fzftmuxlist` will attach to the irc session (if it exists), else it will create it.
fzftmuxswitch() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0 --header="[[tmux-switch]]") &&  tmux $change -t "$session" || echo "No sessions found."
}

# zsh; needs setopt re_match_pcre. You can, of course, adapt it to your own shell easily.
fzftmuxkill () {
    local sessions
    sessions="$(tmux ls|fzf --exit-0 --multi --header='[[tmux-kill]]')"  || return $?
    local i
    for i in "${(f@)sessions}"
    do
        [[ $i =~ '([^:]*):.*' ]] && {
            echo "Killing $match[1]"
            tmux kill-session -t "$match[1]"
        }
    done
}

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
