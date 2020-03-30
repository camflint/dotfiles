#!/usr/bin/env zsh

target="$1"

# Before switching, save the current session (for alternate switching).
"$(dirname $0)/tx-save-session.sh"

local change
[ -n "$TMUX" ] && change='switch-client' || change='attach-session'
exec tmux $change -t "$target"
