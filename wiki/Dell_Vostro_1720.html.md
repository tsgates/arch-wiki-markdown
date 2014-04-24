Dell Vostro 1720
================

This page deals with setting up Arch Linux on the Dell Vostro 1720
laptop. This page links to the wiki pages relevant for this laptop. In
order to avoid information duplication, this page only states
information that is not on the linked wiki pages.

Contents
--------

-   1 CPU
-   2 Network
    -   2.1 Ethernet
    -   2.2 Wireless
-   3 Touchpad

CPU
---

The processor on this laptop is able to use CPU Frequency Scaling. This
laptop can use the acpi-cpufreq module.

The processor on this laptop is capable of running both the 32 and the
64 bits versions of Arch Linux Arch64_FAQ: How do I determine if my
processor is x86 64 compatible?

    $ cat /proc/cpuinfo
    processor	: 0
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 23
    model name	: Intel(R) Core(TM)2 Duo CPU     T6670  @ 2.20GHz
    stepping	: 10
    cpu MHz		: 2201.000
    cache size	: 2048 KB
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
    cpuid level	: 13
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
                     pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
                     constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor 
                     ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm ida 
                     dts tpr_shadow vnmi flexpriority
    bogomips	: 4391.49
    clflush size	: 64
    cache_alignment	: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

Network
-------

> Ethernet

To know your exact (wired) ethernet card you can run:

    $ lspci -nn | grep Eth
    08:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 03)

The RTL8111/8168B card is supported by the kernel.

> Wireless

To know your exact wireless card you can run:

    $ lspci -nn | grep Net
    0e:00.0 Network controller [0280]: Broadcom Corporation BCM4312 802.11b/g LP-PHY [14e4:4315] (rev 01)

-   This card is supported by the broadcom driver, follow instructions
    here: Broadcom BCM4312
-   This card is partionally supported by the kernel, see here [b43
    known PCI devices [1]]

Touchpad
--------

To find out the exact touchpad you can run:

    $ cat /proc/bus/input/devices
    I: Bus=0011 Vendor=0002 Product=0008 Version=7321
    N: Name="AlpsPS/2 ALPS GlidePoint"
    P: Phys=isa0060/serio1/input0
    S: Sysfs=/devices/platform/i8042/serio1/input/input8
    U: Uniq=
    H: Handlers=mouse1 event8 
    B: EV=b
    B: KEY=420 0 70000 0 0 0 0 0 0 0 0
    B: ABS=1000003

This laptop has the following touchpad: AlpsPS/2 ALPS GlidePoint. Follow
the instructions for the AlpsPS/2 ALPS GlidePoint here:
Touchpad_Synaptics

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Vostro_1720&oldid=196594"

Category:

-   Dell

-   This page was last modified on 23 April 2012, at 12:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
