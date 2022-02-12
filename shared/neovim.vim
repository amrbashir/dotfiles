" -----------------
"  Editor setttings
" -----------------
let mapleader = "\<Space>"
filetype plugin indent on
syntax on
set nocompatible " Disable Vi compatability
set mouse=a "Enable mouse everywhere
set number " Show line number
set relativenumber "Show the line numbers relative to current line; useful for motions.
set noerrorbells " Disable the annoying error sounds
set backspace=indent,eol,start " Make backspace work as expected
set laststatus=2 " Always have a statusline
set autoindent
set smartindent
set scrolloff=2 " Show 2 lines before and after the cursor on the screen
set noshowmode " Disables current mode text; replaced by statusline plugin
set hidden " Allow hidden buffers; useful for popups and tabs
set signcolumn=number " Show signs in the line numbers column instead of its own column
set shiftwidth=4
set tabstop=4
set expandtab " Use Spaces instead of Tabs
set smarttab
set showcmd " Displays commands like when using leader key comobos
set cmdheight=2 " Give more space to display messages in the cmdline 
set updatetime=300 " Faster updates to the buffer for smooth experience
set shortmess+=c " Don't pass messages to |ins-completion-menu|; useful for coc.nvim
set incsearch " Navigate to search matches as you type
set ignorecase " Enble case-insensitive search 
set smartcase " Enable case-insensitive search if it only contains lowercase letters; see |ignorecase|
set wildmenu " Enable autocomplete menu for the cmdline 
set wildmode=longest:list,full " Set wildmenu completion to show list if there is many then complete full match afterwards
set nobackup " Disable backup for some coc.nvim lsp servers; see coc.nvim#649
set nowritebackup " Disable backup for some coc.nvim lsp servers; see coc.nvim#649
set nowrap " Disable line wrapping

" ----------------------
" Editor colors settings
" ----------------------
highlight Pmenu ctermbg=60 ctermfg=15
highlight PmenuSel ctermbg=62 ctermfg=235
highlight PmenuSbar ctermbg=60
highlight PmenuThumb ctermbg=62

" ----------------
" Plugins settings
" ----------------
call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'machakann/vim-highlightedyank'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdcommenter'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()

let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-rust-analyzer', 'coc-prettier']
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1

" ------------
"  Keybindings
" ------------
	" |<leader>+wr| to toggle line wrappig
nmap <leader>wr :setlocal wrap!<CR>
	" |Ctrl+h| to remove search highlights
nnoremap <C-h> :nohlsearch<CR>
vnoremap <C-h> :nohlsearch<CR>
	" |Shift+h| for easier start of line motion
map H ^
	" |Shift+l| for easier end of line motion
map L $
	" |j| to navigate down on wrapped lines
nnoremap j gj
	" |k| to navigate up on wrapped lines
nnoremap k gk 
	" |n| to navigate to next search match, centered on screen
nnoremap <silent> n nzz
	" |Shift+n| to navigate to previous search match, centered on screen
nnoremap <silent> N Nzz
	" |*| to navigate to next search match, centered on screen
nnoremap <silent> * *zz
	" |Shift+3| to navigate to previous match of current word under cursor, centered on screen
nnoremap <silent> # #zz
	" |/| to search forwards using regex
nnoremap / /\v
	" |?| to search backwards using regex
nnoremap ? ?\v 
	" |:%s/| to search and replace using regex
cnoremap %s/ %sm/
	" |<leader>+c| to toggle comments
nmap <leader>c <Plug>NERDCommenterInver 
	" |Ctrl+Space| to open the autocomplete menu
inoremap <silent><expr> <c-space> coc#refresh() 
	" |Tab| to autocomplete and cycle forwards in the autocomplete menu
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>" 
	" |Enter| to use the selected item in the autocomplete menu
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<CR>"
	" |gd| to go to symbol definition
nmap <silent> gd <Plug>(coc-definition)
	" |gtd| to go to symbol type definition
nmap <silent> gtd <Plug>(coc-type-definition)
	" |gi| to go to symbol implementation 
nmap <silent> gi <Plug>(coc-implementation)
	" |gr| to go to symbol refrences
nmap <silent> gr <Plug>(coc-references)
	" |<leader>r| to rename a symbol
nmap <leader>r <Plug>(coc-rename)
	" |<leader>+a| to perform code actions
xmap <leader>a <Plug>(coc-codeaction-selected)
	" |<leader>+a| to perform code actions
nmap <leader>a <Plug>(coc-codeaction-selected)
	" |<leader>+cl| to perform code lense actions
nmap <leader>cl  <Plug>(coc-codelens-action)
	" |Shift+K| to show symbol documentation
nnoremap <silent> K :call <SID>show_documentation()<CR> 
	" |<leader>+f| to format current buffer
nmap <leader>f :call CocActionAsync('format')<CR>

" -------
" General
" -------
autocmd CursorHold * silent call CocActionAsync('highlight') " Highlight the symbol and its references when holding the cursor.

" ----------------
" Helper functions
" ----------------
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" TODO: add file explorer
" TODO: search for a word in the workspace and replace
" TODO: better ESC
" TODO: show buffers as Tabs
" TODO: better coloring of autocomplete popus
" TODO: integrate coc.nvim to lightline and customize lightline
"
