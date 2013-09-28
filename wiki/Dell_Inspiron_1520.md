Dell Inspiron 1520
==================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Intro                                                              |
|     -   1.1 Summary                                                      |
|     -   1.2 To do                                                        |
|     -   1.3 Working                                                      |
|     -   1.4 Unknown / Untested                                           |
|                                                                          |
| -   2 Installation                                                       |
| -   3 Kernel                                                             |
| -   4 X.org                                                              |
|     -   4.1 NVIDIA GeForce 8600M GT                                      |
|                                                                          |
| -   5 Hardware                                                           |
|     -   5.1 Microphone                                                   |
|     -   5.2 lspci                                                        |
|                                                                          |
| -   6 Power Management                                                   |
|     -   6.1 Suspend and Resume                                           |
|     -   6.2 CPU Frequency Scaling                                        |
|     -   6.3 ACPI                                                         |
|                                                                          |
| -   7 Links                                                              |
|     -   7.1 General                                                      |
|     -   7.2 Linux on a Dell Inspiron 1520                                |
+--------------------------------------------------------------------------+

Intro
-----

> Summary

This is the wiki entry for the Dell XPS 1520 laptop. It's heavily under
construction, and it's based on the Dell Inspiron 8500 page.

> To do

-   everything...

> Working

-   Ethernet: Broadcom chip, use b44 module
-   Wireless: Dell Wireless 1395 802.11g Mini Card (Broadcom BCM4311)
    Use b43-firmware from the AUR.
-   Audio: intel8x0 (Sigmatel)
-   Display: 1440x900
-   Multimedia keys (set up xmodmap)
-   nVidia GeForce 8600M GT (256MB GDDR2)
-   SD card slot
-   Webcam: OmniVision Technologies, Inc. OV2640

> Unknown / Untested

-   Modem
-   Firewire

Installation
------------

Just follow the Beginners' Guide

Kernel
------

Works with 2.6.39 out of the box.

X.org
-----

This is my working xorg.conf:

> NVIDIA GeForce 8600M GT

This config should work with all mobile GeForce chipsets. Install the
synaptic package for the touchpad.

  

    # **********************************************************************
    # Modules section. This allows modules to be specified
    # **********************************************************************

    Section "Module"
           Load  "ddc"  # ddc probing of monitor
           Load  "dbe"
           Load  "dri"
           Load  "extmod"
           Load  "glx"
           Load  "bitmap" # bitmap-fonts
           Load  "type1"
           Load  "freetype"
           Load  "record"
           Load  "synaptics"
    EndSection


    # ******************************
    # Files section
    # ******************************

    Section "Files"
           ModulePath   "/usr/lib/xorg/modules"
           FontPath     "/usr/share/fonts/misc"
           FontPath     "/usr/share/fonts/75dpi"
           FontPath     "/usr/share/fonts/100dpi"
           FontPath     "/usr/share/fonts/Type1"
           FontPath     "/usr/share/fonts/encodings"
           FontPath     "/usr/share/fonts/cyrillic"
    EndSection


    # ******************************
    # Server flags section
    # ******************************

    Section "ServerFlags"

    EndSection

    # ******************************
    # Core keyboard's InputDevice section
    # ******************************

    Section "InputDevice"
           Identifier  "Keyboard0"
           Driver      "keyboard"
           Option      "CoreKeyboard"
           Option "XkbRules" "xorg"
           Option "XkbModel" "pc105"
           Option "XkbLayout" "se"
    EndSection

    # ******************************
    # Core Pointer's InputDevice section
    # ******************************

    Section "InputDevice"
           Identifier      "USB Mouse"
           Driver          "mouse"
           Option          "Device"                "/dev/input/mice"
           Option		"SendCoreEvents"	"true"
           Option          "Protocol"              "IMPS/2"
           Option          "ZAxisMapping"          "4 5"
           Option          "Buttons"               "5"
    EndSection

    Section "InputDevice"
           Identifier      "Touchpad"
           Driver          "synaptics"
           Option  "Device"        "/dev/input/mouse0"
           Option  "Protocol"      "auto-dev"
           Option  "LeftEdge"      "1700"
           Option  "RightEdge"     "5300"
           Option  "TopEdge"       "1700"
           Option  "BottomEdge"    "4200"
           Option  "FingerLow"     "25"
           Option  "FingerHigh"    "30"
           Option  "MaxTapTime"    "180"
           Option  "MaxTapMove"    "220"
           Option  "VertScrollDelta" "100"
           Option  "MinSpeed"      "0.06"
           Option  "MaxSpeed"      "0.12"
           Option  "AccelFactor" "0.0010"
           Option  "SHMConfig"     "on"
    EndSection

    # ******************************
    # Monitor section
    # ******************************

    Section "Monitor"
           Identifier "Dell Inspiron 1520 WXGA+ LCD"
           Option "DPMS" "true"
    EndSection


    # ******************************
    # Graphics device section
    # ******************************

    Section "Device"
           Identifier  "NVIDIA GeForce 8600M GT"
           Driver      "nvidia"
           VendorName  "NVIDIA"
           BoardName   "8600M GT"
           Option	"NoLogo"	"true"
           Option	"AllowGLXWithComposite"	"true"
           Option	"Coolbits"	"1"
           Option	"Triplebuffer"	"true"
           Option "OnDemandVBlankInterrupts" "true"
    EndSection

    # ******************************
    # Screen sections
    # ******************************

    Section "Screen"
           Identifier "Screen0"
           Device     "NVIDIA GeForce 8600M GT"
           Monitor    "Dell Inspiron 1520 WXGA+ LCD"
           DefaultColorDepth 24
           SubSection "Display"
                   Depth     24
                   Modes "1440x900" "1280x800" "1280x768" "1280x720" "1024x768" "800x600" "640x480"
           EndSubSection
           SubSection "Display"
                   Depth     32
                   Modes "1440x900" "1280x800" "1280x768" "1280x720" "1024x768" "800x600" "640x480"
           EndSubSection
    EndSection


    # ******************************
    # ServerLayout sections.
    # ******************************

    Section "ServerLayout"
           Identifier     "Xorg Configured"
           Screen      0  "Screen0" 0 0
           InputDevice    "Keyboard0" "CoreKeyboard"
           InputDevice	"USB Mouse"	"CorePointer"
           InputDevice    "Touchpad" "SendCoreEvents"
    EndSection

    # ******************************
    # DRI extension options section
    # ******************************

    Section "DRI"
           Group "video"
           Mode 0666
    EndSection

    Section "Extensions"
           Option "Composite" "Enable"
    EndSection

Hardware
--------

> Microphone

To activate the microphone with alsamixer, open alsamixer and press Tab.
Now activate Capture by pressing Space. If it does not work, play around
with the other settings.

> lspci

    00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
    00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI Express Root Port (rev 0c)
    00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 02)
    00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 02)
    00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 02)
    00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2)
    00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 02)
    00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 02)
    00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA IDE Controller (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
    01:00.0 VGA compatible controller: nVidia Corporation G84 [GeForce 8600M GT] (rev a1)
    03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
    03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 05)
    03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
    03:01.2 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
    03:01.3 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 12)
    0c:00.0 Network controller: Broadcom Corporation BCM4311 802.11b/g WLAN (rev 01)

Power Management
----------------

I suggest you read Gentoo Power Management Guide for great information.

> Suspend and Resume

Suspend and resume works 100% with the default kernel.

Hibernation doesn't work, all it does is shut down the computer.

> CPU Frequency Scaling

See the main CPU Frequency Scaling article.

> ACPI

To turnoff the computer when you press the power button, put the
following in /etc/acpi/handler.sh

    button/power)
           case "$2" in
               PBTN)
                       logger "PowerButton pressed: $2"
                       halt
               ;;
               *)    logger "ACPI action undefined: $2" ;;
           esac

Replace the "halt" line with the shutdown command of your choice.

  
 To turn off the backlight of an ATI Radeon Mobility card, put the
following in /etc/acpi/handler.sh

    button/lid)
           case "$2" in
               LID)
                   logger "ACPI button/lid action"
                   STATE=`radeontool light`
                   case "$STATE" in
                       "The radeon backlight looks on") radeontool light off ;;
                       "The radeon backlight looks off") radeontool light on ;;
                   esac
                   ;;
           esac
           ;;

This requires that you have the radeontool package installed (it is in
AUR). You also need to add "acpid" to the DAEMONS array in /etc/rc.conf.

Links
-----

> General

-   Gentoo Power Management Guide
-   Gentoo Dell Inspiron 8500 Wiki
-   Software Suspend 2
-   Linux on Laptops
-   This report is listed at the TuxMobil: Linux Laptop and Notebook
    Installation Guides Survey: DELL.

> Linux on a Dell Inspiron 1520

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Inspiron_1520&oldid=231856"

Category:

-   Dell
