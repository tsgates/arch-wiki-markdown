xf86-video-sis
==============

This page describes how to get Silicon Integrated Systems (SiS) chipset
graphical adapters working on Arch Linux:

Contents
--------

-   1 Packages
-   2 lspci
-   3 Modules & rc.conf
-   4 xorg.conf
    -   4.1 Enable SSE
    -   4.2 SiS 671 card
    -   4.3 Dual head configuration

Packages
--------

You will need main xf86-video-sis with driver and it's good idea to
install sisctrl (gui tool for setting video modes). Some cards not
supported by sis driver package can work with xf86-video-sisusb and
xf86-video-sisimedia. You can also check xf86-video-sis671 from AUR.

lspci
-----

Output of lspci should look like this (depends on present model):

    01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS] 661/741/760 PCI/AGP or 662/761Gx PCIE VGA Display Adapter

Modules & rc.conf
-----------------

There are couple of modules related to SiS video cards:

    $ lsmod | grep sis | sed -re 's#^([a-zA-Z0-9_-]*) *.*#\1#g' | xargs modinfo | grep 'filename:'
    ...
    filename:       /usr/lib/modules/{kernel-version}/kernel/drivers/char/agp/sis-agp.ko.gz
    filename:       /usr/lib/modules/{kernel-version}/kernel/drivers/char/agp/agpgart.ko.gz
    ...

whereas {kernel-version} is the kernel version currently installed on
your system. For example kernel 3.7.1.1

You will probably need to load only sis-agp (it will probably load the
other sis modules as required by your hardware) as first and then the
other modules. So the beginning of MODULES array in your  /etc/rc.conf
should look like this:

    MODULES=(sis-agp)

xorg.conf
---------

Here are few most important sections from /etc/X11/xorg.conf

1.  Load some modules:

    Section "Module"
      Load  "dbe"
      Load  "i2c"
      Load  "bitmap"
      Load  "ddc"
      Load  "dri"
      Load  "extmod"
      Load  "freetype"
      Load  "glx"
      Load  "int10"
      Load  "vbe"
    EndSection

1.  Device specification:

    Section "Device"
      Identifier "Card0"
      Driver "sis"
      Card        "** SiS (generic)     [sis]"
      BusID "PCI:1:0:0"

      Option "UseFBDev" "true"
      Option "EnableSisCtrl" "yes"
      Option "ForceCRT1Type" "LCD"
      Option "ForceCRT2Type" "NONE"
      #Option "CRT2Detection" "true" #For me this worked better than forceing the detection. If you use this comment out the two Force lines above this.
      Option "CRT1Gamma" "on"
      Option "CRT2Gamma" "on"
      Option "Brightness" "0.000 0.000 0.000"
      Option "Contrast" "0.000 0.000 0.000"
      Option "CRT1Saturation" "0"
      Option "XvOnCRT2" "yes"
      Option "XvDefaultContrast" "2"
      Option "XvDefaultBrightness" "10"
      Option "XvDefaultHue" "0"
      Option "XvDefaultSaturation" "0"
      Option "XvDefaultDisableGfxLR" "no"
      Option "XvGamma" "off"
    EndSection

1.  Enable Direct Rendering:

    Section "DRI"
      Mode         0666
    EndSection

Enable SSE

enable or force the SSE use in SiS Card

Add

     Option "UseSSE" "yes"

to Device section

SiS 671 card

Add

     Option "UseTiming1366" "yes"

to Device section.

> Dual head configuration

You need 2 device sections to enable dualhead mode. Sis specific options
should be placed into master head device section.

    Section "Monitor"
      Identifier   "CRT1"
      ModelName    "PANEL"
      Option       "DPMS"
      VendorName   "LCD"
      HorizSync    31-60
      VertRefresh  40-60
    EndSection

    Section "Monitor"
      Identifier   "CRT2"
      ModelName    "tv"
      Option       "DPMS"
      VendorName   "tv"
    EndSection

    Section "Screen"
      DefaultDepth 24
      SubSection "Display"
        Depth      24
        Modes      "1024x768".
      EndSubSection
      Device       "Device[0]"
      Identifier   "Screen[0]"
      Monitor      "CRT2"
    EndSection

    Section "Screen"
      DefaultDepth 24
      SubSection "Display"
        Depth      24
        Modes      "1024x768".
      EndSubSection
      Device       "Device[1]"
      Identifier   "Screen[1]"
      Monitor      "CRT1"
    EndSection

    Section "Device"
      BoardName    "630"
      BusID        "PCI:1:0:0"
      Driver       "sis"
      Identifier   "Device[1]"
      Screen       1
      VendorName   "SiS"
    EndSection

    Section "Device"
      BoardName    "630"
      BusID        "PCI:1:0:0"
      Driver       "sis"
      Identifier   "Device[0]"
      Screen       0
      VendorName   "SiS"
      Option "EnableSisCtrl" "true"
    EndSection

    Section "ServerLayout"
      Identifier   "Layout[dual]"
      ...
      Option       "Clone" "off"
      Screen       "Screen[0]"
      Screen       "Screen[1]" RightOf "Screen[0]"
      Option       "Xinerama" "off"
    EndSection

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xf86-video-sis&oldid=243080"

Category:

-   X Server

-   This page was last modified on 6 January 2013, at 03:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
