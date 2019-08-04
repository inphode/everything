#!/bin/bash

# Check that the gnome monospace font is set to Fira Code
gsettings get org.gnome.desktop.interface monospace-font-name

if [[ $? =~ "Fira Code weight=453 12" ]]; then
    exit 0;
fi

exit 1;

