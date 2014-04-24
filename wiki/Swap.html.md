Swap
====

Related articles

-   Swap on video ram
-   fstab

This page provides an introduction to swap space and paging on
GNU/Linux. It covers creation and activation of swap partitions and swap
files.

From All about Linux swap space:

Linux divides its physical RAM (random access memory) into chunks of
memory called pages. Swapping is the process whereby a page of memory is
copied to the preconfigured space on the hard disk, called swap space,
to free up that page of memory. The combined sizes of the physical
memory and the swap space is the amount of virtual memory available.

Contents
--------

-   1 Swap space
-   2 Swap partition
    -   2.1 activation by systemd
-   3 Swap file
    -   3.1 Swap file creation
    -   3.2 Remove swap file
-   4 Swap with USB device
-   5 Performance Tuning
    -   5.1 Swappiness
    -   5.2 Priority

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

Or:

    $ free -m

Note:There is no performance advantage to either a contiguous swap file
or a partition, both are treated the same way.

Swap partition
--------------

A swap partition can be created with most GNU/Linux partitioning tools
(e.g. fdisk, cfdisk). Swap partitions are typically designated as type
82, however it is possible to use any partition type as swap.

To set up a Linux swap area, the mkswap command is used. For example:

    # mkswap /dev/sda2

Warning:All data on the specified partition will be lost.

The mkswap utility generates an UUID for the partition by default, use
the -U flag in case you want to specify custom UUID:

    # mkswap -U custom_UUID /dev/sda2

To enable the device for paging:

    # swapon /dev/sda2

To enable this swap partition on boot, add an entry to fstab:

    /dev/sda2 none swap defaults 0 0

Note:Adding an entry to fstab is optional in most cases with systemd.
See the next subsection.

Note:If using an SSD with TRIM support, consider using defaults,discard
in the swap line in fstab. If activating swap manually with swapon,
using the -d or --discard parameter achieves the same. See man 8 swapon
for details.

> activation by systemd

Systemd is activating swap partitions based on two different mechanisms,
both are executables in /usr/lib/systemd/system-generators. The
generators are run on startup and create native systemd units for
mounts. The first, systemd-fstab-generator reads the fstab to generate
units, including a unit for swap. The second, systemd-gpt-auto-generator
inspects the root disk to generate units. It operates on GPT disks only,
and can identify swap partitions by their type code 82.

Note:If both generators create a systemd unit for the same swap
partition, they are conflicting, resulting in an error message.

This can be solved by one of the following options:

-   removing the swap entry from /etc/fstab
-   changing the swap partitions type code from 82 to an arbitrary type
    code
-   deleting the systemd-gpt-auto-generator, and adding its path to the
    NoExtract rule for pacman

Swap file
---------

As an alternative to creating an entire partition, a swap file offers
the ability to vary its size on-the-fly, and is more easily removed
altogether. This may be especially desirable if disk space is at a
premium (e.g. a modestly-sized SSD).

Note:The Btrfs file system does not currently support swap files.
Failure to heed this warning may result in file system corruption.
Though it should be noted that one may use a swap file on Btrfs if
mounted through a loop device. This method will result in severely
degraded swap performance.

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

After creating the correctly sized file, format it to swap:

    # mkswap /swapfile

Activate the swap file:

    # swapon /swapfile

Edit /etc/fstab and add an entry for the swap file:

    /swapfile none swap defaults 0 0

> Remove swap file

Warning: swap is managed by systemd and will be reenabled by it after
some time.

To remove a swap file, the current swap file must be turned off.

As root:

    # swapoff -a

Remove swap file:

    # rm -f /swapfile

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

Warning:Make sure you are writing the partition to the correct disk!

Next open /etc/fstab.

Now add a new entry, just under the current swap entry, which take the
current swap partition over the new USB one

    UUID=... none swap defaults,pri=10 0 0

where UUID is taken from the output of the command

    ls -l /dev/disk/by-uuid/ | grep /dev/sdc1

Just replace sdc1 with your new USB swap partition. sdb1

Tip:We use UUID because when you attach other devices to the computer it
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

    /etc/sysctl.d/99-sysctl.conf

    vm.swappiness=1
    vm.vfs_cache_pressure=50

To test and more on why this may work, take a look at this article.

This Q&A post explains a lot about swappiness.

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

Or via the -p (or --priority) parameter of swapon:

    # swapon -p 100 /dev/sda1

If two or more areas have the same priority, and it is the highest
priority available, pages are allocated on a round-robin basis between
them.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Swap&oldid=306149"

Category:

-   File systems

-   This page was last modified on 20 March 2014, at 18:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
