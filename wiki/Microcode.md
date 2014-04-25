Microcode
=========

Contents
--------

-   1 What is a microcode update
-   2 Updating microcode
-   3 How to tell if a microcode update is needed
-   4 Which CPUs accept microcode updates
    -   4.1 AMD CPUs
    -   4.2 Intel CPUs

What is a microcode update
--------------------------

Processor microcode is akin to processor firmware. The kernel is able to
update the processor's firmware without the need to update it via a BIOS
update.

The microcode data file contains the latest microcode definitions for
all Intel processors. Intel releases microcode updates to correct
processor behavior as documented in the respective processor
specification updates. While the regular approach to getting this
microcode update is via a BIOS upgrade, Intel realizes that this can be
an administrative hassle. The Linux operating system and VMware ESX
products have a mechanism to update the microcode after booting. For
example, this file will be used by the operating system mechanism if the
file is placed in the /etc/firmware directory of the Linux system.
~Intel

Note:Arch Linux does not use /etc/firmware to process the update,
instead firmware binaries are made available in /usr/lib/firmware/*.

Updating microcode
------------------

For Intel processors, install intel-ucode.

For AMD processors the microcode updates are available in
linux-firmware, which is installed as part of the base system.

Reboot your machine and then execute:

    # dmesg | grep microcode

The output of this command should indicate the current version of your
processor's microcode and whether any additional update was applied to
it.

    [    9.890103] microcode: CPU0: patch_level=0x05000101
    [   10.254972] microcode: CPU0: new patch_level=0x0500010d
    [   10.255002] microcode: CPU1: patch_level=0x05000101
    [   10.261101] microcode: CPU1: new patch_level=0x0500010d
    [   10.261287] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba

> Note:

-   Microcode updates via software are not persistent. In other words,
    one needs to apply them at each boot.
-   As of Linux 3.4.2, the microcode update module is loaded
    automatically if your processor support it, no user interaction is
    required.

How to tell if a microcode update is needed
-------------------------------------------

The best way to tell is to download and install the appropriate
microcode update. First load the microcode module using modprobe.

    # modprobe microcode

Then inspect dmesg, if it reports that an update was applied, the
microcode in the BIOS of your motherboard predates the one in either
intel-ucode or linux-firmware. Users should therefore use the microcode
update!

Examples, note that in each case, the BIOS on the motherboard is the
latest version from each respective vendor:

Intel X3360:

    microcode: CPU0 sig=0x10677, pf=0x10, revision=0x705
    microcode: CPU1 sig=0x10677, pf=0x10, revision=0x705
    microcode: CPU2 sig=0x10677, pf=0x10, revision=0x705
    microcode: CPU3 sig=0x10677, pf=0x10, revision=0x705
    microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
    microcode: CPU0 updated to revision 0x70a, date = 2010-09-29
    microcode: CPU1 updated to revision 0x70a, date = 2010-09-29
    microcode: CPU2 updated to revision 0x70a, date = 2010-09-29
    microcode: CPU3 updated to revision 0x70a, date = 2010-09-29

Intel E5200:

    microcode: CPU0 sig=0x1067a, pf=0x1, revision=0xa07
    microcode: CPU1 sig=0x1067a, pf=0x1, revision=0xa07
    microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
    microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
    microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28

Intel Atom 330:

    microcode: CPU0 sig=0x106c2, pf=0x8, revision=0x20d
    microcode: CPU1 sig=0x106c2, pf=0x8, revision=0x20d
    microcode: CPU2 sig=0x106c2, pf=0x8, revision=0x20d
    microcode: CPU3 sig=0x106c2, pf=0x8, revision=0x20d
    microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
    microcode: CPU0 updated to revision 0x219, date = 2009-04-10
    microcode: CPU1 updated to revision 0x219, date = 2009-04-10
    microcode: CPU2 updated to revision 0x219, date = 2009-04-10
    microcode: CPU3 updated to revision 0x219, date = 2009-04-10

It is believed that the date returned corresponds to the date that Intel
implemented a microcode update. This date does not correspond to the
version of the the microcode database included in the package!

Which CPUs accept microcode updates
-----------------------------------

> AMD CPUs

According to AMD's Operating System Research Center, these AMD processor
families support microcode updates:

-   10h (Barcelona)
-   11h (Turion X2 Ultra/Llano)
-   12h (Fusion), 14h (Bobcat)
-   15h (Bulldozer)

> Intel CPUs

According to Intel's download center, the following CPUs support
microcode updates:

-   Intel® Atom™ Processor
-   Intel® Atom™ processor for Entry Level Desktop PCs
-   Intel® Celeron® Desktop Processor
-   Intel® Core™ Duo Processor
-   Intel® Core™ i3 Desktop Processor
-   Intel® Core™ i3 Mobile Processor
-   Intel® Core™ i5 Desktop Processor
-   Intel® Core™ i5 Mobile Processor
-   Intel® Core™ i7 Desktop Processor
-   Intel® Core™ i7 Mobile Processor
-   Intel® Core™ i7 Mobile Processor Extreme Edition
-   Intel® Core™ i7 Processor Extreme Edition
-   Intel® Core™ Solo processor
-   Intel® Core™2 Duo Desktop Processor
-   Intel® Core™2 Duo Mobile Processor
-   Intel® Core™2 Extreme Mobile Processor
-   Intel® Core™2 Extreme Processor
-   Intel® Core™2 Quad Mobile Processor
-   Intel® Core™2 Quad Processor
-   Intel® Core™2 Solo Processor
-   Intel® Pentium® 4 Processor Extreme Edition
-   Intel® Pentium® 4 Processors
-   Intel® Pentium® D Processor
-   Intel® Pentium® M Processor
-   Intel® Pentium® Processor Extreme Edition
-   Intel® Pentium® Processor for Desktop
-   Intel® Pentium® Processor for Mobile
-   Intel® Setup and Configuration Software (Intel® SCS)
-   Intel® vPro™ technology
-   Intel® Xeon® Processor
-   Intel® Xeon® Processor 3000 Sequence
-   Intel® Xeon® Processor 5000 Sequence
-   Intel® Xeon® Processor 6000 Sequence
-   Intel® Xeon® Processor 7000 Sequence
-   Intel® Xeon® processor E3-1200 Product Family
-   Intel® Xeon® processor E5-1600 Product Family
-   Intel® Xeon® processor E5-2400 Product Family
-   Intel® Xeon® processor E5-2600 Product Family
-   Intel® Xeon® processor E5-4600 Product Family
-   Intel® Xeon® processor E7-2800 Product Family
-   Intel® Xeon® processor E7-4800 Product Family
-   Intel® Xeon® processor E7-8800 Product Family
-   Intel® Z2460 Smartphone
-   Mobile Intel® Celeron® Processors
-   Mobile Intel® Pentium® 4 Processors - M

Retrieved from
"https://wiki.archlinux.org/index.php?title=Microcode&oldid=299968"

Category:

-   CPU

-   This page was last modified on 23 February 2014, at 01:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
