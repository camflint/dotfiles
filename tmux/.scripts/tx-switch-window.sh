#!/usr/bin/env zsh
set -e

source "$(dirname $0)/tx-common.sh"

if [[ -z "$TMUX" ]]; then return 1; fi
local -r fmt='#{window_id}:|#W|(#{?window_active,active,})'
wid=$(tmux list-windows -F "$fmt" \
  | column -t -s'|' \
  | fzf -q '@' --reverse --prompt 'switch window: ' -1 \
  | cut -d':' -f1)
[[ ! -z "$wid" ]] && tmux select-window -t "$wid"
