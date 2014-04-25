ASUS Eee PC 1001px
==================

  

Contents
--------

-   1 Introduction
-   2 Installation
-   3 Fn keys
-   4 Laptop Mode Tools & powersaving
-   5 Graphics
-   6 Wireless
-   7 Hardware information
    -   7.1 lspci
    -   7.2 lsusb

Introduction
------------

How to install Arch Linux on the Asus Eee PC 1001px.

The same model was sold in Europe under the name Eee PC R101.

Installation
------------

The Intel Atom 450N supports x86_64-instructions and 64bit-Arch runs
perfectly fine.

To boot from an USB stick it is necessary to deactivate the "Boot
Booster"-option in the BIOS or otherwise the Asus seems to skip all
detection scans and will just boot from harddisk. Press F2 repeatedly
during the fortunately short POST to enter the BIOS. Deactivate "Boot
Booster" and select your USB stick as the first HDD in the HDD list.
(The "Removable Device" in the main boot devices list is something
different.)

See USB Installation Media.

When partitioning you may want to keep the EFI-partition (usually the
last, smallest partition). It allows to use the "Boot Booster"-Feature
and to jump over certain tests before booting. Do not panic however if
you deleted it, the partition may be restored. Look on the eeePC-Forum
for it.

Fn keys
-------

Install acpi-eeepc-generic from AUR and add this file
https://github.com/nbigaouette/acpi-eeepc-generic/blob/afeb3a328258b0298a5edaa0e8de22d1bb48643d/acpi-eeepc-1001PX-events.conf

Laptop Mode Tools & powersaving
-------------------------------

The powersaving-mechanisms provided by Laptop Mode Tools seem to work.

Standby (Suspend-to-ram) works perfectly fine with hotkey. Hibernate
(Suspend-to-disk) was not tested.

Spinning down the harddrive works.

Adjusting the brightness of the display works with hotkeys after adding
the following to your kernel-boot-options

     acpi_osi=Linux acpi_backlight=vendor

To adjust the brightness from the command line, you can write values 0
to 10 (inclusive) to
/sys/devices/virtual/backlight/acpi_video0/brightness.

In some cases this causes problems and erratic brightness adjustment
when using hotkeys. Using the kernel-boot-option

     acpi_osi=Linux

alone seems to fix that.

Personal Remark: The overall endurance seems good. While I never
actually reached the promised 10h, 8h-9h are possible with dimmed
display, 4h while really working with it. The power-saving-support is
probably not worse than on Windows.

Another edit: I recommend getting kernel-netbook and not using
acpi_osi=Linux anymore.

Graphics
--------

The integrated GPU (Pineview) is supported with KMS by the i915 kernel
module. Use xf86-video-intel for Xorg

See also Intel.

Wireless
--------

Wireless is fully supported by ath9k module in all three modes of
operation (b/g/n).

Hardware information
--------------------

> lspci

    00:00.0 Host bridge: Intel Corporation Pineview DMI Bridge
    00:02.0 VGA compatible controller: Intel Corporation Pineview Integrated Graphics Controller
    00:02.1 Display controller: Intel Corporation Pineview Integrated Graphics Controller
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02) 
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation Tigerpoint LPC Controller (rev 02)
    00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA AHCI Controller (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
    01:00.0 Ethernet controller: Atheros Communications Atheros AR8132 / L1c Gigabit Ethernet Adapter (rev c0)
    02:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)

> lsusb

    Bus 005 Device 002: ID 0b05:1788 ASUSTek Computer, Inc. 
    Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 001 Device 002: ID 13d3:5119 IMC Networks 
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_1001px&oldid=232016"

Category:

-   ASUS

-   This page was last modified on 27 October 2012, at 18:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
