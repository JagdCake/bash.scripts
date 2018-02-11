#!/bin/bash

# ===================
# Prompt
# ===================

prmt () {
	read -p "Enter '0' for shutdown or '1' for reboot: " key
}

prmt

# accept the input only if the user enters '0' or '1'
while [[ ! $key =~ [0-1]{1}$ ]]; do	
	echo "Try again!"
	prmt
done

# ===================
# Closing applications
# ===================

# array of applications to close
apps=(transmission-gtk chrome steam) 
appnames=(Transmission, Google Chrome, Steam)

# using SIGTERM to allow programs to exit cleanly
# the wildcard (*) selects all array items
kill -s SIGTERM `pidof ${apps[*]}`; echo "Closing ${appnames[*]}"

# ===================
# Date and time
# ===================

# split the start time and date into two variables
starttime="`uptime -s | awk '{print $2}'`"
startdate="`uptime -s | awk '{print $1}'`"

# makes 'Jan' the item at index 1 of the array
months=(Null Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

# get the start month's number in format "##", e.g. 02 = February
sm="`echo $startdate | awk -F - '{print $2}'`"

# get the current month's number  
cm=`date +%m`

# ===================
# Conditions
# ===================

# removes the 0 from month numbers below 10 so they correspond to that month's index in the array, e.g. 02 becomes 2 which is the index of Feb
if [ $sm -lt 10 ]; then
	smonth="`echo $sm | awk -F 0 '{print $2}'`"
elif [ $sm -ge 10 ]; then
	smonth="`echo $sm`"
fi

# double quotes evaluate any command between them (IF the command is between backticks)
if [ $cm -lt 10 ]; then
	cmonth="`echo $cm | awk -F 0 '{print $2}'`"
elif [ $cm -ge 10 ]; then
	cmonth="`echo $cm`"
fi

# ===================
# Logs
# ===================

# startup time and date 
echo "System powered on at: $starttime on `echo $startdate | awk -F - '{print $3}'` ${months[$sm]} `echo $startdate | awk -F - '{print $1}'`" >> ~/Desktop/shutdown.txt;

if [ $key -eq 0 ]; then
# current time + 20 sec / 5 sec (hh:mm:ss) and the date 
	echo "System shutdown at: `date +%H:%M:%S -d "+20 sec"` on `date +%d` ${months[$cmonth]} `date +%Y`" >> ~/Desktop/shutdown.txt; 
elif [ $key -eq 1 ]; then
	echo "System rebooted at: `date +%H:%M:%S -d "+5 sec"` on `date +%d` ${months[$cmonth]} `date +%Y`" >> ~/Desktop/shutdown.txt;
fi

# system uptime
# using -e so echo recognizes escape characters
echo -e "The system has been `uptime -p`\n" >> ~/Desktop/shutdown.txt

# ===================
# System shutdown
# ===================

if [ $key -eq 0 ]; then
# turn system off after 20 seconds
	sleep 20s; shutdown -P now
elif [ $key -eq 1 ]; then
# reboot system after 5 seconds
	sleep 5s; shutdown -r now
fi
