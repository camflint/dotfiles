#!/usr/bin/env bash

ignore_files=$(mktemp)
trap "rm -f $ignore_files" EXIT

git ls-files -o -i --exclude-from=.gitignore > $ignore_files

files=(`find dotfiles -type f -print |\
    grep -vxF -f $ignore_files`)

dirs=(`sort -u <(for f in "${files[@]}"; do dirname "$f"; done)`)

for src in "${dirs[@]}"; do
    dst="${src/dotfiles/$HOME}"
    if [ ! -d "$dst" ]; then
        mkdir -p "$dst"
    fi
done

src_root=`pwd -P`
for src in "${files[@]}"; do
    dst="${src/dotfiles/$HOME}"
    if [ ! -e "$dst" ] || [ -L "$dst" ]; then
        ln -s -f "$src_root/$src" "$dst"
    fi
done

