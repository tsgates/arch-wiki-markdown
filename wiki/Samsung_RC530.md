Samsung RC530
=============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Style need to be  
                           fixed. See Help:Style.   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This is valid for many newer Samsung laptops. The system tested here is
a Samsung RC 530. Since the models do not differ greatly in their
overall design chances are good that the whole RC series is covered by
the following steps.

    * Optimus setup (bumblebee, bbswitch)
    * CPU frequency sheduling (cputools)
    * vendor specific kernel extensions (samsung_tools)

    uname-a                                                                                                                       Linux 3.5.3-1-ARCH #1 SMP PREEMPT 

Good news everyone!

     * 100% compatibility

Quirks:

     * do not use acpi_call (https://aur.archlinux.org/packages.php?ID=39470) since it breaks hibernation/suspend with pm-utils
     * ensure that you do not use Window Manager specific hotkeys like Fn + FX to adjust anything if you intend to keep the samsung_tools config for xbindkeys

{{bc| Hardware (lshw): - Nvidia/Intel Optimus

     *-display               
          description: VGA compatible controller
          product: 2nd Generation Core Processor Family Integrated Graphics Controller
          vendor: Intel Corporation
          physical id: 2
          bus info: pci@0000:00:02.0
          version: 09
          width: 64 bits
          clock: 33MHz
          capabilities: vga_controller bus_master cap_list rom
          configuration: driver=i915 latency=0
          resources: irq:43 memory:f6400000-f67fffff memory:d0000000-dfffffff ioport:e000(size=64)

- Intel i7: *-cpu product: Intel(R) Core(TM) i7-2630QM CPU @ 2.00GHz
vendor: Intel Corp. physical id: 1 bus info: cpu@0 size: 800MHz
capacity: 800MHz width: 64 bits capabilities: fpu fpu_exception wp vme
de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush
dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp x86-64
constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc
aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16
xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer xsave avx
lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi
flexpriority ept vpid cpufreq <nowki> - Intel Wireless

    wireless=IEEE 802.11bgn
                   resources: irq:45 memory:f7200000-f7201fff
           *-pci:2
                description: PCI bridge
                product: 6 Series/C200 Series Chipset Family PCI Express Root Port 4
                vendor: Intel Corporation
                physical id: 1c.3
                bus info: pci@0000:00:1c.3
                version: b4
                width: 32 bits
                clock: 33MHz
                capabilities: pci normal_decode bus_master cap_list
                configuration: driver=pcieport
                resources: irq:19 ioport:b000(size=4096) memory:f6800000-f71fffff ioport:f2100000(size=10485760)

</nowiki>

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Samsung Tools - fan-control and power-management                   |
|     -   1.1 Description                                                  |
|                                                                          |
| -   2 Laptop Mode Tools                                                  |
| -   3 Optimus                                                            |
+--------------------------------------------------------------------------+

Samsung Tools - fan-control and power-management
------------------------------------------------

The Samsung Tools are crucial to save power. On a Samsung RC 530 sample
results are 4-5h work-time, using the standard battery as power suply
(using laptop-mode, samsung_tools, low brightness, active WLAN and no
Bluetooth).

> Description

"It enables control in a friendly way of the devices found on Samsung
laptops (bluetooth, wireless, webcam, backlight, CPU fan, special keys)
and the control of various aspects related to power management, like the
CPU undervolting (when a PHC-enabled kernel is available).

URL: https://launchpad.net/samsung-tools

It's a kernel extension, which can be installed via AUR:
https://aur.archlinux.org/packages.php?ID=37713

Laptop Mode Tools
-----------------

Another useful step is to install laptop-tools. Ensure that you
carefully read the hdparm section.

URL: Laptop_Mode_Tools

Optimus
-------

Use bbswitch and add it to your kernel modules sections:

URL: Bumblebee

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samsung_RC530&oldid=237831"

Category:

-   Samsung
