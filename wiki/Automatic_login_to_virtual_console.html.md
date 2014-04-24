Automatic login to virtual console
==================================

Related articles

-   Display manager
-   Silent boot
-   Start X at Login

This article describes how to automatically log in to a virtual console
at the end of the boot process. This article only covers console
log-ins; see Start X at Login for information about automatic login into
Xorg.

Contents
--------

-   1 Configuration
    -   1.1 Virtual console
    -   1.2 Serial console
-   2 See also

Configuration
-------------

Configuration relies on systemd drop-in files to override the default
parameters passed to agetty.

Configuration differs for virtual versus serial consoles. In most cases,
you want to set up automatic login on a virtual console, (whose device
name is ttyN, where N is a number). The configuration of automatic login
for serial consoles will be slightly different. Device names of the
serial consoles look like ttySN, where N is a number.

> Virtual console

Create the following file (and leading directories):

    /etc/systemd/system/getty@tty1.service.d/autologin.conf

    [Service]
    ExecStart=
    ExecStart=-/usr/bin/agetty --autologin username --noclear %I 38400 linux

Tip:The option Type=idle will delay the service startup until all jobs
(state change requests to units) are completed. When using Type=simple,
the service will be started immediately, but boot-up messages may
pollute the login prompt. This option is particularly useful when
starting X automatically. To use this option, add Type=simple into
autologin.conf.

If you want to use a tty other than tty1, see systemd FAQ.

> Serial console

Create the following file (and the leading directories):

    /etc/systemd/system/serial-getty@ttyS0.service.d/autologin.conf

    [Service]
    ExecStart=
    ExecStart=-/usr/bin/agetty --autologin username -s %I 115200,38400,9600 vt102

See also
--------

-   Change default runlevel/target to boot into

Retrieved from
"https://wiki.archlinux.org/index.php?title=Automatic_login_to_virtual_console&oldid=301273"

Categories:

-   Boot process
-   Security

-   This page was last modified on 24 February 2014, at 11:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
