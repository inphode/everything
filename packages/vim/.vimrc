" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" Insert plugins here:
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ludovicchabant/vim-gutentags'
Plug 'easymotion/vim-easymotion'

" Initialize plugin system
call plug#end()

" -- Indentation options
" New lines inherit the indentation of previous lines
set autoindent
" Sets file type specific indent rules
filetype indent on
" Convert tabs to spaces
set expandtab
" When shifting lines, round the indentation to the nearest multiple of 'shiftwidth'
set shiftround
" When shifting, indent using four spaces
set shiftwidth=4
" Insert 'tabstop' number of spaces when the 'tab' key is pressed
set smarttab
" Indent using four spaces
set tabstop=4

" -- Search options
" Enable search highlighting
set hlsearch
" Incremental search that shows partial matches
set incsearch
" Ignore case when searching
set ignorecase
" Automatically switch search to case-sensitive when search query contains an uppercase letter
set smartcase

" -- Text rendering options
" Always try to show a paragraph’s last line
set display+=lastline
" Use an encoding that supports unicode
set encoding=utf-8
" Avoid wrapping a line in the middle of a word
set linebreak
" The number of screen lines to keep above and below the cursor
set scrolloff=5
" The number of screen columns to keep to the left and right of the cursor
set sidescrolloff=10
" Enable line wrapping
set wrap

" -- Theme/colour options
" Enable true color support
"set termguicolors
" Enable syntax highlighting
syntax enable
" Enable gruvbox theme italics (must be set before colorscheme gruvbox
let g:gruvbox_italic=1
" Enable gruvbox theme
colorscheme gruvbox
" Visual selection colour
"highlight Visual cterm=bold ctermbg=LightYellow ctermfg=NONE

" -- User interface options
" Always display the status bar
set laststatus=2
" Always show cursor position
set ruler
" Display command line’s tab complete options as a menu
set wildmenu
" Maximum number of tab pages that can be opened from the command line
set tabpagemax=50
" Highlight the line currently under cursor
set cursorline
" Show line numbers on the sidebar
set number
" Show line number on the current line and relative numbers on all other lines
set relativenumber
" Disable beep on errors
set noerrorbells
" Flash the screen instead of beeping on errors
"set visualbell
" Enable mouse for scrolling and resizing
set mouse=a
" Set the window’s title, reflecting the file currently being edited
set title
" Highlight matching bracket
set showmatch

" -- Misc options
" Automatically re-read files if unmodified inside Vim
set autoread
" Allow backspacing over indention, line breaks and insertion start
set backspace=indent,eol,start
" Display a confirmation dialog when closing an unsaved file
set confirm
" Delete comment characters when joining lines
set formatoptions+=j
" Hide files in the background instead of closing them
set hidden
" Increase the undo limit
set history=1000
" Ignore file’s mode lines; use vimrc configurations instead
set nomodeline
" Interpret octal as decimal when incrementing numbers
set nrformats-=octal

" -- Additional functionality
" Map leader key to space
let mapleader=" "
nnoremap <SPACE> <Nop>
" Highlight last inserted text
nnoremap gV `[v`]
" turn off search highlight
nnoremap <leader>s :nohlsearch<CR>

" -- Plugin options
" Nerdtree toggle
map <leader>n :NERDTreeToggle<CR>

