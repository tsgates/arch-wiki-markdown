Toshiba Tecra A8
================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Reference Information                                              |
| -   2 General Information                                                |
|     -   2.1 Important information                                        |
|     -   2.2 Technical Specifications                                     |
|     -   2.3 lspci (on model PTA83E)                                      |
|                                                                          |
| -   3 Installation                                                       |
| -   4 State of the drivers                                               |
|     -   4.1 What works                                                   |
|     -   4.2 What needs special hacks for getting to work                 |
|         -   4.2.1 Audio system                                           |
|         -   4.2.2 Synaptics Touchpad                                     |
+--------------------------------------------------------------------------+

Reference Information
---------------------

For this wiki, I also used information from the Gentoo wiki (page no
longer exists).

General Information
-------------------

This wiki will present how to install Arch Linux on a Toshiba Tecra A8.

> Important information

A BIOS update is mandatory so that Arch Linux can boot. Otherwise, the
supplied BIOS gives a lot of APIC errors. The BIOS updating procedure
can be done by using the software supplied by Toshiba at bios update.
Note that this requires that you run the program on windows.

> Technical Specifications

 

    Processor: Intel Core Duo 1.83 GHz T2400
    Memory: 512 MB 
    HDD: 80 GB FUJITSU MHV2080B
    DVD+/-RW : Matsushita DVD-RAM UJ-841S 
    Video Card: Intel 945GM
    Display: 1280x800 @ 60Hz
    Audio: Intel ICH7
     

  

> lspci (on model PTA83E)

 

    00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03)
    00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
    00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
    00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
    01:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
    02:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
    03:0b.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
    03:0b.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller
    03:0b.3 SD Host controller: Texas Instruments PCIxx12 SDA Standard Compliant SD Host Controller
     

Installation
------------

I had everything prepartitioned from a previous linux install and as
such I cannont give any insight on this matter. The installs is
flawless, using the Don't panic install cd.

State of the drivers
--------------------

> What works

 

    Gigabit ethernet controller: out of the box
    USB controller and ports: out of the box
    Touchpad: requires tweaking for enabling scrolling
    Intel 3945abg  wireless: out of the box using iwlwifi
    CPU stepping : out of the box
    Cooler stepping: out of the box
    Display at 1280x800: out of the box
     

> What needs special hacks for getting to work

Audio system

The integrated sound card works out of the box, but the integrated
speakers don't. To enable the integrated speakers do:

    echo options snd_hda_intel model=basic >> /etc/modprobe.d/modprobe.conf

Synaptics Touchpad

It works out of the box but without scrollzone.

To enable scrollzone use the ideas specified in touchpad / section ALPS

 

     Section "InputDevice"
           Identifier  "Touchpad"
    	Driver  "synaptics"
    	Option  "Device"   "/dev/input/mouse0"
    	Option  "Protocol"   "auto-dev"
    	Option  "LeftEdge"   "130"
    	Option  "RightEdge"   "840"
    	Option  "TopEdge"   "130"
    	Option  "BottomEdge"   "640"
    	Option  "FingerLow"   "7"
    	Option  "FingerHigh"   "8"
    	Option  "MaxTapTime"   "180"
    	Option  "MaxTapMove"   "110"
    	Option  "EmulateMidButtonTime"   "75"
    	Option  "VertScrollDelta"   "20"
    	Option  "HorizScrollDelta"   "20"
    	Option  "MinSpeed"   "0.25"
    	Option  "MaxSpeed"   "0.50"
    	Option  "AccelFactor"   "0.010"
    	Option  "EdgeMotionMinSpeed"   "200"
    	Option  "EdgeMotionMaxSpeed"   "200"
    	Option  "UpDownScrolling"   "1"
    	Option  "SHMConfig"   "on"
    	Option  "Emulate3Buttons"   "on"
    EndSection
     

Do not enable circular scrolling as it will freaze the pointer in the
center of the screen.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Tecra_A8&oldid=225302"

Category:

-   Toshiba
