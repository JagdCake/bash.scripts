#!/bin/bash

### Description ###
# Enter your weight (in kilograms) once every week
# Log the current workout week's number
# Log the current date
# Convert the weight from kg to pounds and log both values
### ###

### Usage ###
# You can just create an alias for the script in '.bashrc' and run it from a terminal
    # alias weighttracker='/path/to/./weight_tracker.sh'
    # $ weighttracker
# You can create a symbolic link to the script from your home directory
    # ~$ ln -s /path/to/weight_tracker.sh
    # ~$ ./weight_tracker.sh
# usable only for weekly weight tracking
### ###

### Options ###
# log file location
log=~/Desktop/weight.txt
### ###

# Log format
# Week: #
# Date: ## Month ####
# Weight: ##.# kg / ##.# lb
# \n (newline)

lb=0.45359

show_weight_change_since() {
    if [ "$1" == 'start' ]; then
        start_weight=$(head -n 3 "$log" | tail -n 1 | awk '{ print $2 }')
        point_in_time=$(head -n 2 "$log" | tail -n 1 | awk -F':' '{ print $2 }' | awk '{$1=$1};1')
    elif [ "$1" == 'week' ]; then
        start_weight=$(tail -n 8 "$log" | head -n 3 | tail -n 1 | awk '{ print $2 }')
        point_in_time='last week'
    fi

    current_weight=$(tail -n 2 "$log" | head -n 1 | awk '{ print $2 }')

    kg_difference=$(echo "scale=1; $start_weight - $current_weight" | bc -l)
    lb_difference=$(echo "scale=1; $kg_difference / $lb" | bc -l)

    if [ $(echo "$start_weight > $current_weight" | bc) -eq 1 ]; then
        echo "You have lost: $kg_difference kg / $lb_difference lb, since "$point_in_time""
    else
        kg_positive=$(echo "scale=1; $kg_difference * -1" | bc)
        lb_positive=$(echo "scale=1; $lb_difference * -1" | bc)
        echo "You have gained: $kg_positive kg / $lb_positive lb, since "$point_in_time""
    fi
}


# accept data only if it's formatted properly
# regex is checking for any number followed by a dot and ending with a single digit
while [[ ! "$kg" =~ [0-9]\.[0-9]{1}$ ]]; do
	echo "Wrong format. Use: ##.#"
	weightprompt
done

lb=0.45359

# log the weight for the current week
echo -e "Week: $week\nDate: $date\nWeight: $kg kg / "$(echo "scale=1; $kg / $lb" | bc -l) lb"\n" >> "$log"

# this part = "$(echo "scale=1; $kg / $lb" | bc -l)" converts the entered value into a floating-point lb value with the help of "bc -l" ("bc" allows float division and the "-l" flag prints the result as a float too, while "scale=1" limits the lb value to the first digit after the decimal point)

