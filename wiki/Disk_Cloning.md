Disk Cloning
============

Disk cloning is the process of making an image of a partition or an
entire hard drive. This can be useful both for copying the drive to
other computers and for backup/recovery purposes.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Using dd                                                           |
|     -   1.1 Cloning a partition                                          |
|     -   1.2 Cloning an entire hard disk                                  |
|     -   1.3 Backing up the MBR                                           |
|     -   1.4 Create disk image                                            |
|     -   1.5 Restore system                                               |
|                                                                          |
| -   2 Using cp                                                           |
| -   3 Disk cloning software                                              |
|     -   3.1 Disk cloning in Arch                                         |
|     -   3.2 Disk cloning outside of Arch                                 |
|                                                                          |
| -   4 External Links                                                     |
+--------------------------------------------------------------------------+

> Using dd

The dd command is a simple, yet versatile and powerful tool. It can be
used to copy from source to destination, block-by-block, regardless of
their filesystem types or operating systems. A convenient method is to
use dd from a live environment, as in a livecd.

Warning:As with any command of this type, you should be very cautious
when using it; it can destroy data. Remember the order of input file
(if=) and output file (of=) and do not reverse them! Always ensure that
the destination drive or partition (of=) is of equal or greater size
than the source (if=).

Cloning a partition

From physical disk /dev/sda, partition 1, to physical disk /dev/sdb,
partition 1.

    dd if=/dev/sda1 of=/dev/sdb1 bs=4096 conv=notrunc,noerror

If output file of (sdb1 in the example) does not exist, dd will start at
the beginning of the disk and create it.

Cloning an entire hard disk

From physical disk /dev/sda to physical disk /dev/sdb

    dd if=/dev/sda of=/dev/sdb bs=4096 conv=notrunc,noerror

This will clone the entire drive, including MBR (and therefore
bootloader), all partitions, UUID's, and data.

-   notrunc or 'do not truncate' maintains data integrity by instructing
    dd not to truncate any data.
-   noerror instructs dd to continue operation, ignoring all input
    errors. Default behavior for dd is to halt at any error.
-   bs=4096 sets the block size to 4k, an optimal size for hard disk
    read/write efficiency and therefore, cloning speed.

Backing up the MBR

The MBR is stored in the the first 512 bytes of the disk. It consist of
3 parts:

1.  The first 446 bytes contain the boot loader.
2.  The next 64 bytes contain the partition table (4 entries of 16 bytes
    each, one entry for each primary partition).
3.  The last 2 bytes contain an identifier

To save the MBR into the file "mbr.img":

      # dd if=/dev/hda of=/mnt/sda1/mbr.img bs=512 count=1

To restore (be careful : this could destroy your existing partition
table and with it access to all data on the disk):

      # dd if=/mnt/sda1/mbr.img of=/dev/hda

If you only want to restore the boot loader, but not the primary
partition table entries, just restore the first 446 bytes of the MBR:

      # dd if=/mnt/sda1/mbr.img of=/dev/hda bs=446 count=1

To restore only the partition table, one must use

      # dd if=/mnt/sda1/mbr.img of=/dev/hda bs=1 skip=446 count=64

You can also get the MBR from a full dd disk image.

      #dd if=/path/to/disk.img of=/mnt/sda1/mbr.img bs=512 count=1

Create disk image

1. Boot from a liveCD or liveUSB.

2. Make sure no partitions are mounted from the source hard drive.

3. Mount the external HD

4. Backup the drive.

     # dd if=/dev/hda conv=sync,noerror bs=64K | gzip -c  > /mnt/sda1/hda.img.gz

5. Save extra information about the drive geometry necessary in order to
interpret the partition table stored within the image. The most
important of which is the cylinder size.

     # fdisk -l /dev/hda > /mnt/sda1/hda_fdisk.info

NOTE: You may wish to use a block size (bs=) that is equal to the amount
of cache on the HD you are backing up. For example, bs=8192K works for
an 8MB cache. The 64K mentioned in this article is better than the
default bs=512 bytes, but it will run faster with a larger bs=.

Restore system

To restore your system:

     # gunzip -c /mnt/sda1/hda.img.gz | dd of=/dev/hda

> Using cp

The cp program can be used to clone a disk, one partition at a time. An
advantage to using cp is that the filesystem type of the destination
partition(s) may be the same or different than the source. For safety,
perform the process from a live environment.

The basic procedure from a live environment will be:

-   Create the new destination partition(s) using fdisk, cfdisk or other
    tools available in the live environment.
-   Create a filesystem on each of the newly created partitions.
    Example:

    mkfs -t ext3 /dev/sdb1

-   Mount the source and destination partitions. Example:

    mount -t ext3 /dev/sda1 /mnt/source
    mount -t ext3 /dev/sdb1 /mnt/destination

-   Copy the files from the source partition to the destination

    cp -a /mnt/source/* /mnt/destination

-a: preserve all attributes , never follow symbolic links and copy
recursively

-   Change the mount points of the newly cloned partitions in /etc/fstab
    accordingly
-   Finally, install the GRUB bootloader if necessary. (See GRUB)

Disk cloning software
---------------------

> Disk cloning in Arch

The ncurses program PartImage is in the community repos. The interface
is not exceptionally intuitive but it works. There are currently no
GTK/QT based disk cloners for Linux. Another option is to use dd, a
small CLI image/file creation utility. The wikipedia has a list of
various version of dd, specifically oriented to this purpose
wikipedia:Dd_(Unix)#Recovery-oriented_variants_of_dd. dd_rescue works
efficiently with corrupt disks copying error free areas first and later
retrying error areas.

> Disk cloning outside of Arch

If you wish to backup or propagate your Arch install root, you are
probably better off booting into something else and clone the partition
from there. Some suggestions:

-   PartedMagic has a very nice live cd/usb with PartImage and other
    recovery tools.
-   Mindi is a linux distribution specifically for disk clone backup. It
    comes with its own cloning program, Mondo Rescue.
-   Acronis True Image is a commercial disk cloner for Windows. It
    allows you to create a live cd (from within Windows), so you do not
    need a working Windows install on the actual machine to use it.
-   FSArchiver allows you to save the contents of a file system to a
    compressed archive file. Can be found on the System Rescue CD.
-   Clonezilla is an enhanced partition imager which can also restore
    entire disks as well as partitions.
-   Redo Backup and Recovery is a Live CD featuring a graphical
    front-end to partclone.

External Links
--------------

-   Wikipedia:List of disk cloning software
-   Arch Linux forum thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Disk_Cloning&oldid=245025"

Categories:

-   Data compression and archiving
-   System recovery
