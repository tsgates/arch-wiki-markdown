HCL/Printers
============

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List (HCL)
  Full Systems
  Laptops - Desktops
  Components
  Video Cards - Sound Cards - Wired Net Adapters - Modems - Wireless Adapters - Printers - Scanners - TV Cards - Digital Cameras - CD and DVD Writer/Readers - Keyboards - Main Boards
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Contents
--------

-   1 CANON
    -   1.1 PIXMA iP3000
    -   1.2
-   2 HP
    -   2.1 LaserJet Pro P1102
    -   2.2 DeskJet 710C
    -   2.3 DeskJet 970 Cse
    -   2.4 DeskJet D1560
    -   2.5 PSC 1610
    -   2.6 DeskJet F2400
    -   2.7 DeskJet F4580
    -   2.8 LaserJet 1000
    -   2.9 LaserJet 6L
-   3 LEXMARK
    -   3.1 X5250
    -   3.2 MS310d
-   4 EPSON
    -   4.1 Stylus CX-8400
    -   4.2 Stylus DX7450
    -   4.3 Stylus SX400

CANON
=====

PIXMA iP3000
------------

Full support using CUPS and Gutenprint drivers.

HP
==

LaserJet Pro P1102
------------------

foo2jzs driver for so-called winprinters is required. Driver
HP-LaserJet_Pro_P1102.ppd.gz from foo2zjs package in AUR AUR is
required. Aso see this page:https://wiki.archlinux.org/index.php/Cups

DeskJet 710C
------------

Driver pnm2ppa from AUR is required.

DeskJet 970 Cse
---------------

DeskJet D1560
-------------

Full support using hplip

PSC 1610
--------

Full support using hplip (for printing) and 'sane' (for scanning)

DeskJet F2400
-------------

Full support using hplip (for printing) and 'sane' (for scanning)

DeskJet F4580
-------------

Full support using hplip (for printing) and 'sane' (for scanning)

LaserJet 1000
-------------

Printer will not work with HPLIP. Follow instructions here: a linux
printer driver for ZjStream protocol

LaserJet 6L
-----------

It works but you have to change BIOS settings for Parallel port to
Interupt: IRQ7, Base I/O adress: 3BC and Mode: SPP or (Output only, it
works with Bi-directional on my IBM). Then CUPS recognizes it.

LEXMARK
=======

X5250
-----

MS310d
------

Full support using CUPS.

EPSON
=====

Stylus CX-8400
--------------

Full printing support using CUPS and gutenprint drivers.

For scanning support, the additional iscan driver is necessary, but
luckily there is a AUR package that installs the driver (and sane if it
is not already installed.)

Stylus DX7450
-------------

Full support, using CUPS and gutenprint driver. For scanning all works
out-of-the-box with xsane.

Stylus SX400
------------

Full support, using CUPS and gutenprint driver. For scanning all works
with simple scan.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Printers&oldid=303003"

Category:

-   Hardware Compatibility List

-   This page was last modified on 3 March 2014, at 09:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
