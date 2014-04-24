Fujitsu Siemens Pa 2510
=======================

Contents
--------

-   1 LAPTOP SPECS
-   2 XORG CONFIGURATION
    -   2.1 using the ATI catalyst driver
    -   2.2 using the open source driver
-   3 SOUND
-   4 TOUCHPAD
-   5 ACCESS TO DEVICES
-   6 WIRELESS LAN
    -   6.1 Madwifi
-   7 The easy way:
-   8 A bit more complicated but also working (only for 32bit systems):
    -   8.1 Ndiswrapper
-   9 ETHERNET
-   10 USB
-   11 MONITOR OUT
-   12 HOTKEYS, SPECIAL BUTTONS
-   13 CARD SLOTS
-   14 Powersave
-   15 Suspend
    -   15.1 to ram
    -   15.2 to disk

LAPTOP SPECS
------------

    Processor: AMD Athlon64 X2 TK55 
    Harddisk : 160Gb Harddisk
    DVD-RW   : 
    Graphics : integrated Ati Xpress X1200
    Display  : 1280x800 LCD
    Ports    : 3 USB ports, Expresscard Slot
    Network  : Realtek Ethernet, Atheros 5007eg, AC'97 Modem

XORG CONFIGURATION
------------------

See the Beginners Guide for details

> using the ATI catalyst driver

pacman -S catalyst

> using the open source driver

You have the choice between the radeon and radeonhd driver. However you
need a new DRM Kernel Module to get direct rendering. The new DRM module
should be included in Kernel 2.6.26 so either updgrade or get the
libdrm-git package from the AUR. You should also install XOrg Server
from git using the xorg-server-git package from the AUR. (this will take
some time). Dont forget xf86-input-mouse-git and
xf86-input-keyboard-git.

Use the xf86-video-ati-git video driver from the AUR. For more
information and driver updates visit http://www.phoronix.com.

SOUND
-----

Works out of the box. Don't forget to add your user to the audio group.

Check here for more info about how to set up sound:
https://wiki.archlinux.org/index.php/ALSA_Setup

TOUCHPAD
--------

ACCESS TO DEVICES
-----------------

Add user to groups (given you have created a user):

        gpasswd -a username video
        gpasswd -a username optical
        gpasswd -a username storage
        gpasswd -a username audio

WIRELESS LAN
------------

> Madwifi

The Atheros AR5007 currently doesnt work out of the box. but it works
using a patch. Read   
 Read http://madwifi.org/ticket/1679 for details.   

* * * * *

The easy way:
-------------

Please download the following Package from AUR: Madwifi with new HAL in
AUR

You need to unrar the Package, type makepkg and then install the new
build package (pacman -A madwifi-xxxxx-i686.tar.gz) Or (using yaourt)
yaourt -S madwifi-newhal-git.

Now your wlan card should be recognised. Maybe you should also blacklist
the ath5k kernel module by adding "!ath5k" into the modules section in
/etc/rc.conf

* * * * *

A bit more complicated but also working (only for 32bit systems):
-----------------------------------------------------------------

The madwifi package with included patch can be downloaded from:
http://snapshots.madwifi.org/special/madwifi-ng-r2756+ar5007.tar.gz  
 After downloading:  
 Untar the package

    tar xvf madwifi-ng-r2756+ar5007.tar.gz

change into the madwifi folder

    cd madwifi-ng-r2756+ar5007

compile madwifi

    make

install

    make install

then add ath_pci and wlan to your modules section in rc.conf

> Ndiswrapper

work in progress

  

ETHERNET
--------

works out of the box using the r8169 module.

USB
---

works

MONITOR OUT
-----------

not tested

HOTKEYS, SPECIAL BUTTONS
------------------------

The buttons for the led brightness didn't work until I added

    acpi_osi=linux

to grub.

CARD SLOTS
----------

testet with Memorystickn and Sdcard

Powersave
---------

add "powernow_k8" to the modules section in rc.conf

for frequency scaling you should search the wiki for laptop-mode-tools.

Suspend
-------

> to ram

> to disk

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fujitsu_Siemens_Pa_2510&oldid=238811"

Category:

-   Fujitsu

-   This page was last modified on 6 December 2012, at 00:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
