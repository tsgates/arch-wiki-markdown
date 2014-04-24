Linux-ck
========

Summary help replacing me

Linux-ck and headers

-   Current version: 3.13.6-1
-   BFS CPU scheduler: v0.446
-   CK Patchset: 3.13-ck1
-   Release date: 07-Mar-2014

> Related

Linux-ck/Changelog - Linux-ck Changelog.

Repo-ck - Setup and contents of unofficial repo-ck.

Modprobed-db - Util to keep track of all probed modules. Useful for
compiling a minimal kernel package.

Contents
--------

-   1 General Package Details
    -   1.1 Release Cycle
    -   1.2 Package Defaults
-   2 Installation Options
    -   2.1 1. Compile the Package From Source
    -   2.2 2. Use Pre-Compiled Packages
-   3 How to Enable the BFQ I/O Scheduler
    -   3.1 Globally (for all devices)
    -   3.2 Selectively (for only specified devices)
-   4 Troubleshooting
    -   4.1 Running Virtualbox with Linux-ck
        -   4.1.1 Option 1. Use the Unofficial Repo (recommended)
        -   4.1.2 Option 2. The virtualbox-ck-modules package
            (recommended if linux-ck is built by you from the AUR)
        -   4.1.3 Option 3. Use DKMS (more complicated)
    -   4.2 Downgrading
    -   4.3 Forum Support
-   5 A Little About the BFS
    -   5.1 BFS Design Goals
    -   5.2 An Example Video About Queuing Theory
    -   5.3 Some Performance-Based Metrics: BFS vs. CFS
    -   5.4 Check if Enabled
-   6 BFS Myths
    -   6.1 BFS patched kernels CAN in fact use systemd
-   7 Further Reading on BFS and CK Patchset
-   8 Linux-ck Package Changelog

General Package Details
-----------------------

Linux-ck is a package available in the AUR and in the unofficial
linux-ck repo that allows users to run a kernel/headers setup patched
with Con Kolivas' ck1 patchset, including the Brain Fuck Scheduler
(BFS). Many Archers elect to use this package for the BFS' excellent
desktop interactivity and responsiveness under any load situation.
Additionally, the bfs imparts performance gains beyond interactivity.
For example, see: CPU_Schedulers_Compared.pdf.

> Release Cycle

Linux-ck roughly follows the release cycle of the official ARCH kernel.
The following are requirements for its release:

-   Upstream code
-   CK's Patchset
-   BFQ Patchset
-   ARCH config/config.x86_64 sets for major version jumps only

> Package Defaults

There are three modifications to the config files:

1.  The options that the ck patchset enable/disable.
2.  The options that the BFQ patchset need to compile without user
    interaction.
3.  Apply GCC patch that enables additional CPU optimizations at compile
    time (these options are not part of the standard linux-ck package
    and are only available when the user compiles custom options).

All other options are set to the ARCH defaults outlined in the main
kernel's config files. Users are of course free to modify them! The
linux-ck package contains an option to switch on the nconfig config
editor (see section below). For some suggestions, see CK's BFS
configuration FAQ.

Installation Options
--------------------

Note:As with *any* additional kernel, users will need to manually edit
their boot loader's config file to make it aware of the new kernel
images. For example, users of GRUB should execute "grub-mkconfig -o
/boot/grub/grub.cfg". Syslinux, GRUB-legacy, etc. will need to be
modified as well.

Users have two options to get these kernel packages.

> 1. Compile the Package From Source

The AUR contains entries for both packages mentioned above.

Users can customize the linux-ck package via tweaks in the PKGBUILD:

-   Optional nconfig for user specific tweaking.
-   Option to compile a minimal set of modules via a make
    localmodconfig.
-   Option to bypass the standard ARCH config options and simply use the
    current kernel's .config file.
-   Optionally set the BFQ I/O scheduler as default.

More details about these options are provided in the PKGBUILD itself via
line comments. Be sure to read them if compiling from the AUR!

Note:There are related PKGBUILDs in the AUR for other common modules
unique to linux-ck. For example nvidia-ck, nvidia-304xx-ck,lirc-ck, and
broadcom-wl-ck.

> 2. Use Pre-Compiled Packages

If users would rather not spend the time to compile on their own, an
unofficial repo maintained by graysky is available to the community.

For details, see: Repo-ck.

How to Enable the BFQ I/O Scheduler
-----------------------------------

Budget Fair Queueing is a disk scheduler which allows each
process/thread to be assigned a portion of the disk throughput.

> Globally (for all devices)

If compiling from the AUR, simply set the BFQ flag to yes in the
PKGBUILD prior to building.

    _BFQ_enable_="y"

If using the repo packages, append "elevator=bfq" to the kernel boot
line in /boot/grub/menu.lst if using grub or in /etc/default/grub under
the GRUB_CMDLINE_LINUX_DEFAULT="quiet" line followed by rebuilding
/boot/grub/grub.cfg via the standard "grub-mkconfig -o
/boot/grub/grub.cfg" command.

> Selectively (for only specified devices)

An alternative method is to direct the kernel to use it on a
device-by-device basis. For example, to enable it for /dev/sda simply:

    # echo bfq > /sys/block/sda/queue/scheduler

To confirm, simply cat the same file:

    # cat /sys/block/sda/queue/scheduler
    noop deadline cfq [bfq] 

Note that doing it this way will not survive a reboot. To make the
change automatically at the next system boot, place lines in
/etc/tmpfiles.d/IO_scheduler.conf:

    w /sys/block/sda/queue/scheduler - - - - bfq

Troubleshooting
---------------

> Running Virtualbox with Linux-ck

Virtualbox works just fine with custom kernels such as Linux-ck without
the need to keep any of the official ARCH kernel-headers packages on the
system!

Don't forget to add users to the vboxusers group:

    # gpasswd -a USERNAME vboxusers

Option 1. Use the Unofficial Repo (recommended)

Note:As of 17-Oct-2012, Repo-ck users can enjoy these modules as
precompiled packages in the repo itself. If you built your linux-ck from
the AUR you CANNOT USE THE REPO as all packages in the repo are matched
groups.

See the Repo-ck article to setup http://repo-ck.com for pacman to use
directly.

Option 2. The virtualbox-ck-modules package (recommended if linux-ck is built by you from the AUR)

Install the virtualbox-ck-modules package and then install virtualbox
package.

Option 3. Use DKMS (more complicated)

Install virtualbox with the virtualbox-host-dkms package. Then setup
dkms as follows:

    # pacman -S virtualbox virtualbox-host-dkms
    # dkms install vboxhost/4.2.6

Note:Make sure to substitute the correct version number of virtualbox in
the second command. At the time of writting, 4.2.6 is current.

> Downgrading

Users wishing to downgrade to a previous version of linux-ck, have
several options:

-   Source archives are available dating back to linux-ck-3.3.7-1.
-   AUR.git holds AUR git commits for linux-ck dating back to
    linux-ck-2.6.39.3-1.

> Forum Support

Always feel free to open a thread in the forums for support. Be sure to
give the thread a descriptive title to draw attention to the fact that
the post relates to the Linux- ck package.

A Little About the BFS
----------------------

The Brain Fuck Scheduler is a desktop orientated cpu process scheduler
with extremely low latencies for excellent interactivity within normal
load levels.

> BFS Design Goals

The BFS has two major design goals:

1.  Achieve excellent desktop interactivity and responsiveness without
    heuristics and tuning knobs that are difficult to understand,
    impossible to model and predict the effect of, and when tuned to one
    workload cause massive detriment to another.
2.  Completely do away with the complex designs of the past for the cpu
    process scheduler and instead implement one that is very simple in
    basic design.

For additional information, see the
linux-ck#Further_Reading_on_BFS_and_CK_Patchset section of this article.

> An Example Video About Queuing Theory

See this video about queuing theory for an interesting parallel with
supermarket checkouts. Quote from CK, "the relevance of that video is
that BFS uses a single queue, whereas the mainline Linux kernel uses a
multiple queue design. The people are tasks, and the checkouts are CPUs.
Of course there's a lot more to a CPU scheduler than just the queue
design, but I thought this video was very relevant."

> Some Performance-Based Metrics: BFS vs. CFS

A major benefit of using the BFS is increased responsiveness. The
benefits however, are not limited to desktop feel. Graysky put together
some non-responsiveness based benchmarks to compare it to the CFS
contained in the "stock" linux kernel. Seven different machines were
used to see if differences exist and, to what degree they scale using
performance based metrics. Again, these end-points were never factors in
the primary design goals of the bfs. Results were encouraging.

For those not wanting to see the full report, here is the conclusion:
Kernels patched with the ck1 patch set including the bfs outperformed
the vanilla kernel using the cfs at nearly all the performance-based
benchmarks tested. Further study with a larger test set could be
conducted, but based on the small test set of 7 PCs evaluated, these
increases in process queuing, efficiency/speed are, on the whole,
independent of CPU type (mono, dual, quad, hyperthreaded, etc.), CPU
architecture (32-bit and 64-bit) and of CPU multiplicity (mono or dual
socket).

Moreover, several "modern" CPUs (Intel C2D and Ci7) that represent
common workstations and laptops, consistently outperformed the cfs in
the vanilla kernel at all benchmarks. Efficiency and speed gains were
small to moderate.

[CPU_Schedulers_Compared.pdf] is available for download.

> Check if Enabled

This start-up message should appear in the kernel ring buffer when BFS
in enabled:

    # dmesg | grep scheduler
    ...
    [    0.380500] BFS CPU scheduler v0.420 by Con Kolivas.

BFS Myths
---------

> BFS patched kernels CAN in fact use systemd

It is a common mistake to think that bfs does not support cgroups. It
does support cgroups, just not all the cgroup features. Systemd works
with BFS patched kernels, though systemd user sessions are broken for
now, as some of those missing features are required to start
systemd --user.

Further Reading on BFS and CK Patchset
--------------------------------------

-   Con Kolivas' White Paper on the BFS
-   Wikipedia's BFS Article
-   Con Kolivas' Blog

Linux-ck Package Changelog
--------------------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=Linux-ck&oldid=303519"

Category:

-   Kernel

-   This page was last modified on 7 March 2014, at 21:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
