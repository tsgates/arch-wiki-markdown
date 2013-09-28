Full System Backup with tar
===========================

This article will show you how to do a full system backup with tar.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Overview                                                           |
| -   2 Boot with LiveCD                                                   |
| -   3 Changing Root                                                      |
| -   4 Mount Other Partitions                                             |
| -   5 Exclude File                                                       |
| -   6 Backup Script                                                      |
+--------------------------------------------------------------------------+

Overview
--------

Backing up with tar has the advantages of using compression that can
help save disk space, and simplicity. The process only requires several
steps, they are:

1.  Boot from a LiveCD
2.  Change root to the Linux install
3.  Mount additional (if any) partitions/drives
4.  Add exclusions
5.  Use the backup script to backup

To minimize downtime the backup can alternatively be performed on a
running system using LVM snapshots, if all filesystems reside on LVM
volumes.

Boot with LiveCD
----------------

Many Linux bootable CDs, USBs... have the ability to let you change root
to your install. While changing root isn't necessary to do a backup, it
provides the ability to just run the script without need to transfer it
to a temporary drive or having to locate it on the filesystem. The Live
medium must be of the same architecture that your Linux install
currently is (i.e. i686 or x86_64).

Changing Root
-------------

First you should have a scripting environment set up on your current
Linux install. If you do not know what that is, it means that you are
able to execute any scripts that you may have as if they are regular
programs. If you do not, see this article on how to do that. What you'll
need to do next is change root, to learn more about what changing root
is, read this. When you change root, you do not need to mount any
temporary file systems (/proc, /sys, and /dev). These temporary file
systems get populated on boot and you actually do not want to backup
them up because they can interfere with the normal (and necessary)
population process which can change on any upgrade. To change root,
you'll need to mount your current Linux installs root partition. For
example:

    mkdir /mnt/arch
    mount /dev/<your-partition-or-drive>

Use fdisk -l to discover you partitions and drives. Now chroot:

    cd /mnt/arch
    chroot . /bin/bash

This example obviously uses bash but you can use other shells if
available. Now you will be in your scripted environment (this is
provided that you have your ~/.bashrc sourced on entry):

    cat ~/.bash_profile
    # If using bash, source the local .bashrc
    source ~/.bashrc

Mount Other Partitions
----------------------

Other partitions that you use (if any) will need to be mounted in their
proper places (e.g. if you have a separate /home partition).

Exclude File
------------

tar has the ability to ignore specified files and directories. The
syntax is one definition per line. tar also has the capability to
understand regular expressions (regexps). For example:

    # Not old backups                                                               
    /opt/backup/arch-full*                                                                   
                                                                                    
    # Not temporary files                                                           
    /tmp/*

    # Not the cache for pacman
    /var/cache/pacman/pkg/
    ...

Backup Script
-------------

Backing up with tar is straight-forward process. Here is a basic script
that can do it and provides a couple checks. You'll need to modify this
script to define your backup location, and exclude file (if you have
one), and then just run this command after you've chrooted and mounted
all your partitions.

    #!/bin/bash
    # full system backup

    # Backup destination
    backdest=/opt/backup

    # Labels for backup name
    #PC=${HOSTNAME}
    pc=pavilion
    distro=arch
    type=full
    date=$(date "+%F")
    backupfile="$backdest/$distro-$type-$date.tar.gz"

    # Exclude file location
    prog=${0##*/} # Program name from filename
    excdir="/home/<user>/.bin/root/backup"
    exclude_file="$excdir/$prog-exc.txt"

    # Check if chrooted prompt.
    echo -n "First chroot from a LiveCD.  Are you ready to backup? (y/n): "
    read executeback

    # Check if exclude file exists
    if [ ! -f $exclude_file ]; then
      echo -n "No exclude file exists, continue? (y/n): "
      read continue
      if [ $continue == "n" ]; then exit; fi
    fi

    if [ $executeback = "y" ]; then
      tar --exclude-from=$exclude_file -czpvf $backupfile /
    fi

Retrieved from
"https://wiki.archlinux.org/index.php?title=Full_System_Backup_with_tar&oldid=255380"

Category:

-   System recovery
