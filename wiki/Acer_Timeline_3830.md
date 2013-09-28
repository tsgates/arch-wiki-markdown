Acer Timeline 3830
==================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
|     -   1.1 Acer TimelineX 3830TG-6412                                   |
|         -   1.1.1 cpuinfo                                                |
|         -   1.1.2 lspci                                                  |
|         -   1.1.3 lsusb                                                  |
|                                                                          |
| -   2 Exact hardware model (for me at least)                             |
| -   3 Really issues, hardware problems                                   |
|     -   3.1 Sound card issue                                             |
|     -   3.2 Screen backlight issue                                       |
|     -   3.3 Wireless                                                     |
|     -   3.4 GPU switch issue                                             |
|                                                                          |
| -   4 Lighter issues                                                     |
|     -   4.1 Other Wireless                                               |
|     -   4.2 CPU frequency scaling                                        |
|     -   4.3 Fn + buttons                                                 |
|     -   4.4 ACPI events                                                  |
+--------------------------------------------------------------------------+

Hardware
--------

> Acer TimelineX 3830TG-6412

cpuinfo

    $ cat  /proc/cpuinfo
    processor       : 0
    vendor_id       : GenuineIntel
    cpu family      : 6
    model           : 42
    model name      : Intel(R) Core(TM) i3-2310M CPU @ 2.10GHz
    stepping        : 7
    cpu MHz         : 800.000
    cache size      : 3072 KB
    physical id     : 0
    siblings        : 4
    core id         : 0
    cpu cores       : 2
    apicid          : 0
    initial apicid  : 0
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 13
    wp              : yes
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 x2apic popcnt xsave avx lahf_lm arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
    bogomips        : 4192.16
    clflush size    : 64
    cache_alignment : 64
    address sizes   : 36 bits physical, 48 bits virtual
    power management: 

    processor       : 1
    vendor_id       : GenuineIntel
    cpu family      : 6
    model           : 42
    model name      : Intel(R) Core(TM) i3-2310M CPU @ 2.10GHz
    stepping        : 7
    cpu MHz         : 800.000
    cache size      : 3072 KB
    physical id     : 0
    siblings        : 4
    core id         : 0
    cpu cores       : 2
    apicid          : 1
    initial apicid  : 1
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 13
    wp              : yes
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 x2apic popcnt xsave avx lahf_lm arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
    bogomips        : 4192.08
    clflush size    : 64
    cache_alignment : 64
    address sizes   : 36 bits physical, 48 bits virtual
    power management: 

    processor       : 2
    vendor_id       : GenuineIntel
    cpu family      : 6
    model           : 42
    model name      : Intel(R) Core(TM) i3-2310M CPU @ 2.10GHz
    stepping        : 7
    cpu MHz         : 800.000
    cache size      : 3072 KB
    physical id     : 0
    siblings        : 4
    core id         : 1
    cpu cores       : 2
    apicid          : 2
    initial apicid  : 2
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 13
    wp              : yes
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 x2apic popcnt xsave avx lahf_lm arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
    bogomips        : 4192.09
    clflush size    : 64
    cache_alignment : 64
    address sizes   : 36 bits physical, 48 bits virtual
    power management: 

    processor       : 3
    vendor_id       : GenuineIntel
    cpu family      : 6
    model           : 42
    model name      : Intel(R) Core(TM) i3-2310M CPU @ 2.10GHz
    stepping        : 7
    cpu MHz         : 800.000
    cache size      : 3072 KB
    physical id     : 0
    siblings        : 4
    core id         : 1
    cpu cores       : 2
    apicid          : 3
    initial apicid  : 3
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 13
    wp              : yes
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 x2apic popcnt xsave avx lahf_lm arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
    bogomips        : 4192.10
    clflush size    : 64
    cache_alignment : 64
    address sizes   : 36 bits physical, 48 bits virtual
    power management:

lspci

    $ lspci
    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
    00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
    00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b4)
    00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b4)
    00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 (rev b4)
    00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b4) 
    00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 04)
    00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 04)
    02:00.0 Ethernet controller: Atheros Communications AR8151 v2.0 Gigabit Ethernet (rev c0)
    03:00.0 Network controller: Broadcom Corporation BCM43227 802.11b/g/n
    04:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5116 PCI Express Card Reader (rev 01)
    04:00.1 SD Host controller: Realtek Semiconductor Co., Ltd. RTS5116 PCI Express Card Reader (rev 01)
    05:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)

lsusb

    $ lsusb
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 004 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 003 Device 003: ID 058f:b002 Alcor Micro Corp.

Exact hardware model (for me at least)
--------------------------------------

Acer Aspire (TimelineX) 3830TG

Core i5-2410M 2.3GHz

4GB DDR3 RAM

NVIDIA GeForce GT 540M

750 GB HDD

Atheros wifi (AR9287) b/g/n

(Probably some of these issues only for Arch Linux, e.g. Ubuntu handling
automatically, (Ubuntu is great, but too fat for me) )

    [ susu@archie ~ ]$ uname -a
    Linux archie 3.0-ARCH #1 SMP PREEMPT Wed Aug 17 21:55:57 CEST 2011 x86_64 Intel(R) Core(TM) i5-2410M CPU @ 2.30GHz GenuineIntel GNU/Linux

Really issues, hardware problems
--------------------------------

> Sound card issue

Problem: No sound

There is a (Ubuntu) bugreport about the problem:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/783582

There are plenty of comments, but the first one that worked for me:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/783582/comments/33

But if you are too lazy to click, or that page cannot be reached:

-   download HDA_Analyzer from here:
    http://www.alsa-project.org/main/index.php/HDA_Analyzer
-   run the script (as root)

Note: some plus package may be needed (python2, pygtk), and change the
first line of the file:

    #!/usr/bin/env python2

EDIT: ALL instances "python" must be changed to "python2"... there are
two entries, one at the top AND bottom:

    os.system("python2 %s" % TMPDIR + '/' + FILES[0] + ' ' + ' '.join(sys.argv[1:]))

(there must be more elegant solution, but it is pretty fast)

-   run hda_analyzer.py (same workaround may need)
-   find Node[0x1b] PIN and select
-   on Node editor tab check EAPD

(and then my urxvt started to beep, I have to turn that off. UPDATE: I
have added this: "/usr/bin/xset b off" to my .xinitrc)

Note: and then both internal speaker and headphone output worked, and
also muting if I plug in my headphone (there were some comment at the
bugreport about that "auto-muting" does not work).

Oh, of course, I have 3.0 kernel.

UPDATE: I wrote a script about this. That script a hack, not an elegant
solution, at least it works.
http://dl.dropbox.com/u/4602313/acer-3830-setter.py

Note: I also had to add my user to audio group to use sound card.

> Screen backlight issue

The brightness is not controllable either through software (KDE slider)
or by pressing the Fn+Left/Right buttons. the acpi_osi option fixes the
Fn+Left/Right buttons and the acpi_backlight option fixes the control
via software using the kde slider.

Add kernel options acpi_osi=Linux and acpi_backlight=vendor

Step-by-step:

-   Edit /boot/grub/menu.lst
-   Find your system menu entry, and add acpi_osi=Linux and
    acpi_backlight=vendor kernel options

My menu entry looks like:

    title  Arch Linux
    root   (hd0,6)
    kernel /boot/vmlinuz-linux root=/dev/sda7 ro acpi_osi=Linux acpi_backlight=vendor
    initrd /boot/initramfs-linux.img

-   reboot and pray

Note: tested with integrated Intel GPU only

But still an issue that I cannot set brightness value from software
(from sysfs), only Fn + Left/Right arrows working.

> Wireless

 ATH9K driver issue
    

Very inconsistent wireless performance and a lot of invalid misc, tx
retries, and dropped packets.

The wireless card is detected as an AR9287 when in reality it is an
AR5B97.

I've read just about everything under the sun on this topic. It appears
that the only "functional" driver is ATH9K. The ATH5K driver will refuse
to run with the hardware. Ndiswrapper doesn't seem to run the xp version
of the driver. These issues are numerously documented and have existed
for over a year. the linux wireless page seems to indicate that there is
not much in the way of official bug developement in regards to these
problems meaning no foreseeable fix. At the time of writing, 11-14-2011,
this card has pretty poor support under linux giving you only 2 true
fixes: buy a new wireless card or switch to a different os. Windows 7
has none of these issues with the card.

All that being said there are 2 mitigation strategies which minimally
help:

1. Disabling hardware encryption

(post taken from launchpad:
https://bugs.launchpad.net/archlinux/+source/linux/+bug/735171/comments/29)

    "I googled the problem, and came up with this command;

    sudo -s

    echo "options ath9k nohwcrypt=1" > /etc/modprobe.d/ath9k.conf

    taken from here;

    http://ubuntuforums.org/showthread.php?t=1746326"

2. Disabling or limiting IPv6 support

     Place the entry "alias net-pf10 off" into /etc/modprobe.d/modprobe.conf

good luck.

Broadcom BCM43227

Some models of this laptop come with the BCM43227 wireless module. You
can verify this is what you have by running

     lspci | grep Network

The output should be the following:

     03:00.0 Network controller: Broadcom Corporation BCM43227 802.11b/g/n

This chip works fine with broadcom-wl from AUR. However, you need to
press Fn+F3 (may be a couple of times) to turn on the wireless. It seems
that each press of the button cycles through the different combinations
of Wireless/Bluetooth On/Off.

> GPU switch issue

At the moment I turned NVIDIA GPU off from BIOS, later I will provide
some info about switching. Until then you can check on Bumblebee

Lighter issues
--------------

> Other Wireless

See Wireless Setup.

TODO: create some profiling (and some iptables stuff also would be nice
for that network profiling)

> CPU frequency scaling

CPU frequency scaling can be accomplished with cpufrequtils, Laptop Mode
Tools, and etc. once the acpi_cpufreq kernel module is loaded (e.g. by
adding it to the MODULES array in rc.conf and rebooting).

Laptop Mode Tools or acpid can be used to switch governors when the
laptop is on battery or AC.

> Fn + buttons

On a standard setup, acpi seems to detect Fn+up, Fn+down, Fn+F8,
Fn+Home, Fn+PgUp, Fn+PgDn and Fn+End.

Fn+Right (higher brightness), Fn+Left (lower brightness), Fn+F3
(wireless), Fn+F6 (blank screen) and Fn+F7 (touchpad) all seem to work
fine, however they do not generate acpi events.

Fn + F3 (wireless)

This combination doesn't seem to generate any acpi events, however it
seems to cycle through the different combinations of Wireless/Bluetooth
and On/Off. The total number is 4 combinations.

> ACPI events

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Timeline_3830&oldid=215209"

Category:

-   Acer
