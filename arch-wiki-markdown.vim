"Name our colourscheme
let colors_name = "arch-wiki-markdown"

"Reset the all previous syntax highlighting
hi clear
if exists("syntax_on")
    syntax reset
endif

"Unset some things causing issues
hi Error guibg=None ctermbg=None
hi htmlItalic guibg=None ctermbg=None
hi htmlBoldItalic guibg=None ctermbg=None

"Set syntax colours
hi Normal ctermfg=254 ctermbg=235 guifg=#eaeaea guibg=#262626
hi Comment term=bold ctermfg=241 gui=italic guifg=#6c6c6
hi Title cterm=bold ctermfg=167 gui=bold,underline guifg=#d75f5f
hi link htmlH1 Title
hi htmlH2 cterm=bold ctermfg=222 gui=bold,underline guifg=#ffd787
hi htmlH3 cterm=bold ctermfg=117 gui=bold,underline guifg=#87d7ff
hi htmlH4 ctermfg=167 guifg=#d75f5f
hi htmlH5 ctermfg=222 guifg=#ffd787
hi htmlH6 ctermfg=117 guifg=#87d7ff
hi Statement term=underline cterm=bold ctermfg=117 gui=bold guifg=#87d7ff
hi Special term=bold ctermfg=241 gui=italic guifg=#6c6c6c
