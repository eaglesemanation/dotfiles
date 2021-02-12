call plug#begin()

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'dense-analysis/ale'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'sheerun/vim-polyglot'

Plug 'lervag/vimtex'

call plug#end()

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('sources', {
\ '_': ['ale', 'ultisnips', 'omni'],
\})

let g:ale_fixers = ['remove_trailing_lines', 'trim_whitespace']

set hidden
