#!/bin/bash

# ===================
# Close applications
# ===================
close_apps() {
    # array of applications to close
    apps=(transmission-gtk firefox steam) 
    app_names=(Transmission, Firefox, Steam)

    # using SIGTERM to allow programs to exit cleanly
    # "@" calls the array items as separate strings
    kill -s SIGTERM `pidof "${apps[@]}"` && echo "Closing "${app_names[@]}""
}

# ===================
# Write to log
# ===================
log=~/Desktop/shutdown.txt

# if the log file doesn't exist, create it
if [ -e "$log" ]; then
    touch "$log"
fi

shutdown_or_reboot() {
    time_to_shutdown=10
    time_to_reboot=5

    close_apps

    # startup time and date 
    echo "System powered on at: $startTime on `echo $startDate | awk -F - '{print $3}'` ${months[$sM]} `echo $startDate | awk -F - '{print $1}'`" >> "$log"

    if [ $1 == 'shutdown' ]; then
    # current time + 10 sec / 5 sec (hh:mm:ss) and the date 
        echo "System shutdown at: `date +%H:%M:%S -d "+$time_to_shutdown sec"` on `date +%d` ${months[$cMonth]} `date +%Y`" >> "$log" 
    elif [ $1 == 'reboot' ]; then
        echo "System rebooted at: `date +%H:%M:%S -d "+$time_to_reboot sec"` on `date +%d` ${months[$cMonth]} `date +%Y`" >> "$log"
    fi

    # system uptime
    # using -e so echo can recognize escape characters
    echo -e "The system has been `uptime -p`\n" >> "$log"
}

# ===================
# Date and time
# ===================
# split the start time and date into two variables
startTime="`uptime -s | awk '{print $2}'`"
startDate="`uptime -s | awk '{print $1}'`"

# makes 'Jan' the item at index 1 of the array
months=(Null Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

# get the start month's number in format "##", e.g. 02 = February
sM="`echo $startDate | awk -F - '{print $2}'`"

# get the current month's number  
cM=`date +%m`

# removes the 0 from month numbers below 10 so they correspond to that month's index in the array, e.g. 02 becomes 2 which is the index of Feb
if [ $sM -lt 10 ]; then
	sMonth="`echo $sM | awk -F 0 '{print $2}'`"
elif [ $sM -ge 10 ]; then
	sMonth="`echo $sM`"
fi

# double quotes evaluate any command between them (IF the command is between backticks)
if [ $cM -lt 10 ]; then
	cMonth="`echo $cM | awk -F 0 '{print $2}'`"
elif [ $cM -ge 10 ]; then
	cMonth="`echo $cM`"
fi

# ===================
# Select
# ===================
select thing_to_do in "Shutdown" "Reboot" "Cancel"; do
    case $thing_to_do in
        Shutdown )
            shutdown_or_reboot shutdown
            # turn system off after 10 seconds
            sleep ${time_to_shutdown}s; shutdown -P now
            exit;; 
        Reboot )
            shutdown_or_reboot reboot
            # reboot system after 5 seconds
            sleep ${time_to_reboot}s; shutdown -r now
            exit;; 
        Cancel ) 
            exit;;
    esac
done
