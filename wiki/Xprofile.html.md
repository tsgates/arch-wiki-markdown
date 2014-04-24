xprofile
========

Related articles

-   xinitrc

An xprofile file, ~/.xprofile and /etc/xprofile, allows you to execute
commands at the beginning of the X user session - before the Window
manager is started. Therefore it cannot be used to start window-based
applications. See this article for that. Xprofile is of particular use
for autostarting programs with a session, started from a Display
manager, when that session does not have its own autostart facility - a
standalone Window manager for example.

xprofile is similar in syntax and in concept to xinitrc (~/.xinitrc and
/etc/X11/xinit/xinitrc.d/).

Compatibility
-------------

xprofile (and xinitrc) files are natively sourced by

-   GDM (/etc/gdm/Xsession)
-   KDM (/usr/share/config/kdm/Xsession)
-   LightDM (/etc/lightdm/Xsession)
-   LXDM (/etc/lxdm/Xsession)

> Making it compatible with xinit

It is possible to make xprofile compatible with these programs:

-   startx
-   xinit
-   XDM
-   SLiM
-   any other Display manager which uses ~/.xsession or ~/.xinitrc

All of these execute, directly or indirectly, ~/.xinitrc (usually copied
from /etc/skel/.xinitrc), or /etc/X11/xinit/xinitrc if it does not
exist. That is why we have to source xprofile from these files.

    ~/.xinitrc and /etc/X11/xinit/xinitrc and /etc/skel/.xinitrc

    #!/bin/sh

    # Make sure this is before the 'exec' command or it won't be sourced.
    [ -f /etc/xprofile ] && source /etc/xprofile
    [ -f ~/.xprofile ] && source ~/.xprofile

    ...

xinitrc.d/* files are already sourced from the default xinitrc file.

Configuration
-------------

Firstly, create the file ~/.xprofile if it does not exist already. Then,
simply add the commands for the programs you wish to start with the
session. See below:

    ~/.xprofile

    tint2 &
    nm-applet &

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xprofile&oldid=303896"

Category:

-   X Server

-   This page was last modified on 10 March 2014, at 12:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
