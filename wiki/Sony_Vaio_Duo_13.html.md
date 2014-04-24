Sony Vaio Duo 13
================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Sony Vaio Duo 13  
                           configuration how-to     
                           coming soon (Discuss)    
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Current status
-   2 Booting
    -   2.1 Legacy BIOS Boot Mode
    -   2.2 UEFI Boot Mode
-   3 SDIO
    -   3.1 TouchPad
    -   3.2 Wireless Adapter
-   4 Sound

Current status
--------------

The info on this page is partly outdated. Please refer to Guido
Günther's overview at
https://honk.sigxcpu.org/piki/hw/sony-SVD1321X9EW/.

Booting
-------

> Legacy BIOS Boot Mode

The Duo 13 does not support legacy BIOS boot mode.

> UEFI Boot Mode

The Duo 13 only supports UEFI boot.

You may have noticed that the Arch install media won't boot at all, and
that even if you try to add a "nomodeset" parameter to the boot line it
still won't work. Well it turns out that gummiboot won't work at all
with the Duo 13, period. You'll have to create a custom install media
using GRUB as your UEFI boot loader. Once you've installed Arch Linux
onto the SSD drive, you'll have to chainload the SSD from the USB stick
(which means you'll have to have your USB "key" plugged in when you
power on in order to boot the main OS on the SSD drive).

SDIO
----

The wireless WiFi card and the touchpad are connected to the motherboard
via the newer SDIO interface (not USB or PCI), so the lspci and lsusb
commands will not show you that those two pieces of hardware they exist.

> TouchPad

This isn't solved yet, so you're best bet right now is to use an
external USB mouse. If you figure it out, please update the Wiki here
(and many thanks for doing so!).

> Wireless Adapter

This isn't solved yet either, so a recommendation would be to run to
your local store (e.g. Walmart) and buy a cheap USB wifi dongle. The
Netgear N150 works right out of the box with stock kernel drivers and no
need to install any drivers manually.

Sound
-----

Sound works right out of the box, but you might experience an issue
where the sound stops functioning when you resume from suspend. No
solution yet.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sony_Vaio_Duo_13&oldid=304285"

Category:

-   Sony

-   This page was last modified on 13 March 2014, at 13:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
