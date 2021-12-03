let mapleader = "\<Space>"
set nocompatible

" <<< Plugins >>>
call plug#begin()

Plug 'itchyny/lightline.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'machakann/vim-highlightedyank'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
" <<</ Plugins >>>

" <<< coc.nvim >>>
inoremap <silent><expr> <C-Space> coc#refresh()

" todo: if item is selected, autocomplete it, or match with vscode behavior
" and find another way to scroll down the list 
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gtd <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>r <Plug>(coc-rename)
nmap <leader>a <Plug>(coc-codeaction)
nmap <leader>f :call CocAction('format')<CR>

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" <<</ coc.nvim >>>

" <<< Editor >>>
filetype plugin indent on
syntax on
set mouse=a
set number
set relativenumber
set nowrap
set noerrorbells
set encoding=utf8
set backspace=2
set laststatus=2
set autoindent
set smartindent
set scrolloff=2
set noshowmode
set hidden
set signcolumn=number
set wildmenu
set wildmode=longest:list,full
set shiftwidth=4
set tabstop=4
set expandtab
set smarttab
set splitright
set splitbelow
set showcmd
set cmdheight=2
set updatetime=300
set shortmess+=c
set incsearch
set ignorecase
set smartcase

highlight Pmenu ctermbg=60 ctermfg=15
highlight PmenuSel ctermbg=62 ctermfg=235
highlight PmenuSbar ctermbg=60
highlight PmenuThumb ctermbg=62

nmap <leader>wr :setlocal wrap!<CR>

" Ctrl+H to remove search highlights
nnoremap <C-h> :nohlsearch<CR>
vnoremap <C-h> :nohlsearch<CR>

" Easier start/end of line motion
map H ^
map L $

" Force my self to use home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Switch between buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" Useful for navigation when lines are wrapped
nnoremap j gj
nnoremap k gk

" Search results centered
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz

" Very magic search/replace by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

" Toggle between buffers
nnoremap <leader><leader> <c-^>

" todo: add keybinding for commenting lines
" todo: add file explorer
" todo: search for a word in the workspace
" todo: vscode ctrl+p and ctrl+o
" todo: f2 to rename symbol
" todo: better ESC
" todo: show buffers as Tabs
" todo: better coloring of autocomplete popus
" todo: move lines up and down Alt+[jk], match vscode
" todo: copy lines up and down Ctrl+Shift+[jk] match vscode
" <<</ Editor>>>
