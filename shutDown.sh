#!/bin/bash
# using SIGTERM to allow programs to exit cleanly
kill -s SIGTERM `pidof tixati`; echo 'Exiting Tixati...'
kill -s SIGTERM `pidof chrome`; echo 'Exiting Chrome...'
kill -s SIGTERM `pidof steam`; echo 'Exiting Steam...'
echo "System powered on at: `uptime -s`" >> /home/jagdcake/Desktop/shutdown.txt;
# %R displays only the current time (hh:mm)
date +'System shutdown 30 sec after: %R' >> /home/jagdcake/Desktop/shutdown.txt; # using -e so echo recognizes escape characters
# double quotes are needed to be able to add command output to a string
echo -e "The system has been `uptime -p`\n" >> /home/jagdcake/Desktop/shutdown.txt
# turn pc off after 30 seconds
sleep 30s; shutdown -P now
