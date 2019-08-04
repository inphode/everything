#!/bin/bash

# Check keyboard tweaks (CAPS LOCK as CTRL and both SHIFT as CAPS LOCK)
gsettings get org.gnome.desktop.input-sources xkb-options 

if [[ ! $? =~ "['shift:both_capslock', 'ctrl:nocaps', 'terminate:ctrl_alt_bksp']" ]]; then
    exit 1;
fi

# Check key repeat delay
gsettings get org.gnome.desktop.peripherals.keyboard delay

if [[ ! $? =~ "uint32 300"$ ]]; then
    exit 1;
fi

# Check key repeat speed
gsettings get org.gnome.desktop.peripherals.keyboard repeat-interval

if [[ ! $? =~ "uint32 30"$ ]]; then
    exit 1;
fi

exit 0;

