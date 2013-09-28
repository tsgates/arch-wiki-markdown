Qingy
=====

Qingy is a replacement for Getty and login-managers like slim, kdm gdm
and so on, using DirectFB to provide a fast, nice GUI without the
overhead of the X Window System. It allows users to log in and start the
session of their choice (text console, gnome, kde, wmaker, etc.).
Running several X sessions is also possible.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 How to get qingy?                                                  |
| -   2 Replace *getty with qingy                                          |
| -   3 Configuring qingy                                                  |
| -   4 Starting X                                                         |
| -   5 Adding a session entry                                             |
|     -   5.1 Text mode session                                            |
|     -   5.2 X mode session                                               |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 Synaptic touchpad and keyboard issue                         |
+--------------------------------------------------------------------------+

How to get qingy?
-----------------

First you need a working DirectFB. I'm recommending Uvesafb but if you
have some graphical issues with it use vesafb. Qingy may not work with
KMS.

A package is available in the [community] repo. To install:

    # pacman -S qingy 

Several extra themes are also available. In [community] repo, there is
an Arch specific theme:

    # pacman -S qingy-theme-arch

A package of several various themes is available in AUR:

-   qingy-themes

Replace *getty with qingy
-------------------------

Simply enable qingy@.service on the tty that you want it on and remove
getty from that tty:

    # systemctl enable qingy@ttyX
    # systemctl disable getty@ttyX

where X is the tty you want qingy to be on. Do this as many times as
needed.

Also, you need to mask the qingy service with:

    # systemctl mask getty@ttyX

for each of the ttys you enabled qingy on.

Configuring qingy
-----------------

You can configure qingy by editing /etc/qingy/settings.

The default settings for X are fine so only edit them if you really know
what you are doing.

    # Full path to the X server
    #x_server = "/usr/bin/Xorg"
    # Full path to the 'xinit' executable
    xinit = "/usr/bin/xinit"
    # Parameter we should pass to the X server
    x_args = "-nolisten tcp -br"

I recommend to set

    log_facilities = console, file

so you can look for errors in /var/log/qingy.log, too.

All other options are well explained.

You may need to set the path to the X server e.g.

    # Full path to the X server
    x_server = "/usr/bin/X"

Starting X
----------

Please do note that .xinitrc is different from .xsession. The default
login script, .xinitrc, works with startx, but graphical login managers
generally do not look for .xinitrc. Instead, they look for a file named
.xsession in your home directory.

If you want to start X with qingy you need to edit your .xsession.

Here a default .xsession for qingy.

    #!/bin/sh
    exec <login-shell command> <window manager starter>

An example:

    #!/bin/sh
    exec bash --login -c 'openbox-session'

The start of the window manager using a login shell is needed because
qingy starts the X-session directly without the help of a shell. This
causes issues like no umlauts in xterm and malfunction of control keys
like "Home", "End", "Del" and so on in the terminal.

For more details, visit the Ubuntu CustomXSession wiki at [1]

If you want your X sessions to be started in an active state, you may
need to add the following lines to the end of /etc/pam.d/qingy.

    session    optional	/lib/security/pam_loginuid.so
    session    optional	/lib/security/pam_ck_connector.so

Active sessions allow you to access network controles,
shutdown/susspend/hibernate funtionality, and drives you wish to mount
via your DE/WM.

Adding a session entry
----------------------

If you've changed the variable x_sessions or text_session in the config
file of qingy replace the following paths with the path you've set.

> Text mode session

Create a file /etc/qingy/sessions/<sessionname>.

The file name is shown as entry in the session list.

The file should be a shell script. For an example have a look into
/etc/qingy/sessions/emacs.

> X mode session

Create the folder /etc/X11/Sessions/ and save a new script file into it.
(see Text mode session)

The name of the file is shown in the session list.

Troubleshooting
---------------

> Synaptic touchpad and keyboard issue

Qingy (and quite possibly other DirectFB applications) has some issues
using Synaptics touchpad. Also the keyboard can behave strangely (like
if each keys were pressed twice).

This can be solved by adding:

-   If each keypress was doubled

    disable-module=keyboard

-   If mouse acts funny

    disable-module=ps2mouse
    disable-module=serialmouse

to /etc/directfbrc. If the file does not exist, create it. This will
enable you to use your touchpad, however some extra functionality like
tapping or tap-dragging might not work.

On computers with several pointing devices, such as the Lenovo ThinkPad,
it may be necessary to add the line:

    disable-module=linux_input

to /etc/directfbrc. This should correct both the mouse and keyboard
issues.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Qingy&oldid=256040"

Category:

-   Display managers
