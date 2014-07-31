"Name our colourscheme
let colors_name = "arch-wiki-markdown"

"Reset the all previous syntax highlighting
" hi clear
if exists("syntax_on")
    syntax reset
endif

"Base colours
hi Normal ctermfg=254 ctermbg=235 guifg=#eaeaea guibg=#262626
hi clear Visual
hi Visual ctermbg=234 guibg=#1c1c1c
hi Underlined term=underline cterm=underline ctermfg=None gui=underline guifg=None
hi Conceal ctermfg=117 ctermbg=235 guifg=117 guifg=#262626
hi Error ctermbg=None guibg=None
hi Comment cterm=italic ctermfg=241 gui=italic guifg=#6c6c6
hi Identifier term=bold cterm=bold ctermfg=117 gui=bold guifg=#87d7ff
hi Special ctermfg=None guifg=None
hi Constant term=bold cterm=bold ctermfg=222 gui=bold guifg=#ffd787
hi Type ctermfg=117 guifg=#87d7ff
hi Title term=bold,underline cterm=bold ctermfg=167 gui=bold,underline guifg=#d75f5f

"HTML colours
hi! link htmlH1 Title
hi htmlH2 term=bold,underline cterm=bold ctermfg=117 gui=bold guifg=#87d7ff
hi htmlH3 term=bold,underline cterm=bold ctermfg=222 gui=bold guifg=#ffd787
hi htmlH4 cterm=italic ctermfg=167 gui=italic guifg=#d75f5f
hi htmlH5 cterm=italic ctermfg=117 gui=italic guifg=#87d7ff
hi htmlH6 cterm=italic ctermfg=222 gui=italic guifg=#ffd787
hi htmlTag term=bold cterm=bold ctermfg=117 gui=bold guifg=#87d7ff
hi htmlLink term=underline cterm=underline ctermfg=167 gui=underline guifg=#d75f5f term=underline
hi htmlBold term=bold cterm=bold ctermfg=231 gui=bold guifg=#ffffff
hi htmlItalic term=reverse cterm=italic gui=italic
hi htmlBoldItalic term=bold,reverse cterm=bold,italic ctermfg=231 gui=bold,italic guifg=#ffffff

"Markdown colours
hi mkdURL ctermfg=117 guifg=#87d7ff
hi! link mkdLineBreak Normal
hi mkdCode cterm=reverse ctermfg=238 ctermbg=222 gui=reverse guifg=#444444 guibg=#ffd787
hi! link mkdIndentCode mkdCode
hi mkdListBullet1 ctermfg=117 guifg=#86d7ff
hi! link mkdListBullet2 mkdListBullet1
