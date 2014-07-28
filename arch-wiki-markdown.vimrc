"settings
set encoding=utf-8 "set encoding
set nolist wrap linebreak breakat&vim breakat-=* "prevent line-breaking mid-word
set clipboard=unnamedplus "copying will go to the xorg clipboard
set lazyredraw "only redraw what needs to be redrawn
set ttyfast "assume a fast connection to the terminal for better rendering
set mouse=a "enables mouse functionality with extended capabilities
if has("mouse_sgr")
    set ttymouse=sgr "use mouse handling that emits sgr-style reporting if it's available
else
    set ttymouse=xterm2 "fall back to xterm2-style reporting if sgr isn't available
endif
if $TERM =~ '^linux'
    set t_Co=8 "use 8 colours when a vterm is detected
elseif !has("gui_running")
    set t_Co=256 "assume 256 colours when any other terminal is detected
endif

"markdown syntax
filetype plugin indent on
syntax on
set conceallevel=2
runtime ftdetect/mkd.vim
runtime ftplugin/mkd.vim
runtime syntax/mkd.vim
set filetype=mkd

"arch-wiki-markdown colourscheme
colorscheme arch-wiki-markdown
