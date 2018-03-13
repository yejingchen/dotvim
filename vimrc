source /etc/vimrc
set nocompatible
filetype plugin indent on
set cindent foldmethod=syntax
set incsearch hlsearch
set ts=4 sw=4 ruler showcmd nu wildmenu
set colorcolumn=80 cursorline
set mouse=a

nnoremap <Leader>y :%y +<CR>
nnoremap <Leader>p :put +<CR>
nnoremap <Leader>P :put! +<CR>

syntax enable
set bg=dark 
"colorscheme solarized

" Indentation preferences for C-like sources
set cino=:0 " the 'case' for switch have same indent as 'switch'
set cino+=t0 " don't indent return type above function declaration/definition
set cino+=l1 " case block aligns according to 'case'
set cino+=g0 " C++ scope declarations (public, private) 0 indent
set cino+=N-s " don't indent inside namespaces

" Certain file type syntax highlight
autocmd BufNewFile,BufRead PKGBUILD* set ft=PKGBUILD nocindent autoindent smartindent

set laststatus=2 " Enable lightline for each window
let g:lightline = {
	\ 'colorscheme' : 'default',
	\ 'component' : {
		\ 'readonly' : '%{&readonly ? "" : ""}',
		\ 'fugitive' : '%{exists("*fugitive#head") ? fugitive#head() : ""}'
		\ },
	\ 'separator' : { 'left': '', 'right': '' },
	\ 'subseparator' : { 'left': '', 'right': '' }
	\ }

runtime ftplugin/man.vim " load the shipped man plugin
let g:clang_use_library = 1 " use clang library instead of executable for code completion

" incsearch.vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" rust.vim
let g:rust_fold = 1

" shipped matchit pack, required by vim-textobj-matchit
packadd! matchit

" FastFold
nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

" vim-easy-align, visual & normal mode
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" ALE
let g:ale_linters =  {
	\ 'rust': ['rls'],
	\ 'c': ['clang'],
	\ 'cpp': ['clang'],
	\ }
let g:ale_rust_rls_toolchain = 'stable'

" helptags
"silent! helptags ALL
