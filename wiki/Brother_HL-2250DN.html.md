Brother HL-2250DN
=================

This guide explains how to install a Brother HL-2250DN laserjet printer
using CUPS.

Note:If you already attempted (and failed) to install the driver in
CUPS, remove it before proceeding with this tutorial.

Contents
--------

-   1 Prerequisites
-   2 Installation
-   3 Configuration
    -   3.1 Configuring the connection
    -   3.2 Regional Settings
-   4 Alternatives

Prerequisites
-------------

This tutorial assumes you have already configured the CUPS printer
server. There is plenty of existing information to get this working.

Installation
------------

Install brother-hl2250dn from the AUR.

Configuration
-------------

Restart the CUPS daemon and browse to the CUPS server:
http://localhost:631/

Under the Administration category, choose Manage printers. You should
now see your HL2250DN printer automatically installed and configured,
for USB connection.

Configuring the connection

Follow step 5a for USB connection, and step 5b for a network connection,
on this page.

Print a test page and configure the printer settings to your liking.

Regional Settings

Make sure to set your printer preferences to match your region. For
example, if you live in North America (Canada, US, Mexico) your paper
size should be changed from the Default "A4" to "Letter". Sometimes this
will be done automatically by your Desktop Environment (e.g. KDE) but
it's worthwhile to check it yourself or the text on your pages won't
align properly.

Alternatives
------------

I failed to get the above to work for various reasons, but am having
moderate success with the Generic PCL Laser Printer driver over IPP.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_HL-2250DN&oldid=303621"

Category:

-   Printers

-   This page was last modified on 8 March 2014, at 17:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
