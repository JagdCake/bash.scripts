#!/bin/bash

# ====================
# Solus specific (probably)

# copy the script to home dir (cp ~/Documents/shellScripts/scripts/./nightLight.sh ~/) autostart the script in the background (./nightLight.sh &)

# keep track of it with 'ps aux | grep nightLight'

# stop it with 'kill ID'

# ====================

# applications to look for
apps=(mpv hl2_linux CompanyOfHeroes2)
arraylength=${#apps[@]}

# loop indefinitely (this doesn't seem good)
while true;
do
# if any of the apps are running assign '1' to the var, if not assign '0' (only one app can run at a time)
# iterate over the array items
for (( i=0; i<${arraylength}; i++ ));
do
	check=`ps -ef | grep ${apps[$i]} | grep -v "grep" | wc -l`
done

# if one of the apps is running turn night-light off and vice versa
if [ "$check" -eq 1 ]; then
	gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
elif [ "$check" -eq 0 ]; then
	gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
fi
done
