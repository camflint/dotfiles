[ -z "$TMUX" ] && { echo "ERROR: this script must be run from tmux" >&2;
exit; 1; }

main_pane_corners=$(tmux display-message -t.1 -pF '#{pane_at_top} #{pane_at_right} #{pane_at_bottom} #{pane_at_left}')

# TODO: This isn't a perfect check, but it's the best I can think of ATM.
if [ "$main_pane_corners" = "0 0 1 1" ]; then
  # switch from vertical -> horizontal layout
  layout='main-horizontal'
elif [ "$main_pane_corners" = "0 1 0 1" ]; then
  # switch from horizontal -> vertical layout
  layout='main-vertical'
fi

[ -z "$layout" ] && layout='main-vertical'  # default

tmux select-layout "$layout"

