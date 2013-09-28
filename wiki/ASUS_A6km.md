ASUS A6km
=========

This page describes troubleshooting and configuration specific to the
Asus A6km laptop.

On this model, a known buggy BIOS problem results in a system hang when
any USB device, such as a mouse, is attached at bootup. This can be
fixed using a downgraded BIOS version (can be downloaded here). The
installation described uses this 202 BIOS version and so far no problems
have been encountered, even the power management modules behave
properly.

See the Beginners' Guide for installation instructions.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Wireless                                                           |
| -   3 Audio                                                              |
| -   4 Touchpad                                                           |
| -   5 Webcam                                                             |
| -   6 Modem                                                              |
| -   7 IrDA                                                               |
| -   8 Card Reader                                                        |
| -   9 Tv Out                                                             |
| -   10 Other Software/Utilities                                          |
|     -   10.1 Power Management                                            |
|     -   10.2 Suspend to RAM/Disk                                         |
+--------------------------------------------------------------------------+

Hardware
--------

-   1.8GHz AMD Turion 64 ML34 Processor
-   15.4" XGA Widescreen TFT Screen
-   256MB Nvidia Geforce Go 7300
-   100GB Hard Drive
-   RTL-8169 Gigabit Ethernet Integrated Card
-   Broadcom Integrated 802.11g wireless card
-   DVD Dual Layer Drive
-   Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro
-   1.3 Mega Pixel USB Intergrated Camera
-   SiS AC'97 Sound Card

lspci outout:

    00:00.0 Host bridge: Silicon Integrated Systems [SiS] Device 0756 (rev 02)
    00:01.0 PCI bridge: Silicon Integrated Systems [SiS] PCI-to-PCI bridge
    00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS964 [MuTIOL Media IO] (rev 36)
    00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev 01)
    00:02.6 Modem: Silicon Integrated Systems [SiS] AC'97 Modem Controller (rev a0)
    00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS] AC'97 Sound Controller (rev a0)
    00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.1 Controller (rev 0f)
    00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.1 Controller (rev 0f)
    00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.1 Controller (rev 0f)
    00:03.3 USB Controller: Silicon Integrated Systems [SiS] USB 2.0 Controller
    00:09.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 54g] 802.11g Wireless LAN Controller (rev 02)
    00:0a.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b3)
    00:0a.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 08)
    00:0a.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 17)
    00:0a.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 08)
    00:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet (rev 10)
    00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
    00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
    00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
    00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
    01:00.0 VGA compatible controller: nVidia Corporation G72M [Quadro NVS 110M/GeForce Go 7300] (rev a1)

Wireless
--------

For wireless, can use the b43-fwcutter package to install the firmware,
(run lsmod command to check if the b43 module is running):

    # b43-fwcutter -w /lib/firmware /path_to_driver

the driver can be found here

Audio
-----

The sound card [SiS AC'97] was detected on installation and the correct
modules for audio loaded at bootup.

See ALSA for installation/configuration details.

Touchpad
--------

To get the touchpad working, install the synaptics package:

    # pacman -S xf86-input-synaptics

Webcam
------

The webcam was detected on installation and the modules loaded at
bootup.

    Linux video capture interface: v2.00
    stkwebcam: Syntek USB2.0 Camera is now controlling video device /dev/video0

The cheese webcam package worked well with the installed drivers. Cheese
is installed with Gnome extras packages.

Modem
-----

Not tested so far

IrDA
----

First make sure the device is enabled in the BIOS, then once booted up,
start the daemon:

    # /etc/rc.d/irda start

One way to test the device is to install the utilities:

    # pacman -S irda-utils

and run the command:

    # irdadump

the output should look something like this when working:

    13:13:59.173537 xid:cmd 851b3728 > ffffffff S=6 s=0 (14) 
    13:13:59.263432 xid:cmd 851b3728 > ffffffff S=6 s=1 (14) 
    13:13:59.353394 xid:cmd 851b3728 > ffffffff S=6 s=2 (14) 
    13:13:59.443431 xid:cmd 851b3728 > ffffffff S=6 s=3 (14) 
    13:13:59.533395 xid:cmd 851b3728 > ffffffff S=6 s=4 (14) 
    13:13:59.626729 xid:rsp 851b3728 < 26098ceb S=6 s=4 Sony Ericss hint=9124 [ PnP Modem IrCOMM  IrOBEX ] (28) 
    13:13:59.633430 xid:cmd 851b3728 > ffffffff S=6 s=5 (14) 
    13:13:59.723433 xid:cmd 851b3728 > ffffffff S=6 s=* asus-archlinux-64 hint=0400 [ Computer ] (33) 

The 'Sony Ericss' entry is a nearby (direct line of sight) mobile phone
with infra-red enabled.

There should also be an irda0 entry when running the # ip a command.

Card Reader
-----------

Not tested so far

Tv Out
------

Not tested.

Other Software/Utilities
------------------------

> Power Management

For cpu scaling, see CPU Frequency Scaling.

> Suspend to RAM/Disk

For suspend-to-ram, follow the instructions in the Suspend to RAM page.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_A6km&oldid=250473"

Category:

-   ASUS
