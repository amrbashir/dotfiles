let mapleader = "\<Space>"
set nocompatible
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
set wildmenu
set wildmode=longest:list,full

highlight Pmenu ctermbg=60 ctermfg=15
highlight PmenuSel ctermbg=62 ctermfg=235
highlight PmenuSbar ctermbg=60
highlight PmenuThumb ctermbg=62

" Toggle line wrap for current buffer
nmap <leader>wr :setlocal wrap!<CR>

" Remove search highlights
nnoremap <C-h> :nohlsearch<CR>
vnoremap <C-h> :nohlsearch<CR>

" Easier start/end of line motion
map H ^
map L $

" Disable arrow keys to force myself to use home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Go down/up on wrapped lines
nnoremap j gj
nnoremap k gk

" Center searsh results upon navigation
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz

" Very magic search/replace by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

" Navigte between buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" Toggle between buffers
nnoremap <leader><leader> <c-^>



call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'machakann/vim-highlightedyank'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'onsails/lspkind-nvim'
Plug 'airblade/vim-rooter'
Plug 'ray-x/lsp_signature.nvim'
Plug 'nvim-lua/plenary.nvim'
call plug#end()


lua <<EOF
local nvim_lsp = require('lspconfig')
local cmp = require('cmp')
local lspkind = require('lspkind')

local on_attach = function(client)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  require("lsp_signature").on_attach()
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = { 'rust_analyzer' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true
                },
                procMacro = {
                    enable = true
                },
            }
        }
    })
end

cmp.setup({
  snippet = {
    -- REQUIRED by nvim-cmp
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

-- TODO: check vscode autocomplete behavior and match it
  mapping = {
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  },

  formatting = {
      format = lspkind.cmp_format()
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'cmdline' },
    { name = 'path' }
  })
})
EOF

autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()


" TODO: add file explorer
" TODO: search for a word in the workspace and replace
" TODO: vscode ctrl+p and ctrl+o
" TODO: better ESC
" TODO: show buffers as Tabs
" TODO: better coloring of autocomplete popus
