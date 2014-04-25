DeveloperWiki:Dragon
====================

Contents
--------

-   1 Specs
-   2 Partition layout
-   3 Services
-   4 Maintainer
-   5 Trivia
-   6 History

Specs
-----

-   Intel Dual E2160
-   4GB Ram
-   2x500GB HDD as Raid1
-   5TB Traffic
-   100Mbit/s Uplink

Partition layout
----------------

/dev/sda1 and /dev/sdb1 10 GB -> /dev/md1; contains /

/dev/sda2 and /dev/sdb2 1 GB -> /dev/md2; swap

/dev/sda3 and /dev/sdb3 rest of space -> /dev/md3; /home

Services
--------

-   ssh

Maintainer
----------

System (sudo): ioni,bluewind

Trivia
------

-   bootloader is syslinux

History
-------

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Dragon&oldid=182731"

Category:

-   DeveloperWiki:Server Configuration

-   This page was last modified on 8 February 2012, at 20:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
