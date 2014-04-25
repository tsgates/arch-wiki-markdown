Console Mouse Support
=====================

GPM, short for General Purpose Mouse, is a daemon that provides mouse
support for Linux virtual consoles.

Contents
--------

-   1 Installing
    -   1.1 Desktop
    -   1.2 Laptop
-   2 Configuring

Installing
----------

> Desktop

Install gpm with pacman.

> Laptop

Install gpm and xf86-input-synaptics with pacman.

Configuring
-----------

The -m parameter precedes the declaration of the mouse to be used. The
-t parameter precedes the type of mouse. To get a list of available
types for the -t option, run gpm with -t help.

    $ gpm -m /dev/input/mice -t help

If the mouse only has 2 buttons, pass -2 to GPM_ARGS and button-2 will
perform the paste function.

The gpm package needs to be started with a few parameters. These
parameters can be added in the file /etc/conf.d/gpm or used when running
gpm directly.

-   For PS/2 mice, replace the existing line with:

    GPM_ARGS="-m /dev/psaux -t ps2"

-   Whereas USB mice should use:

    GPM_ARGS="-m /dev/input/mice -t imps2"

-   And IBM Trackpoints need:

    GPM_ARGS="-m /dev/input/mice -t ps2"

Once a suitable configuration has been found, gpm can be started by
systemd:

    systemctl start gpm.service

and enabled at boot time with:

    systemctl enable gpm.service

For more information see man gpm.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Console_Mouse_Support&oldid=240512"

Category:

-   Mice

-   This page was last modified on 16 December 2012, at 06:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
