Start X at Login
================

Related articles

-   systemd/User
-   Automatic login to virtual console
-   Display manager
-   Silent boot
-   Xinitrc

This article explains how to have the X server start automatically right
after logging in at a virtual terminal. This is achieved by running the
startx command, whose behaviour can be customized as described in the
xinitrc article, for example for choosing what window manager to launch.
Alternatively, a display manager can be used to start X automatically
and provide a graphical login screen.

Shell profile files
-------------------

Note:These solutions run X on the same tty used to login, which is
required in order to maintain the login session.

-   For Bash, add the following to the bottom of ~/.bash_profile. If the
    file does not exist, copy a skeleton version from
    /etc/skel/.bash_profile.   
     For Zsh, add it to ~/.zprofile instead.

    [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

> Note:

-   You can replace the -eq 1 comparison with one like -le 3 (for vt1 to
    vt3) if you want to use graphical logins on more than one VT.
-   X must always be run on the same tty where the login occurred, to
    preserve the logind session. This is handled by the default
    /etc/X11/xinit/xserverrc.

-   For Fish, add the following to the bottom of your
    ~/.config/fish/config.fish.

    # start X at login
    if status --is-login
        if test -z "$DISPLAY" -a $XDG_VTNR = 1
            exec startx
        end
    end

Tips and tricks
---------------

-   This method can be combined with automatic login to virtual console.
    When doing this you have to set correct dependencies for the
    autologin systemd service to ensure that dbus is started before
    ~/.xinitrc is read and hence pulseaudio started (see: BBS#155416)
-   If you would like to remain logged in when the X session ends,
    remove exec.
-   To redirect the output of the X session to a file, create an alias:

    alias startx='startx &> ~/.xlog'

Retrieved from
"https://wiki.archlinux.org/index.php?title=Start_X_at_Login&oldid=301266"

Categories:

-   X Server
-   Boot process

-   This page was last modified on 24 February 2014, at 11:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
