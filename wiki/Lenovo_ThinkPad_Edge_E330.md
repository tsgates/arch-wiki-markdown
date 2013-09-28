Lenovo ThinkPad Edge E330
=========================

  Summary
  ---------------------------------------------------------------------------------------
  This article covers the Arch Linux support for the Lenovo ThinkPad Edge E330s laptop.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Review                                                             |
| -   3 Hardware                                                           |
|     -   3.1 lspci                                                        |
|     -   3.2 lsusb                                                        |
|                                                                          |
| -   4 Configuration                                                      |
|     -   4.1 Clickpad                                                     |
|     -   4.2 Video                                                        |
|     -   4.3 Wireless                                                     |
|         -   4.3.1 Intel Centrino Wireless-N 2230 (rev c4)                |
|                                                                          |
|     -   4.4 Sound                                                        |
|     -   4.5 Webcam                                                       |
|     -   4.6 Power                                                        |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Brightness control                                           |
|     -   5.2 USB2.0 not working or giving kernel traces                   |
+--------------------------------------------------------------------------+

Installation
------------

I've fully copied the system from my former notebook to the new disc and
made it booting with grub rescue shell.

Review
------

Check this
http://www.notebookcheck.net/Review-Lenovo-Thinkpad-Edge-E330-Notebook.83754.0.html
for a hardware review.

Hardware
--------

My notebook is a LENOVO 3354ALG/3354ALG, BIOS H3ET65WW(1.02) 09/12/2012
with a Core i3-3110M cpu, memory upgraded to 2x4GB and I've instantly
replaced the 320GB hdd with a 64GB Crucial m4 slim(!) SSD.

Using Kernel 3.7.2

  Device                                              Works
  --------------------------------------------------- -----------------------------------------------------------
  Video                                               Yes
  Ethernet                                            Yes
  Wireless (Intel Centrino Wireless-N 2230 (rev c4)   Yes (but a bit slower than expected, not above 150MBit/s)
  Bluetooth                                           Yes
  Audio                                               Yes
  Camera                                              Yes
  Card Reader                                         Yes
  USB 2.0                                             Yes - see below
  USB 3.0                                             Yes

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
    00:1f.0 ISA bridge: Intel Corporation HM77 Express Chipset LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
    00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
    02:00.0 Network controller: Intel Corporation Centrino Wireless-N 2230 (rev c4)
    03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5209 PCI Express Card Reader (rev 01)
    08:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 07)

> lsusb

    Bus 001 Device 002: ID 045e:00e1 Microsoft Corp. Wireless Laser Mouse 6000 Reciever
    Bus 003 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 004 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 003: ID 8087:07da Intel Corp. 
    Bus 003 Device 004: ID 04ca:700c Lite-On Technology Corp. 

Configuration
-------------

> Clickpad

worked out of the box for my with xf86-input-synaptics 1.6.2-4

> Video

In order to use the builtin intel graphics adapter you will have to
install the corresponding drivers:

    # pacman -S xf86-video-intel intel-dri libva-intel-driver

Option "AccelMethod" "SNA" in xorg.conf works well for me.

> Wireless

Intel Centrino Wireless-N 2230 (rev c4)

Works out of the box. Module: iwldvm

> Sound

Works out of the box. Module: snd-hda-intel

> Webcam

Works out of the box (tested using cheese)

> Power

Suspend works out of the box. Hibernate works using pm-utils (see
Suspend and Hibernate#Kernel). Uswsusp was not tested

Troubleshooting
---------------

> Brightness control

Brightness can only be switched between darkest and brightest values
using OS method. So it's better to use hardware vendor to control it:
append "acpi_backlight=vendor" to the grub kernel line!

> USB2.0 not working or giving kernel traces

Not sure if this was solved by using acpi_backlight=vendor or by
blacklisting these modules I don't use:

    cat /etc/modprobe.d/modprobe.conf 
    blacklist joydev
    blacklist pcspkr
    blacklist iTCO_vendor_support
    blacklist iTCO_wdt

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_Edge_E330&oldid=248698"

Category:

-   Lenovo
