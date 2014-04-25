RAID
====

Related articles

-   Software RAID and LVM
-   Installing with Fake RAID
-   Convert a single drive system to RAID
-   ZFS
-   Playing_with_ZFS

This article explains what RAID is and how to create/manage a software
RAID array using mdadm.

Contents
--------

-   1 Introduction
    -   1.1 Standard RAID levels
    -   1.2 Nested RAID levels
    -   1.3 RAID level comparison
-   2 Implementation
    -   2.1 Which type of RAID do I have?
-   3 Installation
    -   3.1 Prepare the Devices
    -   3.2 Create the Partition Table
    -   3.3 Build the Array
    -   3.4 Update configuration file
    -   3.5 Assemble the Array
    -   3.6 Format the RAID Filesystem
        -   3.6.1 Calculating the Stride and Stripe-width
            -   3.6.1.1 Example 1. RAID0
            -   3.6.1.2 Example 2. RAID5
    -   3.7 Add to Kernel Image
    -   3.8 Mounting from a Live CD
-   4 RAID Maintenance
    -   4.1 Scrubbing
        -   4.1.1 General Notes on Scrubbing
        -   4.1.2 RAID1 and RAID10 Notes on Scrubbing
    -   4.2 Removing Devices from an Array
    -   4.3 Adding a New Device to an Array
-   5 Monitoring
    -   5.1 Watch mdstat
    -   5.2 Track IO with iotop
    -   5.3 Track IO with iostat
    -   5.4 Mailing on events
        -   5.4.1 Alternative method
-   6 Troubleshooting
    -   6.1 Start arrays read-only
    -   6.2 Recovering from a broken or missing drive in the raid
-   7 Benchmarking
-   8 See also

Introduction
------------

See the Wikipedia article on this subject for more information: RAID

Redundant Array of Independent Disks (RAID) is a storage technology that
combines multiple disk drive components (typically disk drives or
partitions thereof) into a logical unit. Depending the RAID
implementation, this logical unit can be a file system or an additional
transparent layer that can hold several partitions. Data is distributed
across the drives in one of several ways called "RAID levels", depending
on the level of redundancy and performance required. The RAID level
chosen can thus prevent data loss in the event of a hard disk failure,
increase performance or be a combination of both.

Despite redundancy implied by most RAID levels, RAID does not guarantee
that data is safe. A RAID will not protect data if there is a fire, the
computer is stolen or multiple hard drives fail at once. Furthermore,
installing a system with RAID is a complex process that may destroy
data.

Warning:Therefore, be sure to back up all data before proceeding.

Note:Users considering a RAID array for data storage/redundancy should
also consider RAIDZ which is implemented via ZFS, a more modern and
powerful alternative to software RAID.

> Standard RAID levels

There are many different levels of RAID, please find hereafter the most
commonly used ones.

 RAID 0 
    Uses striping to combine disks. Even though it does not provide
    redundancy, it is still considered RAID. It does, however, provide a
    big speed benefit. If the speed increase is worth the possibility of
    data loss (for swap partition for example), choose this RAID level.
    On a server, RAID 1 and RAID 5 arrays are more appropriate. The size
    of a RAID 0 array block device is the size of the smallest component
    partition times the number of component partitions.
 RAID 1 
    The most straightforward RAID level: straight mirroring. As with
    other RAID levels, it only makes sense if the partitions are on
    different physical disk drives. If one of those drives fails, the
    block device provided by the RAID array will continue to function as
    normal. The example will be using RAID 1 for everything except swap
    and temporary data. Please note that with a software implementation,
    the RAID 1 level is the only option for the boot partition, because
    bootloaders reading the boot partition do not understand RAID, but a
    RAID 1 component partition can be read as a normal partition. The
    size of a RAID 1 array block device is the size of the smallest
    component partition.
 RAID 5 
    Requires 3 or more physical drives, and provides the redundancy of
    RAID 1 combined with the speed and size benefits of RAID 0. RAID 5
    uses striping, like RAID 0, but also stores parity blocks
    distributed across each member disk. In the event of a failed disk,
    these parity blocks are used to reconstruct the data on a
    replacement disk. RAID 5 can withstand the loss of one member disk.
    Note:RAID 5 is a common choice due to its combination of speed and
    data redundancy. The caveat is that if one drive were to fail and
    another drive failed before that drive was replaced, all data will
    be lost.

> Nested RAID levels

 RAID 1+0 
    Commonly referred to as RAID 10, is a nested RAID that combines two
    of the standard levels of RAID to gain performance and additional
    redundancy. It is the best alternative to RAID 5 when redundancy is
    crucial.

> RAID level comparison

+--------------+--------------+--------------+--------------+--------------+--------------+
| RAID level   | Data         | Physical     | Read         | Write        | Min drives   |
|              | redundancy   | drive        | performance  | performance  |              |
|              |              | utilization  |              |              |              |
+==============+==============+==============+==============+==============+==============+
| 0            | No           | 100%         | nX           | nX           | 2            |
|              |              |              | > Best       | > Best       |              |
+--------------+--------------+--------------+--------------+--------------+--------------+
| 1            | Yes          | 50%          | nX           | 1X           | 2            |
|              |              |              | (theoretical |              |              |
|              |              |              | ly)          |              |              |
|              |              |              | 1X (in       |              |              |
|              |              |              | practice)    |              |              |
+--------------+--------------+--------------+--------------+--------------+--------------+
| 5            | Yes          | 67% - 94%    | (n−1)X       | (n−1)X       | 3            |
|              |              |              | > Superior   | > Superior   |              |
+--------------+--------------+--------------+--------------+--------------+--------------+
| 6            | Yes          | 50% - 88%    | (n−2)X       | (n−2)X       | 4            |
+--------------+--------------+--------------+--------------+--------------+--------------+
| 10           | Yes          | 50%          | nX           | (n/2)X       | 4            |
|              |              |              | (theoretical |              |              |
|              |              |              | ly)          |              |              |
+--------------+--------------+--------------+--------------+--------------+--------------+

* Where n is standing for the number of dedicated disks.

Implementation
--------------

The RAID devices can be managed in different ways:

 Software RAID 
    This is the easier implementation as it does not rely on obscure
    proprietary firmware and software to be used. The array is managed
    by the operating system either by:
    -   by an abstraction layer (e.g. mdadm);
        Note:This is the method we will use later in this guide.
    -   by a logical volume manager (e.g. LVM);
    -   by a component of a file system (e.g. ZFS).

 Hardware RAID 
    The array is directly managed by a dedicated hardware card installed
    in the PC to which the disks are directly connected. The RAID logic
    runs on an on-board processor independently of the host processor
    (CPU). Although this solution is independent of any operating
    system, the latter requires a driver in order to function properly
    with the hardware RAID controller. The RAID array can either be
    configured via an option rom interface or, depending on the
    manufacturer, with a dedicated application when the OS has been
    installed. The configuration is transparent for the Linux kernel: it
    doesn't see the disks separately.

 FakeRAID 
    This type of RAID is properly called BIOS or Onboard RAID, but is
    falsely advertised as hardware RAID. The array is managed by
    pseudo-RAID controllers where the RAID logic is implemented in an
    option rom or in the firmware itself with a EFI SataDriver (in case
    of UEFI), but are not full hardware RAID controllers with all RAID
    features implemented. Therefore, this type of RAID is sometimes
    called FakeRAID. dmraid from the official repositories, will be used
    to deal with these controllers. Some FakeRAID controller examples:
    Intel Rapid Storage, JMicron JMB36x RAID ROM, AMD RAID, ASMedia
    106x,...

> Which type of RAID do I have?

Since software RAID is implemented by the user, the type of RAID is
easily known to the user.

However, discerning between FakeRAID and true hardware RAID can be more
difficult. As stated, manufacturers often incorrectly distinguish these
two types of RAID and false advertising is always possible. The best
solution in this instance is to run the lspci command and looking
through the output to find the RAID controller. Then do a search to see
what information can be located about the RAID controller. True hardware
RAID controller are often rather expensive (~$400+), so if someone
customized the system, and it is very likely that choosing a hardware
RAID setup made a very noticeable change in the computer's price.

Installation
------------

Install mdadm which is used for administering pure software RAID using
plain block devices: the underlying hardware does not provides any RAID
logic, just a supply of disks. mdadm will work with any collection of
block devices. Even if unusual. For example, one can thus make a RAID
array from a collection of thumb drives.

> Prepare the Devices

Warning:These steps erase everything on a device, so type carefully!

To prevent possible issues each device in the RAID should be securely
wiped. If the device is being reused or re-purposed from an existing
array, erase any old RAID configuration information:

    # mdadm --zero-superblock /dev/<drive>

or if a particular partition on a drive is to be deleted:

    # mdadm --zero-superblock /dev/<partition>

Note:Zapping a partition's superblock should not affect the other
partitions on the disk.

> Create the Partition Table

It is highly recommended to pre-partition the disks to be used in the
array. Since most RAID users are selecting HDDs >2 TB, GPT partition
tables are required and recommended. Disks are easily partitioned using
gptfdisk.

-   After created, the partition type should be assigned hex code FD00.
-   Creating partitions that are of the same size on each of the devices
    is preferred.
-   A good tip is to leave approx 100 MB at the end of the device when
    partitioning. See below for rationale.

Note:It is also possible to create a RAID directly on the raw disks
(without partitions), but not recommended because it can cause problems
when swapping a failed disk.

When replacing a failed disk of a RAID, the new disk has to be exactly
the same size as the failed disk or bigger — otherwise the array
recreation process will not work. Even hard drives of the same
manufacturer and model can have small size differences. By leaving a
little space at the end of the disk unallocated one can compensate for
the size differences between drives, which makes choosing a replacement
drive model easier. Therefore, it is good practice to leave about 100 MB
of unallocated space at the end of the disk.

> Build the Array

Use mdadm to build the array. Several examples are given below.

Warning:Do not simply copy/paste the examples below; use your brain and
substitute the correct options/drive letters!

Note:If this is a RAID1 array which is intended to boot from Syslinux a
limitation in syslinux v4.07 requires the metadata value to be 1.0
rather than the default of 1.2.

The following example shows building a 2 device RAID1 array:

    # mdadm --create --verbose --level=1 --metadata=1.2 --chunk=64 --raid-devices=2 /dev/md0 /dev/sdb1 /dev/sdc1

Note:In a RAID1 the chunk switch is actually not needed.

The following example shows building a 4 device RAID5 array:

    # mdadm --create --verbose --level=5 --metadata=1.2 --chunk=256 --raid-devices=4 /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 --spare-devices=1 /dev/sdf1

The array is created under the virtual device /dev/mdX, assembled and
ready to use (in degraded mode). One can directly start using it while
mdadm resyncs the array in the background. It can take a long time to
restore parity. Check the progress with:

    $ cat /proc/mdstat

> Update configuration file

After building any new RAID array, the default configuration file,
mdadm.conf, must be updated like so:

    # mdadm --detail --scan >> /etc/mdadm.conf

Always check the mdadm.conf configuration file using a text editor after
running this command to ensure that contents look reasonable.

Note:If updating the RAID configuration from within the Arch Installer
by swapping to another TTY, ensure that the correct mdadm.conf file has
been written:

> Assemble the Array

Once the configuration file has been updated the array can be assembled
using mdadm:

    # mdadm --assemble --scan

> Format the RAID Filesystem

The array can now be formatted like any other disk, just keep in mind
that:

-   Due to the large volume size not all filesystems are suited (see:
    File system limits).
-   The filesystem should support growing and shrinking while online
    (see: File system features).
-   One should calculate the correct stride and stripe-width for optimal
    performance.

Calculating the Stride and Stripe-width

Stride = (chunk size/block size).

Stripe-width = (# of physical data disks * stride).

Example 1. RAID0

Example formatting to ext4 with the correct stripe-width and stride:

-   Hypothetical RAID0 array is composed of 2 physical disks.
-   Chunk size is 64k.
-   Block size is 4k.

Stride = (chunk size/block size). In this example, the math is (64/4) so
the stride = 16.

Stripe-width = (# of physical data disks * stride). In this example, the
math is (2*16) so the stripe-width = 32.

    # mkfs.ext4 -v -L myarray -m 0.5 -b 4096 -E stride=16,stripe-width=32 /dev/md0

Example 2. RAID5

Example formatting to ext4 with the correct stripe-width and stride:

-   Hypothetical RAID5 array is composed of 4 physical disks; 3 data
    discs and 1 parity disc.
-   Chunk size is 256k.
-   Block size is 4k.

Stride = (chunk size/block size). In this example, the math is 256/4) so
the stride = 64.

Stripe-width = (# of physical data disks * stride). In this example, the
math is (3*64) so the stripe-width = 192.

    # mkfs.ext4 -v -L myarray -m 0.5 -b 4096 -E stride=64,stripe-width=192 /dev/md0

For more on stride and stripe-width, see: RAID Math.

> Add to Kernel Image

Note:The following section is applicable only if the root filesystem
resides on the array. Users may skip this section if the array holds a
data partition(s).

Add mdadm_udev to the HOOKS section of the Mkinitcpio to add support for
mdadm directly into the init image:

    HOOKS="base udev autodetect block mdadm_udev filesystems usbinput fsck"

Be sure to regenerate the initramfs image (see Image creation and
activation) after making the modification to the HOOKS array:

    # mkinitcpio -p linux

> Mounting from a Live CD

Users wanting to mount the RAID partition from a Live CD, use

    # mdadm --assemble /dev/<disk1> /dev/<disk2> /dev/<disk3> /dev/<disk4>

RAID Maintenance
----------------

> Scrubbing

It is good practice to regularly run data scrubbing to check for and fix
errors. Depending on the size/configuration of the array, a scrub may
take multiple hours to complete.

To initiate a data scrub:

    # echo check > /sys/block/md0/md/sync_action

The check operation scans the drives for bad sectors and automatically
repairs them. If it finds good sectors that contain bad data (the data
in a sector does not agree with what the data from another disk
indicates that it should be, for example the parity block + the other
data blocks would cause us to think that this data block is incorrect),
then no action is taken, but the event is logged (see below). This "do
nothing" allows admins to inspect the data in the sector and the data
that would be produced by rebuilding the sectors from redundant
information and pick the correct data to keep.

As with many tasks/items relating to mdadm, the status of the scrub can
be queried by reading /proc/mdstat.

Example:

    $ cat /proc/mdstat

    Personalities : [raid6] [raid5] [raid4] [raid1] 
    md0 : active raid1 sdb1[0] sdc1[1]
          3906778112 blocks super 1.2 [2/2] [UU]
          [>....................]  check =  4.0% (158288320/3906778112) finish=386.5min speed=161604K/sec
          bitmap: 0/30 pages [0KB], 65536KB chunk

To stop a currently running data scrub safely:

    # echo idle > /sys/block/md0/md/sync_action

Note:If the system is rebooted after a partial scrub has been suspended,
the scrub will start over.

When the scrub is complete, admins may check how many blocks (if any)
have been flagged as bad:

    # cat /sys/block/md0/md/mismatch_cnt

General Notes on Scrubbing

Note:Users may alternatively echo repair to
/sys/block/md0/md/sync_action but this is ill-advised since if a
mismatch in the data is encountered, it would be automatically updated
to be consistent. The danger is that we really don't know whether it's
the parity or the data block that's correct (or which data block in case
of RAID1). It's luck-of-the-draw whether or not the operation gets the
right data instead of the bad data.

It is a good idea to set up a cron job as root to schedule a periodic
scrub. See raid-check which can assist with this.

RAID1 and RAID10 Notes on Scrubbing

Due to the fact that RAID1 and RAID10 writes in the kernel are
unbuffered, an array can have non-0 mismatch counts even when the array
is healthy. These non-0 counts will only exist in transient data areas
where they don't pose a problem. However, since we can't tell the
difference between a non-0 count that is just in transient data or a
non-0 count that signifies a real problem. This fact is a source of
false positives for RAID1 and RAID10 arrays. It is however recommended
to still scrub to catch and correct any bad sectors there might be in
the devices.

> Removing Devices from an Array

One can remove a device from the array after marking it as faulty:

    # mdadm --fail /dev/md0 /dev/sdxx

Now remove it from the array:

    # mdadm -r /dev/md0 /dev/sdxx

Remove device permanently (for example, to use it individually from now
on): Issue the two commands described above then:

    # mdadm --zero-superblock /dev/sdxx

Warning: Reusing the removed disk without zeroing the superblock WILL
CAUSE LOSS OF ALL DATA on the next boot. (After mdadm will try to use it
as the part of the raid array). DO NOT issue this command on linear or
RAID0 arrays or data LOSS will occur!

Stop using an array:

1.  Umount target array
2.  Stop the array with: mdadm --stop /dev/md0
3.  Repeat the three command described in the beginning of this section
    on each device.
4.  Remove the corresponding line from /etc/mdadm.conf

> Adding a New Device to an Array

Adding new devices with mdadm can be done on a running system with the
devices mounted. Partition the new device using the same layout as one
of those already in the arrays as discussed above.

Assemble the RAID array if it is not already assembled:

    # mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1

Add the new device the array:

    # mdadm --add /dev/md0 /dev/sdc1

This should not take long for mdadm to do. Again, check the progress
with:

    # cat /proc/mdstat

Check that the device has been added with the command:

    # mdadm --misc --detail /dev/md0

Monitoring
----------

A simple one-liner that prints out the status of the RAID devices:

    awk '/^md/ {printf "%s: ", $1}; /blocks/ {print $NF}' </proc/mdstat

    md1: [UU]
    md0: [UU]

> Watch mdstat

    watch -t 'cat /proc/mdstat'

Or preferably using tmux

    tmux split-window -l 12 "watch -t 'cat /proc/mdstat'"

> Track IO with iotop

The iotop package displays the input/output stats for processes. Use
this command to view the IO for raid threads.

    iotop -a -p $(sed 's, , -p ,g' <<<`pgrep "_raid|_resync|jbd2"`)

> Track IO with iostat

The iostat package displays the input/output statistics for devices and
partitions.

     iostat -dmy 1 /dev/md0
     iostat -dmy 1 # all

> Mailing on events

A smtp mail server (sendmail) or at least an email forwarder
(ssmtp/msmtp) is required to accomplish this. Perhaps the most
simplistic solution is to use dma which is very tiny (installs to 0.08
MiB) and requires no setup.

Edit /etc/mdadm.conf defining the email address to which notifications
will be received.

Note:If using dma as mentioned above, users may simply mail directly to
the username on the localhost rather than to an external email address.

To test the configuration:

    # mdadm --monitor --scan --test

When satisfied with the results, enable the mdadm daemon:

    # systemctl enable mdadm.service

Alternative method

To avoid the installation of a smtp mail server or an email forwarder
you can use the S-nail tool (don't forget to setup) already on your
system.

Create a file named /etc/mdadm_warning.sh with:

    #!/bin/bash
    event=$1
    device=$2

    echo " " | /usr/bin/mailx -s "$event on $device" destination@email.com

And give it execution permissions chmod +x /etc/mdadm_warning.sh

Then add this to the mdadm.conf

    PROGRAM /etc/mdadm_warning.sh

To test and enable use the same as in the previous method.

Troubleshooting
---------------

If you are getting error when you reboot about "invalid raid superblock
magic" and you have additional hard drives other than the ones you
installed to, check that your hard drive order is correct. During
installation, your RAID devices may be hdd, hde and hdf, but during boot
they may be hda, hdb and hdc. Adjust your kernel line accordingly. This
is what happened to me anyway.

> Start arrays read-only

When an md array is started, the superblock will be written, and resync
may begin. To start read-only set the kernel module md_mod parameter
start_ro. When this is set, new arrays get an 'auto-ro' mode, which
disables all internal io (superblock updates, resync, recovery) and is
automatically switched to 'rw' when the first write request arrives.

Note:The array can be set to true 'ro' mode using mdadm -r before the
first write request, or resync can be started without a write using
mdadm -w.

To set the parameter at boot, add md_mod.start_ro=1 to your kernel line.

Or set it at module load time from /etc/modprobe.d/ file or from
directly from /sys/.

    echo 1 > /sys/module/md_mod/parameters/start_ro

> Recovering from a broken or missing drive in the raid

You might get the above mentioned error also when one of the drives
breaks for whatever reason. In that case you will have to force the raid
to still turn on even with one disk short. Type this (change where
needed):

    # mdadm --manage /dev/md0 --run

Now you should be able to mount it again with something like this (if
you had it in fstab):

    # mount /dev/md0

Now the raid should be working again and available to use, however with
one disk short! So, to add that one disc partition it the way like
described above in Prepare the device. Once that is done you can add the
new disk to the raid by doing:

    # mdadm --manage --add /dev/md0 /dev/sdd1

If you type:

    # cat /proc/mdstat

you probably see that the raid is now active and rebuilding.

You also might want to update your configuration (see: #Update
configuration file).

Benchmarking
------------

There are several tools for benchmarking a RAID. The most notable
improvement is the speed increase when multiple threads are reading from
the same RAID volume.

Tiobench specifically benchmarks these performance improvements by
measuring fully-threaded I/O on the disk.

Bonnie++ tests database type access to one or more files, and creation,
reading, and deleting of small files which can simulate the usage of
programs such as Squid, INN, or Maildir format e-mail. The enclosed ZCAV
program tests the performance of different zones of a hard drive without
writing any data to the disk.

hdparm should NOT be used to benchmark a RAID, because it provides very
inconsistent results.

See also
--------

-   Software RAID in the new Linux 2.4 kernel, Part 1 and Part 2 in the
    Gentoo Linux Docs
-   Linux RAID wiki entry on The Linux Kernel Archives
-   How Bitmaps Work
-   Arch Linux software RAID installation guide on Linux 101
-   Chapter 15: Redundant Array of Independent Disks (RAID) of Red Hat
    Enterprise Linux 6 Documentation
-   Linux-RAID FAQ on the Linux Documentation Project
-   Dell.com Raid Tutorial - Interactive Walkthrough of Raid
-   BAARF including Why should I not use RAID 5? by Art S. Kagel
-   Introduction to RAID, Nested-RAID: RAID-5 and RAID-6 Based
    Configurations, Intro to Nested-RAID: RAID-01 and RAID-10, and
    Nested-RAID: The Triple Lindy in Linux Magazine
-   HowTo: Speed Up Linux Software Raid Building And Re-syncing
-   RAID5-Server to hold all your data

> mdadm

-   Debian mdadm FAQ
-   mdadm source code
-   Software RAID on Linux with mdadm in Linux Magazine

Forum threads

-   Raid Performance Improvements with bitmaps
-   GRUB and GRUB2
-   Can't install grub2 on software RAID
-   Use RAID metadata 1.2 in boot and root partition

RAID with encryption

-   Linux/Fedora: Encrypt /home and swap over RAID with dm-crypt by
    Justin Wells

Retrieved from
"https://wiki.archlinux.org/index.php?title=RAID&oldid=305769"

Categories:

-   Getting and installing Arch
-   File systems

-   This page was last modified on 20 March 2014, at 02:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
