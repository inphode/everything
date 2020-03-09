#!/bin/bash

sudo apt install protobuf-compiler libncurses-dev libssl-dev pkgconf autoconf autotools-dev
git clone https://github.com/mobile-shell/mosh /tmp/mosh-src
cd /tmp/mosh-src
./autogen.sh
./configure
make
sudo make install
