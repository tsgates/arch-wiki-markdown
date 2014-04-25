Ext3
====

There are many strengths to the Third Extended ("ext3") filesystem. Its
in-kernel and userspace code has been tried, tested, fixed, and improved
upon more than almost every other Linux-compatible filesystem. It is
simple, robust, and extensible. This article explains some tips that can
improve both the performance and the reliability of the filesystem.

In this document /dev/hdXY will be used as a generic partition. You
should replace this with the actual device node for your partition, such
as /dev/hdb1 for the first partition of the primary slave disk or
/dev/sda2 for the second partition of your first SCSI or Serial ATA
disk.

Contents
--------

-   1 Using tune2fs and e2fsck
-   2 Using directory indexing
-   3 Enable full journaling
-   4 Disable lengthy boot time checks
-   5 Reclaim reserved filesystem space
-   6 Assigning a label
-   7 User experiences

Using tune2fs and e2fsck
------------------------

Before we begin, we need to make sure you are comfortable with using the
tune2fs utility to alter the filesystem options of an ext2 or ext3
partition (or convert ext2 to ext3). Please read the tune2fs man page.

It's generally a good idea to run a filesystem check using the e2fsck
utility after you've completed the alterations you wish to make on your
filesystem. This will verify that your filesystem is clean and fix it if
needed. You should also read the manual page for the e2fsck utility if
you have not yet done so.

Warning:Only run unmounted! Make sure any filesystems are cleanly
unmounted before altering them with the tune2fs or e2fsck utilities!
Altering or tuning a filesystem while it is mounted can cause severe
corruption! Consider booting from a LiveCD such as Parted Magic or the
Arch Linux one.

Using directory indexing
------------------------

This feature improves file access in large directories or directories
containing many files by using hashed binary trees to store the
directory information. It's perfectly safe to use, and it provides a
fairly substantial improvement in most cases; so it's a good idea to
enable it:

    # tune2fs -O dir_index /dev/hdXY

This will only take effect with directories created on that filesystem
after tune2fs is run. In order to apply this to currently existing
directories, we must run the e2fsck utility to optimize and reindex the
directories on the filesystem:

    # e2fsck -D -f /dev/hdXY

> Note:

-   This should work with ext2, ext3 and ext4 filesystems. Depending on
    the size of your filesystem, this could take a long time.
-   Directory indexing is activated by default in Arch Linux via
    /etc/mke2fs.conf.

Enable full journaling
----------------------

Warning:ext4 partitions will not mount if both delayed allocation and
full journaling (e.g. journal=data) are enabled.

By default, ext3 partitions mount with the 'ordered' data mode. In this
mode, all data is written to the main filesystem and its metadata is
committed to the journal, whose blocks are logically grouped into
transactions to decrease disk I/O. This tends to be a good default for
most people. However, I've found a method that increases both
reliability and performance (in some situations): journaling everything,
including the file data itself (known as 'journal' data mode). Normally,
one would think that journaling all data would decrease performance,
because the data is written to disk twice: once to the journal then
later committed to the main filesystem, but this does not seem to be the
case. I've enabled it on all nine of my partitions and have only seen a
minor performance loss in deleting large files. In fact, doing this can
actually improve performance on a filesystem where much reading and
writing is to be done simultaneously. See this article written by Daniel
Robbins on IBM's website for more information.

There are two different ways to activate journal data mode. The first is
by adding data=journal as a mount option in /etc/fstab. If you do it
this way and want your root filesystem to also use it, you should also
pass rootflags=data=journal as a kernel parameter in your bootloader's
configuration. In the second method, you will use tune2fs to modify the
default mount options in the filesystem's superblock:

    # tune2fs -O has_journal -o journal_data /dev/hdXY

Please note that the second method may not work for older kernels.
Especially Linux 2.4.20 and below will likely disregard the default
mount options on the superblock. If you're feeling adventurous you may
also want to tweak the journal size. (I've left the journal size at the
default.) A larger journal may give you better performance (at the cost
of more disk space and longer recovery times). Please be sure to read
the relevant section of the tune2fs manual before doing so:

    # tune2fs -J size=$SIZE /dev/hdXY

Disable lengthy boot time checks
--------------------------------

Warning:Only do this on a journaling filesystem such as ext3. This may
or may not work on other journaling filesystems such as ReiserFS or XFS,
but has not been tested. Doing so may damage or otherwise corrupt other
filesystems. You do this at your own risk.

It seems that our ext3 filesystems are still being checked every 30
mounts or so. This is a good default for many because it helps prevent
filesystem corruption when you have hardware issues, such as bad
IDE/SATA/SCSI cabling, power supply failures, etc. One of the driving
forces for creating journaling filesystems was that the filesystem could
easily be returned to a consistent state by recovering and replaying the
needed journaled transactions. Therefore, we can safely disable these
mount-count- and time-dependent checks if we are certain the filesystem
will be quickly checked to recover the journal if needed to restore
filesystem and data consistency. Before you do this please make sure
your filesystem entry in /etc/fstab has a positive integer in its 6th
field (pass) so that it is checked at boot time automatically. You may
do so using the following command:

    # tune2fs -c 0 -i 0 /dev/hdXY

If you just want to limit the checks to happen less often without
totally disabling them (for peace of mind). A great method is to change
from a number of count's check to a time frame check. See the man page.
Here is once every month:

    # tune2fs -c 0 -i 1m /dev/hdXY

Reclaim reserved filesystem space
---------------------------------

Ext3 partition contain a used space of 5% for special reasons by
default. The main reason is to help with less fragmentation on the
filesystem. The other reason for such space is so root can log in even
when the filesystem becomes 100% used. Without this option, the root
user might not be able to log in to "clean up" because the system could
become unstable, trying to write logs to a 100% full system for example.

The issue with this is that hard drives are getting so big the 5% can
add up to be quite a large amount of wasted space. (eg. 100 GB = 5 GB
reserved). Now if you separate your filesystems to like /home for
example it might be a good idea to adjust these and reclaim that wasted
space on long-term archive partitions (see this email for more info).
It's a safe bet to leave your / filesystem at 5% reserved just in case.
Leave reserved space for filesystems containing /var and /tmp also or
else you'll end up with problems.

Now to change your reserved space to 1% of the drive, which is fair for
non-root filesystems.

    # tune2fs -m 1 /dev/sdXY

Assigning a label
-----------------

Once you have created and formated a partition, you can assign it a
label using the e2label command. This allows you to add the partition to
/etc/fstab using a label instead of using a device path (usefull for an
USB drive). To add a label to a partition, type the following command as
root:

    # e2label /dev/sdXY new-label

If the optional argument new-label is not present, e2label will simply
display the current filesystem label. If the optional argument new-label
is present, then e2label will set the filesystem label to be new-labelq.
Ext2 and ext3 filesystem labels can be at most 16 characters long; if
new-label is longer than 16 characters, e2label will truncate it and
print a warning message.

User experiences
----------------

I never had problems with these tips on large (>750) filesystems.
Disabling lengthy boot-time works fine as well.

I get filesystem errors even with this tips. Do not disable lengthy boot
time checks.

If you have some big partitions, do not enable full journaling on them.
I experienced reproducible freezes (about 30 seconds) when enabling this
on my 250GB home partition.

Did you try tweaking bdflush as described by Daniel Robbins?

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ext3&oldid=286424"

Category:

-   File systems

-   This page was last modified on 5 December 2013, at 21:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
