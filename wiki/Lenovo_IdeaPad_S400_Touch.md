Lenovo IdeaPad S400 Touch
=========================

The Lenovo IdeaPad S400 Touch is an excellent quality laptop that works
well with Arch. Almost everything worked perfectly out of the box,
however there are a few things one might have to configure manually.

The purpose of this article is to outline the installation and setup of
Arch Linux on your Lenovo IdeaPad S400 Touch laptop. As of 1/22/2014
this article only covers the success and difficulties of my own
(Esko997’s) installation and setup of the laptop. This page is currently
a work in progress.

Features:

-   1.9 GHz Pentium 2117U Intel Processor
-   4GB DDR3 RAM
-   Integrated Intel HD Graphics
-   Broadcom Wireless 802.11bgn Wireless Card
-   14” 10-point touch display
-   Dolby Advanced Audio v2 speakers
-   720p HD webcam
-   Multigesture control touchpad

Contents
--------

-   1 Installation/Setup
    -   1.1 Wireless
    -   1.2 Graphics
    -   1.3 Audio
-   2 Post-Installation/Configuration
    -   2.1 Bluetooth
    -   2.2 Touch Screen

Installation/Setup
------------------

When I first purchased the laptop it came preinstalled with Windows 8.1.
In order to begin the Arch Linux installation I had to, in Windows 8,
enable booting into the BIOS via the Advanced Settings tab under
Settings. Once in the BIOS I had to disable Secure Mode, enable USB
boot, and enable Legacy Boot. From here I was able to install Arch
without any problems. I chose to completely remove Windows 8.1, but
should you want to preserve this OS please refer to the Beginners' guide
for more information.

> Wireless

Wireless works out of the box however it is recommended that you install
the broadcom wireless drivers as I have found the wireless speed can
become throttled without them.

> Graphics

Setup regarding the graphics is as simple as installing the
xf86-video-intel package via pacman.

    # pacman -S xf86-video-intel

> Audio

Audio works as soon as the channels have been unmuted. This process is
detailed in the Beginners Guide.

Post-Installation/Configuration
-------------------------------

> Bluetooth

Not tested/configured but should theoretically work out of the box.

> Touch Screen

Works out of the box however gestures are not supported, the touch
interface essentially just acts as another way to left-click.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_IdeaPad_S400_Touch&oldid=298184"

Category:

-   Lenovo

-   This page was last modified on 16 February 2014, at 07:23.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
