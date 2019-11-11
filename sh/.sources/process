#!/usr/bin/env sh

# Lists open network handles and returns PID of picked process.
function selectnetworkhandle() {
  header=$1
  pid=$(
    lsof -i -n -P |
    tail -n +2 |
    awk 'BEGIN { OFS="," } { print $2,$1,$9 }' |
    fzf --multi --header="[[ $1 ]]" |
    cut -d, -f1)
  echo $pid
}

function netkill() {
  pid=$(selectnetworkhandle "kill process w/ conn")
  if [[ -n "$pid" ]]; then
    ps -f $pid && echo ""
    read -r -q y\?"Kill process [$pid] (y/n)? " && \
      kill -9 $pid && echo &&
      echo "Killed $pid."
  fi
}

