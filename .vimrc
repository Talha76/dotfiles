" Auto importf& Compile
" :autocmd BufNewFile *.cpp 0r ~/cp/template.cpp

nnoremap <F4> :!xclip -o -sel clip > ~/cp/in.txt <CR><CR>
inoremap <F4> <ESC>:!xclip -o -sel clip > ~/cp/in.txt <CR><CR>
nnoremap <F6> :!xclip -sel clip % <CR><CR>
inoremap <F6> <ESC>:!xclip -sel clip % <CR><CR>

autocmd filetype cpp nnoremap <F9>       :wa \| !make %:r && timeout 5s ./%:r < ~/cp/in.txt > ~/cp/out.txt<CR>
autocmd filetype cpp inoremap <F9>  <ESC>:wa \| !make %:r && timeout 5s  ./%:r < ~/cp/in.txt > ~/cp/out.txt<CR>
autocmd filetype cpp nnoremap <F10>      :wa \| !make clean && make %:r D=1 && ./%:r < ~/cp/in.txt > ~/cp/out.txt<CR>
autocmd filetype cpp inoremap <F10> <ESC>:wa \| !make clean && make %:r D=1 && ./%:r < ~/cp/in.txt > ~/cp/out.txt<CR>

autocmd filetype python nnoremap <F9> :wa \| !python % < ~/cp/in.txt > ~/cp/out.txt<CR>
autocmd filetype python inoremap <F9> <ESC>:wa \| !python % < ~/cp/in.txt > ~/cp/out.txt<CR>

" Auto Completion
inoremap ( ()<left>
inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap { {}<left>
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap [ []<left>
inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<left>"
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<left>"

inoremap <expr> <CR> <sid>insert_newline()
function s:insert_newline() abort
  let pair = strpart(getline('.'), col('.')-2, 2)
  return stridx('(){}[]', pair) % 2 == 0 && strlen(pair) == 2 ? "\<CR>\<ESC>\O" : "\<CR>"
endfunction

inoremap <expr> <space> <sid>insert_space()
function s:insert_space() abort
  let pair = strpart(getline('.'), col('.')-2, 2)
  return stridx('(){}[]', pair) % 2 == 0 && strlen(pair) == 2 ? "\<space>\<space>\<left>" : "\<space>"
endfunction

inoremap <expr> <bs> <sid>rm_pair()
function s:rm_pair() abort
	let pair = strpart(getline('.'), col('.')-2, 2)
	return stridx('(){}[]''''""', pair) % 2 == 0 && strlen(pair) == 2 ? "\<del>\<bs>" : "\<bs>"
endfunction

function! ToggleComment()
    " Check if the current line is commented
    if getline('.') =~ '^\s*//'
        " Uncomment the line
        s/^\(\s*\)\/\/ /\1/
    else
        " Comment the line
        s/^\(\s*\)/\1\/\/ /
    endif
endfunction

" Map Ctrl+/ to the ToggleComment function in normal mode
nnoremap <C-_> :call ToggleComment()<CR>

" Map Ctrl+/ to the ToggleComment function in visual mode
vnoremap <C-_> :call ToggleComment()<CR>gv

map <C-c> "+y

set nocompatible              " be iMproved, required
filetype on                  " required
filetype plugin on
filetype plugin indent on
syntax on

set splitright splitbelow
set mouse=a
set number
set relativenumber
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2
set smartindent
set smarttab
set autoindent
set cindent
set noerrorbells
set ruler
set guifont=*
set backspace=indent,eol,start
" set ignorecase
set incsearch
set nowrap
set hlsearch

" bubt site
" set termguicolors
set foldmethod=indent
set nofoldenable
" set cursorline
set laststatus=2
set showcmd
set wildmenu
colorscheme habamax

if !has('nvim')
  set clipboard=unnamedplus
endif
if !has('nvim')
  set ttymouse=xterm2
endif

nnoremap <S-j> :m .+1<CR>==
nnoremap <S-k> :m .-2<CR>==
vnoremap <S-j> :m '>+1<CR>gv==gv
vnoremap <S-k> :m '<-2<CR>gv==gv

nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

tnoremap <A-h> <C-\><C-n><A-h>
tnoremap <A-j> <C-\><C-n><A-j>
tnoremap <A-k> <C-\><C-n><A-k>
tnoremap <A-l> <C-\><C-n><A-l>

filetype plugin indent on    " required

" for development
let mapleader = ','
map <leader>dev :Lex<CR>60<C-w><<A-l><C-w>s12<C-w>-:term<CR><A-k>
map <leader>cp :50 vsplit in.txt<CR>:split out.txt<CR><C-w>h

let g:copilot_enabled = v:false

call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf'
call plug#end()

" FZF
nnoremap <leader>f :FZF<CR>

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<tab>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<s-tab>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" inoremap <silent><expr> <CR>
"       \ coc#pum#visible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ CheckBackspace() ? "\<TAB>" :
"       \ coc#refresh()

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
