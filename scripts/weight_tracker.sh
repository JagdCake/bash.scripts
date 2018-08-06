#!/bin/bash

### Description ###
# Enter your weight (in kilograms) once every week (on a specified day)
    # If you've already logged your weight for the week:
        # show the change in weight gain / loss (in kilograms and pounds) from the start 
        # show the change in weight gain / loss (in kilograms and pounds) since last week 
# Log the current (workout) week's number
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

declare -A days
days=([Monday]=1 [Tuesday]=2 [Wednesday]=3 [Thursday]=4 [Friday]=5 [Saturday]=6 [Sunday]=7)
# choose a day for logging your weight
day=${days['Monday']}
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

# e.g. 21 Feb 2018
date=$(date "+%d %b %Y")

weight_prompt() {
    # enter weight in format: ##.#, e.g. 78.3
    read -p "Weight: " kg

    # accept data only if it's formatted properly
    # regex is checking for any number followed by a dot and ending with a single digit
    while [[ ! "$kg" =~ [0-9]\.[0-9]{1}$ ]]; do
        echo "Wrong format. Use: ##.#"
        weightprompt
    done

    # get last week's number (it has to already be in the log file before you run the script for the first time)
    last_week=$(tail -n 4 "$log" | head -n 1 | awk '{ print $2 }')

    week=$(($last_week+1))

    # log the weight for the current week
    echo -e "Week: $week\nDate: "$date"\nWeight: $kg kg / "$(echo "scale=1; $kg / $lb" | bc -l) lb"\n" >> "$log"

    # this part = "$(echo "scale=1; $kg / $lb" | bc -l)" converts the entered value into a floating-point lb value with the help of "bc -l" ("bc" allows float division and the "-l" flag prints the result as a float too, while "scale=1" limits the lb value to the first digit after the decimal point)
}

# day of the week (starts at 1 (Monday))
today=$(date +%u)
last_date=$(tail -n 3 "$log" | head -n 1 | awk -F':' '{ print $2 }' | awk '{$1=$1};1')

if [[ $day -eq $today && "$last_date" != "$date" ]]; then
    weight_prompt
else
    show_weight_change_since 'start'
    show_weight_change_since 'week'
fi

