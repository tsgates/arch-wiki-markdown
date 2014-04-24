Thinkpad S540
=============

This page outlines installation tips for Archlinux on the Lenovo
Thinkpad S540, and tips on getting the best setup, and known cavaets.

Contents
--------

-   1 Installation
    -   1.1 Before Installation
    -   1.2 During Installation
-   2 Known Cavaets

Installation
------------

> Before Installation

In the BIOS (press enter when the Lenovo Logo appears on screen):

-   Disable Secure Boot
-   Set Boot type to either Both (Legacy First) or Legacy Only (UEFI
    Installation has yet to be successful)

> During Installation

By default the system won't boot due to issues with the intel video
chip.

Edit `/etc/default/grub` and change `GRUB_CMDLINE_LINUX` to the value
`"intel.modeset=0"` and re-run `grub-mkconfig`. This will fix the video
bug.

  

Known Cavaets
-------------

Currently known cavets with Arch Linux on the s540 are:

-   Touch screen sometimes doesn't re-activate after system is placed in
    sleep mode (requires reboot)
-   Default soft-buttons on the touch pad don't match the markings.This
    page outlines installation tips for Archlinux on the Lenovo Thinkpad
    S540, and tips on getting the best setup, and known cavaets.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Thinkpad_S540&oldid=290437"

Category:

-   Lenovo

-   This page was last modified on 26 December 2013, at 08:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
