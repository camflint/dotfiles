#!/usr/bin/env zsh

sid=$1
if [[ -z "$sid" ]]; then
  local -r fmt='#{session_id}:|#S|(#{session_attached} attached)'
  sid=$({ tmux display-message -p -F "$fmt" && tmux list-sessions -F "$fmt"; } \
    | awk '!seen[$1]++' \
    | column -t -s'|' \
    | fzf -q '$' --reverse --prompt 'switch session: ' -1 \
    | cut -d':' -f1)
fi
if [[ -z "$sid" ]]; then
  exit 1
fi

"$(dirname $0)/tx-switch-client.sh" "$sid" ||\ 
  { tmux new-session -d -s "$sid" && tmux attach-session -t "$sid"; }
