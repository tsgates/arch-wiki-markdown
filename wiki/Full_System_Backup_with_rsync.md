Full System Backup with rsync
=============================

Related articles

-   Backup Programs
-   rsync

This article is about using rsync to transfer a copy of your "/" tree,
excluding a few select folders. This approach is considered to be better
than disk cloning with dd since it allows for a different size,
partition table and filesystem to be used, and better than copying with
cp -a as well, because it allows greater control over file permissions,
attributes, Access Control Lists (ACLs) and extended attributes. [1]

Either method will work even while the system is running. Since it's
going to take a while, you may freely browse the web during this time.
Worst case scenario you won't get the same opened tabs when you restore
the backup (or boot from it) because they weren't saved. Not a big deal.

Contents
--------

-   1 With a single command
-   2 Using a script
-   3 Boot requirements
    -   3.1 Update the fstab
    -   3.2 Update the bootloader's configuration file
-   4 First boot
-   5 See also

With a single command
---------------------

As root, run:

    # rsync -aAXv /* /path/to/backup/folder --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found}

For information on why these folders were excluded, read the next
section.

Note:If you are heavy user of hardlinks, you might consider using
additionally -H rsync's option, which by default is turned off as memory
expensive during rsync run, but nowadays it should be no problem on most
of modern machines. There are a lot of hard links below the /usr folder
which save disk space.

Note:If you plan on backing up your system somewhere other than /mnt or
/media, don't forget to add it to the list, to avoid an infinite loop.
Also, if there are any bind mounts in the system they should be excluded
as well, as not to copy the bind mounted contents twice. The example
below is a good place to start and excludes all the necessary
directories that are typically common to all users of Arch Linux. Your
system may have additional areas which you may also want to exclude. Use
the mount command to list system mounts for additional insight on what
to exclude.

Note:You may want to add rsync's --delete option if you are running this
multiple times to the same backup folder

Using a script
--------------

Same as in the above method, the system files are transferred in archive
mode, ensuring that symbolic links, devices, permissions and ownerships,
among other file attributes are preserved, while excluding files that
match the patterns from the --exclude string. On top of that, it shows
at the end how much time it took, and it also writes a blank file
stating when the backup was created. To learn more about what this
script does, read man rsync and man date.

Note:Again, if you plan on backing up your system somewhere other than
/mnt or /media, don't forget to add it to the list, to avoid an infinite
loop.

Note:You may want to add rsync's --delete option if you are running this
multiple times to the same backup folder

    $ cd ~/Scripts
    $ nano backup.sh

    #!/bin/sh

    if [ $# -lt 1 ]; then 
        echo "No destination defined. Usage: $0 destination" >&2
        exit 1
    elif [ $# -gt 1 ]; then
        echo "Too many arguments. Usage: $0 destination" >&2
        exit 1
    elif [ ! -d "$1" ]; then
       echo "Invalid path: $1" >&2
       exit 1
    elif [ ! -w "$1" ]; then
       echo "Directory not writable: $1" >&2
       exit 1
    fi

    case "$1" in
      "/mnt") ;;
      "/mnt/"*) ;;
      "/media") ;;
      "/media/"*) ;;
      *) echo "Destination not allowed." >&2 
         exit 1 
         ;;
    esac

    START=$(date +%s)
    rsync -aAXv /* $1 --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/var/lib/pacman/sync/*}
    FINISH=$(date +%s)
    echo "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds" | tee $1/"Backup from $(date '+%A, %d %B %Y, %T')"

    $ chmod +x backup.sh

Note:The contents of /dev, /proc, /sys, /tmp, /run were excluded because
they are populated at boot (while the folders themselves are not
created), /lost+found is filesystem-specific. For Arch Linux,
/var/lib/pacman/sync/* can also be excluded. This can save a lot of time
on every backup since the directory contains many small files that tend
to change quite often. These are description files for every package
from the repositories and can be re-generated with pacman -Syu.Also
/var/log/journal/* may be skipped as it contains large number of systemd
logs. Additionally, you may also want to skip /home/*/.thumbnails/*,
/home/*/.mozilla/firefox/*.default/Cache/* and
/home/*/.cache/chromium/*.

Backing up is easy.

While the system is running, open up a terminal and run (as root):

    # /home/user/Scripts/backup.sh /some/destination

(replace user with username since you created the directory as user in
the user's home directory)

You can also replace both $1 instances from the script with the actual
destination path, move it to one of the folders from echo $PATH, and
then simply run (as root):

    # backup.sh

Boot requirements
-----------------

Having a bootable backup can be useful in case the filesystem becomes
corrupt or if an update breaks the system. The backup can also be used
as a test bed for updates, with the [testing] repo enabled, etc. If you
transferred the system to a different partition or drive and you want to
boot it, the process is as simple as updating the backup's /etc/fstab
and your bootloader's configuration file.

> Update the fstab

Without rebooting, edit the backup's fstab to reflect the changes:

    # nano /path/to/backup/etc/fstab

    tmpfs        /tmp          tmpfs     nodev,nosuid             0   0

    /dev/sda1    /boot         ext2      defaults                 0   2
    /dev/sda5    none          swap      defaults                 0   0
    /dev/sda6    /             ext4      defaults                 0   1
    /dev/sda7    /home         ext4      defaults                 0   2

Because rsync has performed a recursive copy of the entire root
filesystem, all of the sda mountpoints are problematic and booting the
backup will fail. In this example, all of the offending entries are
replaced with a single one:

    # nano /path/to/backup/etc/fstab

    tmpfs        /tmp          tmpfs     nodev,nosuid             0   0

    /dev/sdb1    /             ext4      defaults                 0   1

Remember to use the proper device name and filesystem type.

> Update the bootloader's configuration file

This section assumes that you backed up the system to another drive or
partition, that your current bootloader is working fine, and that you
want to boot from the backup as well.

For Syslinux, all you need to do is duplicate the current entry, except
pointing to a different drive or partition:

Tip:Instead of editing syslinux.cfg, you can also temporarily edit the
menu during boot. When the menu shows up, press the Tab key and change
the relevant entries. Partitions are counted from one, drives are
counted from zero.

    # nano /boot/syslinux/syslinux.cfg

For GRUB, it's recommended that you automatically re-generate the
grub.cfg file:

    # pacman -S os-prober
    # grub-mkconfig -o /boot/grub/grub.cfg

Also verify the new menu entry in /boot/grub/grub.cfg. Make sure the
UUID is matching the good partition, or else it could still boot on the
old system.

First boot
----------

Reboot the computer and select the right entry in the bootloader. This
will load the system for the first time. All peripherals should be
detected and the empty folders in / will be populated.

Now you can re-edit /etc/fstab to add the previously removed partitions
and mount points.

If you transferred the data from HDD to SSD (solid state drive), don't
forget to activate TRIM. Also consider using HDD and tmpfs mount points
to reduce SSD wearing - see Relocate files to tmpfs and Tips for
Minimizing SSD Read & Writes.

Note:You may have to reboot again in order to get all services and
daemons working correctly. Personally, pulseaudio would not initialise
because of a module loading error. I restarted the dbus.service to make
it work.

See also
--------

1.  Howto – local and remote snapshot backup using rsync with hard links
    Includes file deduplication with hard-links, MD5 integrity
    signature, 'chattr' protection, filter rules, disk quota, retention
    policy with exponential distribution (backups rotation while saving
    more recent backups than older)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Full_System_Backup_with_rsync&oldid=299518"

Category:

-   System recovery

-   This page was last modified on 21 February 2014, at 22:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
