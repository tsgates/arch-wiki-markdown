ASUS A53T
=========

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Summary                                                            |
| -   2 Installation                                                       |
| -   3 Hardware                                                           |
|     -   3.1 CPU                                                          |
|     -   3.2 Audio                                                        |
|     -   3.3 Video                                                        |
|     -   3.4 Wireless                                                     |
|     -   3.5 Webcam                                                       |
|     -   3.6 lspci Output                                                 |
|     -   3.7 lsusb Output                                                 |
+--------------------------------------------------------------------------+

Summary
-------

Comprehensive review available here:
http://techreport.com/articles.x/21717

-   Processor: AMD A6-3400M 1.4GHz Quad Core
-   RAM: 4GB
-   Video: Radeon HD 6720G2 1GB (Radeon HD 6520G + Radeon HD 6650M)
-   Hard Drive: 750GB

Installation
------------

Requires addition of the following to boot options:

     radeon.modeset=0

Timeouts experienced while formatting each partition of the hard drive.
Cause as yet unconfirmed (perhaps webcam), appears harmless just have to
wait 2 minutes between each partition format, the installer has not
crashed.

Installation otherwise trouble free, no missing drivers etc to
complicate the process.

x86_64 required to recognise full RAM quantity, only 2.2GB available
under i686.

Hardware
--------

> CPU

Works fine with cpufrequtils, powernow-k8 driver.

> Audio

Pulseaudio required, with libflashsupport-pulse from AUR required for
sound in Flash video.

Crackled sound can be fixed by editing /etc/pulse/default.pa and adding
tsched=0 to the load-module module-udev-detect line

     load-module module-udev-detect tsched=0

Credit to heftig from thread here:
https://bbs.archlinux.org/viewtopic.php?pid=920549

> Video

xf86-video-ati supported by default. Catalyst driver required to take
full advantage of dual graphics processors. Catalyst installation OK
following instructions on Arch Wiki.

HDMI port is fully supported through Catalyst, audio and video confirmed
working.

> Wireless

Working fine, no workarounds required.

> Webcam

Working fine, no workarounds required.

> lspci Output

     00:00.0 Host bridge: Advanced Micro Devices [AMD] Family 12h Processor Root Complex
     00:01.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Device 9647
     00:01.1 Audio device: Advanced Micro Devices [AMD] nee ATI BeaverCreek HDMI Audio [Radeon HD 6500D and 6400G-6600G series]
     00:02.0 PCI bridge: Advanced Micro Devices [AMD] Family 12h Processor Root Port
     00:04.0 PCI bridge: Advanced Micro Devices [AMD] Family 12h Processor Root Port
     00:05.0 PCI bridge: Advanced Micro Devices [AMD] Family 12h Processor Root Port
     00:10.0 USB controller: Advanced Micro Devices [AMD] Hudson USB XHCI Controller (rev 03)
     00:11.0 SATA controller: Advanced Micro Devices [AMD] Hudson SATA Controller [AHCI mode] (rev 40)
     00:12.0 USB controller: Advanced Micro Devices [AMD] Hudson USB OHCI Controller (rev 11)
     00:12.2 USB controller: Advanced Micro Devices [AMD] Hudson USB EHCI Controller (rev 11)
     00:14.0 SMBus: Advanced Micro Devices [AMD] Hudson SMBus Controller (rev 13)
     00:14.2 Audio device: Advanced Micro Devices [AMD] Hudson Azalia Controller (rev 01)
     00:14.3 ISA bridge: Advanced Micro Devices [AMD] Hudson LPC Bridge (rev 11)
     00:14.4 PCI bridge: Advanced Micro Devices [AMD] Hudson PCI Bridge (rev 40)
     00:14.7 SD Host controller: Advanced Micro Devices [AMD] Hudson SD Flash Controller
     00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 0 (rev 43)
     00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 1
     00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 2
     00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 3
     00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 4
     00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 6
     00:18.6 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 5
     00:18.7 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 7
     01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Whistler [AMD Radeon HD 6600M Series]
     02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
     03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)

> lsusb Output

     Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
     Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
     Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
     Bus 003 Device 002: ID 04f2:b23b Chicony Electronics Co., Ltd 
     Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_A53T&oldid=213883"

Category:

-   ASUS
