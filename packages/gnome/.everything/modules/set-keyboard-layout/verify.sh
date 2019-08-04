#!/bin/bash

# Check that the gnome monospace font is set to Fira Code
gsettings get org.gnome.desktop.input-sources sources

if [[ $? =~ "[('xkb', 'us')]" ]]; then
    exit 0;
fi

exit 1;

