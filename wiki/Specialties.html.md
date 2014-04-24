dm-crypt/Specialties
====================

Back to Dm-crypt.

Contents
--------

-   1 Securing the unencrypted boot partition
    -   1.1 Booting from a removable device
    -   1.2 chkboot
-   2 Using GPG or OpenSSL Encrypted Keyfiles
-   3 Remote unlocking of the root (or other) partition
-   4 Discard/TRIM support for solid state drives (SSD)
-   5 Modifying the encrypt hook for a root partition
-   6 Modifying the encrypt hook for a non-root partition

Securing the unencrypted boot partition
---------------------------------------

The /boot partition and the Master Boot Record are the two areas of the
disk that are not encrypted, even in an encrypted root configuration.
They cannot be encrypted because the boot loader and BIOS (respectively)
are unable to unlock a dm-crypt container in order to continue the boot
process. This section describes steps that can be taken to make the boot
process more secure.

Note that securing the /boot partition and MBR can mitigate numerous
attacks that occurr during the boot process, but systems configured this
way may still be vulnerable to BIOS/UEFI/firmware tampering, hardware
keyloggers, cold boot attacks, and many other threats that are beyond
the scope of this article.

> Booting from a removable device

Using a separate device to boot a system is a fairly straightforward
procedure, and offers a significant security improvement against some
kinds of attacks. Two vulnerable parts of a system employing an
encrypted root filesystem are

-   the Master Boot Record, and
-   the /boot partition.

These must be stored unencrypted in order for the system to boot. In
order to protect these from tampering, it is advisable to store them on
a removable medium, such as a USB drive, and boot from that drive
instead of the hard disk. As long as you keep the drive with you at all
times, you can be certain that those components have not been tampered
with, making authentication far more secure when unlocking your system.

It is assumed that you already have your system configured with a
dedicated partition mounted at /boot. If you do not, please follow the
steps in dm-crypt/System Configuration#Boot loader, substituting your
hard disk for a removable drive.

Note:You must make sure your system supports booting from the chosen
medium, be it a USB drive, an external hard drive, an SD card, or
anything else.

Prepare the removable drive (/dev/sdx).

    # gdisk /dev/sdx #format if necessary. Alternatively, cgdisk, fdisk, cfdisk, gparted...
    # mkfs.ext2 /dev/sdx1
    # mount /dev/sdx1 /mnt

Copy your existing /boot contents to the new one.

    # cp -R -i -d /boot/* /mnt

Mount the new partition. Do not forget to update your fstab file
accordingly.

    # umount /boot
    # umount /mnt
    # mount /dev/sdx1 /boot
    # genfstab -p -U / > /etc/fstab

Update GRUB. grub-mkconfig should detect the new partition UUID
automatically, but custom menu entries may need to be updated manually.

    # grub-mkconfig -o /boot/grub/grub.cfg
    # grub-install /dev/sdx #install to the removable device, not the hard disk.

Reboot and test the new configuration. Remember to set your device boot
order accordingly in your BIOS or UEFI. If the system fails to boot, you
should still be able to boot from the hard drive in order to correct the
problem.

> chkboot

Warning:chkboot makes a /boot partition tamper-evident, not
tamper-proof. By the time the chkboot script is run, you have already
typed your password into a potentially compromised boot loader, kernel,
or initrd. If your system fails the chkboot integrity test, no
assumptions can be made about the security of your data.

Referring to an article from the ct-magazine (Issue 3/12, page 146,
01.16.2012 http://www.heise.de/ct/inhalt/2012/03/6/) the following
script checks files under /boot for changes of SHA-1 hash, inode and
occupied blocks on the hard drive. It also checks the MBR. The script
cannot prevent certain type of attacks, but a lot are made harder. No
configuration of the script itself is stored in unencrypted /boot. With
a locked/powered-off crypted system this makes it infeasible for an
attacker to recognize that an automatic checksum comparison of the
partition is done upon boot.

The script with installation instructions is available here:
ftp://ftp.heise.de/pub/ct/listings/1203-146.zip (Author: Juergen
Schmidt, ju at heisec.de; License: GPLv2). There is also an AUR package:
chkboot and a slightly updated AUR package chkboot-git which includes
systemd support.

After installation:

-   For classical sysvinit: add /usr/local/bin/chkboot.sh & to your
    /etc/rc.local
-   For systemd: add a service file and enable the service: systemd. The
    service file might look like:

    [Unit]
    Description=Check that boot is what we want
    Requires=basic.target
    After=basic.target

    [Service]
    Type=oneshot
    ExecStart=/usr/local/bin/chkboot.sh

    [Install]
    WantedBy=multi-user.target

There is a small caveat for systemd: At the time of writing, the
original chkboot.sh script provided contains an empty space at the
beginning of  #!/bin/bash which has to be removed for the service to
start successfully.

As /usr/local/bin/chkboot_user.sh need to be excuted after login, add it
to the autostart (e.g. under KDE -> System Settings -> Startup and
Shutdown -> Autostart; Gnome3: gnome-session-properties).

With Arch Linux changes to /boot are pretty frequent, for example by new
kernels rolling-in. Therefore it may be helpful to use the scripts with
every full system update. One way to do so:

    #!/bin/bash
    #
    # Note: Insert your <user>  and execute it with sudo for pacman & chkboot to work automagically
    #
    echo "Pacman update [1] Quickcheck before updating" & 
    sudo -u <user> /usr/local/bin/chkboot_user.sh		# insert your logged on <user> 
    /usr/local/bin/chkboot.sh
    sync							# sync disks with any results 
    sudo -u <user> /usr/local/bin/chkboot_user.sh		# insert your logged on <user> 
    echo "Pacman update [2] Syncing repos for pacman" 
    pacman -Syu
    /usr/local/bin/chkboot.sh
    sync	
    sudo -u <user> /usr/local/bin/chkboot_user.sh		# insert your logged on <user>
    echo "Pacman update [3] All done, let us roll on ..."

Alternatively to above scripts, a hash check can be set up with AIDE
which can be customized via a very flexible configuration file.

While one of these methods should serve the purpose for most users, they
do not address all security problems associated with the unencrypted
/boot. One approach which endeavours to provide a fully authenticated
boot chain was published with POTTS as an academic thesis to implement
the STARK authentication framework.

The POTTS proof-of-concept uses Arch Linux as a base distribution and
implements a system boot chain with

-   POTTS - a bootmenu for a one-time authentication message prompt
-   TrustedGrub - a grub-legacy implementation which authenticates the
    kernel and initramfs against TPM chip registers
-   TRESOR - a kernel patch which implements AES but keeps the
    master-key not in RAM but in CPU registers during runtime.

As part of the thesis installation instructions based on Arch Linux (iso
2013-01) have been published. If you want to try it, be aware these
tools are not in standard repositories and the solution will be time
consuming to maintain.

Using GPG or OpenSSL Encrypted Keyfiles
---------------------------------------

The following forum posts give instructions to use two factor
authentication, gpg or openssl encrypted keyfiles, instead of a
plaintext keyfile described earlier in this wiki article System
Encryption using LUKS with GPG encrypted keys:

-   GnuPG: Post regarding GPG encrypted keys This post has the generic
    instructions.
-   OpenSSL: Post regarding OpenSSL encrypted keys This post only has
    the ssldec hooks.
-   OpenSSL: Post regarding OpenSSL salted bf-cbc encrypted keys This
    post has the bfkf initcpio hooks, install, and encrypted keyfile
    generator scripts.

Note that:

-   You can follow the above instructions with only two primary
    partitions one boot partition

(required because of LVM), and one primary LVM partition. Within the LVM
partition you can have as many partitions as you need, but most
importantly it should contain at least root, swap, and home logical
volume partitions. This has the added benefit of having only one keyfile
for all your partitions, and having the ability to hibernate your
computer (suspend to disk) where the swap partition is encrypted. If you
decide to do so your hooks in /etc/mkinitcpio.conf should look like
HOOKS=" ... usb usbinput (etwo or ssldec) encrypt(if using openssl) lvm2 resume ... "
and you should add "resume=/dev/mapper/<VolumeGroupName>-<LVNameOfSwap>"
to your kernel parameters.

-   If you need to temporarily store the unecrypted keyfile somewhere,
    do not store them on an unencrypted disk. Even better make sure to
    store them to RAM such as /dev/shm.
-   If you want to use a GPG encrypted keyfile, you need to use a
    statically compiled GnuPG version 1.4 or you could edit the hooks
    and use this AUR package gnupg1
-   It is possible that an update to OpenSSL could break the custom
    ssldec mentioned in the second forum post.

Remote unlocking of the root (or other) partition
-------------------------------------------------

If you want to be able to reboot a fully LUKS-encrypted system remotely,
or start it with a Wake-on-LAN service, you will need a way to enter a
passphrase for the root partition/volume at startup. This can be
achieved by running the net hook along with an SSH server in initrd.
Install the dropbear_initrd_encrypt package from the AUR and follow the
post-installation instructions. Replace the encrypt hook with
dropbear encryptssh in /etc/mkinitcpio.conf. Put the net hook early in
the HOOKS array if your DHCP server takes a long time to lease IP
addresses.

If you would simply like a nice solution to mount other encrypted
partitions (such as /home)remotely, you may want to look at this forum
thread.

Discard/TRIM support for solid state drives (SSD)
-------------------------------------------------

Solid state drive users should be aware that by default, Linux's
full-drive encryption mechanisms will not forward TRIM commands from the
filesystem to the underlying drive. The device-mapper maintainers have
made it clear that TRIM support will never be enabled by default on
dm-crypt devices because of the potential security implications.

Most users will still want to use TRIM on their encrypted SSDs. Minimal
data leakage in the form of freed block information, perhaps sufficient
to determine the filesystem in use, may occur on devices with TRIM
enabled. An illustration and discussion of the issues arising from
activating TRIM is available in the blog of a cryptsetup developer.

As a semi-tangential caveat, it is worth noting that because TRIM
provides information to the drive firmware about which blocks contain
data, encryption schemes that rely on plausible deniability, like
TrueCrypt's hidden volumes, should never be used on a device that
utilizes TRIM. This is probably also valid for TC containers within a
LUKS encrypted device that uses TRIM.

TrueCrypt's developers also recommend against using any TC volume on a
device that performs wear-leveling techniques to extend the life of the
drive; most flash devices, including SSDs and USB flash drives, use
mandatory wear-leveling at the firmware level. LUKS devices are probably
not vulnerable to problems with wear-leveling if the entire device is
blanked before the LUKS partition is initialized. See here and here for
more information.

In linux 3.1 and up, support for dm-crypt TRIM pass-through can be
toggled upon device creation or mount with dmsetup. Support for this
option also exists in cryptsetup version 1.4.0 and up. To add support
during boot, you will need to add :allow-discards to the cryptdevice
option. The TRIM option may look like this:

    cryptdevice=/dev/mapper/root:root:allow-discards

For the main cryptdevice configuration options before the
:allow-discards see Dm-crypt/System_Configuration

Besides the kernel option, it is also required to mount the filesystem
(e.g. /dev/mapper/root in this example) with the discard option in
/etc/fstab. For details, please refer to the SSD page. For LUKS devices
unlocked manually on the console or via /etc/crypttab either discard or
allow-discards may be used.

Modifying the encrypt hook for a root partition
-----------------------------------------------

It is possible to modified the encrypt hook, to allow multiple hard
drive decrypt root (/) at boot. The AUR-package cryptsetup-multi use to
do this, but there is an alternative way thanks to user benke:

    # cp /usr/lib/initcpio/hooks/encrypt  /usr/lib/initcpio/hooks/encrypt2
    # cp /usr/lib/initcpio/install/encrypt /usr/lib/initcpio/install/encrypt2
    # nano /usr/lib/initcpio/hooks/encrypt2

Change cryptkey to cryptkey2, and cryptdevice to cryptdevice2. Add
cryptdevice2= (e.g. cryptdevice2=/dev/sdb:hdd2) to your boot options
(and cryptkey2= if needed).

Change the /etc/fstab flag for root:

    /dev/sdb     /mnt    btrfs    device=/dev/sda,device=/dev/sdb, ..    0 0

Modifying the encrypt hook for a non-root partition
---------------------------------------------------

Maybe you have a requirement for using the encrypt hook on a non-root
partition. Arch does not support this out of the box, however, you can
easily change the cryptdev and cryptname values in
/lib/initcpio/hooks/encrypt (the first one to your /dev/sd* partition,
the second to the name you want to attribute). That should be enough.

The big advantage is you can have everything automated, while setting up
/etc/crypttab with an external key file (i.e. the keyfile is not on any
internal hard drive partition) can be a pain - you need to make sure the
USB/FireWire/... device gets mounted before the encrypted partition,
which means you have to change the order of /etc/fstab (at least).

Of course, if the cryptsetup package gets upgraded, you will have to
change this script again. Unlike /etc/crypttab, only one partition is
supported, but with some further hacking one should be able to have
multiple partitions unlocked.

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Why not use the  
                           supported Grub2 right    
                           away? See also           
                           Mkinitcpio#Using_RAID    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

If you want to do this on a software RAID partition, there is one more
thing you need to do. Just setting the /dev/mdX device in
/lib/initcpio/hooks/encrypt is not enough; the encrypt hook will fail to
find the key for some reason, and not prompt for a passphrase either. It
looks like the RAID devices are not brought up until after the encrypt
hook is run. You can solve this by putting the RAID array in
/boot/grub/menu.lst, like

    kernel /boot/vmlinuz-linux md=1,/dev/hda5,/dev/hdb5

If you set up your root partition as a RAID, you will notice the
similarities with that setup ;-). GRUB can handle multiple array
definitions just fine:

    kernel /boot/vmlinuz-linux root=/dev/md0 ro md=0,/dev/sda1,/dev/sdb1 md=1,/dev/sda5,/dev/sdb5,/dev/sdc5

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dm-crypt/Specialties&oldid=302093"

Categories:

-   Security
-   File systems

-   This page was last modified on 25 February 2014, at 18:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
