LXDM
====

Related articles

-   LXDE
-   Display manager

LXDM is a lightweight display manager for the LXDE desktop environment.
The UI is implemented with GTK+ 2. It is still in the early stages of
development.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Default session
        -   2.1.1 Globally
        -   2.1.2 Per user
    -   2.2 Autologin
    -   2.3 Shutdown and reboot commands
-   3 Tips and tricks
    -   3.1 Adding face icons
    -   3.2 Simultaneous users and switching users
    -   3.3 Themes

Installation
------------

The lxdm package is available in the official repositories. The
development package, lxdm-git, is available in the AUR.

Currently, lxdm provides the lxdm systemd service. Enable it to start
LXDM at boot.

Configuration
-------------

The configuration files for LXDM are all located in /etc/lxdm/. The main
configuration file is lxdm.conf, and is well documented in its comments.
Another file, Xsession, is the systemwide x session configuration file
and should generally not be edited. The other files in this folder are
all shell scripts, which are run when certain events happen in LXDM.

These are:

1.  LoginReady is executed with root privileges when LXDM is ready to
    show the login window.
2.  PreLogin is run as root before logging a user in.
3.  PostLogin is run as the logged-in user right after he has logged in.
4.  PostLogout is run as the logged-in user right after he has logged
    out.
5.  PreReboot is run as root before rebooting with LXDM.
6.  PreShutdown is run as root before poweroff with LXDM.

> Default session

It can be specified which session will be loaded when the users select
the 'Default' session from the session list. Note that the user setting
takes preference over global setting.

Globally

Edit /etc/lxdm/lxdm.conf and change the session line to whatever session
or DE is desired:

    session=/usr/bin/startlxde

Example using Xfce:

    session=/usr/bin/startxfce4

Example using Openbox:

    session=/usr/bin/openbox-session

Example using GNOME:

    session=/usr/bin/gnome-session

This is useful for themes that have no visible session selection box,
and if experiencing trouble using autologin.

Per user

To define an individual user's preferred session, simply edit his/her
respective ~/.dmrc to define the selection.

Example: user1 wants Xfce4, user2 wants Cinnamon, and user3 wants GNOME:

For user1:

    [Desktop]
    Session=xfce

For user2:

    [Desktop]
    Session=cinnamon

For user3:

    [Desktop]
    Session=gnome

> Autologin

To log in to one account automatically, without providing a password,
find the line in /etc/lxdm/lxdm.conf that looks like this:

    #autologin=dgod

Uncomment it, substituting the target user instead of "dgod".

This will cause LXDM to automatically login to the specified account
when it first starts up. However, if one were to log out of that
account, one would have to enter its password to log back into it. To
avoid this, delete the password:

    $ passwd -d username

> Shutdown and reboot commands

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: I think lxdm     
                           defines shutdown and     
                           reboot by default now.   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Shutdown and reboot commands can be configured in /etc/lxdm/lxdm.conf by
adding the [cmd] section:

    [cmd]
    # reboot command
    reboot=/usr/bin/systemctl reboot

    # shutdown command
    shutdown=/usr/bin/systemctl poweroff

Tips and tricks
---------------

> Adding face icons

A 96x96 px image (jpg or png) can optionally be displayed on a per-user
basis replacing the stock icon. Simply copy or symlink the target image
to $HOME/.FACE. The gnome-control-center package supplies some default
icons suitable for the lxdm screen. Look under /usr/share/pixmaps/faces
after installing that package.

Note:Users need not keep gnome-control-center installed to use this
images. Simply install it, copy them elsewhere, and remove it.

> Simultaneous users and switching users

LXDM allows multiple users to be logged into different ttys at the same
time. The following command is used to allow another user to login
without logging out the current user:

    $ lxdm -c USER_SWITCH

Note:When the new user logs in, his/her session is now on the NEXT tty
from tty7. For example, user1 logs in and issues the USER_SWITCH
command. Now user2 logs in. User2 will be on tty7 while user1 will be on
tty1.

If you use the Xfce desktop, the Switch User functionality of its Action
Button panel item specifically looks for the gdmflexiserver executable
in order to enable itself. If you provide it with an executable shell
script /usr/bin/gdmflexiserver consisting of

    #!/bin/sh
    /usr/bin/lxdm -c USER_SWITCH

then user switching in Xfce should work fine also with LXDM.

Xscreensaver can also perform this task. For more, see the
Xscreensaver#LXDM article.

> Themes

The LXDM themes are localized in /usr/share/lxdm/themes.

There is only one theme provided with LXDM, namely Industrial. To
display the background file wave.svg which is part of this theme, make
sure you have librsvg installed.

There are 2 themes provided with lxdm-git. ArchStripes and ArchDark. You
can configure them on /etc/lxdm/lxdm.conf in theme=theme_name

Retrieved from
"https://wiki.archlinux.org/index.php?title=LXDM&oldid=303930"

Category:

-   Display managers

-   This page was last modified on 10 March 2014, at 17:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
