Acer Aspire 5745PG
==================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Hardware                                                           |
| -   3 General Installation Guide                                         |
| -   4 Graphics                                                           |
|     -   4.1 Networking                                                   |
|                                                                          |
| -   5 Battery issues                                                     |
| -   6 TouchScreen                                                        |
+--------------------------------------------------------------------------+

Introduction
============

Same laptop as the Acer Aspire 5745G, but this one has an integrated
(USB-connected) touch screen. Everything seems to work fine except for:

-   SD card reader: Sometimes works, sometimes doesn't
-   Touch Screen: Explained below
-   Brightness increasing-decreasing: In gnome-shell one strike of the
    keys increases/decreases two levels of brigthness. One corresponds
    to the Operating System responding to the key, while the other is
    because of the BIOS responding as well. This can be solved by
    disabling GnomeShell brigthness controls or by using the following
    commands to increase/decrease and setting them up to a keyboard
    shortcurt:

    xbacklight -steps 1 -inc 20
    xbacklight -steps 1 -dec 20

Hardware
========

Processor: Intel Core i5-450M 2.4GHz

Video: Intel Integrated Graphics and NVIDIA GeForce GT 330M switchable
(Second Generation)

Audio: Intel Corporation 5 Series/3400 Series Chipset High Definition
Audio (rev 05)

Wired NIC: Atheros Communications AR8151 v1.0 Gigabit Ethernet (rev c0)

Wireless NIC: Broadcom Corporation BCM43225 802.11b/g/n (rev 01)

    $ lspci -nn
    00:00.0 Host bridge [0600]: Intel Corporation Core Processor DRAM Controller [8086:0044] (rev 18)
    00:01.0 PCI bridge [0604]: Intel Corporation Core Processor PCI Express x16 Root Port [8086:0045] (rev 18)
    00:02.0 VGA compatible controller [0300]: Intel Corporation Core Processor Integrated Graphics Controller [8086:0046] (rev 18)
    00:16.0 Communication controller [0780]: Intel Corporation 5 Series/3400 Series Chipset HECI Controller [8086:3b64] (rev 06)
    00:1a.0 USB controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b3c] (rev 05)
    00:1b.0 Audio device [0403]: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio [8086:3b56] (rev 05)
    00:1c.0 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 [8086:3b42] (rev 05)
    00:1c.5 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 [8086:3b4c] (rev 05)
    00:1d.0 USB controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b34] (rev 05)
    00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev a5)
    00:1f.0 ISA bridge [0601]: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller [8086:3b09] (rev 05)
    00:1f.2 SATA controller [0106]: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA AHCI Controller [8086:3b29] (rev 05)
    00:1f.3 SMBus [0c05]: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller [8086:3b30] (rev 05)
    00:1f.6 Signal processing controller [1180]: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem [8086:3b32] (rev 05)
    01:00.0 VGA compatible controller [0300]: nVidia Corporation GT216 [GeForce GT 330M] [10de:0a29] (rev a2)
    01:00.1 Audio device [0403]: nVidia Corporation High Definition Audio Controller [10de:0be2] (rev a1)
    02:00.0 Ethernet controller [0200]: Atheros Communications AR8151 v1.0 Gigabit Ethernet [1969:1073] (rev c0)
    03:00.0 Network controller [0280]: Atheros Communications Inc. AR9287 Wireless Network Adapter (PCI-Express) [168c:002e] (rev 01)
    3f:00.0 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers [8086:2c62] (rev 05)
    3f:00.1 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture System Address Decoder [8086:2d01] (rev 05)
    3f:02.0 Host bridge [0600]: Intel Corporation Core Processor QPI Link 0 [8086:2d10] (rev 05)
    3f:02.1 Host bridge [0600]: Intel Corporation Core Processor QPI Physical 0 [8086:2d11] (rev 05)
    3f:02.2 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d12] (rev 05)
    3f:02.3 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d13] (rev 05)

General Installation Guide
==========================

It's in spanish, though: [1]

Graphics
========

Starting from BIOS version 1.15, enabling discrete graphics (nVidia)
through the BIOS Setup Menu is impossible, since the option is disabled.
This makes the nVidia card to behave like the ones with Optimus
Techonology do, and though optimus is not supported in linux, there is a
way to make use of the card, and that is by installing and configuring
Bumblebee, which will transfer render orders to the card and direct the
output to the screen thorugh VirtualGL.

Using FN+Left when in intel graphics and VGA connected changes between
screen modes (clone, right-of, etc.)

Networking
----------

Wi-Fi and Ethernet connection work just fine, though you will have to
set wi-fi up. Start by loading the new atheros module:

    # modprobe ath9k

See Wireless Setup for more info.

Battery issues
==============

Battery problems we're fixed when BIOS version v1.15 was released.
Before that, one could not see the amount of battery left in the device
nor any kind of information related to it.

TouchScreen
===========

The touchscreen used is an eGalax one:

    I: Bus=0003 Vendor=0eef Product=7253 Version=0210
    N: Name="eGalax Inc. USB TouchController"
    P: Phys=usb-0000:00:1a.0-1.3/input0
    S: Sysfs=/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input7
    U: Uniq=
    H: Handlers=mouse0 event7 
    B: PROP=0
    B: EV=1b
    B: KEY=421 30001 0 0 0 0
    B: ABS=1000000003f
    B: MSC=10

    I: Bus=0006 Vendor=0eef Product=0020 Version=0001
    N: Name="eGalaxTouch Virtual Device for Multi"
    P: Phys=
    S: Sysfs=/devices/virtual/input/input20
    U: Uniq=
    H: Handlers=mouse3 event20 
    B: PROP=0
    B: EV=b
    B: KEY=400 0 0 0 0 0
    B: ABS=660800001000003

    I: Bus=0006 Vendor=0eef Product=0010 Version=0001
    N: Name="eGalaxTouch Virtual Device for Single"
    P: Phys=
    S: Sysfs=/devices/virtual/input/input21
    U: Uniq=
    H: Handlers=mouse4 event21 js0 
    B: PROP=0
    B: EV=b
    B: KEY=30000 0 0 0 0
    B: ABS=1000003

You can donwload the drivers here. However, there's an AUR package that
does all the hard work for you: xf86-input-egalax-linux3 (Kernels 3 and
up)

If you have trouble making it work, take a look at this thread: [2]

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_5745PG&oldid=250581"

Category:

-   Acer
