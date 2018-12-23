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

# select what you want to do
# start / stop tracking time; show a summary; options to correct tracked time; quit

