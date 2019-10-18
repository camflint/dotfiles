#!/usr/bin/env bash

folders=(
	"bash"
	"config"
	"gdb"
	"git"
	"hammerspoon"
	"mackup"
	"readline"
	"tmux"
	"vim"
	"zsh"
)

for folder in ${folders[@]}; do
	stow $folder -t $HOME
done
