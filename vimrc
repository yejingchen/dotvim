source /etc/vimrc
set nocompatible
filetype plugin indent on
syntax on
set autoindent cindent
set incsearch hlsearch
set ts=4 sw=4 ruler showcmd nu
set colorcolumn=80
set mouse=a

" Indentation preferences for C-like sources
set cino=:0 " the 'case' for switch have same indent as 'switch'
set cino+=t0 " don't indent return type above function declaration/definition
set cino+=l1 " case block aligns according to 'case'
set cino+=g0 " C++ scope declarations (public, private) 0 indent
set cino+=N-s " don't indent inside namespaces

" Certain file type syntax highlight
autocmd BufNewFile,BufRead PKGBUILD* set ft=PKGBUILD

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

" tab-completion candidates
set wildmenu

" vim-syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" vim-syntastic checkers
let g:syntastic_c_checkers = ['clang_check']
let g:syntastic_cpp_checkers = ['clang_check']
let g:syntastic_rust_checkers = ['cargo']

" rust-racer settings
set hidden
let g:racer_cmd = "/usr/bin/racer"
let g:racer_experimental_completer = 1
