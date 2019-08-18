#!/bin/bash

nvim --version || exit 1
pip2 --version || exit 1
pip3 --version || exit 1
nvr --version || exit 1
gem --version || exit 1

if [[ -s "$HOME_PATH/.local/share/nvim/site/autoload/plug.vim" ]]; then
    exit 0;
fi

exit 1;

