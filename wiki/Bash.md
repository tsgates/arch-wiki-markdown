Bash
====

Related articles

-   Readline
-   Environment variables
-   Color Bash Prompt

Bash (Bourne-again Shell) is a shell/programming language by the GNU
Project. Its name is a homaging reference to its predecessor: the
long-deprecated Bourne shell. Bash can be run on most UNIX-like
operating systems, including GNU/Linux.

Contents
--------

-   1 Invocation
    -   1.1 Login shell
    -   1.2 Interactive shell
    -   1.3 POSIX compliance
    -   1.4 Legacy mode
-   2 Configuration
    -   2.1 Configuration file sourcing order at startup
    -   2.2 Shell and environment variables
-   3 Command line
-   4 Aliases
-   5 Functions
    -   5.1 Compile and execute a C source on the fly
    -   5.2 Extract
    -   5.3 cd and ls in one
    -   5.4 Simple note taker
    -   5.5 Simple task utility
    -   5.6 Docview
    -   5.7 Calculator
    -   5.8 Kingbash
-   6 Tips and tricks
    -   6.1 Prompt customization
    -   6.2 Tab completion
        -   6.2.1 Less-input completion
        -   6.2.2 Manually
    -   6.3 The "command not found" hook
    -   6.4 Display error codes
    -   6.5 Disable Ctrl+z in terminal
    -   6.6 Clear the screen after logging out
    -   6.7 ASCII art, fortunes and cowsay
    -   6.8 ASCII historical calendar
    -   6.9 Customise title
    -   6.10 Fix line wrap on window resize
    -   6.11 History completion
    -   6.12 Auto "cd" when entering just a path
    -   6.13 Mimic Zsh run-help ability
-   7 See also

Invocation
----------

Bash behaviour can be altered depending on how it is invoked. Some
descriptions of different modes follow.

> Login shell

If Bash is spawned by login in a tty, by an SSH daemon, or similar
means, it is considered a login shell. This mode can also be engaged
using the -l or --login command line options.

> Interactive shell

Bash is considered an interactive shell if it is started neither with
the -c option nor any non-option arguments, and whose standard input and
error are connected to terminals.

> POSIX compliance

Bash can be run with enhanced POSIX compliance by starting Bash with the
--posix command-line option or executing set -o posix while Bash is
running.

> Legacy mode

In Arch /bin/sh (which used to be the Bourne shell executable) is
symlinked to /bin/bash.

If Bash is invoked with the name sh, it tries to mimic the startup
behavior of historical versions of sh.

Configuration
-------------

The following files can be used to configure Bash:

-   /etc/profile
-   ~/.bash_profile
-   ~/.bash_login
-   ~/.profile

Note:/etc/bash.bashrc is non-standard, only some distributions like Arch
Linux have this included because packagers have added a
-DSYS_BASHRC="/etc/bash.bashrc" flag at compilation time, in order to
have a system bashrc file.

-   /etc/bash.bashrc
-   ~/.bashrc
-   ~/.bash_logout

These files are commonly used:

-   /etc/profile is sourced by all Bourne-compatible shells upon login.
    It sets up an environment upon login and loads application-specific
    (/etc/profile.d/*.sh) settings.
-   ~/.profile is read and sourced by Bash when an interactive login
    shell is started.
-   ~/.bashrc is read and sourced by Bash when a non-login interactive
    shell is started, for example, when you open a virtual console from
    the desktop environment. This file is useful for setting up a
    user-specific shell environment.

> Configuration file sourcing order at startup

These files are sourced by Bash in different circumstances.

-   if interactive + login shell → /etc/profile then the first readable
    of ~/.bash_profile, ~/.bash_login, and ~/.profile
    -   Bash will source ~/.bash_logout and /etc/bash.bash_logout upon
        exit.
-   if interactive + non-login shell → /etc/bash.bashrc then ~/.bashrc
-   if login shell + legacy mode → /etc/profile then ~/.profile

And by default in Arch:

-   /etc/profile (indirectly) sources /etc/bash.bashrc
-   /etc/skel/.bash_profile which users are encouraged to copy to
    ~/.bash_profile, sources ~/.bashrc

which means that /etc/bash.bashrc and ~/.bashrc will be executed for all
interactive shells, whether they are login shells or not.

The complete startup sequence for Bash is explained in the INVOCATION
section of man 1 bash or in [1].

> Shell and environment variables

The behavior of Bash and programs run by it can be influenced by a
number of environment variables. Environment variables are used to store
useful values such as command search directories, or which browser to
use. When a new shell or script is launched it inherits its parent's
variables, thus starting with an internal set of shell variables[2].

These shell variables in Bash can be exported in order to become
environment variables:

    VARIABLE=content
    export VARIABLE

or with a shortcut

    export VARIABLE=content

Environment variables are conventionally placed in ~/.profile or
/etc/profile so that all bourne-compatible shells can use them.

See Environment variables for more general information.

Command line
------------

Bash command line is managed by the separate library called Readline.
Readline provides a lot of shortcuts for interacting with the command
line i.e. moving back and forth on the word basis, deleting words etc.
It is also Readline's responsibility to manage history of input
commands. Last, but not least, it allows you to create macros.

Aliases
-------

alias is a command, which enables a replacement of a word with another
string. It is often used for abbreviating a system command, or for
adding default arguments to a regularly used command.

Personal aliases are preferably stored in ~/.bashrc, and system-wide
aliases (which affect all users) belong in /etc/bash.bashrc.

An example excerpt from ~/.bashrc covering several time-saving aliases:

    ~/.bashrc

    ## Modified commands ## {{{
    alias diff='colordiff'              # requires colordiff package
    alias grep='grep --color=auto'
    alias more='less'
    alias df='df -h'
    alias du='du -c -h'
    alias mkdir='mkdir -p -v'
    alias nano='nano -w'
    alias ping='ping -c 5'
    alias dmesg='dmesg -HL'
    # }}}

    ## New commands ## {{{
    alias da='date "+%A, %B %d, %Y [%T]"'
    alias du1='du --max-depth=1'
    alias hist='history | grep'         # requires an argument
    alias openports='ss --all --numeric --processes --ipv4 --ipv6'
    alias pgg='ps -Af | grep'           # requires an argument
    alias ..='cd ..'
    # }}}

    # Privileged access
    if [ $UID -ne 0 ]; then
        alias sudo='sudo '
        alias scat='sudo cat'
        alias svim='sudoedit'
        alias root='sudo -s'
        alias reboot='sudo systemctl reboot'
        alias poweroff='sudo systemctl poweroff'
        alias update='sudo pacman -Su'
        alias netctl='sudo netctl'
    fi

    ## ls ## {{{
    alias ls='ls -hF --color=auto'
    alias lr='ls -R'                    # recursive ls
    alias ll='ls -l'
    alias la='ll -A'
    alias lx='ll -BX'                   # sort by extension
    alias lz='ll -rS'                   # sort by size
    alias lt='ll -rt'                   # sort by date
    alias lm='la | more'
    # }}}

    ## Safety features ## {{{
    alias cp='cp -i'
    alias mv='mv -i'
    alias rm='rm -I'                    # 'rm -i' prompts for every file
    # safer alternative w/ timeout, not stored in history
    alias rm=' timeout 3 rm -Iv --one-file-system'
    alias ln='ln -i'
    alias chown='chown --preserve-root'
    alias chmod='chmod --preserve-root'
    alias chgrp='chgrp --preserve-root'
    alias cls=' echo -ne "\033c"'       # clear screen for real (it does not work in Terminology)
    # }}}

    ## Make Bash error tolerant ## {{{
    alias :q=' exit'
    alias :Q=' exit'
    alias :x=' exit'
    alias cd..='cd ..'
    # }}}

See also Pacman Tips#Shortcuts for other useful aliases.

Functions
---------

Bash also supports functions. Add the functions to ~/.bashrc, or a
separate file which is sourced from ~/.bashrc. More Bash function
examples can be found in BBS#30155.

> Compile and execute a C source on the fly

The following function will compile (within the /tmp/ directory) and
execute the C source argument on the fly (and the execution will be
without arguments). And finally, after program terminates, will remove
the compiled file.

    ~/.bashrc

    # Compile and execute a C source on the fly
    csource() {
            [[ $1 ]]    || { echo "Missing operand" >&2; return 1; }
            [[ -r $1 ]] || { printf "File %s does not exist or is not readable\n" "$1" >&2; return 1; }
    	local output_path=${TMPDIR:-/tmp}/${1##*/};
    	gcc "$1" -o "$output_path" && "$output_path";
    	rm "$output_path";
    	return 0;
    }

> Extract

The following function will extract a wide range of compressed file
types. and use it with the syntax extract <file1> <file2> ...

    ~/.bashrc

    extract() {
        local c e i

        (($#)) || return

        for i; do
            c=''
            e=1

            if [[ ! -r $i ]]; then
                echo "$0: file is unreadable: \`$i'" >&2
                continue
            fi

            case $i in
                *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
                       c=(bsdtar xvf);;
                *.7z)  c=(7z x);;
                *.Z)   c=(uncompress);;
                *.bz2) c=(bunzip2);;
                *.exe) c=(cabextract);;
                *.gz)  c=(gunzip);;
                *.rar) c=(unrar x);;
                *.xz)  c=(unxz);;
                *.zip) c=(unzip);;
                *)     echo "$0: unrecognized file extension: \`$i'" >&2
                       continue;;
            esac

            command "${c[@]}" "$i"
            ((e = e || $?))
        done
        return "$e"
    }

Note:Make sure extglob is enabled: shopt -s extglob, by adding it to the
~/.bashrc (see:
http://mywiki.wooledge.org/glob#Options_which_change_globbing_behavior).
It is enabled by default, if using Bash completion.

Another way to do this is to install a specialized package. For example:

-   unp - package from the AUR which contains a Perl script
-   atool
-   dtrx

> cd and ls in one

Very often changing to a directory is followed by the ls command to list
its contents. Therefore it is helpful to have a second function doing
both at once. In this example we will name it cl and show an error
message if the specified directory does not exist.

    ~/.bashrc

    # cd and ls in one
    cl() {
        dir=$1
        if [[ -z "$dir" ]]; then
            dir=$HOME
        fi
        if [[ -d "$dir" ]]; then
            cd "$dir"
            ls
        else
            echo "bash: cl: '$dir': Directory not found"
        fi
    }

Of course the ls command can be altered to fit your needs, for example
ls -hall --color=auto.

> Simple note taker

    ~/.bashrc

    note () {
        # if file doesn't exist, create it
        if [[ ! -f $HOME/.notes ]]; then
            touch "$HOME/.notes"
        fi

        if ! (($#)); then
            # no arguments, print file
            cat "$HOME/.notes"
        elif [[ "$1" == "-c" ]]; then
            # clear file
            > "$HOME/.notes"
        else
            # add all arguments to file
            printf "%s\n" "$*" >> "$HOME/.notes"
        fi
    }

> Simple task utility

Inspired by #Simple note taker

    ~/.bashrc

    todo() {
        if [[ ! -f $HOME/.todo ]]; then
            touch "$HOME/.todo"
        fi

        if ! (($#)); then
            cat "$HOME/.todo"
        elif [[ "$1" == "-l" ]]; then
            nl -b a "$HOME/.todo"
        elif [[ "$1" == "-c" ]]; then
            > $HOME/.todo
        elif [[ "$1" == "-r" ]]; then
            nl -b a "$HOME/.todo"
            printf "----------------------------\n"
            read -p "Type a number to remove: " number
            ex -sc "${number}d" "$HOME/.todo"
        else
            printf "%s\n" "$*" >> "$HOME/.todo"
        fi
    }

> Docview

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: It is probably   
                           best to configure        
                           xdg-open correctly.      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

    ~/.bashrc

    docview () {
        if [[ -f $1 ]] ; then
            case $1 in
                *.pdf)       xpdf     "$1" ;;
                *.ps)        oowriter "$1" ;;
                *.odt)       oowriter "$1" ;;
                *.txt)       leafpad  "$1" ;;
                *.doc)       oowriter "$1" ;;
                *)           printf "don't know how to extract '%s'..." "$1" >&2; return 1 ;;
            esac
        else
            printf "'%s' is not a valid file!\n" "$1" >&2
            return 1;
        fi
    }

> Calculator

    ~/.bashrc

    calc() {
        echo "scale=3;$@" | bc -l
    }

> Kingbash

Kingbash - menu driven auto-completion (see
https://bbs.archlinux.org/viewtopic.php?id=101010).

Install kingbash from the AUR, then insert the following into your
~/.bashrc:

    ~/.bashrc

    function kingbash.fn() {
        echo -n "KingBash> $READLINE_LINE" #Where "KingBash> " looks best if it resembles your PS1, at least in length.
        OUTPUT=$(/usr/bin/kingbash "$(compgen -ab -A function)")
        READLINE_POINT=$(echo "$OUTPUT" | tail -n 1)
        READLINE_LINE=$(echo "$OUTPUT" | head -n -1)
        echo -ne "\r\e[2K"
    }
    bind -x '"\t":kingbash.fn'

Tips and tricks
---------------

> Prompt customization

The Bash prompt is governed by the variable $PS1. To colorize the Bash
prompt, use:

    ~/.bashrc

    #PS1='[\u@\h \W]\$ '  # To leave the default one
    #DO NOT USE RAW ESCAPES, USE TPUT
    reset=$(tput sgr0)
    red=$(tput setaf 1)
    blue=$(tput setaf 4)
    green=$(tput setaf 2)

    PS1='\[$red\]\u\[$reset\] \[$blue\]\w\[$reset\] \[$red\]\$ \[$reset\]\[$green\] '

This $PS1 is useful for a root Bash prompt, with red designation and
green console text. For more info, see: Color Bash Prompt.

> Tab completion

Tab completion allows for completing partially typed commands by
pressing Tab twice. Start a new shell and it will be automatically
enabled by /etc/bash.bashrc.

Note:Bash's native support of tab-completions for basic file name,
command, and variables can be extended with the package
bash-completion (available in the official repositories). It extends
its' functionality by adding a wide range of commands and their options.
The normal expansions that you are used to (such as
$ ls file.*<tab><tab>) will not work unless you
$ compopt -o bashdefault <prog> for all programs you want to fallback to
the normal glob expansions. See [3] and [4].

Less-input completion

For a single press of Tab to produce a list of all possible completions
(both when a partial or no completion is possible):

    ~/.inputrc

    set show-all-if-ambiguous on

Alternatively, to produce such a list only when no completion is
possible:

    ~/.inputrc

    set show-all-if-ambiguous on
    set show-all-if-unmodified on

Manually

For basic completion use lines in the form of complete -cf your_command
(Note: these will conflict with the bash-completion package settings):

    ~/.bashrc

    complete -cf sudo
    complete -cf man

> The "command not found" hook

See pkgfile#"Command not found" hook.

> Display error codes

To set trap to intercept the non-zero return code of last program:

    ~/.bashrc

    EC() { echo -e '\e[1;33m'code $?'\e[m\n'; }
    trap EC ERR

> Disable Ctrl+z in terminal

You can disable the Ctrl+z feature (pauses/closes your application) by
wrapping your command like this:

    #!/bin/bash
    trap "" 20
    adom

Now when you accidentally press Ctrl+z in adom instead of Shift+z
nothing will happen because Ctrl+z will be ignored.

> Clear the screen after logging out

To clear the screen after logging out on a virtual terminal:

    ~/.bash_logout

    clear
    reset

> ASCII art, fortunes and cowsay

Along with colors, system info and ASCII symbols, Bash can be made to
display a piece of ASCII art on login. ASCII images can be found online
and pasted into a text file, or generated from scratch. To set the image
to display in a terminal on login, use:

    ~/.bashrc

    cat /path/to/text/file

Random poignant, inspirational, silly or snide phrases can be found in
fortune-mod.

    $ fortune

    It is Texas law that when two trains meet each other at a railroad crossing,
    each shall come to a full stop, and neither shall proceed until the other has gone.

Note:By default, fortune displays quotes and phrases that are rather
innocuous. However, the package does contain a set of comments some
people will find offensive, located in /usr/share/fortune/off/. See the
man page (man fortune) for more info on these.

To have a random phrase displayed when logging into a terminal, use:

    ~/.bashrc

    command fortune

These two features can be combined, using the program cowsay:

    command cowsay $(fortune)

    The earth is like a tiny grain of sand, 
    only much, much heavier.                
    ----------------------------------------- 
           \   ^__^
            \  (oo)\_______
               (__)\       )\/\
                   ||----w |
                   ||     ||
    (user@host)-(10:10 AM Wed Dec 22)
    --(~))--->

    command cowthink $(fortune)

    ( The best cure for insomnia is to get a )
    ( lot of sleep. -W.C. Fields             )
     ---------------------------------------- 
            o   ^__^
             o  (oo)\_______
                (__)\       )\/\
                    ||----w |
                    ||     ||
    (user@host)-(10:10 AM Wed Dec 22)
    --(~))--->

The ASCII images are generated by .cow text files located in
/usr/share/cows, and all themes can be listed with the cowsay -l. These
files can be edited to the user's liking; custom images can also be
created from scratch or found on the net. The easiest way create a
custom cow file is to use an existing one as a template. To test the
custom file:

    $ cowsay -f /path/to/file $(fortune)

This can produce some nice eye candy, and the commands used can be more
complex. For a specialized example, take a look here. Another example,
to use a random cow, random facial expression, and nicely wrap the text
of long fortunes:

    command fortune -a | fmt -80 -s | $(shuf -n 1 -e cowsay cowthink) -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n

     ________________________________________ 
    ( Fry: I must be a robot. Why else would )
    ( human women refuse to date me?         )
    ---------------------------------------- 
           o
             o
               o  
                  ,'``.._   ,'``.
                 :,--._:)\,:,._,.:
                 :`--,''@@@:`...';\        
                  `,'@@@@@@@`---'@@`.     
                  /@@@@@@@@@@@@@@@@@:
                 /@@@@@@@@@@@@@@@@@@@\
               ,'@@@@@@@@@@@@@@@@@@@@@:\.___,-.
              `...,---'``````-..._@@@@|:@@@@@@@\
                (                 )@@@;:@@@@)@@@\  _,-.
                 `.              (@@@//@@@@@@@@@@`'@@@@\
                  :               `.//@@)@@@@@@)@@@@@,@;
                  |`.            _,'/@@@@@@@)@@@@)@,'@,'
                  :`.`-..____..=:.-':@@@@@.@@@@@_,@@,'
                 ,'\ ``--....-)='    `._,@@\    )@@@'``._
                /@_@`.       (@)      /@@@@@)  ; / \ \`-.'
               (@@@`-:`.     `' ___..'@@_,-'   |/   `.)
                `-. `.`.``-----``--,@@.'
                  |/`.\`'        ,',');
                      `         (/  (/
    (user@host)-(10:10 AM Wed Dec 22)
    --(~))--->

Note:For full 256-colored cowsay-like art use ponysay (version 3.0 has
422 ponies). The syntax is the same, meaning $ ponysay message to say
something and ponysay -l for a complete list of ponies. To create more
ponies use util-say-git and store them in ~/.local/share/ponysay/ponies
and ~/.local/share/ponysay/ttyponies/ for desktop and TTY, respectively.

> ASCII historical calendar

To install calendar files in your ~/.calendar directory you will need
the rpmextract package installed. Then from your home directory, run the
following:

    $ mkdir -p ~/.calendar
    $ curl -o calendar.rpm http://download.fedora.redhat.com/pub/epel/5/x86_64/calendar-1.25-4.el5.x86_64.rpm
    $ rpm2cpio calendar.rpm | bsdtar -C ~/.calendar --strip-components=4 -xf - ./usr/share/c*

This will then print out the calendar items:

    $ sed -n "/$(date +%m\\/%d\\\|%b\*\ %d)/p" $(find ~/.calendar /usr/share/calendar -maxdepth 1 -type f -name 'c*' 2>/dev/null);

> Customise title

The $PROMPT_COMMAND variable allows you to execute a command before the
prompt. For example, this will change the title to your full current
working directory:

    ~/.bashrc

    export PROMPT_COMMAND='echo -ne "\033]0;$PWD\007"'

This will change your title to the last command run, and make sure your
history file is always up-to-date:

    ~/.bashrc

    export HISTCONTROL=ignoreboth
    export HISTIGNORE='history*'
    export PROMPT_COMMAND='history -a;echo -en "\e]2;";history 1|sed "s/^[ \t]*[0-9]\{1,\}  //g";echo -en "\e\\";'

> Fix line wrap on window resize

When you resize your xterm in vi for example, Bash will not get the
resize signal, and the text you type will not wrap correctly,
overlapping the prompt.

    ~/.bashrc

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

> History completion

History completion bound to arrow keys (down, up) (see: Readline#History
and Readline Init File Syntax):

    ~/.bashrc

     bind '"\e[A": history-search-backward'
     bind '"\e[B": history-search-forward'

or:

    ~/.inputrc

    "\e[A": history-search-backward
    "\e[B": history-search-forward

> Auto "cd" when entering just a path

Bash can automatically prepend cd  when entering just a path in the
shell. For example:

    $ /etc

    bash: /etc: Is a directory

But after:

    ~/.bashrc

    shopt -s autocd

You get:

    [user@host ~] $ /etc
    cd /etc
    [user@host etc]

> Mimic Zsh run-help ability

Zsh can invoke the manual for the written command pushing Alt+h. A
similar behaviour is obtained in Bash by appending this line in your
inputrc file:

    /etc/inputrc

    "\eh": "\C-a\eb\ed\C-y\e#man \C-y\C-m\C-p\C-p\C-a\C-d\C-e"

See also
--------

-   Advanced Bash Scripting Guide - Very good resource regarding shell
    scripting using Bash
-   An active and friendly IRC channel for Bash
-   Bash Hackers Wiki - Excellent Bash Wiki
-   Bash Reference Manual - Official reference (654K)
-   Bash Scripting by Example
-   Bashscripts.org - A forum for bashers.
-   Chakra Wiki: Startup files
-   Completion Guide
-   Custom Bash Commands & Functions
-   General recommendations - General Recommendations for Arch
-   Greg's Wiki - Highly recommended
-   How to change the title of an xterm
-   Bash manual page
-   Quote Tutorial
-   Introduction to Bash
-   Readline Init File Syntax* The Bourne-Again Shell - The third
    chapter of The Architecture of Open Source Applications

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bash&oldid=305921"

Category:

-   Command shells

-   This page was last modified on 20 March 2014, at 17:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
