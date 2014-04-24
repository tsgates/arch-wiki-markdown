tcplay
======

Related articles

-   Disk Encryption
-   TrueCrypt
-   Tomb

tcplay is a free (BSD-licensed), pretty much fully featured (including
multiple keyfiles, cipher cascades, etc.) and stable TrueCrypt
implementation.

Source: github project home

Contents
--------

-   1 Installation
-   2 Encrypting a file as a virtual volume
-   3 Mounting an existing container for a user
-   4 See also

Installation
------------

Install tcplay or tcplay-git from the AUR.

Encrypting a file as a virtual volume
-------------------------------------

Invoke

     $ losetup -f

to find the first unused loopback device; in this example, /dev/loop0.

Note:As of udev 181-5, the loop device module is no longer auto-loaded.

Create a new container foo.tc, 20M in size for instance, in the working
directory:

     # dd if=/dev/zero of=foo.tc bs=1 count=0 seek=20M
     # losetup /dev/loop0 foo.tc
     # tcplay -c -d /dev/loop0 -a whirlpool -b AES-256-XTS

Enter a secure password for the volume, and confirm the query to
overwrite foo.tc with the new volume. tcplay will then write random data
into the volume. Map the volume and create a filesystem on it in order
to mount

     # tcplay -m foo.tc -d /dev/loop0
     # mkfs.ext4 /dev/mapper/foo.tc
     # mount /dev/mapper/foo.tc /mnt/truecrypt/

To unset the container,

     # umount /mnt/truecrypt
     # dmsetup remove foo.tc
     # losetup -d /dev/loop0

Mounting an existing container for a user
-----------------------------------------

Consider /dev/loop0 the first unused loop device, foo.tc the TrueCrypt
container, /home/you/truecrypt/ the desired mount point. The user you in
this example has uid=1000 and gid=100. The steps for mounting the
container as a virtual volume are:

1.  Associate loop device with the container
2.  Map the container to the loop device
3.  Mount the container in the filesystem

The following commands perform the above actions.

     # losetup /dev/loop0 foo.tc
     # tcplay -m foo.tc -d /dev/loop0
     # mount -o nosuid,uid=1000,gid=100 /dev/mapper/foo.tc /home/you/truecrypt/

To reverse them:

     # umount /home/you/truecrypt/
     # dmsetup remove foo.tc
     # losetup -d /dev/loop0

See also
--------

-   Manual page for tcplay
-   Jason Ryan: Replacing TrueCrypt
-   TrueCrypt Homepage
-   HOWTO: Truecrypt Gentoo wiki
-   Truecrypt Tutorial on HowToForge
-   There is a good chance the CIA has a backdoor? (via wp)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tcplay&oldid=296528"

Categories:

-   Security
-   File systems

-   This page was last modified on 8 February 2014, at 02:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
