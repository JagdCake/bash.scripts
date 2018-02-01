#!/bin/bash
# using SIGTERM to allow programs to exit cleanly
kill -s SIGTERM `pidof tixati`; echo 'Exiting Tixati...'
kill -s SIGTERM `pidof chrome`; echo 'Exiting Chrome...'
kill -s SIGTERM `pidof steam`; echo 'Exiting Steam...'

# split the start time and date into two variables
starttime="`uptime -s | awk '{print $2}'`"
startdate="`uptime -s | awk '{print $1}'`"

# double quotes evaluate any command between them (IF the command is between backticks) while single quotes print out a literal string
echo "System powered on at: $starttime on $startdate" >> /home/jagdcake/Desktop/shutdown.txt;

# displays the current time + 30 seconds (hh:mm:ss) and the date 
echo "System shutdown at: `date +%H:%M:%S -d "+30 sec"` on `date +%Y-%m-%d`" >> /home/jagdcake/Desktop/shutdown.txt; 

# using -e so echo recognizes escape characters
echo -e "The system has been `uptime -p`\n" >> /home/jagdcake/Desktop/shutdown.txt

# turn system off after 30 seconds
sleep 30s; shutdown -P now
