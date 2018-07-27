#!/bin/bash

# https://en.wikipedia.org/wiki/Pomodoro_Technique

# if spd-say sound is crackling, open '/usr/share/defaults/speech-dispatcher/speechd.conf' and change 'AudioOutputMethod' to 'libao'

pomodoro_time=25
small_break=5
big_break=20

checkmarks=0

timer() {
    target=$(date +%M -d "+${pomodoro_time} minutes")
    current=$(date +%M)
    passed=0

    while [ $target -ne $current ]; do
        sleep ${small_break}m
        echo "$(echo $passed + $small_break | bc -l ) minutes have passed."
        passed=$(($passed+$small_break))
        current=$(date +%M)
    done

    spd-say -t female1 'stop'
    echo -e '\nStop'
    checkmarks=$(($checkmarks+1))

    if [ $checkmarks -ne 4 ]; then
        echo '✓'
        spd-say -t female1 'start'
        echo -e '\nStart'
        echo "Take a ${small_break} minute break."
        sleep ${small_break}m
        timer
    else
        echo '✓'
        echo "Take a ${big_break} minute break."
        sleep ${big_break}m
        checkmarks=0
        spd-say -t female1 'start'
        echo -e '\nStart'
        timer
    fi
}

timer

