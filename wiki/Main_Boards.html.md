HCL/Main Boards
===============

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List (HCL)
  Full Systems
  Laptops - Desktops
  Components
  Video Cards - Sound Cards - Wired Net Adapters - Modems - Wireless Adapters - Printers - Scanners - TV Cards - Digital Cameras - CD and DVD Writer/Readers - Keyboards - Main Boards
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Contents
--------

-   1 MSI
    -   1.1 MSI Neo2
-   2 Asus
    -   2.1 A8N-E
    -   2.2 M2N-SLI deluxe
    -   2.3 P4S800D
    -   2.4 P5K
    -   2.5 P7P55D-E Deluxe
-   3 Gigabyte
    -   3.1 GA-MA69VM-S2, BIOS F8 03/03/2008

MSI
===

MSI Neo2
--------

Asus
====

A8N-E
-----

Everything works perfectly.

M2N-SLI deluxe
--------------

I have not used the on board sound, the second wired NIC, or tried SLI
(only one video card) but everything else works out of the box with 64
bit arch.

P4S800D
-------

Motherboard for 32-bit Pentium 4, works perfectly.

P5K
---

Works perfectly, every component was identified correctly. Didn't check
CrossFire, but probably everything is fine with it. The same results
with 32 and 64 bit.

P7P55D-E Deluxe
---------------

Works really well under x86_64. Have a few yet-to-be-resolved --
possibly unrelated -- issues: hangs on lock screen and hibernate,
haven't gotten integrated audio to drive sub-woofer in 2.1 channel
arrangement. Haven't tested cross-fire or over-clocking features yet.

Gigabyte
========

GA-MA69VM-S2, BIOS F8 03/03/2008
--------------------------------

Works. I had to add

    clocksource=acpi_pm nohz=off 

to the kernel command line.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Main_Boards&oldid=279834"

Category:

-   Hardware Compatibility List

-   This page was last modified on 26 October 2013, at 04:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
