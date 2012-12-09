set t_Co=256
set background=dark
colorscheme railscasts

set clipboard=unnamed
let mapleader=","

set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

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

" rooter
Bundle "https://github.com/airblade/vim-rooter.git"

" FuzzyFinder
Bundle "L9"
Bundle "https://github.com/clones/vim-fuzzyfinder.git"

let g:fuf_fuzzyRefining = 1
let g:fuf_reuseWindow = 1
let g:fuf_ignoreCase = 1
let g:fuf_coveragefile_exclude = '\v\~$|\.o$|\.exe$|\.bak$|\.swp|\.class$|\.png$|\.gif$\.jpg$|\.scssc$|.public/system.'
let g:fuf_mrufile_exclude = g:fuf_coveragefile_exclude
let g:fuf_file_exclude = g:fuf_coveragefile_exclude

" Mapping
nnoremap <C-t> :FufCoverageFile<CR>
nnoremap <C-m> :FufMruFile<CR>
nnoremap <C-b> :FufBuffer<CR>

" Slim
Bundle "https://github.com/bbommarito/vim-slim.git"