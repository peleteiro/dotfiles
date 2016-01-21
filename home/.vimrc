set t_Co=256
set background=dark
colorscheme railscasts

set clipboard=unnamed
let mapleader=","

set nocompatible               " be iMproved

set number
set numberwidth=4

set wildmode=list:longest
set hidden
set nowrap
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab
set ignorecase
set smartcase
set smarttab
set hlsearch
set incsearch

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep
set nobackup
set noswapfile

set list
set listchars=tab:>.,trail:.,extends:#

set tw=140
nnoremap ; :

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

syntax enable
filetype plugin indent on

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-rooter'

Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/unite.vim'

Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

" Add plugins to &runtimepath
call plug#end()
