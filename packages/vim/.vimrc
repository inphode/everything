" Make sure we're not in compatibility mode
set nocompatible

" Map leader key to space. This is a dependant of some plugin config
" so we map it at the start of this vimrc.
let mapleader=" "
nnoremap <SPACE> <Nop>

" Specify a directory for plugins
if has('nvim')
    " Neovim plugin directory
    call plug#begin('~/.local/share/nvim/plugged')
else
    " Vanilla vim plugin directory
    call plug#begin('~/.vim/plugged')
endif

" Automatic session tracking with :Obsession
Plug 'tpope/vim-obsession'

" Nice clean, well made theme without too many colours
Plug 'fenetikm/falcon'

    " Config for the theme can be found after the plugin section

" Brings up a file tree with <leader>n or <leader>N (finds current file in tree)
Plug 'scrooloose/nerdtree'

    " Toggle the nerd tree window
    map <leader>n :NERDTreeToggle<cr>
    " Toggle the nerd tree window and find the current file in the tree
    map <leader>N :NERDTreeFind<cr>
    " Minimum UI
    let NERDTreeMinimalUI = 1
    " Render arrows for open/closed directories
    let NERDTreeDirArrows = 1
    " Delete the buffer if it's open when deleting the associated file
    let NERDTreeAutoDeleteBuffer = 1

" Shows git changes in nerd tree window
Plug 'Xuyuanp/nerdtree-git-plugin'

" Allows jumping around files by typing 's' followed by 2 characters
Plug 'easymotion/vim-easymotion'

    " s{char}{char} to move to {char}{char} over windows
    nmap s <Plug>(easymotion-overwin-f2)

" Lightweight status line and tab/buffer line
Plug 'vim-airline/vim-airline'

    " Config for airline and its theme can be found after the plugin section

" Contains a theme to match falcon vim theme
Plug 'vim-airline/vim-airline-themes'

" Git commands like :Gblame and :Glog
Plug 'tpope/vim-fugitive'

" Adds git changes to left gutter/margin
Plug 'mhinz/vim-signify'

" Statup screen, with cowsay quote and recent files
Plug 'mhinz/vim-startify'

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

" Very heavy plugin that implements LSP from VS Code - full code intelligence
Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " coc.vim - The below is mostly taken from the example on the coc.vim github
    " Make syntax highlighting work for jsonc comments
    autocmd FileType json syntax match Comment +\/\/.\+$+
    " Some servers have issues with backup files, see #649
    set nobackup
    set nowritebackup
    " Better display for messages
    "set cmdheight=2
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
    "nmap <leader>R <Plug>(coc-rename)
    " Remap for format selected region
    "xmap <leader>f  <Plug>(coc-format-selected)
    "nmap <leader>f  <Plug>(coc-format-selected)
    " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
    "xmap <leader>a  <Plug>(coc-codeaction-selected)
    "nmap <leader>a  <Plug>(coc-codeaction-selected)
    " Remap for do codeAction of current line
    "nmap <leader>ac  <Plug>(coc-codeaction)
    " Fix autofix problem of current line
    "nmap <leader>qf  <Plug>(coc-fix-current)
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
    "nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
    nnoremap <silent> <space>y  :<C-u>CocList yank<cr>

" Basic support for blade template files
Plug 'jwalton512/vim-blade'

" Adds some extra operations around adding/changing quotes, brackets etc.
Plug 'tpope/vim-surround'

" Adds support for repeating some of Tim Pope's other plugins with '.' operator
Plug 'tpope/vim-repeat'

" Allows C-a and C-x to increment and decrement dates and complex numbers
Plug 'tpope/vim-speeddating'

" Installs the FZF command on the system needed for the FZF vim plugin
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Powerful file find and search plugin, which uses FZF and Ripgrep
Plug 'junegunn/fzf.vim'

    " fzf (and ripgrep) bindings
    nmap <leader>f :Files<cr>|     " fuzzy find files in the working directory (where you launched Vim from)
    nmap <leader>F :FzfAll<cr>|    " fuzzy find files in the working directory (ignore gitignore rules)
    nmap <leader>v :FzfVendor<cr>| " fuzzy find files in the vendor directory
    nmap <leader>l :BLines<cr>|    " fuzzy find lines in the current buffer
    nmap <leader>L :Lines<cr>|     " fuzzy find lines in all buffers
    nmap <leader>b :Buffers<cr>|   " fuzzy find an open buffer
    nmap <leader>r :RgProject |    " fuzzy find text in the working directory (honours VCS ignore files)
    nmap <leader>R :RgAll |        " fuzzy find text in the working directory (ignoring VCS ignore files)
    nmap <leader>c :Commands<cr>|  " fuzzy find vim commands (like Ctrl-Shift-P in Sublime/Atom/VS Code)
    nmap <leader>: :History:<cr>|  " fuzzy find command history
    nmap <leader>e :History<cr>|   " fuzzy find v:oldfiles and open buffers
    nmap <leader>/ :History/<cr>|  " fuzzy find search history
    nmap <leader>h :Helptags<cr>|  " fuzzy find help documentation
    nmap <leader>m :Marks<cr>|     " fuzzy find marks
    nmap <leader>M :Maps<cr>|      " fuzzy find keyboard mappings
    nmap <leader>w :Windows<cr>|   " fuzzy find windows

    " Enable per-command history with FZF
    let g:fzf_history_dir = '~/.local/share/fzf-history'
    " Set the floating window layout for FZF
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }

    " Custom FZF command to search all files without honouring gitignore
    command! -bang -nargs=? -complete=dir FzfAll call fzf#vim#files(<q-args>, {'source': 'rg --glob !/node_modules/ --glob !/.git/ --hidden --no-ignore-vcs -l ""', 'options': ['--info=inline', '--preview', '~/.local/share/nvim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)
    " Custom FZF command to search only in the vendor folder
    command! -bang FzfVendor call fzf#vim#files('vendor', <bang>0)
    " Custom FZF command to find text in project files
    command! -bang -nargs=* RgProject call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, <bang>0)
    " Custom FZF command to find text in all files without honouring gitignore
    command! -bang -nargs=* RgAll call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case --no-ignore-vcs ".shellescape(<q-args>), 1, <bang>0)

    " Use rg as the find command to respect gitignore, and improve search speed
    let $FZF_DEFAULT_COMMAND = 'rg --glob !/.git/ --hidden -l ""'

" PHP documentation generator with <leader>d
Plug 'kkoomen/vim-doge'

" Allows naming/renaming tabs, instead of using buffer names
Plug 'gcmt/taboo.vim'

    " Make Taboo save tab names in session
    set sessionoptions+=tabpages,globals

" Automatically strips trailing whitespace only on lines that have been edited
Plug 'axelf4/vim-strip-trailing-whitespace'

" Allows quckly commenting and uncommmenting blocks of code with 'gc'
Plug 'tpope/vim-commentary'

if has('nvim')
    " Neovim-specific plugins

    " nvim does not deal with vimspector well, so we use this less ideal plugin
    Plug 'vim-vdebug/vdebug', {'branch': 'master'}

        " Vdebug options
        if !exists('g:vdebug_options')
            let g:vdebug_options = {}
        endif
        " Don't break on first line of first file
        let g:vdebug_options.break_on_open = 0
        " Stop the debugger on closed connection
        let g:vdebug_options.on_close = 'stop'
else
    " Vanilla vim-specific plugins

    " Enable a sensible set of key bindings (mostly function keys) for vimspector.
    " This needs to be set before loading the plugin.
    let g:vimspector_enable_mappings = 'HUMAN'
    " Debugging client which uses VS Code plugins - works well on vim but not nvim
    Plug 'puremourning/vimspector'
endif

" Archived plugins

" An interesting floating terminal plugin. Disabled as I don't need it with tmux
"Plug 'voldikss/vim-floaterm'
" My own xdebug plugin. Very incomplete.
"Plug '~/git/vimbugger'

" Initialize plugin system
call plug#end()


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
let g:falcon_background = 1
let g:falcon_inactive = 0
colorscheme falcon
if !has('nvim')
    " Fix colour issues with italics in vanilla vim
    highlight Comment cterm=NONE ctermfg=243 gui=NONE guifg=#787882
    highlight Todo cterm=NONE ctermfg=0 ctermbg=187 gui=NONE guifg=#020221 guibg=#DDCFBF
    highlight Italic cterm=NONE gui=NONE
    highlight phpDocTags cterm=NONE ctermfg=246 gui=NONE guifg=#a1968a
    " This is necessary when trying to use vanilla vim through SSH and tmux
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Ayu theme
" This was a nice theme too, but incomplete. Leaving here to remind me to
" check it out in the future.
"let ayucolor="light"  " for light version of theme
"let ayucolor="mirage" " for mirage version of theme
"let ayucolor="dark"   " for dark version of theme
"colorscheme ayu

" Custom visual selection colour
" Not necessary for current theme, as I like it's selection colour
"highlight Visual cterm=bold ctermbg=LightYellow ctermfg=NONE

" Fixes issues with syntax highlighting getting messed up in cases of
" large codeblocks. Set even larger if dealing with files with more
" than 10,000 lines.
syntax sync minlines=10000


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


" -- User interface options

" Always display the status bar
set laststatus=2
" Always show cursor position
set ruler
" Display command line’s tab complete options as a menu
set wildmenu
" Vertical auto complete menu (seems to be enabled by default, but maybe
" needed for vanilla vim)
"set wildoptions+=pum
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
" Flash the screen instead of beeping on errors (This can get annoying)
"set visualbell
" Enable mouse for scrolling and resizing
set mouse=a
if !has('nvim')
    " Fix mouse dragging compatibility when using neovim with SSH and tmux
    set ttymouse=sgr
endif
" Set the window’s title, reflecting the file currently being edited
set title
" Highlight matching bracket
set showmatch


" -- Misc options

" Fast terminal 'ttyfast' - should maybe be disabled on slow SSH
set ttyfast
" This will do less redraw operations - good for slow SSH but can cause some
" issues with garbage left on screen.
"set lazyredraw
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
" Persist undo in a file in current directory
set undofile


" -- Additional custom functionality

" Make PHP variables words including the $
autocmd FileType php set iskeyword+=$

" Auto-complete from anything anywhere
inoremap <C-l> <c-x><c-n>

" Make <Esc> in neovim exit terminal mode (without conflicting with FZF)
if has('nvim')
    autocmd TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    autocmd FileType fzf tunmap <buffer> <Esc>
endif

" Adds a DiffSaved command for seeing a diff of changes since last save
function! s:DiffUnsavedChanges()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffUnsavedChanges call s:DiffUnsavedChanges()

" Set clipboard save to file with + register and to tmux with * register
let g:clipboard = {
            \   'name': 'copyToFile',
            \   'copy': {
            \      '+': 'tee /home/phill/.clipboard',
            \      '*': 'tmux load-buffer -',
            \    },
            \   'paste': {
            \      '+': 'tee /home/phill/.clipboard',
            \      '*': 'tmux save-buffer -',
            \   },
            \   'cache_enabled': 1,
            \ }

" Highlight last changed test
nnoremap gp `[v`]

" Turn off search highlight - This is probably an odd/bad key binding, but I'm
" so used to it now.
nnoremap <leader>s :nohlsearch<CR>

" When using `dd` in the quickfix list, remove the item from the quickfix list.
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
endfunction
:command! RemoveQFItem :call RemoveQFItem()
" Use map <buffer> to only map dd in the quickfix window. Requires +localmap
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>
autocmd FileType qf map <buffer> <C-k> :cp<cr>:copen<cr>
autocmd FileType qf map <buffer> <C-j> :cn<cr>:copen<cr>

" Perform command on each entry in the quickfix list
nmap <leader>q :cdo |
" Perform command on each file in the quickfix list
nmap <leader>Q :cfdo |
" Jump to previous item in the quickfix list
nmap [q :cp<cr>
" Jump to next item in the quickfix list
nmap ]q :cn<cr>
" Jump to previous quickfix list
nmap [Q :colder<cr>
" Jump to next quickfix list
nmap ]Q :cnewer<cr>
