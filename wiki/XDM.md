XDM
===

> Summary

XDM is the X Display Manager.

> Related

Display Manager

From XDM manual page:

Xdm manages a collection of X displays, which may be on the local host
or remote servers. The design of xdm was guided by the needs of X
terminals as well as The Open Group standard XDMCP, the X Display
Manager Control Protocol. Xdm provides services similar to those
provided by init, getty and login on character terminals: prompting for
login name and password, authenticating the user, and running a
"session."

XDM provides a simple and straightforward graphical login prompt.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Background wallpaper                                               |
| -   3 Multiple X sessions & Login in the window                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 XDM loops back to itself after login                         |
|     -   4.2 XDM does not update login records                            |
+--------------------------------------------------------------------------+

Installation
------------

Install xorg-xdm, available in the Official Repositories.

Use default launch script ~/.xsession Make the ~/.xsession file
executable.

    $ cp /etc/skel/.xsession /etc/skel/.xinitrc ~  # use default launch script

Or use a simple line (assume your favorite window manager is 'openbox')

    $ echo exec openbox > ~/.xsession  
    $ chmod 744 ~/.xsession

Without these modifications XDM will execute the xinitrc from
/etc/X11/xinit/xinitrc (See Xorg#Running for details).

If you would also like to use an Arch Linux theme for XDM, you can
optionally install the xdm-archlinux package, also available in the
Official Repositories.

See Display Manager for additional information.

Background wallpaper
--------------------

Here are some tips to make XDM look nicer:

-   Install the Quick Image Viewer:

    # pacman -S qiv

-   Make a directory to store background images. (e.g. /root/backgrounds
    or /usr/local/share/backgrounds)

-   Place your images in the directory. If you do not have any try [1]
    for starters.

-   Edit /etc/X11/xdm/Xsetup_0. Change the xconsole command to:

     /usr/bin/qiv -zr /root/backgrounds/*

-   Edit /etc/X11/xdm/Xresources. Add/replace the following defines:

     xlogingreetFont:  -adobe-helvetica-bold-o-normal--20------iso8859-1
     xloginfont:       -adobe-helvetica-medium-r-normal--14------iso8859-1
     xloginpromptFont: -adobe-helvetica-bold-r-normal--14------iso8859-1
     xloginfailFont:   -adobe-helvetica-bold-r-normal--14------iso8859-1
     xlogin*frameWidth: 1
     xlogin*innerFramesWidth: 1
     xlogin*logoPadding: 0
     xlogin*geometry:    300x175-0-0

Comment out the logo defines:

     #xlogin*logoFileName: /usr/X11R6/lib/X11/xdm/pixmaps/xorg.xpm
     #xlogin*logoFileName: /usr/X11R6/lib/X11/xdm/pixmaps/xorg-bw.xpm

For the exact meaning of the definitions, see the man page of xdm.

-   Update /etc/pacman.conf so the changes do not get erased:

     ~NoUpgrade   = etc/X11/xdm/Xsetup_0 etc/X11/xdm/Xresources

The changes will now give you a random wallpaper image and move the
login prompt to the bottom-right edge of the screen.

Multiple X sessions & Login in the window
-----------------------------------------

With the Xdmcp enable, you can easily run multiple X sessions
simultaneously on the same machine.

    # X -query ip_xdmcp_server :2 

This will launch the second session, in window you need
xorg-server-xephyr

    # Xephyr -query this_machine_ip :2 

Troubleshooting
---------------

> XDM loops back to itself after login

The current version of the xorg-xdm package, available in the Official
Repositories is patched to register sessions with ConsoleKit by default.
If ConsoleKit is not running, XDM will fail to succesfully launch an X
session. D-Bus can be used invoke ConsoleKit when called upon by XDM.

Make sure that the dbus package, available in the Official Repositories
is installed and then make sure dbus is included in the DAEMONS array in
/etc/rc.conf.

When using pure systemd with logind, instead of consolekit which is now
deprecated, systemd will start dbus automatically. To use xdm use

    # systemctl enable xdm.service

or

    # systemctl enable xdm-archlinux.service

Also, make sure that you are actually starting your window manager, for
example with the command xmonad in ~/.xsession, and that ~/.xsession has
the correct permissions of 774. This file is installed by xorg-xinit.

> XDM does not update login records

The vanilla config of XDM calls /etc/X11/xdm/GiveConsole for the startup
of display :0, whereas otherwise it calls /etc/X11/xdm/Xstartup. Since
only the latter contains a call to /usr/bin/sessreg, the login record
/var/run/utmp is not updated for a login on display :0. As a
consequence, the output of who does not necessarily list the user after
login through XDM. This was already discussed in the bug report
FS#26395.

As a simple fix, append the following line to /etc/X11/xdm/GiveConsole:

    exec /usr/bin/sessreg -a -w /var/log/wtmp -u /var/run/utmp -x /etc/X11/xdm/Xservers -l $DISPLAY -h "" $USER

This change also enables the getuser function presented in Acpid to
work.

Retrieved from
"https://wiki.archlinux.org/index.php?title=XDM&oldid=254357"

Category:

-   Display managers
