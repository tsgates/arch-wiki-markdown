xinitrc
=======

Related articles

-   Display manager
-   Start X at Login
-   Xorg
-   xprofile

The ~/.xinitrc file is a shell script read by xinit and by its front-end
startx. It is mainly used to execute desktop environments, window
managers and other programs when starting the X server (e.g., starting
daemons and setting environment variables). The xinit program starts the
X Window System server and works as first client program on systems that
are not using a display manager.

One of the main functions of ~/.xinitrc is to dictate which client for
the X Window System is invoked with startx or xinit programs on a
per-user basis. There exists numerous additional specifications and
commands that may also be added to ~/.xinitrc as you further customize
your system.

Most DMs also source the similar xprofile before xinit.

Contents
--------

-   1 Getting started
-   2 Configuration
-   3 Tips and tricks
    -   3.1 Override xinitrc from command line
    -   3.2 Making a DE/WM choice

Getting started
---------------

/etc/skel/ contains files and directories to provide sane defaults for
newly created user accounts. (The name skel is derived from the word
skeleton, because the files it contains form the basic structure for
users' home directories.) The xorg-xinit package will populate /etc/skel
with a framework .xinitrc file.

Tip:~/.xinitrc is a so-called 'dot' (.) file. Files in a *nix file
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

or

    $ xinit -- :1 -nolisten tcp vt$XDG_VTNR

> Note:

-   xinit doesn't read the system-wide /etc/X11/xinit/xserverrc file, so
    you either have to copy it into your home directory as name
    .xserverrc, or specify vt$XDG_VTNR as command line option in order
    to preserve session permissions.
-   xinit doesn't handle multiple sessions if you are already logged-in
    into some other virtual terminal. For that you have to specify
    session by appending -- :session_no. If you are already running X
    then you should start with :1 or more.

Your DE/WM of choice should now start up. You are now free to test your
keyboard with its layout, moving your mouse around and of course enjoy
the view.

Configuration
-------------

When a display manager is not used, it is important to keep in mind that
the life of the X session starts and ends with ~/.xinitrc. This means
that once the script quits, X quits regardless of whether you still have
running programs (including your window manager). Therefore it's
important that the window manager quitting and X quitting should
coincide. This is easily achieved by running the window manager as the
last program in the script.

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

Note that in the example above, programs such as xscreensaver, xsetroot
and sh are run in the background (& suffix added). Otherwise, the script
would halt and wait for each program and daemons to exit before
executing openbox-session. Also note that openbox-session is not
backgrounded. This ensures that the script will not quit until openbox
does.

Prepending the window manager openbox-session with exec is recommended
as it replaces the current process with that process, so the script will
stop running and X won't exit even if the process forks into the
background.

Tips and tricks
---------------

> Override xinitrc from command line

If you have a working ~/.xinitrc, but just want to try other WM/DE, you
can run it by issuing startx followed by the path to the window manager:

    $ startx /full/path/to/window-manager

Note that the full path is required. Optionally, you can also override
/etc/X11/xinit/xserverrc file (which stores the default X server
options) with custom options by appending them after --, e.g.:

    $ startx /usr/bin/enlightenment -- -nolisten tcp -br +bs -dpi 96 vt$XDG_VTNR

or

    $ xinit /usr/bin/enlightenment -- -nolisten tcp -br +bs -dpi 96 vt$XDG_VTNR

> Making a DE/WM choice

If you aren't using any graphical login manager or don't want to, you
might have to edit the ~/.xinitrc very frequently. This can be easily
solved by simple few line case addition, which will take the argument
and load the desired desktop environment or window manager.

The following example ~/.xinitrc shows how to start a particular DE/WM
with an argument:

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

    # Here Xfce is kept as default
    session=${1:-xfce}

    case $session in
            enlightenment) exec enlightenment_start;;
            fluxbox) exec startfluxbox;;
            gnome) exec gnome-session;;
            lxde) exec startlxde;;
            kde) exec startkde;;
            openbox) exec openbox-session;;
            xfce) exec startxfce4;;
            # No known session, try to run it as command
            *) exec $1;;                
    esac

Then copy the /etc/X11/xinit/xserverrc file into your home directory:

    $ cp /etc/X11/xinit/xserverrc ~/.xserverrc

After that, you can easily start a particular DE/WM by passing an
argument, e.g.:

    $ xinit
    $ xinit gnome
    $ xinit kde
    $ xinit wmaker

or

    $ startx
    $ startx ~/.xinitrc gnome
    $ startx ~/.xinitrc kde
    $ startx ~/.xinitrc wmaker

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xinitrc&oldid=301265"

Categories:

-   Desktop environments
-   X Server

-   This page was last modified on 24 February 2014, at 11:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
