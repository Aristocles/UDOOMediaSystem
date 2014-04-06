#!/bin/bash

# https://github.com/JaykGit/UDOOMediaSystem
# www.makeitbreakitfixit.com April/2014

# This script will check for specified services PID files and make sure the process is running.
# If PID is missing or not running it will notify the Arduino to display an alert.

# We create a file in $SCRIPT_DIR to hold the PID number. This file also serves as a flag
# that the script has previously run and believes the process is running (and has already
# told the Arduino, if configured to). If the process fails we remove this file and the
# absence of the file is now used to indicate we know the process has failed. This system
# was used to avoid unnecessary comms with the Arduino.

if [ $# -lt 2 ]
then
  echo "Usage: $0 <PID file location> <Service name>"
  echo "Ex: $0 /var/run/minidlna/minidlna.pid MiniDLNA"
  exit 1
fi

LOG_DATE=`date +[%d/%m/%Y\ \-\ \%H:%M:%S]` # Time/date we use for logging
LOG="/var/log/UDOOMediaSystem.log" # Log file for all UDOO Media System stuff
SCRIPT_DIR=/root/bin
PID_FILE=$1
NAME=$2
#SECONDS=$(($RANDOM % 10)) # Random number between 1 and 10

# Lets output a line to the syslog
echo "Running $0 for $2" | logger

if [ -r $PID_FILE ]
echo "$PID_FILE exists"
then
  PID=$(cat $PID_FILE)
  ps -p $PID > /dev/null # Make sure the PID is actually running
  if [ $? -eq 0 ] # If previous cmd executed exit 0
  then
    echo "PID [$PID] is found in process list. $NAME is running"
    # In my use case, I would prefer if the LCD only showed me services in error.
    # But if you wish for Arduin LCD to also tell you when a service is running,
    # the uncomment the below.
    if [ -e "$SCRIPT_DIR/$NAME.tmppid" ] # First, check to make sure file exists
    then
      echo "$SCRIPT_DIR/$NAME.tmppid exists"
      OLD_PID=$(cat "$SCRIPT_DIR/$NAME.tmppid")
      if [ $PID -eq $OLD_PID ]
      then
        echo "PID inside $NAME.tmpid [$OLD_PID] is same as running PID [$PID]. We have already spoken to Ard. Exiting"
        exit 0 # We exit if we already have exiting PID in the file
      fi
    fi
    echo "PID inside $NAME.tmppid [$OLD_PID] doesnt match to PID [$PID]. Talking to Ard"
    /root/bin/UDOO-send_string.sh "#[ERR] $NAME failed" # First, we delete the err
# I choose note to tell Ard when a service is up. Only when it fails
#    /root/bin/UDOO-send_string.sh "$NAME running [$PID]"
    echo $PID > "$SCRIPT_DIR/$NAME.tmppid"
    echo "Writing PID [$PID] to $NAME.tmppid. Exiting"
    echo "$LOG_DATE - [UDOOMediaSystem] - INFO - $NAME is running [$PID]" >> $LOG
    exit 0
  fi
  echo "PID [$PID] is not found in process list"
fi

#sleep $SECONDS # Wait a little first, this is to prevent overrun of Arduino serial
if [ -e "$SCRIPT_DIR/$NAME.tmppid" ]
then
  echo "$SCRIPT_DIR/$NAME.tmppid exists"
  OLD_PID=$(cat "$SCRIPT_DIR/$NAME.tmppid")
  if [ $OLD_PID -eq 1 ] # We will have a "1" in the file if we have already
  then                  # told arduino about the error
    echo "Found a \"1\" inside $NAME.tmppid. We have already spoken to Ard. Exiting"
    exit 0
  fi
  echo "This is a new ERR. Talking to Ard"
# I choose note to tell Ard when a service is up. Only when it fails
#  /root/bin/UDOO-send_string.sh "#$NAME running [$OLD_PID]"
  /root/bin/UDOO-send_string.sh "[ERR] $NAME failed"
  echo "1" > "$SCRIPT_DIR/$NAME.tmppid" # The "1" denotes that we have contacted ard already
  echo "Writing \"1\" to $NAME.tmppid to denote an ERR flag. Exiting"
  echo "$LOG_DATE - [UDOOMediaSystem] - WARN - Notified Arduino that $NAME has stopped" >> $LOG
  exit 0
fi

echo "No State found. Writing \"1\" to $NAME.tmppid to denote an ERR flag. Exiting"
echo "1" > "$SCRIPT_DIR/$NAME.tmppid"
exit 0
