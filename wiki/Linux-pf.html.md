Linux-pf
========

Linux-pf is a kernel package based on the stock -ARCH kernel, patched
with a row of significant patches:

-   The latest Con Kolivas' -ck patchset, including BFS
-   TuxOnIce
-   BFQ (as default I/O scheduler)
-   UKSM
-   AUFS3

Contents
--------

-   1 Installation
    -   1.1 From the unofficial repository (recommended)
    -   1.2 Manual compilation
        -   1.2.1 Install compiled package
-   2 Configuration
-   3 Tips and tricks
-   4 Forum thread for linux-pf
-   5 See also

Installation
------------

The reference PKGBUILD can be found at the linux-pf and at the
bitbucket.org mercurial repository.

> From the unofficial repository (recommended)

Precompiled packages, generic and CPU-family optimized are uploaded at
the pfkernel unofficial repository, usually within 6 hours of the AUR
update for x86_64 and 12 hours for i686. Append the following to
/etc/pacman.conf to activate the pfkernel repo:

    [pfkernel]
    # Generic and optimized binaries of the ARCH kernel patched with BFS, TuxOnIce, BFQ, IMQ, Aufs3
    # linux-pf, kernel26-pf, gdm-old, nvidia-pf, nvidia-96xx, xchat-greek, arora-git
    Server = http://dl.dropbox.com/u/11734958/$arch
    SigLevel = Optional

Packages in the unofficial repository are not signed, so you will need
to set SigLevel to Optional or Never. Running $ pacman -Syyl pfkernel
will update all repos and show the available packages from pfkernel.
Afterwards, just install linux-pf linux-pf-headers (for generic binaries
- platform-specific binaries are also available and will be listed in
the output from the aforementioned pacman command), but additional
configuration steps must be performed; see the Installation section.

> Manual compilation

There's a number of options a user is asked to choose from, should
he/she select to compile from the PKGBUILD:

    ==> Hit <Y> to use your running kernel's config
        (needs IKCONFIG and IKCONFIG_PROC)
    ==> Hit <L> to run 'make localmodconfig'
    ==> Hit <N> (or just <ENTER>) to build an all-inclusive kernel like stock -ARCH
        (warning: it can take a looong time)

The <Y> option is for users who have already compiled and are running a
custom kernel. The PKGBUILD reads the running kernel's configuration and
uses it for the subsequent compilation. The <L> option tries some kind
of autodetection of the user's hardware: it first tries to use the
modprobed_db module database, then falls back to the linux kernel's make
localmodconfig functionality. The last option is self-explanatory.

    ==> Kernel configuration options before build:
        <M> make menuconfig (console menu)
        <N> make nconfig (newer alternative to menuconfig)
        <G> make gconfig (needs gtk)
        <X> make xconfig (needs qt)
        <O> make oldconfig
        <ENTER> to skip configuration and start compiling

Choose one of these to use your favourite user interface for configuring
the kernel. Note that the last option might still prompt with
unresolved/new configuration options, if you have selected <Y> or <L> in
the previous step.

    ==> An non-generic CPU was selected for this kernel.
    ==> Hit <G>     :  to create a generic package named linux-pf
    ==> Hit <ENTER> :  to create a package named after the selected CPU
                       (e.g. linux-pf-core2 - recommended)
    ==> This option affects ONLY the package name. Whether or not the
    ==> kernel is optimized was determined at the previous config step.

If you have selected a specific CPU optimization for your kernel in the
previous step, the default action is to append the CPU to the package
name. This way, a subsequent package update from the repository will
pull the optimized package and not the generic one. This also will help
better compatibility with 3rd party precompiled modules (e.g.
nvidia-pf), which might break things if loaded on optimized linux-pf
kernels.

Install compiled package

After the compilation finishes, an additional linux-pf-headers[-cpu]
package will be created. Don't forget to install it too, if you plan on
using additional modules like nvidia or virtualbox.

    # pacman -U linux-pf-core2-3.3.2-1-$CPUTYPE.pkg.tar.xz linux-pf-headers-core2-3.3.2-1-$CPUTYPE.pkg.tar.xz

During the kernel installation, mkinitcpio will be called by the install
script to recreate the initramfs.

Note:If you make any changes to /etc/mkinitcpio.conf after the
installation, you must run mkinitcpio -p linux-pf to have the initial
ramdisk recreated.

Configuration
-------------

Then, you need to add a boot entry in boot loader configuration file
which points to linux-pf (the following example is from one of the
maintainer's boxes):

    title  Linux-pf 3.2
    root   (hd0,4)
    kernel (hd0,0)/vmlinuz-linux-pf root=/dev/disk/by-label/ROOT ro vga=0x318 lapic resume=/dev/disk/by-label/SWAP video=vesafb:ywrap,mtrr:3 fastboot quiet
    initrd (hd0,0)/initramfs-linux-pf.img

If you intend to use TuxOnIce for hibernation, make sure you have added
the necessary modules to the MODULES array of /etc/mkinitcpio.conf and
at least the resume hook to the HOOKS array:

    MODULES="... lzo tuxonice_compress tuxonice_swap tuxonice_userui ..."
    HOOKS="... block userui resume filesystems ..."

In the example above, TuxOnIce is setup to use a swap partition as the
suspended image allocator. The resume hook must be placed before
filesystems. Also, a progress indicator is requested with userui. Please
read the TuxOnIce wiki page for more detailed information.

Last, you must choose whether you want to suspend using pm-utils or the
hibernate-script. Please, refer to the respective wiki pages for more
details. TuxOnIce offers the option for a text mode or an even nicer
framebuffer splash progress indicator.

Tips and tricks
---------------

-   If you notice disk-related performance problems or occational
    hickups, it might be an I/O scheduler issue. Try a different one
    than the linux-pf default (BFQ) by echoing to
    /sys/block/sda/queue/scheduler cfq, noop or deadline: # echo noop >.
    Note, the aforementioned command only sets the I/O scheduler for the
    1st hard drive and additional echoes will be needed if you have
    more. If the situation improves, then append "elevator=cfq" (or noop
    or deadline) to the linux-pf command line in /boot/grub/menu.lst, to
    make the change permanent.
-   For people who build their own tailored kernels and compilation
    aborts with with an error about "missing include/config/dvb/*.h
    files", setting <M> at DVB for Linux at Device Drivers/Multimedia
    support and leaving everything else out, creates just the necessary
    dvb.h, which allows the compilation to continue.

Forum thread for linux-pf
-------------------------

There's a discussion thread at the BBS for reporting errors,
impressions, ideas and requests.

See also
--------

-   linux-pf mercurial repository
-   Patchset homepage
-   Patchset community forum
-   Patchset changelog

Retrieved from
"https://wiki.archlinux.org/index.php?title=Linux-pf&oldid=293617"

Category:

-   Kernel

-   This page was last modified on 19 January 2014, at 22:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
