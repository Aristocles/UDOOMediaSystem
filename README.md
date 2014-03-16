UDOOMediaSystem
===============

This is an Arduino project built using an Arduino Due. See the below link for full details and instructions on how to build this project.

UDOO Media System - See http://makeitbreakitfixit.com/2014/02/28/diy-complete-media-system-that-fits-in-the-palm-of-your-hand/ for tutorial


QUICK INSTRUCTIONS:

1) Grab the latest Arduino sketch/code release (current release is v1.0.1) and paste it in to your Arduino IDE

2) Make config changes if required and upload the sketch/code to the Arduino

3) Grab the Linux test script (current test script is serial_comms_test.sh) and paste it in to a new file in your Linux machine, make required config changes, make executable and then run the script. Basic steps in Linux shell are:

  - cd ~/bin
  - nano serial_comms_test.sh
  - <paste script in here, make config changes> CTRL+X to quit (say 'Y' when asked to save buffer)
  - chmod +x serial_comms_test.sh
  - ./serial_comms_test.sh
