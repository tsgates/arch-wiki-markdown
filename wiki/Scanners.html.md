HCL/Scanners
============

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List (HCL)
  Full Systems
  Laptops - Desktops
  Components
  Video Cards - Sound Cards - Wired Net Adapters - Modems - Wireless Adapters - Printers - Scanners - TV Cards - Digital Cameras - CD and DVD Writer/Readers - Keyboards - Main Boards
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

See also USB Scanner Support

Contents
--------

-   1 HP
    -   1.1
-   2 EPSON
    -   2.1 Stylus DX7450
-   3 LEXMARK
    -   3.1 X5250
-   4 Mustek
    -   4.1 BearPaw 2400CU
-   5 AGFA
    -   5.1 SnapScan 1212u

HP
==

HP F4580, use hplip

EPSON
=====

Stylus DX7450
-------------

Full support, using CUPS and gutenprint driver. For scanning all works
out-of-the-box with xsane.

LEXMARK
=======

X5250
-----

Mustek
======

BearPaw 2400CU
--------------

Works with sane-gt68xx (sane-gt68xx-firmware)

  

AGFA
====

SnapScan 1212u
--------------

Needs firmware SnapScan 1212U.bin to work, it can be extracted from the
Windows driver by running the installer under wine then looking in
Program Files. AGFA no longer offer the drivers on their website,
instead suggesting you install VueScan. The drivers can still be had
from various places though, the latest version is 2.0.0.9.

VueScan also works, and seems to have the firmware built in. But the
free version watermarks your images.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Scanners&oldid=279829"

Category:

-   Hardware Compatibility List

-   This page was last modified on 26 October 2013, at 04:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
