Improve Boot Performance
========================

  Summary
  ------------------------------------------------------------------------------------------------------------
  This article attempts to aggregate methods on how to improve the boot performance of an Arch Linux system.

Improving the boot performance of a system can provide reduced boot wait
times and a means to learn more about how certain system files and
scripts interact with one another. This article attempts to aggregate
methods on how to improve the boot performance of an Arch Linux system.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Identifying bottlenecks                                            |
| -   2 Compiling a Custom Kernel                                          |
| -   3 Early start for services                                           |
| -   4 Staggered spin-up                                                  |
| -   5 Filesystem Mounts                                                  |
| -   6 Initramfs                                                          |
| -   7 Less output during boot                                            |
| -   8 Additional Resources                                               |
+--------------------------------------------------------------------------+

Identifying bottlenecks
-----------------------

The systemd-analyze command can be used to show timing details about the
boot process, including an svg plot showing units waiting for their
dependencies. See man systemd-analyze for details.

Compiling a Custom Kernel
-------------------------

Compiling a custom kernel will reduce boot time and memory usage. Read
more about compiling a kernel.

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

Filesystem Mounts
-----------------

Thanks to mkinitcpio's fsck hook, you can avoid a possibly costly
remount of the root partition by changing ro to rw on the kernel line
and removing it from /etc/fstab. Options can be set with
rootflags=mount options... on the kernel line.

You can also remove API filesystems from /etc/fstab, as systemd will
mount them itself (see pacman -Ql systemd | grep '\.mount$' for a list).
It is not uncommon for users to have a /tmp entry carried over from
sysvinit, but you may have noticed from the command above that systemd
already takes care of this. Ergo, it may be safely removed.

Other filesystems like /home can be mounted with custom mount units.
Adding noauto,x-systemd.automount will buffer all access to that
partition, and will fsck and mount it on first access, reducing the
number of filesystems it must fsck/mount during the boot process.

Note: this will make your /home filesystem type autofs, which is ignored
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

Less output during boot
-----------------------

Change verbose to quiet on the bootloader's kernel line. For some
systems, particularly those with an SSD, the slow performance of the TTY
is actually a bottleneck, and so less output means faster booting.

Additional Resources
--------------------

-   systemd
-   e4rat
-   udev
-   Daemon
-   mkinitcpio
-   Maximizing Performance
-   Bootchart - A tool to assist in profiling the boot process
-   Kexec A tool to reboot very quickly without waiting for the whole
    BIOS boot process to finish.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Improve_Boot_Performance&oldid=253364"

Category:

-   Boot process
