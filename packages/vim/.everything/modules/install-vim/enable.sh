#!/bin/bash

bashrcd_enable neovim

bashrcd_source node
nvm install --lts
nvm use --lts

# Install ruby, python and other dependencies
sudo apt install ruby ruby-dev python3-pip universal-ctags ripgrep -y

# Install python, ruby and node extensions for neovim
pip3 install --user --upgrade neovim
pip3 install --user --upgrade neovim-remote
pip3 install --user --upgrade jedi
sudo gem install neovim
npm install -g neovim

# Install neovim
curl -fLo $HOME_PATH/.local/bin/nvim --create-dirs \
    https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x $HOME_PATH/.local/bin/nvim

# Install vim-plug (for neovim)
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins (for neovim)
nvim +PlugInstall +qall > /dev/null

# Install coc.vim plugins (for neovim)
nvim -c 'CocInstall -sync coc-json coc-html coc-tsserver coc-css coc-vetur coc-phpls coc-yaml coc-python coc-highlight coc-yank coc-git coc-texlab|q'

# Install vanilla vim
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt install vim -y

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# I think the below needs modifying as that method of
# running vim commands might only work on neovim

# Install plugins (for vanilla vim)
#vim +PlugInstall +qall > /dev/null

# Install coc.vim plugins (for vanilla vim)
#vim -c 'CocInstall -sync coc-json coc-html coc-tsserver coc-css coc-vetur coc-phpls coc-yaml coc-python coc-highlight coc-yank coc-git coc-texlab|q'
