dm-crypt/Encrypting a Non-Root File System
==========================================

Back to dm-crypt

The following are examples of encrypting a secondary, i.e. non-root,
filesystem with dm-crypt.

Contents
--------

-   1 Overview
-   2 Partition
    -   2.1 Manual mounting and unmounting
    -   2.2 Automated unlocking and mounting
        -   2.2.1 Crypttab
        -   2.2.2 Pam mount
-   3 Loop device
    -   3.1 Manual mounting and unmounting
    -   3.2 Resizing the loopback filesystem

Overview
--------

Encrypting a secondary filesystem usually protects only sensitive data,
while leaving the operating system and program files unencrypted. This
is useful for encrypting an external medium, such as a USB drive, so
that it can be moved to different computers securely. One might also
choose to encrypt sets of data separately according to who has access to
it.

Because dm-crypt is a block-level encryption layer, it only encrypts
full devices, full partitions and loop devices. To encrypt individual
files requires a filesystem-level encryption layer, such as eCryptfs or
EncFS. See Disk Encryption for general information about securing
private data.

Partition
---------

This example covers the encryption of the /home partition, but it can be
applied to any other comparable non-root partition containing user data.

Tip:You can either have a single user's /home directory on a partition,
or create a common partition for all user's /home partitions.

First, prepare the partition by securely erasing it, see Dm-crypt/Drive
Preparation#Secure erasure of the hard disk drive.

Then setup the LUKS header with:

    # cryptsetup options luksFormat device

Replace device with the previously created partition. See
Dm-crypt/Device Encryption#Encryption options for LUKS mode for details
like the available options.

To gain access to the encrypted partition, unlock it with the device
mapper, using:

    # cryptsetup open device name

After unlocking the partition, it will be available at /dev/mapper/name.
Now create a file system of your choice with:

    # mkfs.fstype /dev/mapper/name

Mount the file system to /home, or if it should be accessible to only
one user to /home/username, see #Manual mounting and unmounting.

Tip:Unmount and mount once to verify that the mapping is working as
intended.

> Manual mounting and unmounting

To mount the partition:

    cryptsetup open --type luks device name
    mount -t ext2 /dev/mapper/name /mnt/home

To unmount it:

    umount /mnt/home
    cryptsetup luksClose name

> Automated unlocking and mounting

There are two different solutions for automating the process of
unlocking the partition and mounting its filesystem.

Crypttab

Using crypttab, unlocking happens at boot time: this is the recommended
solution if you want to use one common partition for all user's home
partitions (or another general mount).

To make systemd open and mount the encrypted partition on boot, two
files need to be edited, /etc/crypttab and /etc/fstab. The /etc/crypttab
file describes encrypted block devices that are set up during system
boot by systemd-cryptsetup-generator automatically.

For example, to open the encrypted LUKS partition on the device
/dev/sdx1 with the name home, add this line:

    /etc/crypttab

    home /dev/sdx1 none luks

The option none will trigger a prompt during boot to type the passphrase
for unlocking the partition. A keyfile can also be set up and referenced
instead. This results in an automatic unlocking, if the keyfile is
accessible during boot. Since LUKS offers the option to have multiple
keys, the chosen option can also be changed later.

See man crypttab (5) and read the file /etc/crypttab for more
information.

Edit /etc/fstab and add an entry for the previously created path in
/dev/mapper. Following above example the fstab entry looks like this:

    /etc/fstab

    /dev/mapper/home /home <filesystem> defaults 0 2

Pam mount

With Pam mount, unlocking happens on user login: this is the recommended
solution if you want to have a single user's home directory on a
partition.

See Pam mount.

Loop device
-----------

A loop device enables to map a blockdevice to a file with the standard
util-linux tool losetup. The file can then contain a filesystem, which
can be used quite like any other filesystem. A lot of users know
Truecrypt as a tool to create encrypted containers. Just about the same
functionality can be achieved with a loopback filesystem encrypted with
LUKS and is shown in the following example.

First, start by creating an encrypted container:

    dd if=/dev/urandom of=/bigsecret bs=1M count=10

This will create the file bigsecret with a size of 10 megabytes. Next
create the device node /dev/loop0, so that we can mount/use our
container:

    losetup /dev/loop0 /bigsecret

Note:If it gives you the error /dev/loop0: No such file or directory,
you need to first load the kernel module with modprobe loop. These days
(Kernel 3.2) loop devices are created on demand. Ask for a new loop
device with losetup -f.

From now on the procedure is the same as for #Partition, except for the
fact that the container is already randomised and will not need another
secure erasure.

Tip:Containers with dm-crypt can be very flexible. Have a look at the
features and documentation of Tomb. It provides a dm-crypt script
wrapper for fast and flexible handling.

> Manual mounting and unmounting

To unmount the container:

    umount /mnt/secret
    cryptsetup luksClose secret
    losetup -d /dev/loop0

To mount the container again:

    losetup /dev/loop0 /bigsecret
    cryptsetup open --type luks /dev/loop0 secret
    mount -t ext2 /dev/mapper/secret /mnt/secret

> Resizing the loopback filesystem

First unmount the encrypted container:

    umount /mnt/secret
    cryptsetup luksClose secret
    losetup -d /dev/loop0

After this expand the container file with the size of the data you want
to add:

    dd if=/dev/urandom bs=1M count=1024 | cat - >> /bigsecret

Warning:Be careful to really use two >, or you will override your
current container.

You could use /dev/zero instead of /dev/urandom to significantly speed
up the process, but with /dev/zero your encrypted filesystems will not
be as secure. See Random number generation for more alternatives. A
faster (almost instant) method than dd is truncate, but its use has the
same security implications as using /dev/zero. The size passed to
truncate is the final size to make the file, so do not use a value less
than that of the current file or you will lose data. E.g. to increase a
20G file by 10G run truncate -s 30G filename.

Now map the container to the loop device:

    losetup /dev/loop0 /bigsecret
    cryptsetup open --type luks /dev/loop0 secret

After this resize the encrypted part of the container to the maximum
size of the container file:

    cryptsetup resize secret

Finally, resize the filesystem. Here is an example for ext2/3/4 (check
the file system first as it's a bad idea to resize it if it is broken):

    e2fsck -f /dev/mapper/secret
    resize2fs /dev/mapper/secret

You can now mount your container again:

    mount /dev/mapper/secret /mnt/secret

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dm-crypt/Encrypting_a_Non-Root_File_System&oldid=302464"

Categories:

-   Security
-   File systems

-   This page was last modified on 28 February 2014, at 17:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
