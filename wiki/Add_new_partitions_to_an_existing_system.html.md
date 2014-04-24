Add new partitions to an existing system
========================================

Related articles

-   Partitioning
-   Gparted

You may find yourself in the situation where you either want to create a
new partition to give yourself more flexibility (for example, for backup
operations), or you are forced to use new partition(s) because your
original is full and to free up space you need to move data from the
full partition to a new one.

As an easy alternative, you can always download a copy of another
operating system such as Ubuntu and boot into a live media version (Arch
USB Installation Media guide). Newer versions of Ubuntu include Gparted.

Warning:Be sure to at least read through all the steps in this guide
before making any real changes. There is always a risk for losing your
data when adjusting partitions.

Contents
--------

-   1 Preamble
-   2 Creating the New Partitions
    -   2.1 Extended Growth & Logical Partitioning
-   3 Moving Existing Data to the New Partition
-   4 Remounting the New Partitions on the Filesystem
    -   4.1 Manually remounting and checking
    -   4.2 Permanent remounting

Preamble
--------

Here are the steps involved with adding new partitions:

1.  Create new partitions.
2.  Mount the new partitions in a temporary location.
3.  Copy the existing files from old partition to the newly created
    partitions in their temporary locations.
4.  Delete the files under the original directories
5.  Move new partition from their temporary mount points to their
    permanent homes
6.  Update fstab accordingly.

Creating the New Partitions
---------------------------

Warning:Changing, Resizing and/or Creating partitions has the VERY REAL
potential to cause DATA LOSS Use common sense. BACKUP ANYTHING YOU DO
NOT WANT TO LOSE!

New partitions can be created either on previously unpartitioned
sections of an existing disk (or raid array in my case) or simply on an
additional newly installed drive.

You will need your filesystems to be UNMOUNTED when you make changes
such as adding new partitions to the free space on your disk or
shrinking partitions. Therefore you will need to boot into an
environment such as provided by the install CD in Rescue mode.

Command line utilities such as fdisk, cfdisk or sfdisk can be used, but
if you are unfamiliar with creating partitions and filesystems
Gparted-Live iso is recommended. It provides a nice gui and additional
checks to make sure what you are doing is okay. See also GParted for how
to use GParted.

> Extended Growth & Logical Partitioning

Partitions come in three main flavors: Primary, Extended and Logical. An
Extended partition is for the most part just a "wrapper" to contain
logical partitions.

If you have a typical Linux partition scheme, then you probably have a
single "extended" partition with "logical" partitions of '/', '/home'
and possibly a '/boot' partition. Your logical partitions will probably
completely fill the extended partition they reside in. Before you can
add additional partitions, you must grow the current extended partition
to make room for your new logical partitions, or you can create a new
extended partition. I prefer to grow the extended partition then add the
new logical partitions. I find no need for primary partitions unless
dual booting windows.

You will need to create a filesystem on the new partitions with 'mkfs -t
<fstype>' or you may select the desired filesystem when defining your
partition with Gparted. If you do not know which filesystem you are
using, then from the command line type "df -hT" and check the type
column.

Moving Existing Data to the New Partition
-----------------------------------------

To benefit from the extra space provided by the new partitions, the new
partitions need to be integrated into the filesystem.

Files should not be written to the parts of the filesystem you are
moving during this process. The safest way to accomplish the copy and
delete is to either boot from your install cd into rescue mode and
create mount points to hold your / filesystem and the new partitions, or
alternatively shutdown anything that could write to or read from the
existing directories. For example, for /var, syslog-ng needed to be
shutdown. If using dmraid, issue "dmraid -ay" to activate your raid sets
when booting from the install CD into rescue mode.

The basic process (as root) is:

Stop any processes that might write to the old directories.

    # /etc/rc.d/syslog-ng stop

Create temporary mount points for your new partitions.

    # mkdir /mnt/newtemp

Mount the new partitions on the temporary mount points.

    # mount /dev/sda5 /mnt/newtemp

Warning:Before doing this ensure that the system does not still need
read or write access to these folders

Copy the information from the old directories to the new partitions.

    # cp -a /olddir /mnt/newtemp

Confirm the information was written to the new partitions with ls, diff,
etc. When you are certain the information was written correctly to the
new partitions delete the information from the old directories.

    # rm -r /olddir

Remounting the New Partitions on the Filesystem
-----------------------------------------------

Next the new partition(s) should be unmounted from their temporary
location(s) and assigned their proper place in the filesystem.

> Manually remounting and checking

Unmount the new partitions from the temporary mount point

    umount /mnt/newtemp

Mount the new partitions as /newdir

    mount /dev/sda5 /newdir

Now the new partitions are in the proper location in the filesystem and
you can confirm the new room with df -h

> Permanent remounting

Finally make the new changes permanent by adding the new mount
configuration to /etc/fstab. As root edit /etc/fstab adding something
similar to the following corresponding to your own new partitions:

    /dev/sda5 /newdir ext3 defaults 0 2

(See the fstab article for more details.)

If you have disabled any running processes, restart or enable them,
check the files on your new partitions to insure all is well and check
the logs for any permission errors. Then reboot and make sure it all
works as expected.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Add_new_partitions_to_an_existing_system&oldid=291295"

Category:

-   File systems

-   This page was last modified on 2 January 2014, at 02:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
