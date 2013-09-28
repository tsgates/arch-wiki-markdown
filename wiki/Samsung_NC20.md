Samsung NC20
============

Samsung NC20 is a laptop with 12.1" display with resolution 1280x800. It
have 160GB hard drive, 3 USB ports, Memory Card reader (3-in-1
propably), VGA-output, Webcam and microphone. It have 1GB RAM and the
computer is delivered with Windows XP license.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Graphics                                                           |
|     -   2.1 VIA chrome9 driver                                           |
|     -   2.2 openchrome                                                   |
|                                                                          |
| -   3 What works                                                         |
| -   4 Not have been tested                                               |
| -   5 lspci output                                                       |
| -   6 lsusb output                                                       |
+--------------------------------------------------------------------------+

Installation
============

Not found any problems during installation, except cfdisk did not
started because default partition table was somehow corrupted (Windows
partition + propably different recovery-partition). At least in this
machine.

Installed using USB-stick and downloaded packages from web directly
using LAN-cable (works out of the box).

If you find that your screen displays a test pattern cycling through
solid colours on boot, you may need to add modprobe.blacklist=viafb to
the kernel command line.

Graphics
========

VIA chrome9 driver
------------------

The official VIA provided chrome9 driver is currently the only way to
get any form of 3D acceleration on the NC20. You can install it using
the via-chrome9-dkms, xf86-video-via-chrome9 & via-chrome9-dri packages
from the AUR.

You can then use the following as your /etc/X11/xorg.conf:

    Section "ServerLayout"
            Identifier      "Default Layout"
            Screen          "Default Screen"
            Option          "RandR"  "true"
    EndSection

    Section "Files"
    	#RgbPath      "/usr/local/share/X11/rgb"
    	ModulePath   "/usr/lib/xorg/modules"
    	#FontPath     "/usr/share/fonts/X11/misc/"
    	#FontPath     "/usr/share/fonts/X11/TTF/"
    	#FontPath     "/usr/share/fonts/X11/OTF"
    	#FontPath     "/usr/share/fonts/X11/Type1/"
    	#FontPath     "/usr/share/fonts/X11/100dpi/"
    	#FontPath     "/usr/share/fonts/X11/75dpi/"
    EndSection


    Section "Monitor"
    	Identifier	"VGA-1"
         	#Option		"Ignore"	    "true"
            #Option         "NoDDCValue"        "false"
         	Option		"Disable"	    "true"
         	#Option		"Enable"	    "true"
            #Option		"Rotate"            "right"
         	#Modeline 	"1024x768_60.00"    63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync
         	#Option		"PreferredMode"	    "1024x768"
    	Option		"DefaultModes"	    "true"
    EndSection

    Section "Monitor"
    	Identifier	"LVDS-1"
    	#Option	 	"Ignore"		"true"
    	Option   	"Enable"		"true"
    	Option   	"PanelSize"		"1280x800"
    	Option	  	"PreferredMode" 	"1280x800"
    	#Option	  	"MSB"           	"false"
    	#Option         "NoDithering"           "true"
    	#Option         "DualChannel"           "false"
    	#Option         "Center"                "true"
            #Option         "FixOnIGA1"             "true"
    	#Option         "ClockPolarity"         "1"
    	#Option         "ClockAdjust"
    	#Option         "ClockDrivingSelection"
    	#Option         "DataDrivingSelection"
    	#Option         "Vt1636ClockSelST1"
    	#Option		"Vt1636ClockSelST2"
    	Option		"DefaultModes"	    "true"
    EndSection	

    Section "Monitor"
    	Identifier	"DVI-1"
    	Option		"Ignore"	"true"
    	Option		"DefaultModes"	    "true"
    EndSection	

    Section "Monitor"
    	Identifier	"TV-1"
    	Option 		"Ignore"   	"true"
    	Option		"DefaultModes"	    "true"
    EndSection	

    Section "Monitor"
            Identifier      "HDMI-1"
            Option          "Ignore"        "true"
    	Option		"DefaultModes"	    "true"
    EndSection

    Section "Monitor"
            Identifier      "DisplayPort-1"
            Option          "Ignore"        "true"
    	Option		"DefaultModes"	    "true"
    EndSection

    Section "Monitor"
            Identifier      "VGA-2"
            Option         "Ignore"            "true"
            #Option         "NoDDCValue"        "false"
            #Option         "Disable"           "true"
            #Option         "Enable"            "true"
            #Option         "Rotate"            "right"
            #Modeline       "1024x768_60.00"    63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync
            #Option          "PreferredMode"     "1024x768"
    	Option		"DefaultModes"	    "true"
    EndSection

    Section "Monitor"
            Identifier      "LVDS-2"
            Option          "Ignore"                "true"
            #Option         "Enable"                "true"
            #Modeline       "800x480_60.00"         29.50  800 824 896 992  480 483 493 500 -hsync +vsync
            #Modeline       "1024x768_60.00"        63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync
            #Modeline       "1600x1200_60.00"       130.25  1600 1648 1680 1760  1200 1203 1207 1235 -hsync +vsync
            #Option         "PanelSize"             "1024x768"
            #Option         "PreferredMode"         "1024x768"
            #Option         "MSB"                   "false"
            #Option         "NoDithering"           "true"
            #Option         "DualChannel"           "false"
            #Option         "Center"                "true"
            #Option         "FixOnIGA1"             "true"
    	#Option         "Vt1636ClockSelST1"
            #Option         "Vt1636ClockSelST2"
    	Option		"DefaultModes"	    	"true"
    EndSection

    Section "Monitor"
            Identifier      "DVI-2"
            Option          "Ignore"        "true"
    	Option		"DefaultModes"	    "true"
    EndSection

    Section "Monitor"
            Identifier      "TV-2"
            Option          "Ignore"        "true"
    	Option		"DefaultModes"	"true"
    EndSection

    Section "Monitor"
            Identifier      "HDMI-2"
            Option          "Ignore"        "true"
    	Option		"DefaultModes"	    "true"
    EndSection

    Section "Monitor"
            Identifier      "DisplayPort-2"
            Option          "Ignore"        "true"
    	Option		"DefaultModes"	    "true"
    EndSection

    Section "Device"
    	Driver 		"via"
    	VendorName  	"VIA Tech"
    	BoardName   	"via"
    	Identifier	"Configured Video Device"
    EndSection

    Section "Screen"
    	DefaultDepth 24
    	SubSection "Display"
    		Virtual 1280 800
    		Depth  24
    	EndSubSection
    	Identifier	"Default Screen"
    	Device		"Configured Video Device"
    EndSection

    Section "DRI"
    	Group 0
    	Mode 0666
    EndSection

    Section "Extensions"
    	Option	"Composite"			"Enable"
    EndSection

openchrome
----------

Openchrome is an open source driver for VIA graphics, however it is at
times unreliable and at some points has even prevented the installer
displaying correctly. However should you wish to you can install it
using the xf86-video-openchrome package.

What works
==========

Tested to work:

-   Xorg using openchrome driver, VESA caused segmentation fault on X
    startup
-   Audio works out-of-the-box, but volume "Front"-channel was very
    silent level, so check this too if you cannot hear any sound even
    you have set "Master" to 100%
-   Microphone
-   Bluetooth
-   Wlan
-   Memory Card reader

Not have been tested
====================

Not yet tested if works at all:

-   Suspend
-   Hibernate
-   Webcamera

lspci output
============

    00:00.0 Host bridge: VIA Technologies, Inc. VX800 Host Bridge (rev 12)
    00:00.1 Host bridge: VIA Technologies, Inc. VX800/VX820 Error Reporting
    00:00.2 Host bridge: VIA Technologies, Inc. VX800/VX820 Host Bus Control
    00:00.3 Host bridge: VIA Technologies, Inc. VX800 PCI to PCI Bridge
    00:00.4 Host bridge: VIA Technologies, Inc. VX800/VX820 Power Management Control
    00:00.5 PIC: VIA Technologies, Inc. VX800/VX820 APIC and Central Traffic Control
    00:00.6 Host bridge: VIA Technologies, Inc. VX800/VX820 Scratch Registers
    00:00.7 Host bridge: VIA Technologies, Inc. VX800/VX820 North-South Module Interface Control
    00:01.0 VGA compatible controller: VIA Technologies, Inc. VX800/VX820 Chrome 9 HC3 Integrated Graphics (rev 11)
    00:03.0 PCI bridge: VIA Technologies, Inc. VX800/VX820 PCI Express Root Port
    00:03.1 PCI bridge: VIA Technologies, Inc. VX800/VX820 PCI Express Root Port
    00:0d.0 FLASH memory: VIA Technologies, Inc. Secure Digital Memory Card Controller
    00:0f.0 IDE interface: VIA Technologies, Inc. VX800 Serial ATA and EIDE Controller
    00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev a0)
    00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev a0)
    00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev a0)
    00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 90)
    00:11.0 ISA bridge: VIA Technologies, Inc. VX800/VX820 Bus Control and Power Management
    00:11.7 Host bridge: VIA Technologies, Inc. VX8xx South-North Module Interface Control
    00:14.0 Audio device: VIA Technologies, Inc. VT1708/A [Azalia HDAC] (VIA High Definition Audio Controller) (rev 20)
    01:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless Network Adapter (rev 01)
    02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8040 PCI-E Fast Ethernet Controller (rev 13)

lsusb output
============

    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 004 Device 002: ID 0a5c:2101 Broadcom Corp. A-Link BlueUsbA2 Bluetooth
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 001 Device 002: ID 0ac8:c326 Z-Star Microelectronics Corp. 
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samsung_NC20&oldid=255640"

Category:

-   Samsung
