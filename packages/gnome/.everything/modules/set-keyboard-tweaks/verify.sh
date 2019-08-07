#!/bin/bash

source ../../utils.sh
iamatest

# Check keyboard tweaks (CAPS LOCK as CTRL and both SHIFT as CAPS LOCK)
OUTPUT=$(gsettings get org.gnome.desktop.input-sources xkb-options)

if [[ ! $OUTPUT =~ "['shift:both_capslock', 'ctrl:nocaps', 'terminate:ctrl_alt_bksp']" ]]; then
    exit 1
fi

# Check key repeat delay
OUTPUT=$(gsettings get org.gnome.desktop.peripherals.keyboard delay)

if [[ ! $OUTPUT =~ "uint32 300"$ ]]; then
    exit 1
fi

# Check key repeat speed
OUTPUT=$(gsettings get org.gnome.desktop.peripherals.keyboard repeat-interval)

if [[ ! $OUTPUT =~ "uint32 30"$ ]]; then
    exit 1
fi

exit 0

