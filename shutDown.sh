#!/bin/bash
# using SIGTERM to allow programs to exit cleanly
kill -s SIGTERM `pidof tixati`; echo 'Exiting Tixati...'
kill -s SIGTERM `pidof chrome`; echo 'Exiting Chrome...'
kill -s SIGTERM `pidof steam`; echo 'Exiting Steam...'

# split the start time and date into two variables
starttime="`uptime -s | awk '{print $2}'`"
startdate="`uptime -s | awk '{print $1}'`"

# makes 'Jan' the item at index 1 of the array
months=(Null Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

# get the start month's number in format "##", e.g. 02 = February
sm="`echo $startdate | awk -F - '{print $2}'`"

# get the current month's number  
cm=`date +%m`

# removes the 0 from month numbers below 10, so they correspond to that month's index in the array, e.g. 02 becomes 2 which is the index of Feb
if [ $sm -lt 10 ]; then
	smonth="`echo $sm | awk -F 0 '{print $2}'`"
elif [ $sm -ge 10 ]; then
	smonth="`echo $sm`"
fi

if [ $cm -lt 10 ]; then
	cmonth="`echo $cm | awk -F 0 '{print $2}'`"
elif [ $cm -ge 10 ]; then
	cmonth="`echo $cm`"
fi

# double quotes evaluate any command between them (IF the command is between backticks) while single quotes print out a literal string
echo "System powered on at: $starttime on `echo $startdate | awk -F - '{print $3}'` ${months[$sm]} `echo $startdate | awk -F - '{print $1}'`" >> /home/jagdcake/Desktop/shutdown.txt;

# displays the current time + 30 seconds (hh:mm:ss) and the date 
echo "System shutdown at: `date +%H:%M:%S -d "+30 sec"` on `date +%d` ${months[$cmonth]} `date +%Y`" >> /home/jagdcake/Desktop/shutdown.txt; 

# using -e so echo recognizes escape characters
echo -e "The system has been `uptime -p`\n" >> /home/jagdcake/Desktop/shutdown.txt

# turn system off after 30 seconds
sleep 30s; shutdown -P now
