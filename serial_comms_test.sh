#!/bin/bash

# UDOO Media System - Test Script [March 2014]
# Jay Aristocles (jay@enail.com.au)
# http://makeitbreakitfixit.com/2014/02/28/diy-complete-media-system-that-fits-in-the-palm-of-your-hand/
# See above link for full DIY instructions on how to build your own UDOO Media System
# This code is also available on GitHub under my account https://github.com/JaykGit/
#
# This script can be used to test functionality between Linux to Arduino serial comms.
# You will need to either run the serial monitor in the Arduino IDE or `cat /dev/<ttymxc3`
# to see the output. The script does not receive feedback, you need to check it yourself.
#
# PROTOCOL DETAILS:
# - ALL serial communication to Arduino must be within curly braces { }
# - ALL flags (eg. set time/date) have a special character sent immediately after the {
# - To set the Arduino date/time you must use the @ flag followed by the date/time in format  DD,MM,YYYY,hh,mm,ss
# Example: {@20,1,2014,21,01,40} Will parse to Jan 20th 2014, 9:01:40PM
# - To delete an entry in the alert array you must use the # flag followed by the exact alert text you wish to delete
# - To output the contents of the alert array (with date/time) to serial use the ? flag (ie: {?} )
# - Using a second ? will also output all configured options (ie: {??} )
# An example string that one may use to send from Linux is: echo "{Hello World}" > /dev/ttymxc3; echo "{?}" > /dev/ttymxc3

# CONFIGURATION
INT="/dev/ttymxc3" # Serial interface connecting to Arduino
BAUD=115200 # Serial interface baud rate
# /END CONFIGURATION


stty -F $INT $BAUD
# Testing to fill the array
echo "--- TESTING ARRAY ADDITION, CHARACTERS AND CHAR LIMITS ---"
echo "{first message 22 chars}"
echo "{first message 22 chars}" > $INT
sleep 2
echo "{my second message 26 chars}"
echo "{my second message 26 chars}" > $INT
sleep 2
echo "{3rd msg 16 chars}"
echo "{3rd msg 16 chars}" > $INT
sleep 2
echo "{this is the fourth message, 36 chars}"
echo "{this is the fourth message, 36 chars}" > $INT
sleep 2
echo "{!@#$%^&*()FINALMSG<>:;',.}"
echo "{!@#$%^&*()FINALMSG<>:;',.}" > $INT
sleep 2
echo "{?}"
echo "{?}" > $INT
sleep 10
# Adding current timestamp
echo "--- SETTING TIME/DATE ---"
DATE=`date +%d,%m,%Y,%H,%M,%S`
echo "{@$DATE}"
echo "{@$DATE}" > $INT
sleep 2
# Testing to rotate the awway
echo "--- TESTING ARRAY ROTATION ---"
echo "{rotate 1}"
echo "{rotate 1}" > $INT
echo "{rotate 2}"
echo "{rotate 2}" > $INT
echo "{rotate 3}"
echo "{rotate 3}" > $INT
echo "{rotate 4}"
echo "{rotate 4}" > $INT
echo "{rotate 5}"
echo "{rotate 5}" > $INT
echo "{rotate 6}"
echo "{rotate 6}" > $INT
echo "{rotate 7}"
echo "{rotate 7}" > $INT
echo "{rotate 8}"
echo "{rotate 8}" > $INT
echo "{rotate 9}"
echo "{rotate 9}" > $INT
echo "{rotate 10}"
echo "{rotate 10}" > $INT
echo "{rotate 11}"
echo "{rotate 11}" > $INT
sleep 2
echo "{?}"
echo "{?}" > $INT
sleep 10
# Testing replace functionality
echo "--- TESTING DELETE AND REPLACE ---"
echo "{makeitbreakitfixit.com}"
echo "{makeitbreakitfixit.com}" > $INT
echo "{UDOOMediaSystem}"
echo "{UDOOMediaSystem}" > $INT
echo "{?}"
echo "{?}" > $INT
sleep 2
echo "{makeitbreakitfixit.com}"
echo "{makeitbreakitfixit.com}" > $INT
echo "{UDOOMediaSystem}"
echo "{UDOOMediaSystem}" > $INT
echo "{?}"
echo "{?}" > $INT
sleep 10
# Testing delete functionality
echo "{#makeitbreakitfixit.com}"
echo "{#makeitbreakitfixit.com}" > $INT
echo "{#UDOOMediaSystem}"
echo "{#UDOOMediaSystem}" > $INT
# Verbose output
echo "--- VERBOSE OUTPUT ---"
echo "{??}"
echo "{??}" > $INT
sleep 10
# Testing complete
echo "--- TESTING COMPLETE ---"
