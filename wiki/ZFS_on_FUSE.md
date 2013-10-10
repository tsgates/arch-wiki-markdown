ZFS on FUSE
===========

> Summary

This page provides basic guidelines for using ZFS from user space
through FUSE.

> Related

ZFS

Installing Arch Linux on ZFS

ZFS on FUSE/Linux is a project bringing the ZFS file system to Linux.
Due to incompatible license with GPL it is argued that it cannot exist
as a direct kernel module, however, this does not apply for
implementation as a FUSE file system.

Some of the capabilities of version 0.7.0 (as of Feb 2012) are limited
compared to original implementation (incomplete list):

-   sharenfs uses different syntax than on Solaris;
-   it is possible to create snapshots, however, they have to be cloned
    to another disk to actually be able to browse the file system (due
    to missing .zfs special directory).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Use                                                                |
|     -   2.1 Quick Setup Guide                                            |
|         -   2.1.1 Automatically mount pools and datasets on boot         |
|                                                                          |
|     -   2.2 NFS shares                                                   |
+--------------------------------------------------------------------------+

Installation
------------

ZFS on FUSE/Linux is available in AUR as "zfs-fuse" (0.7.0 as of Feb
2012). Install manually or with yaourt:

    $ yaourt -S zfs-fuse

Read the messages after installation and be sure to edit the
configuration files as per your needs.

Further, make sure that fuse module is loaded (as root):

    # modprobe fuse

Start zfs-fuse daemon:

    # rc.d start zfs-fuse

You will want to add "fuse" module to MODULES array in /etc/rc.conf and
the zfs-fuse to the DAEMONS array to have it started after reboot.

Use
---

> Quick Setup Guide

Search on Google how ZFS works. Be sure, which block device you specify
and better backup before continueing!

Briefly, you will want to create a pool (as root):

-   [Warning: Always try to use id names instead when working with ZFS,
    otherwise import errors will occur.]

    # zpool create mypool /dev/disk/by-id/<id-to-partition>

Alternatively:

    # zpool create mypool /dev/sdb

This will create a "pool" called "mypool" on physical block device
/dev/sdb (on whole disk, not on a single partition). Also, a first
dataset (aka zfs file system) with the same name will be created and
automatically mounted to /mypool.

You can create other datasets (file systems) within the pool. The reason
for doing so is to be able to set various properties on them, to be able
to create snapshots independently, etc.

    # zfs create mypool/my1stdataset 

NB that "mypool" is a reference to an existing pool, not to the mount
point (which is /mypool at the moment).

Automatically mount pools and datasets on boot

Pools and datasets can be mounted during boot by adding them to the
arrays in /etc/conf.d/zfs-fuse.

If you like to have all pools and all datasets mounted you can add a
"-a" in the array:

    ZFS_IMPORT=("-a")

If you like to have all datasets mounted add "-a" in that array as well:

    ZFS_MOUNT=("-a")

> NFS shares

ZFS can export datasets (file systems) as NFS without the need to place
the directories in /etc/exports.

The nfs-kernel daemon should be installed and started:

    # pacman -S nfs-utils
    # rc.d start nfs-kernel

Add the nfs-server to DAEMONS array in /etc/rc.conf well before the
nfs-fuse.

The syntax of setting the NFS share is:

    # zfs set sharenfs="host1:option1,option2,option3 host2:option1,...,optionN" dataset_name
    # zfs set sharenfs="192.168.1.1/24:ro 192.168.1.3:rw" mypool/my1stdataset

The exported shares and their options can be listed as follows:

    # cat /var/lib/nfs/etab

NB:

-   It does not work to use only "zfs set sharenfs=on
    mypool/my1stdataset" - it is not possible to mount such a share from
    other computers.

-   Only NFS version 3 seems to be supported for readonly (ro) shares
    (use "mount servername:/mypool/my1stdataset /mnt -o vers=3,defaults"
    to force that version)

-   It does not work to use "*" as shortcut for any host name. Use the
    actual IP address / mask of NFS clients list.

-   Running subsequent 'zfs set sharenfs="10.1.0.3:rw"
    mypool/my1stdataset' will add the extra host to the existing
    exports.

-   To remove existing exports, run "zfs set sharenfs=off
    mypool/my1stdataset".

-   To enable sharing after reboot, put "zfs share -a" to your
    /etc/rc.local".

-   It is possible to use also the regular way of exporting NFS shares
    via /etc/exports, however, do not set it up for the shares, which
    are exported by zfs directly!

Retrieved from
"https://wiki.archlinux.org/index.php?title=ZFS_on_FUSE&oldid=243689"

Category:

-   File systems
