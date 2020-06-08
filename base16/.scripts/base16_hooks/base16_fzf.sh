#!/usr/bin/env zsh

if [ -n "$BASE16_THEME" ]; then
  fzf_config="${HOME}/.local/share/base16-fzf/bash/base16-${BASE16_THEME}.config"
  if [ -f "$fzf_config" ]; then
    eval "$(cat "$fzf_config")"
  fi
fi
