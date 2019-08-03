#!/bin/bash

sudo apt install -y fonts-inconsolata xclip fonts-firacode

# Set gnome monospace font to Inconsolata
gsettings set org.gnome.desktop.interface monospace-font-name 'Inconsolata 12'

# Set gnome input sources
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us')]"
# Set keyboard tweaks (CAPS LOCK as CTRL and both SHIFT as CAPS LOCK)
gsettings set org.gnome.desktop.input-sources xkb-options "['shift:both_capslock', 'ctrl:nocaps', 'terminate:ctrl_alt_bksp']"
# Set key repeat delay and repeat speed
gsettings set org.gnome.desktop.peripherals.keyboard delay 300
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30

# Install kitty terminal
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# Add desktop integration for kitty
ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin
mkdir -p ~/.local/share/applications
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/kitty.desktop
# Update the path to the kitty icon in the kitty.desktop file
sed -i "s/Icon\=kitty/Icon\=\/home\/$USER\/.local\/kitty.app\/share\/icons\/hicolor\/256x256\/apps\/kitty.png/g" ~/.local/share/applications/kitty.desktop

