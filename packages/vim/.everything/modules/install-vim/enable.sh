#!/bin/bash

bashrcd_enable neovim

bashrcd_source node
nvm install --lts
nvm use --lts

curl -fLo $HOME_PATH/.local/bin/nvim --create-dirs \
    https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x $HOME_PATH/.local/bin/nvim

npm install -g neovim

sudo apt install ruby ruby-dev python3-pip universal-ctags ripgrep -y
pip3 install --user --upgrade neovim
pip3 install --user --upgrade neovim-remote
pip3 install --user --upgrade jedi

sudo gem install neovim

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +PlugInstall +qall > /dev/null
nvim -c 'CocInstall -sync coc-json coc-html coc-tsserver coc-css coc-vetur coc-phpls coc-yaml coc-python coc-highlight coc-yank coc-git coc-texlab|q'

# Install vanilla vim
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt install vim -y

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

