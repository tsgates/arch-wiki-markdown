Toshiba Satellite S75-A7221
===========================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: WIP (Discuss)     
  ------------------------ ------------------------ ------------------------

I recently installed Arch Linux on my new laptop. I'll be adding my
experience installing on both BIOS and UEFI modes as well as hardware
and the packages to go with it during installation.

Contents
--------

-   1 Display
-   2 Networking
    -   2.1 Wired
    -   2.2 Wireless
-   3 Sound

Display
-------

This laptop has the Intel HD Graphics 4600 onboard. Install the
xf86-video-intel along with mesa to get 2D/3D acceleration working. You
will also want to enable multilib and install lib32-intel-dri to get
hardware acceleration working on your 32-bit applications.

When booting, whether installing or post-install, you will need to add
acpi_backlight=vendor to your kernel options. This will prevent a black
screen on boot.

Networking
----------

> Wired

> Wireless

Sound
-----

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Satellite_S75-A7221&oldid=279151"

Category:

-   Toshiba

-   This page was last modified on 20 October 2013, at 03:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
