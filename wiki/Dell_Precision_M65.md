Dell Precision M65
==================

Contents
--------

-   1 Hardware
    -   1.1 hwd output
    -   1.2 lsusb
    -   1.3 lspci
-   2 Configuration details
    -   2.1 SATA Controller
    -   2.2 Xorg.conf (including synaptics touchpad)
    -   2.3 Bluetooth
    -   2.4 Hard Drive
    -   2.5 Display
    -   2.6 Network
    -   2.7 Audio
    -   2.8 VGA
    -   2.9 FireWire
    -   2.10 Modem
    -   2.11 Fn Keys
    -   2.12 SmartCard Reader (under baterry cell)

Hardware
========

hwd output
----------

    $ sudo hwd -s

     HARDWARE DETECT ver 5.3.1 (simple mode)
     Kernel     : 2.6.23.14-ARCH
     CPU & Cache: Processor 0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz 1000MHz, 4096 KB Cache
     Processor 1: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz 1000MHz, 4096 KB Cache
     Sound(a)   : 82801G ICH7 Family High Definition Audio Controller module: snd-hda-intel
     Video      : G72GL [Quadro FX 350M] server: Xorg (vesa)
     Driver     : nvidia   module: nvidia
     Monitor    : Generic Monitor  H: 28.0-96.0kHz V: 50.0-75.0Hz
     Mouse      : Microsoft Corp. IntelliMouse Optical   xtype: IMPS2 device: /dev/input/mice # My usb mouse, however M65 has the great Synaptics touchpad + trackpoint
     HDD        : 82801GBM/GHM ICH7 Family SATA IDE Controller module: ata_piix
     USB        : 82801G ICH7 Family USB UHCI Controller #4 module: uhci_hcd
     USB2       : 82801G ICH7 Family USB2 EHCI Controller module: ehci_hcd
     USB Reader : O2 Micro, Inc. Oz776 SmartCard Reader
     Ethernet   : NetXtreme BCM5752 Gigabit Ethernet PCI Express module: tg3
     Network    : PRO/Wireless 3945ABG Network Connection module: iwl3945
     Firewire   : Firewire IEEE 1394  module: ohci1394
     PCMCIA slot: Cardbus bridge module: yenta_cardbus

  

lsusb
-----

    Bus 004 Device 001: ID 0000:0000
    Bus 002 Device 003: ID 0b97:7762 O2 Micro, Inc. Oz776 SmartCard Reader
    Bus 002 Device 002: ID 0b97:7761 O2 Micro, Inc.
    Bus 002 Device 001: ID 0000:0000
    Bus 005 Device 006: ID 413c:8103 Dell Computer Corp. Wireless 350 Bluetooth
    Bus 005 Device 005: ID 045e:0039 Microsoft Corp. IntelliMouse Optical
    Bus 005 Device 004: ID 413c:0058 Dell Computer Corp.
    Bus 005 Device 002: ID 413c:a005 Dell Computer Corp.
    Bus 005 Device 001: ID 0000:0000
    Bus 003 Device 001: ID 0000:0000
    Bus 001 Device 001: ID 0000:0000

  

lspci
-----

    00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
    00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express PCI Express Root Port (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01)
    00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 01) 
    00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 01)
    00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 01)
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 01)
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 01)
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 01)
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 01)
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
    00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 01)
    00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 01)
    00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
    01:00.0 VGA compatible controller: nVidia Corporation G72GL [Quadro FX 350M] (rev a1)
    03:01.0 CardBus bridge: O2 Micro, Inc. Cardbus bridge (rev 21)
    03:01.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02)
    09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752 Gigabit Ethernet PCI Express (rev 02)
    0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)

Configuration details
=====================

> SATA Controller

Intel 82801GBM/GHM (ICH7 Family) SATA IDE Controller Works with "Intel
ESB. ICH, PIIX3, PIIX4 PATA/SATA support" (ata_pIIx module) from kernel.
ATA/ATAPI/MFM/RLL support must be set off in the kernel.

> Xorg.conf (including synaptics touchpad)

    Section "ServerLayout"
       Identifier     "Layout0"
       Screen      0  "Screen0" 0 0
       InputDevice    "Keyboard0"
       InputDevice    "Mouse0"
       InputDevice    "Mouse1"
    EndSection

    Section "Files"
       RgbPath         "/usr/X11R6/lib/X11/rgb"
    EndSection

    Section "Module"
       Load           "dbe"
       Load           "extmod"
       Load           "type1"
       Load           "freetype"
       Load           "glx"
       Load           "synaptics"
    EndSection

    Section "ServerFlags"
       Option         "Xinerama" "0"
    EndSection

    Section "InputDevice"
       # touchpoint
       Identifier     "Mouse0"
       Driver         "mouse"
       Option         "Protocol" "ImPS/2"
       Option         "Device" "/dev/input/mice"
       Option         "Emulate3Buttons" "yes"
       Option         "ZAxisMapping" "4 5"
       Option         "CorePointer"
    EndSection

    Section "InputDevice"
            # Synaptics touchpad
    #	 Option  "InputFashion"  "Mouse"
    #	 Option  "RBCornerButton" "0"
    #	 Option  "TapButton1"  "0"
    #	 Option  "TapButton2"  "0"
    #	 Option  "Buttons"  "8"
    #	 Option  "ZAxisMapping"  "4 5 6 7"
    #	 Option  "TopEdge"  "100"
    #	 Option	 "BottomEdge"  "670"
    #	 Option  "LeftEdge"  "100"
    #	 Option  "RightEdge"  "950"
    #	 Option  "MaxSpeed"  "2.0"
    #	 Option  "MinSpeed"  "0.5"
       Identifier     "Mouse1"
       Driver         "synaptics"
       Option         "Protocol" "auto-dev"
       Option         "SendCoreEvents" "true"
       Option         "Device" "/dev/psaux"
       Option         "HorizEdgeScroll" "0"
       Option         "SHMConfig" "on"
    #	 Option  "RTCornerButton" "0"
       Option         "AccelFactor" "0.07"
    EndSection

    Section "InputDevice"
    #    Option	"CustomKeycodes" "on"
       Identifier     "Keyboard0"
       Driver         "kbd"
    EndSection

    Section "Monitor"
       # HorizSync source: edid, VertRefresh source: edid
       Identifier     "Monitor0"
       VendorName     "Unknown"
       ModelName      "Seiko"
       HorizSync       30.0 - 75.0
       VertRefresh     60.0
       Option         "DPMS"
    EndSection

    Section "Monitor"
       Identifier     "Monitor1"
       VendorName     "Unknown"
       ModelName      "DELL 2001FP"
       HorizSync       31.0 - 80.0
       VertRefresh     56.0 - 76.0
    EndSection

    Section "Device"
       Identifier     "Videocard0"
       Driver         "nvidia"
       VendorName     "NVIDIA Corporation"
       BoardName      "Quadro FX 350M"
    EndSection

    Section "Device"
       Identifier     "Videocard1"
       Driver         "nvidia"
       VendorName     "NVIDIA Corporation"
       BoardName      "Quadro FX 350M"
       BusID          "PCI:1:0:0"
       Screen          1
    EndSection

    Section "Screen"
       Identifier     "Screen0"
       Device         "Videocard0"
       Monitor        "Monitor0"
       DefaultDepth    24
       Option         "TwinView" "1"
       Option         "metamodes" "DFP-0: 1440x900 +0+150, DFP-1: nvidia-auto-select +1440+0"
       SubSection     "Display"
           Depth       24
       EndSubSection
    EndSection

    Section "Screen"
       Identifier     "Screen1"
       Device         "Videocard1"
       Monitor        "Monitor1"
       DefaultDepth    24
       Option         "TwinView" "0"
       Option         "metamodes" "DFP-1: nvidia-auto-select +0+0"
    EndSection

  

> Bluetooth

Bluetooth works hci_usb kernel driver and if wireless switch is in "on"
position. I installed bluez-libs and bluez-utils packages from extra
repositorty. If I run

    $ sudo sh /etc/rc.d/bluetooth start 

then

    $hcitool dev 
    Devices:
           hci0    00:16:41:92:77:1A

> Hard Drive

100 GB @ 7200 RPM

> Display

1920x1200 WUXGA

> Network

Ethernet adapter Broadcom BCM5752 works with "Broadcom Tigon3" (module
tg3) from kernel.

Wifi adapter Intel 3945ABG works perfectly with iwl3945 module from
http://www.intellinuxwireless.org/?p=iwlwifi or with the iwlwifi package
from core repository, if you have a distribution kernel. Don't use the
ipw driver (http://ipw3945.sourceforge.net)! It's slow and using the
binary userspace daemon. However, in the iwl driver (unlike to ipw
driver) by that time do not support the led diode, indicating the
wireless activity.

> Audio

Intel 82801 (ICH7) High definition family controller works with "Intel
HD Audio" (snd-dha-intel module) from kernel. But sometimes, the PCM
channel disappear from the mixer. I do not know why, perhaps bug in the
driver.?

> VGA

Nvidia Quadro FX 350M works perfectly with the nvidia closed-source
driver.

> FireWire

Not tested

> Modem

Not tested

> Fn Keys

Works on Arch using Gnome.

> SmartCard Reader (under baterry cell)

Not tested

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Precision_M65&oldid=196585"

Category:

-   Dell

-   This page was last modified on 23 April 2012, at 12:50.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
