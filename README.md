# camflint/dotfiles

This repository contains the personal dotfiles which I use and maintain for Unix-based systems (primarily Mac OS). I frequently incorporate useful random scripts, snippets, functions, etc.  I find elsewhere on the web in addition to hacking my own workflow. I typically do my best to attribute or link to the respective source in such cases. You are free to adapt anything you find here for your own use, or use it as a starting point, at your own risk of course.

## Usage

My dotfiles make use of primarily two excellent filesystem management / configuration backup utilities, [GNU Stow](https://www.gnu.org/software/stow/) and [Mackup](https://github.com/lra/mackup). Assuming you have these installed on your system, you can follow the steps below. 

You should probably have a reasonable idea of how Stow and Mackup work before running these commands. It's also a good idea to  close any relevant applications you are restoring dotfiles for, first.

```bash
git clone https://github.com/camflint/dotfiles.git ~/dotfiles

cd ~/dotfiles
stow sh
stow tmux
stow vim
...

cd ~/dotfiles/mackup
mackup restore
```

## Favorite applications

I use the following applications daily both at work and at home. I make sure their configs are sourced from this repository, so that I can keep my favorites in sync in both environments.

|Application|Purpose|
|:-|:-|
| Alacritty | terminal emulator |
| Firefox | w/ Tridactyl plugin for Vim-like keyboard operation |
| Zsh | shell |
| Tmux | multiplexer |
| Vim | editor and IDE replacement |
| MacVim | standalone Vim handy for certain use cases, e.g. when I want a floating window |
| Vifm | terminal-based file manager with VI-mode bindings |
| iStat Menus 6 | CPU, GPU, memory, etc. monitor in taskbar |
| Moom | window and workspace manager |
| Contexts | Cmd+Tab replacement |
| Smooze | better mousewheel and scrolling |
| Lunar | display brightness/contrast management |
| Hammerspoon | automation |
| Karabiner Elements | keyboard mappings |
| CopyClip | clipboard ring in system tray |
| Various productivity apps | currently Spark, Fantastical 2, Todoist, Notion, Anki |

