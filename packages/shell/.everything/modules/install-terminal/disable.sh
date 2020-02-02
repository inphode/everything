#!/bin/bash

# Delete files installed by kitty
rm ~/.local/bin/kitty
rm -rf ~/.local/kitty.app
rm ~/.local/share/applications/kitty.desktop

# Remove qterminal
sudo apt remove -y qterminal
