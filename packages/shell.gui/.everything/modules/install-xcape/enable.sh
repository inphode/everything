#!/bin/bash

bashrcd_enable xcape
sudo apt-get install git gcc make pkg-config libx11-dev libxtst-dev libxi-dev -y
[[ -d /tmp/installers/xcape ]] && rm -rf /tmp/installers/xcape
mkdir -p /tmp/installers/xcape
git clone https://github.com/alols/xcape.git /tmp/installers/xcape
cd /tmp/installers/xcape
make
sudo make install

