#!/bin/bash

# ====================
# copy the script to the home dir, start (with 'watch -n 3' (update every 3 seconds)) in the background (with '&') and send the output to disappear inside 'null' (with '> /dev/null &') 
# 'watch -n 3 ./nightLight.sh &> /dev/null &'

# keep track of it with 'top -p `pidof watch`'

# stop it with 'kill ID'
# ====================

# check if any of the specified applications are currently running
if [[ $(pgrep hl2_linux) || $(pgrep mpv) || $(pgrep CompanyOfHeroes2) ]]; then
	check=1
else
	check=0
fi

# if any one of the apps is running turn night-light off and vice versa
if [ "$check" -eq 1 ]; then
	gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
else
	gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
fi
