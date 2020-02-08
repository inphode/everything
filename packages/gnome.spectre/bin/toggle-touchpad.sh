#!/bin/bash

# New method:
ELANID=$(xinput list | grep 'ELAN.*pointer' | sed 's/.*id=\([0-9]\+\).*/\1/')
SYNID=$(xinput list | grep 'Synaptics.*pointer' | sed 's/.*id=\([0-9]\+\).*/\1/')

xinput set-prop $ELANID "Device Enabled" 0

if xinput list-props $SYNID | grep --quiet 'Device Enabled.*1$'; then
    xinput set-prop $SYNID "Device Enabled" 0
else
    xinput set-prop $SYNID "Device Enabled" 1

    # Scroll speed (reversed in horizontal and vertical scrolling)
    synclient VertScrollDelta=-111
    synclient HorizScrollDelta=-111
    # Enable 3 finger click middle mouse
    synclient ClickFinger3=2
    # Diable 3 finger tap middle mouse
    synclient TapButton3=0
    # Diable 2 finger tap right mouse
    synclient TapButton2=0
fi

# Old method:
# The extra spaces are intentional and required for a match
#if synclient | grep --quiet 'TouchpadOff             = 0'; then
#    synclient TouchpadOff=1
#    #notify-send Touchpad Disabled
#else
#    synclient TouchpadOff=0
#    #notify-send Touchpad Enabled
#
#    # Also apply settings
#    # Scroll speed (reversed in horizontal and vertical scrolling)
#    synclient VertScrollDelta=-111
#    synclient HorizScrollDelta=-111
#    # Enable 3 finger click middle mouse
#    synclient ClickFinger3=2
#    # Diable 3 finger tap middle mouse
#    synclient TapButton3=0
#    # No right button area
#    #synclient RightButtonAreaLeft=0
#    #synclient RightButtonAreaTop=0
#fi
