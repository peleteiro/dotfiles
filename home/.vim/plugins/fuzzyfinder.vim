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


