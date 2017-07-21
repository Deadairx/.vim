call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'

Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-sleuth'
Plug 'scrooloose/syntastic'
Plug 'kshenoy/vim-signature'
Plug 'airblade/vimgutter'

Plug 'tpope/vim-dispatch', { 'for': 'cs' }
Plug 'OrangeT/vim-csharp', { 'for': 'cs' }
Plug 'PProvost/vim-ps1',   { 'for': 'ps1' }
Plug 'chrisbra/csv.vim',   { 'for': 'csv' }
Plug 'keith/swift.vim',    { 'for': 'swift' }
Plug 'rust-lang/rust.vim', { 'for': 'rust'  }
Plug 'cespare/vim-toml',   { 'for': 'toml'  }
Plug 'etdev/vim-hexcolor', { 'for': 'css' }
Plug 'kurocode25/mdforvim', { 'for': 'markdown' }
Plug 'myhere/vim-nodejs-complete', { 'for': 'javascript' }

Plug 'morhetz/gruvbox'

Plug 'bling/vim-bufferline'
call plug#end()

scriptencoding utf-8

syntax on
filetype plugin on
filetype plugin indent on

" Sets: {{{1
set nobomb
set so=5
set lazyredraw
set synmaxcol=800
set title
set listchars=trail:·,tab:»\ ,extends:>,precedes:\<
set nowrap
set nu
set rnu
set laststatus=2
set backspace=indent,eol,start
set ignorecase
set smartcase
set incsearch
set splitright
set splitbelow
set cursorline 
set fillchars=vert:│,fold:─
set wildmenu

cabbrev ~? ~/
cabbrev 5s %s

" Functions: {{{1
function! DeleteHiddenBuffers()
  let tpbl = []
  let nClosed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')

  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val) == -1')
    if getbufvar(buf, '&mod') == 0
      silent execute 'bwipeout' buf
      let nClosed += 1
    endif
  endfor

  if nClosed > 0
    echo "Closed " . nClosed . " hidden buffers."
  else
    redraw!
  endif
endfunction

function! OpenInBrowser()
  if executable('firefox')
    let line = getline('.')
    let line = matchstr(line, 'http[^   ]*')
    exec "!firefox " . line
  else
    echo "firefox not executable"
  endif
endfunction

if exists('*OpenInBrowser')
  nnoremap <leader>w :call OpenInBrowser()<cr>
endif

function! TidyCurrent()
  :!tidy -m -wrap 0 %
endfunction

nnoremap <leader>t :call TidyCurrent()<cr>

function! WhatIsMyLeaderKey()
  :echo 'Map leader is' (exists('g:mapleader')? g:mapleader : '\')
endfunction

function! SynStack()
  if !exists('*synstack')
    return
  endif

  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

if exists('*SynStack')
  nmap <leader>s :call SynStack()<cr>
endif

function! GetCurrentByteOffset()
  echo eval(line2byte(line("."))+col(".")-1)
endfunction

"function! LintVimrc()
"  call vimlint#vimlint($MYVIMRC, {'output': 'quickfix'})
"  source $MYVIMRC
"endfunction

"LocalIndentGuide +hl +cc
highlight LocalIndentGuide ctermfg=221 ctermbg=0 cterm=inverse

" AutoCommands: We only want to execute these once {{{1
if !exists('s:autocommands_loaded') && has('autocmd')
  let s:autocommands_loaded = 1

  autocmd Filetype gitcommit setlocal spell textwidth=72

  "autocmd BufWinEnter,BufNewFile,BufRead *.tt2 :call match Comment ",\|\""

  " Handle OpenRA archives (and 'jar') as zip files
  autocmd BufReadCmd *.orapkg,*.oramap,*.oramod,*.jar call zip#Browse(expand('<amatch>'))

  autocmd BufWinEnter,BufNewFile,BufRead *.cake setlocal ft=cs

  " Source vimrc when it is written
  augroup reload_vimrc
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    "autocmd BufWritePost $MYVIMRC call LintVimrc()
  augroup END

  augroup filetypedetect
    autocmd BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
  augroup END

  "autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
endif

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  "let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_user_command = 'ag %s -l -g ""'
  let g:ctrlp_use_caching = 0

  " These commands/mappings will open a buffer for each result, so remember to
  " :call DeleteHiddenBuffers
  nnoremap K :grep! "\b<c-r><c-w>\b"<cr>:cw<cr>
  command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  "nnoremap \ :Ag<space>
endif

" Colorscheme {{{1
colorscheme darkblue
set background=dark
set tabstop=4

" Cursor Block for cygwin
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"
