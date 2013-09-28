HP nx70x0
=========

Work in progress - by Joffer

I am currently running Arch on this laptop, problem free so far, but
I've not tried infrared, bluetooth and the media card reader. I'm
available for PM in the forum.

The nx7000 series comes in (at least) two versions, one with a 1680x1050
display and another with a 1280x800 (or whatever the lower widescreen
resolution is). My laptop has a 1680x1050 display, 1.6GHz Pentium M and
1GB RAM.

nx7000 and nx7010 are more or less the same laptop..

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Modules                                                            |
| -   2 xorg                                                               |
| -   3 Hardware info                                                      |
|     -   3.1 lspci                                                        |
+--------------------------------------------------------------------------+

> Modules

-   Ethernet: 8139cp
-   Wireless: ipw2100 (nx7000) / ipw2200 (nx7010))
-   Audio: snd-intel-8x0 / snd-pcm-oss
-   Video: ati

> xorg

I'm running xorg 7 (modular) with the ati driver from xorg, using Gnome
2.12 as my DE/WM at the moment. I get between 1700 and 1900 in glxgears
(glxgears and glxinfo are part of the 'mesa' package).

This is my xorg.conf for Xorg7 (modular):

    Section "ServerLayout"
    	Identifier     "X.org Configured"
    	Screen		"Screen0"
    	InputDevice    "Mouse0" "CorePointer"
    	InputDevice    "Keyboard0" "CoreKeyboard"
    EndSection

    Section "Files"
    	RgbPath		"/usr/share/X11/rgb"
    	ModulePath	"/usr/lib/xorg/modules"
    	FontPath	"/usr/share/fonts/misc"
    	FontPath	"/usr/share/fonts/75dpi"
    	FontPath	"/usr/share/fonts/100dpi"
    	FontPath	"/usr/share/fonts/TTF"
    	FontPath	"/usr/share/fonts/Type1"
    	FontPath	"/usr/share/fonts/artwiz-fonts"
    	FontPath	"/usr/share/fonts/cyrillic"
    	FontPath	"/usr/share/fonts/terminus"
    	FontPath	"/usr/share/fonts/util"
    EndSection

    Section "Module"
    	Load	"record"
    	Load	"xtrap"
    	Load	"glx"
    	Load	"dbe"
    	Load	"dri"
    	Load	"extmod"
    	Load	"freetype"
    	Load	"type1"
    EndSection

    Section "InputDevice"
    	Identifier	"Keyboard0"
    	Driver		"kbd"
    	Option		"XkbLayout"	"no"
    	Option		"XkbVariant"	",qwerty"
    	Option		"XkbRules"	"xorg"
    EndSection

    Section "InputDevice"
    	Identifier	"Mouse0"
    	Driver		"mouse"
    	Option		"Protocol"	"imps/2"
    	Option		"Device"	"/dev/input/mice"
    	Option		"Buttons"	"5"
    	Option		"ZAxisMapping"	"4 5"
    EndSection

    Section "Monitor"
    	Identifier	"Monitor0"
    	VendorName	"HP LCD"
    	ModelName	"0"
    	Option		"DPMS"	"true"
    EndSection

    Section "Device"
    	Identifier  "Card0"
    	Driver      "ati"
    	VendorName  "ATI Technologies Inc"
    	BoardName   "Radeon R250 Lf [FireGL 9000]"
    	BusID       "PCI:1:0:0"
    EndSection

    Section "Screen"
    	Identifier "Screen0"
    	Device     "Card0"
    	Monitor    "Monitor0"
    	DefaultDepth	24
    	SubSection "Display"
    		Viewport   0 0
    		Modes	"1680x1050" "1024x768" 
    		Depth     8
    	EndSubSection
    	SubSection "Display"
    		Viewport   0 0
    		Modes	"1680x1050" "1024x768" 
    		Depth     16
    	EndSubSection
    	SubSection "Display"
    		Viewport   0 0
    		Modes	"1680x1050" "1024x768" 
    		Depth     24
    	EndSubSection
    EndSection

    Section "DRI"
    	Group	"users"
    	Mode	0660
    EndSection

> Hardware info

lspci

    00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller (rev 03)
    00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01)
    00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01)
    00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 01)
    00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 01)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81)
    00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 01)
    00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 01)
    00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 01)
    00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
    00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 01)
    01:00.0 VGA compatible controller: ATI Technologies Inc Radeon R250 Lf [FireGL 9000] (rev 01)
    02:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 80)
    02:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 20)
    02:02.0 Network controller: Intel Corporation PRO/Wireless 2200BG (rev 05)
    02:04.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller

Please note that this output shows a ipw2200 wireless card, instead of a
ipw2100. Thats because I've changed it myself. It originally came with a
ipw2100.

  
 More info later.. (hopefully)

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_nx70x0&oldid=196632"

Category:

-   HP
