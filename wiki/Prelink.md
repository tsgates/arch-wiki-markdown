Prelink
=======

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Method                                                             |
| -   2 Installing                                                         |
| -   3 Configuration                                                      |
| -   4 Usage                                                              |
|     -   4.1 Prelinking                                                   |
|     -   4.2 Removing prelink                                             |
|                                                                          |
| -   5 Daily Cron Job                                                     |
| -   6 KDE                                                                |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Method
------

Most programs require libraries to function. Libraries can be integrated
into a program once, by a linker, when it is compiled (static linking)
or they can be integrated when the program is run by a loader, (dynamic
linking). Dynamic linking has advantages in code size and management,
but every time a program is run, the loader needs to find the relevant
libraries. Because the libraries can move around in memory, this causes
a performance penalty, and the more libraries that need to be resolved,
the greater the penalty. prelink reduces this penalty by using the
system's dynamic linker to reversibly perform this linking in advance
("prelinking" the executable file) by relocating. Afterward, the program
only needs to spend time finding the relevant libraries on being run if,
for some reason (perhaps an upgrade), the libraries have changed since
being prelinked.

Installing
----------

Prelink is available through pacman

    pacman -S prelink

Configuration
-------------

All settings are in /etc/prelink.conf.

Note:Some proprietary binaries will crash with prelink (such as Flash,
Skype, Nvidia proprietary driver). You can add these to the exclude list
in /etc/prelink.conf.

Usage
-----

> Prelinking

following command prelink all the binaries in the directories given by
/etc/prelink.conf

    # prelink -amR

Warning:It has been observed that if you are low on disk space and you
prelink your entire system then there is a possibility that your
binaries may be truncated. The result being a b0rked system. Use the
file or readelf command to check the state of a binary file.
Alternatively, check the amount of free space on your harddrive ahead of
time with df -h.

> Removing prelink

Removing prelinking from all binaries

    # prelink -au

Daily Cron Job
--------------

This is recommended (and included in other distros packages) as it has
to be done in order to get speed benefits from updates. Save as
/etc/cron.daily/prelink.cron

    /etc/cron.daily/prelink.cron

    #!/bin/bash
    [[ -x /usr/sbin/prelink ]] && /usr/sbin/prelink -amR &>/dev/null

and give it the necessary ownership and permissions:

# chmod 755 /etc/cron.daily/prelink.cron

KDE
---

KDE knows about prelinking and it will start faster if you tell it you
have it. It is best to stick this in where all the users can use it.

    /etc/profile.d/kde-is-prelinked.sh

    export KDE_IS_PRELINKED=1

and give it the necessary ownership and permissions:

# chmod 755 /etc/profile.d/kde-is-prelinked.sh

See also
--------

-   Prelink man page
-   Gentoo Linux Prelink Guide
-   ELF Prelinking and what it can do for you

Retrieved from
"https://wiki.archlinux.org/index.php?title=Prelink&oldid=255878"

Category:

-   System administration
