#!/bin/bash

source $HOME_PATH/.bashrc

curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage $HOME_PATH/bin/nvim

sudo apt install python3-pip -y
pip3 install --user --upgrade neovim
pip3 install --user --upgrade neovim-remote

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo apt install universal-ctags ripgrep -y

nvim +PlugInstall +qall > /dev/null
nvim -c 'CocInstall -sync coc-json coc-html coc-tsserver coc-css coc-vetur coc-phpls coc-yaml coc-python coc-emmet coc-highlight coc-yank coc-git coc-texlab|q'
