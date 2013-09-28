Suspend and Hibernate
=====================

Summary

Describes suspend(sleep-to-ram), hibernate(sleep-to-disk)

Related articles

Suspend to RAM

Systemd

pm-utils

Uswsusp

Tuxonice

Suspending to RAM with hibernate-script

Suspending to Disk with hibernate-script

Manually suspending the operating system, either to memory (standby) or
to disk (hibernate) sometimes provides the most efficient way to
optimize battery life, depending on the usage pattern of the laptop.
While there is relatively straightforward support in the linux kernel to
support these operations, typically some adjustments have to be made
before initiating these operations (typically due to problematic
drivers, modules or hardware). The following tools provide wrappers
around the kernel interfaces to suspend/resume

-   Wrappers: Systemd, pm-utils
-   Backend: kernel, uswsusp, tuxonice

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Backend                                                            |
|     -   1.1 Kernel                                                       |
|         -   1.1.1 Suspend                                                |
|         -   1.1.2 Hibernation                                            |
|                                                                          |
|     -   1.2 Uswsusp                                                      |
|     -   1.3 TuxOnIce                                                     |
|                                                                          |
| -   2 Wrappers                                                           |
|     -   2.1 systemd                                                      |
|     -   2.2 pm-utils                                                     |
+--------------------------------------------------------------------------+

Backend
=======

Kernel
------

> Suspend

works-out-of-box

> Hibernation

It needs a swap partiton.

About swap partition size

Even if your swap partition is smaller than RAM, you still have a big
chance in hibernating successfully. According to kernel documentation:
"/sys/power/image_size controls the size of the image created by the
suspend-to-disk mechanism [...] which is set to 2/5 of available RAM by
default. [...] The suspend-to-disk mechanism will do its best to ensure
the image size will not exceed that number." You may either decrease it
due to a small swap partition or increase it in purpose of possible
hibernation speed up.

Add Kernel Parameters

The parameter resume=SWAP_PARTITION has to be passed to the Kernel
parameters (where SWAP_PARTITION is either your swap device, i.e.
/dev/sdaX, or your swap UUID). Consult Kernel parameters for more info.

     kernel /boot/vmlinuz-linux ... resume=/dev/sdaX

If you are using swap file instead of regular swap partition, read
Swap#Swap file resuming for more info.

     kernel /boot/vmlinuz-linux ... resume=/dev/sdaX resume_offset=12345

You will also need to add the resume hook to mkinitcpio.conf:

    /etc/mkinitcpio.conf

    # resume must be placed after ide scsi sata and/or lvm2, but before filesystems
    HOOKS="... ide scsi sata lvm2 resume filesystems"

You must rebuild the initrd image for these changes to take effect:

    # mkinitcpio -p linux

Note:If you use a custom kernel, then you might have to change the value
of the -p option.

Uswsusp
-------

uswsusp (userspace software suspend) is a set of user space tools used
for hibernation (suspend-to-disk) and suspend (suspend-to-RAM or
standby) on Linux systems.

Consulte Uswsusp.

TuxOnIce
--------

TuxOnIce , an advanced suspend/hibernate framework which supports
suspending to a swap-disk or a regular file with fast LZO-compression.

Consulte TuxOnIce.

Wrappers
========

systemd
-------

    $ systemctl suspend
    $ systemctl hibernate
    $ systemctl hybrid-sleep

See systemd#ACPI Power Management with systemd

pm-utils
--------

    # pm-suspend
    # pm-hibernate
    # pm-suspend-hybrid

See pm-utils

Retrieved from
"https://wiki.archlinux.org/index.php?title=Suspend_and_Hibernate&oldid=244250"

Category:

-   Power management
