Home and End keys not working
=============================

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Escape codes     
                           should not be hardcoded  
                           as is done on this page. 
                           These escape codes vary  
                           in meaning per terminal, 
                           which is why terminfo    
                           exists in the first      
                           place. In zsh you can    
                           use the $terminfo        
                           associative array, and   
                           in other shells you can  
                           use tput. (Discuss)      
  ------------------------ ------------------------ ------------------------

Note:This page previously contained some bad advice. Setting the TERM
environment variable in your ~/.bashrc is a BAD idea. Please do not do
it. Follow the advice below.

Contents
--------

-   1 Why do not my Home and End keys work in terminals?
    -   1.1 libreadline problem
    -   1.2 I do not touch my TERM value, and the keys still do not work
        right
    -   1.3 Adjusting terminfo (If nothing helps)
-   2 Why do not my Home and End keys work in application XYZ?
    -   2.1 Lynx
    -   2.2 URxvt/Rxvt
    -   2.3 Zsh
    -   2.4 Less

Why do not my Home and End keys work in terminals?
--------------------------------------------------

Technically, this is a little wrong. Your home and end keys work fine in
a terminal. They don't work, however, in your shell (bash).

Typically, command line applications use libreadline for interaction. If
you know it does not use readline, this tactic may or may not work. For
instance, ncurses applications most likely do not use libreadline, BUT
ncurses is usually smart enough to map your Home/End keys properly.

> libreadline problem

Usually applications are able to fix this on their own. The number one
cause of this problem is setting your $TERM variable to something it is
not in bashrc. All modern terminals are smart enough to set their own
term variable.

Do not set $TERM manually. Let the terminal do it.

When in bash, do the following:

    echo $TERM

You may or may not like the value it sets (i.e. 'xterm' when you want
'xterm-256color'). That is fine. Typically there is a way to configure
your terminal to change this without changing the TERM variable.

For xterm and urxvt, it is in ~/.Xresources

    XTerm*termName: xterm-256color
    ...
    URxvt*termName: rxvt-unicode

For screen, you can set the $TERM variable in your ~/.screenrc with:

    term screen-256color

TODO add more terminal configurations here

> I do not touch my TERM value, and the keys still do not work right

This can happen. Not everything is covered 100% of the time. But
libreadline had a workaround for this. libreadline maintains mappings
for more obscure keys in /etc/inputrc (or ~/.inputrc for user-by-user
changes).

If you look at the Arch /etc/inputrc, you will see the following lines:

    "\e[1~": beginning-of-line
    "\e[4~": end-of-line
    "\e[7~": beginning-of-line
    "\e[8~": end-of-line
    "\eOH": beginning-of-line
    "\eOF": end-of-line
    "\e[H": beginning-of-line
    "\e[F": end-of-line

All of these try to map your Home/End key values. To see the actual
value of yours, you can use yet another libreadline binding, called
"quoted-insert" which outputs the actual value of a key, rather than
issuing the keypress. quoted-insert is typically "Ctrl-v". Let's try an
example (done on urxvt):

    Ctrl-v F6 outputs ^[[17~
    Ctrl-v Ctrl-c outputs ^C
    Ctrl-v Home outputs ^[[1~
    Ctrl-v End outputs ^[[4~

For future reference, the ^[ is a literal (quoted-insert) Esc keypress.
This means that these keys are actually sending "ESC [ 4 ~". In inputrc
syntax, the ESC key is expressed with "\e" (as you can see above).

For example the urxvt keys shown above would be:

    "\e[1~": beginning-of-line
    "\e[4~": end-of-line

If your Home and End key values are not listed in /etc/inputrc (as you
can see, with the ^[ to \e conversion, mine ARE listed), you need to add
them there. 99% of the time this will not effect other terminals.
Technically, one should add these settings to ~/.inputrc, because it's
easier to keep track of, and stays with your user that way. You can also
do MUCH cooler things with a user-specific inputrc (See Readline for
more details).

> Adjusting terminfo (If nothing helps)

-   Do

        infocmp $TERM >terminfo.src

-   Edit terminfo.src file in current directory to adjust keystrings.
    For example change khome and kend.

    khome=\E[1~, kend=\E[4~, 

Warning:Please check that no other key use the same character sequence.

-   Run

        tic terminfo.src

    This command creates ~/.terminfo directory

-   Add

        export TERMINFO=~/.terminfo

    to your profile

Tip:Of course this works only for termcap/terminfo capable programs.
Other ones should have own keymap configuration mechanism

Why do not my Home and End keys work in application XYZ?
--------------------------------------------------------

If you've gone through the above, and your TERM is set properly, and
your Home and End keys are properly entered into /etc/inputrc and
~/.inputrc, this is no longer system wide. Your keys are correct, but
the application is not. You will have to consult the documentation for
the given app on how to do this. Hopefully we can add some examples here
as we come across broken applications.

> Lynx

In lynx.cfg, use the quoted-insert characters above, replacing ^[ with
\033:

    setkey "\033[1~" HOME
    setkey "\033[4~" END

> URxvt/Rxvt

In your X resources (in ~/.Xresources file) you should add something
like following:

    URxvt*keysym.Home: \033[1~
    URxvt*keysym.End: \033[4~

> Zsh

See Zsh#Key_bindings.

> Less

Create file ~/.less with

    $ lesskey -o .less -
    #command
    \e[4~ goto-end
    \e[1~ goto-line

or for making less work in xterm

    $ lesskey -o .less -
    #command
    \eOF goto-end
    \eOH goto-line

or you may create systemwide config the same way.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Home_and_End_keys_not_working&oldid=262391"

Categories:

-   Command shells
-   Keyboards

-   This page was last modified on 11 June 2013, at 17:18.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
