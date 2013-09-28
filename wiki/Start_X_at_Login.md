Start X at Login
================

Summary

Starting X automatically at login to a virtual terminal.

Related

systemd/User

Automatic login to virtual console

Display Manager

Silent boot

Xinitrc

A display manager can be used to provide a login screen and start the X
server. This article explains how this can be done using an existing
virtual terminal.

To manually start X, startx is used, which will execute ~/.xinitrc,
which may be customized to start the window manager of choice as
described in the xinitrc article.

Shell profile file
------------------

Note:This runs X on the same tty used to login, which is required in
order to maintain the login session.

-   For Bash, add the following to the bottom of ~/.bash_profile. If the
    file does not exist, copy a skeleton version from
    /etc/skel/.bash_profile.

-   For Zsh, add it to ~/.zprofile instead.

    [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

Note:You can replace the -eq 1 comparison with one like -le 3 (for vt1
to vt3) if you want to use graphical logins on more than one VT.

Note:X must always be run on the same tty where the login occurred, to
preserve the logind session. This is handled by the default
/etc/X11/xinit/xserverrc.

Tips
----

-   This method can be combined with automatic login to virtual console.
    When doing this you have to set correct dependencies for the
    autologin systemd service to ensure that dbus is started before
    ~/.xinitrc is read and hence pulseaudio started (see: BBS#155416)
-   If you would like to remain logged in when the X session ends,
    remove exec.
-   To redirect the output of the X session to a file, create an alias:

    alias startx='startx &> ~/.xlog'

Retrieved from
"https://wiki.archlinux.org/index.php?title=Start_X_at_Login&oldid=254230"

Categories:

-   X Server
-   Boot process
