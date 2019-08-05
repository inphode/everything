" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" Insert plugins here:
"Plug 'morhetz/gruvbox'
"Plug 'ayu-theme/ayu-vim'
Plug 'fenetikm/falcon'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'ludovicchabant/vim-gutentags'
Plug 'easymotion/vim-easymotion'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'mattn/emmet-vim'
Plug 'mhinz/vim-startify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jwalton512/vim-blade'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'vim-vdebug/vdebug'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Initialize plugin system
call plug#end()

" Adds a DiffSaved command for seeing a diff of changes since last save
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

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
" Enable syntax highlighting
syntax enable
" Enable true color support
set termguicolors
" Add airline support for falcon
let g:falcon_airline = 1
let g:airline_theme = 'falcon'
" Smarter tab line (displays buffers when there's 1 tab)
let g:airline#extensions#tabline#enabled = 1
" Enable falcon color scheme
colorscheme falcon

" Ayu theme
"let ayucolor="light"  " for light version of theme
"let ayucolor="mirage" " for mirage version of theme
"let ayucolor="dark"   " for dark version of theme
"colorscheme ayu

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
" Fast terminal
set ttyfast
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
" Startify
" When opening a file or bookmark, don't change to its directory
let g:startify_change_to_dir = 0
" When opening a file or bookmark, seek and change to the root of the VCS
let g:startify_change_to_vcs_root = 1
" Bookmarks (these should probably be moved outside the VCS
let g:startify_bookmarks = [ {'c': '~/.vimrc'}, '~/.bashrc' ]
" Common commands
let g:startify_commands = [ {'u': ['Update Plugins', 'PlugUpdate']} ]
" Startify list ordering
let g:startify_lists = [
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ { 'type': 'files',     'header': ['   MRU']            },
            \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
            \ { 'type': 'commands',  'header': ['   Commands']       },
            \ ]

" Nerdtree toggle
map <leader>n :NERDTreeToggle<cr>
map <leader>N :NERDTreeFind<cr>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeAutoDeleteBuffer = 1

" fzf (and ripgrep)
nmap <leader>f :Files<cr>|     " fuzzy find files in the working directory (where you launched Vim from)
nmap <leader>/ :BLines<cr>|    " fuzzy find lines in the current file
nmap <leader>b :Buffers<cr>|   " fuzzy find an open buffer
nmap <leader>r :Rg |           " fuzzy find text in the working directory
nmap <leader>c :Commands<cr>|  " fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
nmap <leader>h :History:<cr>|  " fuzzy find Command history
nmap <leader>e :History<cr>|   " fuzzy find v:oldfiles and open buffers
nmap <leader>m :Marks<cr>|     " fuzzy find Marks
" Enable per-command history.
let g:fzf_history_dir = '~/.local/share/fzf-history'
" In Neovim, you can set up fzf window using a Vim command
"let g:fzf_layout = { 'window': 'enew' }
"let g:fzf_layout = { 'window': '-tabnew' }
"let g:fzf_layout = { 'window': '10new' }
"let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }
function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = &lines - 8
  let width = float2nr(&columns - (&columns * 2 / 10))
  let col = float2nr((&columns - width) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': 4,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction
" Use rg as the find command to respect gitignore
let $FZF_DEFAULT_COMMAND = 'rg --glob !/.git/ --hidden -l ""'

" coc.vim
" Make syntax highlighting work for jsonc comments
autocmd FileType json syntax match Comment +\/\/.\+$+
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Use `<leader>[` and `<leader>]` to navigate diagnostics
nmap <leader>[ <Plug>(coc-diagnostic-prev)
nmap <leader>] <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
" Remap for rename current word
nmap <leader>R <Plug>(coc-rename)
" Remap for format selected region
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)
" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap for do codeAction of current line
"nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)
" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
"nmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)
" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
"nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
"nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
