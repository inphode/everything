#!/bin/bash

sudo apt install -y rxvt-unicode fonts-inconsolata terminator

# Set gnome monospace font to Inconsolata
gsettings set org.gnome.desktop.interface monospace-font-name 'Inconsolata 12'

# Install gruvbox theme for Terminator terminal
mkdir -p ~/.config/terminator/ && wget -O ~/.config/terminator/config https://raw.githubusercontent.com/egel/terminator-gruvbox/master/config

