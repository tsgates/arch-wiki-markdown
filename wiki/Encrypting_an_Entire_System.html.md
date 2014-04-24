dm-crypt/Encrypting an Entire System
====================================

Back to dm-crypt.

The following are examples of common scenarios of full system encryption
with dm-crypt. They explain all the adaptations that need to be done to
the normal installation procedure. All the necessary tools are on the
installation image.

Contents
--------

-   1 Overview
-   2 Simple partition layout with LUKS
    -   2.1 Preparing the disk
    -   2.2 Preparing non-boot partitions
    -   2.3 Preparing the boot partition
    -   2.4 Mounting the devices
    -   2.5 Configuring mkinitcpio
    -   2.6 Configuring the boot loader
-   3 LVM on LUKS
    -   3.1 Preparing the disk
    -   3.2 Preparing the logical volumes
    -   3.3 Preparing the boot partition
    -   3.4 Configuring mkinitcpio
    -   3.5 Configuring the boot loader
    -   3.6 Checking fstab
-   4 LUKS on LVM
    -   4.1 Preparing the disk
    -   4.2 Preparing the logical volumes
    -   4.3 Preparing the boot partition
    -   4.4 Configuring mkinitcpio
    -   4.5 Configuring the boot loader
    -   4.6 Configuring fstab and crypttab
    -   4.7 Encrypting /home after reboot
    -   4.8 Expanding LVM on multiple disks
        -   4.8.1 Adding a new drive
        -   4.8.2 Extending the logical volume
    -   4.9 Troubleshooting
        -   4.9.1 The system does not boot
-   5 LUKS on software RAID
-   6 Plain dm-crypt
    -   6.1 Preparing the disk
    -   6.2 Preparing the non-boot partitions
    -   6.3 Preparing the boot partition
    -   6.4 Configuring mkinitcpio
    -   6.5 Configuring the boot loader
    -   6.6 Post-installation

Overview
--------

Securing a root filesystem is where dm-crypt excels, feature and
performance-wise. When a system's root filesystem is on a dm-crypt
device, nearly every file on the system is encrypted. Unlike selectively
encrypting non-root filesystems, an encrypted root filesystem can
conceal information such as which programs are installed, the usernames
of all user accounts, and common data-leakage vectors such as mlocate
and /var/log/. Furthermore, an encrypted root filesystem makes tampering
with the system far more difficult, as everything except the boot loader
and kernel is encrypted.

All scenarios illustrated in the following share these advantages, other
pros and cons differentiating them are summarized below:

+--------------------------+--------------------------+--------------------------+
| Scenarios                | Advantages               | Disadvantages            |
+==========================+==========================+==========================+
| #Simple partition layout | -   Simple partitioning  | -   Inflexible;          |
| with LUKS                |     and setup            |     disk-space to be     |
| shows a basic and        |                          |     encrypted has to be  |
| straight-forward set-up  |                          |     pre-allocated        |
| for a fully LUKS         |                          |                          |
| encrypted root.          |                          |                          |
+--------------------------+--------------------------+--------------------------+
| #LVM on LUKS             | -   Simple partitioning  | -   LVM adds an          |
| achieves partitioning    |     with knowledge of    |     additional mapping   |
| flexiblity by using LVM  |     LVM                  |     layer and hook       |
| inside a single LUKS     | -   Only one key         | -   Less useful, if a    |
| encrypted partition.     |     required to unlock   |     singular volume      |
|                          |     all volumes (e.g.    |     should receive a     |
|                          |     easy                 |     separate key         |
|                          |     resume-from-disk     |                          |
|                          |     setup)               |                          |
|                          | -   Volume layout not    |                          |
|                          |     transparent when     |                          |
|                          |     locked               |                          |
+--------------------------+--------------------------+--------------------------+
| #LUKS on LVM             | -   LVM can be used to   | -   Complex; changing    |
| uses dm-crypt only after |     have encrypted       |     volumes requires     |
| the LVM is setup.        |     volumes span         |     changing encryption  |
|                          |     multiple disks       |     mappers too          |
|                          | -   Easy mix of          | -   Volumes require      |
|                          |     un-/encrypted volume |     individual keys      |
|                          |     groups               | -   LVM layout is        |
|                          |                          |     transparent when     |
|                          |                          |     locked               |
+--------------------------+--------------------------+--------------------------+
| #Plain dm-crypt          | -   Data resilience for  | -   High care to all     |
| uses dm-crypt plain      |     cases where a LUKS   |     encryption           |
| mode, i.e. without a     |     header may be        |     parameters is        |
| LUKS header and its      |     damaged              |     required             |
| options for multiple     | -   Allows deniable      | -   Single encryption    |
| keys.                    |     encryption           |     key and no option to |
| This scenario also       |                          |     change it            |
| employs USB devices for  |                          |                          |
| /boot and key storage,   |                          |                          |
| which may be applied to  |                          |                          |
| the other scenarios.     |                          |                          |
+--------------------------+--------------------------+--------------------------+

While all above scenarios provide much greater protection from outside
threats than encrypted secondary filesystems, they also share a common
disadvantage: any user in possession of the encryption key is able to
decrypt the entire drive, and therefore can access other users' data. If
that is of concern, it is possible to use a combination of blockdevice
and stacked filesystem encryption and reap the advantages of both. See
Disk Encryption to plan ahead.

Simple partition layout with LUKS
---------------------------------

This example covers a full system encryption with dmcrypt+ LUKS in a
simple partition layout:

    +--------------------+--------------------------+--------------------------+
    |Boot partition      |LUKS encrypted system     |Optional free space       |
    |                    |partition                 |for additional partitions |
    |/dev/sdaY           |/dev/sdaX                 |or swap to be setup later |
    +--------------------+--------------------------+--------------------------+

The first steps can be performed directly after booting the Arch Linux
install image.

> Preparing the disk

Prior to creating any partitions, securely erase the disk as described
in Dm-crypt/Drive Preparation#Secure erasure of the hard disk drive.

Then create the needed partitions, at least one for / (e.g. /dev/sdaX)
and /boot (/dev/sdaY), see Partitioning.

> Preparing non-boot partitions

Then follow the same procedure described in details in
Dm-crypt/Encrypting a non-root file system#Partition (which, despite the
title, can be applied to root partitions, as long as mkinitcpio and the
boot loader are then correctly configured). If you want to use special
encryption options (e.g. cipher, key length), see the encryption options
before executing the first command:

    # cryptsetup -y -v luksFormat /dev/sdaX
    # cryptsetup open /dev/sdaX cryptroot
    # mkfs -t ext4 /dev/mapper/cryptroot
    # mount -t ext4 /dev/mapper/cryptroot /mnt

Check the mapping works as intended:

    # umount /mnt
    # cryptsetup close cryptroot
    # cryptsetup open /dev/sdaX cryptroot
    # mount -t ext4 /dev/mapper/cryptroot /mnt

If you created separate partitions (e.g. /home), these steps have to be
adapted and repeated for all of them, except for /boot.

See
Dm-crypt_with_LUKS/Encrypting_a_non-root_file_system#Automated_unlocking_and_mounting
for automated unlocking and mounting of additional partitions at boot.

Note that each blockdevice requires its own passphrase. This may be
inconvenient, because it results in a separate passphrase to be input
during boot. An alternative is to use a keyfile stored in the system
partition to unlock the separate partition via crypttab. See
Dm-crypt/Device Encryption#Using LUKS to Format Partitions_with a
Keyfile for instructions.

> Preparing the boot partition

What you do have to setup is a non-encrypted /boot partition, which is
needed for a crypted root. For a standard MBR/non-EFI /boot partition,
for example, execute:

    # mkfs -t ext4 /dev/sdaY
    # mkdir /mnt/boot
    # mount -t ext4 /dev/sdaY /mnt/boot

> Mounting the devices

At Installation guide#Mount the partitions you will have to mount the
mapped devices, not the actual partitions. Of course /boot, which is not
encrypted, will still have to be mounted directly.

> Configuring mkinitcpio

Add the encrypt hook to mkinitcpio.conf before filesystems:

    etc/mkinitcpio.conf

    HOOKS="... encrypt ... filesystems ..."

See dm-crypt/System Configuration#mkinitcpio for details and other hooks
that you may need.

> Configuring the boot loader

In order to boot the encrypted root partition, the following kernel
parameter needs to be set in your boot loader:

    cryptdevice=/dev/sdaX:cryptroot

See Dm-crypt/System Configuration#Boot loader for details and other
parameters that you may need.

LVM on LUKS
-----------

The straight-forward method is to set up LVM on top of the encrypted
partition instead of the other way round. Technically the LVM is setup
inside one big encrypted blockdevice. Hence, the LVM is not transparent
until the blockdevice is unlocked and the underlying volume structure is
scanned and mounted during boot.

This method will not allow you to span the logical volumes over multiple
disk, even in the future. For a solution that allows to do so, see #LUKS
on LVM.

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: The intro of     
                           this scenario needs some 
                           adjustment now that a    
                           comparison has been      
                           added to #Overview. A    
                           suggested structure is   
                           to make it similar to    
                           the                      
                           #Simple_partition_layout 
                           _with_LUKS               
                           intro. (Discuss)         
  ------------------------ ------------------------ ------------------------

> Preparing the disk

Prior to creating any partitions, securely erase the disk as described
in Dm-crypt/Drive Preparation#Secure erasure of the hard disk drive (the
necessary tools are on the installation ISO).

Then make the following partitions:

-   sdx1 - Size 2MB, Partition Type EF02 (This is so GRUB plays nice
    with GPT)
-   sdx2 - Size 200mb, Partition Type 8300 (This is your /boot
    partition)
-   sdx3 - Remaining space, Partition Type 8E00 (LVM)

After that, create the LUKS encrypted container (sdx3. We do not encrypt
/boot or the BIOS partition)

    # cryptsetup luksFormat /dev/sdx3

NOTE: cryptsetup has a TON of options (which you can find in its man
page). The defaults now are quite secure (aes-xts-plain64 with 256bit
keysize results in a 128 bit AES encryption for the data), but you may
change whatever settings you like here. A description of the options you
find in the LUKS page too. Enter your password twice.

Now we open our container:

    # cryptsetup open --type luks /dev/sdx3 lvm

Your decrypted disk is now available at /dev/mapper/lvm

> Preparing the logical volumes

    # pvcreate /dev/mapper/lvm
    # vgcreate MyStorage /dev/mapper/lvm
    # lvcreate -L 15G MyStorage -n rootvol
    # lvcreate -L 35G MyStorage -n homevol
    # lvcreate -L 2G MyStorage -n swapvol
    # lvcreate -L 200G MyStorage -n mediavol

    # mkfs.ext4 /dev/mapper/MyStorage-rootvol
    # mkfs.ext4 /dev/mapper/MyStorage-homevvol
    # mkswap /dev/mapper/MyStorage-swapvol
    # mkfs.ext4 /dev/mapper/MyStorage-mediavol

    # mount /dev/MyStorage/rootvol /mnt
    # mkdir /mnt/home
    # mount /dev/MyStorage/homevol /mnt/home
    # swapon /dev/mapper/MyStorage-swapvol

     _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
    |Logical volume1 15GB  |Logical volume2 35GB      |Logical volume3 200GB               |
    |/dev/MyStorage/rootvol|/dev/MyStorage/homevol    |/dev/MyStorage/mediavol             |
    |_ _ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ |
    |                                                                                      |
    |                        (LUKS Encrypted Disk  /dev/sdxx)                              |
    |                                                                                      |
    |--------------------------------------------------------------------------------------|

> Preparing the boot partition

In most setups, a dedicated /boot partition is not necessary, but it is
in a complex setup like this one, because GRUB needs to be able to read
the kernel, initramfs, its own configuration files, etc. from the /boot
directory. Since GRUB does not itself know how to unlock a LUKS
partition (that's the kernel's job), /boot must not be encrypted, and
therefore must be a separate disk partition.

Create an ext2 filesystem on the partition you created for /boot earlier
(/dev/sdx2 in the example above).

    # mkfs -t ext2 /dev/sdx2

Mount this partition under the /boot partition of the installed system.
If you skip this step (or if you mount /mnt after /mnt/boot), GRUB's
installation scripts will be writing to the root partition's /boot
directory, which will be encrypted and thus unreadable by GRUB at the
next reboot. Note: you may wish to delete the /boot/* directory contents
from /dev/sdx3 (root partition) to make it obvious that /boot is not
mounted, in case you need to make changes in the future.

    # mount /dev/sdx2 /mnt/boot #if you are outside the chroot, OR
    # mount /dev/sdx2 /boot     #if you are inside the chroot

Now continue through the Arch setup. (Pacstrap, arch-chroot /mnt, and so
on. This HOWTO will assume you are also installing grub-bios to GPT as
per the install guide.)

> Configuring mkinitcpio

Add the encrypt and lvm2 hooks to mkinitcpio.conf, before filesystems:

    etc/mkinitcpio.conf

    HOOKS="... encrypt lvm2 ... filesystems ..."

Note:In the past, it was necessary to ensure the correct ordering of the
encrypt and lvm2 hooks, but the order no longer matters with the current
implementation of lvm2.

See dm-crypt/System Configuration#mkinitcpio for details and other hooks
that you may need.

> Configuring the boot loader

In order to boot the encrypted root partition, the following kernel
parameter needs to be set in your boot loader:

    cryptdevice=/dev/sdx3:MyStorage

See Dm-crypt/System Configuration#Boot loader for details and other
parameters that you may need.

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Is the following 
                           note specific to         
                           encryption cases or      
                           should be moved to LVM   
                           or GRUB? (Discuss)       
  ------------------------ ------------------------ ------------------------

Note:When reinstalling GRUB, you may receive warnings like
/run/lvm/lvmetad.socket: connect failed: No such file or directory or
WARNING: failed to connect to lvmetad: No such file or directory. Falling back to internal scanning.
This is because /run is not available inside the chroot. These warnings
will not prevent the system from booting, provided that everything has
been done correctly, so you may continue with the installation.

> Checking fstab

"genfstab -p /mnt >> /mnt/etc/fstab" will make the proper entry in
fstab, so that no further manual intervention is needed and the /boot
partition is automatically mounted when the system starts.

LUKS on LVM
-----------

To use encryption on top of LVM, the LVM volumes are set up first and
then used as the base for the encrypted partitions. This way, a mixture
of encrypted and non-encrypted volumes/partitions is possible as well.
Unlike #LVM on LUKS, this method allows normally spanning the logical
volumes over multiple disks.

The following short example creates a LUKS on LVM setup and mixes in the
use of a key-file for the /home partition and temporary crypt volumes
for /tmp and /swap. The latter is considered desirable from a security
perspective, because no potentially sensitive temporary data survives
the reboot, when the encryption is re-initialised. If you are
experienced with LVM, you will be able to ignore/replace LVM and other
specifics according to your plan.

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: The intro of     
                           this scenario needs some 
                           adjustment now that a    
                           comparison has been      
                           added to #Overview. A    
                           suggested structure is   
                           to make it similar to    
                           the                      
                           #Simple_partition_layout 
                           _with_LUKS               
                           intro. (Discuss)         
  ------------------------ ------------------------ ------------------------

> Preparing the disk

Partitioning scheme:

-   /dev/sda1 -> /boot
-   /dev/sda2 -> LVM

Randomise /dev/sda2:

    cryptsetup -d /dev/random -c aes-xts-plain64 -s 512 create lvm /dev/sda2
    dd if=/dev/urandom of=/dev/mapper/lvm
    cryptsetup remove lvm

> Preparing the logical volumes

    lvm pvcreate /dev/sda2
    lvm vgcreate lvm /dev/sda2
    lvm lvcreate -L 10G -n root lvm
    lvm lvcreate -L 500M -n swap lvm
    lvm lvcreate -L 500M -n tmp lvm
    lvm lvcreate -l 100%FREE -n home lvm

    cryptsetup luksFormat -c aes-xts-plain64 -s 512 /dev/lvm/root
    cryptsetup open --type luks /dev/lvm/root root
    mkreiserfs /dev/mapper/root
    mount /dev/mapper/root /mnt

Note that /home will be encrypted after rebooting.

> Preparing the boot partition

    dd if=/dev/zero of=/dev/sda1 bs=1M
    mkreiserfs /dev/sda1
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot

Now after setup of the encrypted LVM partitioning, it would be time to
install: Arch Install Scripts.

> Configuring mkinitcpio

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Does the order   
                           of lvm2 and encrypt      
                           matter in this case?     
                           Compare to #Configuring  
                           mkinitcpio 2. (Discuss)  
  ------------------------ ------------------------ ------------------------

Add the lvm2 and encrypt hooks to mkinitcpio.conf, before filesystems:

    etc/mkinitcpio.conf

    HOOKS="... lvm2 encrypt ... filesystems ..."

See dm-crypt/System Configuration#mkinitcpio for details and other hooks
that you may need.

> Configuring the boot loader

For the above example, change the kernel options for the root-device
auto-configured in the bootloader installation from root=/dev/hda3 to

    cryptdevice=/dev/lvm/root:root root=/dev/mapper/root

More general, the kernel command line for LUKS <-> LVM is constructed
like this:

    root=/dev/mapper/<volume-group>-<logical-volume> cryptdevice=/dev/<luks-part>:<volume-group>

For example:

    root=/dev/mapper/vg-arch cryptdevice=/dev/sda4:vg

Or like this:

    cryptdevice=/dev/<volume-group>/<logical-volume>:root root=/dev/mapper/root

If you want install the system on a usb stick, you need to add
lvmdelay=/dev/mapper/lvm-root

> Configuring fstab and crypttab

    /etc/fstab

     /dev/mapper/root        /       reiserfs        defaults        0       1
     /dev/sda1               /boot   reiserfs        defaults        0       2
     /dev/mapper/tmp         /tmp    tmpfs           defaults        0       0
     /dev/mapper/swap        none    swap            sw              0       0

    /etc/crypttab

     swap	/dev/lvm/swap	SWAP		-c aes-xts-plain64 -s 512
     tmp	/dev/lvm/tmp	/dev/urandom	-c aes-xts-plain64 -s 512

> Encrypting /home after reboot

Below we will be editing /etc/crypttab. This is necessary to unlock each
non-root LUKS container (like /home, /media, etc) -- these logical
volumes are just as important as /root, and if they are not visible the
entire system will fail to boot! LVM must have all volumes present and
accounted for. Now, in order to avoid typing in multiple passwords (1
per container) every boot, we may generate some strong encryption keys
and save them in /etc. Some more background about possible encryption
keys, you find here. When the PC is powered off, these keys are
perfectly safe: they are being saved inside the root LVM container,
which must be unlocked by you at boot with a password. As well, having
different passwords for each disk makes breaking the encryption even
more difficult -- even if one password is compromised, the LVM WILL NOT
activate without the other partitions.

    mkdir -p -m 700 /mnt/etc/luks-keys
    dd if=/dev/random of=/mnt/etc/luks-keys/home bs=1 count=256

    cryptsetup luksFormat -c aes-xts-plain64 -s 512 /dev/lvm/home /etc/luks-keys/home
    cryptsetup open --type luks -d /etc/luks-keys/home /dev/lvm/home home
    mkreiserfs /dev/mapper/home
    mount /dev/mapper/home /home

    /etc/crypttab

     home	/dev/lvm/home   /etc/luks-keys/home

Note:If you do not want to use a keyfile, simply leave the third column
empty (/etc/luks-keys/home in the example) and you will be asked for a
password at boot.

    /etc/fstab

     /dev/mapper/home        /home   reiserfs        defaults        0       0

> Expanding LVM on multiple disks

The encrypt hook only allows for a single cryptdevice= entry. For
example, take "LVM on LUKS": The entire LVM exists inside a LUKS
container. This is perfectly fine for a single-drive system: there is
only one container to decrypt. But what happens when you want to
increase the size of your LVM? This is in fact the main advantage of
LVM: you can add and remove entire drives without having to change the
underlying partition.

So, you add another hard drive in order to expand home (which is a
logical volume of its own). You encrypt the second drive, add it to the
volume group, expand the home LV. But now, how do you tell initrd to
unlock BOTH drives at the same time? You cannot, at least not without
modifying the encrypt hook. And as stated in the section above: if only
a part of an LVM is available, it will not boot. So, adding a second
drive that requires decryption before it can be read is out of the
picture.

Luckily, we can get around this by making the LVM's visible to the
system even before they are encrypted. This is why LUKS on LVM is, in
general, the option offering more flexibility to change partitioning.

Adding a new drive

Assuming you now have a working single-drive LUKS-on-LVM configuration,
it's now time to expand one of your logical volumes.

Connect your drive (if it's new, or completely randomize it as you did
with your root drive). Open gdisk and create a single partiion:

-   /dev/sdy1: Use ALL space, Partition type 8E00 (Linux LVM)

Now, attach this new disk to your existing LVM:

    # pvcreate /dev/sdy1
    # vgextend MyStorage /dev/sdy1

Extending the logical volume

You will have to unmount whatever partition you want to grow, meaning
you may need to boot via an install cd. Details for this will follow
below. In this example, we will extend the "HOME" logical volume by 100%
of the free space of our new drive (ie, put the WHOLE thing into /home!)

From a root console:

    # umount /home
    # fsck /dev/mapper/home
    # cryptsetup luksClose /dev/mapper/home
    # lvextend -l +100%FREE MyStorage/homevol

Now the LV is extended. Let us make LUKS aware of the change:

    # cryptsetup open --type luks /dev/mapper/MyStorage-homevol home
    # umount /home      ((JUST IN CASE IT WAS AUTO RE-MOUNTED AGAIN))
    # cryptsetup --verbose resize home

And finally resize the ext4 partition itself:

    # e2fsck -f /dev/mapper/home
    # resize2fs /dev/mapper/home

Done!

    # mount /dev/mapper/home /home

Note how /home now includes the span of the new drive, and you DO not
have to change or add any more encryption keys -- the key for your Home
LVM will continue to work and fill into the newly added space.

-   A note on extending your root partition:

The procedure works exactly the same for your root LVM, with the
exception that it must be done from an Arch INSTALL CD. (you cannot
unmount your root partition while it's in use).

> Troubleshooting

The system does not boot

First, DONT PANIC! You can always boot a rescue CD and get into your LVM
manually!

Start up via the Arch installer. When you reach the root shell, for each
encrypted LVM:

    # cryptsetup open --type luks /dev/mapper/MyStorage-rootvol

Simply unlock each logical partition -- they will appear in
/dev/mapper/<lv> and you can mount each from there.

LUKS on software RAID
---------------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Some references: 
                           RAID, Software RAID and  
                           LVM,                     
                           http://jasonwryan.com/bl 
                           og/2012/02/11/lvm/       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Plain dm-crypt
--------------

This scenario sets up a system on a dm-crypt a full disk with plain mode
encryption. Note that for most use cases, the methods using LUKS
described above are the better options for both system encryption and
encrypted partitions. LUKS features like key management with multiple
pass-phrases/key-files are unavailable with plain mode.

The scenario uses an USB stick for the boot device and another one to
store the encryption key. The disk layout is:

    +------------------------------------------------------------+ +---------------+ +---------------+
    |disk drive /dev/sdaX encrypted using plain mode and LVM     | |USB stick 1    | |USB stick 2    |
    |--------------------+------------------+--------------------| |---------------| |---------------|
    |Volume 1:           |Volume 2:         |Volume 3:           | |Boot device    | |Encryption key |
    |                    |                  |                    | |               | |file storage   |
    |root                |swap              |home                | |/boot          | |(unpartitioned |
    |                    |                  |                    | |               | |in example)    |
    |/dev/store/root     |/dev/store/swap   |/dev/store/home     | |/dev/sdY1      | |/dev/sdZ       |
    +--------------------+------------------+--------------------+ +---------------+ +---------------+

The reasons for the use of two USB-keys are:

-   The boot loader options required to open/unlock a plain encrypted
    device are detailed. Typing them each boot is error prone, storing
    them on an unencrypted /boot partition on the same device results in
    security concerns.
-   This scenario uses a key file, storing the keyfile on a second USB
    stick for security again. A passphrase with good entropy may be used
    instead.

The main consideration for choosing plain over LUKS mode for the
scenario is:

-   dm-crypt plain mode does not require a header on the encrypted disk.
    This means that an unpartitioned, encrypted disk will be
    indistinguishable from a disk filled with random data, which is the
    desired attribute for this scenario.

Plain dm-crypt encrypted disks can be more resilient to damage than LUKS
encrypted disks, because it does not rely on an encryption master-key
which can be a single-point of failure if damaged. However, using plain
mode also requires more manual configuration of encryption options to
achieve the same cryptographic strength. See also
Disk_Encryption#Cryptographic_metadata

Note:If you have a requirement for a blockdevice without a cryptheader
but want to use LUKS instead of plain mode for above noted
disadvantages, cryptsetup offers a --header option too. While it cannot
be used with the encrypt hook, it can generally be used to place the
LUKS header remote from the encrypted blockdevice. For example it could
be placed on the usb-key /dev/sdZ instead of the key-file (using a
passphrase instead gives easy two-factor authentication).

> Preparing the disk

It is vital that the mapped device is filled with data. In particular
this applies to the scenario usecase we apply here.

See Dm-crypt/Drive_Preparation and
Dm-crypt/Drive_Preparation#dm-crypt_specific_methods

> Preparing the non-boot partitions

See Dm-crypt/Device Encryption#Encryption options for plain mode for
details.

Using the device /dev/sdX, with the twofish-xts cipher with a 512 bit
key size and using a keyfile we have the following options for this
scenario:

    # cryptsetup --hash=sha512 --cipher=twofish-xts-plain64 --offset=0 --key-file=/dev/sdZ --key-size=512 open --type=plain /dev/sdX enc

Unlike encrypting with LUKS, the above command must be executed in full
whenever the mapping needs to be re-established, so it is important to
remember the cipher, hash and key file details.

We can now check a mapping entry has been made for /dev/mapper/enc:

    # fdisk -l

Next, we setup LVM logical volumes on the mapped device, see
Lvm#Installing_Arch_Linux_on_LVM for further details:

    # pvcreate /dev/mapper/enc
    # vgcreate store /dev/mapper/enc
    # lvcreate -L 20G store -n root
    # lvcreate -C y -L 10G store -n swap
    # lvcreate -l +100%FREE store -n home

We format and mount them and activate swap, see File Systems#Format a
device for further details:

    # mkfs.ext4 /dev/store/root
    # mkfs.ext4 /dev/store/home
    # mount /dev/store/root /mnt
    # mkdir /mnt/home
    # mount /dev/store/home /mnt/home
    # mkswap /dev/store/swap
    # swapon /dev/store/swap

> Preparing the boot partition

The /boot partition can be installed on the standard vfat partition of a
USB stick, if required. But if manual partitioning is needed, then a
small 200MB partition is all that is required:

    # fdisk /dev/sdY
    > n
    > p
    > 1
    > default (2048)
    > +200M
    > w
    > q

We choose a non-journalling file system to preserve the flash memory of
the /boot partition, if not already formatted as vfat:

    # mkfs.ext2 /dev/sdY1
    # mkdir /mnt/boot
    # mount /dev/sdY1 /mnt/boot

> Configuring mkinitcpio

Add the encrypt and lvm2 hooks to mkinitcpio.conf, before filesystems:

    etc/mkinitcpio.conf

    HOOKS="... encrypt lvm2 ... filesystems ..."

See dm-crypt/System Configuration#mkinitcpio for details and other hooks
that you may need.

> Configuring the boot loader

In order to boot the encrypted root partition, the following kernel
parameters need to be set in your boot loader:

    cryptdevice=/dev/sdX:enc cryptkey=/dev/sdZ:0:512 crypto=sha512:twofish-xts-plain64:512:0:

See Dm-crypt/System Configuration#Boot loader for details and other
parameters that you may need.

Tip:If using GRUB, you can install it on the same USB as the /boot
partition with:

    # grub-install --recheck /dev/sdY

> Post-installation

You may wish to remove the USB sticks after booting. Since the /boot
partition is not usually needed, the following option can be added to
the boot options in /etc/fstab:

    /etc/fstab

    # /dev/sdYn
    UUID=************* /boot ext2 noauto,rw,noatime 0 2

However, when an update to the kernel or bootloader is required, the
/boot partition must be present and mounted. As the entry in fstab
already exists, it can be mounted simply with:

    # mount /boot

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dm-crypt/Encrypting_an_Entire_System&oldid=304065"

Categories:

-   Security
-   File systems
-   Getting and installing Arch

-   This page was last modified on 11 March 2014, at 19:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
