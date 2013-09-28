Swap
====

Summary

An introduction to swap space and paging on GNU/Linux. Covers creation
and activation of swap partitions and swap files.

Related

fstab

From All about Linux swap space:

Linux divides its physical RAM (random access memory) into chucks of
memory called pages. Swapping is the process whereby a page of memory is
copied to the preconfigured space on the hard disk, called swap space,
to free up that page of memory. The combined sizes of the physical
memory and the swap space is the amount of virtual memory available.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Swap space                                                         |
| -   2 Swap partition                                                     |
| -   3 Swap file                                                          |
|     -   3.1 Swap file creation                                           |
|     -   3.2 Remove swap file                                             |
|     -   3.3 Swap file resuming                                           |
|                                                                          |
| -   4 Swap with USB device                                               |
| -   5 Performance Tuning                                                 |
|     -   5.1 Swappiness                                                   |
|     -   5.2 Priority                                                     |
+--------------------------------------------------------------------------+

Swap space
----------

Swap space will usually be a disk partition but can also be a file.
Users may create a swap space during installation of Arch Linux or at
any later time should it become necessary. Swap space is generally
recommended for users with less than 1 GB of RAM, but becomes more a
matter of personal preference on systems with gratuitous amounts of
physical RAM (though it is required for suspend-to-disk support).

To check swap status, use:

    $ swapon -s

Or：

    $ free -m

Note:There is no performance advantage to either a contiguous swap file
or a partition, both are treated the same way.

Swap partition
--------------

A swap partition can be created with most GNU/Linux partitioning tools
(e.g. fdisk, cfdisk). Swap partitions are designated as type 82.

To set up a Linux swap area, the mkswap command is used. For example:

    # mkswap /dev/sda2

Warning:All data on the specified partition will be lost.

To enable the device for paging:

    # swapon /dev/sda2

To enable this swap partition on boot, add an entry to fstab:

    /dev/sda2 none swap defaults 0 0

Note:If using a TRIM supported SSD, discard is a valid mount option for
swap. If creating swap manually, using -d or --discard achieves the
same. For more information and other available mount options, see the
swapon man page.

Swap file
---------

As an alternative to creating an entire partition, a swap file offers
the ability to vary its size on-the-fly, and is more easily removed
altogether. This may be especially desirable if disk space is at a
premium (e.g. a modestly-sized SSD).

Note:The BTRFS filesystem does not currently support swapfiles. Failure
to heed this warning may result in filesystem corruption.

> Swap file creation

As root use fallocate to create a swap file the size of your choosing (M
= Megabytes, G = Gigabytes) (dd can also be used but will take longer).
For example, creating a 512 MB swap file:

    # fallocate -l 512M /swapfile
    Or
    # dd if=/dev/zero of=/swapfile bs=1M count=512

Set the right permissions (a world-readable swap file is a huge local
vulnerability)

    # chmod 600 /swapfile

After creating the correctly-sized file, format it to swap:

    # mkswap /swapfile

Activate the swapfile:

    # swapon /swapfile

Edit /etc/fstab and add an entry for the swap file:

    /swapfile none swap defaults 0 0

> Remove swap file

To remove a swap file, the current swap file must be turned off.

As root:

    # swapoff -a

Remove swapfile:

    # rm -rf /swapfile

> Swap file resuming

Resuming the system from a swap file after hibernation requires an
addition kernel parameter compared to resuming from a swap partition.
The additional parameter is resume_offset=<Swap File Offset>.

The value of <Swap File Offset> can be obtained from the output of
filefrag -v; The output is in a table format; the required value is
located in the physical column from the first row. Eg:

    # filefrag -v /swapfile
    Filesystem type is: ef53
    File size of /swapfile is 4290772992 (1047552 blocks, blocksize 4096)
    ext logical  physical  expected  length flags
      0       0     7546880                6144 
      1    6144  7557120  7553023   2048 
      2    8192  7567360  7559167   2048 
    ...

From the example <Swap FIle Offset> is 7546880.

Note:Please note that in kernel resume parameter you still have to type
path to partition (e.g. resume=/dev/sda1) not to swapfile explicitly!
Parameter resume_offset is for informing system where swapfile starts on
hard disk (e.g. resume_offset=7546880).

Swap with USB device
--------------------

Thanks to modularity offered by Linux, we can have multiple swap
partitions spread over different devices. If you have a very full hard
disk, USB device can be used as partition temporally. But this method
has some severe disadvantage：

-   USB device is slower than hard disk.
-   flash memories have limited write cycles. Using it as swap partition
    will kill it quickly.
-   when another device is attached to the computer, no swap can be
    used.

To add a a USB device to SWAP, first take a USB flash and partition it
with a swap partition.You can use graphical tools such as Gparted or
console tools like fdisk. Make sure to label the partition as SWAP
before writing the partition table.

Make sure you are writing the partition to the correct disk!

Next edit the fstab

    # nano /etc/fstab

Now add a new entry, just under the current swap entry, which take the
current swap partition over the new USB one

    UUID=... none swap defaults,pri=10 0 0

where UUID is taken from the output of the command

    ls -l /dev/disk/by-uuid/ | grep /dev/sdc1

Just replace sdc1 with your new USB swap partition. sdb1

We use UUID because when you attach other devices to the computer it
could modify the device order

Last, add

    pri=0

in the original swap entry for teaching fstab to use HD swap only when
USB is full

This guide will work for other memory such as SD cards, etc.

Performance Tuning
------------------

Swap values can be adjusted to help performance.

> Swappiness

The swappiness sysctl parameter represents the kernel's preference (or
avoidance) of swap space. Swappiness can have a value between 0 and 100.
Setting this parameter to a low value will reduce swapping from RAM, and
is known to improve responsiveness on many systems.

    /etc/sysctl.conf

    vm.swappiness=1
    vm.vfs_cache_pressure=50

> Priority

If you have more than one swap file or swap partition you should
consider assigning a priority value (0 to 32767) for each swap area. The
system will use swap areas of higher priority before using swap areas of
lower priority. For example, if you have a faster disk (/dev/sda) and a
slower disk (/dev/sdb), assign a higher priority to the swap area
located on the faster device. Priorities can be assigned in fstab via
the pri parameter:

    /dev/sda1 none swap defaults,pri=100 0 0
    /dev/sdb2 none swap defaults,pri=10  0 0

Or via the −p (or −−priority) parameter of swapon:

    # swapon -p 100 /dev/sda1

If two or more areas have the same priority, and it is the highest
priority available, pages are allocated on a round-robin basis between
them.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Swap&oldid=245909"

Category:

-   File systems
