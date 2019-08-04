#!/bin/bash

# TODO: Instead of resetting to default, store the output of `gsettings get`
# in a file in this directory when enabling and use that value to restore
# and to verify.

# Reset gnome monospace font
gsettings reset org.gnome.desktop.interface monospace-font-name

