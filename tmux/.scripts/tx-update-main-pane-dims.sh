[ -z "$TMUX" ] && { echo "ERROR: this script must be run from tmux" >&2;
exit; 1; }

while getopts 'w:h:' opt; do
  case "$opt" in
    w) pwidth=$OPTARG ;;
    h) pheight=$OPTARG ;;
  esac
done

if [[ $pwidth -le 0 ]] || [[ $pwidth -gt 100 ]] ||\
   [[ $pheight -le 0 ]] || [[ $pheight -gt 100 ]]; then
  echo 'ERROR: width and height must be percentage values between 1 and 100' >&2;
  exit 1
fi

wwidth=$(tmux display-message -pF '#{window_width}')
wheight=$(tmux display-message -pF '#{window_height}')

width=$(echo "$wwidth * $pwidth / 100" | bc)
# NOTE: it's important we leave 1 line of space for the status line, otherwise tmux will start to have layout issues and
# crash a lot.
height=$(echo "($wheight * $pheight / 100) - 2" | bc)

# Set main-pane-width and main-pane-height
[[ $width -gt 0 && $width -le $wwidth ]] && tmux set-window-option main-pane-width $width
[[ $height -gt 0 && $height -le $wheight ]] && tmux set-window-option main-pane-height $height

#echo "wheight=$wheight, height=$height"

tmux select-layout  # refresh

