xprofile
========

/etc/xprofile and ~/.xprofile allow you to execute commands at the
beginning of the X user session, before the Window Manager is started.
Therefore it cannot be used to start window-based applications. See
Autostarting#Graphical for that.

Compatibility
-------------

xprofiles are natively sourced by KDM (/usr/share/config/kdm/Xsession),
GDM (/etc/gdm/Xsession) and LXDM (/etc/lxdm/Xsession).

> Making it compatible with xinit

It is possible to make xprofiles compatible with these programs:

-   startx
-   xinit
-   XDM
-   SLiM
-   any other Display Manager who uses ~/.xsession or ~/.xinitrc

All of these execute, directly or indirectly, ~/.xinitrc (usually copied
from /etc/skel/.xinitrc), or /etc/X11/xinit/xinitrc if it doesn't exist.
That's why we have to source xprofiles from these files.

    ~/.xinitrc and /etc/X11/xinit/xinitrc and /etc/skel/.xinitrc

    #!/bin/sh

    # Make sure this is before the 'exec' command or it won't be sourced.
    [ -f /etc/xprofile ] && source /etc/xprofile
    [ -f ~/.xprofile ] && source ~/.xprofile

    ...

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xprofile&oldid=245767"

Category:

-   X Server
