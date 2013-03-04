#!/bin/bash

# allow 2 finger && edge scrolling
sleep 10s; # if it's still not working on startup try increasing the delay
synclient VertEdgeScroll=1;
synclient HorizEdgeScroll=1;
synclient VertTwoFingerScroll=1;
synclient HorizTwoFingerScroll=1;
 
# enable 2 finger-tap to middle click
xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Tap Action" 8 9 0 0 1 2 3

# To run this script after suspend/resume:
# gsettings set org.gnome.settings-daemon.peripherals.input-devices hotplug-command "/home/isaac/trackpad_settings"
