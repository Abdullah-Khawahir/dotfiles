" -----------------------------
" General Options
" -----------------------------
colorscheme habamax
set nocompatible
set wrap
set nowrap
set colorcolumn=80

set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent

set number
set relativenumber
set mouse=a
set termguicolors
set noshowmode
set clipboard=unnamedplus
set breakindent
set undofile
set termbidi
set ignorecase
set smartcase
set wildignorecase
set signcolumn=yes
set updatetime=100
set timeoutlen=1000
set splitright
set splitbelow
set list
set listchars=tab:»\ ,trail:·,nbsp:␣
" set inccommand=split
set cursorline
set scrolloff=10
set hlsearch
set linebreak
set laststatus=3
set nomodeline

" -----------------------------
" Path and Dictionary
" -----------------------------
set path+=**
set dictionary=/usr/share/dict/cracklib-small

" -----------------------------
" Packadd
" -----------------------------
packadd cfilter

" -----------------------------
" Netrw Options
" -----------------------------
let g:netrw_banner = 0
let g:netrw_fastbrowse = 0
let g:netrw_keepdir = 1
let g:netrw_localcopydircmd = 'cp -r'
let g:netrw_preview = 1
let g:netrw_winsize = 30
let g:netrw_list_hide = '\v(\.swp$|node_modules|__pycache__|\.git)'

" -----------------------------
" Compiler/SDK Paths
" -----------------------------
let g:dotnet_errors_only = 0
let g:dart_sdk_path = "~/development/flutter/"
let g:python3_host_prog = "~/venv/bin/python3"

" -----------------------------
" Key Mappings
" -----------------------------
" Leader
let mapleader=" "
let maplocalleader=" "

" Normal Mode
nnoremap <Esc> :nohlsearch<CR>
nnoremap <leader>e :lua vim.diagnostic.open_float()<CR>
nnoremap <C-s> :w<CR>
nnoremap ]b :bn<CR>
nnoremap [b :bp<CR>
nnoremap ZD :bd<CR>
nnoremap <C-S-s> :wa<CR>
nnoremap <leader><leader> :b 
nnoremap ]q :cn<CR>
nnoremap [q :cp<CR>
nnoremap <leader>C :!!<CR>
nnoremap <C-w><C-t> :term<CR>
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <C-S-right> :tabmove<CR>
nnoremap <C-S-left> :tabmove -1<CR>
nnoremap <C-S-T> :tabnew<CR>
nnoremap <c-d> <c-d>zz
nnoremap <c-u> <c-u>zz
nnoremap n nzz
nnoremap N Nzz
nnoremap gX "gy:!xdg-open \"https://www.google.com/search?q=\"<Left>
nnoremap <C-i> <C-i>
nnoremap <leader>ra yiw:%sno/<C-r>"//gc<Left><Left><Left>
nnoremap <leader>rc :sno/<C-r>=expand('<cword>')<CR>//gc<Left><Left><Left>
nnoremap <leader>waf :e <C-r>=expand('%:p:h')<CR>/
nnoremap <leader>wad :silent !mkdir -p <C-r>=expand('%:p:h')<CR>/
nnoremap <leader>wcf :!cp % <C-r>=expand('%:p:h')<CR>/
nnoremap <leader>wcp :let @+=expand('%')<CR>
nnoremap <leader>wmf :!mv % <C-r>=expand('%:p:h')<CR>/
nnoremap <leader>tr :set wrap!<CR>
" nnoremap \c :if &cmdheight==0 | set cmdheight=1 | else | set cmdheight=0 | endif<CR>
nnoremap \r :set wrap!<CR>
nnoremap \gr :windo set wrap!<CR>
nnoremap \s :set spell!<CR>
nnoremap \gs :windo set spell!<CR>
nnoremap \n :set rnu! nu!<CR>
nnoremap \gn :windo set rnu! nu!<CR>
nnoremap \e :set modifiable!<CR>

" Window Movement
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-left> <C-w>>
nnoremap <C-right> <C-w><
nnoremap <C-down> <C-w>-
nnoremap <C-up> <C-w>+

" Visual Mode
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv
vnoremap gX "gy:!xdg-open \"https://www.google.com/search?q=<C-R>g\""<Left>
vnoremap s" di"<C-r>\""
vnoremap s' di'<C-r>\"'
vnoremap s` di`<C-r>\"`
vnoremap s( di(<C-r>\")
vnoremap s[ di[<C-r>\"]
vnoremap s{ di{<C-r>\"}
vnoremap s< di<<C-r>\">

" Normal + Visual
nnoremap gV `[v`]

" Add current line to quickfix
nnoremap <leader>Q :call setqflist([{'bufnr':bufnr('%'),'lnum':line('.'),'col':1,'text':getline('.')}],'a')<CR>

