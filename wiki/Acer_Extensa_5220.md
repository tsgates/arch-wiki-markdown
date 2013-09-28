Acer Extensa 5220
=================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Kernel                                                             |
| -   3 CPU                                                                |
| -   4 Graphics                                                           |
| -   5 Touchpad                                                           |
| -   6 Card Reader                                                        |
| -   7 DVD                                                                |
| -   8 Webcam                                                             |
| -   9 Sound                                                              |
| -   10 Networking                                                        |
|     -   10.1 LAN                                                         |
|     -   10.2 WLAN                                                        |
|                                                                          |
| -   11 Firewire                                                          |
| -   12 Untested                                                          |
| -   13 Configuration Files                                               |
|     -   13.1 xorg.conf                                                   |
|     -   13.2 lsusb output                                                |
|     -   13.3 lspci output                                                |
+--------------------------------------------------------------------------+

Hardware
========

Extract from Acer website:

-   Processor: Intel® Celeron™ M processor 530SR (1.73GHz, 1MB cache,
    533MHz FSB) supporting Intel® 64-bit architecture.
-   Display: 15.4” WXGA CrystalBrite widescreen TFT LCD display 1280 x
    800@ 16.7 million colours
-   HDD: 80GB SATA 5400RPM hard disk drive,
-   Card Reader: 5-in-one card reader: SD™ Card, MultiMediaCard, Memory
    Stick®, Memory Stick PRO™ or xD-Picture Card™
-   DVD: 8X DVD Super-Multi dual layer optical drive
-   Battery: Lithium Ion (44.4W, 4000mAh) 6-cell, up to 2 hours battery
    life*
-   Weight: 2.88Kg
-   Dimensions: 360(W) x 267(D) x 30.3/43(H) mm
-   Webcam: Integrated Acer CrystalEye webcam supporting enhanced Acer
    PrimaLite™ technology
-   WLAN: 802.11b/g dual-mode with SignalUp technology (Broadcom 4311
    Chipset)
-   LAN: Gigabit Network Connection supporting Wake-on-LAN

1 x Modem port (56K ITU V.92 with PTT approval, Wake-on-Ring ready)

4 x USB 2.0 ports

1 x IEEE 1394 FireWire

1 x External display (VGA) port

1 x S-Video/TV-out port

1 x Type II PC Card slot + 1 x Express Card /54 slot

1 x line-in jack

1 x Microphone-in jack + 1 x Headphones/speaker/line-out jack

The parameters depend on the submodel.

Kernel
======

The default kernel runs fine, x86_64 and i686.

CPU
===

CPU physically doesn't support SpeedStep or hardware virtualisation. 64
bit is supported.

Graphics
========

Works fine with xf86-video-intel

    # pacman -S xf86-video-intel

With a little work, Compiz Fusion works relatively well. I think I
needed to install libgl-dri and do a lot of the steps listed in the
troubleshooting section of the wiki.

    # pacman -S libgl-dri

Touchpad
========

Install the synaptics package and enable in xorg.conf as demonstrated
below or in wiki page.

    # pacman -S synaptics

Card Reader
===========

Working, but only tested with SD cards. Requires at least tifm_sd module
(perhaps tifm_7xx1, tifm_core and others for other card types if not
automatically loaded). Either add to /etc/rc.conf or modprobe, card
should be autodetected and mounted if HAL is going correctly.

    # modprobe tifm_sd

DVD
===

Didn't require any manual configuration, works fine using default
install options. Drive supposedly supports LightScribe, haven't
attempted to configure.

Webcam
======

Requires installation of linux-uvc-svn and group membership to "video"

    # pacman -S linux-uvc-svn
    # modprobe uvcvideo

Sound
=====

Ensure snd-hda-intel module is loaded and add this to your
/etc/modprobe.d/modprobe.conf:

    options snd-hda-intel model=acer

Worked with the 2GB RAM/160GB HDD/Intel Celeron M-540 model and that
described at the top.

Networking
==========

LAN
---

Works fine with no configuration required.

WLAN
----

b43 module works fine and is probably most recommended with up to date
kernel version. bcm43xx and ndiswrapper both confirmed to work by
Lastebil and OzMick but are probably best used only as alternatives when
b43 doesn't. Connection using b43 is stronger and significantly more
reliable than with ndiswrapper.

Consult the wiki page: https://wiki.archlinux.org/index.php/Wireless#b43

Firewire
========

Works fine. To control playback and download from MiniDV camcorder,
simply had to install Kino, modprobe raw1394 and run Kino as root, refer
to Kino usage manual. One could alternatively change permissions on
relevant device nodes for a cleaner non-root solution.

    # pacman -S kino
    # modprobe raw1394

Untested
========

-   Modem
-   VGA port (Definitely should work; tested on Ubuntu/GNOME)
-   S-Video/TV-out port
-   Type II PC Card slot + 1 x Express Card /54 slot

Configuration Files
===================

xorg.conf
---------

    Section "ServerLayout"
    	Identifier     "Xorg Configured"
    	Screen      0  "Screen0" 0 0
    	InputDevice    "Keyboard0" "CoreKeyboard"
    	InputDevice    "Touchpad" "CorePointer"
    	Option         "AIGLX" "true"
    EndSection

    Section "ServerFlags"
    	Option "AllowMouseOpenFail"  "true"	
    EndSection

    Section "Files"
    	RgbPath      "/usr/share/X11/rgb"
    	ModulePath   "/usr/lib/xorg/modules"
    	FontPath     "/usr/share/fonts/misc:unscaled"
    	FontPath     "/usr/share/fonts/misc"
    	FontPath     "/usr/share/fonts/75dpi:unscaled"
    	FontPath     "/usr/share/fonts/75dpi"
    	FontPath     "/usr/share/fonts/100dpi:unscaled"
    	FontPath     "/usr/share/fonts/100dpi"
    	FontPath     "/usr/share/fonts/PEX"
    	FontPath     "/usr/share/fonts/cyrillic"
    	FontPath     "/usr/share/fonts/Type1"
    	FontPath     "/usr/share/fonts/ttf/western"
    	FontPath     "/usr/share/fonts/ttf/decoratives"
    	FontPath     "/usr/share/fonts/truetype"
    	FontPath     "/usr/share/fonts/truetype/openoffice"
    	FontPath     "/usr/share/fonts/truetype/ttf-bitstream-vera"
    	FontPath     "/usr/share/fonts/latex-ttf-fonts"
    	FontPath     "/usr/share/fonts/defoma/CID"
    	FontPath     "/usr/share/fonts/defoma/TrueType"
    EndSection

    Section "Module"
    	Load  "ddc"
    	Load  "dbe"
    	Load  "dri"
    	Load  "extmod"
    	Load  "glx"
    	Load  "bitmap"
    	Load  "type1"
    	Load  "freetype"
    	Load  "record"
    	Load  "synaptics"
    EndSection
     
    Section "InputDevice"
    	Identifier  "Keyboard0"
    	Driver      "keyboard"
    	Option      "CoreKeyboard"
    	Option "XkbRules" "xorg"
    	Option "XkbModel" "pc105"
    	Option "XkbLayout" ""
    	Option "XkbVariant" ""
    EndSection
     
    Section "InputDevice"
    	Driver          "synaptics"
    	Identifier      "Touchpad"
    	Option  "Device"        "/dev/psaux"
    	Option  "Protocol"      "auto-dev"
    	Option  "SHMConfig"     "on"
    EndSection
     
    Section "Monitor"
    	Identifier "Monitor0"
    	Option "DPMS" "true"
    	HorizSync    28.0 - 96.0
    	VertRefresh  50.0 - 75.0
    EndSection
     
    Section "Device"
    	Identifier  "Card0"
    	Driver      "intel"
    	Option      "XAANoOffscreenPixmaps" "true"
    	Option      "DRI" "true"
    	VendorName  "All"
    	BoardName   "All"
    EndSection

    Section "Screen"
    	Identifier "Screen0"
    	Device     "Card0"
    	Monitor    "Monitor0"
    	Option     "AddARGBGLXVisuals" "True"
    	DefaultColorDepth 24
    	SubSection "Display"
    		Depth     24
    		Modes "1280x800"
    		ViewPort  0 0
    	EndSubSection
    EndSection

    Section "Extensions"
    	Option       "Composite" "Enable"
    EndSection

    Section "DRI"
    	Group 0
    	Mode 0666
    EndSection

lsusb output
------------

    Bus 007 Device 001: ID 0000:0000  
    Bus 006 Device 002: ID 064e:a101 Suyin Corp. 
    Bus 006 Device 001: ID 0000:0000  
    Bus 005 Device 001: ID 0000:0000  
    Bus 004 Device 001: ID 0000:0000  
    Bus 003 Device 001: ID 0000:0000  
    Bus 002 Device 001: ID 0000:0000  
    Bus 001 Device 001: ID 0000:0000  

064e:a101 is the webcam.

lspci output
------------

    00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 03)
    00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 03)
    00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 03)
    00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Contoller #4 (rev 03)
    00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
    00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 03)
    00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
    00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 03)
    00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
    02:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5787M Gigabit Ethernet PCI Express (rev 02)
    04:00.0 Network controller: Broadcom Corporation BCM94311MCG wlan mini-PCI (rev 01)
    0f:06.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
    0f:06.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller
    0f:06.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD)
    0f:06.3 Generic system peripheral [0805]: Texas Instruments PCIxx12 SDA Standard Compliant SD Host Controller

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Extensa_5220&oldid=238908"

Category:

-   Acer
