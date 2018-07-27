#!/bin/bash

# https://en.wikipedia.org/wiki/Pomodoro_Technique

# if spd-say sound is crackling, open '/usr/share/defaults/speech-dispatcher/speechd.conf' and change 'AudioOutputMethod' to 'libao'

### options ###
pomodoro_time=25
small_break=5
big_break=20

icons=(🍅 ✓ ✔ ✅ ✗ ✘)
checkmark_icon=${icons[0]}

voice_options=(male1 male2 male3 female1 female2 female3 child_male child_female)
voice_type=${voice_options[4]}
start_message='Start!'
stop_message='Stop!'
### ###

# Source: https://stackoverflow.com/questions/38868665/multiplying-strings-in-bash-script/38868864#38868864 
multiply_string() {
    string="$1"
    count="$2"

    multiply="$(printf "%${count}s")"
    echo "${multiply// /$string}"
}

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

    spd-say -t $voice_type "$stop_message"

    echo -e "\n${stop_message}"
    checkmarks=$(($checkmarks+1))

    if [ $checkmarks -ne 4 ]; then
		multiply_string "$checkmark_icon" $checkmarks
        echo "Take a ${small_break} minute break."
        sleep ${small_break}m
        spd-say -t $voice_type "$start_message"
        echo -e "\n${start_message}"
        timer
    else
		multiply_string "$checkmark_icon" $checkmarks
        echo "Take a ${big_break} minute break."
        sleep ${big_break}m
        checkmarks=0
        spd-say -t $voice_type "$start_message"
        echo -e "\n${start_message}"
        timer
    fi
}

echo -e "\n${start_message}"

checkmarks=0
timer

