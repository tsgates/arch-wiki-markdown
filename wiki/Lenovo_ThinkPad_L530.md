Lenovo ThinkPad L530
====================

  Summary
  ---------------------------------------------------------------------------------
  This article covers the Arch Linux support for the Lenovo ThinkPad L530 laptop.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
|     -   1.1 lspci                                                        |
|     -   1.2 lsusb                                                        |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Clickpad                                                     |
|     -   2.2 Video                                                        |
|     -   2.3 Ethernet                                                     |
|     -   2.4 Wireless                                                     |
|         -   2.4.1 Driver                                                 |
|                                                                          |
|     -   2.5 Wireless                                                     |
|     -   2.6 Sound                                                        |
|     -   2.7 Webcam                                                       |
|     -   2.8 Fingerprint Reader                                           |
|     -   2.9 Card Reader                                                  |
|     -   2.10 Trackpoint                                                  |
|     -   2.11 Special key                                                 |
|                                                                          |
| -   3 Troubleshooting                                                    |
| -   4 Link                                                               |
+--------------------------------------------------------------------------+

Hardware
--------

Using Kernel 3.8.5

  Device               Works
  -------------------- ------------
  Video                Yes
  Ethernet             Yes
  Wireless             Yes
  Bluetooth            Yes
  Audio                Yes
  Camera               Yes
  Card Reader          Yes
  Fingerprint Reader   Not Tested
  Touchpad             Yes
  Trackpoint           No

> lspci

    00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09)
    00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
    00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
    00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
    00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 (rev c4)
    00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 (rev c4)
    00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 4 (rev c4)
    00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM76 Express Chipset LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
    00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
    01:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5229 PCI Express Card Reader (rev 01)
    06:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 [Taylor Peak] (rev 34)
    0c:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168 PCI Express Gigabit Ethernet controller (rev 07)

> lsusb

    Bus 003 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 004 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 003: ID 0a5c:21e6 Broadcom Corp. BCM20702 Bluetooth 4.0 [ThinkPad]
    Bus 003 Device 004: ID 04f2:b2eb Chicony Electronics Co., Ltd 

Configuration
-------------

> Clickpad

The clickpad works with the xf86-input-synaptic driver from extra, but
the left/right click buttons at the bottom of the clickpad do not work.

Install xf86-input-synaptics-clickpad from the AUR.

> Video

In order to use the builtin intel graphics adapter you will have to
install the corresponding drivers:

    # pacman -S xf86-video-intel

> Ethernet

Works out of the box.

> Wireless

Works out of the box.

Driver

rtl8192ce driver LSPCI : Network controller: Realtek Semiconductor Co.,
Ltd. RTL8188CE 802.11b/g/n WiFi Adapter (rev 01)

> Wireless

Install : bluez and blueman

> Sound

Works out of the box.

> Webcam

Works out of the box.

> Fingerprint Reader

Try : fingerprint-gui

> Card Reader

Works out of the box. Tips : Card appears in : /dev/mmc*

> Trackpoint

Don't work :-(

https://bugzilla.kernel.org/show_bug.cgi?id=33292

> Special key

All special keys works except the microphone mute key : see
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/751471).

Troubleshooting
---------------

Trackpoint

Link
----

Experiences with thinkpad l530 on arch linux

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_L530&oldid=253666"

Category:

-   Lenovo
