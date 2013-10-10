LXDM
====

> Summary

LXDM is the lightweight display manager aimed to replace gdm in LXDE
distros. The UI is implemented with GTK+. It is still in early stages of
development.

> Related

Display_Manager

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
| -   3 Configuration                                                      |
|     -   3.1 Unlocking Keyrings upon Login                                |
|     -   3.2 Adding Face Icons                                            |
|     -   3.3 Default session                                              |
|         -   3.3.1 Globally                                               |
|         -   3.3.2 Per user                                               |
|                                                                          |
|     -   3.4 Autologin                                                    |
|     -   3.5 Expected Logout Behavior                                     |
|     -   3.6 Sessionlist                                                  |
|     -   3.7 Simultaneous Users and Switching Users                       |
|     -   3.8 PulseAudio                                                   |
|     -   3.9 Themes                                                       |
+--------------------------------------------------------------------------+

Installation
------------

The lxdm package which is available in the official repositories or
lxdm-git is available in the AUR.

Usage
-----

Currently, lxdm provides an lxdm.service file. Enable it like any other
systemd service:

    # systemctl enable lxdm

Configuration
-------------

Warning:The language select control in lxdm.conf is sometimes required
and sometimes not. Set lang= to inverse value of itself when LXDM
potentially enters a boot loop and fails to load target sessions.

The configuration files for LXDM are all located in /etc/lxdm. The main
configuration file is lxdm.conf, and is well documented in its comments.
Another file, Xsession, is the systemwide x session configuration file
and should generally not be edited. The other files in this folder are
all bash scripts, which are run when certain events happen in LXDM.

These are:

1.  LoginReady: Is executed with root privileges when LXDM is ready to
    show the login window.
2.  PreLogin: Is run as root before logging a user in.
3.  PostLogin: Is run as the logged-in user right after they have logged
    in.
4.  PostLogout: Is run as the logged-in user right after they have
    logged out.
5.  PreReboot: Is run as root before rebooting with LXDM.
6.  PreShutdown: Is run as root before poweroff with LXDM.

> Unlocking Keyrings upon Login

When using a key manager such as gnome-keyring to manage passwords for
ssh keys, /etc/pam.d/lxdm should be adjusted to allow users to unlock
keyrings upon login if desired. Add the following to the package
provided /etc/pam.d/lxdm:

    auth            optional        pam_gnome_keyring.so
    session         optional        pam_gnome_keyring.so auto_start

> Adding Face Icons

A 96x96 px image (jpg or png) can optionally be displayed on a per-user
basis replacing the stock icon. Simply copy or symlink the target image
to $HOME/.face.

The gnome-control-center package supplies some default icons suitable
for the lxdm screen. Look under /usr/share/pixmaps/faces after
installing that package.

Note:Users need not keep gnome-control-center installed to use this
images. Simply install it, copy them elsewhere, and remove it.

> Default session

Globally

Edit /etc/lxdm/lxdm.conf and change the line:

    session=/usr/bin/startlxde

To whatever session or DE is desired.

Example using xfce:

    session=/usr/bin/startxfce4

This is useful for themes that have no visible session selection box,
and if experiencing trouble using autologin.

Per user

To define an individual user's preferred session, simply edit his/her
respective ~/.dmrc to define the selection.

Example: user1 wants xfce4, user2 wants cinnamon, and user3 wants gnome:

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

    #autologin=username

Uncomment it, substituting the target user instead of "username".

This will cause LXDM to automatically login to the specified account
when it first starts up. However, if one were to log out of that
account, one would have to enter its password to log back into it; if
the password was empty, that user will be unable to log into the
account. To remedy this and be able to log into the account without
entering a password, first delete the password:

    $ passwd -d USERNAME

Then, edit the PAM file for LXDM, which is /etc/pam.d/lxdm. The files in
this directory describe how users are authenticated by the various
installed programs that need to do some sort of authentication. Change
the line that says

    auth    required    pam_unix.so

to this:

    auth    required    pam_unix.so nullok

This will tell the pam_unix authentication module that blank passwords
are to be accepted. After making this change, LXDM will log into
accounts with blank passwords.

> Expected Logout Behavior

What might be slightly surprising with LXDM is that, by default, it does
not clear the last user's desktop background or kill the user's
processes when that user logs out. Users desiring this behavior, can
edit /etc/lxdm/PostLogout like this:

    #!/bin/sh

    # Kills all your processes when you log out.
    killall --user $USER -TERM

    # Sets the desktop background to solid black. Useful if you have multiple monitors.
    xsetroot -solid black

Note:This will kill daemons such as tmux, urxvtd, etc.

Users can replace killall command with the following to exclude ssh and
screen processes from termination:

    ps --user $USER | egrep -v "ssh|screen" | cut -b11-15 | xargs -t kill

Or to (hopefully) only kill X-Processes and childs:

    ps --user $USER | cut -f1,2 -d' ' | egrep "\?$" | cut -d' ' -f1 | xargs -t kill

> Sessionlist

To add/remove entries to LXDM's session dropdown menu; create/remove the
.desktop files in /usr/share/xsessions as desired. A typical .desktop
file will look something like:

    [Desktop Entry]
    Encoding=UTF-8
    Name=Openbox
    Comment=Log in using the Openbox window manager (without a session manager)
    Exec=/usr/bin/openbox-session
    TryExec=/usr/bin/openbox-session
    Icon=openbox.png
    Type=XSession

> Simultaneous Users and Switching Users

LXDM allows multiple users to be logged into different ttys at the same
time. The following command is used to allow another user to login
without logging out the current user:

    $ lxdm -c USER_SWITCH

Note:When the new user logs in, his/her session is now on the NEXT tty.
For example, user1 logs in and issues the USER_SWITCH command. Now user2
logs in. User2 will be on tty8 while user1 will be on tty7.

Xscreensaver can also perform this task. For more, see the
Xscreensaver#LXDM article.

> PulseAudio

After a user logs out, subsequent users have no access to PulseAudio.
The reason is that PulseAudio stores server credentials as properties on
the X11 root window, and since LXDM does not restart the X server, these
properties are not cleaned up and prevent the sound server from starting
up for the next users. To remove these properties on logout, add the
following line to /etc/lxdm/PostLogout:

    test -x /usr/bin/pax11publish && /usr/bin/pax11publish -r

> Themes

There is only one theme provided with lxdm, namely Industrial. To
display the background file wave.svg which is part of this theme, make
sure you have librsvg installed.

Retrieved from
"https://wiki.archlinux.org/index.php?title=LXDM&oldid=255002"

Category:

-   Display managers
