dm-crypt/System Configuration
=============================

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Aggregate here   
                           all the generic          
                           information on system    
                           configuration from the   
                           other sub-articles of    
                           Dm-crypt. (Discuss)      
  ------------------------ ------------------------ ------------------------

Back to Dm-crypt.

Contents
--------

-   1 mkinitcpio
-   2 Boot loader
    -   2.1 cryptdevice
    -   2.2 root
    -   2.3 resume
    -   2.4 cryptkey
    -   2.5 crypto
-   3 crypttab

mkinitcpio
----------

When encrypting a system it is necessary to regenerate the initial
ramdisk after properly configuring mkinitcpio. Depending on the
particular scenarios, a subset of the following hooks will have to be
enabled:

-   encrypt: always needed when encrypting the root partition, or a
    partition that needs to be mounted before root; it must come before
    the filesystems hook; it is not needed in all the other cases, as
    system initialization scripts like /etc/crypttab take care of
    unencrypting any other partitions.
-   shutdown: recommended before mkinitcpio 0.16 to ensure controlled
    unmounting during system shutdown. It is still functional, but not
    deemed necessary anymore.
-   keymap: provides support for foreign keymaps for typing encryption
    passwords; it must come before the encrypt hook.
-   keyboard: needed to make USB keyboards work in early userspace.
    -   usbinput: deprecated, but can be given a try in case keyboard
        does not work.

Other hooks needed should be clear from other manual steps followed
during the installation of the system.

Boot loader
-----------

In order to enable booting an encrypted root partition, a subset of the
following kernel parameters need to be set. See kernel parameters for
instructions specific to your boot loader.

> cryptdevice

This parameter will make the system prompt for the passphrase to unlock
the root device on a cold boot. It is parsed by the encrypt hook to
identify which device contains the encrypted system:

    cryptdevice=device:dmname

-   device is the path to the raw encrypted device. Usage of Persistent
    block device naming is advisable.
-   dmname is the device-mapper name given to the device after
    decryption, which will be available as /dev/mapper/dmname.

> root

This parameter is needed when not using GRUB. The reason GRUB does not
require this is because the auto-generated grub.cfg is meant to handle
specifying the root for you.

    root=device

-   device is the device file of the actual (decrypted) root file
    system. If the file system is formatted directly on the decrypted
    device file this will be /dev/mapper/dmname.

> resume

    resume=device

-   device is the device file of the decrypted (swap) filesystem used
    for suspend2disk. If swap is on a separate partition, it will be in
    the form of /dev/mapper/swap. See also Dm-crypt/Swap Encryption.

> cryptkey

This parameter is required by the encrypt hook for reading a keyfile to
unlock the cryptdevice. It can have two parameter sets, depending on
whether the keyfile exists as a file or a bitstream starting on a
specific location.

For a file the format is:

    cryptkey=device:fstype:path

-   device is the raw block device where the key exists.
-   fstype is the filesystem type of device (or auto).
-   path is the absolute path of the keyfile within the device.

Example: cryptkey=//dev/usbstick:vfat:/secretkey

For a bitstream on a device the key's location is specified with the
following:

    cryptkey=device:offset:size 

Example: cryptkey=/dev/sdZ:0:512 reads a 512 bit keyfile starting at the
beginning of the device.

See also Dm-crypt/Device Encryption#Cryptsetup and keyfiles.

> crypto

This parameter is specific to pass dm-crypt plain mode options to the
encrypt hook.

It takes the form

    crypto=<hash>:<cipher>:<keysize>:<offset>:<skip>

The arguments relate directly to the cryptsetup options. See
Dm-crypt/Device_Encryption#Encryption_options_for_plain_mode

For a disk encrypted with just plain default options, the crypto
arguments must be specified, but each entry can be left blank:

    crypto=::::

A specific example of arguments is

    crypto=sha512:twofish-xts-plain64:512:0:

crypttab
--------

The /etc/crypttab (or, encrypted device table) file contains a list of
encrypted devices that are to be unlocked when the system boots, similar
to fstab. This file can be used for automatically mounting encrypted
swap devices or secondary filesystems. It is read before fstab, so that
dm-crypt containers can be unlocked before the filesystem inside is
mounted. Note that crypttab is read after the system has booted, so it
is not a replacement for mkinitcpio hooks or boot loader options in the
case of an encrypted root scenario. See the crypttab man page for
details.

    /etc/crypttab

     #Example crypttab file. Fields are: name, underlying device, passphrase, cryptsetup options.
     #Mount /dev/lvm/swap as /dev/mapper/swap using plain dm-crypt with passphrase "SWAP"
     swap	/dev/lvm/swap	SWAP		-c aes-xts-plain -h whirlpool -s 512
     #Mount /dev/lvm/tmp as /dev/mapper/tmp using plain dm-crypt with a random passphrase, making its contents unrecoverable after it is dismounted.
     tmp	/dev/lvm/tmp	/dev/urandom	-c aes-xts-plain -s 512
     #Mount /dev/lvm/home as /dev/mapper/home using LUKS, and prompt for the passphrase at boot time.
     home   /dev/lvm/home
     #Mount /dev/sdb1 as /dev/mapper/backup using LUKS, with a passphrase stored in a file.
     backup /dev/sdb1       /home/alice/backup.key

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dm-crypt/System_Configuration&oldid=296703"

Categories:

-   Security
-   File systems

-   This page was last modified on 9 February 2014, at 21:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
