#!/bin/bash

gsettings get org.gnome.mutter experimental-features

if [[ $? =~ "['x11-randr-fractional-scaling']" ]]; then
    exit 0;
fi

exit 1;

