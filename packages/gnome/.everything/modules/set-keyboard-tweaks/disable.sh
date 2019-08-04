#!/bin/bash

# Set keyboard tweaks (CAPS LOCK as CTRL and both SHIFT as CAPS LOCK)
gsettings reset org.gnome.desktop.input-sources xkb-options

# Set key repeat delay and repeat speed
gsettings reset org.gnome.desktop.peripherals.keyboard delay
gsettings reset org.gnome.desktop.peripherals.keyboard repeat-interval

