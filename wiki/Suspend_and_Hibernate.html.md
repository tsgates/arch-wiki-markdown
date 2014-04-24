Suspend and Hibernate
=====================

Related articles

-   Uswsusp
-   TuxOnIce
-   systemd
-   pm-utils
-   Suspending to RAM with hibernate-script
-   Suspending to Disk with hibernate-script

Currently there are available three methods of suspending: suspend to
RAM (usually called just suspend), suspend to disk (usually known as
hibernate), and hybrid suspend (sometimes aptly called suspend to both):

-   Suspend to RAM method cuts power to most parts of the machine aside
    from the RAM, which is required to restore the machine's state.
    Because of the large power savings, it is advisable for laptops to
    automatically enter this mode when the computer is running on
    batteries and the lid is closed (or the user is inactive for some
    time).

-   Suspend to disk method saves the machine's state into swap space and
    completely powers off the machine. When the machine is powered on,
    the state is restored. Until then, there is zero power consumption.

-   Suspend to both method saves the machine's state into swap space,
    but does not power off the machine. Instead, it invokes usual
    suspend to RAM. Therefore, if the battery is not depleted, the
    system can resume from RAM. If the battery is depleted, the system
    can be resumed from disk, which is much slower than resuming from
    RAM, but the machine's state has not been lost.

There are multiple low level interfaces (backends) providing basic
functionality, and some high level interfaces providing tweaks to handle
problematic hardware drivers/kernel modules (e.g. video card
re-initialization).

Contents
--------

-   1 Low level interfaces
    -   1.1 kernel (swsusp)
    -   1.2 uswsusp
    -   1.3 tuxonice
-   2 High level interfaces
    -   2.1 systemd
    -   2.2 pm-utils
-   3 Suspend to RAM
-   4 Hibernation
    -   4.1 About swap partition/file size
    -   4.2 Required kernel parameters
        -   4.2.1 Hibernation into swap file
    -   4.3 Recreate initial ramdisk
-   5 Troubleshooting
    -   5.1 ACPI_OS_NAME
    -   5.2 VAIO Users
    -   5.3 Suspend/hibernate doesn't work

Low level interfaces
--------------------

Though these interfaces can be used directly, it is advisable to use
some of high level interfaces to suspend/hibernate. Using low level
interfaces directly is significantly faster than using any high level
interface, since running all the pre- and post-suspend hooks takes time,
but hooks can properly set hardware clock, restore wireless etc.

> kernel (swsusp)

The most straightforward approach is to directly inform the in-kernel
software suspend code (swsusp) to enter a suspended state; the exact
method and state depends on the level of hardware support. On modern
kernels, writing appropriate strings to /sys/power/state is the primary
mechanism to trigger this suspend.

See kernel documentation for details.

> uswsusp

The uswsusp ('Userspace Software Suspend') is a wrapper around the
kernel's suspend-to-RAM mechanism, which performs some graphics adapter
manipulations from userspace before suspending and after resuming.

See main article Uswsusp.

> tuxonice

TuxOnIce is a fork of the kernel implementation of suspend/hibernate
that provides kernel patches to improve the default implementation. It
requires a custom kernel to achieve this purpose.

See main article TuxOnIce.

High level interfaces
---------------------

Note:The end goal of these packages is to provide binaries/scripts that
can be invoked to perform suspend/hibernate. Actually hooking them up to
power buttons or menu clicks or laptop lid events is usually left to
other tools. To automatically suspend/hibernate on certain power events,
such as laptop lid close or battery depletion percentage, you may want
to look into running Acpid.

> systemd

systemd provides native commands for suspend, hibernate and a hybrid
suspend, see Power management#Power management with systemd for details.

See Power management#Sleep hooks for additional information on
configuring suspend/hibernate hooks. Also see man systemctl,
man systemd-sleep, and man systemd.special.

> pm-utils

pm-utils is a set of shell scripts that encapsulate the backend's
suspend/hibernate functionality. It comes with a set of pre- and
post-suspend tweaks and various hooks to customize the process.

See main article pm-utils.

Suspend to RAM
--------------

Suspend to RAM should work out of the box.

Hibernation
-----------

In order to use hibernation, you need to create swap partition or swap
file. See Swap for details.

> About swap partition/file size

Even if your swap partition is smaller than RAM, you still have a big
chance of hibernating successfully. According to kernel documentation:

/sys/power/image_size controls the size of the image created by the
suspend-to-disk mechanism. It can be written a string representing a
non-negative integer that will be used as an upper limit of the image
size, in bytes. The suspend-to-disk mechanism will do its best to ensure
the image size will not exceed that number. However, if this turns out
to be impossible, it will try to suspend anyway using the smallest image
possible. In particular, if "0" is written to this file, the suspend
image will be as small as possible. Reading from this file will display
the current image size limit, which is set to 2/5 of available RAM by
default.

You may either decrease the value of /sys/power/image_size to make the
suspend image as small as possible (for small swap partitions), or
increase it to possibly speed up the hibernation process.

> Required kernel parameters

The kernel parameter resume=<swap_partition> has to be used. As
<swap_partition> is by default to use the UUID of the swap partition.
The kernel name, i.e. /dev/sda1, can only be used if Persistent block
device naming is opted out in GRUB2.

For example, with GRUB2 you can use GRUB_CMDLINE_LINUX_DEFAULT variable:

    /etc/default/grub

    GRUB_CMDLINE_LINUX_DEFAULT="resume=/dev/disk/by-uuid/4209c845-f495-4c43-8a03-5363dd433153"

Don't forget to run grub-mkconfig -o /boot/grub/grub.cfg afterwards.

Tip:As an alternative, for GRUB2 you may try this solution from debian
wiki, which automatically adds your first swap partition to resume=
parameter to all found linux entries.

Hibernation into swap file

Using a swap file instead of a swap partition requires an additional
kernel parameter resume_offset=<Swap File Offset>.

The value of <Swap File Offset> can be obtained by running
filefrag -v <Swap File>, the output is in a table format and the
required value is located in the first row of the physical_offset
column. For example:

    # filefrag -v /swapfile

    Filesystem type is: ef53
    File size of /swapfile is 4294967296 (1048576 blocks of 4096 bytes)
     ext:     logical_offset:        physical_offset: length:   expected: flags:
       0:        0..       0:      38912..     38912:      1:            
       1:        1..   22527:      38913..     61439:  22527:             unwritten
       2:    22528..   53247:     899072..    929791:  30720:      61440: unwritten
    ...

In the example the value of <Swap File Offset> is 38912.

Tip:The value of <Swap File Offset> can also be obtained by running
swap-offset <Swap File>. The swap-offset binary is provided by package
uswsusp-git.

> Note:

-   Please note that in the kernel parameter resume you have to provide
    the device of the partition that contains the swapfile, not swapfile
    itself! The parameter resume_offset informs the system where the
    swapfile starts on the resume device.
-   If using uswsusp, then these two parameters have to be provided in
    /etc/suspend.conf via the keys resume device and resume offset.

> Recreate initial ramdisk

If you use an initramfs (default Arch systems do), you must add the
resume hook into the HOOKS in the configuration of mkinitcpio:

    /etc/mkinitcpio.conf

    # resume must be placed after block and lvm2, but before filesystems
    HOOKS="... block lvm2 resume filesystems ..."

Warning:You must not use the systemd hook, because it does not support
resuming from hibernation. See FS#37028 for details.

Finally, you must rebuild the initrd image for these changes to take
effect:

    # mkinitcpio -p linux

Note:If you use a custom kernel, then you might have to change the value
of the -p option.

Troubleshooting
---------------

> ACPI_OS_NAME

You might want to tweak your DSDT table to make it work. See DSDT
article

> VAIO Users

Add acpi_sleep=nonvs kernel flag to your loader, and you are done!

> Suspend/hibernate doesn't work

There have been many reports about the screen going black without easily
viewable errors or the ability to do anything when going into and coming
back from suspend and/or hibernate. These problems have been seen on
both laptops and desktops. This is not an official solution, but
switching to an older kernel, especially the LTS-kernel, will probably
fix this.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Suspend_and_Hibernate&oldid=299792"

Category:

-   Power management

-   This page was last modified on 22 February 2014, at 13:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
