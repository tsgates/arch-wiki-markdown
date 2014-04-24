fsck
====

Related articles

-   Ext4
-   Btrfs
-   fstab

fsck stands for "file system check" and it is used to check and
optionally repair one or more Linux file systems. Normally, the fsck
program will try to handle filesystems on different physical disk drives
in parallel to reduce the total amount of time needed to check all of
the filesystems (see: man fsck).

The Arch Linux boot process conveniently takes care of the fsck
procedure for you and will check all relevant partitions on your
drive(s) automatically on every boot. Hence, there is usually no need to
resort to the command-line unless necessary.

Contents
--------

-   1 Boot time checking
    -   1.1 Mechanism
    -   1.2 Forcing the check
-   2 Tips and tricks
    -   2.1 Attempt to repair damaged blocks
    -   2.2 Repair damaged blocks interactively
    -   2.3 Changing the check frequency
    -   2.4 fstab options
-   3 Troubleshooting
    -   3.1 Can't run fsck on a separate /usr partition
    -   3.2 ext2fs : no external journal

Boot time checking
------------------

> Mechanism

There are two players involved:

1.  mkinitcpio offers you the option to fsck your root device before
    mounting it via the fsck hook. If you do this, you should mount root
    read-write via the appropriate rw option on the kernel commandline.
2.  systemd will fsck all filesystems assuming three things are true:
    the filesystem has a fsck pass number greater than 0 (either from
    /etc/fstab or a user-supplied unit file), the filesystem is not
    already mounted read-write, and you've not elected to disable fsck
    entirely via the kernel commandline option fsck.mode=skip.

Note:Option 1 is the recommended default, and what you will end up with
if you follow the Installation Guide. If you want to go with option 2
instead, you should remove the fsck hook from mkinitcpio.conf and use ro
on the kernel commandline.

> Forcing the check

You can also force fsck at boot time by passing fsck.mode=force, as a
kernel parameter. This will check every filesystem you have on the
machine.

Tips and tricks
---------------

> Attempt to repair damaged blocks

To automatically repair damaged portions, run:

Warning:This will not ask if you want to repair it, as the answer is Yes
when you run it.

    # fsck -a

> Repair damaged blocks interactively

Tip:This is useful for when file on the boot partition have changed, and
the journal failed to properly update. In this case, unmount the boot
partition, and run the following code:

To repair damaged portions, run :

    # fsck -r <drive>

> Changing the check frequency

By default, fsck checks a filesystem every 30 boots (counted
individually for each partition). To change the frequency of checking,
run:

    # tune2fs -c 20 /dev/sda1

In this example, 20 is the number of boots between two checks.

Note that 1 would make it scan at every boot, while 0 would stop
scanning altogether.

Tip:If you wish to see the frequency number and the current mount count
for a specific partition, use:

    # dumpe2fs -h /dev/sda1 | grep -i 'mount count'

> fstab options

fstab is a system configuration file and is used to tell the Linux
kernel which partitions (file systems) to mount and where on the file
system tree.

A typical /etc/fstab entry may look like this:

    /dev/sda1   /         ext4      defaults       0  1
    /dev/sda2   /other    ext4      defaults       0  2
    /dev/sda3   /win      ntfs-3g   defaults       0  0

The 6th column (in bold) is the fsck option.

-   0 = Do not check.
-   1 = First file system (partition) to check; / (root partition)
    should be set to 1.
-   2 = All other filesystems to be checked.

Troubleshooting
---------------

> Can't run fsck on a separate /usr partition

1.  Make sure you have the required hooks in /etc/mkinitcpio.conf and
    that you remembered to re-generate your initramfs image after
    editing this file.
2.  Check your fstab! Only the root partition needs "1" at the end,
    everything else should have either "2" or "0". Carefully inspect it
    for other typos, as well.

> ext2fs : no external journal

There are times (due to power failure) in which an ext(3/4) file system
can corrupt beyond normal repair. Normally, there will be a prompt from
fsck indicating that it cannot find an external journal. In this case,
run the following commands:

    # umount <directory>;  ## unmount the partition based on its directory
    # tune2fs -j /dev/<partition>;  ## write a new journal to the partition
    # fsck -p /dev/<partition>;  ## run an fsck to repair the partition

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fsck&oldid=290872"

Category:

-   File systems

-   This page was last modified on 30 December 2013, at 08:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
