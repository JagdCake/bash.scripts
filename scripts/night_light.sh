#!/bin/bash

### Usage ###
# Create an alias for the script in '.bashrc' and run it from a terminal
    # alias togglenightl='watch -n [x] /path/to/./night_light.sh &> /dev/null &'
        # 'watch -n [x]' runs the script every x seconds, for example - 3 
        # '&> /dev/null &' redirects the output, so the script can run in the background
    # $ togglenightl
# Keep track of it with 'jobs' (have to be in the same terminal)
    # stop it by closing the shell / killing it with 'kill %[jobs ID]'
### ###

### Options ###
# set your screen resolution
res_width=1920
res_height=1080
### ###

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

