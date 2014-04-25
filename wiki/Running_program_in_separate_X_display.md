Running program in separate X display
=====================================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           Gaming#Starting_games_in 
                           _a_separate_X_server.    
                           Notes: same topic        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

It may often be handy to run some program in separate X display. I.e. 3D
games for gaining performance, or making alt+tab-style switching
possible with ctrl+alt+[F7-F12].

The simplest way would be:

    xinit appname -- :10

> Basic script

But if you have ~/.xinitrc in place, you should use full path to app to
override it. Also there can be some environment variables and X options
to pass. So the smart way would be to pack it all into a wrapper:

    #!/bin/bash

    # calculate first available VT
    LVT=`fgconsole --next-available`

    # calculate first usable display
    XNUM="-1"
    SOCK="something"
    while [ ! -z "$SOCK" ]
    do
    XNUM=$(( $XNUM + 1 ))
    SOCK=$(ls -A -1 /tmp/.X11-unix | grep "X$XNUM" )
    done
    NEWDISP=":$XNUM"

    if [ ! -z "$*" ]
    # generate exec line if arguments are given
    then
    # test if executable exists
     if [ ! -x "$(which $1 2> /dev/null)" ] 
    then
    echo "$1: No such executable!"
    # if running from X, display zenity dialog:
    [ -z "$DISPLAY" ] || zenity --error --text="$1: No such executable!" 2> /dev/null
    exit 127
    fi
    # generate exec line
    EXECL="$(which $1)"
    shift 1
    EXECL="$EXECL $*"
    EXECPH=""

    # prepare to start new X sessions if no arguments passed
    else
    EXECL=""
    EXECPH="New X session"
    fi

    # if runing from X, display zenity dialog:
    [ -z "$DISPLAY" ] || zenity --question --title "Launch?" --text="Will launch \"$EXECL$EXECPH\"

    tty$LVT
    X display $NEWDISP

    Continue?" 2> /dev/null || exit 1

    echo "Will launch \"$EXECL$EXECPH\" on tty$LVT, X display $NEWDISP..."
    [ -z "$DISPLAY" ] && sleep 1s


    # This flag is used for indication of unaccessible or broken DRI.
    # It is set, for example, when using fglrx+compiz-manager.
    # Some games will refuse to start if it is set.
    # Unsetting it should not do any harm, and can be useful.
    unset LIBGL_ALWAYS_INDIRECT

    ##########################################################
    # main execution
    xinit $EXECL -- $NEWDISP vt$LVT -nolisten tcp -br &
    ##########################################################

    # set our new dislplay
    DISPLAY=$NEWDISP
    # wait some time for X to load
    sleep 4s

    # then we set useful parameters

    # disable non-linear mouse acceleration
    xset m 1 0

    # disable hard-coded default 10m screensaver
    xset s 0 0

    # while X is running, persistently do something useful
    # i.e. prevent apps from enabling mouse acceleration and screensaver
    while xset -q > /dev/null
    do 
    xset m 1 0
    xset s 0 0
    sleep 3s
    done


    wait
    sleep 5

General principle: set variables before xinit line, and xset parameters
after.

Save it as /usr/bin/xrun or better as /usr/local/bin/xrun (if you have
/usr/local/bin/ in your $PATH)

After that launching app in separate X display should be as easy as
typing

    xrun appname

remove lines containing zenity, if you do not have zenity installed.

  

Permission problems
-------------------

See General Troubleshooting#Session permissions for details.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Running_program_in_separate_X_display&oldid=289509"

Category:

-   X Server

-   This page was last modified on 19 December 2013, at 20:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
