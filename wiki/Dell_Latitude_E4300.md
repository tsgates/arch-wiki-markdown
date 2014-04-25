Dell Latitude E4300
===================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Out of date.     
                           Covered by Beginners'    
                           guide. (Discuss)         
  ------------------------ ------------------------ ------------------------

This article will tell you how to get the basic components of the laptop
running with Arch.

Contents
--------

-   1 Installation
-   2 Hardware
-   3 Configuration
    -   3.1 Video
    -   3.2 Wi-Fi
    -   3.3 Hotkeys
    -   3.4 Bluetooth

Installation
============

Remember to back up the restore partition if you plan to restore it, or
leave it. The Installation guide should get you running without a
problem.

Hardware
========

The Dell E4300 comes with the following hardware:

-   CPU: Intel Core 2 Duo SP9300 (2.26GHz) or SP9400 (2.40GHz)
-   Screen size: 13.3" TFT WXGA WLEDMonitor (1280x800)
-   Memory: 2GB DDR3-1066MHz SDRAM SO-DIMM
-   Audio: Intel G45 DEVCTG
-   Video: Intel x4500MHD
-   Wireless: Dell Wireless 1397, Dell Wireless 1510, Intel® WiFi Link
    5100, Intel WiFi Link 5300
-   Harddisk: 80GB or 160GB 5200rpm, 160GB or 250GB 7200RPM w/free-fall
    sensor
-   Battery: 6 cell (60Whr) or
-   Optional: Modem, Bluetooth, Webcam, SSD, Smart Card Reader, WWAN
    card and Expansion Bay for second disk.

    [serrghi@arch ~ ]lspci -nn
    00:00.0 Host bridge [0600]: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub [8086:2a40] (rev 07)
    00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller [8086:2a42]
    00:02.1 Display controller [0380]: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller [8086:2a43]
    00:19.0 Ethernet controller [0200]: Intel Corporation 82567LM Gigabit Network Connection [8086:10f5] (rev 03)
    00:1a.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 [8086:2937] (rev 03)
    00:1a.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 [8086:2938] (rev 03)
    00:1a.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 [8086:2939] (rev 03)
    00:1a.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 [8086:293c] (rev 03)
    00:1b.0 Audio device [0403]: Intel Corporation 82801I (ICH9 Family) HD Audio Controller [8086:293e] (rev 03)
    00:1c.0 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 [8086:2940] (rev 03)
    00:1c.1 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 [8086:2942] (rev 03)
    00:1c.3 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 [8086:2946] (rev 03)
    00:1d.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 [8086:2934] (rev 03)
    00:1d.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 [8086:2935] (rev 03)
    00:1d.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 [8086:2936] (rev 03)
    00:1d.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 [8086:293a] (rev 03)
    00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev 93)
    00:1f.0 ISA bridge [0601]: Intel Corporation ICH9M-E LPC Interface Controller [8086:2917] (rev 03)
    00:1f.2 RAID bus controller [0104]: Intel Corporation Mobile 82801 SATA RAID Controller [8086:282a] (rev 03)
    00:1f.3 SMBus [0c05]: Intel Corporation 82801I (ICH9 Family) SMBus Controller [8086:2930] (rev 03)
    02:01.0 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd R5C832 IEEE 1394 Controller [1180:0832] (rev 05)
    02:01.1 SD Host controller [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter [1180:0822] (rev 22)
    0c:00.0 Network controller [0280]: Broadcom Corporation BCM4322 802.11a/b/g/n Wireless LAN Controller [14e4:432b] (rev 01) 

    [serrghi@arch ~ ]cat /proc/cpuinfo
    processor	: 0
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 23
    model name	: Intel(R) Core(TM)2 Duo CPU     P9300  @ 2.26GHz
    stepping	: 6
    cpu MHz	: 800.000
    cache size	: 6144 KB
    physical id	: 0
    siblings	: 2
    core id	: 0
    cpu cores	: 2
    apicid		: 0
    initial apicid	: 0
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 10
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse 
    sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx smx est tm2 
    ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi flexpriority
    bogomips	: 4523.36
    clflush size	: 64
    cache_alignment: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

    processor	: 1
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 23
    model name	: Intel(R) Core(TM)2 Duo CPU     P9300  @ 2.26GHz
    stepping	: 6
    cpu MHz		: 800.000
    cache size	: 6144 KB
    physical id	: 0
    siblings	: 2
    core id		: 1
    cpu cores	: 2
    apicid		: 1
    initial apicid	: 1
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 10
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse 
    sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx smx est tm2 
    ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi flexpriority
    bogomips	: 4523.40
    clflush size	: 64
    cache_alignment	: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

Configuration
=============

Video
-----

The laptop comes with integrated Intel graphics.

    pacman -S xf86-video-intel

Wi-Fi
-----

-   Broadcom: See Broadcom wireless.
-   Intel wireless cards: Installing iwl-5000-ucode should do the trick.

Hotkeys
-------

Install Xbindkeys from extra repo and place the following in
~/.xbindkeysrc This enables the volume(down,up,mute) to function
properly.

    ~/.xbindkeysrc

    #VolDown
    "amixer set Master 5- unmute"
       m:0x0 + c:122
       XF86AudioLowerVolume

    #VolUp
    "amixer set Master 5+ unmute"
       m:0x0 + c:123
       XF86AudioRaiseVolume 

    #VolMute
    "amixer set Master mute"
       m:0x0 + c:121
       XF86AudioMute

Bluetooth
---------

1.  Make sure that BT is enabled in BIOS and that the blue LED is lit up
    (just right of the WiFi indicator)

    modprobe rfkill # 
    modprobe uinput #
    pacman -S bluez # for utils
    pacman -S bluez-hid2hci # for turning BT hub out of keyboard-mode
    bluetoothctl power on

If you're running *Box and you want a nice GUI, get Blueman from
community repo. Everyone else should refeer to the wiki page for
Bluetooth.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_E4300&oldid=302921"

Category:

-   Dell

-   This page was last modified on 2 March 2014, at 14:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
