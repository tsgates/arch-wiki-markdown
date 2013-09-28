CDemu
=====

CDemu is a software suite designed to emulate an optical drive and disc
(including CD-ROMs and DVD-ROMs). It enables you to use other disk image
formats that contain more than just the standard ISO-9660 filesystem,
for instance .bin/.cue, .nrg, or .ccd images. mount can directly handle
only .iso disc images (which contain a single filesystem), but many
images contain multiple sessions, mixed data/audio tracks… In short,
cdemu enables you to mount nearly any kind of image file with ease.

Installation
------------

CDemu can be installed with the package cdemu-client, available in the
official repositories. To enable the daemon in systemd run:

    # systemctl enable cdemu-daemon.service

> GUI

There are several GUIs available in the AUR.

-   GTK/Gnome: gcdemu is the official GTK version, which also provides a
    GNOME panel applet.
-   KDE: kde-cdemu-manager is the KDE equivalent which also integrates
    with Dolphin's Actions menu when right clicking an image file.

Examples
--------

Loading a single image to first device:

    # cdemu load 0 ~/image.mds

Loading multiple-file image to first device:

    # cdemu load 0 ~/session1.toc ~/session2.toc ~/session3.toc

Loading a text-based image in non-ASCII/non-Unicode encoding:

    # cdemu load 0 ~/image.cue --encoding=windows-1250

Loading an encrypted image with password provided as an argument:

    # cdemu load 0 ~/image.daa --password=seeninplain

Unloading first device:

    # cdemu unload 0

Displaying device status:

    # cdemu status

Displaying device mapping information:

    # cdemu device-mapping

Setting daemon debug mask for the first device:

    # cdemu daemon-debug-mask 0 0x01

Obtaining library debug mask for the first device:

    # cdemu library-debug-mask 0

Disabling DPM emulation on all devices:

    # cdemu dpm-emulation all 0

Enabling transfer rate emulation on first device:

    # cdemu tr-emulation 0 1

Changing device ID of first device:

    # cdemu device-id 0 "MyVendor" "MyProduct" "1.0.0" "Test device ID"

Enumerating supported parsers:

    # cdemu enum-supported-parsers

Enumerating supported fragments:

    # cdemu enum-supported-fragments

Enumerating supported daemon debug masks:

    # cdemu enum-daemon-debug-masks

Enumerating supported library debug masks:

    # cdemu enum-library-debug-masks

Displaying daemon and library version:

    # cdemu version

Retrieved from
"https://wiki.archlinux.org/index.php?title=CDemu&oldid=246797"

Category:

-   Optical
