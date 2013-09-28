RAID
====

Summary

This article explains what RAID is and how to install, configure and
maintain it.

Required software

mdadm

parted

Related

Software RAID and LVM

Installing with Fake RAID

Convert a single drive system to RAID

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
|     -   1.1 Standard RAID levels                                         |
|     -   1.2 Nested RAID levels                                           |
|     -   1.3 Redundancy                                                   |
|     -   1.4 RAID level comparison                                        |
|                                                                          |
| -   2 Installation                                                       |
|     -   2.1 Prepare the device                                           |
|     -   2.2 Create the partition table                                   |
|         -   2.2.1 Partition code                                         |
|                                                                          |
|     -   2.3 Copy the partition table                                     |
|     -   2.4 Build the array                                              |
|     -   2.5 Update configuration file                                    |
|     -   2.6 Configure filesystem                                         |
|     -   2.7 Assemble array on boot                                       |
|     -   2.8 Add to kernel image                                          |
|                                                                          |
| -   3 Mounting from a Live CD                                            |
| -   4 Removing device, stop using the array                              |
| -   5 Adding a device to the array                                       |
| -   6 Monitoring                                                         |
|     -   6.1 Watch mdstat                                                 |
|     -   6.2 Track IO with iotop                                          |
|     -   6.3 Mailing on events                                            |
|                                                                          |
| -   7 Troubleshooting                                                    |
|     -   7.1 Start arrays read-only                                       |
|     -   7.2 Recovering from a broken or missing drive in the raid        |
|                                                                          |
| -   8 Benchmarking                                                       |
| -   9 Additional Resources                                               |
+--------------------------------------------------------------------------+

Introduction
------------

See the Wikipedia article on this subject for more information: RAID

Redundant Array of Independent Disks (RAID) devices are virtual devices
created from two or more real block devices. This allows multiple
devices (typically disk drives or partitions thereof) to be combined
into a single device to hold (for example) a single filesystem. RAID is
designed to prevent data loss in the event of a hard disk failure. There
are different levels of RAID.

> Standard RAID levels

 RAID 0
    Uses striping to combine disks. Not really RAID in that it provides
    no redundancy. It does, however, provide a big speed benefit. This
    example will utilize RAID 0 for swap, on the assumption that a
    desktop system is being used, where the speed increase is worth the
    possibility of system crash if one of your drives fails. On a
    server, a RAID 1 or RAID 5 array is more appropriate. The size of a
    RAID 0 array block device is the size of the smallest component
    partition times the number of component partitions.
 RAID 1
    The most straightforward RAID level: straight mirroring. As with
    other RAID levels, it only makes sense if the partitions are on
    different physical disk drives. If one of those drives fails, the
    block device provided by the RAID array will continue to function as
    normal. The example will be using RAID 1 for everything except swap.
    Note that RAID 1 is the only option for the boot partition, because
    bootloaders (which read the boot partition) do not understand RAID,
    but a RAID 1 component partition can be read as a normal partition.
    The size of a RAID 1 array block device is the size of the smallest
    component partition.
 RAID 5
    Requires 3 or more physical drives, and provides the redundancy of
    RAID 1 combined with the speed and size benefits of RAID 0. RAID 5
    uses striping, like RAID 0, but also stores parity blocks
    distributed across each member disk. In the event of a failed disk,
    these parity blocks are used to reconstruct the data on a
    replacement disk. RAID 5 can withstand the loss of one member disk.
    Note:RAID 5 is a common choice due to its combination of speed and
    data redundancy. The caveat is that if 1 drive were to fail and
    before that drive was replaced another drive failed, all data will
    be lost. For excellent information regarding this, see the RAID5
    Risks discussion thread on the Ubuntu forums. The best alternative
    to RAID5 when redundancy is crucial is RAID 10.

> Nested RAID levels

 RAID 1+0
    Commonly referred to as RAID 10, is a nested RAID that combines two
    of the standard levels of RAID to gain performance and additional
    redundancy.

> Redundancy

Warning:Installing a system with RAID is a complex process that may
destroy data. Be sure to backup all data before proceeding.

RAID does not provide a guarantee that your data is safe. If there is a
fire, if your computer is stolen or if you have multiple hard drive
failures, RAID will not protect your data. Therefore it is important to
make backups (see Backup Programs). Whether you use tape drives, DVDs,
CDROMs or another computer, keep an current copy of your data out of
your computer (and preferably offsite). Get into the habit of making
regular backups. You can also divide the data on your computer into
current and archived directories. Then back up the current data
frequently, and the archived data occasionally.

> RAID level comparison

  RAID level   Data redundancy   Physical drive utilization   Read performance   Write performance   Min drives
  ------------ ----------------- ---------------------------- ------------------ ------------------- ------------
  0            No                100%                         Superior           Superior            1
  1            Yes               50%                          Very high          Very high           2
  5            Yes               67% - 94%                    Superior           High                3
  6            Yes               50% - 88%                    Very High          High                4
  10           Yes               50%                          Very high          Very high           4

Installation
------------

Install mdadm and parted, available in the Official Repositories.

> Prepare the device

To prevent possible issues down the line, you should consider wiping
your entire disk before setting up RAID. This should be repeated for
each disk you will be using for RAID, these commands completely erase
anything currently on the device!

Warning:These steps erase everything on the /dev/disk-to-clean so type
carefully

Erase any old RAID configuration info

    # mdadm --zero-superblock /dev/disk-to-clean

Erase all partition-table data

    # dd if=/dev/zero of=/dev/disk-to-clean bs=4096 count=1

Make sure kernel clears old entries

    # partprobe -s

Verify the entries in /etc/fstab and /etc/mdadm.conf

With a software RAID, disabling the hard disk cache will help prevent
data loss during power loss, as long as you do not use a UPS. Repeat the
command for each drive in the array. Note however, that this decreases
performance.

    # hdparm -W 0 /dev/path_to_disk

> Create the partition table

The RAID setup varies between different RAID-levels. If you know what
RAID you want and already set up your hardware accordingly, you can
proceed with formatting the disks you want in your array. It is also
possible to create a RAID directly on the raw disks (without
partitions), but not recommended because it can cause problems when
swapping a failed disk.

When replacing a failed disk of a RAID-array, the new disk has to be
exactly the same size as the failed disk or bigger — otherwise the array
recreation process will not work. Even hard drives of the same
manufacturer and model can have small size differences. By leaving a
little space at the end of the disk unallocated one can compensate for
the size differences between drives, which makes choosing a replacement
drive model easier. Therefore, it is good practice to leave about 100 MB
of unallocated space at the end of the disk.

Format one of the drives in the array with your favorite tool. For
example,

    # cfdisk /dev/path_to_disk

Tip:Using GParted to create the partitions and align them to the
cylinder will create optimized disk alignment. This can be achieved
using the Gnome Partition Editor Live Media.

Partition code

The two partition types that are applicable to RAID devices are Non-FS
data and Linux RAID auto. Non-FS data is recommended, as your array is
not auto-assembled during boot. With Linux RAID auto one may run into
trouble when booting from a live-cd or when installing the degraded
RAID-array in a different system (maybe with other degraded RAID-arrays
in worst case) as Linux will try to automatically assemble and resync
the array which could render your data on the array unreadable if it
fails.

Note:cfdisk and mkpart use a set of "filesystem types" to set the
partition codes. Each type corresponds to a partition code (see Parted
User's Manual). It uses the da type to denote Non-FS data and fd for
Linux RAID auto.

> Copy the partition table

Once you have a properly partitioned and aligned disk you can copy the
setup to any other disk.

Verify your partitions meet basic requirements:

    # sfdisk -lRV /dev/path_to_formatted_array_disk

Dump the partition table from the formatted disk to a file:

    # sfdisk -d /dev/path_to_formatted_array_disk > ~/formatted_array.dump

Copy the partition table from the disk dump file to all other disks in
the array:

    # sfdisk /dev/path_to_unformatted_array_disk < ~/formatted_array.dump

After repeating the command for every unformatted disk of the array,
verify that the disks are identical with

    # fdisk -l

or

    # sfdisk -l -u S

> Build the array

Now build the array (e.g. post on RAID5 setup).

Warning:Make sure to change the bold values below to match your setup.

     # mdadm --create --verbose /dev/md/your_array --level=5 --metadata=1.2 --chunk=256 --raid-devices=5 /dev/path_to_array_disk-1 /dev/path_to_array_disk-2 /dev/path_to_array_disk-3 /dev/path_to_array_disk-4 /dev/path_to_array_disk-5 

The array is created under the virtual device /dev/md/your_array,
assembled and ready to use (in degraded mode). You can directly start
using it while mdadm resyncs the array in the background. It can take a
long time to restore parity, you can check the progress with:

    $ cat /proc/mdstat

> Update configuration file

Since the installer builds the initrd using /etc/mdadm.conf in the
target system, you should update the default configuration file. The
default file can be overwritten using the redirection operator, because
it only contains explanatory comments.

Redirect the contents of the metadata stored on the named devices to the
configuration file:

    # mdadm --examine --scan > /etc/mdadm.conf

Note:If you are updating your RAID configuration from within the Arch
Installer by swapping to another TTY, you will need to ensure that you
are writing to the correct mdadm.conf file:

    # mdadm --examine --scan > /mnt/etc/mdadm.conf

Once the configuration file has been updated the array can be assembled
using mdadm:

    # mdadm --assemble --scan

> Configure filesystem

The array can now be formatted like any other disk, just keep in mind
that:

-   Due to the large volume size not all filesystems are suited (see:
    File system limits).
-   The filesystem should support growing and shrinking while online
    (see: File system features).
-   The biggest performance gain you can achieve on a raid array is to
    make sure you format the volume aligned to your RAID stripe size
    (see: RAID Math).

> Assemble array on boot

If you selected the Non-FS data partition code the array will not be
automatically recreated after the next boot. To assemble the array issue
the following command:

     # mdadm --assemble --scan /dev/your_array --uuid=your_array_uuid 

or write it to rc.local.

  

> Add to kernel image

See mkinitcpio for more info.

Add mdadm or mdadm_udev to the HOOKS= section of the
/etc/mkinitcpio.conf file before the filesystems hook. This will add
support for mdadm directly into the init image.

    HOOKS="base udev autodetect pata scsi sata mdadm_udev filesystems usbinput fsck"

You can view available hooks for the HOOKS= section with:

    # mkinitcpio -L

and find out information about each hook with:

    # mkinitcpio -H mdadm_udev

Add raid456 module and the filesystem module used on the raid (ext4) to
the MODULES= section of the /etc/mkinitcpio.conf file. This will build
these modules into the kernel image.

    MODULES="ext4 raid456"

Next regenerate your initrd with:

    # mkinitcpio -p linux

or if using linux-lts

    # mkinitcpio -p linux-lts

Mounting from a Live CD
-----------------------

If you want to mount your RAID partition from a Live CD, use

    # mdadm --assemble /dev/md0 /dev/sda3 /dev/sdb3 /dev/sdc3

(or whatever mdX and drives apply to you)

Note: Live CDs like SystemrescueCD assemble the RAID arrays
automatically at boot time if you used the partition type fd at the
install of the array)

Removing device, stop using the array
-------------------------------------

You can remove a device from the array after you mark it as faulty.

    # mdadm --fail /dev/md0 /dev/sdxx

Then you can remove it from the array.

    # mdadm -r /dev/md0 /dev/sdxx

Remove device permanently (for example in the case you want to use it
individally from now on). Issue the two commands described above then:

    # mdadm --zero-superblock /dev/sdxx

After this you can use the disk as you did before creating the array.

Warning: If you reuse the removed disk without zeroing the superblock
you will LOSE all your data next boot. (After mdadm will try to use it
as the part of the raid array). DO NOT issue this command on linear or
RAID0 arrays or you will LOSE all your data on the raid array.

Stop using an array:

1.  Umount target array
2.  Stop the array with: mdadm --stop /dev/md0
3.  Repeat the three command described in the beginning of this section
    on each device.
4.  Remove the corresponding line from /etc/mdadm.conf

Adding a device to the array
----------------------------

Adding new devices with mdadm can be done on a running system with the
devices mounted. Partition the new device /dev/sdx using the same layout
as one of those already in the arrays /dev/sda.

    # sfdisk -d /dev/sda > table
    # sfdisk /dev/sdx < table

Assemble the RAID arrays if they are not already assembled:

    # mdadm --assemble /dev/md1 /dev/sda1 /dev/sdb1 /dev/sdc1
    # mdadm --assemble /dev/md2 /dev/sda2 /dev/sdb2 /dev/sdc2
    # mdadm --assemble /dev/md0 /dev/sda3 /dev/sdb3 /dev/sdc3

First, add the new device as a Spare Device to all of the arrays. We
will assume you have followed the guide and use separate arrays for
/boot RAID 1 (/dev/md1), swap RAID 1 (/dev/md2) and root RAID 5
(/dev/md0).

    # mdadm --add /dev/md1 /dev/sdx1
    # mdadm --add /dev/md2 /dev/sdx2
    # mdadm --add /dev/md0 /dev/sdx3

This should not take long for mdadm to do. Check the progress with:

    # cat /proc/mdstat

Check that the device has been added with the command:

    # mdadm --misc --detail /dev/md0

It should be listed as a Spare Device.

Tell mdadm to grow the arrays from 3 devices to 4 (or however many
devices you want to use):

    # mdadm --grow -n 4 /dev/md1
    # mdadm --grow -n 4 /dev/md2
    # mdadm --grow -n 4 /dev/md0

This will probably take several hours. You need to wait for it to finish
before you can continue. Check the progress in /proc/mdstat. The RAID 1
arrays should automatically sync /boot and swap but you need to install
Grub on the MBR of the new device manually.
Installing_with_Software_RAID_or_LVM#Install_Grub_on_the_Alternate_Boot_Drives

The rest of this guide will explain how to resize the underlying LVM and
filesystem on the RAID 5 array.

Note:I am not sure if this can be done with the volumes mounted and will
assume you are booting from a live-cd/usb

If you are have encrypted your LVM volumes with LUKS, you need resize
the LUKS volume first. Otherwise, ignore this step.

    # cryptsetup luksOpen /dev/md0 cryptedlvm
    # cryptsetup resize cryptedlvm

Activate the LVM volume groups:

    # vgscan
    # vgchange -ay

Resize the LVM Physical Volume /dev/md0 (or e.g. /dev/mapper/cryptedlvm
if using LUKS) to take up all the available space on the array. You can
list them with the command "pvdisplay".

    # pvresize /dev/md0

Resize the Logical Volume you wish to allocate the new space to. You can
list them with "lvdisplay". Assuming you want to put it all to your
/home volume:

    # lvresize -l +100%FREE /dev/array/home

To resize the filesystem to allocate the new space use the appropriate
tool. If using ext2 you can resize a mounted filesystem with ext2online.
For ext3 you can use resize2fs or ext2resize but not while mounted.

You should check the filesystem before resizing.

    # e2fsck -f /dev/array/home
    # resize2fs /dev/array/home

Read the manuals for lvresize and resize2fs if you want to customize the
sizes for the volumes.

Monitoring
----------

A simple one-liner that prints out the status of your Raid devices:

    awk '/^md/ {printf "%s: ", $1}; /blocks/ {print $NF}' </proc/mdstat

    md1: [UU]
    md0: [UU]

> Watch mdstat

    watch -t 'cat /proc/mdstat'

Or preferably using tmux

    tmux split-window -l 12 "watch -t 'cat /proc/mdstat'"

> Track IO with iotop

The iotop package lets you view the input/output stats for processes.
Use this command to view the IO for raid threads.

    iotop -a -p $(sed 's, , -p ,g' <<<`pgrep "_raid|_resync|jbd2"`)

> Mailing on events

You need a smtp mail server (sendmail) or at least an email forwarder
(ssmtp/msmtp). Be sure you have configured an email in /etc/mdadm.conf

    # mdadm --monitor --scan --test

When it is ready you can enable the service

    # systemctl enable mdadm.service

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

Additional Resources
--------------------

-   RAID/Software on the Gentoo Wiki
-   Software RAID Install on the Gentoo Wiki
-   Software RAID in the new Linux 2.4 kernel, Part 1 and Part 2 in the
    Gentoo Linux Docs
-   Linux RAID wiki entry on The Linux Kernel Archives
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

mdadm

-   Debian mdadm FAQ
-   mdadm source code
-   Software RAID on Linux with mdadm in Linux Magazine

Forum threads

-   Raid Performance Improvements with bitmaps
-   2011-08-28 - Arch Linux - GRUB and GRUB2
-   2011-08-03 - Arch Linux - Can't install grub2 on software RAID
-   2011-07-29 - Gentoo - Use RAID metadata 1.2 in boot and root
    partition

RAID with encryption

-   Linux/Fedora: Encrypt /home and swap over RAID with dm-crypt by
    Justin Wells

Retrieved from
"https://wiki.archlinux.org/index.php?title=RAID&oldid=255743"

Categories:

-   Getting and installing Arch
-   File systems
