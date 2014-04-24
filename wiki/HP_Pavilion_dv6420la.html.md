HP Pavilion dv6420la
====================

Contents
--------

-   1 About this laptop
-   2 Foreword
-   3 Video
-   4 Webcam
-   5 Sound
-   6 Ports and drives
-   7 Power management
-   8 Input devices
-   9 Networking

About this laptop
-----------------

lspci:

    00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
    00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
    00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
    00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
    00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
    00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
    00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
    00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
    00:02.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
    00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
    00:05.0 VGA compatible controller: nVidia Corporation C51 [Geforce 6150 Go] (rev a2)
    00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
    00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
    00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
    00:0a.3 Co-processor: nVidia Corporation MCP51 PMU (rev a3)
    00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
    00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
    00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev f1)
    00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev f1)
    00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2)
    00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
    00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
    00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
    00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
    00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
    00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
    03:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev 02)
    07:05.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
    07:05.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19)
    07:05.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 01)
    07:05.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 0a)
    07:05.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)

cpuinfo:

    processor	: 0
    vendor_id	: AuthenticAMD
    cpu family	: 15
    model		: 104
    model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-56
    stepping	: 1
    cpu MHz		: 1800.000
    cache size	: 512 KB
    physical id	: 0
    siblings	: 2
    core id	: 0
    cpu cores	: 2
    fdiv_bug	: no
    hlt_bug	: no
    f00f_bug	: no
    coma_bug	: no
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 1
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy misalignsse ts fid vid ttp tm stc 100mhzsteps
    bogomips	: 3620.85
    clflush size	: 64

    processor	: 1
    vendor_id	: AuthenticAMD
    cpu family	: 15
    model		: 104
    model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-56
    stepping	: 1
    cpu MHz		: 1800.000
    cache size	: 512 KB
    physical id	: 0
    siblings	: 2
    core id		: 1
    cpu cores	: 2
    fdiv_bug	: no
    hlt_bug		: no
    f00f_bug	: no
    coma_bug	: no
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 1
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy misalignsse ts fid vid ttp tm stc 100mhzsteps
    bogomips	: 3620.85
    clflush size	: 64

And the kernel I'm using at the moment:

    Linux laptop 2.6.23-ARCH #1 SMP PREEMPT Fri Dec 21 19:39:35 UTC 2007 i686 AMD Turion(tm) 64 X2 Mobile Technology TL-56 AuthenticAMD GNU/Linux

  

Foreword
--------

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: All info refer   
                           to ancient kernel        
                           version. (Discuss)       
  ------------------------ ------------------------ ------------------------

Apparently this laptop has issues with APIC, booting without any
parameters seems to lead to some lockups. this guy wrote a nice list of
possible boot parameters and their effects, I'll quote them just in case
they're gone at the time you read this.

Boot Options

vanilla/no options: Allows for a random crash in all kernels tested
(2.6.18 thru 2.6.20-rc4). Xen does not work with this option.

iommu=off: Works perfectly with stock 2.6.18 Debian kernels. On newer
kernels (2.6.20-rc5) it suffers from the reboot freeze at ‘Saving system
clock..’ that was encountered with the pci=pirqmask option until a
recent acpid upgrade resolved it with that option on newer kernels. The
changelog for apcid only lists an update on handling Xorg events. It
seems interesting that the change affected the reboot problem when using
pci=pirqmasq, but not when using iommu=off on the newer kernels. Xen
works with this option.

Emailed from James Zuelow who notes “After browsing the LKML archives
about the nForce chipset and ACPI, I found an entry describing
commenting out an nVidia specific section of the iommu code. Not wanting
to dig that deeply into the code..” “..I decided to try booting without
any ACPI or pci options, and iommu=off. It works great. With
pci=usepirqmask I couldn’t reboot reliably, and would still get lockups
occasionally by starting konsole, and using tab completion.”

noapic: Works fine with all kernels, but leaves USB2.0 in an unusable
state. ( dmesg shows irq 7: nobody cared ) Xen doesn’t work with this.

agp=off: allows the s2disk and s2ram to work properly with nvidia, may
not be necessary in the future

pci=pirqmask: Works great, USB2.0 works. Reported instability, but much
less frequent, and often not encountered. Triggered sometimes by
repeated use of terminal bell (tab completion) and on one occasion
during the fsck of disk on startup (yikes). Seems to be more stable once
nvidia GUI is active. A reboot freeeze with this option was resolved
with acpid 1.04-5 as noted in the Changelog. Xen doesn’t work with this.

  
 I've been using iommu=off and it seems to be working great, no lockups
so far or anything since pci=pirqmask seems to make the laptop very
unstable at times, sometimes I would find that my laptop locked up after
leaving it turned on with the lid closed for many hours.

Video
-----

This laptop has a "Geforce 6150 Go" card as you could see on the lspci,
there's nothing to say here since it works normally with the nvidia
drivers on the repos, no issues, also tv-out works nicely. Screen
backlight dimming works with the Fn keys, it's even possible to set it
on kpowersave.

Webcam
------

See Webcam Setup.

Sound
-----

Works, nothing to configure or anything, including the internal mic
(works with a external mic too) and the headphone jack, also the SPDIF
jack works too, I thought it wouldn't.

Ports and drives
----------------

CD/DVD drive works, I tried burning a CD on k3b and it worked perfectly.
Also tried the card reader, works as it is expected to. Didn't try the
firewire port but I assume it works and I'll say the same about the
expresscard slot.

Power management
----------------

powernow-k8 works, so we're able to get cpu freq scaling:

    powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-56 processors (2 cpu cores) (version 2.00.00)
    powernow-k8:    0 : fid 0xa (1800 MHz), vid 0x12
    powernow-k8:    1 : fid 0x8 (1600 MHz), vid 0x13
    powernow-k8:    2 : fid 0x0 (800 MHz), vid 0x1e

Didn't try suspend/hibernate, but a google search reveals that other
people seems to have luck with it.

Input devices
-------------

HP_Pavilion_dv6018 also worked here. This is a laptop for Latin America,
so their keyboard layout is "la-latin1" on rc.conf and "latam" on
xorg.conf.

To use sensor keys and remote control you need to set keyboard model in
/etc/X11/xorg.conf

       Option "XkbModel" "hpzt11xx"

Add this command to some startup script, /etc/rc.local in Arch Linux:

       setkeycodes e008 221 e00e 226 e00c 213

And finally add these commands to startup of your windowmanager or
desktop environment. I put them to ~/.xinitrc

       xmodmap -e "keycode 197 = XF86Pictures"
       xmodmap -e "keycode 237 = XF86Video"
       xmodmap -e "keycode 118 = XF86Music"

TODO: Add Fn+fx keys Remote control mimics keyboard, no additional
software needed. Range is about 4 meters.

Networking
----------

Only tried it with ndiswrapper, took the driver from the Windows Vista
partition, works perfectly. Ethernet works too with the forcedeth driver
and I think I'll never have the need to use the internal modem, but I
think it's one of those that are only supported by linuxant, so it uses
a propietary driver. (too much work for something that I'll never use)

Wireless card also works flawlessly with broadcom-wl module from the
AUR.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_dv6420la&oldid=296165"

Category:

-   HP

-   This page was last modified on 4 February 2014, at 13:03.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
