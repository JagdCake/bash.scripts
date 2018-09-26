#!/bin/bash

### Description ###
# Pomodoro timer, see - https://en.wikipedia.org/wiki/Pomodoro_Technique
# Start an x minute timer
# Print 'x minutes have passed' every x minutes
# Produce an audible 'stop' after x minutes and print a checkmark
# Allow an x minute break
# Produce an audible 'start' after the break and restart the timer
# Repeat from the start until the fourth checkmark and then allow an x minute break
# Repeat from the start
### ###

### Usage ###
# You can just create an alias for the script in '.bashrc' and run it from a terminal
    # alias pomodoro='/path/to/./pomodoro.sh'
    # $ pomodoro
# You can create a symbolic link to the script from your home directory
    # ~$ ln -s /path/to/pomodoro.sh
    # ~$ ./pomodoro.sh
# The script needs its own terminal window / tab to work (run the timer, show messages)
    # stop it with CTRL+C or by closing the terminal
### ###

### Troubleshooting ###
# if the 'spd-say' sound is crackling, open '/usr/share/defaults/speech-dispatcher/speechd.conf' and change 'AudioOutputMethod' to 'libao'
### ###

### Options ###
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

dependency_check() {
    if [ ! $(which speech-dispatcher 2>/dev/null) ]; then
        echo "Dependency: \"speech-dispatcher\" is not installed."
        exit
    fi
}

dependency_check

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

