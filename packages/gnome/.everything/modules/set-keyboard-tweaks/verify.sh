#!/bin/bash

# Check keyboard tweaks (CAPS LOCK as CTRL and both SHIFT as CAPS LOCK)
verify_command_contains \
    "['shift:both_capslock', 'ctrl:nocaps', 'terminate:ctrl_alt_bksp']" \
    gsettings get org.gnome.desktop.input-sources xkb-options
# Check key repeat delay
verify_command_matches \
    "uint32 300"$ \
    gsettings get org.gnome.desktop.peripherals.keyboard delay
# Check key repeat speed
verify_command_matches \
    "uint32 30"$ \
    gsettings get org.gnome.desktop.peripherals.keyboard repeat-interval

exit $REPORT_ENABLED

