#!/bin/bash

# TODO: Have the node package put this is a separate file to source
NVM_DIR=$HOME_PATH/.config/nvm
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
nvm use --lts

curl -fLo $HOME_PATH/.local/bin/nvim --create-dirs \
    https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x $HOME_PATH/.local/bin/nvim

npm install -g neovim

sudo apt install ruby ruby-dev python2-pip python3-pip universal-ctags ripgrep -y
pip2 install --user --upgrade neovim
pip3 install --user --upgrade neovim
pip3 install --user --upgrade neovim-remote

sudo gem install neovim

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +PlugInstall +qall > /dev/null
nvim -c 'CocInstall -sync coc-json coc-html coc-tsserver coc-css coc-vetur coc-phpls coc-yaml coc-python coc-emmet coc-highlight coc-yank coc-git coc-texlab|q'

