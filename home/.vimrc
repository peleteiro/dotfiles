set t_Co=256
set background=dark
colorscheme railscasts

set clipboard=unnamed
let mapleader=","

set nocompatible               " be iMproved
filetype off                   " required!

syntax enable
set number
filetype plugin indent on

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

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" Slim
Bundle "git://github.com/slim-template/vim-slim.git"

" Jedi
Bundle "https://github.com/davidhalter/jedi-vim.git"

" VCL
Bundle "https://github.com/pkufranky/vcl-vim-plugin.git"
