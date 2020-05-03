#!/bin/bash

git clone https://github.com/nvm-sh/nvm.git $HOME/.nvm
(cd $HOME/.nvm && git checkout v0.35.3)

bashrcd_enable node
bashrcd_source node

nvm install --lts
nvm use --lts
nvm install -g yarn
