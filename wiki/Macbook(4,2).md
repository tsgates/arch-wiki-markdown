Macbook(4,2)
============

NOTE: This article is still work in progress - by kcirick

This article is intended specifically for Macbook(4,2) (late September
2008) model. If you have other Macbook model, please see here.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 The Model                                                          |
| -   2 Installation                                                       |
|     -   2.1 Preliminaries                                                |
|         -   2.1.1 Back up your data                                      |
|         -   2.1.2 Install rEFIt                                          |
|         -   2.1.3 Note for single-boot                                   |
|                                                                          |
|     -   2.2 Partitioning                                                 |
|         -   2.2.1 Single-boot (Arch Linux Only)                          |
|         -   2.2.2 Dual-boot (Arch Linux + OS-X)                          |
|         -   2.2.3 Triple-boot (Arch Linux + Windows + OS-X)              |
|                                                                          |
|     -   2.3 Install Arch Linux                                           |
|                                                                          |
| -   3 System Configuration                                               |
|     -   3.1 Xorg Setup                                                   |
|         -   3.1.1 Video                                                  |
|         -   3.1.2 Touchpad                                               |
|         -   3.1.3 Keyboard                                               |
|                                                                          |
|     -   3.2 Wireless Setup                                               |
|         -   3.2.1 Ndiswrapper                                            |
|         -   3.2.2 Broadcom-wl                                            |
+--------------------------------------------------------------------------+

The Model
---------

To make sure that you have the right model, here is the list of system
specifications for Macbook(4,2) [1]

-   Release Date: October 14, 2008
-   Model Numbers: MB402*/B
-   Display: 13.3-inch glossy widescreen LCD, 1280 x 800 pixel
    resolution (WXGA, 16:10 = 8:5 aspect ratio)
-   Front Side Bus: 800 MHz
-   CPU: 2.1 GHz Intel Core 2 Duo (T8100)
-   Memory: 1 GB (two 512 MB) 667 MHz PC2-5300 - Expandable to 4 GB
-   Graphics: Intel GMA X3100 using 144 MB RAM
-   Hard Drive: 120 GB - Optional 160 GB or 250 GB
-   Wireless: Integrated 802.11a/b/g/n (Broadcom BCM4328 rev03)
-   Slot Drive: 4× DVD+R DL writes, 8× DVD±R read, 4× DVD±RW writes, 24×
    CD-R, and 10x CD-RW recording
-   Included OS: Mac OS X v10.5.4
-   Battery: 55-watt-hour removable lithium-polymer

Installation
------------

Incomplete - Work in Progress

> Preliminaries

Back up your data

You should backup before you begin the installation. It suffices to just
backup the Users directory (/Users/user/ where user is the name of the
username in OSX) onto external hard drive or USB stick.

Install rEFIt

Before you begin, you should install rEFIt, the bootloader for EFI-based
computer, such as the Intel Macbooks.

1.  Download the .dmg
2.  Install the program
3.  run:

    cd /efi/refit; ./enable.sh

Note for single-boot

However, if you are going to erase OS-X and plan on single-boot, then
you need to also back up

    /System/Library/Extensions/IOUSBFamily.kext/Contents/PlugIns/AppleUSBVideoSupport.kext/Contents/MacOS/AppleUSBVideoSupport

You will need this for iSight functionality

> Partitioning

TODO

Single-boot (Arch Linux Only)

Dual-boot (Arch Linux + OS-X)

Triple-boot (Arch Linux + Windows + OS-X)

> Install Arch Linux

TODO

System Configuration
--------------------

TODO

> Xorg Setup

Video

Touchpad

Keyboard

> Wireless Setup

This model of Macbook has Broadcom BCM4328(rev03). There are two
methods: (a) using Ndiswrapper or (b) using broadcom-wl

Ndiswrapper

1.  Install ndiswrapper:

     # pacman -S ndiswrapper

1.  Download the driver from here (from Ubuntu Community Documentation)
2.  Unarchive the zip file (install 'unzip' first)
3.  Install the driver:

     # ndiswrapper -i bcmwl5.inf
     # ndiswrapper -l
     # ndiswrapper -m
     # depmod -a
     # modprobe ndiswrapper

1.  Test the new module. If you see something similar, then it's
    successful

     # iwconfig

     OUTPUT REQUIRED

1.  Edit /etc/rc.conf:

Add:

    MODULES = (.. ndiswrapper ..)

Broadcom-wl

1.  Download the broadcom-wl package from AUR
2.  Remove the conflicting modules:

     # rmmod b43
     # rmmod ssb

1.  load the new module:

     # modprobe lib80211
     # modprobe wl

1.  Add the modules to /etc/rc.conf:

    MODULES=(lib80211 wl !b43 !ssb ...

Retrieved from
"https://wiki.archlinux.org/index.php?title=Macbook(4,2)&oldid=196500"

Category:

-   Apple
