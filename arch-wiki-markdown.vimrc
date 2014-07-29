" Main Settings:
set nocompatible "disable vi-compatibility settings
setglobal fileencoding=utf-8
set encoding=utf-8 "set encoding
set fileformats=unix,dos,mac "set compatible line endings in order of preference
set nolist nonumber wrap linebreak breakat&vim breakat-=* "prevent line-breaking mid-word
set foldcolumn=0 "fold layers 5 or more deep
set lazyredraw "only redraw what needs to be redrawn
set ttyfast "assume a fast connection to the terminal for better rendering
set smarttab expandtab autoindent tabstop=4 shiftwidth=4 "configure tabs
set hlsearch incsearch ignorecase smartcase "configure how search behaves
set timeout timeoutlen=1000 "how long before timing out for mappings
set ttimeout ttimeoutlen=100 "how long before timing out for terminal key codes
set clipboard=unnamed
if has('unnamedplus')|set clipboard+=unnamedplus|endif
set mouse=a "enables mouse functionality with extended capabilities
if has("mouse_sgr")|set ttymouse=sgr|else|set ttymouse=xterm2|endif
if $TERM =~ '^linux'|set t_Co=8|elseif !has("gui_running")|set t_Co=256|endif
set nocursorline nocursorcolumn "disable cursor column/line highlighting
set nofoldenable "disable the fold column
set noru laststatus=0 noshowmode "remove statusline
set clipboard=autoselect "autocopy selection
set clipboard+=unnamed "use '*' reg
if has('unnamedplus')|set clipboard+=unnamedplus|endif "if exists, use '+' reg
set autoread "track file changes
autocmd CursorHold * checktime "use CursorHold events to trigger checktime
filetype plugin indent on
syntax on
set conceallevel=2

" Load Syntax:
runtime ftdetect/mkd.vim
runtime ftplugin/mkd.vim
runtime syntax/mkd.vim
set filetype=mkd

" Load Theme:
colorscheme arch-wiki-markdown

" Unset Mappings:
unmap v
unmap w
unmap <PageDown>
unmap <kPageDown>
unmap <PageUp>
unmap <kPageUp>

" Mappings:
map <C-ScrollWheelUp> <Nop>
map <C-ScrollWheelDown> <Nop>
map <A-ScrollWheelUp> <Nop>
map <A-ScrollWheelDown> <Nop>
noremap <C-ScrollWheelUp> 4zl
noremap <C-ScrollWheelDown> 4zh
noremap <A-ScrollWheelUp> zl
noremap <A-ScrollWheelDown> zh
noremap <Home> 0
noremap <kHome> <Home>
noremap <End> $
noremap <kEnd> <End>
noremap <Up> <C-P>
noremap <Down> <C-N>
noremap = +
noremap _ -
noremap <C-Up> 4k
noremap <C-Down> 4j
noremap <C-Right> <S-Right>
noremap <C-Left> <S-Left>
noremap <S-Up> gg0
noremap <S-Down> G$
noremap <S-Right> $
noremap <S-Left> ^
nnoremap y vy<Esc>
vnoremap y y
nnoremap <C-c> y
vnoremap <C-c> y
nnoremap T vg_y
vnoremap T g_y
nnoremap <C-a> gg0vG$
xnoremap <C-a> <Esc>gg0vG$
nnoremap <Leader>a gg0vG$
xnoremap <Leader>a <Esc>gg0vG$
nnoremap <silent><expr> <Leader>/ ':noh<CR>'
noremap <silent><expr> q ':q<CR>'
