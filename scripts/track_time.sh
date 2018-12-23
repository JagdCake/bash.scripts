#!/bin/bash

### Description ###
# Choose between tracking time — spent learning, working or working out
# Decide if you want to start / stop tracking time, display a summary or correct tracked time
### ###

dependency_check() {
    if [ ! $(which timew 2>/dev/null) ]; then
        echo "Dependency: \"timewarrior\" is not installed."
        exit 1
    fi
}

dependency_check

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

# show a "start" option only if nothing is being tracked
if [ $? -ne 0 ]; then
    options=("Start $noun")
else
    options=("Stop $noun")
fi

options+=("Summary" "Corrections" "Quit")

corrections() {
    timew summary :ids
    read -p "Correct entry with ID: " id

    select correction in "Change start time" "Change end time" "Shorten" "Lengthen" "Cancel"; do
        case "$correction" in
            "Change start time" )
                read -p "Start time: " correct_time
                timew start "$id" "$correct_time"
                break;;
            "Change end time" )
                read -p "End time: " correct_time
                timew stop "$id" "$correct_time"
                break;;
            "Shorten" )
                read -p "Shorten by: " correct_time
                timew shorten "$id" "$correct_time"
                break;;
            "Lengthen" )
                read -p "Lengthen by: " correct_time
                timew lengthen "$id" "$correct_time"
                break;;
            "Cancel" )
                return;;
        esac
    done
}

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
        'Corrections' )
            corrections
            break;;
        "Quit" )
            exit;;
    esac
done

# rerun the script to update the options 
~/Documents/code.github/bash.scripts/scripts/./track_time.sh "$tag"

