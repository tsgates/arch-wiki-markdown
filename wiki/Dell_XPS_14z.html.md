Dell XPS 14z
============

  

Contents
--------

-   1 Hardware state
-   2 System Settings
-   3 System Setup
    -   3.1 Graphics
        -   3.1.1 Nvidia card
        -   3.1.2 Intel card
    -   3.2 Power management
    -   3.3 Special trick for acpid
    -   3.4 Other

Hardware state
--------------

Device

Status

Network

Works

Wireless

Works

Sound

Works

Bluetooth

Works

Touchpad

Works

Graphics

Modify

USB 3.0

Not tested

Webcam

Works

System Settings
---------------

    lspci

    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
    00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
    00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
    00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b4)
    00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 (rev b4)
    00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b4)
    00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 6 (rev b4)
    00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM67 Express Chipset Family LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 04)
    00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 04)
    01:00.0 VGA compatible controller: nVidia Corporation Device 1050 (rev ff)
    07:00.0 Ethernet controller: Atheros Communications AR8151 v2.0 Gigabit Ethernet (rev c0)
    08:00.0 Network controller: Intel Corporation Centrino Advanced-N 6230 (rev 34)
    09:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5116 PCI Express Card Reader (rev 01)
    0f:00.0 USB controller: Texas Instruments Device 8241 (rev 02)

System Setup
------------

> Graphics

Nvidia card

Initially, both the Intel integrated graphics and the Nvidia card will
be active, consuming a lot of power, so you probably want to install
bumblebee and bbswitch. With this laptop, the packages nvidia,
bumblebee-git and bbswitch-git are working fine.

Intel card

From the xps 15z, wiki page, it is reported that using the Intel card
without any modifications can result in poor video performance. A quick
fix that does not make things worse for the 14z is to edit
/boot/grub/menu.lst, and append the following to the kernel section

    kernel /boot/vmlinuz... i915.semaphores=1

> Power management

Classical power saving tricks should apply for this laptop. See the
dedicated pages of acpid, laptop-mode and cpufreq.

First try to install pm-utils.

and see if the following command works successfully:

    # pm-suspend

Normally it should.

> Special trick for acpid

If you wish to use acpid for handling the event for plugging/unplugging
the ac adapter, you should know that the script does not handle it
properly. For some reason, acpi_listen does not report a second argument
in AC|ACAD|ADP0 but ACPI0003:00. In /etc/acpi/handler.sh, you can modify
these lines:

       ac_adapter)
           case "$2" in
               AC|ACAD|ADP0)
               ...

in

       ac_adapter)
           case "$2" in
               AC|ACAD|ADP0|ACPI0003:00)
               ...

If this does not solve your problem, you should be able to see what
event is triggered by plugging/unplugging the laptop using acpi_listen.

> Other

USB 3.0 has not been tested but should be working. The USB 3.0 driver in
the Linux kernel is located in:

    Device Drivers -> USB Support -> xHCI HCD (USB 3.0) support (EXPERIMENTAL)
    SYMBOL: USB_XHCI_HCD

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_XPS_14z&oldid=304833"

Category:

-   Dell

-   This page was last modified on 16 March 2014, at 07:54.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
