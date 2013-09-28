Kernels
=======

Summary

This article discusses kernels in Arch, kernel patches and kernel
compilation.

Related

Kernel modules

Kernel Panics

Linux-ck

sysctl

From Wikipedia:

the kernel is the main component of most computer operating systems; it
is a bridge between applications and the actual data processing done at
the hardware level. The kernel's responsibilities include managing the
system's resources (the communication between hardware and software
components).

There are various alternative kernels available for Arch Linux in
addition to the mainline Linux kernel. This article lists some of the
options available in the repositories with a brief description of each.
There is also a description of patches that can be applied to the
system's kernel. The article ends with an overview of custom kernel
compilation with links to various methods.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Precompiled kernels                                                |
|     -   1.1 Official packages                                            |
|     -   1.2 AUR packages                                                 |
|                                                                          |
| -   2 Patches and Patchsets                                              |
|     -   2.1 How to install                                               |
|     -   2.2 Major patchsets                                              |
|         -   2.2.1 -ck                                                    |
|         -   2.2.2 -rt                                                    |
|         -   2.2.3 -bld                                                   |
|         -   2.2.4 -grsecurity                                            |
|         -   2.2.5 Tiny-Patches                                           |
|         -   2.2.6 -pf                                                    |
|                                                                          |
|     -   2.3 Individual patches                                           |
|         -   2.3.1 Reiser4                                                |
|         -   2.3.2 Gensplash/fbsplash                                     |
|                                                                          |
| -   3 Compilation                                                        |
|     -   3.1 Using the Arch Build System                                  |
|     -   3.2 Traditional                                                  |
|     -   3.3 Proprietary NVIDIA driver                                    |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Precompiled kernels
-------------------

> Official packages

linux 
    The Linux kernel and modules from the [core] repository. Vanilla
    kernel with three patches applied.

linux-lts 
    Long term support (LTS) Linux kernel and modules from the [core]
    repository.

> AUR packages

linux-bfs 
    Linux kernel and modules with the Brain Fuck Scheduler (BFS) -
    created by Con Kolivas for desktop computers with fewer than 4096
    cores, with BFQ I/O scheduler as optional.

linux-ck 
    Linux Kernel built with Con Kolivas' ck1 patchset.
    Additional options which can be toggled on/off in the PKGBUILD
    include: BFQ scheduler, nconfig, localmodconfig and use running
    kernel's config.
    These are patches designed to improve system responsiveness with
    specific emphasis on the desktop, but suitable to any workload. The
    ck patches include BFS.
    For further information and installation instructions, please read
    the linux-ck main article.

linux-eee-ck 
    The Linux Kernel and modules for the Asus Eee PC 701, built with Con
    Kolivas' ck1 patchset.

linux-fbcondecor 
    The Linux Kernel and modules with fbcondecor support.

linux-grsec 
    The Linux Kernel and modules with grsecurity and PaX patches for
    increased security.

linux-ice 
    The Linux Kernel and modules with gentoo-sources patchset and
    TuxOnIce support.

linux-lqx 
    Liquorix is a distro kernel replacement built using the best
    configuration and kernel sources for desktop, multimedia, and gaming
    workloads, often used as a Debian Linux performance replacement
    kernel. damentz, the maintainer of the Liquorix patchset, is a
    developer for the Zen patchset as well, so many of the improvements
    there are found in this patchset.

linux-pax 
    The Linux Kernel and modules with PaX patches for increased
    security.

linux-pf 
    Linux kernel and modules with the pf-kernel patchset [-ck patchset
    (BFS included), TuxOnIce, BFQ], aufs2 and squashfs-lzma.

linux-zen 
    The Zen Kernel is a the result of a collaborative effort of kernel
    hackers to provide the best Linux kernel possible for every day
    systems.

kernel-netbook 
    Static kernel for netbooks with Intel Atom N270/N280/N450/N550 such
    as the Eee PC with the add-on of external firmware (broadcom-wl) and
    patchset (BFS + TuxOnIce + BFQ optional) - Only Intel GPU

linux-lts-tresor 
    The stable LTS Linux Kernel and modules with integrated TRESOR

Patches and Patchsets
---------------------

There are lots of reasons to patch your kernel, the major ones are for
performance or support for non-mainline features such as reiser4 file
system support. Other reasons might include fun and to see how it is
done and what the improvements are.

However, it is important to note that the best way to increase the speed
of your system is to first tailor your kernel to your system, especially
the architecture and processor type. For this reason using pre-packaged
versions of custom kernels with generic architecture settings is not
recommended or really worth it. A further benefit is that you can reduce
the size of your kernel (and therefore build time) by not including
support for things you do not have or use. For example, I always start
with the stock kernel config when a new kernel version is released and I
remove support for things like bluetooth, video4linux, 1000Mbit
ethernet, etc. Stuff I know I won't use before I build my next kernel!
However, this page is not about customizing your kernel config but I
would recommend that as a first step to be combined with a patchset
later.

> How to install

The installation process of custom kernel packages relies on the Arch
Build System (ABS). If you haven't built any custom packages yet you may
consult the following articles: Arch Build System and Creating Packages.

If you haven't actually patched or customized a kernel before it is not
that hard and there are many PKGBUILDs on the forum for individual
patchsets. However, I would advise you to start from scratch with a bit
of research on the benefits of each patchset rather than jumping on the
nearest bandwagon! This way you'll learn much more about what you are
doing rather than just choosing a kernel at startup and wondering what
it actually does.

See #Compilation.

> Major patchsets

First of all it is important to note that patchsets are developed by a
variety of people. Some of these people are actually involved in the
production of the linux kernel and others are hobbyists, which may
reflect its level of reliability and stability.

It is also worth noting that some patchsets are built on the back of
other patchsets (which may or may not be reflected in the title of the
patch). Patchsets (and kernel updates) can be released very frequently
and often it is not worth keeping up with ALL of them so do not go
crazy, unless you make it your hobby!

You can search google for more sets - remember to use quotes "-nitro"
for example otherwise google will deliberately NOT show the results you
want!

Note:This section is for information only - clearly no guarantees of
stability or reliability are implied by inclusion on this page.

-ck

These are patches designed to improve system responsiveness with
specific emphasis on the desktop, but suitable to any workload. The
patches are created and maintained by Con Kolivas, his site is at
http://users.on.net/~ckolivas/kernel/. Con maintains a full set but also
provides the patches broken down so you can add only those you prefer.

The -ck patches can be found at http://ck.kolivas.org/patches/3.0/

-rt

This patchset is maintained by a small group of core developers, led by
Ingo Molnar. This patch allows nearly all of the kernel to be preempted,
with the exception of a few very small regions of code ("raw_spinlock
critical regions"). This is done by replacing most kernel spinlocks with
mutexes that support priority inheritance, as well as moving all
interrupt and software interrupts to kernel threads.

It further incorporates high resolution timers - a patch set, which is
independently maintained.

[as said from the Real-Time Linux Wiki]

patch at http://www.kernel.org/pub/linux/kernel/projects/rt/

-bld

Warning:This scheduler is in development.

BLD is best described as a O(1) CPU picking technique. Which is done by
reordering CPU runqueues based on runqueue loads. In other words, it
keeps the scheduler aware of the load changes, which helps scheduler to
keep runqueues in an order. This technique doesn't depend on scheduler
ticks. The two most simple things in this technique are: load tracking
and runqueue ordering; these are relatively simpler operations. Load
tracking will be done whenever a load change happens on the system and
based on this load change runqueue will be ordered. So, if we have an
ordered runqueue from lowest to highest, then picking the less (or even
busiest) runqueue is easy. Scheduler can pick the lowest runqueue
without calculation and comparison at the time of placing a task in a
runqueue. And while trying to distribute load at sched_exec and
sched_fork our best choice is to pick the lowest busiest runqueue of the
system. And in this way, system remains balanced without doing any load
balancing. At the time of try_to_wake_up picking the idlest runqueue is
topmost priority but it has been done as per domain basis to utilize CPU
cache properly and it's an area where more concentration is requires.

Google code Webpage: http://code.google.com/p/bld/

Patches are only available for 3.3-rc3, 3.4-rc4 and 3.5.0.

-grsecurity

Grsecurity is a security focused patchset. It adds numerous security
related features such as Role-Based Access Control and utilizes features
of the PaX project. It can be used on a desktop but a public server
would receive the greatest benefit. Some applications are incompatible
with the additional security measures implemented by this patchset. If
this occurs, consider using a lower security level.

The -grsecurity patches can be found at http://grsecurity.net

Tiny-Patches

The goal of Linux Tiny is to reduce its memory and disk footprint, as
well as to add features to aid working on small systems. Target users
are developers of embedded system and users of small or legacy machines
such as 386s.

Patch releases against the mainstream Linux kernel have been
discontinued. The developers chose to focus on a few patches and spend
their time trying to get them merged into the mainline kernel.

-pf

linux-pf is yet another Linux kernel fork which provides you with a
handful of awesome features not merged into mainline. It is based on
neither existing Linux fork nor patchset, although some unofficial ports
may be used if required patches haven't been released officially. The
most prominent patches of linux-pf are TuxOnIce, the CK patchset (most
notably BFS), AUFS3, LinuxIMQ, l7 filter and BFQ.

> Individual patches

These are patches which can be simply included in any build of a vanilla
kernel or incorporated (probably with some major tweaking) into another
patchset. I have included some common ones for starters.

Reiser4

Reiser4

Gensplash/fbsplash

Gensplash - http://dev.gentoo.org/~spock/projects/

Compilation
-----------

Arch Linux provides for several methods of kernel compilation.

> Using the Arch Build System

Using the Arch Build System takes advantage of the high quality of the
existing linux PKGBUILD and the benefits of package management. The
PKGBUILD is structured so that you can stop the build after the source
is downloaded and configure the kernel.

See Kernels/Compilation/Arch Build System.

> Traditional

This method involves manually downloading a source tarball, and building
in your home directory as normal user. Once configured, two
compilation/installation methods are offered; the traditional manual
method as well as makepkg/pacman.

An advantage of the traditional method is that it will work on other
Linux distributions.

See Kernels/Compilation/Traditional.

> Proprietary NVIDIA driver

See NVIDIA#Alternate install: custom kernel for instructions on using
the proprietary NVIDIA driver with a custom kernel.

See also
--------

-   O'Reilly - Linux Kernel in a Nutshell (free ebook)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kernels&oldid=251911"

Category:

-   Kernel
