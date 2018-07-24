#!/bin/bash

# https://en.wikipedia.org/wiki/Pomodoro_Technique

# if spd-say sound is crackling, open '/usr/share/defaults/speech-dispatcher/speechd.conf' and change 'AudioOutputMethod' to 'libao'

pomodoro_time=25

checkmarks=0

timer() {
    target=$(date +%M -d "+${pomodoro_time} minutes")
    current=$(date +%M)
    passed=0

    while [ $target -ne $current ]; do
        sleep 5m
        echo "$(echo $passed + 5 | bc -l ) minutes have passed"
        passed=$(($passed+5))
        current=$(date +%M)
    done

    spd-say -t female1 'stop'
    echo -e '\nStop'
    checkmarks=$(($checkmarks+1))

    if [ $checkmarks -ne 4 ]; then
        echo '✓'
        echo 'Take a 5 minute break'
        sleep 5m
        spd-say -t female1 'start'
        echo -e '\nStart'
        timer
    else
        echo '✓'
        echo 'Take a 20 minute break'
        sleep 20m
        checkmarks=0
        spd-say -t female1 'start'
        echo -e '\nStart'
        timer
    fi
}

timer

