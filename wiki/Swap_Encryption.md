dm-crypt/Swap Encryption
========================

Back to Dm-crypt.

Depending on requirements, different methods may be used to encrypt the
swap partition which are described in the following. A setup where the
swap encryption is re-initialised on reboot (with a new encryption)
provides higher data protection, because it avoids sensitive file
fragments which may have been swapped out a long time ago without being
overwritten. However, re-encrypting swap also forbids using a
suspend-to-disk feature generally.

Contents
--------

-   1 Without suspend-to-disk support
-   2 With suspend-to-disk support
    -   2.1 LVM on LUKS
    -   2.2 mkinitcpio hook
    -   2.3 Using a swap file

Without suspend-to-disk support
-------------------------------

In systems where suspend to disk is not a desired feature, it is
possible to create a swap file that will have a random master key with
each boot. This is accomplished by using dm-crypt directly without LUKS
extensions.

The /etc/crypttab is well commented and you can basically just uncomment
the swap line and change <device> to a persistent symlink.

    /etc/crypttab

    # <name>       <device>         <password>              <options>
    # swap         /dev/hdx4        /dev/urandom            swap,cipher=aes-cbc-essiv:sha256,size=256

Where:

 <name>
    Represents the name (/dev/mapper/<name>) to list in /etc/fstab.
 <device>
    Should be the symlink to the actual partition's device file.
 <password>
    /dev/urandom sets the dm-crypt master key to be randomized on every
    volume recreation.
 <options>
    The swap option runs mkswap after cryptographic's are setup.

Warning:You should use persistent block device naming (in example ID's)
for <device> because if there are multiple hard drives installed in the
system, their naming order (sda, sdb,...) can occasionally be scrambled
upon boot and thus the swap would be created over a valuable file
system, destroying its content.

Persistent block device naming is implemented with simple symlinks.
Using UUID's or filesystem-labels is not possible as plain dm-crypt
writes only encrypted data without a persistent header like LUKS. If you
are not familar with one of the directories under /dev/disk/ read on in
the section on Dm-crypt/Device Encryption#Preparation for Persistent
block device naming

    #ls -l /dev/disk/*/* | grep sda2

    lrwxrwxrwx 1 root root 10 Oct 12 16:54 /dev/disk/by-id/ata-WDC_WD2500BEVT-22ZCT0_WD-WXE908VF0470-part2 -> ../../sda2

Example line for the /dev/sda2 symlink from above:

    /etc/crypttab

    # <name>                      <device>                                   <password>     <options>
      swap  /dev/disk/by-id/ata-WDC_WD2500BEVT-22ZCT0_WD-WXE908VF0470-part2  /dev/urandom   swap,cipher=aes-cbc-essiv:sha256,size=256

This will map /dev/sda2 to /dev/mapper/swap as a swap partition that can
be added in /etc/fstab like a normal swap.

If the partition chosen for swap was previously a LUKS partition,
crypttab will not overwrite the partition to create a swap partition.
This is a safety measure to prevent data loss from accidental
mis-identification of the swap partition in crypttab. In order to use
such a partition the LUKS header must be overwritten once.

With suspend-to-disk support
----------------------------

> LVM on LUKS

A simple way to realize encrypted swap with suspend-to-disk support is
by using LVM ontop the encryption layer, so one encrypted partition can
contain infinite filesystems (root, swap, home, ...). Follow the
instructions on Dm-crypt/Encrypting an Entire System#LVM on LUKS and
then just configure the required kernel parameters.

Assuming you have setup LVM on LUKS with a swap logical volume (at
/dev/MyStorage/swap for example), all you need to do is add the resume
mkinitcpio hook, and add the resume=/dev/MyStorage/swap kernel parameter
to your boot loader. For GRUB, this can be done by appending it to the
GRUB_CMDLINE_LINUX_DEFAULT variable in /etc/default/grub.

    /etc/default/grub

    GRUB_CMDLINE_LINUX_DEFAULT="... resume=/dev/MyStorage/swap"

then run grub-mkconfig -o /boot/grub/grub.cfg to update GRUB's
configuration file. To add the mkinitcpio hook, edit the following line
in mkinitcpio.conf

    /etc/mkinitcpio.conf

    HOOKS="... encrypt lvm2 resume ... filesystems ..."

then run mkinitcpio -p linux to update the initramfs image.

> mkinitcpio hook

To be able to resume after suspending the computer to disk (hibernate),
it is required to keep the swap filesystem intact. Therefore, it is
required to have a pre-existent LUKS swap partition, which can be stored
on the disk or input manually at startup. Because the resume takes place
before /etc/crypttab can be used, it is required to create a hook in
/etc/mkinitcpio.conf to open the swap LUKS device before resuming.

If you want to use a partition which is currently used by the system,
you have to disable it first:

    # swapoff /dev/<device>

Also make sure you remove any line in /etc/crypttab pointing to this
device.

The following setup has the disadvantage of having to insert an
additional passphrase for the swap partition manually on every boot.

Warning:Do not use this setup with a key file. Please read about the
issue reported here

To format the encrypted container for the swap partition, create a
keyslot for a user-memorizable passphrase.

Open the partition in /dev/mapper:

    # cryptsetup open --type luks /dev/<device> swapDevice

Create a swap filesystem inside the mapped partition:

    # mkswap /dev/mapper/swapDevice

Now you have to create a hook to open the swap at boot time.

-   Create a hook file containing the open command:

    /lib/initcpio/hooks/openswap

     # vim: set ft=sh:
     run_hook ()
     {
         cryptsetup open --type luks /dev/<device> swapDevice
     }

for opening the swap device by typing your password or

    /lib/initcpio/hooks/openswap

     # vim: set ft=sh:
     run_hook ()
     {
         mkdir crypto_key_device
         mount /dev/mapper/<root-device> crypto_key_device
         cryptsetup open --type luks --key-file crypto_key_device/<path-to-the-key> /dev/<device> swapDevice
         umount crypto_key_device
     }

for opening the swap device by loading a keyfile from a crypted root
device

Note:If swap is on a Solid State Disk (SSD) and Discard/TRIM is desired
the option --allow-discards has to get added to the cryptsetup line in
the openswap hook above. See Discard/TRIM support for solid state disks
(SSD) or SSD for more information on discard. Additionally you have to
add the mount option 'discard' to your fstab entry for the swap device.

-   Then create and edit the hook setup file:

    /lib/initcpio/install/openswap

    # vim: set ft=sh:
    build ()
    {
       add_runscript
    }
    help ()
    {
    cat<<HELPEOF
      This opens the swap encrypted partition /dev/<device> in /dev/mapper/swapDevice
    HELPEOF
    }

-   Add the hook openswap in the HOOKS array in /etc/mkinitcpio.conf,
    before filesystem but after encrypt. Do not forget to add the resume
    hook after openswap.

    HOOKS="... encrypt openswap resume filesystems ..."

-   Regenerate the boot image:

    # mkinitcpio -p linux

-   Add the mapped partition to /etc/fstab by adding the following line:

    /dev/mapper/swapDevice swap swap defaults 0 0

-   Set up your system to resume from /dev/mapper/swapDevice. For
    example, if you use GRUB with kernel hibernation support, add
    resume=/dev/mapper/swapDevice to the kernel line in
    /boot/grub/grub.cfg. A line with encrypted root and swap partitions
    can look like this:

    kernel /vmlinuz-linux cryptdevice=/dev/sda2:rootDevice root=/dev/mapper/rootDevice resume=/dev/mapper/swapDevice ro

To make the parameter persistent on kernel updates, add it to
/etc/default/grub.

At boot time, the openswap hook will open the swap partition so the
kernel resume may use it. If you use special hooks for resuming from
hibernation, make sure they are placed after openswap in the HOOKS
array. Please note that because of initrd opening swap, there is no
entry for swapDevice in /etc/crypttab needed in this case.

> Using a swap file

A swap file can be used to reserve swap-space within an existing
partition and may also be setup inside an encrypted blockdevice's
partition. When resuming from a swapfile the resume hook must be
supplied with the passphrase to unlock the device where the swap file is
located. To create it:

-   Choose a mapped partition (e.g. /dev/mapper/rootDevice) whose
    mounted filesystem (e.g. /) contains enough free space to create a
    swapfile with the desired size.

-   Create the swap file (e.g. /swapfile) inside the mounted filesystem
    of your chosen mapped partition. Be sure to activate it with swapon
    and also add it to your /etc/fstab file afterward. Note that the
    swapfile's previous contents remain transparent over reboots.

-   Set up your system to resume from your chosen mapped partition. For
    example, if you use GRUB with kernel hibernation support, add
    resume=your chosen mapped partition and resume_offset=see
    calculation command below to the kernel line in /boot/grub/grub.cfg.
    A line with encrypted root partition can look like this:

    kernel /vmlinuz-linux cryptdevice=/dev/sda2:rootDevice root=/dev/mapper/rootDevice resume=/dev/mapper/rootDevice resume_offset=123456789 ro

The resume_offset of the swap-file points to the start (extent zero) of
the file and can be identified like this:

    # filefrag -v /swapfile | awk '{if($1=="0:"){print $4}}'

-   Add the resume hook to your etc/mkinitcpio.conf file and rebuild the
    image afterward:

    HOOKS="... encrypt resume ... filesystems ..."

-   If you use a USB keyboard to enter your decryption password, then
    the keyboard module must appear in front of the encrypt hook, as
    shown below. Otherwise, you will not be able to boot your computer
    because you could not enter your decryption password to decrypt your
    Linux root partition! (If you still have this problem after adding
    keyboard, try usbinput, though this is deprecated.)

    HOOKS="... keyboard encrypt ..."

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dm-crypt/Swap_Encryption&oldid=298441"

Categories:

-   Security
-   File systems

-   This page was last modified on 16 February 2014, at 22:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
