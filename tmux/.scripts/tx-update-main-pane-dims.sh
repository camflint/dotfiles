[ -z "$TMUX" ] && { echo "ERROR: this script must be run from tmux" >&2;
exit; 1; }

while getopts 'w:h:' opt; do
  case "$opt" in
    w) width=$OPTARG ;;
    h) height=$OPTARG ;;
  esac
done

if [[ $width -le 0 ]] || [[ $width -gt 100 ]] ||\
   [[ $height -le 0 ]] || [[ $height -gt 100 ]]; then
  echo 'ERROR: width and height must be percentage values between 1 and 100' >&2;
  exit 1
fi

cwidth=$(tmux display-message -pF '#{client_width}')
cheight=$(tmux display-message -pF '#{client_height}')

pwidth=$(expr $cwidth \* $width \/ 100)
pheight=$(expr $cheight \* $height \/ 100)

tmux set-window-option main-pane-width $pwidth
tmux set-window-option main-pane-height $pheight
tmux select-layout

