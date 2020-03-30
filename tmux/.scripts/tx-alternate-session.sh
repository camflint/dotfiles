#!/usr/bin/env zsh
set -e

source "$(dirname $0)/tx-common.sh"

if [ -z "$TMUX" ]; then
  echo 'ERROR: Only works inside tmux' >&2
  exit 1
fi

local sid=''
if [ -f "$last_session_id_file" ] && [ $(wc -l "$last_session_id_file" | awk '{print $1}') -ge 1 ]; then
  sid=$(head -n 1 "$last_session_id_file")
fi

if [ -z "$sid" ]; then
  tmux display-message 'No alternate session found!'
else
  "$(dirname $0)/tx-save-session.sh"
  tmux switch-client -t "$sid" 2>/dev/null
fi

