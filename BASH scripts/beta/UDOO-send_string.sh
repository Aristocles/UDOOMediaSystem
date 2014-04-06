#!/bin/sh

# https://github.com/JaykGit/UDOOMediaSystem
# www.makeitbreakitfixit.com April/2014
#
# This script will push sanitised strings to the Arduino. Do not invoke directly.
# Be sure to match the below baud with the rate set on the Arduino

# CONFIGURATION OPTIONS BELOW
BAUD=115200 # Serial baud speed. Must match the baud configured in the Arduino code
INT=/dev/ttymxc3

# Do not change anything below this line.

if [ $# -lt 1 ] ;then
  echo "$0: Exiting. You need to pass a parameter to this script inside inverted commas"
  exit 1
fi

if [ $# -gt 1 ] ;then
  echo "$0: Exiting. Does not accept more than one parameter. Try putting it inside inverted commas"
  exit 1
fi

# Configure the serial interface
stty -F $INT cs8 $BAUD ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke$

string=$1
#echo "String set to $string"
length=${#string}
if [ $length -lt 2 -o $length -gt 125 ] ;then
  echo "$0: Exiting. Cannot accept a string greater than 25 characters long"
  exit 1
fi

#case $string in
#  *[^a-zA-Z0-9]{25}* ) echo "$0: Exiting. Invalid characters present"; exit 1;;
#esac

#echo "Removing invalid characters"
filtered=$(echo $string | tr -d -c "?@#()[\],\_\- .[:alnum:]")
#echo "Sending string: $filtered"

echo "{$filtered}" > $INT
exit 0
