#!/bin/bash

sudo apt install -y rxvt-unicode fonts-inconsolata terminator

# Install gruvbox theme for Terminator terminal
mkdir -p ~/.config/terminator/ && wget -O ~/.config/terminator/config https://raw.githubusercontent.com/egel/terminator-gruvbox/master/config

