#!/usr/bin/env sh

function my-edit() {
  if [[ $# == 0 ]]; then
    # No args; invoke vifm.
    vifm -c "cd \"$(pwd)\""
    return
  elif [[ $# == 1 ]]; then
    if [[ -d $1 ]]; then
      # Single arg; directory; invoke vifm on dir.
      vifm -c "cd \"$1\""
    elif [[ -f $1 ]]; then
      # Single arg; file; directly edit with vim.
      vim $1
    fi
  else
    valid=true
    for f in "$a"; do
      if [[ ! -f $f ]]; then $valid=false; fi
    done
    if [[ $valid ]]; then
      # Multi-arg; all files; invoke vim with file arguments.
      vim "$@"
    fi
  fi
}

alias e='my-edit'


