Btrfs
=====

Related articles

-   File Systems
-   Btrfs - Tips and tricks
-   Mkinitcpio-btrfs

From Wikipedia:Btrfs

Btrfs (B-tree file system, variously pronounced: "Butter F S", "Better F
S", "B-tree F S", or simply "Bee Tee Arr Eff Ess") is a GPL-licensed
experimental copy-on-write file system for Linux. Development began at
Oracle Corporation in 2007.

From Btrfs Wiki

Btrfs is a new copy on write (CoW) filesystem for Linux aimed at
implementing advanced features while focusing on fault tolerance, repair
and easy administration. Jointly developed at Oracle, Red Hat, Fujitsu,
Intel, SUSE, STRATO and many others, Btrfs is licensed under the GPL and
open for contribution from anyone.

> Warning:

-   Btrfs is still considered experimental. See the Btrfs Wiki's
    Stability status, Is Btrfs stable, and Getting started for more
    detailed information.
-   Beware of the limitations.

Contents
--------

-   1 Installation
    -   1.1 Additional packages
-   2 General administration of Btrfs
    -   2.1 Creating a new file system
    -   2.2 Convert from Ext3/4
    -   2.3 Mount options
        -   2.3.1 Examples
    -   2.4 Displaying used/free space
-   3 Limitations
    -   3.1 Encryption
    -   3.2 Swap file
    -   3.3 GRUB
        -   3.3.1 Partition offset
        -   3.3.2 Missing root
-   4 Features
    -   4.1 Copy-On-Write (CoW)
    -   4.2 Multi-device filesystem and RAID feature
        -   4.2.1 Multi-device filesystem
        -   4.2.2 RAID features
    -   4.3 Sub-volumes
        -   4.3.1 Creating sub-volumes
        -   4.3.2 Listing sub-volumes
        -   4.3.3 Setting a default sub-volume
        -   4.3.4 Snapshots
        -   4.3.5 Installing with root on btrfs subvolume
    -   4.4 Defragmentation
    -   4.5 Compression
    -   4.6 Checkpoint interval
    -   4.7 Partitioning
    -   4.8 Scrub
    -   4.9 Balance
-   5 See also

Installation
------------

Btrfs is included in the default kernel and its tools (btrfs-progs) are
available in the official repositories. GRUB, mkinitcpio, and Syslinux
have support for Btrfs and require no additional configuration.

> Additional packages

-   btrfs-progs includes btrfsck, a tool that can fix errors on Btrfs
    filesystems.
-   mkinitcpio-btrfs enables roll-back abilities.
-   btrfs-progs-git for nightly

Tip:See Btrfs Wiki Getting Started for suggestions regarding running
Btrfs effectively.

General administration of Btrfs
-------------------------------

> Creating a new file system

A Btrfs file system can either be newly created or have one converted.

To format a partition do:

    # mkfs.btrfs -L mylabel /dev/partition

Note:As of this commit (November 2013), Btrfs default blocksize is 16KB.

To use a larger blocksize for data/meta data, specify a value for the
leafsize via the -l switch as shown in this example using 16KB blocks:

    # mkfs.btrfs -L mylabel -l 16k /dev/partition

Multiple devices can be entered to create a RAID. Supported RAID levels
include RAID 0, RAID 1, RAID 10, RAID 5 and RAID 6. By default the
metadata is mirrored and data is striped. See Using Btrfs with Multiple
Devices for more information about how to create a Btrfs RAID volume.

    # mkfs.btrfs [options] /dev/part1 /dev/part2

> Convert from Ext3/4

Boot from an install CD, then convert by doing:

    # btrfs-convert /dev/partition

Mount the partion and test the conversion by checking the files. Be sure
to change the /etc/fstab to reflect the change (type to btrfs and
fs_passno [the last field] to 0 as Btrfs does not do a file system check
on boot). Also note that the UUID of the partition will have changed, so
update fstab accordingly when using UUIDs. chroot into the system and
rebuild the GRUB menu list (see Install from Existing Linux and GRUB
articles).

To complete, delete the saved image, delete the sub-volume that image is
on, and finally balance the file system to reclaim the space.

    # rm /ext2_saved/*
    # btrfs subvolume delete /ext2_saved

> Mount options

See Btrfs Wiki Mount options.

In addition to configurations that can be made during or after file
system creation, the various mount options for Btrfs can drastically
change its performance characteristics.

Warning:Specific mount options can disable safety features and increase
the risk of complete file system corruption in the event of a power
failure. (See link above.)

As this is a file system that is in active development. Changes and
regressions should be expected. See links in the "See also" section for
some benchmarks.

Users may need to add the btrfs hook to mkinitcpio if adding a btrfs
partition to /etc/fstab.

Examples

Note:For questions regarding the use of autodefrag on SSDs see Btrfs
Wiki Gotchas, Btrfs Wiki Mount options, and Phoronix 3.11 Benchmarking.

-   Linux 3.12
    -   Btrfs on a SSD for system installation and an emphasis on
        maximizing performance.
    -   rw,noatime,compress=lzo,ssd,discard,space_cache,autodefrag,inode_cache

    -   Btrfs on a HDD for archival purposes with an emphasis on
        maximizing space.
    -   rw,relatime,compress-force=zlib,autodefrag

> Displaying used/free space

General linux userspace tools such as /usr/bin/df will inaccurately
report free space on a Btrfs partition since it does not take into
account space allocated for and used by the metadata. It is recommended
to use /usr/bin/btrfs to query a btrfs partition. Below is an
illustration of this effect, first querying using df -h, and then using
btrfs filesystem df:

    # df -h /

    Filesystem      Size  Used Avail Use% Mounted on
    /dev/sda3       119G  3.0G  116G   3% /

    # btrfs filesystem df /

    Data: total=3.01GB, used=2.73GB
    System: total=4.00MB, used=16.00KB
    Metadata: total=1.01GB, used=181.83MB

Notice that df -h reports 3.0GB used but btrfs filesystem df reports
2.73GB for the data. This is due to the way BTRFS allocates space into
the pool. The true disk usage is the sum of all three 'used' values
which is inferior to 3.0GB as reported by df -h.

Another useful command to show a less verbose readout of used space is
btrfs filesystem show:

    # btrfs filesystem show /dev/sda3

    failed to open /dev/sr0: No medium found
    Label: 'arch64'  uuid: 02ad2ea2-be12-2233-8765-9e0a48e9303a
    	Total devices 1 FS bytes used 2.91GB
    	devid    1 size 118.95GB used 4.02GB path /dev/sda2

    Btrfs v0.20-rc1-358-g194aa4a-dirty

Limitations
-----------

A few limitations should be known before trying.

> Encryption

Btrfs has no built-in encryption support (this may come in future);
users can encrypt the partition before running mkfs.btrfs. See dm-crypt.

Existing Btrfs file system, can use something like EncFS or TrueCrypt,
though perhaps without some of Btrfs' features.

> Swap file

Btrfs does not support swap files. This is due to swap files requiring a
function that Btrfs doesn't have for possibility of corruptions.link A
swap file can be mounted on a loop device with poorer performance but
will not be able to hibernate. A systemd service file is available
systemd-loop-swapfile.

> GRUB

Partition offset

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: This may no      
                           longer be needed. Need   
                           to verify with a direct  
                           installation of Btrfs    
                           without a partition      
                           table. (Discuss)         
  ------------------------ ------------------------ ------------------------

GRUB can boot Btrfs partitions however the module may be larger than
other File Systems and the core.img file made by grub-install may not
fit in the first 63 sectors (31.5KiB) of the drive between the MBR and
the first partition. Up-to-date partitions tools such as fdisk and gdisk
avoid this issue by offsetting the first partition by roughly 1MiB.

Missing root

Users experiencing the following: error no such device: root when
booting from a RAID style setup then edit
/usr/share/grub/grub-mkconfig_lib and remove both quotes from the line
echo "  search --no-floppy --fs-uuid --set=root ${hints} ${fs_uuid}".
Regenerate the config for grub and the system should boot without an
error.

Features
--------

Various features are available and can be adjusted.

> Copy-On-Write (CoW)

The resolution at which data are written to the filesystem is dictated
by Btrfs itself and by system-wide settings. Btrfs defaults to a 30
seconds checkpoint interval in which new data are committed to the
filesystem. This is tuneable using mount options (see below)

System-wide settings also affect commit intervals. They include the
files under /proc/sys/vm/* and are out-of-scope of this wiki article.
The kernel documentation for them resides in
Documentation/sysctl/vm.txt.

CoW comes with some advantages, but can negatively affect performance
with large files that have small random writes. It is recommended to
disable CoW for database files and virtual machine images.

One can disable CoW for the entire block device by mounting it with
nodatacow option. However, this will disable CoW for the entire file
system.

Note:nodatacow will only affect newly created file. CoW may still happen
for existing file.

To disable CoW for single files/directories do:

    $ chattr +C /dir/file

Note:From chattr man page: For btrfs, the 'C' flag should be set on new
or empty files. If it is set on a file which already has data blocks, it
is undefined when the blocks assigned to the file will be fully stable.
If the 'C' flag is set on a directory, it will have no effect on the
directory, but new files created in that directory will have the No_COW
attribute.

Tip:In accordance with the note above, you can use the following trick
to disable CoW on existing files in a directory:

    $ mv /path/to/dir /path/to/dir_old
    $ mkdir /path/to/dir
    $ chattr +C /path/to/dir
    $ cp /path/to/dir_old/* /path/to/dir
    $ rm -rf /path/to/dir_old

Make sure that the data are not used during this process. Also note that
mv or cp --reflink as described below will not work.

Likewise, to save space by forcing CoW when copying files use:

    $ cp --reflink source dest 

As dest file is changed, only those blocks that are changed from source
will be written to the disk. One might consider aliasing aliasing cp to
cp --reflink=auto.

> Multi-device filesystem and RAID feature

Multi-device filesystem

When creating a btrfs filesystem, one can pass many partitions or disk
devices to mkfs.btrfs. The filesystem will be created across these
devices. One can "pool" this way, multiple partitions or devices to get
a big btrfs filesystem.

One can also add or remove device from an existing btrfs filesystem
(caution is mandatory).

A multi-device btrfs filesystem (also called a btrfs volume) is not
recognized until btrfs device scan has been run. This is the purpose of
the btrfs mkinitcpio hook.

RAID features

When creating multi-device filesystem, one can also specify to use
RAID0, RAID1, RAID10, RAID5 or RAID6 across the devices comprising the
filesystem. RAID levels can be applied independently to data and meta
data. By default, meta data is duplicated on single volumes or RAID1 on
multi-disk sets.

btrfs works in block-pairs for raid0, raid1, and raid10. This means:

raid0 - block-pair stripped across 2 devices

raid1 - block-pair written to 2 devices

For 2 disk sets, this matches raid levels as defined in md-raid (mdadm).
For 3+ disk-sets, the result is entirely different than md-raid.

For example:

-   Three 1TB disks in an md based raid1 yields a /dev/md0 with 1TB free
    space and the ability to safely lose 2 disks without losing data.
-   Three 1TB disks in a Btrfs volume with data=raid1 will allow the
    storage of approximately 1.5TB of data before reporting full. Only 1
    disk can safely be lost without losing data.

Btrfs uses a round-robin scheme to decide how block-pairs are spread
among disks. As of Linux 3.0, a quasi-round-robin scheme is used which
prefers larger disks when distributing block pairs. This allows raid0
and raid1 to take advantage of most (and sometimes all) space in a disk
set made of multiple disks. For example, a set consisting of a 1TB disk
and 2 500GB disks with data=raid1 will place a copy of every block on
the 1TB disk and alternate (round-robin) placing blocks on each of the
500GB disks. Full space utilization will be made. A set made from a 1TB
disk, a 750GB disk, and a 500GB disk will work the same, but the
filesystem will report full with 250GB unusable on the 750GB disk. To
always take advantage of the full space (even in the last example), use
data=single. (data=single is akin to JBOD defined by some raid
controllers) See the BTRFS FAQ for more info.

> Sub-volumes

See the following links for more details:

-   Btrfs Wiki SysadminGuide#Subvolumes
-   Btrfs Wiki Getting started#Basic Filessystem Commands
-   Btrfs Wiki Trees

Creating sub-volumes

To create a sub-volume:

    # btrfs subvolume create subvolume-name

Listing sub-volumes

To see a list of current sub-volumes:

    # btrfs subvolume list -p .

Setting a default sub-volume

Warning:Changing the default subvolume with btrfs subvolume default will
make the top level of the filesystem inaccessible, except by use of the
subvolid=0 mount option. Reference: Btrfs Wiki Sysadmin Guide.

The default sub-volume is mounted if no subvol= mount option is
provided.

    # btrfs subvolume set-default subvolume-id /.

> Example:

    # btrfs subvolume list .

    ID 258 gen 9512 top level 5 path root_subvolume
    ID 259 gen 9512 top level 258 path home
    ID 260 gen 9512 top level 258 path var
    ID 261 gen 9512 top level 258 path usr

    # btrfs subvolume set-default 258 .

> Reset:

    # btrfs subvolume set-default 0 .

Snapshots

See Btrfs Wiki SysadminGuide#Snapshots for details.

To create a snapshot:

    # btrfs subvolume snapshot source [dest/]name

Snapshots are not recursive. Every sub-volume inside sub-volume will be
an empty directory inside the snapshot.

Installing with root on btrfs subvolume

  ------------------------ ------------------------ ------------------------
  [Tango-go-next.png]      This article or section  [Tango-go-next.png]
                           is a candidate for       
                           moving to [[]].          
                           Notes: Does not fit into 
                           #Features section, maybe 
                           we should start new      
                           one... (Discuss)         
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Setting rootvol  
                           as the default subvolume 
                           (see #Setting a default  
                           sub-volume) would be     
                           much simpler, for both   
                           installation and         
                           booting. (Discuss)       
  ------------------------ ------------------------ ------------------------

Warning:When using legacy BIOS booting, syslinux is not capable of
booting from a btrfs subvolume with the following setup, one must always
use GRUB. (It is possible with a different, more complicated btrfs
subvolume setup, that is out of the scope of this section.)

For increased flexibility, install the system into a dedicated
sub-volume. Set up a btrfs filesystem as to your liking and mount it to
/mnt. The following mkfs command is given as an example.

    # mkfs.btrfs /dev/sda1 
    # mount /dev/sda1 /mnt

Create a subvolume for root, where rootvol is an arbitrary name. If you
wish, create additional subvolumes at this step, for example to
accommodate /home.

    # cd /mnt
    # btrfs subvolume create rootvol
    # cd /
    # umount /mnt

Mount the subvolume.

    # mount -o subvol=rootvol /dev/sda1 /mnt

From here continue the installation process from the pacstrap step, as
per the Installation guide or Beginners' guide.

Additional considerations:

-   In /etc/fstab, the mount option subvol="subvolume-name" has to be
    specified, and the fsck setting in the last field has to be 0.
-   In the kernel boot parameters, use: rootflags=subvol=subvolume-name.
    It is still necessary to add the standard root parameter with
    root=/dev/sda1.
-   It is advisable to add crc32c (or crc32c-intel for Intel machines)
    to the modules array in /etc/mkinitcpio.conf

Note:Child sub-volumes are automatically mounted by Btrfs when the
parent sub-volume is mounted.

> Defragmentation

Btrfs supports online defragmentation. To defragment the metadata of the
root folder do:

    # btrfs filesystem defragment /

This will not defragment the entire file system. For more information
read this page on the btrfs wiki.

To defragment the entire file system verbosely:

    # btrfs filesystem defragment -r -v /

Note:The command above will defragment only file data. To defragment
directory metadata for every directory in the file system, run this
command:

    # find / -xdev -type d -print -exec btrfs filesystem defragment '{}' \;

> Compression

Btrfs supports transparent compression, which means every file on the
partition is automatically compressed. This does not only reduce the
size of those files, but also improves performance, in particular if
using the lzo algorithm, in some specific use cases (e.g. single tread
with heavy file IO), while obviously harming performance on other cases
(e.g. multithreaded and/or cpu intensive tasks with large file IO).

Compression is enabled using the compress=zlib or compress=lzo mount
options. Only files created or modified after the mount option is added
will be compressed. However, it can be applied quite easily to existing
files (e.g. after a conversion from ext3/4) using the
btrfs filesystem defragment -calg command, where alg is either zlib or
lzo. In order to re-compress the whole file system with lzo, run the
following command:

    # btrfs filesystem defragment -r -v -clzo /

Tip:Compression can also be enabled per-file without using the compress
mount option; simply apply chattr +c to the file. When applied to
directories, it will cause new files to be automatically compressed as
they come.

When installing Arch to an empty Btrfs partition, set the compress
option after preparing the storage drive. Simply switch to another
terminal (Ctrl+Alt+number), and run the following command:

    # mount -o remount,compress=lzo /dev/sdXY /mnt/target

After the installation is finished, add compress=lzo to the mount
options of the root file system in fstab.

> Checkpoint interval

Starting with Linux 3.12, users are able to change the checkpoint
interval from the default 30 s to any value by appending the commit
mount option in /etc/fstab for the btrfs partition.

    LABEL=arch64 / btrfs defaults,noatime,ssd,compress=lzo,commit=120 0 0

> Partitioning

Btrfs can occupy an entire data storage device and replace the MBR or
GPT partitioning schemes. One can use subvolumes to simulate partitions.
There are some limitations to this approach in single disk setups:

-   Cannot use different file systems for different mount points.
-   Cannot use swap area as Btrfs does not support swap files and there
    is no place to create swap partition.
-   Cannot use UEFI to boot.

To overwrite the existing partition table with Btrfs, run the following
command:

    # mkfs.btrfs /dev/sdX

Do not specify /dev/sdaX or it will format an existing partition instead
of replacing the entire partitioning scheme.

Install the boot loader in a like fashion to installing it for a data
storage device with a Master Boot Record. For example:

    # grub-install --recheck /dev/sdX

for GRUB.

Warning:Using the btrfs filesystem set-default command to change the
default sub-volume from anything other than the top level (ID 0) may
break Grub. See Btrfs#Setting a default sub-volume to reset.

> Scrub

See Btrfs Wiki Glossary.

    # btrfs scrub start /
    # btrfs scrub status /

Warning:The running scrub process will prevent the system from
suspending, see this thread for details.

> Balance

See Btrfs Wiki Glossary.

Since btrfs-progs-3.12 balancing is a background process - see
man 8 btrfs for full description.

    # btrfs filesystem balance start /
    # btrfs filesystem balance status /

See also
--------

-   Official site
    -   Btrfs Wiki
    -   Btrfs Wiki Glossary
-   Official FAQs
    -   Btrfs Wiki FAQ
    -   Btrfs Wiki Problem FAQ
-   Btrfs pull requests
    -   3.14
    -   3.13
    -   3.12
    -   3.11
-   Performance related
    -   Btrfs on raw disks?
    -   Varying leafsize and nodesize in Btrfs
    -   Btrfs support for efficient SSD operation (data blocks
        alignment)
    -   Is Btrfs optimized for SSDs?
    -   Phoronix mount option benchmarking
        -   Linux 3.11
        -   Linux 3.9
        -   Linux 3.7
        -   Linux 3.2
    -   Lzo vs. zLib
-   Miscellaneous
    -   Funtoo Wiki Btrfs Fun
    -   Avi Miller presenting Btrfs at SCALE 10x, January 2012.
    -   Summary of Chris Mason's talk from LFCS 2012
    -   Btrfs: stop providing a bmap operation to avoid swapfile
        corruptions 2009-01-21

Retrieved from
"https://wiki.archlinux.org/index.php?title=Btrfs&oldid=306148"

Category:

-   File systems

-   This page was last modified on 20 March 2014, at 18:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
