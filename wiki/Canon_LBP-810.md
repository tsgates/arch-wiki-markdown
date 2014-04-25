Canon LBP-810
=============

Introduction
============

This manual describes how to get Canon LBP-810/LBP-1120 printer to work
under Arch Linux.

Note: You must use an USB cable to connect your printer. If it only has
a parallel port, I'm sorry but my driver won't work. [1]

Requirements
============

Install the following packages with pacman:

-   cups foomatic-db foomatic-filters;
-   capt-lbp. Package is available in the AUR.

    # pacman -S cups foomatic-db foomatic-filters
    # pacman -U capt-lbp-0.4-2-i686.pkg.tar.xz

Configuration
=============

Note:Before going any further see the cups page and check if the user
you are currently logged as (not root) is in the group lp

Verify group:

    # grep lp /etc/group

See if the printer is connected to the computer by checking dmesg and
lsusb command output it should tell you something like this:

    # Bus 005 Device 002: ID 04a9:260a Canon, Inc. CAPT Printer

After that start the CUPS daemon:

    # /etc/rc.d/cupsd start

Add the printer using lpadmin, it should be located at /dev/usb/lpX
where X is the corresponding number for printer. check if the usblp
kernel module is loaded again by using the dmesg command

    # lpadmin -p <printer name> -v <device URI> -P /usr/share/cups/model/Canon-LBP-810-capt.ppd -E

Device URI like /dev/usb/lpX.

If you recieve:

    lpadmin: File device URIs have been disabled! To enable, see the FileDevice directive in "/etc/cups/cupsd.conf".

Add the following to /etc/cups/cupsd.conf:

    ...
    # Allow new printers to be added using device URIs "file:/filename"
    FileDevice Yes
    ...

If you have done the previous steps then the printer should be visible
from the web based CUPS configruation tool http://localhost:631

Change the DeviceURI section in /etc/cups/printers.conf to

    ...
    DeviceURI file:///dev/null
    ...

and /etc/capt.conf to match the corresponding device e.g /dev/usb/lpX.
If the file /etc/capt.conf is only available on record, then change the
permissions: chmod o+w /etc/capt.conf.

And finally restart CUPS:

    # /etc/rc.d/cupsd restart

Retrieved from
"https://wiki.archlinux.org/index.php?title=Canon_LBP-810&oldid=217125"

Category:

-   Printers

-   This page was last modified on 8 August 2012, at 17:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
