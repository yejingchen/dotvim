scriptencoding utf-8
if filereadable('/etc/vimrc')
	source /etc/vimrc
endif
filetype plugin indent on
set hidden
set incsearch hlsearch
set tabstop=4 shiftwidth=4 expandtab
set ruler showcmd nu wildmenu
set formatoptions+=mM shortmess-=S
set colorcolumn=81 cursorline
set mouse=a
syntax enable
"set background=light termguicolors

highlight clear SignColumn

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

set completeopt+=popup

" ALE
let g:ale_linters = {
            \ 'rust': [],
            \ 'c': [],
            \ 'cpp': [],
            \ 'objc': [],
            \ 'objcpp': [],
            \}
"let g:ale_completion_enabled = 1
let g:ale_sign_error = '!!'
let g:ale_set_balloons = 1
"set omnifunc=ale#completion#OmniFunc

" mac os surprises
set pythonthreedll=/usr/local/Frameworks/Python.framework/Versions/Current/Python

" BEGIN vim-plug
call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale'
Plug 'Konfekt/FastFold'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/vim-easy-align'
Plug 'easymotion/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'kana/vim-textobj-user'
Plug 'adriaanzon/vim-textobj-matchit'
Plug 'igankevich/mesonic'
Plug 'solarnz/thrift.vim'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'majutsushi/tagbar'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim' "depends on external command, installed by pacman
"Plug 'tpope/vim-endwise'
Plug 'rstacruz/vim-closer'
Plug 'rust-lang/rust.vim'
Plug 'noahfrederick/vim-hemisu'
Plug 'scrooloose/nerdtree'
Plug 'saltstack/salt-vim'
Plug 'cespare/vim-toml'
Plug 'lifepillar/vim-solarized8'
Plug 'reedes/vim-colors-pencil'
Plug 'chr4/nginx.vim'
Plug 'ycm-core/YouCompleteMe', { 'do': '/usr/local/bin/python3 install.py' }
call plug#end()

set laststatus=2 " Enable lightline for each window
let g:lightline = {
	\ 'colorscheme' : 'one',
	\ 'active': {
	\	'left': [ [ 'mode', 'paste' ],
	\				[ 'readonly', 'gitbranch', 'filename', 'modified' ],
	\				[ 'ale_checking' ] ],
	\	'right': [ [ 'lineinfo', 'ale_errors', 'ale_warnings', 'ycm_warnings', 'ycm_errors' ],
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
	\	'ycm_warnings': 'youcompleteme#GetWarningCount',
	\	'ycm_errors': 'youcompleteme#GetErrorCount'
	\	},
	\ 'component_type': {
	\	'ale_checking': 'left',
	\	'ale_warnings': 'warning',
	\	'ale_errors': 'error',
	\	'ycm_warnings': 'warning',
	\	'ycm_errors': 'error',
	\	},
	\ 'component_function': {
	\	'gitbranch': 'Gitbranch',
	\	},
	\ }
function! Gitbranch() abort 
	let br = FugitiveHead()
	return !empty(br) ? ''.br : ''
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
        if g:colors_name =~# 'wombat\|solarized8\{,1}\|landscape\|jellybeans\|seoul256\|Tomorrow'
			let g:lightline.colorscheme =
						\ substitute(substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', ''), '8', '', '')
			call lightline#init()
			call lightline#colorscheme()
			call lightline#update()
		endif
	catch
	endtry
endfunction

" YouCompleteMe
let g:ycm_language_server = 
            \[
            \   {
            \       'name': 'rust',
            \       'cmdline': ['rust-analyzer'],
            \       'filetypes': ['rust'],
            \       'project_root_files': ['Cargo.toml'],
            \   },
            \   {
            \       'name': 'ccls',
            \       'cmdline': ['ccls'],
            \       'filetypes': ['c', 'cpp', 'objc', 'objcpp'],
            \       'project_root_files': ['.ccls-root', 'compile_commands.json']
            \   },
            \]
let g:ycm_rust_toolchain_root = '/Users/jye/.rustup/toolchains/stable-x86_64-apple-darwin'
nnoremap gd :YcmCompleter GoTo<CR>
nnoremap gr :YcmCompleter GoToReferences<CR>
nnoremap gt :YcmCompleter GetType<CR>

"colorscheme solarized8

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

" fzf: enable Rg command
command! -bang -nargs=* RG
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
