set sw=4
set ts=4
set expandtab
set ic
set fileformat=unix
set encoding=utf-8

" pathogen related
execute pathogen#infect()
syntax on
filetype plugin indent on

" syntastic related
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 '

map <silent> <Leader>e :Errors<CR>
map <Leader>s :SyntasticToggleMode<CR>
" let g:syntastic_auto_loc_list=1

" vim2hs related
set nofoldenable

" vim-hdevtools/hdevtools related
au FileType haskell nnoremap <buffer> <F2> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F3> :HdevtoolsClear<CR>
au FileType haskell nnoremap <buffer> <silent> <F4> :HdevtoolsInfo<CR>

so $HOME/myVimrc
