Lenovo ThinkPad X1
==================

Contents
--------

-   1 Model description
-   2 Drive space customization
-   3 Installation method
    -   3.1 Legacy-BIOS
    -   3.2 UEFI
-   4 Hardware
    -   4.1 Fingerprint Reader
    -   4.2 Adjusting Backlight Brightness
-   5 Power management
-   6 Extra Keys

Model description
-----------------

Lenovo ThinkPad X1, Sandy Bridge (Core i5, 2,5 GHz), NWG2MRT This model
has SSD 80/HDD 320 pair. Comes without optical drive. Has UEFI BIOS with
BIOS-legacy fallback mode. Has Windows 7 Pro pre-installed, with tons of
bloatware (bing toolbar, big Lenovo superbar button et all)
pre-installed, too.

Drive space customization
-------------------------

By default:

    - SSD: two WinRE partitions and one Windows system partition
    - HDD: blank

I've chosen to:

    - leave WinRE untouched (there are two such partitions)
    - use SSD for my root partition
    - use HDD for swap, /home, /var (~30 Gb, pacman cache goes here), /tmp

Installation method
-------------------

Note:If you'd like to create Windows recovery flash drive, do it before
Arch installation with the help of autorun located at recovery
partition, from your installed Windows system.

Due to the fact that there is no optical drive, you need to install Arch
from USB stick.

> Legacy-BIOS

This procedure is far less involved then UEFI and works perfectly.

In order to turn off UEFI booting you will need to boot into your BIOS
and change the boot mode to Legacy. Afterward, follow the Beginners'
guide for standard installation instructions.

> UEFI

Installation from UEFI bootable USB works with the default bootloader,
so rEFInd is unnecessary. In the BIOS under Startup, set "UEFI/Legacy
Boot" to UEFI only. The default partition table (and Windows
installation) uses MBR. For UEFI, reformat the disk as GPT.

Booting using an efibootmgr entry works well. The warnings about
incompatibility and embedding arguments to do not apply.

Hardware
--------

Almost everything works out of the box. Install synaptics and
video-intel drivers.

> Fingerprint Reader

fingerprint-gui from the AUR is already patched to work with the X1's
newer fingerprint reader. To get the gui's dropdown to recognize your
device, you'll have to add your user to the plugdev group:

    # gpasswd -a <username> plugdev

It has been seen that the relevant udev rules do not get set properly.
To do this, open /usr/lib/udev/rules.d/40-libbsapi.rules with your
favorite text editor to add (or create with) the following lines:

    /usr/lib/udev/rules.d/40-libbsapi.rules

    ATTRS{idVendor}==”147e”, ATTRS{idProduct}==”2020″,   SYMLINK+=”input/touchchip-%k”, MODE=”0664″, GROUP=”plugdev”
    ATTRS{idVendor}==”147e”, ATTRS{idProduct}==”2020″,   ATTR{power/control}==”*”, ATTR{power/control}=”auto”

Restart your computer for the group and udev changes to take effect.

> Adjusting Backlight Brightness

Add acpi_osi="!Windows 2012" to your kernel parameters (see
https://bbs.archlinux.org/viewtopic.php?id=158775).

Power management
----------------

Just consult Laptop page to read about tp_smapi, pm-utils, uswsusp and
acpid.

Tp_smapi does not seem to work at all.

Suspend works fine, even with status indicator.

Extra Keys
----------

The sleep, wifi, brightness, and keyboard backlight keys all work out of
the box. All of the others (volume, media, etc.) can be bound using the
standard X labels:

    XF86ScreenSaver
    XF86WebCam
    XF86Display
    XF86AudioPrev
    XF86AudioPlay
    XF86AudioNext
    XF86AudioMute
    XF86AudioLowerVolume
    XF86AudioRaiseVolume
    XF86AudioMicMute
    XF86Launch1 # the black button above F6

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X1&oldid=298130"

Category:

-   Lenovo

-   This page was last modified on 16 February 2014, at 07:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
