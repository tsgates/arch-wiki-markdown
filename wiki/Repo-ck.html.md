Repo-ck
=======

Related articles

-   Linux-ck
-   Linux-ck/Changelog

Article details setup and usage of an unofficial Arch Linux repo
containing generic and CPU-optimized kernel and support packages
containing the ck1 patchset featuring the Brain Fuck Scheduler by Con
Kolivas.

Contents
--------

-   1 Packages in repo-ck
-   2 Setup
-   3 Installation Examples
-   4 How to Determine Which CPU Optimized Package Set to Select
-   5 How Much Faster Are the CPU Optimized Packages
-   6 How to Enable the BFQ I/O Scheduler
    -   6.1 Globally (for all devices)
    -   6.2 Selectively (for only specified devices)
-   7 Package Trivia/Repo Statistics
-   8 Troubleshooting
    -   8.1 Forum Support

Packages in repo-ck
-------------------

The repo contains generic packages as well as CPU-specific packages for
the linux-ck family. Many Arch users are familiar with the concept of a
generic kernel package. The official Arch kernel is available in two
flavors (either i686 or x86_64) which are generic packages in that i686
will work with any compatible x86 CPU and x86_64 will work with any
compatible x86_64 CPU. Users have a choice between the corresponding
generic linux-ck packages or CPU-specific and optimized linux-ck
packages:

CPU Type

Group Alias

Details

> Generic

ck-generic

Compiled with generic optimizations suitable for any compatible CPU just
like the official Arch linux package. This is true for both Intel and
AMD processors.

> Intel

ck-atom

Intel Atom platform specific optimizations. Intel Atom CPUs have an
in-order pipelining architecture and thus can benefit from accordingly
optimized code.

ck-core2

Intel Core 2-family including Dual and Quads (Core 2/Newer Xeon/Mobile
Celeron based on Core2).

ck-nehalem

Intel 1st Generation Core i3/i5/i7-family specific optimizations.

ck-sandybridge

Intel 2nd Generation Core i3/i5/i7-family specific optimizations.

ck-ivybridge

Intel 3rd Generation Core i3/i5/i7-family specific optimizations.

ck-haswell

Intel 4th Generation Core i3/i5/i7-family specific optimizations.

ck-p4

Intel Pentium-4 specific optimizations (P4/P4-based Celeron/Pentium-4
M/Older Xeon).

ck-pentm

Intel Pentium-M specific optimizations (Pentium-M notebook chips/not
Pentium-4 M).

> AMD

ck-kx

AMD K7/K8-family specific optimizations.

ck-k10

AMD K10-family specific optimizations including: 61xx Eight-Core
Magny-Cours, Athlon X2 7x50, Phenom X3/X4/II, Athlon II X2/X3/X4, or
Turion II-family processor.

ck-barcelona

CPUs based on AMD Family 10h cores with x86-64 instruction set support.

ck-bobcat

CPUs based on AMD Family 14h cores with x86-64 instruction set support.

ck-bulldozer

CPUs based on AMD Family 15h cores with x86-64 instruction set support.

ck-piledriver

CPUs based on AMD Family 15h cores with x86-64 instruction set support.

CPU-specific optimization are invoked at compilation by selecting the
corresponding option under Processor type and features>Processor family
or by setting-up the .config file accordingly. These changes setup make
specific gcc options including the $CFLAGS.

Repo-ck also contains packages for chromium-scroll-pixels for each arch.

  CPU Type   Package                  Details
  ---------- ------------------------ -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Generic    chromium-scroll-pixels   Current stable version of chromium browser patched to maintain the --scroll-pixel functionality allowing users to set the speed of their wheel mouse's scrolling functions.

Setup
-----

Add the repo-ck repository into pacman.conf and sign Graysky's key.

Installation Examples
---------------------

Use the ck-X group and select the desired packages for installation.
There are 6 groups corresponding to the 13 package sets: ck-generic,
ck-atom, ck-core2, ck-nehalem, ck-sandybridge, ck-ivybridge, ck-haswell,
ck-p4, ck-pentm, ck-kx, ck-k10, ck-barcelona, ck-bulldozer,
ck-piledriver

    # pacman -S ck-generic
    :: There are 7 members in group ck-generic:
    :: Repository repo-ck
       1) broadcom-wl-ck  2) linux-ck  3) linux-ck-headers  4) nvidia-304xx-ck  5) nvidia-ck
       6) virtualbox-ck-guest-modules  7) virtualbox-ck-host-modules

    Enter a selection (default=all):

Alternatively, simply direct pacman to install the packages directly:

    # pacman -S linux-ck linux-ck-headers

How to Determine Which CPU Optimized Package Set to Select
----------------------------------------------------------

Users unsure which package set to use can always install the ck-generic
group which will drive any compatible CPU. For those wanting
CPU-specific optimized packages, run the following command (assuming
that base-devel is installed):

    # gcc -c -Q -march=native --help=target | grep march

The resulting value is what gcc would use as the march CFLAG. Refer to
the table below for a mapping of this value to the correct group.

Brand

Group

March

> Intel

ck-atom

atom

ck-core2

core2

ck-nehalem

corei7

ck-sandybridge

corei7-avx

ck-ivybridge

core-avx-i

ck-haswell

core-avx2

ck-p4

pentium4, nocona

ck-pentm

pentm, pentium-m

> AMD

ck-kx

athlon, athlon-4, athlon-tbird, athlon-mp, athlon-xp, k8-sse3

ck-k10

amdfam10

ck-barcelona

barcelona

ck-bobcat

btver1

ck-bulldozer

bdver1

ck-piledriver

bdver2

Note:Users are encouraged to add additional entries to this table based
on their experience.

Additional links can be used to help determine which package set to
select:

-   http://wiki.gentoo.org/wiki/Safe_CFLAGS#Intel
-   http://wiki.gentoo.org/wiki/Safe_CFLAGS#AMD
-   http://www.linuxforge.net/docs/linux/linux-gcc.php
-   http://gcc.gnu.org/onlinedocs/gcc/i386-and-x86_002d64-Options.html

How Much Faster Are the CPU Optimized Packages
----------------------------------------------

The answer is not that much faster. Extensive testing comparing the
effect of gcc compile options on resulting binaries have been conducted
by others with varying result from no change to rather significant speed
ups.

-   phoronix labs
-   Kernel patch for more CPU families offers measurable speed
    increases.

Readers are encouraged to add to this list.

How to Enable the BFQ I/O Scheduler
-----------------------------------

Since release 3.0.4-2, the BFQ patchset is applied to the package by
default. Users must enable the BFQ scheduler to use it; it is dormant by
default.

> Globally (for all devices)

Add elevator=bfq to boot loader Kernel parameters.

Note:Users building the PKG from the AUR have an option in the PKGBUILD
itself to globally use the BFQ as the default I/O scheduler.

> Selectively (for only specified devices)

Direct the kernel to use it on a device-by-device basis. For example, to
enable it for /dev/sda simply:

    # echo bfq > /sys/block/sda/queue/scheduler

To confirm, simply cat the same file:

    # cat /sys/block/sda/queue/scheduler
    noop deadline cfq [bfq] 

Setting this way will not survive a reboot. To make the change
automatically at the next system boot, create the following tmpfile
where "X" is the letter for the SSD device.

     /etc/tmpfiles.d/set_IO_scheduler.conf 

    w /sys/block/sdX/queue/scheduler - - - - noop

Package Trivia/Repo Statistics
------------------------------

-   Repo statistics are available (popularity of packages, which CPU is
    most popular, # of downloads, etc.).

Note:The statistics are not updated daily but do give a snapshot of the
data.

Troubleshooting
---------------

> Forum Support

Please use this discussion thread to voice comments, questions,
suggestions, requests, etc. Note from graysky, "I can add other
CPU-specific builds upon request. I just wanna be sure people will
actually use them if I take the time to compile them."

Retrieved from
"https://wiki.archlinux.org/index.php?title=Repo-ck&oldid=301050"

Category:

-   Kernel

-   This page was last modified on 24 February 2014, at 03:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
