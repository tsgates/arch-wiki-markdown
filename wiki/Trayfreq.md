Trayfreq
========

Contents
--------

-   1 Introduction
    -   1.1 Short history
    -   1.2 Features
-   2 Installation
    -   2.1 Trayfreq Setup
-   3 Remarks
-   4 External Links

Introduction
------------

Trayfreq (pronounced tray-freek) is a GTK+ application released under
GPL that lets you select your CPU's governor or frequency from a tray
icon and displays information for your battery. Trayfreq is designed to
be desktop-environment-independent so it depends only on GTK+ and a
system tray to show its icons. Trayfreq is the perfect addition to Xfce,
LXDE, and Window Managers (Openbox, Fluxbox, etc.).

> Short history

The official version was abandoned at 0.2.x.dev1-3 (sometime during
2009) and eventually failed as the rest of the world walked on into the
future. In February 2014, Phillid picked the then-orphaned AUR package
up and tidied and reworked the source code to make Trayfreq work once
again.

> Features

-   Displays a icon that shows you the relative current CPU frequency
-   When the CPU icon is right-clicked, it provides a menu of available
    frequencies and governors to choose.
-   When the CPU icon is left-clicked, it runs a command (set in config
    file, default nothing)
-   Displays a icon that shows you the status of your Battery (Charging,
    Discharging, Charged) and its relative current charge (optional)
-   Toggling of CPU governor based on if the battery is discharging or
    not.
-   Lightweight, Desktop-Environment Independent

Installation
------------

Install trayfreq from the AUR.

> Trayfreq Setup

Now, let's edit the configuration file for trayfreq.

    $ cp /usr/share/trayfreq/trayfreq.config ~/.trayfreq.config
    $ nano ~/.trayfreq.config

Everything will be commented out; uncomment what you want to use. Let's
go through the options

-   [battery] – the group battery
    -   show=1 – 1 to show the battery tray icon, 0 to not show it
    -   governor=powersave – this sets the governor to use if the
        battery is discharging
-   [ac] – the group for if the batter is not discharging
    -   governor=ondemand – this sets the governor to use if the battery
        is not discharging
-   [events] – the group events
    -   activate=/usr/bin/xterm – this sets the program to launch when
        the tray icon is activated (left clicked usually)
-   [governor] – the group governor
    -   default=ondemand – this sets the default governor to be set when
        trayfreq starts
-   [frequency] – the group frequency
    -   default=800000 – this sets the default frequency in hertz to be
        set when trayfreq starts

Note that, if a default frequency is set, it will override the governor.

Sample File:

    [battery]
    show=1
    governor=powersave
    [ac]
    governor=ondemand
    [events]
    activate=/usr/bin/showbatt
    [governor]
    default=ondemand
    #[frequency]
    #default=800000

If you want, you can have a configuration file in your home folder, but
it can now set the program to run when the tray icon is activated too.
The file should be ~/.trayfreq.config; if it exists, trayfreq will not
look at /usr/share/trayfreq/trayfreq.config.

Remarks
-------

A desktop file is installed into /etc/xdg/autostart/. It will
automatically start once installed. If you do not want it to start
automatically, open the start up manager that comes with your desktop
enviroment and uncheck trayfreq.

External Links
--------------

-   Trayfreq's Website

Retrieved from
"https://wiki.archlinux.org/index.php?title=Trayfreq&oldid=299860"

Categories:

-   Power management
-   CPU

-   This page was last modified on 22 February 2014, at 16:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
