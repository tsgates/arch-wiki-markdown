Vimrc
=====

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Vim.        
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Description                                                        |
| -   2 Setup                                                              |
| -   3 Portability                                                        |
| -   4 Vimrc                                                              |
| -   5 Colorscheme                                                        |
+--------------------------------------------------------------------------+

Description
-----------

This is 90% geared for purely
console/terminal/pty/tty/ssh/putty/telnet/tmux/screen users. I've only
just the past couple years started understanding why it was key to learn
vim, in the past I never had the patience for it and preferred nano-like
editors. Now vim is all I use when on linux, it's so much more
productive.. especially with a customized vimrc file.

Setup
-----

I install this as /etc/vimrc if possible. Individual users can use a vim
config file in their home directories.

    ~/.vimrc

    source /etc/vimrc

To install for a single user just save it in their home dir at
/home/username/.vimrc

  

Portability
-----------

For the portability needed to work on many different systems, this
doesn't rely on any plugins other than those built into the default
installation of vim 7.0. It works well on all types of consoles, and
depending on the TERM environment variable (and whether it has the right
term capabilities) it will load 256 color support or not. Usually on a
new system I just scp this right over and it works without any
modifications. But an ongoing Work in progress.

  

Vimrc
-----

    ~/.vimrc or /etc/vimrc

    " Updated: Wed Feb 22 13:25:23 2012 by galileo@galileo



    " For all key mappings like ', .' to reload vimrc
    let maplocalleader=','



    " BACKUPS, SWAPFILES, VIEWDIR, TMPDIR  "{{{1
    " ================================================================================================================================================================

    " SET RUNTIMEPATH {{{3
    if isdirectory(expand("$HOME/.vim"))
    	let $VIMRUNTIME=expand("$HOME/.vim")
    	set runtimepath=$VIMRUNTIME
    endif


    " IF BKDIR IS NOT SET OR EMPTY, SET {{{3
    if $BKDIR == ""
    	let $BKDIR=expand("$HOME/.bk")
    	if !isdirectory(expand("$BKDIR"))
    		call mkdir(expand("$BKDIR"), "p", 0700)
    	endif
    endif


    " MAKE DIRS IF mkdir exists {{{3
    if exists("*mkdir")
    	if !isdirectory(expand("$BKDIR/.vim/viewdir"))|call mkdir(expand("$BKDIR/.vim/viewdir"), "p", 0700)|endif
    	if !isdirectory(expand("$BKDIR/.vim/tmp"))|call mkdir(expand("$BKDIR/.vim/tmp"), "p", 0700)|endif
    	if !isdirectory(expand("$BKDIR/.vim/backups"))|call mkdir(expand("$BKDIR/.vim/backups"), "p", 0700)|endif
    endif


    " SETTINGS USING NEW DIRS {{{3
    let &dir=expand("$BKDIR") . "/.vim"
    let &viewdir=expand("$BKDIR") . "/.vim/viewdir"
    let &backupdir=expand("$BKDIR") . "/.vim/backups"
    "let &verbosefile=expand("$BKDIR") . "/.vim/vim-messages.


    " VIMINFO {{{3
    " COMMENTED OUT {{{4
    "  "       Maximum number of lines saved for each register
    "  %       When included, save and restore the buffer lis
    "  '       Maximum number of previously edited files for which the marks are remembere
    "  /       Maximum number of items in the search pattern history to be saved
    "  :        Maximum number of items in the command-line history
    "  <       Maximum number of lines saved for each register.
    "   @       Maximum number of items in the input-line history
    "  h       Disable the effect of 'hlsearch' when loading the viminfo
    "  n       Name of the viminfo file.  The name must immediately follow the 'n'.  Must be the last oneEnvironment variables are expanded when opening the file, not when setting the option
    "  r       Removable media.  The argument is a string
    "  s       Maximum size of an item in Kbyte
    "   }}}4 COMMENTED OUT
    let &viminfo="%200,'200,/800,h,<500,:500,s150,r/tmp,r" . expand("$BKDIR") . "/.vim/tmp,n" . expand("$BKDIR") ."/.vim/.vinfo"






    " CUSTOM FUNCTIONS "{{{1
    " ================================================================================================================================================================
    if !exists("AskApacheLoaded")
    	let AskApacheLoaded=1


    	" FUNCTION - LastMod {{{3
    	" Warning, this is controlled by an autocmd triggered when closing the file that updates the file (in a great way)
    	" Updated: Wed Feb 22 13:25:23 2012 by galileo@galileo
    	function! LastMod()
    		exe "silent! 1,20s/Updated: .*/" . printf('Updated: %s by %s@%s', strftime("%c"), expand("$LOGNAME"), hostname()) . "/e"
    	endfunction


    	" FUNCTION - LastModNow {{{3
    	" An even better version than LastMod()
    	function! LastModNow()
    		call setline(line('.'), printf('%sUpdated: %s by %s@%s', printf(&commentstring, ' '), strftime("%c"), expand("$LOGNAME"), hostname()))
    		"printf('%sUpdated: %s by %s@%s', printf(&commentstring, ' '), strftime("%c"), expand("$LOGNAME"), hostname())\|dd\|j\|dd<CR><ESC>
    		"printf('Updated: %s by %s %s', strftime("%c"), expand("$LOGNAME@$HOSTNAME")) ."/e"
    	endfunction


    	" FUNCTION - AppendModeline {{{3
    	" Append modeline after last line in buffer.  Use substitute() instead of printf() to handle '%%s' modeline
    	function! AppendModeline()
    		let l:modeline = printf(" vim: set ft=%s ts=%d sw=%d tw=%d foldmethod=%s :", &filetype, &tabstop, &shiftwidth, &textwidth, &foldmethod)
    		let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    		call append(line("$"), l:modeline)
    	endfunction


    	" FUNCTION - LastModAAZZZ {{{3
    	" AA_UPDATED='01/24/12-00:56:00'
    	function! LastModAAZZZ()
    		exe "1,50s/AA_UPDATED=.*/AA_UPDATED='" . strftime("%c") . "'"
    	endfunction


    	" FUNCTION - StripTrailingWhitespace {{{3
    	" automatically remove trailing whitespace before write
    	function! StripTrailingWhitespace()
    		normal mZ
    		%s/\s\+$//e
    		if line("'Z") != line(".")|echo "Stripped whitespace\n"|endif
    		normal `Z
    	endfunction


    	" FUNCTION - MyTabL {{{3
    	function! MyTabL()
    		let s = ''|let t = tabpagenr()|let i = 1
    		while i <= tabpagenr('$')
    			let bl = tabpagebuflist(i)|let wn = tabpagewinnr(i)
    			let s .= '%' . i . 'T'. (i == t ? '%1*' : '%2*') . '%*' . (i == t ? ' %#TabLineSel# ' : '%#TabLine#')
    			let file = (i == t ? fnamemodify(bufname(bl[wn - 1]), ':p') : fnamemodify(bufname(bl[wn - 1]), ':t') )|if file == ''|let file = '[No Name]'|endif
    			let s .= i.' '. file .(i == t ? ' ' : '')|let i += 1
    		endwhile
    		let s .= '%T%#TabLineFill#%=' . (tabpagenr('$') > 1 ? '%999XX' : 'X')
    		return s
    	endfunction


    	" FUNCTION - DiffWithSaved {{{3
    	" Diff with saved version of the file
    	function! s:DiffWithSaved()
    		let filetype=&ft
    		diffthis
    		vnew | r # | normal! 1Gdd
    		diffthis
    		exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
    	endfunction
    	com! DiffSaved call s:DiffWithSaved()


    	" FUNCTION - ShowWhitespace() {{{3
    	function! ShowWhitespace(flags)
    		let bad = ''
    		let pat = []
    		for c in split(a:flags, '\zs')
    			if c == 'e'
    				call add(pat, '\s\+$')
    			elseif c == 'i'
    				call add(pat, '^\t*\zs \+')
    			elseif c == 's'
    				call add(pat, ' \+\ze\t')
    			elseif c == 't'
    				call add(pat, '[^\t]\zs\t\+')
    			else
    				let bad .= c
    			endif
    		endfor

    		if len(pat) > 0
    			let s = join(pat, '\|')
    			exec 'syntax match ExtraWhitespace "'.s.'" containedin=ALL'
    		else
    			syntax clear ExtraWhitespace
    		endif

    		if len(bad) > 0|echo 'ShowWhitespace ignored: '.bad|endif
    	endfunction



    	" FUNCTION - ToggleShowWhitespace {{{3
    	" I use this all the time, it's mapped to , ts
    	function! ToggleShowWhitespace()
    		if !exists('b:ws_show')|let b:ws_show = 0|endif
    		if !exists('b:ws_flags')|let b:ws_flags = 'est'|endif
    		let b:ws_show = !b:ws_show
    		if b:ws_show|call ShowWhitespace(b:ws_flags)|else|call ShowWhitespace('')|endif
    	endfunction

    endif








    " DYNAMIC SETTINGS / COLORS / TERMINAL {{{1
    " ================================================================================================================================================================

    " DISABLE MOUSE NO GOOEYS {{{3
    if has('mouse')|set mouse=|endif

    " SET TITLESTRING {{{3
    if has('title')|set titlestring=%t%(\ [%R%M]%)|endif

    " SET TABLINE {{{3
    if exists("*s:MyTabL")|set tabline=%!MyTabL()|endif

    let g:vimsyn_folding='af'

    "DISABLE FILETYPE-SPECIFIC MAPS {{{3
    let no_plugin_maps=1


    "}}}1 DYNAMIC SETTINGS / COLORS / TERMINAL






    " OPTIONS "{{{1
    " ===========================================================================================================================================================================


    " BACKUP, FILE OPTIONS {{{2
    " ================================================================================
    set backup			  " Make a backup before overwriting a file.  Leave it around after the file has been successfully written.
    set backupcopy=auto " When writing a file and a backup is made, this option tells how it's done.  This is a comma separated list of words. - value: yes,no,auto - no:rename the file and write a new one

    set swapfile
    set swapsync=fsync

    "}}}2 BACKUP, FILE OPTIONS


    " BASIC SETTINGS "{{{2
    " ================================================================================
    set nocompatible		" vim, not vi.. must be first, because it changes other options as a side effect
    set modeline

    set statusline=%M%h%y\ %t\ %F\ %p%%\ %l/%L\ %=[%{&ff},%{&ft}]\ [a=\%03.3b]\ [h=\%02.2B]\ [%l,%v]
    set title titlelen=150 titlestring=%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

    "set tags=tags;/			" search recursively up for tags

    set ttyfast				" we have a fast terminal
    set scrolljump=5	  " when scrolling up down, show at least 5 lines
    "set ttyscroll=999	  " make vim redraw screen instead of scrolling when there are more than 3 lines to be scrolled

    "set tw=500				" default textwidth is a max of 5

    set undolevels=10		" 50 undos - saved in memory
    set updatecount=250		" switch every 250 chars, save swap

    set whichwrap+=b,s,<,>,h,l,[,]			" backspaces and cursor keys wrap to
    "set wildignore+=*.o,*~,.lo,*.exe,*.bak	" ignore object files
    "set wildmenu							" menu has tab completion
    "set wildmode=longest:full				" *wild* mode
    set nowrap

    set autoindent smartindent		" auto/smart indent

    set autoread					" watch for file changes

    set backspace=indent,eol,start	" backspace over all kinds of things

    set cmdheight=1					" command line two lines high
    set complete=.,w,b,u,U,t,i,d	" do lots of scanning on tab completion
    set cursorline					" show the cursor line
    "set enc=utf-8 fenc=utf-8		" utf-8

    set history=3000				" keep 3000 lines of command line history

    set keywordprg=TERM=mostlike\ man\ -s\ -Pless

    set laststatus=2

    "set lazyredraw					" don't redraw when don't have to
    set linebreak					" wrap at 'breakat' instead of last char
    set magic						" Enable the "magic"

    set maxmem=25123	" 24 MB -  max mem in Kbyte to use for one buffer.  Max is 2000000

    set noautowrite					" don't automagically write on :next

    set noexpandtab					" no expand tabs to spaces"
    set noruler					" show the line number on the bar
    set nospell
    set nohidden					" close the buffer when I close a tab (I use tabs more than buffers)

    set noerrorbells visualbell t_vb= " Disable ALL bells

    set number					" line numbers

    set pastetoggle=<F11>

    set scrolloff=3				" keep at least 3 lines above/below
    set shiftwidth=3			" shift width

    set showcmd					" Show us the command we're typing
    set showfulltag				" show full completion tags
    set showmode				" show the mode all the time

    set sidescroll=2			" if wrap is off, this is fasster for horizontal scrolling
    set sidescrolloff=2			"keep at least 5 lines left/right

    set noguipty

    set splitright
    set splitbelow

    set restorescreen=on " restore screen contents when vim exits -  disable withset t_ti= t_te=

    "set sessionoptions=word,blank,buffers,curdir,folds,globals,help,localoptions,resize,sesdir,tabpages,winpos,winsize
    set winheight=25
    set winminheight=1	" minimal value for window height
    "set winheight=30	" set the minimal window height
    set equalalways		" all the windows are automatically sized same
    set eadirection=both	" only equalalways for horizontally split windows

    set hlsearch

    set laststatus=2

    set tabstop=4
    set softtabstop=4

    set shiftwidth=3
    set switchbuf=usetab

    set commentstring=#%s

    set tabpagemax=55
    set showtabline=2		" 2 always, 1 only if multiple tabs
    set smarttab			" tab and backspace are smart

    set foldmethod=marker
    set foldenable
    set foldcolumn=6				" the blank left-most bar left of the numbered lines


    set incsearch					" incremental search
    "set ignorecase					" search ignoring case
    set sc							" override 'ignorecase' when pattern has upper case characters
    set smartcase					" Ignore case when searching lowercase

    set showmatch					" show matching bracket
    set diffopt=filler,iwhite		" ignore all whitespace and sync"
    set stal=2


    "}}}1 OPTIONS










    " PLUGIN SETTINGS {{{1
    " ================================================================================================================================================================
    " Settings for :TOhtml "{{{3
    let html_number_lines=1
    let html_use_css=1
    let use_xhtml=1
    "}}}1 PLUGIN SETTINGS




    " COLORSCHEME IF MORE THAN 2 COLORS lol {{{1
    " ================================================================================================================================================================
    if &t_Co > 2

    	if &term =~ "256"

    		set bg=dark t_Co=256 vb
    		let &t_vb="\<Esc>[?5h\<Esc>[?5l"	" flash screen for visual bell

    		if filereadable(expand("$VIMRUNTIME/colors/askapachecode.vim"))
    			colorscheme askapachecode
    		elseif filereadable(expand("$HOME/.vim/colors/askapachecode.vim"))
    			colorscheme askapachecode
    		else
    			colorscheme default
    		endif

    		filetype indent plugin on
    		syntax on

    	else
    		" things like cfdisk, crontab -e, visudo, vless, etc.
    		set term=linux
    		set t_Co=8
    		syntax off
    		filetype indent plugin off

    	endif

    endif

    "}}}1








    " AUTOCOMMANDS "{{{1
    " ===========================================================================================================================================================================
    "if !exists(":DiffOrig") | command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis | endif

    " auto load extensions for different file types
    if has('autocmd')

    	if !exists("autocommands_loaded")
    		let autocommands_loaded = 1

    		" JUMP TO LAST POS {{{3
    		" When editing a file, always jump to the last known cursor position. Don't do it when the position is invalid or when inside an event handler
    		" (happens when dropping a file on gvim). Also don't do it when the mark is in the first line, that is the default position when opening a file.
    		au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


    		" CLEARMATCHES ON BUFWINLEAVE {{{3
    		au BufWinLeave * call clearmatches()


    		" STRIP TRAILING WHITESPACE {{{3
    		autocmd BufWritePre *.cpp,*.hpp,*.i :call StripTrailingWhitespace()


    		" AA_ZZZ LAST MOD {{{3
    		autocmd BufWritePre,FileWritePre,TabLeave zzz_askapache-bash.sh ks|call LastModAAZZZ()|'s


    		" SET VIM SETTINGS FOR AA_ZZZ SCRIPTS {{{3
    		autocmd BufRead /etc/ZZZ/*.sh,.bash_profile,.bash_login,.bashrc,.bash_login_user,.bash_logout setlocal ts=4 sw=3 ft=sh foldmethod=marker tw=500 foldcolumn=7


    		" INSERT CURRENT DATE AND TIME IN A *.SH FILE WHEN WRITING IT {{{3
    		autocmd BufWritePre,FileWritePre *.*   ks|call LastMod()|'s


    		" IMPROVE LEGIBILITY {{{3
    		autocmd BufRead quickfix setlocal nobuflisted wrap number


    		" SAVE BACKUPFILE AS BACKUPDIR/FILENAME-06-13-1331 {{{3
    		autocmd BufWritePre * let &bex = strftime("-%m-%d-%H%M")


    		" TMUX FILETYPE {{{3
    		autocmd BufRead tmux.conf,.tmux.conf,.tmux*,*/tmux-sessions/* setlocal filetype=tmux foldmethod=marker


    		" APACHE2 FILETYPE {{{3
    		autocmd BufRead /opt/a*/conf/*,/etc/httpd/*.conf setlocal filetype=apache


    		" SH FILETYPES {{{3
    		autocmd BufRead *.sh,*.cron,*.bash setlocal filetype=sh


    		" SYSLOG-NG FILETYPE {{{3
    		autocmd BufRead syslog-ng.conf setlocal filetype=syslog-ng


    		" COMMENTSTRING FOR VIM "{{{3
    		au FileType vim setlocal commentstring="%s


    		" COMMENTSTRING FOR XDEFAULTS "{{{3
    		au FileType xdefaults setlocal foldmethod=marker foldlevel=2 commentstring=!%s


    		" VIMRC {{{3
    		augroup vimrc
    			au BufReadPre * setlocal foldmethod=indent
    			au BufWinEnter * if &fdm == 'indent' | set foldmethod=manual | endif
    			au BufRead *.vim,vimrc,*.vimrc set filetype=vim ts=3 sw=3 tw=500 foldmethod=marker foldcolumn=6
    		augroup END

    		" AUTOMKVIEWS {{{3
    		" Warning - this will save your settings for each file you edit and restore those settings when opened again - can fill up quick
    		au BufWinLeave *.sh,*.conf,*.vim,*.c,*.txt,.htaccess,*.cgi,*.php,*.html,*.conf,vimrc mkview
    		au BufWinEnter *.sh,*.conf,*.vim,*.c,*.txt,.htaccess,*.cgi,*.php,*.html,*.conf,vimrc silent loadview
    		" }}}3

    		" MAN RUNTIME - TODO REPLACE WITH TMUXES CTRL-M BINDING {{{3
    		" Lets you type :Man anymanpage and it will load in vim, color-coded and searchable
    		"runtime ftplugin/man.vim

    	endif

    endif
    "}}}1







    " MAPS "{{{1
    " ===========================================================================================================================================================================


    " FUNCTION MAPS {{{2
    " ---------------------------------
    " APPEND MODELINE {{{3
    map <silent> <LocalLeader>ml :call AppendModeline()<CR>


    " SHOW WHITESPACE {{{3
    nnoremap <LocalLeader>ts :call ToggleShowWhitespace()<CR>


    " SUDO A WRITE {{{3
    command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
    "cmap w!! %!sudo tee > /dev/null %
    " :w !sudo tee > /dev/null %


    " SET TABLINE {{{3
    " My Personal Fav, inserts last-modified manually on current line when you press <F12> key
    " call setline(1, printf('%sUpdated: %s by %s@%s', printf(&commentstring, ' '), strftime("%c"), expand("$LOGNAME"), hostname()))
    if exists("*s:LastModNow")
    	map <silent> <F12> :call LastModNow()<CR>
    endif


    " RELOAD VIMRC FILES {{{3
    map <LocalLeader>. :mkview<CR>:unlet! AskApacheLoaded autocommands_loaded<CR>:mapclear<CR>:source /etc/vimrc<CR>:echoerr 'VIMRC RELOADED'<CR>


    " SCROLLING MAPS {{{3
    map <PageDown> :set scroll=0<CR>:set scroll^=2<CR>:set scroll-=1<CR><C-D>:set scroll=0<CR>
    map <PageUp> :set scroll=0<CR>:set scroll^=2<CR>:set scroll-=1<CR><C-U>:set scroll=0<CR>
    nnoremap <silent> <PageUp> <C-U><C-U>
    vnoremap <silent> <PageUp> <C-U><C-U>
    inoremap <silent> <PageUp> <C-\><C-O><C-U><C-\><C-O><C-U>
    nnoremap <silent> <PageDown> <C-D><C-D>
    vnoremap <silent> <PageDown> <C-D><C-D>
    inoremap <silent> <PageDown> <C-\><C-O><C-D><C-\><C-O><C-D>
    "}}}3





    " KEY MAPS {{{2
    " physically map keys to produce different key, type CTRL-V in insert mode followed by any key to see how vim sees it
    " ----------------------------------------
    imap <ESC>[8~ <End>
    map <ESC>[8~ <End>

    imap <ESC>[7~ <Home>
    map <ESC>[7~ <Home>





    " Basic Maps  {{{2
    " ----------------------------------------
    " TOGGLE PASTE MODE {{{3
    map <LocalLeader>pm :set nonumber! foldcolumn=0<CR>

    " REINDENT FILE {{{3
    map <LocalLeader>ri G=gg<CR>

    " CLEAR SPACES AT END OF LINE {{{3
    map <LocalLeader>cs :%s/\s\+$//e<CR>

    " Y YANKS FROM CURSOR TO $ {{{3
    map Y y$

    " DON'T USE EX MODE, USE Q FOR FORMATTING {{{3
    map Q gq
    map! ^H ^?

    " NEXT SEARCH RESULT {{{3
    map <silent> <LocalLeader>cn :cn<CR>

    " WRAP? {{{3
    map <silent> <LocalLeader>ww :ww

    " ERR INSERTION {{{3
    "map <silent> <LocalLeader>e <Home>A<C-R>=printf('%s', '_err "$0 $FUNCNAME:$LINENO FAILED WITH ARGS= $*"')<CR><Home><Esc>

    " CUSTOM LINES FOR CODING {{{3
    map <silent> <LocalLeader>l1 <Home>A<C-R>=printf('%s%s', printf(&commentstring, ' '), repeat('=', 160))<CR><Home><Esc>
    map <silent> <LocalLeader>l2 <Home>A<C-R>=printf('%s%s', printf(&commentstring, ' '), repeat('=', 80))<CR><Home><Esc>
    map <silent> <LocalLeader>l3 <Home>A<C-R>=printf('%s%s', printf(&commentstring, ' '), repeat('-', 40))<CR><Home><Esc>
    map <silent> <LocalLeader>l4 <Home>A<C-R>=printf('%s%s', printf(&commentstring, ' '), repeat('-', 20))<CR><Home><Esc>

    " CHANGE DIRECTORY TO THAT OF CURRENT FILE {{{3
    nmap <LocalLeader>cd :cd%:p:h<CR>

    " CHANGE LOCAL DIRECTORY TO THAT OF CURRENT FILE {{{3
    nmap <LocalLeader>lcd :lcd%:p:h<CR>

    " TOGGLE WRAPPING {{{3
    nmap <LocalLeader>ww :set wrap!<CR>
    nmap <LocalLeader>wo :set wrap<CR>



    " TABS "{{{2
    " ---------------------------------

    " CREATE A NEW TAB {{{3
    map <LocalLeader>tc :tabnew %<CR>

    " LAST TAB {{{3
    map <LocalLeader>t<Space> :tablast<CR>

    " CLOSE A TAB {{{3
    map <LocalLeader>tk :tabclose<CR>

    " NEXT TAB {{{3
    map <LocalLeader>tn :tabnext<CR>

    " PREVIOUS TAB {{{3
    map <LocalLeader>tp :tabprev<CR>




    " FOLDS	 "{{{2
    " ---------------------------------
    " Fold with paren begin/end matching
    nmap F zf%

    " When I use ,sf - return to syntax folding with a big foldcolumn
    nmap <LocalLeader>sf :set foldcolumn=6 foldmethod=syntax<cr>
    "}}}2

    "}}}1





    " HILITE "{{{1
    " ===========================================================================================================================================================================
    hi NonText cterm=NONE ctermfg=NONE
    hi Search cterm=bold ctermbg=99 ctermfg=17
    "}}}









    " COMMENTED OUT {{{1
    " comments down at bottom of file so it doesn't slow down vim parsing and loading
    " ================================================================================================================================================================
    "Commented Out "{{{4
    " Whitespace Highlighting
    "au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
    "au InsertLeave * redraw!
    "highlight ExtraWhitespace ctermbg=red guibg=red
    "match ExtraWhitespace /\s\+$/
    "autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    "autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    "autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    "autocmd BufWinLeave * call clearmatches()

    " Show leading whitespace that includes spaces, and trailing whitespace.
    "au BufWinEnter * match ExtraWhitespace /^\s* \s*\|\s\+$/
    "au BufWinEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    "au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    "au InsertLeave * match ExtraWhitespace /\s\+$/

    " Convenient command to see the difference between the current buffer and the
    " file it was loaded from, thus the changes you made.  Only define it when not defined already.
    "if !exists(":DiffOrig") | command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis | endif
    "au BufRead httpd.conf set filetype=apache		" for htaccess files set filetype to apache
    "}}}4

    " COMMENTED OUT MAPS {{{6
    "map <C-S-]> gt
    "map <C-S-[> gT
    "map <C-1> 1gt
    "map <C-2> 2gt
    "map <C-3> 3gt
    "map <C-4> 4gt
    "map <C-5> 5gt
    "map <C-6> 6gt
    "map <C-7> 7gt
    "map <C-8> 8gt
    "map <C-9> 9gt
    "map <C-0> :tablast<CR>

    " correct type-o's on exit
    " nmap q: :q

    " save and build
    " nmap <LocalLeader>wm  :w<cr>:make<cr>
    " Also map user-defined omnicompletion as Ctrl+k
    "inoremap <C-k> <C-x><C-u>

    " Y yanks from cursor to $
    "map Y y$


    " for yankring to work with previous mapping:
    "function! YRRunAfterMaps()
    "   nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
    "endfunction

    " toggle list mode
    "nmap <LocalLeader>tl :set list!<cr>

    " toggle paste mode
    "nmap <LocalLeader>pm :set paste!<cr>

    " toggle wrapping
    "nmap <LocalLeader>ww :set wrap!<cr>

    " change directory to that of current file
    "nmap <LocalLeader>cd :cd%:p:h<cr>

    " change local directory to that of current file
    "nmap <LocalLeader>lcd :lcd%:p:h<cr>

    " correct type-o's on exit
    "nmap q: :q

    " save and build
    "nmap <LocalLeader>wm  :w<cr>:make<cr>

    " open all folds
    "nmap <LocalLeader>o  :%foldopen!<cr>

    " close all folds
    "nmap <LocalLeader>c  :%foldclose!<cr>

    " ,tt will toggle taglist on and off
    "nmap <LocalLeader>tt :Tlist<cr>

    " ,nn will toggle NERDTree on and off
    "nmap <LocalLeader>n :NERDTreeToggle<cr>

    " When I'm pretty sure that the first suggestion is correct
    "map <LocalLeader>st 1z=

    " q: sucks
    "nmap q: :q

    " Fix the # at the start of the line
    "inoremap # X<BS>#

    " Fold with paren begin/end matching
    "nmap F zf%

    " When I use ,sf - return to syntax folding with a big foldcolumn
    "nmap <LocalLeader>sf :set foldcolumn=6 foldmethod=syntax<cr>

    "}}}6




    " Commented out maps "{{{4
    " ---------------------------------

    "" fm	- (zm)  more folds
    " noremap <LocalLeader>fm zm

    " fl  - (zr) less/reduce folds
    " noremap <LocalLeader>fl zr

    " fc	- close all folds (zM)
    " noremap <LocalLeader>fc zM

    " fo	- open all folds (zR)
    " noremap <LocalLeader>fo zR

    " ff  -  (zf)	- create a fold
    " noremap <LocalLeader>ff zf
    " fd	- (zd)	- delete fold at cursor
    " noremap <LocalLeader>fd zd
    "}}}4
    " # REMOVING AUTOCOMMANDS {{{6
    " :au[tocmd] [group] {event} {pat} [nested] {cmd}
    " Remove all autocommands associated with {event} and {pat}, and add the command {cmd}.
    " :au[tocmd]! [group] {event} {pat} [nested] {cmd}

    " Remove all autocommands associated with {event} and {pat}.
    " :au[tocmd]! [group] {event} {pat}

    " Remove all autocommands associated with {pat} for all events.
    " :au[tocmd]! [group] * {pat}

    " Remove ALL autocommands for {event}.
    " :au[tocmd]! [group] {event}

    " Remove ALL autocommands.
    " :au[tocmd]! [group]   }}}6
    "}}}1 ENDOF COMMENTED OUT




    " VIM TIPS / HELP / TRICKS   {{{1
    " ================================================================================================================================================================

    " BEST TRICKS {{{2

    " TERMCAP HELP {{{3
    " :help termcap

    " :g/^\s*$/;//-1sort to sort each block of lines in a file.


    " VIEW DIFF OF EDITS AGAINST BUFFER VS ORIGINAL FILE {{{3
    " :w !colordiff -u % -


    " INSERT CURRENT FILENAME {{{3
    " :r! echo %

    " DELETE TRAILING WHITESPACE {{{3
    " :%s/\s\+$//

    " Changing Case
    " guu                             : lowercase line
    " gUU                             : uppercase line
    " Vu                              : lowercase line
    " VU                              : uppercase line
    " g~~                             : flip case line
    " vEU                             : Upper Case Word
    " vE~                             : Flip Case Word
    " ggguG                           : lowercase entire file
    " " Titlise Visually Selected Text (map for .vimrc)
    " vmap ,c :s/\<\(.\)\(\k*\)\>/\u\1\L\2/g<CR>
    " " Title Case A Line Or Selection (better)
    " vnoremap <F6> :s/\%V\<\(\w\)\(\w*\)\>/\u\1\L\2/ge<cr> [N]
    " " titlise a line
    " nmap ,t :s/.*/\L&/<bar>:s/\<./\u&/g<cr>  [N]
    " " Uppercase first letter of sentences
    " :%s/[.!?]\_s\+\a/\U&\E/g


    " :r file " read text from file and insert below current line

    " :so $VIMRUNTIME/syntax/hitest.vim	  " view highlight options

    "}}}2


    " HELP HELP {{{3
    " ---------------------------------
    " :helpg pattern					  search grep!! ---  JUMP TO OTHER MATCHES WITH: >
    " :help holy-grail
    " :help all
    " :help termcap
    "  :help user-toc.txt          Table of contents of the User Manual. >
    "  :help :subject              Ex-command "subject", for instance the following: >
    "  :help :help                 Help on getting help. >
    "  :help CTRL-B                Control key <C-B> in Normal mode. >
    "  :help 'subject'             Option 'subject'. >
    "  :help EventName             Autocommand event "EventName"
    "  :help pattern<Tab>          Find a help tag starting with "pattern".  Repeat <Tab> for others. >
    "  :help pattern<Ctrl-D>       See all possible help tag matches "pattern" at once. >
    "		  :cn                         next match >
    "		  :cprev, :cN                 previous match >
    "		  :cfirst, :clast             first or last match >
    "		  :copen,  :cclose            open/close the quickfix window; press <Enter> to jump to the item under the cursor



    " SET HELP {{{3
    " ---------------------------------
    " :verbose set opt? - show where opt was set
    " set opt!		- invert
    " set invopt		- invert
    " set opt&		- reset to default
    " set all&		- set all to def
    " :se[t]			Show all options that differ from their default value.
    " :se[t] all		Show all but terminal options.
    " :se[t] termcap		Show all terminal options.  Note that in the GUI the



    " TAB HELP   {{{3
    " ---------------------------------
    " tc	- create a new tab
    " td	- close a tab
    " tn	- next tab
    " tp	- previous tab



    " UPPERCASE, LOWERCASE, INDENTS {{{3
    " ---------------------------------
    " '.	- last modification in file!
    " gf  - open file under cursor
    " guu - lowercase line
    " gUU - uppercase line
    " =   - reindent text



    " FOLDS {{{3
    " ---------------------------------
    " F 	- create a fold from matching parenthesis
    " fm	- (zm)  more folds
    " fl  - (zr) less/reduce folds
    " fo	- open all folds (zR)
    " fc	- close all folds (zM)
    " ff  -  (zf)	- create a fold
    " fd	- (zd)	- delete fold at cursor
    " zF	- create a fold N lines
    " zi	- invert foldenable



    " KEYSEQS HELP {{{3
    " ---------------------------------
    " CTRL-I - forward trace of changes
    " CTRL-O - backward trace of changes!
    " C-W W	 - Switch to other split window
    " CTRL-U		  - DELETE FROM CURSOR TO START OF LINE
    " CTRL-^		  - SWITCH BETWEEN FILES
    " CTRL-W-TAB  - CREATE DUPLICATE WINDOW
    " CTRL-N		  - Find keyword for word in front of cursor
    " CTRL-P		  - Find PREV diddo


    " SEARCH / REPLACE {{{3
    " ---------------------------------
    " :%s/\s\+$//    - delete trailing whitespace
    " :%s/a\|b/xxx\0xxx/g             modifies a b      to xxxaxxxbxxx
    " :%s/\([abc]\)\([efg]\)/\2\1/g   modifies af fa bg to fa fa gb
    " :%s/abcde/abc^Mde/              modifies abcde    to abc, de (two lines)
    " :%s/$/\^M/                      modifies abcde    to abcde^M
    " :%s/\w\+/\u\0/g                 modifies bla bla  to Bla Bla
    " :g!/\S/d				delete empty lines in file


    "  COMMANDS {{{3
    " ---------------------------------
    " :runtime! plugin/**/*.vim  - load plugins
    " :so $VIMRUNTIME/syntax/hitest.vim	  " view highlight options
    " :so $VIMRUNTIME/syntax/colortest.vim

    " :!!date - insert date
    " :%!sort -u  - only show uniq (and sort)

    " :r file " read text from file and insert below current line
    " :v/./.,/./-1join  - join empty lines

    " :e! return to unmodified file
    " :tabm n  - move tab to pos n
    " :jumps
    " :history
    " :reg   -  list registers

    " delete empty lines
    " global /^ *$/ delete





    " MISC EXAMPLES {{{3
    " ---------------------------------
    "f &term =~ "xterm"| f has("terminfo")set t_Co=8 t_Sf=<Esc>[3%p1%dm t_Sb=<Esc>[4%p1%dm  els  set t_Co=8 t_Sf=<Esc>[3%dm t_Sb=<Esc>[4%dm
    "set t_AB=<Esc>[%?%p1%{8}%<%t25;%p1%{40}%+%e5;%p1%{32}%+%;%dm t_AF=<Esc>[%?%p1%{8}%<%t22;%p1%{30}%+%e1;%p1%{22}%+%;%dm
    " }}}3

    "}}}1 ENDOF VIM TIPS / HELP / TRICKS

Colorscheme
-----------

Here is a colorscheme file optimized for 256 colors. It will work if
saved in ~/.vim/colors/askapachecode.vim or likewise in your
runtimepath. Additionally, you could just paste it in the bottom of the
above vimrc.

The code really needs to be cleaned up, but it looks awesome.

    ~/.vim/colors/askapachecode.vim

    " Vim color file -- askapachecode
    " Maintainer: AskApache <webmaster@askapache.com>
    " Updated: Wed Feb 22 14:10:54 2012 by galileo@galileo

    set background=dark
    hi clear

    if exists("syntax_on")|syntax reset|endif

    let g:colors_name="askapachecode"

    " Vim >= 7.0 specific colors
    if version >= 700
     hi CursorLine ctermbg=236
     hi CursorColumn ctermbg=236
     hi MatchParen ctermfg=157 ctermbg=237 cterm=bold
     hi Pmenu ctermfg=255 ctermbg=238
     hi PmenuSel ctermfg=0 ctermbg=148
    endif

    " General colors
    hi Cursor ctermbg=241
    hi Normal ctermfg=253 ctermbg=232
    hi NonText ctermfg=244 ctermbg=235
    hi LineNr ctermfg=244 ctermbg=232
    hi StatusLine ctermfg=253 ctermbg=238 cterm=italic
    hi StatusLineNC ctermfg=246 ctermbg=238
    hi VertSplit ctermfg=238 ctermbg=238
    hi Folded ctermbg=4 ctermfg=248
    hi Title ctermfg=254 cterm=bold
    hi Visual ctermfg=254 ctermbg=4
    hi SpecialKey ctermfg=244 ctermbg=236

    hi pythonOperator ctermfg=103

    hi Search cterm=NONE	




    " basic highlight groups (:help highlight-groups) {{{1

    " text {{{2
    hi Normal ctermfg=white ctermbg=black cterm=NONE
    hi Folded ctermfg=lightgray ctermbg=black cterm=underline
    hi LineNr ctermfg=darkgray ctermbg=NONE cterm=NONE
    hi Directory ctermfg=cyan ctermbg=NONE cterm=NONE
    hi NonText ctermfg=yellow ctermbg=NONE cterm=NONE
    hi SpecialKey ctermfg=green ctermbg=NONE cterm=NONE

    hi DiffAdd ctermfg=white ctermbg=darkblue cterm=NONE
    hi DiffChange ctermfg=black ctermbg=darkmagenta cterm=NONE
    hi DiffDelete ctermfg=black ctermbg=red cterm=bold
    hi DiffText ctermfg=white ctermbg=green cterm=bold


    " borders / separators / menus {{{2
    hi FoldColumn ctermfg=lightgray ctermbg=darkgray cterm=NONE
    hi SignColumn ctermfg=lightgray ctermbg=darkgray cterm=NONE
    hi Pmenu ctermfg=white ctermbg=darkgray cterm=NONE
    hi PmenuSel ctermfg=white ctermbg=lightblue cterm=NONE
    hi PmenuSbar ctermfg=black ctermbg=black cterm=NONE
    hi PmenuThumb ctermfg=gray ctermbg=gray cterm=NONE

    hi StatusLine ctermfg=black ctermbg=white cterm=bold
    hi StatusLineNC ctermfg=darkgray ctermbg=white cterm=NONE
    hi WildMenu ctermfg=white ctermbg=darkblue cterm=bold
    hi VertSplit ctermfg=white ctermbg=white cterm=NONE

    if &t_Co == 256|hi TabLine ctermfg=15 ctermbg=242 term=underline|else|hi TabLine ctermfg=grey ctermbg=white term=underline|endif
    "hi TabLine ctermfg=white ctermbg=white cterm=NONE
    hi TabLineFill ctermfg=grey ctermbg=white cterm=NONE
    "hi TabLineSel ctermfg=black ctermbg=green cterm=NONE
    hi TabLineSel ctermfg=green ctermbg=black term=bold
    "hi TabLineSel term=bold cterm=bold
    "hi TabLineFill term=reverse cterm=reverse 
    "hi TabLine term=underline cterm=underline ctermfg=15 ctermbg=242

    "hi Menu
    "hi Scrollbar
    "hi Tooltip


    " cursor / dynamic / other {{{2
    hi Cursor ctermfg=black ctermbg=white cterm=NONE
    hi CursorIM ctermfg=black ctermbg=white cterm=reverse
    hi CursorLine ctermfg=NONE ctermbg=NONE cterm=NONE
    hi CursorColumn ctermfg=NONE ctermbg=NONE cterm=NONE

    hi Visual ctermfg=white ctermbg=lightblue cterm=NONE
    hi IncSearch ctermfg=white ctermbg=yellow cterm=NONE
    hi Search ctermfg=white ctermbg=darkgreen cterm=NONE


    " LISTINGS / MESSAGES {{{2
    hi ModeMsg ctermfg=yellow ctermbg=NONE cterm=NONE
    hi Title ctermfg=red ctermbg=NONE cterm=bold
    hi Question ctermfg=green ctermbg=NONE cterm=NONE
    hi MoreMsg ctermfg=green ctermbg=NONE cterm=NONE
    hi ErrorMsg ctermfg=white ctermbg=red cterm=bold
    hi WarningMsg ctermfg=yellow ctermbg=NONE cterm=bold

    hi Directory term=bold ctermfg=4 "{{{
    hi ErrorMsg term=standout ctermfg=15 ctermbg=1  
    hi IncSearch term=reverse cterm=reverse 
    hi Search term=NONE ctermfg=255 ctermbg=135
    hi MoreMsg term=bold ctermfg=2  
    hi ModeMsg term=bold cterm=bold 
    hi LineNr term=underline ctermfg=244 ctermbg=232  
    hi Question term=standout ctermfg=2  
    hi StatusLine term=bold,reverse cterm=italic ctermfg=253 ctermbg=238   
    hi StatusLineNC term=reverse cterm=reverse ctermfg=246 ctermbg=238  
    hi VertSplit term=reverse cterm=reverse ctermfg=238 ctermbg=238  
    hi Title term=bold cterm=bold ctermfg=254  
    hi Visual term=reverse ctermfg=254 ctermbg=4  
    hi VisualNOS term=bold,underline cterm=bold,underline
    hi WarningMsg term=standout ctermfg=1 
    hi WildMenu term=standout ctermfg=0 ctermbg=11  
    hi Folded term=standout cterm=BOLD ctermfg=7 ctermbg=27
    hi FoldColumn term=NONE cterm=NONE ctermfg=75 ctermbg=16
    hi IncSearch term=bold,underline cterm=bold,underline ctermfg=7 ctermbg=9
    hi DiffAdd term=bold ctermbg=12 
    hi DiffChange term=bold ctermbg=13 
    hi DiffDelete term=bold ctermfg=12 ctermbg=14   
    hi DiffText term=reverse cterm=bold ctermbg=9  
    hi SpellBad term=reverse ctermbg=9  
    hi SpellCap term=reverse ctermbg=12  
    hi SpellRare term=reverse ctermbg=13  
    hi SpellLocal term=underline ctermbg=14  
    hi Pmenu ctermfg=255 ctermbg=238  
    hi PmenuSel ctermfg=0 ctermbg=148  
    hi PmenuSbar ctermbg=7 
    hi PmenuThumb cterm=reverse 
    hi TabLine term=underline cterm=underline ctermfg=0 ctermbg=7  
    hi TabLineSel term=bold cterm=bold 
    hi TabLineFill term=reverse cterm=reverse 
    hi CursorLine term=underline cterm=bold ctermbg=234
    hi Cursor ctermbg=241 
    hi MatchParen term=reverse cterm=bold ctermfg=157 ctermbg=237   
    hi Error term=reverse ctermfg=15 ctermbg=9  





    " :hi TabLineSel|hi TabLineFill|hi TabLine
    "hi TabLineSel term=bold cterm=bold 
    "hi TabLineFill term=reverse cterm=reverse 
    "hi TabLine term=underline cterm=underline ctermfg=15 ctermbg=242 
    hi ExtraWhitespace ctermbg=red
    hi Comment term=none ctermfg=darkgrey 
    hi Constant term=underline ctermfg=Magenta 
    hi Special term=bold ctermfg=DarkMagenta 
    hi Identifier term=underline cterm=bold ctermfg=Cyan 
    hi Statement term=bold ctermfg=Yellow 
    hi PreProc term=underline ctermfg=LightBlue 
    hi Type term=underline ctermfg=LightGreen 
    hi Repeat term=underline ctermfg=White 
    hi Operator ctermfg=Red 
    hi Ignore ctermfg=black 
    hi Error term=reverse ctermbg=Red ctermfg=White 
    hi Todo term=standout ctermbg=Yellow ctermfg=Black 



    " COMMON GROUPS THAT LINK TO DEFAULT HIGHLIGHTING.

    hi Function ctermfg=85
    hi String ctermfg=204
    hi Statement term=bold cterm=bold ctermfg=81
    hi Function term=bold cterm=bold ctermfg=32
    hi Number ctermfg=129
    hi Conditional term=bold cterm=bold ctermfg=47
    hi Special term=underline ctermfg=191
    hi Normal ctermfg=7
    hi PreProc ctermfg=141
    " Syntax highlighting
    hi Comment ctermfg=244
    hi Todo ctermfg=245
    hi Boolean ctermfg=148
    hi String ctermfg=148
    hi Identifier ctermfg=148
    hi Function ctermfg=124
    hi Type ctermfg=103
    hi Statement ctermfg=103
    hi Keyword ctermfg=81
    hi Constant ctermfg=81
    hi Number ctermfg=81
    hi Special ctermfg=81
    hi PreProc ctermfg=230
    " Code-specific colors
     

    " SYNTAX HIGHLIGHTING GROUPS (:HELP GROUP-NAME) {{{2
    hi FoldColumn ctermbg=0 ctermfg=2
    hi Folded cterm=none ctermfg=2
    hi NonText cterm=NONE ctermfg=NONE 
    hi StatusLine ctermfg=black ctermbg=White cterm=bold
    hi StatusLineNC ctermfg=White ctermbg=green cterm=NONE
    hi CursorLine cterm=bold term=bold

    " FINAL THOUGHTS "{{{2
    "syn region myFold start="{" end="}" transparent fold
    hi Search term=reverse ctermfg=0 ctermbg=11
    hi LineNr term=underline ctermfg=244 ctermbg=232
    hi MatchParen ctermfg=15 ctermbg=242
    hi String ctermfg=10
    hi Constant ctermfg=14
    hi Identifier ctermfg=14
    hi Operator ctermfg=13
    hi NonText cterm=NONE ctermfg=NONE
    hi Search cterm=bold ctermbg=99 ctermfg=17

Retrieved from
"https://wiki.archlinux.org/index.php?title=Vimrc&oldid=197323"

Category:

-   Dotfiles
