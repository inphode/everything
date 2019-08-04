#!/bin/bash

# Set keyboard tweaks (CAPS LOCK as CTRL and both SHIFT as CAPS LOCK)
gsettings set org.gnome.desktop.input-sources xkb-options "['shift:both_capslock', 'ctrl:nocaps', 'terminate:ctrl_alt_bksp']"

# Set key repeat delay and repeat speed
gsettings set org.gnome.desktop.peripherals.keyboard delay 300
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30

