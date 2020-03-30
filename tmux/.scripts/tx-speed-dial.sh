#!/usr/bin/env zsh

local script_dir="$(dirname ${(%):-%x})"

local -A keypad
keypad[1]='shipotle'
keypad[2]='nacho'
keypad[3]='dotfiles'
keypad[4]=''
keypad[5]=''
keypad[6]=''
keypad[7]=''
keypad[8]=''
keypad[9]=''
keypad[10]=''

local cmd='list'
local num=
while getopts 'lg:' name; do
  case "$name" in
    l) cmd='list' ;;
    g) cmd='go'; num=$OPTARG ;;
  esac
done

function _list() {
  for n in {0..10}; do
    if [ $n -eq 0 ]; then 
      echo "No.,Name"
    else
      echo "$n,$keypad[$n]"
    fi
  done |\
    column -t -s','
}

function _go() {
  local n=$1
  if [ $n -lt 1 ] || [ $n -gt 10 ]; then
    echo 'Invalid dial: must specify a number betwen 1 and 10' >&2
    return 1
  fi

  "${script_dir}/tx-switch-client.sh" "${keypad[$n]}" ||\
    { make_project "${keypad[$n]}" }
}

case "$cmd" in
  list) _list
    ;;
  go) _go $num
    ;;
esac

