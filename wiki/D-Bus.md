D-Bus
=====

D-Bus is a message bus system that provides an easy way for
inter-process communication. It consists of a daemon, which can be run
both system-wide and for each user session, and a set of libraries to
allow applications to use D-Bus.

Contents
--------

-   1 Installation
-   2 Starting the user session
-   3 Debugging
-   4 See also

Installation
------------

D-Bus is enabled automatically when using systemd because dbus is a
dependency of systemd.

Starting the user session
-------------------------

gnome-session, startkde and startxfce4 will start a D-Bus session
automatically if one is not already running. The skeleton file for
~/.xinitrc (/etc/skel/.xinitrcfrom xorg-xinit) will do the same. Make
sure that your ~/.xinitrc is based on the skeleton file
/etc/skel/.xinitrc.

Debugging
---------

d-feet is an easy to use D-Bus debugger GUI tool. D-Feet can be used to
inspect D-Bus interfaces of running programs and invoke methods on those
interfaces. See its homepage for more info.

See also
--------

-   D-Bus page at freedesktop.org
-   Introduction to D-Bus on freedesktop.org

Retrieved from
"https://wiki.archlinux.org/index.php?title=D-Bus&oldid=285212"

Category:

-   Daemons and system services

-   This page was last modified on 29 November 2013, at 17:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
