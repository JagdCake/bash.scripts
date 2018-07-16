#!/bin/bash

# ====================
# copy the script to the home dir, start (with 'watch -n 3' (update every 3 seconds)) in the background (with '&') and send the output to disappear inside 'null' (with '> /dev/null &') 
# "watch -n 3 ./nightLight.sh &> /dev/null &"

# keep track of it with "jobs" (have to be in the same shell) or 'top -p `pidof watch`'

# stop it by closing the shell
# ====================

# set your screen resolution
res_width=1920
res_height=1080

# get the id of the active window
active_window="`xprop -root _NET_ACTIVE_WINDOW | awk -F'#' '{print $2}'`"

width=`xwininfo -id ${active_window} | awk -F'Width:' '{print $2}' | tr -d '[:space:]'`
height=`xwininfo -id ${active_window} | awk -F'Height:' '{print $2}' | tr -d '[:space:]'`
name=`xwininfo -id ${active_window} | awk -F'"' '{print $2}' | tr -d '[:space:]'`

if [ $name != 'Desktop' -a $width -eq $res_width -a $height -eq $res_height ]; then
	gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
else
	gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
fi

