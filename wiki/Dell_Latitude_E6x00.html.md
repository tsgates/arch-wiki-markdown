Dell Latitude E6x00
===================

The Dell Latitude E-Series: 6400/6500.

This article will tell you how to get the basic components of the laptop
running with Arch.

Contents
--------

-   1 Installation
-   2 Throttling
-   3 Hardware
    -   3.1 Overview
    -   3.2 Broadcom BCM4312
    -   3.3 Audio
    -   3.4 Video

Installation
------------

The Installation guide should get you running without a problem.

Further help can be found in the Forum:

    * Linux on the Dell Latitude E6400
    * Dell Latitude E6400 internal mic not working

Throttling
----------

This series is known to severely throttle the CPU even on moderately
high temperatures.

For more information see the following links:

-   http://forum.notebookreview.com/dell-latitude-vostro-precision/348221-e6400-overheating-throttling.html
-   http://en.community.dell.com/support-forums/laptop/f/3518/t/19247293.aspx
-   http://en.gentoo-wiki.com/wiki/Dell_Latitude_E6x00#CPU_overheating_throttling

The following is a simple script that overwrites any throttling the BIOS
attempts to do. This makes the CPU run at full speed and as such may
lead to very high temperatures. A clean fan and heatsink however should
be capable of keeping the temperature within acceptable levels.

    #!/bin/bash
    #execute with sudo/as root, exit with ctrl+c
    modprobe msr
    for (( ; ; ))
    do
    	wrmsr 0x199 0xA26 #the value 0xA26 is the maximum VID and FID for a Core 2 Duo P8700, read the actual value for your Core 2 Duo with "rdmsr -f 44:32 0xCE"
    	wrmsr 0x19A 0x0 #this eliminates any clock modulation and super low frequency mode/half multiplier mode

    	sleep 0.1s #this can possibly be reduced, experiment
    done

  

Hardware
--------

> Overview

The Dell E6500 comes with the following hardware:

    $ lspci

    00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Connection (rev 03)
    00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
    00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
    00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
    00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
    00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 3 (rev 03)
    00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
    00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
    00:1f.2 RAID bus controller: Intel Corporation Mobile 82801 SATA RAID Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
    03:01.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
    03:01.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04)
    03:01.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
    0c:00.0 Network controller: Broadcom Corporation BCM4312 802.11b/g (rev 01)

    $ cat /proc/cpuinfo

     processor	: 0
     vendor_id	: GenuineIntel
     cpu family	: 6
     model		: 23
     model name	: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz
     stepping	: 6
     cpu MHz		: 2268.000
     cache size	: 3072 KB
     physical id	: 0
     siblings	: 2
     core id		: 0
     cpu cores	: 2
     apicid		: 0
     initial apicid	: 0
     fdiv_bug	: no
     hlt_bug		: no
     f00f_bug	: no
     coma_bug	: no
     fpu		: yes
     fpu_exception	: yes
     cpuid level	: 10
     wp		: yes
     flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi flexpriority
     bogomips	: 4523.44
     clflush size	: 64
     power management:

     processor	: 1
     vendor_id	: GenuineIntel
     cpu family	: 6
     model		: 23
     model name	: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz
     stepping	: 6
     cpu MHz		: 2268.000
     cache size	: 3072 KB
     physical id	: 0
     siblings	: 2
     core id		: 1
     cpu cores	: 2
     apicid		: 1
     initial apicid	: 1
     fdiv_bug	: no
     hlt_bug		: no
     f00f_bug	: no
     coma_bug	: no
     fpu		: yes
     fpu_exception	: yes
     cpuid level	: 10
     wp		: yes
     flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi flexpriority
     bogomips	: 4523.39
     clflush size	: 64
     power management:

> Broadcom BCM4312

We have to use commercial dirver. More in this wiki: Broadcom BCM4312

> Audio

    Intel HDA (ICH9 Family) HD Audio Controller (rev 03)

    $ head -1 /proc/asound/card0/codec#0
    Codec: IDT 92HD71B7X

    $ head -1 /proc/asound/card0/codec#2
    Codec: Intel G45 DEVCTG

    $ /proc/asound/version 
    Advanced Linux Sound Architecture Driver Version 1.0.19.
    Compiled on Mar  1 2009 for kernel 2.6.28-ARCH (SMP).

    $ cat /etc/modprobe.d/modprobe.conf 
    options snd-hda-intel model=dell-m4-1

    Kernel 2.6.28.x - follow instruction in Dell Latitude E6400 internal mic not working
    Kernel 2.6.29 - Not tested

> Video

Intel MHD4500

    xf86-video-intel 2.4.3-1

Config for current xorg-server v1.5.x:

    $ cat /etc/X11/xorg.conf

     Section "ServerLayout"
       Identifier     "X.org Configured"
       Screen      0  "Screen0" 0 0
       Option "StandbyTime" "5"
       Option "SuspendTime" "10"
       Option "OffTime" "30"
     EndSection

     Section "Files"
        ModulePath   "/usr/lib/xorg/modules"
        FontPath     "/usr/share/fonts/misc"
        FontPath     "/usr/share/fonts/100dpi:unscaled"
        FontPath     "/usr/share/fonts/75dpi:unscaled"
        FontPath     "/usr/share/fonts/TTF"
        FontPath     "/usr/share/fonts/Type1"
     EndSection
     Section "Module"
        Load  "glx"
        Load  "extmod"
        Load  "xtrap"
        Load  "dbe"
        Load  "dri"
        Load  "freetype"
     EndSection
     Section "Monitor"
        #DisplaySize	  330   210	# mm
        Identifier   "Monitor0"
        VendorName   "SEC"
        ModelName    "5441" 
        Option "DPMS" "true"
     EndSection
     Section "Device"
        Identifier  "Card0"
        Driver      "intel"
        VendorName  "Intel Corporation"
        BoardName   "Mobile 4 Series Chipset Integrated Graphics Controller"
        BusID       "PCI:0:2:0"
     EndSection
     Section "Screen"
        Identifier "Screen0"
        Device     "Card0"
        Monitor    "Monitor0"
       SubSection "Display"
         Viewport   0 0
         Depth     1
       EndSubSection
       SubSection "Display"
         Viewport   0 0
         Depth     4
       EndSubSection
       SubSection "Display"
             Viewport   0 0
           Depth     8
        EndSubSection
        SubSection "Display"
    	  Viewport   0 0
    	  Depth     15
      EndSubSection
      SubSection "Display"
    	  Viewport   0 0
    	  Depth     16
      EndSubSection
      SubSection "Display"
    	  Viewport   0 0
    	  Depth     24
      EndSubSection
     EndSection
     Section "DRI"
      Mode        0666
     EndSection

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_E6x00&oldid=298294"

Category:

-   Dell

-   This page was last modified on 16 February 2014, at 07:46.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
