# #!/usr/bin/env bash


xinput set-prop "SynPS/2 Synaptics TouchPad" $(xinput list-props "SynPS/2 Synaptics TouchPad" | grep "Natural Scrolling Enabled" | awk -F'[()]' 'NR==1 {print $(NF-1)}' ) 1 &
xinput set-prop "SynPS/2 Synaptics TouchPad" $(xinput list-props "SynPS/2 Synaptics TouchPad" | grep "Tapping Enabled" | awk -F'[()]' 'NR==1 {print $(NF-1)}' ) 1 &
sxhkd &
picom &
dunst &
sh ~/.config/polybar/launch.sh &
. ~/.fehbg &
nm-applet &
volctl &
optimus-manager-qt &
discord --start-minimized &
spotify-tray -m &
mailspring -b &
