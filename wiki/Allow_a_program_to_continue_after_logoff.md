Allow a program to continue after logoff
========================================

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Needs better     
                           introduction, the        
                           section #Conclusion is   
                           useless. (Discuss)       
  ------------------------ ------------------------ ------------------------

Have you ever had the need to leave a program running after you have
logged off?

This article will show you how to easily achieve this goal. The things
you need to do differ depending on if you are trying to keep a console
application running (e.g. mutt, centerICQ) or a X application running
(e.g. gaim, graveman). I have created a section for each scenario.

Contents
--------

-   1 Console applications
-   2 X applications
    -   2.1 Secondary X server
    -   2.2 xpra
-   3 Conclusion

Console applications
--------------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Needs expansion  
                           with regard to systemd   
                           and its                  
                           KillUserProcesses        
                           option. (Discuss)        
  ------------------------ ------------------------ ------------------------

You can use a terminal multiplexer to create a session and launch some
program inside it. Then you can detach from the session and leave it
running in background. When you reattach later (even after logout), you
will find the session in the state you left it.

Popular terminal multiplexers are screen and tmux.

X applications
--------------

> Secondary X server

xmove project seems dead, many applications do not work inside the xmove
pseudo server. So an other solution is using a secondary real X server.

With your favourite editor make a script with this content, use chmod to
make it executable (chmod a+x scriptname.sh).

    #!/bin/sh

    if [ $# -eq 0 ] ; then # check to see if arguments are given (color depth)
        a=24        # default color depth
    else
        a=$1        # use given argument
    fi

    if [ $a -ne 8 -a $a -ne 16 -a $a -ne 24 ] ; then
        echo "Invalid color depth. Use 8, 16, or 24."
        exit 1
    fi

    for display in 0 1 2 3 4 5 ; do
        if [ ! -f "/tmp/.X$display-lock" ] ; then
            exec startx -- :$display -depth $a -quiet
            exit 0
        fi
    done

    echo "No displays available."
    exit 1

executing this little script will start a new X server. Then you can
simply start your application and lock the server with xlock -mode blank
(you need the xlockmore package for using xlock.)

Do not start your application in the first X server. If it is not
already started, start the first and start a second one. Use the second
one for your applications.

This is important because some features, like AGP mode, works only on
one X server and other users of the computer will be annoyed if those
feature will be lacking because you started a X server for your own
purposes. So just use the second, the first will be full featured for
everyone who need.

> xpra

Xpra allows you to start X programs and leave them running after
disconnecting to reconnect again at a later time. It is possible to
start X programs on a remote machine, connect to the machine over ssh,
disconnect and reconnect again while the programs continue running.

Read the Xpra article for more information.

Conclusion
----------

Detaching programs is very useful in shared systems, you can easily
leave the machine to someone else while your programs continue to run.
At the moment, however, it is still easier to do this with console
applications. Since in the Linux world almost every task has its console
the only application it is a good idea use it with screen. In the above
example using transmission and screen is actually easier than ktorrent
and xmove.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Allow_a_program_to_continue_after_logoff&oldid=275017"

Category:

-   System administration

-   This page was last modified on 11 September 2013, at 07:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
