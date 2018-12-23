#!/bin/bash

# choose what to track with an argument — learn, work, workout
tag="$1"

if [ "$tag" == 'learn' ]; then
    noun='learning'
elif [ "$tag" == 'work' ]; then
    noun='working'
elif [[ "$tag" == 'workout' || "$tag" == 'workout_off_day' ]]; then
    day=$(date +%u)

    if [[ $day -eq 1 || $day -eq 3 || $day -eq 5 ]]; then
        noun='off day workout'
        tag='workout_off_day'
    elif [[ $day -eq 2 || $day -eq 4 || $day -eq 7 ]]; then
        noun='workout'
    fi
fi

# check if timewarrior is tracking something
timew >/dev/null 2>&1

# start / stop tracking time; show a summary; options to correct tracked time; quit

# show a "start" option only if nothing is being tracked
if [ $? -ne 0 ]; then
    options=("Start $noun")
else
    options=("Stop $noun")
fi

options+=("Summary" "Quit")

# select what you want to do
select option in "${options[@]}"; do
   case "$option" in
        "Start $noun" )
            timew start "$tag"
            break;;
        "Stop $noun" )
            timew stop "$tag"
            break;;
        'Summary' )
            timew summary year "$tag"
            break;;
        "Quit" )
            exit;;
    esac
done

# rerun the script to update the options 
~/Documents/code.github/bash.scripts/scripts/./track_time.sh "$tag"

