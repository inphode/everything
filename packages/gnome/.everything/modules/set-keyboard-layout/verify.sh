#!/bin/bash

# Check that the gnome monospace font is set to Fira Code
OUTPUT=$(gsettings get org.gnome.desktop.input-sources sources)

if [[ $OUTPUT =~ "[('xkb', 'us')]" ]]; then
    exit 0;
fi

exit 1;

