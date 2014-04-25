Improve boot performance
========================

Improving the boot performance of a system can provide reduced boot wait
times and a means to learn more about how certain system files and
scripts interact with one another. This article attempts to aggregate
methods on how to improve the boot performance of an Arch Linux system.

Contents
--------

-   1 Analyzing the boot process
    -   1.1 Using systemd-analyze
    -   1.2 Using systemd-bootchart
    -   1.3 Using bootchart2
-   2 Readahead
-   3 Compiling a custom kernel
-   4 Early start for services
-   5 Staggered spin-up
-   6 Filesystem mounts
-   7 Initramfs
-   8 Less output during boot
-   9 See also

Analyzing the boot process
--------------------------

> Using systemd-analyze

systemd provides a tool called systemd-analyze that can be used to show
timing details about the boot process, including an svg plot showing
units waiting for their dependencies. You can see which unit files are
causing your boot process to slow down. You can then optimize your
system accordingly.

To see how much time was spent in kernelspace and userspace on boot,
simply use:

    $ systemd-analyze

Tip:If you boot via UEFI and use a boot loader which implements
systemds' Boot Loader Interface (which currently only Gummiboot does),
systemd-analyze can additionally show you how much time was spent in the
EFI firmware and the boot loader itself.

To list the started unit files, sorted by the time each of them took to
start up:

    $ systemd-analyze blame

At some points of the boot process, things can not proceed until a given
unit succeeds. To see which units find themselves at these critical
points in the startup chain, do:

    $ systemd-analyze critical-chain

You can also create a SVG file which describes your boot process
graphically, similiar to Bootchart:

    $ systemd-analyze plot > plot.svg

See man systemd-analyze for details.

> Using systemd-bootchart

Bootchart has been merged into systemd since Oct. 2012, and you can use
it to boot just as you would with the original bootchart. Add this to
your kernel line:

    initcall_debug printk.time=y init=/usr/lib/systemd/systemd-bootchart

See the manpage for more information.

> Using bootchart2

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           Bootchart#Running        
                           Bootchart2.              
                           Notes: different         
                           instructions from the    
                           main page (Discuss)      
  ------------------------ ------------------------ ------------------------

You could also use a version of bootchart to visualize the boot
sequence. Since you are not able to put a second init into the kernel
command line you won't be able to use any of the standard bootchart
setups. However the bootchart2-git package from AUR comes with an
undocumented systemd service. After you've installed bootchart2 do:

    # systemctl enable bootchart

Read the bootchart2 documentation for further details on using this
version of bootchart.

Readahead
---------

Systemd comes with its own readahead implementation, this should in
principle improve boot time. However, depending on your kernel version
and the type of your hard drive, your mileage may vary (i.e. it might be
slower). To enable, do:

    # systemctl enable systemd-readahead-collect systemd-readahead-replay

Remember that in order for the readahead to work its magic, you should
reboot a couple of times.

Compiling a custom kernel
-------------------------

Compiling a custom kernel can reduce boot time and memory usage. Though
with the standardization of the 64 bit architecture and the modular
nature of the Linux kernel, these benefits may not be as great as
expected. Read more about compiling a kernel.

Early start for services
------------------------

One central feature of systemd is D-Bus and socket activation. This
causes services to be started when they are first accessed and is
generally a good thing. However, if you know that a service (like
UPower) will always be started during boot, then the overall boot time
might be reduced by starting it as early as possible. This can be
achieved (if the service file is set up for it, which in most cases it
is) by issuing:

    # systemctl enable upower

This will cause systemd to start UPower as soon as possible, without
causing races with the socket or D-Bus activation.

Staggered spin-up
-----------------

Some hardware implements staggered spin-up, which causes the OS to probe
ATA interfaces serially, which can spin up the drives one-by-one and
reduce the peak power usage. This slows down the boot speed, and on most
consumer hardware provides no benefits at all since the drives will
already spin-up immediately when the power is turned on. To check if SSS
is being used:

    $ dmesg | grep SSS

If it wasn't used during boot, there will be no output.

To disable it, add libahci.ignore_sss=1 to the kernel line.

Filesystem mounts
-----------------

Thanks to mkinitcpio's fsck hook, you can avoid a possibly costly
remount of the root partition by changing ro to rw on the kernel line
and removing it from /etc/fstab. Options can be set with
rootflags=mount options... on the kernel line. Remember to remove the
entry from your /etc/fstab file, else the systemd-remount-fs.service
will continue to try to apply those settings. Alternatively, one could
try to mask that unit.

If btrfs is in use for the root filesystem, there is no need for a fsck
on every boot like other filesystems. If this is the case, mkinitcpio's
fsck hook can be removed. You may also want to mask the
systemd-fsck-root.service, or tell it not to fsck the root filesystem
from the kernel command line using fsck.mode=skip. Without mkinitcpio's
fsck hook, systemd will still fsck any relevant filesystems with the
systemd-fsck@.service

You can also remove API filesystems from /etc/fstab, as systemd will
mount them itself (see pacman -Ql systemd | grep '\.mount$' for a list).
It is not uncommon for users to have a /tmp entry carried over from
sysvinit, but you may have noticed from the command above that systemd
already takes care of this. Ergo, it may be safely removed.

Other filesystems like /home can be mounted with custom mount units.
Adding noauto,x-systemd.automount will buffer all access to that
partition, and will fsck and mount it on first access, reducing the
number of filesystems it must fsck/mount during the boot process.

Note:this will make your /home filesystem type autofs, which is ignored
by mlocate by default. The speedup of automounting /home may not be more
than a second or two, depending on your system, so this trick may not be
worth it.

Initramfs
---------

As mentioned above, boot time can be decreased by slimming the kernel,
thereby reducing the amount of data that must be loaded. This is also
true for your initramfs (result of mkinitcpio), as this is loaded
immediately after the kernel, and takes care of recognizing your root
filesystem and mounting it. To boot, very little is actually needed and
includes the storage bus, block device, and filesystem. Falconindy (Dave
Reisner) has begrudgingly created a short tutorial on how to achieve
this on his blog.

Note:If you are using anything that requires udev to be included in the
initramfs (for example, lvm2, mdadm_udev, or even just specifying the
filesystem label with /dev/disk/by-label), trying to strip down your
initramfs will not be a worthwhile endeavor.

Less output during boot
-----------------------

Change verbose to quiet on the bootloader's kernel line. For some
systems, particularly those with an SSD, the slow performance of the TTY
is actually a bottleneck, and so less output means faster booting.

See also
--------

-   systemd
-   e4rat
-   udev
-   Daemon
-   mkinitcpio
-   Maximizing performance
-   Bootchart - Tool to assist in profiling the boot process
-   Kexec - Tool to reboot very quickly without waiting for the whole
    BIOS boot process to finish.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Improve_boot_performance&oldid=299512"

Category:

-   Boot process

-   This page was last modified on 21 February 2014, at 22:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
