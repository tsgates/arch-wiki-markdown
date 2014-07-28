" Vim syntax file
" Language:     Markdown (Concealed Version)
" Maintainer:   Kevin MacMartin <prurigro at gmail dot com>
" Contributor:  Ben Williams <benw@plasticboy.com> (based on vim-markdown v9)

" Read the HTML syntax to start with
if version < 600
    so <sfile>:p:h/html.vim
else
    runtime! syntax/html.vim
    if exists('b:current_syntax')
        unlet b:current_syntax
    endif
endif

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" don't use standard HiLink, it will not work with included syntax files
if version < 508
    command! -nargs=+ HtmlHiLink hi link <args>
else
    command! -nargs=+ HtmlHiLink hi def link <args>
endif

syn spell toplevel
syn case ignore
syn sync linebreaks=1

"additions to HTML groups
syn region htmlItalic       start="\\\@<!\*\S\@="                              end="\S\@<=\\\@<!\*"            keepend oneline contains=htmlItalicUL
syn region htmlItalic       start="\(^\|\s\)\@<=_\|\\\@<!_\([^_]\+\s\)\@="     end="\S\@<=_\|_\S\@="           keepend oneline contains=htmlItalicUL
syn region htmlBold         start="\S\@<=\*\*\|\*\*\S\@="                      end="\S\@<=\*\*\|\*\*\S\@="     keepend oneline contains=htmlBoldStar
syn region htmlBold         start="\S\@<=__\|__\S\@="                          end="\S\@<=__\|__\S\@="         keepend oneline contains=htmlBoldStar
syn region htmlBoldItalic   start="\S\@<=\*\*\*\|\*\*\*\S\@="                  end="\S\@<=\*\*\*\|\*\*\*\S\@=" keepend oneline contains=htmlBoldStar,htmlItalicUL
syn region htmlBoldItalic   start="\S\@<=___\|___\S\@="                        end="\S\@<=___\|___\S\@="       keepend oneline contains=htmlBoldStar,htmlItalicUL
syn match  htmlBoldStar     "\*\*\**"                                                                      contained conceal
syn match  htmlItalicUL     "__*"                                                                         contained conceal
syn region mkdFootnotes     matchgroup=mkdDelimiter start="\[^"                end="\]"
syn region mkdID            matchgroup=mkdDelimiter start="\!?\["              end="\]"                              contained oneline
syn region mkdURL           matchgroup=mkdDelimiter start="("                  end=")"                            contained oneline concealends
syn region mkdLink          matchgroup=mkdDelimiter start="\\\@<!\["           end="\]\ze\s*[[(]"                    contains=@Spell nextgroup=mkdURL,mkdID skipwhite oneline concealends cchar=→
syntax match mkdInlineURL   /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/
syn region mkdLinkDef       matchgroup=mkdDelimiter start="^ \{,3}\zs\["       end="]:"                              oneline nextgroup=mkdLinkDefTarget skipwhite
syn region mkdLinkDefTarget                         start="<\?\zs\S" excludenl end="\ze[>[:space:]\n]"               contained nextgroup=mkdLinkTitle,mkdLinkDef skipwhite skipnl oneline
syn region mkdLinkTitle     matchgroup=mkdDelimiter start=+"+                  end=+"+                               contained
syn region mkdLinkTitle     matchgroup=mkdDelimiter start=+'+                  end=+'+                               contained
syn region mkdLinkTitle     matchgroup=mkdDelimiter start=+(+                  end=+)+                               contained

"define Markdown groups
syn match  mkdLineContinue     ".$"                                                                                  contained
syn match  mkdLineBreak        /  \+$/
syn region mkdBlockquote       start=/^\s*>/                                  end=/$/                                contains=mkdLineBreak,mkdLineContinue,@Spell
syn region mkdCode             start=/\(\([^\\]\|^\)\\\)\@<!`/                end=/\(\([^\\]\|^\)\\\)\@<!`/
syn region mkdCode             start=/\s*``[^`]*/                             end=/[^`]*``\s*/
syn region mkdCode             start=/^\s*```\s*[0-9A-Za-z_-]*\s*$/           end=/^\s*```\s*$/
syn region mkdCode             start="<pre[^>]*>"                             end="</pre>"
syn region mkdCode             start="<code[^>]*>"                            end="</code>"
syn region mkdFootnote         start="\[^"                                    end="\]"
syn match  mkdCode             /^\s*\n\(\(\s\{8,}[^ ]\|\t\t\+[^\t]\).*\n\)\+/
syn match  mkdIndentCode       /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/                                          contained
syn match  mkdListItem         "^\s*[-*+]\s\+"                                                                       contains=mkdListTab
syn match  mkdListItem         "^\s*\d\+\.\s\+"                                                                      contains=mkdListTab
syn match  mkdListTab          "^\s*\*"                                                                              contained contains=mkdListBullet
syn match  mkdListBullet       "\*"                                                                                  contained conceal cchar=•
syn region mkdNonListItemBlock start="\n\(\_^\_$\|\s\{4,}[^ ]\|\t+[^\t]\)\@!" end="^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@=" contains=@mkdNonListItem,@Spell
syn match  mkdRule             /^\s*\*\s\{0,1}\*\s\{0,1}\*$/
syn match  mkdRule             /^\s*-\s\{0,1}-\s\{0,1}-$/
syn match  mkdRule             /^\s*_\s\{0,1}_\s\{0,1}_$/
syn match  mkdRule             /^\s*-\{3,}$/
syn match  mkdRule             /^\s*\*\{3,5}$/

" HTML headings
syn region htmlH1          start="^\s*#"                                      end="\($\|#\+\)" contains=@Spell,mkdHeadingBegin,mkdHeadingEnd
syn region htmlH2          start="^\s*##"                                     end="\($\|#\+\)" contains=@Spell,mkdHeadingBegin,mkdHeadingEnd
syn region htmlH3          start="^\s*###"                                    end="\($\|#\+\)" contains=@Spell,mkdHeadingBegin,mkdHeadingEnd
syn region htmlH4          start="^\s*####"                                   end="\($\|#\+\)" contains=@Spell,mkdHeadingBegin,mkdHeadingEnd
syn region htmlH5          start="^\s*#####"                                  end="\($\|#\+\)" contains=@Spell,mkdHeadingBegin,mkdHeadingEnd
syn region htmlH6          start="^\s*######"                                 end="\($\|#\+\)" contains=@Spell,mkdHeadingBegin,mkdHeadingEnd
syn match  htmlH1          /^.\+\n=\+$/ contains=@Spell
syn match  htmlH2          /^.\+\n-\+$/ contains=@Spell
syn match  mkdHeadingBegin "^\s*#*\s*" contained conceal
syn match  mkdHeadingEnd   "\s*#*\s*$" contained conceal

syn cluster mkdNonListItem contains=htmlItalic,htmlBold,htmlBoldItalic,mkdFootnotes,mkdID,mkdURL,mkdLink,mkdLinkDef,mkdLineBreak,mkdBlockquote,mkdCode,mkdIndentCode,mkdListItem,mkdRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6

" Highlighting for Markdown groups
HtmlHiLink mkdString        String
HtmlHiLink mkdCode          String
HtmlHiLink mkdIndentCode    String
HtmlHiLink mkdFootnote      Comment
HtmlHiLink mkdBlockquote    Comment
HtmlHiLink mkdLineContinue  Comment
HtmlHiLink mkdListItem      Identifier
HtmlHiLink mkdRule          Identifier
HtmlHiLink mkdLineBreak     Todo
HtmlHiLink mkdFootnotes     htmlLink
HtmlHiLink mkdLink          htmlLink
HtmlHiLink mkdURL           htmlString
HtmlHiLink mkdInlineURL     htmlLink
HtmlHiLink mkdID            Identifier
HtmlHiLink mkdLinkDef       mkdID
HtmlHiLink mkdLinkDefTarget mkdURL
HtmlHiLink mkdLinkTitle     htmlString
HtmlHiLink mkdDelimiter     Delimiter

setlocal formatoptions+=r "Automatically insert bullets
setlocal formatoptions-=c "Do not automatically insert bullets when auto-wrapping with text-width
setlocal comments=b:*,b:+,b:- "Accept various markers as bullets
let b:current_syntax = "mkd"
delcommand HtmlHiLink
