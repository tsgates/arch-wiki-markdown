dm-crypt
========

Related articles

-   Disk Encryption
-   Removing System Encryption

This article focuses on how to set up encryption on Arch Linux using
dm-crypt, which is the standard device-mapper encryption functionality
provided by the Linux kernel.

Contents
--------

-   1 Common scenarios
-   2 Drive preparation
-   3 Device encryption
-   4 System configuration
-   5 Swap device encryption
-   6 Specialties
-   7 See also

Common scenarios
----------------

This section introduces common scenarios to employ dm-crypt to encrypt a
system or individual filesystem mount points. The scenarios cross-link
to the other subpages where needed. It is meant as starting point to
familiarize with different practical encryption procedures.

See Dm-crypt/Encrypting a Non-Root File System if you need to encrypt a
device that is not used for booting a system, like a partition or a loop
device.

See Dm-crypt/Encrypting an Entire System if you want to encrypt an
entire system, in particular a root partition. Several scenarios are
covered, including the use of dm-crypt with the LUKS extension, plain
mode encryption and encryption and LVM.

Drive preparation
-----------------

This step will deal with operations like securely erasing the drive and
partitioning it.

See Dm-crypt/Drive Preparation.

Device encryption
-----------------

This section covers how to manually utilize dm-crypt to encrypt a system
through the cryptsetup command, also dealing with the usage of LUKS and
keyfiles.

See Dm-crypt/Device Encryption.

System configuration
--------------------

This page illustrates how to configure mkinitcpio, the boot loader and
the crypttab file when encrypting a system.

See Dm-crypt/System Configuration.

Swap device encryption
----------------------

A swap partition may be added to an encrypted system, if required. The
swap partition must be encrypted as well to protect any data swapped out
by the system. This part details methods without and with
suspend-to-disk support.

See Dm-crypt/Swap Encryption.

Specialties
-----------

This part deals with special operations like securing the unencrypted
boot partition, using GPG or OpenSSL encrypted keyfiles, a method to
boot and unlock via the network, or setting up discard/TRIM for a SSD.

See Dm-crypt/Specialties.

See also
--------

-   dm-crypt - The project homepage
-   cryptsetup - The LUKS homepage and FAQ - the main and foremost help
    resource.
-   cryptsetup repository and release archive.
-   FreeOTFE - Supports unlocking LUKS encrypted volumes in Microsoft
    Windows.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dm-crypt&oldid=304070"

Categories:

-   Security
-   File systems

-   This page was last modified on 11 March 2014, at 20:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
