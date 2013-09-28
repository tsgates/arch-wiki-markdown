xinitrc
=======

Summary

An overview of the primary configuration file for the xinit (startx)
program.

Related

Display Manager

Start X at Login

Xorg

xprofile

The ~/.xinitrc file is a shell script read by xinit and startx. It is
mainly used to execute desktop environments, window managers and other
programs when starting the X server (e.g., starting daemons and setting
environment variables). The xinit and startx programs starts the X
Window System and works as first client programs on systems that cannot
start X directly from /etc/init, or in environments that use multiple
window systems.

One of the main functions of ~/.xinitrc is to dictate which client for
the X Window System is invoked with the /usr/bin/startx and/or
/usr/bin/xinit program on a per-user basis. There exists numerous
additional specifications and commands that may also be added to
~/.xinitrc as you further customize your system.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Getting started                                                    |
|     -   1.1 Making a DE/WM choice                                        |
|     -   1.2 Preserving the session                                       |
|                                                                          |
| -   2 File examples                                                      |
| -   3 File configuration                                                 |
|     -   3.1 On the command line                                          |
|     -   3.2 At startup                                                   |
+--------------------------------------------------------------------------+

Getting started
---------------

/etc/skel/ contains files and directories to provide sane defaults for
newly created user accounts. (The name skel is derived from the word
skeleton, because the files it contains form the basic structure for
users' home directories.) The xorg-xinit package will populate /etc/skel
with a framework .xinitrc file.

Note:~/.xinitrc is a so-called 'dot' (.) file. Files in a *nix file
system which are preceded with a dot (.) are 'hidden' and will not show
up with a regular ls command, usually for the sake of keeping
directories tidy. Dot files may be seen by running ls -A. The 'rc'
denotes Run Commands and simply indicates that it is a configuration
file. Since it controls how a program runs, it is (although historically
incorrect) also said to stand for "Run Control".

Copy the sample /etc/skel/.xinitrc file to your home directory:

    $ cp /etc/skel/.xinitrc ~

Now, edit ~/.xinitrc and uncomment the line that corresponds to your
DE/WM. For example, if you want to test your basic X configuration
(mouse, keyboard, graphics resolution), you can simply use xterm:

    #!/bin/sh
    #
    # ~/.xinitrc
    #
    # Executed by startx (run your window manager from here)

    if [ -d /etc/X11/xinit/xinitrc.d ]; then
      for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
      done
      unset f
    fi

    # exec gnome-session
    # exec startkde
    # exec startxfce4
    # exec wmaker
    # exec icewm
    # exec blackbox
    # exec fluxbox
    # exec openbox-session
    # ...or the Window Manager of your choice
    exec xterm

Note:Make sure to uncomment only one exec line, since that will be the
last command run from the script; all the following lines will just be
ignored. Do NOT attempt to background your WM by appending a `&` to the
line.

After editing ~/.xinitrc properly, it's time to run X. To run X as a
non-root user, issue:

    $ startx
    $ xinit
    $ xinit -- :1

Note:xinit doesn't handle multiple session if you are already logged-in
into some other vt. for that you have to specify session by appending
-- :<session_no>. If you are already running X then you should start
with :1 or more.

Your DE/WM of choice should now start up. You are now free to test your
keyboard with its layout, moving your mouse around and of course enjoy
the view.

> Making a DE/WM choice

If you arn't using any graphical login manager or don't want to, you
might have to edit the ~/.xinitrc very frequently. This can be easly
solved by simple few line case addition which will take the argument and
load the desire DE/WM.

    #!/bin/sh
    #
    # ~/.xinitrc
    #
    # Executed by startx (run your window manager from here)

    if [ -d /etc/X11/xinit/xinitrc.d ]; then
      for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
      done
      unset f
    fi

    # Here xfce is kept as default
    case $1 in
        gnome) exec gnome-session;;
        kde) exec startkde;;
        xfce);;
        *) exec startxfce4;;
    esac

After editing ~/.xinitrc, you can easily start desire DE/WM by passing
argument.

    $ xinit
    $ xinit gnome
    $ xinit kde
    $ xinit xfce -- :1

> Preserving the session

X must always be run on the same tty where the login occurred, to
preserve the logind session. This is handled by the default
/etc/X11/xinit/xserverrc. Also see General Troubleshooting#Session
permissions for related issues.

Note:In the past ck-launch-session was used to start a new session
instead of simply not breaking the old one. There is no equivalent to
this hack with logind, and a multi-seat aware display manager is
required to run X on an arbitrary tty.

File examples
-------------

Following is a simple ~/.xinitrc file example, including some startup
programs:

    ~/.xinitrc

    #!/bin/sh

    if [ -d /etc/X11/xinit/xinitrc.d ]; then
      for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
      done
      unset f
    fi

    xrdb -merge ~/.Xresources         # update x resources db

    xscreensaver -no-splash &         # starts screensaver daemon 
    xsetroot -cursor_name left_ptr &  # sets the cursor icon
    sh ~/.fehbg &                     # sets the background image

    exec openbox-session              # starts the window manager

Prepending exec is recommended as it replaces the current process with
the process, so the script will stop running and X won't exit even if
the process forks into the background.

File configuration
------------------

When a display manager is not used, it is important to keep in mind that
the life of the X session starts and ends with ~/.xinitrc. This means
that once the script quits, X quits regardless of whether you still have
running programs (including your window manager). Therefore it's
important that the window manager quitting and X quitting should
coincide. This is easily achieved by running the window manager as the
last program in the script.

Note that in the first example above, programs such as cairo-compmgr,
xscreensaver, xsetroot and sh are run in the background (& suffix
added). Otherwise, the script would halt and wait for each program and
daemons to exit before executing openbox-session. Also note that
openbox-session is not backgrounded. This ensures that the script will
not quit until openbox does.

The following sections explains how to configure ~/.xinitrc for Multiple
WMs and DEs.

> On the command line

If you have a working ~/.xinitrc, but just want to try other WM/DE you
can run it by issuing xinit followed by the path to the window manager:

    xinit /full/path/to/window-manager

Note that the full path is required. Optionally, you can pass options to
the X server after appending -- - e.g.:

    xinit /usr/bin/enlightenment -- -br +bs -dpi 96

The following example ~/.xinitrc shows how to start a particular window
manager with an argument:

    ~/.xinitrc

    #!/bin/sh
    #
    # ~/.xinitrc
    #
    # Executed by startx (run your window manager from here)

    if [ -d /etc/X11/xinit/xinitrc.d ]; then
      for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
      done
      unset f
    fi

    if [[ $1 == "fluxbox" ]]
    then
      exec startfluxbox
    elif [[ $1 == "spectrwm" ]]
    then
      exec spectrwm
    else
      echo "Choose a window manager"
    fi

Using this example you can start fluxbox or spectrwm with the command
xinit fluxbox or xinit spectrwm.

> At startup

See Start X at Login.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xinitrc&oldid=255258"

Categories:

-   Desktop environments
-   X Server
