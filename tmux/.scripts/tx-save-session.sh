#!/usr/bin/env zsh
set -e

source "$(dirname $0)/tx-common.sh"

echo $(tmux display-message -p -F "#{session_id}") > "$last_session_id_file"

