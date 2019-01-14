scriptencoding utf-8
if filereadable('/etc/vimrc')
	source /etc/vimrc
endif
filetype plugin indent on
set incsearch hlsearch
set tabstop=4 shiftwidth=4 ruler showcmd nu wildmenu
set colorcolumn=81 cursorline
set mouse=a
syntax enable
set bg=dark

" GUI clipboard
nnoremap <Leader>y :%y +<CR>
nnoremap <Leader>p :put +<CR>
nnoremap <Leader>P :put! +<CR>

" Indentation preferences for C-like sources
set cinoptions=:0 " 'case' for switch have same indent as 'switch'
set cinoptions+=t0 " don't indent return type in function declaration/definition
set cinoptions+=l1 " case block aligns according to 'case'
set cinoptions+=g0 " C++ scope declarations (public, private) 0 indent
set cinoptions+=N-s " don't indent inside namespaces

" Certain file type syntax highlight
augroup archlinux
	au!
	autocmd BufNewFile,BufRead PKGBUILD* set ft=PKGBUILD autoindent smartindent
augroup END

" load the shipped man plugin
runtime ftplugin/man.vim

" shipped matchit pack, required by vim-textobj-matchit
packadd! matchit

" YACC C++
let g:yacc_uses_cpp = 1
augroup yacc
	au!
	autocmd BufNewFile,BufRead *.ypp set ft=yacc
	autocmd BufNewFile,BufRead *.y++ set ft=yacc
augroup END

" BEGIN vim-plug
call plug#begin('~/.vim/plugged')
Plug 'w0rp/ale'
Plug 'Konfekt/FastFold'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/vim-easy-align'
Plug 'easymotion/vim-easymotion'
Plug 'altercation/vim-colors-solarized'
Plug 'airblade/vim-gitgutter'
Plug 'kana/vim-textobj-user'
Plug 'adriaanzon/vim-textobj-matchit'
Plug 'igankevich/mesonic'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf.vim' "depends on external command, installed by pacman
Plug 'solarnz/thrift.vim'
call plug#end()

set laststatus=2 " Enable lightline for each window
let g:lightline = {
	\ 'colorscheme' : 'default',
	\ 'active': {
	\	'left': [ [ 'mode', 'paste' ],
	\				[ 'readonly', 'gitbranch', 'filename', 'modified' ],
	\				[ 'ale_checking' ] ],
	\	'right': [ [ 'lineinfo', 'ale_errors', 'ale_warnings' ],
	\	           [ 'percent' ],
	\	           [ 'fileformat', 'fileencoding', 'filetype' ] ] 
	\	},
	\ 'component': {
	\	'readonly' : '%{&readonly ? "" : ""}',
	\	},
	\ 'component_expand': {
	\ 	'ale_checking': 'lightline#ale#checking',
	\	'ale_warnings': 'lightline#ale#warnings',
	\	'ale_errors': 'lightline#ale#errors',
	\	},
	\ 'component_function': {
	\	'gitbranch': 'Gitbranch',
	\	},
	\ 'component_type': {
	\	'ale_checking': 'left',
	\	'ale_warnings': 'warning',
	\	'ale_errors': 'error',
	\	},
	\ 'separator' : { 'left': '', 'right': '' },
	\ 'subseparator' : { 'left': '', 'right': '' }
	\ }
function! Gitbranch() abort 
	let br = fugitive#head()
	return !empty(br) ? 'git:'. br : ''
endfunction
augroup LightlineColorscheme
	autocmd!
	autocmd ColorScheme * call s:lightline_update()
augroup END
function! s:lightline_update()
	if !exists('g:loaded_lightline')
		return
	endif
	try
		if g:colors_name =~# 'wombat\|solarized\|landscape\|jellybeans\|seoul256\|Tomorrow'
			let g:lightline.colorscheme =
						\ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
			call lightline#init()
			call lightline#colorscheme()
			call lightline#update()
		endif
	catch
	endtry
endfunction

" rust.vim
let g:rust_fold = 1

" FastFold
nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

" vim-easy-align, visual & normal mode
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" ALE
let g:ale_linters = {
	\ 'rust': ['rls'],
	\ 'c': ['ccls'],
	\ 'cpp': ['ccls'],
	\ }
let g:ale_completion_enabled = 1
let g:ale_sign_error = '!!'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <silent> gr <Plug>(ale_find_references)
nmap <silent> gd <Plug>(ale_go_to_definition)
nmap <silent> gh <Plug>(ale_hover)
augroup alemaps
	au!
	au FileType rust nmap <silent> <C-]> <Plug>(ale_go_to_definition)
	au FileType c nmap <silent> <C-]> <Plug>(ale_go_to_definition)
	au FileType cpp nmap <silent> <C-]> <Plug>(ale_go_to_definition)
augroup END

" fzf: enable Rg command
command! -bang -nargs=* RG
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
