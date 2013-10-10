Bash
====

> Summary

Discussing and improving Bash's capabilities.

> Related

Readline

Environment Variables

Color Bash Prompt

Bash (Bourne-again Shell) is a shell/programming language by the GNU
Project. Its name is a homaging reference to its predecessor: the
long-deprecated Bourne shell. Bash can be run on most UNIX-like
operating systems, including GNU/Linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Invocation                                                         |
|     -   1.1 Login shell                                                  |
|     -   1.2 Interactive shell                                            |
|     -   1.3 POSIX compliance                                             |
|     -   1.4 Legacy mode                                                  |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Configuration file sourcing order at startup                 |
|     -   2.2 Shell and environment variables                              |
|                                                                          |
| -   3 Command line                                                       |
| -   4 Aliases                                                            |
| -   5 Functions                                                          |
| -   6 Tips and tricks                                                    |
|     -   6.1 Prompt customization                                         |
|     -   6.2 Tab completion                                               |
|         -   6.2.1 Faster completion                                      |
|         -   6.2.2 Manually                                               |
|                                                                          |
|     -   6.3 The "command not found" hook                                 |
|     -   6.4 Display error codes                                          |
|     -   6.5 Disable Ctrl+z in terminal                                   |
|     -   6.6 Clear the screen after logging out                           |
|     -   6.7 ASCII art, fortunes and cowsay                               |
|     -   6.8 ASCII Historical Calendar                                    |
|     -   6.9 Customise Title                                              |
|     -   6.10 Fix line wrap on window resize                              |
|     -   6.11 History completion                                          |
|     -   6.12 Auto "cd" when entering just a path                         |
|                                                                          |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

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
--posix command-line option or executing ‘set -o posix’ while Bash is
running.

> Legacy mode

In Arch /bin/sh (which used to be the Bourne shell executable) is
symlinked to /bin/bash.

If Bash is invoked with the name sh, it tries to mimic the startup
behavior of historical versions of sh.

Configuration
-------------

The following files can be used to configure bash:

-   /etc/profile
-   ~/.bash_profile
-   ~/.bash_login
-   ~/.profile
-   /etc/bash.bashrc (Non-standard: only some distros, Arch included)
-   ~/.bashrc
-   ~/.bash_logout

These files are commonly used:

-   /etc/profile is sourced by all Bourne-compatible shells upon login.
    It sets up an environment upon login and loads application-specific
    (/etc/profile.d/*.sh) settings.
-   ~/.profile is read and sourced by bash when an interactive login
    shell is started.
-   ~/.bashrc is read and sourced by bash when a non-login interactive
    shell is started, for example, when you open a virtual console from
    the desktop environment. This file is useful for setting up a
    user-specific shell environment.

> Configuration file sourcing order at startup

These files are sourced by bash in different circumstances.

-   if interactive + login shell → /etc/profile then the first readable
    of ~/.bash_profile, ~/.bash_login, and ~/.profile
    -   Bash will source ~/.bash_logout upon exit.

-   if interactive + non-login shell → /etc/bash.bashrc then ~/.bashrc
-   if login shell + legacy mode → /etc/profile then ~/.profile

And by default in Arch:

-   /etc/profile (indirectly) sources /etc/bash.bashrc
-   /etc/skel/.bash_profile which users are encouraged to copy to
    ~/.bash_profile, sources ~/.bashrc

which means that /etc/bash.bashrc and ~/.bashrc will be executed for all
interactive shells, whether they are login shells or not.

> Shell and environment variables

The behavior of bash and programs run by it can be influenced by a
number of environment variable. Environment variables are used to store
useful values such as command search directories, or which browser to
use. When a new shell or script is launched it inherits its parent's
variables, thus starting with an internal set of shell variables[1].

These shell variables in bash can be exported in order to become
environment variables:

    VARIABLE=content
    export VARIABLE

or with a shortcut

    export VARIABLE=content

Environment variables are conventionally placed in ~/.profile or
/etc/profile so that all bourne-compatible shells can use them.

See Environment Variables for more general information.

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

    # modified commands
    alias diff='colordiff'              # requires colordiff package
    alias grep='grep --color=auto'
    alias more='less'
    alias df='df -h'
    alias du='du -c -h'
    alias mkdir='mkdir -p -v'
    alias nano='nano -w'
    alias ping='ping -c 5'
    alias ..='cd ..'

    # new commands
    alias da='date "+%A, %B %d, %Y [%T]"'
    alias du1='du --max-depth=1'
    alias hist='history | grep'      # requires an argument
    alias openports='ss --all --numeric --processes --ipv4 --ipv6'
    alias pg='ps -Af | grep $1'         # requires an argument (note: /usr/bin/pg is installed by the util-linux package; maybe a different alias name should be used)

    # privileged access
    if [ $UID -ne 0 ]; then
        alias sudo='sudo '
        alias scat='sudo cat'
        alias svim='sudo vim'
        alias root='sudo su'
        alias reboot='sudo systemctl reboot'
        alias poweroff='sudo systemctl poweroff'
        alias update='sudo pacman -Su'
        alias netcfg='sudo netcfg2'
    fi

    # ls
    alias ls='ls -hF --color=auto'
    alias lr='ls -R'                    # recursive ls
    alias ll='ls -l'
    alias la='ll -A'
    alias lx='ll -BX'                   # sort by extension
    alias lz='ll -rS'                   # sort by size
    alias lt='ll -rt'                   # sort by date
    alias lm='la | more'

    # safety features
    alias cp='cp -i'
    alias mv='mv -i'
    alias rm='rm -I'                    # 'rm -i' prompts for every file
    alias ln='ln -i'
    alias chown='chown --preserve-root'
    alias chmod='chmod --preserve-root'
    alias chgrp='chgrp --preserve-root'

    # pacman aliases (if necessary, replace 'pacman' with your favorite AUR helper and adapt the commands accordingly)
    alias pac="sudo /usr/bin/pacman -S"		# default action	- install one or more packages
    alias pacu="/usr/bin/pacman -Syu"		# '[u]pdate'		- upgrade all packages to their newest version
    alias pacr="sudo /usr/bin/pacman -Rs"		# '[r]emove'		- uninstall one or more packages
    alias pacs="/usr/bin/pacman -Ss"		# '[s]earch'		- search for a package using one or more keywords
    alias paci="/usr/bin/pacman -Si"		# '[i]nfo'		- show information about a package
    alias paclo="/usr/bin/pacman -Qdt"		# '[l]ist [o]rphans'	- list all packages which are orphaned
    alias pacc="sudo /usr/bin/pacman -Scc"		# '[c]lean cache'	- delete all not currently installed package files
    alias paclf="/usr/bin/pacman -Ql"		# '[l]ist [f]iles'	- list all files installed by a given package
    alias pacexpl="/usr/bin/pacman -D --asexp"	# 'mark as [expl]icit'	- mark one or more packages as explicitly installed 
    alias pacimpl="/usr/bin/pacman -D --asdep"	# 'mark as [impl]icit'	- mark one or more packages as non explicitly installed

    # '[r]emove [o]rphans' - recursively remove ALL orphaned packages
    alias pacro="/usr/bin/pacman -Qtdq > /dev/null && sudo /usr/bin/pacman -Rs \$(/usr/bin/pacman -Qtdq | sed -e ':a;N;$!ba;s/\n/ /g')"

Functions
---------

Bash also supports functions. The following function will extract a wide
range of compressed file types. Add the function to ~/.bashrc and use it
with the syntax extract <file1> <file2> ...

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
                   c='bsdtar xvf';;
            *.7z)  c='7z x';;
            *.Z)   c='uncompress';;
            *.bz2) c='bunzip2';;
            *.exe) c='cabextract';;
            *.gz)  c='gunzip';;
            *.rar) c='unrar x';;
            *.xz)  c='unxz';;
            *.zip) c='unzip';;
            *)     echo "$0: unrecognized file extension: \`$i'" >&2
                   continue;;
            esac

            command $c "$i"
            e=$?
        done

        return $e
    }

Note:Make sure extglob is enabled: shopt -s extglob, by adding it to the
~/.bashrc (see:
http://mywiki.wooledge.org/glob#Options_which_change_globbing_behavior).
It is enabled by default, if using Bash completion.

Another way to do this is to install the unp package from the AUR which
contains a Perl script.

Very often changing to a directory is followed by the ls command to list
its contents. Therefore it is helpful to have a second function doing
both at once. In this example we will name it cl and show an error
message if the specified directory does not exist.

    ~/.bashrc

    # cd and ls in one
    cl() {
    if [ -d "$1" ]; then
    	cd "$1"
    	ls
    	else
    	echo "bash: cl: '$1': Directory not found"
    fi
    }

Of course the ls command can be altered to fit your needs, for example
$ ls -hall --color=auto.

More Bash function examples can be found in BBS#30155.

Tips and tricks
---------------

> Prompt customization

The bash prompt is governed by the variable $PS1. To colorize the bash
prompt, use:

    ~/.bashrc

    #PS1='[\u@\h \W]\$ '  # To leave the default one
    PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$ \[\e[m\]\[\e[0;32m\] '

This $PS1 is useful for a root bash prompt, with red designation and
green console text. For more info, see: Color Bash Prompt.

> Tab completion

Tab completion allows for completing partially typed commands by
pressing Tab twice.

Despite Bash's native support for basic file name, command, and variable
tab completion the package bash-completion (available in the Official
repositories) extends functionality by adding it to a wide range of
commands and their options.

Start a new shell and it will be automatically enabled by
/etc/bash.bashrc.

Note:The normal expansions that you are used to like
$ ls file.*<tab><tab> will not work unless you
$ compopt -o bashdefault <prog> for all programs you want to fallback to
the normal glob expansions. See
https://bbs.archlinux.org/viewtopic.php?id=128471 and
https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html

Faster completion

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

For basic completion use lines in the form of complete -cf your_command:

    ~/.bashrc

    complete -cf sudo
    complete -cf man

Note:These will conflict with bash-completion.

> The "command not found" hook

The pkgfile package includes a "command not found" hook that will
automatically search the official repositories when you enter an
unrecognized command. Then it will display something like this:

    $ abiword

    abiword may be found in the following packages:
      extra/abiword 2.8.6-7	usr/bin/abiword

An alternative "command not found" hook is also provided by the AUR
package command-not-found, which will generate an output like the
following:

    $ abiword

    The command 'abiword' is been provided by the following packages:
    abiword (2.8.6-7) from extra
    	[ abiword ]
    abiword (2.8.6-7) from staging
    	[ abiword ]
    abiword (2.8.6-7) from testing
    	[ abiword ]

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
innoccuous. However, the package does contain a set of comments some
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
and ~/.local/share/ponysay/ttyponies/ for desktop and TTY, respectively

> ASCII Historical Calendar

To install calendar files in your ~/.calendar directory you will need
the rpmextract package installed. Then from your home directory, run the
following:

    $ mkdir -p ~/.calendar
    $ curl -o calendar.rpm http://download.fedora.redhat.com/pub/epel/5/x86_64/calendar-1.25-4.el5.x86_64.rpm
    $ rpm2cpio calendar.rpm | bsdtar -C ~/.calendar --strip-components=4 -xf - ./usr/share/c*

This will then print out the calendar items:

    $ sed -n "/$(date +%m\\/%d\\\|%b\*\ %d)/p" $(find ~/.calendar /usr/share/calendar -maxdepth 1 -type f -name 'c*' 2>/dev/null);

> Customise Title

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

See also
--------

-   Advanced Bash Scripting Guide - Very good resource regarding shell
    scripting using bash
-   An active and friendly IRC channel for Bash
-   Bash Hackers Wiki - Excellent Bash Wiki
-   Bash Reference Manual - Official reference (654K)
-   Bash Scripting by Example
-   Bashscripts.org - A Forum for bashers.
-   Chakra Wiki: Startup files
-   Completion Guide
-   Custom Bash Commands & Functions
-   General Recommendations - General Recommendations for Arch
-   Greg's Wiki - Highly recommended
-   How to change the title of an xterm
-   man bash
-   Quote Tutorial
-   Readline Init File Syntax* The Bourne-Again Shell - The third
    chapter of The Architecture of Open Source Applications

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bash&oldid=254806"

Category:

-   Command shells
