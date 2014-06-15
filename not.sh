#!/bin/bash

# This command is designed to present an Ubuntu GUI notification (libnotify).
# I use it to notify me when job in a terminal that's not visible finishes.
# For example: "$ sudo apt-get update ; not.sh"
# The notification will appear after the apt-get completes.

# Usage: You will want to make sure that not.sh is in your PATH.
# I've symlinked not.sh to n (saves some typing).


notify-send "Terminal Job Finished" "______________________"
