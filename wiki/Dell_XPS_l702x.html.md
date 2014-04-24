Dell XPS l702x
==============

This page is work in progress

This page is about Dell XPS l702x hardware configuration

Contents
--------

-   1 System Settings
    -   1.1 Official Specifications
    -   1.2 Specifications according to uname, lspci and lsusb
        -   1.2.1 Microarchitecture, processor and platform
        -   1.2.2 PCI buses and devices
        -   1.2.3 USB devices
-   2 Hardware Setup
    -   2.1 Card Reader
    -   2.2 Special Touch Keys
-   3 Power Management Setup

System Settings
===============

> Official Specifications

-   Processor: Intel 2nd Generation Core Processor
-   Chipset: Intel HM67 Express Chipset
-   Memory: Up to 16GBs of DDR3 in no 3D model
-   Video Cards
    -   Integrated Video Card: Intel HD3000
        -   Mini-DisplayPort wired to Intel HD
    -   Dedicated Video Card:NVIDIA Corporation GF106M [GeForce GT 555M]
        no 3D model
        -   HDMI 1.4 wired to Nvidia Card
    -   Display: 17.3" HD+(1600x900) or FHD(1920x1080) wired to Intel HD
        in no 3D version
-   Audio and Speakers:
    -   Sound Card: Intel HDA
    -   Speakers: JBL 2.1: 2 x 5W + subwoofer 12 W = 22 W RMS
-   Hard Drives: (2) SATA 3 ports for 2.5" HDDs
-   Ethernet: Realtek Ethernet Gigabit Controller
-   Wireless: Intel Centrino Wireless and Bluetooth Card
-   WebCam: Quanta Computers 2MP Webcam
-   Card Reader: JMicron 9 in 1 Card Reader
-   Accelerometer: ST Microelectronics DE351DL Motion Sensor
-   Ports:
    -   (1) Microphone
    -   (1) Headphone JACK
    -   (1) Headphone JACK with SPID/F
    -   (1) eSATA/PowerShare) combined with (1) USB 2.0
    -   (1) USB 2.0
    -   (2) USB 3.0
    -   (1) AC adapter connector
-   Three Touch Multimedia Keys

> Specifications according to uname, lspci and lsusb

Microarchitecture, processor and platform

    uname -mpi

    x86_64 unknown unknown

PCI buses and devices

    lspci

    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
    00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
    00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05)
    00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
    00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5)
    00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b5)
    00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b5)
    00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5 (rev b5)
    00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 6 (rev b5)
    00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)
    00:1f.0 ISA bridge: Intel Corporation HM67 Express Chipset Family LPC Controller (rev 05)
    00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 05)
    00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
    01:00.0 VGA compatible controller: NVIDIA Corporation GF106M [GeForce GT 555M] (rev ff)
    03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6230 [Rainbow Peak] (rev 34)
    04:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)
    05:00.0 System peripheral: JMicron Technology Corp. SD/MMC Host Controller (rev 30)
    05:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host Controller (rev 30)
    05:00.3 System peripheral: JMicron Technology Corp. MS Host Controller (rev 30)
    05:00.4 System peripheral: JMicron Technology Corp. xD Host Controller (rev 30)
    0a:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)

USB devices

    lsusb

    Bus 004 Device 003: ID 8086:0189 Intel Corp. 
    Bus 004 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 003: ID 0408:2fb1 Quanta Computer, Inc. 
    Bus 003 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Hardware Setup
==============

Card Reader
-----------

    With a card inside a card reader

    # echo 1 > /sys/bus/pci/rescan

The command isn't needed until the next start of the machine.

Special Touch Keys
------------------

Only two keys can be remaped to use on DE, second and trird touch keys.

    Touchkeys Scancodes

    0xDB # First touch key, Dell apparently uses a key sequence here where 0xDB is a modifer, 0x2D stands for the touch key and 0x19 for the monitor toggle
    0x85 # Second touch key
    0x84 # Third touch key

One method to remap it is as systemd service:

    /etc/systemd/system/multi-user.target.wants/setsecondkey.service

    [Unit]
    Description=Setkeycode Second Key

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/setkeycodes 0x85 202

    [Install]
    WantedBy=multi-user.target

Power Management Setup
======================

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_XPS_l702x&oldid=290999"

Category:

-   Dell

-   This page was last modified on 30 December 2013, at 21:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
