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

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" Rename file
Bundle 'danro/rename.vim'

" Slim
Bundle "git://github.com/slim-template/vim-slim.git"

" Jedi
Bundle "https://github.com/davidhalter/jedi-vim.git"

" VCL
Bundle "https://github.com/pkufranky/vcl-vim-plugin.git"

" Vim rooter
Bundle "airblade/vim-rooter"

Bundle 'kchmck/vim-coffee-script'

Bundle 'kien/ctrlp.vim'

set wildignore+=*/bower_components/*

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-surround'

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"


" Get off my lawn
"nnoremap <Left> :echoe "Use h"<CR>
"nnoremap <Right> :echoe "Use l"<CR>
"nnoremap <Up> :echoe "Use k"<CR>
"nnoremap <Down> :echoe "Use j"<CR>

syntax enable
filetype plugin indent on