#!/bin/bash

bashrcd_disable neovim

rm $HOME_PATH/.local/bin/nvim
rm -rf $HOME_PATH/.local/share/nvim

pip3 uninstall --user neovim
pip3 uninstall --user neovim-remote

