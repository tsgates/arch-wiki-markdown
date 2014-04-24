dm-crypt/Drive Preparation
==========================

Back to Dm-crypt.

Before encrypting a drive, you should perform a secure erase of the disk
by overwriting the entire drive with random data. To prevent
cryptographic attacks or unwanted File Recovery, this data should be
completely indistinguishable from all data later written by dm-crypt.
See Disk_Encryption#Preparing_the_disk for a more comprehensive
discussion.

Contents
--------

-   1 Secure erasure of the hard disk drive
    -   1.1 Generic methods
    -   1.2 dm-crypt specific methods
        -   1.2.1 dm-crypt wipe before installation
        -   1.2.2 dm-crypt wipe free space after installation
        -   1.2.3 Wipe LUKS header
-   2 Partitioning
    -   2.1 Creating Disk Partitions
        -   2.1.1 Single Disk Systems
        -   2.1.2 Multiple Disk Systems
    -   2.2 LVM: Logical Volume Manager

Secure erasure of the hard disk drive
-------------------------------------

In deciding which method to use for secure erasure of a hard disk drive,
remember that this needs only to be performed once for as long as the
drive is used as an encrypted drive.

Warning:Make appropriate backups of valuable data prior to starting.

Tip:The process of filling an encrypted drive can take over a day to
complete on a multi-terabyte disk. It is therefore suggested to do it
from another installation rather than the Arch installation media.

> Generic methods

For detailed instructions on how to erase and prepare a drive consult
Securely wipe disk.

> dm-crypt specific methods

The following methods are specific for dm-crypt and are mentioned
complementarily, because they are very fast and can be performed after a
partition setup too.

The cryptsetup FAQ mentions a very simple procedure to use an existing
dm-crypt-volume to wipe all free space accessible on the underlying
block device with random data by acting as a simple pseudorandom number
generator. It is also claimed to protect against disclosure of usage
patterns.

dm-crypt wipe before installation

First, create a temporary encrypted container on the partition (sdXY) or
the full disk (sdX) you want to encrypt, e.g. using default parameters

    # cryptsetup open --type plain /dev/sdXY container

Second, check it exists

    # fdisk -l

    Disk /dev/mapper/container: 1000 MB, 1000277504 bytes
    ...
    Disk /dev/mapper/container does not contain a valid partition table

Finally, wipe it with pseudorandom (encrypted data), a use of
/dev/urandom is not required as the encryption cipher is used for
randomness:

    # dd if=/dev/zero of=/dev/mapper/container

    dd: writing to ‘/dev/mapper/container’: No space left on device

Now the next step is #Partitioning.

dm-crypt wipe free space after installation

The same effect can be achieved if a file is created on an encrypted
partition that fills the free space of the partition completely after
the system is installed, booted and filesystems mounted. That is because
encrypted data is practically indistinguishable from random.

    # dd if=/dev/zero of=/file/in/container
    # rm /file/in/container

The above process has to be repeated for every partition blockdevice
created.

Wipe LUKS header

The partitions formatted with dm-crypt/LUKS contain a header with the
cipher and crypt-options used, which is referred to dm-mod when opening
the blockdevice. After the header the actual random data partition
starts. Hence, when re-installing on an already randomised drive, or
de-commissioning one (e.g. sale of PC, switch of drives, etc.) it may be
just enough to wipe the header of the partition, rather than overwriting
the whole drive - which can be a lengthy process.

Wiping the LUKS header will delete the PBKDF2-encrypted (AES) master
key, salts and so on.

Note:It is crucial to write to the LUKS encrypted partition (/dev/sda1
in this example) and not directly to the disks device node. If you did
set up encryption as a device-mapper layer on top of others, e.g. LVM on
LUKS on RAID then write to RAID respectively.

A header with one single default 256 bit size keyslot is 1024KB in size.
It is advised to also overwrite the first 4KB written by dm-crypt, so
1028KB have to be wiped. That is 1052672 Byte.

For zero offset use:

    #head -c 1052672 /dev/zero > /dev/sda1; sync

For 512 bit key length (e.g. for aes-xts-plain with 512 bit key) the
header is 2MB.

If in doubt, just be generous and overwrite the first 10MB or so.

    #dd if=/dev/zero of=/dev/sda1 bs=512 count=20480

Note:With a backup-copy of the header data can get rescued but the
filesystem was likely damaged as the first encrypted sectors were
overwritten. See further sections on how to make a backup of the crucial
header blocks.

When wiping the header with random data everything left on the device is
encrypted data. An exception to this may occur for an SSD, because of
cache blocks SSDs employ. In theory it may happen that the header was
cached in these some time before and that copy may consequently be still
available after wiping the original header. For strong security
concerns, a secure ATA erase of the SSD should be done (procedure please
see the cryptsetup FAQ 5.19).

Partitioning
------------

After the drive has been securely overwritten, it is time to create
partitions and begin setting up an encrypted system.

There are multiple ways to create disk partitions:

-   Standard partitions
-   LVM
-   RAID

LUKS can be used with systems that require LVM and/or RAID and is
compatible with all regular partitioning standards in Linux.

> Creating Disk Partitions

There are two required partitions for a basic encrypted system setup:

 root file system
    / Will be encrypted and store all system and user files (/usr, /bin,
    /var, /home, etc.)

 initial boot partition
    /boot Will not be encrypted; the bootloader needs to access the
    /boot directory where it will load the initramfs/encryption modules
    needed to load the rest of the system which is encrypted (see
    Mkinitcpio for details). For this reason, /boot needs to reside on
    its own, unencrypted partition.

This partition layout is encrypted in these examples and can be refined
according to needs, e.g. by separating partitions or adding an encrypted
swap-partition.

Single Disk Systems

If there are additional partitions desired, these can be individually
created by defining separate primary or extended/logical partitions. It
is possible to encrypt separate partitions (e.g. /home, /var) while
leaving others (e.g. /usr) unencrypted as required. However, a standard
install would also require separate passphrases or keys to open each
encrypted partition during boot.

Multiple Disk Systems

In systems with multiple hard disk drives, the same options exist as a
single disk system. After the creation of the /boot partition, the
remaining free space on the physical disks can be divided up into their
respective partitions at this level. For encrypted partitions that span
multiple disks, LUKS must be used with RAID or LVM.

> LVM: Logical Volume Manager

The LVM allows for systems that require complex hard disk
configurations. Knowledge of using LVM is a requisite to continue with
setting up LUKS with LVM.

Tip:Btrfs has a built-in Subvolume-Feature that fully replaces the need
for LVM if no other filesystems are required. An encrypted swap is not
possible this way and swap files are not supported by btrfs up to now.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dm-crypt/Drive_Preparation&oldid=296781"

Categories:

-   Security
-   File systems

-   This page was last modified on 10 February 2014, at 21:03.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
