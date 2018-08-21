source /etc/vimrc
set nocompatible
filetype plugin indent on
set incsearch hlsearch
set ts=4 sw=4 ruler showcmd nu wildmenu
set colorcolumn=81 cursorline
set mouse=a
syntax enable
"set bg=dark

" GUI clipboard
nnoremap <Leader>y :%y +<CR>
nnoremap <Leader>p :put +<CR>
nnoremap <Leader>P :put! +<CR>

" Indentation preferences for C-like sources
set cino=:0 " the 'case' for switch have same indent as 'switch'
set cino+=t0 " don't indent return type above function declaration/definition
set cino+=l1 " case block aligns according to 'case'
set cino+=g0 " C++ scope declarations (public, private) 0 indent
set cino+=N-s " don't indent inside namespaces

" Certain file type syntax highlight
autocmd BufNewFile,BufRead PKGBUILD* set ft=PKGBUILD autoindent smartindent

" load the shipped man plugin
runtime ftplugin/man.vim

" shipped matchit pack, required by vim-textobj-matchit
packadd! matchit

" YACC C++
let g:yacc_uses_cpp = 1
autocmd BufNewFile,BufRead *.ypp set ft=yacc
autocmd BufNewFile,BufRead *.y++ set ft=yacc

" BEGIN vim-plug
call plug#begin('~/.vim/plugged')
Plug 'w0rp/ale'
Plug 'Konfekt/FastFold'
Plug 'junegunn/vim-easy-align'
Plug 'easymotion/vim-easymotion'
Plug 'altercation/vim-colors-solarized'
Plug 'airblade/vim-gitgutter'
Plug 'kana/vim-textobj-user'
Plug 'adriaanzon/vim-textobj-matchit'
Plug 'igankevich/mesonic'
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf.vim' "depends on external command, installed by pacman
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'make release',
    \ }
call plug#end()

set laststatus=2 " Enable lightline for each window
let g:lightline = {
	\ 'colorscheme' : 'default',
	\ 'active': {
		\ 'left': [ [ 'mode', 'paste' ],
		\			[ 'readonly', 'fugitive', 'filename', 'modified' ] ]
	\ },
	\ 'component' : {
		\ 'readonly' : '%{&readonly ? "" : ""}',
		\ 'fugitive' : '%{!empty(fugitive#head()) ? "git:".fugitive#head() : ""}'
		\ },
	\ 'separator' : { 'left': '', 'right': '' },
	\ 'subseparator' : { 'left': '', 'right': '' }
	\ }
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

let g:clang_use_library = 1 " use clang library instead of executable for code completion

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
	\ 'c': ['clang'],
	\ 'cpp': ['clang'],
	\ }

" fzf: enable Rg command
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" LanguageClient-neovim
let g:LanguageClient_serverCommands = {
	\ 'rust': ['rustup', 'run', 'nightly', 'rls'],
	\ }
augroup lsp_rust
	au FileType rust let g:LanguageClient_diagnosticsEnable = 0 " use ALE linting for rust
	au FileType rust nnoremap <F5> :call LanguageClient_contextMenu()<CR>
	au FileType rust nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
	au FileType rust nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
	au FileType rust nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
	au FileType rust nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
	au FileType rust nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
	au FileType rust nmap <C-]> :call LanguageClient#textDocument_definition()<CR>
augroup END
let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'
