Intel 53x Modem Driver
======================

  

Introduction
------------

This document is targeted on the installation of e.g. Intel 536ep or
Intel 537.

Important: Please do not change the docu without notifiying me (tpowa).
These modules were built for the latest arch stock kernel 2.6. You have
to rebuild the package for other kernels or have to stay with the old
kernel until a new package is provided.

Installation
------------

To get the drivers you have to use extra repository:

    # pacman -S intel-537

or

    # pacman -S intel-536ep

Configuration
-------------

    /etc/rc.conf

-   Add intel-536EP or intel-537 to daemon list
-   Add intel536 or intel537 and ppp_generic to modules list

Note:If pppd quits with an ERROR 1 just after connection, change auth to
noauth in /etc/ppp/options or use the call option (see the pppd man
page).

Note:If you do not want to set the permissions of your modem you "can"
set /usr/bin/pppd setuid but this may be a security risk, you have been
warned!!!

* * * * *

If you have comments on the package please post it here:
https://bbs.archlinux.org/viewtopic.php?t=6123

Retrieved from
"https://wiki.archlinux.org/index.php?title=Intel_53x_Modem_Driver&oldid=264014"

Category:

-   Modems

-   This page was last modified on 23 June 2013, at 21:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
