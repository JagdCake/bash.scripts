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

# get last week's number (it has to already be in the log file before you run the script for the first time)
last_week=$(tail -n 4 "$log" | head -n 1 | awk '{printf $2}')

week=$(($last_week+1))

# e.g. 21 Feb 2018
date=`date "+%d %b %Y"`

weightprompt () {
# enter weight in format: ##.#, e.g. 78.3
	read -p "Weight: " kg
}

# prompt the user for input
weightprompt

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

