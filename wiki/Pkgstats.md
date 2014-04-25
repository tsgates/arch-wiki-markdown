pkgstats
========

pkgstats sends a list of all installed packages, kernel modules, the
architecture and the mirror you are using to the Arch Linux project.
This information is anonymous and cannot be used to identify the user,
but it will help Arch developers prioritize their efforts.

Contents
--------

-   1 Installation
-   2 Usage
-   3 Tip: set it once and forget about it
    -   3.1 Using cron
    -   3.2 Using systemd cron functionality
-   4 Results and reference

Installation
------------

You can install pkgstats from the Official repositories.

Usage
-----

    $ pkgstats -h
    usage: /usr/bin/pkgstats [option]
    options:
           -v      show the version of pkgstats
           -d      enable debug mode
           -h      show this help
           -s      show what information would be sent
                   (but do not send anything)
           -q      be quiet except on errors

Tip: set it once and forget about it
------------------------------------

In order to keep statistics up-to-date while not forcing users to
remember to run pkgstats periodically, a time-based job may be set so as
to execute pkgstats in the background once in a while.

> Using cron

/etc/cron.weekly/pkgstats file is installed by default by pkgstats.
However, if not done before cron systemd service should be enabled. See
Cron#Activation_and_autostart.

> Using systemd cron functionality

Systemd is capable of taking on a significant subset of the
functionality of cron through built-in support for calendar time events
(from systemd version 197) as well as monotonic time events.

A custom example for pkgstats can be found at
systemd/cron_functionality#pkgstats. The rest of that article should be
followed in order to activate systemd cron functionality.

Results and reference
---------------------

Statistics are available at https://www.archlinux.de/?page=Statistics.

You can read the official forum thread for more info.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pkgstats&oldid=301672"

Category:

-   Package management

-   This page was last modified on 24 February 2014, at 12:03.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
