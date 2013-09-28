File Recovery
=============

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preface/Introduction                                               |
|     -   1.1 Page Overview                                                |
|     -   1.2 Special Notes                                                |
|         -   1.2.1 Failing Drives                                         |
|         -   1.2.2 Backup Flash Media/Small Partitions                    |
|         -   1.2.3 Working with Digital Cameras                           |
|                                                                          |
| -   2 Foremost                                                           |
|     -   2.1 Description                                                  |
|     -   2.2 Installation                                                 |
|     -   2.3 External Links                                               |
|                                                                          |
| -   3 Extundelete                                                        |
|     -   3.1 Description                                                  |
|     -   3.2 Installation                                                 |
|     -   3.3 Usage                                                        |
|                                                                          |
| -   4 Photorec                                                           |
|     -   4.1 Description                                                  |
|     -   4.2 Installation                                                 |
|     -   4.3 External Links                                               |
|                                                                          |
| -   5 Testdisk                                                           |
|     -   5.1 Description                                                  |
|     -   5.2 Installation                                                 |
|     -   5.3 External Links                                               |
|                                                                          |
| -   6 e2fsck                                                             |
|     -   6.1 Description                                                  |
|     -   6.2 Installation                                                 |
|     -   6.3 External Links                                               |
|                                                                          |
| -   7 Working with Raw Disk Images                                       |
|     -   7.1 Mount the Entire Disk                                        |
|     -   7.2 Mounting Partitions                                          |
|         -   7.2.1 Getting Disk Geometry                                  |
|                                                                          |
|     -   7.3 Using QEMU to Repair NTFS                                    |
|                                                                          |
| -   8 Text file recovery                                                 |
| -   9 External links                                                     |
+--------------------------------------------------------------------------+

Preface/Introduction
--------------------

> Page Overview

This article is meant to capture several file recovery or undelete
options for Arch Linux. Please contribute to this page using the general
format below and keeping it brief.

> Special Notes

Failing Drives

In the arena of data recovery, it is best to work on images of disks
rather than the physical disks themselves. Generally, a failing drive's
condition worsens over time. The goal ought to be to copy as much data
as possible as early as possible, and to then abandon the disk. The
ddrescue and dd_rescue utilities (ddrescue in repos, dd_rescue in AUR),
unlike dd will repeatedly try to recover from errors, and will read the
drive front to back, then back to front, attempting to salvage data. It
keeps a log file so that you can pause and resume recovery without
losing your progress.

See Disk Cloning.

The image files created from a utility like ddrescue can then be mounted
like a physical device and can be worked on safely. Always make a copy
of the original image so that you can revert if things go sour!

A tried and true method of improving failing drive reads is to keep it
cold. A bit of time in the freezer is appropriate, but be careful to
avoid bringing the drive from cold to warm too quickly, as condensation
will form. Keeping the drive in the freezer with cables connected to the
recovering PC works great.

Do not attempt a filesystem check on a failing drive, as this will
likely make the problem worse. Keep it read-only.

Backup Flash Media/Small Partitions

As an alternative to working with a 'live' partition (mounted or not),
it is often preferable to work with an image provided that the
filesystem in question isn't too large and that you have sufficient free
HDD space to accommodate the image file. For example, flash memory
devices like, thumb drives, digital cameras, portable music players,
cellular phones, etc.

Be sure to read the man pages for the utilities listed below to verify
that they are capable of working with an image file.

To make an image, one can use dd as follows:

    # dd if=/dev/target_partition of=/home/user/partition.image

Working with Digital Cameras

In order for some of the utils listed in the next section to work with
flash media, one needs to have the device in question mounted as a block
device (i.e. it is listed under /dev). Digital cameras operating in PTP
(Picture Transfer Protocol) mode will not work in this regard. PTP
cameras are transparently handled by libgphoto and/or libptp.
Transparently as in, they don't get a block device. The alternative to
PTP mode is USB Mass Storage (UMS) mode which may or may not be
supported by your camera. Some cameras will have a menu item allowing
the user to switch between the two modes; refer to your camera's user
manual. If your camera does not support UMS mode and therefore cannot be
accessed as a block device, your only alternative is to use a flash
media reader and physically remove the media from your camera.

Foremost
--------

> Description

Foremost is a console program to recover files based on their headers,
footers, and internal data structures. This process is commonly referred
to as data carving. Foremost can work on image files, such as those
generated by dd, Safeback, Encase, etc, or directly on a drive. The
headers and footers can be specified by a configuration file or you can
use command line switches to specify built-in file types. These built-in
types look at the data structures of a given file format allowing for a
more reliable and faster recovery.

> Installation

Foremost is available from the AUR in this page.

> External Links

-   Wiki:
-   Homepage: http://foremost.sourceforge.net

Extundelete
-----------

> Description

Extundelete is a terminal-based utility that can recover deleted files
from ext3 and ext4 partitions. It can recover all the recently deleted
files from a partition and/or a specific file(s) given by relative path
or inode information. Note that it works only when the partition is
unmounted. The recovered files are saved in the current directory under
the folder named RECOVERED_FILES/.

> Installation

Extundelete is available in the [community] repository; you can simply
download it with

    # pacman -S extundelete

> Usage

Derived from the post on Linux Poison.

To recover data from a specific partition, you must know the device name
for that partition, which will be in the form '/dev/sdxX', where 'x' is
a letter and 'X' is a number. The example used will be /dev/sda4, but
your system might use something different depending on your filesystem
configuration. If you are unsure, run 'df', which will give you a list
of currently mounted partitions.

Once you have determined which partition you want to recover from, you
can simply run extundelete as so:

    # extundelete /dev/sda4 --restore-file directory/file

Any subdirectories must be specified and the command runs from the
highest level of the partition, so if you are recovering a file in
/home/user/ (where user/ is your user's home directory), and assuming
that your /home directory is on its own partition, you would run

    # extundelete /dev/sda4 restore-file user/file

To speed up multi-file recovery, there is a --restore-files option as
well.

If you want to recover an entire directory, you can do it simply with

    # extundelete /dev/sda4 --restore-directory user/directory

If you are an advanced user and wish to manually recover a block or
inode with extundelete, you can use debugfs to find the inode you wish
to recover, then run

    # extundelete --restore-inode <inode>

<inode> is any valid inode. Additional inodes to recover can be listed
in an unspaced, comma-separated fashion.

Finally, if you wish to recover all deleted files from an entire
partition, you can do so with

    # extundelete /dev/sda4 --restore-all

Photorec
--------

> Description

Photorec is a complementary utility to TestDisk; both open-source data
recovery utilities licensed under the terms of the GNU Public License
(GPL). Photorec is file data recovery software designed to recover lost
files including video, documents and archives from Hard Disks and CDRom
and lost pictures (thus, its 'Photo Recovery' name) from digital camera
memory. PhotoRec ignores the filesystem and goes after the underlying
data, so it will still work even if your media's filesystem has been
severely damaged or re-formatted.

> Installation

Both TestDisk and Photorec are available for Arch i686 and x64_86 in the
same package.

    # pacman -S testdisk

> External Links

-   Wiki (Photorec): http://www.cgsecurity.org/wiki/PhotoRec
-   Homepage: http://www.cgsecurity.org/

Testdisk
--------

> Description

TestDisk, like Photorec are both open-source data recovery utilities
licensed under the terms of the GNU Public License (GPL). TestDisk is
primarily designed to help recover lost partitions and/or make
non-booting disks bootable again when these symptoms are caused by
faulty software, certain types of viruses or human error (such as
accidentally deleting a Partition Table).

> Installation

Both TestDisk and Photorec are available for Arch i686 and x64_86 in the
same package.

    # pacman -S testdisk

> External Links

-   Wiki (TestDisk): http://www.cgsecurity.org/wiki/TestDisk
-   Homepage: http://www.cgsecurity.org/

e2fsck
------

> Description

e2fsck, is the ext2/ext3 filesystem checker included in the base install
of Arch. e2fsck relies on a valid superblock. A superblock is a
description of the entire filesystem's parameters. Because this data is
so important, several copies of the superblock are distributed amongst
the partition data. e2fsck can take an alternate superblock argument if
the main (first) superblock is damaged (use the -b option).

To determine where the superblocks are, run dumpe2fs -h on the affected,
unmounted partition. Superblocks are spaced differently depending on the
blocksize specified when the ext2/ext3 filesystem was created.

An alternate method to determine superblocks is to use the -n option
with mke2fs. Be sure to use the -n flag, which "causes mke2fs to not
actually create a filesystem, but display what it would do if it were to
create a filesystem. This can be used to determine the location of the
backup superblocks for a particular filesystem."

> Installation

e2fsck and dumpe2fs are included in the base Arch i686 and x64_86
install.

> External Links

-   e2fsck man page:
    http://phpunixman.sourceforge.net/index.php/man/e2fsck/8
-   dumpe2fs man page:
    http://phpunixman.sourceforge.net/index.php?parameter=dumpe2fs&mode=man

Working with Raw Disk Images
----------------------------

If you backed up a drive using ddrescue or dd, and you need to mount
this image as a physical drive, then look no further!

> Mount the Entire Disk

In progress.

> Mounting Partitions

Before you can work with the partitions and filesystems in a raw disk
image, you must know where things are inside the image. See the next
section for this.

Getting Disk Geometry

After mounting the entire disk image as a loopback device, you can
inspect it for it's drive layout.

> Using QEMU to Repair NTFS

Say you have a disk image that contains one or more NTFS partitions, and
you need to run Windows chkdsk to fix the filesystem. QEMU let's you use
a raw dd or ddrescue image as a real hard disk inside a virtual machine.

    # qemu -hda /path/to/primary.img -hdb /path/to/damagedDisk.img

Text file recovery
------------------

It's possible to find deleted plain text on your hard drive with a few
commands, you just need to know a (preferably unique) string from the
file you're trying to recover.

You need to use first the strings command to dump all the text from your
partition :

    # strings /dev/hda1 > bigstringsfile

Then grep the strings output for the relevant output

    $ grep -i -200 "Unique string in text file" bigstringsfile > grepoutputfile

The -200 option tells grep to report the 200 lines before and after the
string you choose.

You can now find in grepoutfile the deleted data.

  

External links
--------------

-   Data Recovery on the Ubuntu wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=File_Recovery&oldid=206493"

Categories:

-   File systems
-   System recovery
