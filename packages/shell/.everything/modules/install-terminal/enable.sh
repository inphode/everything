#!/bin/bash

# Install kitty terminal
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Add desktop integration for kitty
ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin
mkdir -p ~/.local/share/applications
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/kitty.desktop

# Update the path to the kitty icon in the kitty.desktop file
sed -i "s/Icon\=kitty/Icon\=\/home\/$USER\/.local\/kitty.app\/share\/icons\/hicolor\/256x256\/apps\/kitty.png/g" ~/.local/share/applications/kitty.desktop

# Install qterminal
sudo apt install -y qterminal

