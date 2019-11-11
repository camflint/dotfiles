#!/usr/bin/env sh

# tmux-switch: quickly create or switch to a session, inside or outside of Tmux.
tmux-switch() {
  sid=$1
  if [[ -z "$sid" ]]; then
    local -r fmt='#{session_id}:|#S|(#{session_attached} attached)'
    sid=$({ tmux display-message -p -F "$fmt" && tmux list-sessions -F "$fmt"; } \
      | awk '!seen[$1]++' \
      | column -t -s'|' \
      | fzf -q '$' --reverse --prompt 'switch session: ' -1 \
      | cut -d':' -f1)
  fi
  local change
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  tmux $change -t "$sid" 2>/dev/null || { tmux new-session -d -s $sid && tmux attach-session -t "$sid"; }
}

alias t='tmux-switch'
