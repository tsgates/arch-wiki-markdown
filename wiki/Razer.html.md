Razer
=====

There is currently no official driver for the Razer gaming mice in
Linux. However, Michael Buesch has created a tool called razercfg to
configure Razer mice under Linux.

Contents
--------

-   1 Compatibility
-   2 Installation
    -   2.1 Final touches
-   3 Using the Razer Configuration Tool

Compatibility
-------------

razercfg lists the following mice models as stable:

-   Razer DeathAdder Classic
-   Razer DeathAdder 3500 DPI
-   Razer DeathAdder Black Edition
-   Razer Krait
-   Razer Naga

and the following as stable but missing minor features:

-   Razer Lachesis
-   Razer Copperhead
-   Razer Boomslang CE

Installation
------------

Download and install razercfg or razercfg-git for bleeding edge git
releases from the AUR.

After installing with pacman add the razerd daemon

    # systemctl enable razerd.service

to start up at launch with.

You also need to edit your /etc/X11/xorg.conf file to disable the
current mouse settings. I just commented them out then set some defaults
as suggested by the author:

    /etc/X11/xorg.conf

     Section "InputDevice"
        Identifier  "Mouse"
        Driver  "mouse"
        Option  "Device" "/dev/input/mice"
     EndSection

It is important to only have Mouse and not Mouse# listed in xorg.conf.

> Final touches

Restart the computer then enter:

    # udevadm control --reload-rules

To start the daemon, type:

    # systemctl start razerd.service

If you did everything correctly, you shouldn't get errors.

Using the Razer Configuration Tool
----------------------------------

There are two commands you can use, one for the command line tool
razercfg or the Qt-based GUI tool qrazercfg.

From the tool you can use the 5 profiles, change the DPI, change mouse
frequency, enable and disable the scroll and logo lights and configure
the buttons.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Razer&oldid=293288"

Category:

-   Mice

-   This page was last modified on 17 January 2014, at 03:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
