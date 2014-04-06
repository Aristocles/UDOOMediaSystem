#!/bin/sh

# https://github.com/JaykGit/UDOOMediaSystem
# www.makeitbreakitfixit.com April/2014
#
# This script will simply grab the current date/time and push it to the Arduino
# Be sure to match the below baud with the rate set on the Arduino

# CONFIGURATION
LOG="/var/log/UDOOMediaSystem.log" # Log file for all UDOO Media System stuff
BAUD=115200 # Serial interface baud rate
INT="/dev/ttymxc3" # Serial interface used to communicate with Arduino
LOG_DATE=`date +[%d/%m/%Y\ \-\ \%H:%M:%S]` # Time/date we use for logging
SCRIPT_DIR=/root/bin
FILE="time"

ARD_DATE=`date +%d,%m,%Y,%H,%M,%S` # Time/date we send to send to Arduino
# /END CONFIGURATION

if [ -e "$SCRIPT_DIR/$TIME" ] # If this exists then we have already sent time
then
  stty -F $INT $BAUD # Configure serial for baud
  # Sending current date/time to Arduino built in to UDOO
  echo "$LOG_DATE - [UDOOMediaSystem] - INFO - Updating Arduino with current date and time [$ARD_DA$
  #echo "Sending date/time to Arduino"
  echo "{@$ARD_DATE}" > $INT
  touch "$SCRIPT_DIR/$FILE"
fi

# Compare current date/time with the files date/time. If the time difference is
# too much then we send the time to Arduino. The only exception is if the uptime
# shows that UDOO was booted recently
# ls -l --time-style=+%Y%m%d%H%M time | awk '{print $6}'
