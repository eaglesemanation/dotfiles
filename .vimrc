" Load default configs
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
" Load all plugins
packloadall

set number
set relativenumber

" Default directions for new splits
set splitright
set splitbelow

" Copy indentation from previous line
set autoindent

set spelllang=en,ru

if exists('+termguicolors')
	" Fix for alacritty
	let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
	" RGB colors
	set termguicolors
endif

colorscheme dracula

filetype plugin on
autocmd BufRead,BufNewFile *.txt set filetype=plaintext

" Saves edits. Arguments: number of files, number of lines, number of
" commands, enables autosave and autorestore, path to save
set viminfo='10,<100,:100,%,n~/.vim/viminfo

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

let g:ale_completion_tsserver_autoimport = 1
let g:ale_completion_enabled = 1
let g:ale_set_balloons = 1

"let g:ale_cpp_clang_options = '-std=c++2a -Wall -Wextra'
"let g:ale_linters = {
"	\ 'cpp': ['clang']
"	\ }

let g:netrw_banner = 0
