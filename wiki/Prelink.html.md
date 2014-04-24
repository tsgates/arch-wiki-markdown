Prelink
=======

Most programs require libraries to function. Libraries can be integrated
into a program once, by a linker, when it is compiled (static linking)
or they can be integrated when the program is run by a loader, (dynamic
linking). Dynamic linking has advantages in code size and management,
but every time a program is run, the loader needs to find the relevant
libraries. Because the libraries can move around in memory, this causes
a performance penalty, and the more libraries that need to be resolved,
the greater the penalty. Prelink reduces this penalty by using the
system's dynamic linker to reversibly perform this linking in advance
("prelinking" the executable file) by relocating. Afterward, the program
only needs to spend time finding the relevant libraries on being run if,
for some reason (perhaps an upgrade), the libraries have changed since
being prelinked.

Contents
--------

-   1 Installing
-   2 Configuration
-   3 Usage
    -   3.1 Prelinking
    -   3.2 Removing prelink
-   4 Daily cron job
-   5 KDE
-   6 See also

Installing
----------

prelink is currently available in the official repositories.

Configuration
-------------

All settings are in /etc/prelink.conf.

Note:Some proprietary binaries will crash with prelink (such as Flash,
Skype, Nvidia proprietary driver). You can add these to the exclude list
in /etc/prelink.conf.

Usage
-----

> Prelinking

The following command prelinks all the binaries in the directories given
by /etc/prelink.conf:

    # prelink -amR

Warning:It has been observed that if you are low on disk space and you
prelink your entire system then there is a possibility that your
binaries may be truncated, the result being a broken install. Use the
file or readelf command to check the state of a binary file.
Alternatively, check the amount of free space on your harddrive ahead of
time with df -h.

> Removing prelink

Remove prelinking from all binaries:

    # prelink -au

Daily cron job
--------------

This is recommended (and included in other distros packages) as it has
to be done in order to get speed benefits from updates. Save as
/etc/cron.daily/prelink

    /etc/cron.daily/prelink

    #!/bin/bash
    [[ -x /usr/bin/prelink ]] && /usr/bin/prelink -amR &>/dev/null

and give it the necessary ownership and permissions:

# chmod 755 /etc/cron.daily/prelink

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
"https://wiki.archlinux.org/index.php?title=Prelink&oldid=305750"

Category:

-   System administration

-   This page was last modified on 20 March 2014, at 01:56.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
