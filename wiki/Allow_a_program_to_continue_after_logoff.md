Allow a program to continue after logoff
========================================

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Have you ever had the need to leave a program running after you have
logged off?

This article will show you how to easily achieve this goal. The things
you need to do differ depending on if you are trying to keep a console
application running (e.g. mutt, centerICQ) or a X application running
(e.g. gaim, graveman). I have created a section for each scenario.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Console applications                                               |
| -   2 X applications                                                     |
|     -   2.1 X move                                                       |
|     -   2.2 Secondary X server                                           |
|     -   2.3 xpra                                                         |
|                                                                          |
| -   3 Conclusion                                                         |
| -   4 Additional Resources                                               |
+--------------------------------------------------------------------------+

Console applications
--------------------

The program that allows you to detach a console application is screen.
Use pacman to install it:

    # pacman -S screen

To create a session name run the command:

    $ screen -OUS [session_name]

This command print a list of pid.tty.host strings identifying your
screen sessions

    $ screen -list

To attach a screen to the current terminal

    $ screen -x [session_name]

This shortcut can be used to detach screen from the terminal. Execution
will continue even after the screen is detached.

    C-a d
    C-a C-d   

screen has many other functionalities; we will use only showcase the one
we need. Read man screen for more details.

You should modify /etc/screenrc, the global settings file, to add the
two settings. Use your favorite editor to edit /etc/screenrc and add
these two lines in the bottom:

    vbell off
    startup_message off

This allows screen to start without delays and it won't make an ugly
screen flash instead of a bell sound.

When starting screen it will not be immediately apparent that you have
done anything. In fact, you are actually working inside a new shell.
Once you start a program in the shell, you can allow it to continue
working, even if you log out. When you want to close the terminal press
CTRL+a d to detach the shell. The console will return in the state it
was before calling screen, you can close it safely and the program will
continue running in the background.

To restore your program just start screen with the -r(restore) option:
screen -r. You will be in the exact place where you left it. Even if you
closed the window or logged off!

X applications
--------------

> X move

To detach an X application you need xmove. Like screen, xmove has some
similar capabilities. Read the manpage for more info.

Install it with pacman:

    $ pacman -S xmove

xmove is a pseudo server X. It is pseudo since it does not actually do
the work of a server, but instead it speaks with an existing X server.

Open a terminal and start xmove with

    $ /usr/bin/xmove -server :0 -port 9 &

Do not forget the &, this will start xmove in the background. It will
continue working until explicitly killed with kill -TERM `pidof xmove`.

Now, xmove is working as X server in port :9 speaking with the X server
in port :0. Zero is usually the port of the first X server, however if
you know your X server is somewhere else change the line accordingly.

If more than one user needs to use xmove at the same time, every user
needs to starts his copy of xmove in a different port. If xhost allows
it, the server can be shared.

Let me explain how to detach with a little example: we want to start
ktorrent' and let it continue seeding after log off.

    $ export DISPLAY=:9
    $ nohup ktorrent &
    $ exit

of if you like it compact

    $ env DISPLAY=:9 nohup ktorrent & exit

ktorrent will start, lets start the downloading of the .torrent we need.
After a while we want log off without interrupting ktorrent's work. Lets
start an other terminal:

    $ export DISPLAY=:9
    $ xmovectrl -list
    4      ktorrent        :0
    $ xmovectrl -move -suspend 4

xmovectrl controls the xmove server, the command -list gives a list of
the attached applications. The first column gives an id of the window.
The same id used by the -mode command.

The command -move moves the window from a X server to an other. Putting
-suspend will make the window appear nowhere while letting the program
continue working.

nohup may be unnecessary; many X applications ignore the hang up signal
by default. To test an application start it from a terminal putting & at
the end of the line, close the terminal. If the X application continues
nohup is not necessary.

To restore the window and work with the application again you need to
start a terminal, set the DISPLAY variable and move the window back to
:0. In our example:

    $ export DISPLAY=:9
    $ xmovectrl -list
    4    ktorrent    suspended
    $ xmovectrl -move :0 4

The ktorrent window will be restored even after log off.

If you use xmove often you may like the idea of making an alias of
xmovectrl so you do not need to set DISPLAY every time. To do that add
to your ~/.bashrc (or other shell initializing file):

    alias xmovectrl='env DISPLAY=:9 xmovectrl'

This alias will set DISPLAY for you every time you call xmovectrl.

xmove X server has less capabilities than the usual server. Some
applications will not work well, or not work at all. Make some tests
before using it with vital applications!

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

Xpra, which is available in AUR (as xpra-winswitch), allows you to start
X programs and leave them running after disconnecting to reconnect again
at a later time. It is possible to start X programs on a remote machine,
connect to the machine over ssh, disconnect and reconnect again while
the programs continue running.

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

Additional Resources
--------------------

-   Tmux - A BSD licensed alternative to screen.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Allow_a_program_to_continue_after_logoff&oldid=241742"

Category:

-   System administration
