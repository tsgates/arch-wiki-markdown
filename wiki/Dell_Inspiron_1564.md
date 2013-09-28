Dell Inspiron 1564
==================

This page is about my experiences with a Dell Inspiron 1564, using Arch
i686.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 System Specs                                                       |
| -   2 Hardware Details                                                   |
| -   3 What Works                                                         |
| -   4 What Does Not Work                                                 |
| -   5 What Has Not Been Tested                                           |
+--------------------------------------------------------------------------+

System Specs
------------

There are several configurations of this machine. Mine is as follows:

CPU: Intel Core i3 330M (2.13GHz)

RAM: 3072MB (1x1024 + 1x2048) 1067MHz DDR3 Dual Channel

Disk: 320GB Serial ATA (5400RPM) Upgraded with Seagate Momentus 7200.4
500GB Upgraded with WD Scorpio Black 750GB 7200RPM Adv. Format

LCD: 15.6" 1366X768 HD WLED

Video: 512 MB ATI Mobility Radeon HD 4330

WLAN: Dell 1397 Mini (a/b/g) (Broadcom BCM4312 chipset) Upgraded with
Intel Wireless WiFi Link 5100 agn

Hardware Details
----------------

lspci output:

     00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 12)
     00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16 Root Port (rev 12)
     00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
     00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06)
     00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 06)
     00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 06)
     00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 (rev 06)
     00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 (rev 06)
     00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06)
     00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6)
     00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 06)
     00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA AHCI Controller (rev 06)
     00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 06)
     02:00.0 VGA compatible controller: ATI Technologies Inc M92 LP [Mobility Radeon HD 4300 Series]
     02:00.1 Audio device: ATI Technologies Inc RV710/730
     04:00.0 Network controller: Intel Corporation Wireless WiFi Link 5100
     05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
     ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 02)
     ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 02)
     ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
     ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
     ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
     ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)

lsusb output:

     Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
     Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
     Bus 001 Device 008: ID 413c:8162 Dell Computer Corp. 
     Bus 001 Device 007: ID 413c:8161 Dell Computer Corp. 
     Bus 001 Device 006: ID 0c45:6480 Microdia 
     Bus 001 Device 005: ID 0bda:0158 Realtek Semiconductor Corp. Mass Storage Device
     Bus 001 Device 003: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub (part of BCM2046 Bluetooth)
     Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
     Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

What Works
----------

-   CPU frequency scaling
-   Coretemp module for temperature monitoring
-   Function keys
-   Card Reader
-   Microphone
-   Web cam
-   Using the ATI Catalyst driver the following works:
    -   Suspend and hibernate
    -   3D acceleration
    -   VAAPI GPU video acceleration (see here)
    -   HDMI Video (audio not tested)

- Using xf86-video-ati the following works:

-   -   Suspend and hibernate
    -   3D acceleration
    -   Power profiling
    -   Temperature monitoring

What Does Not Work
------------------

As of Catalyst 10.7, the new ATI 2D Acceleration Architecture causes
black rectangle corruption. (See ATI bugs #1839 and #1845)

Currently, the fix involves reverting back to the old XAA acceleration.
To do this run the following as root:

    aticonfig --set-pcs-str=DDX,ForceXAA,TRUE

What Has Not Been Tested
------------------------

-   Bluetooth
-   HDMI Audio

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Inspiron_1564&oldid=231868"

Category:

-   Dell
