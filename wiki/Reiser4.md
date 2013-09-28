Reiser4
=======

Reiser4 is the "new" (circa 2004) successor filesystem for ReiserFS,
developed from scratch by Namesys and Hans Reiser. It is very efficient
for handling small files (often used in /var for this purpose) and
includes features such as cheap transparent compression and block
suballocation. Because it is an atomic file system "your file system
operations either entirely occur, or they entirely don't, and they do
not corrupt due to half occurring." Benchmarks with other linux
filesystems are also available.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Important Notes                                                    |
| -   2 Packages                                                           |
| -   3 Moving to Reiser4                                                  |
|     -   3.1 Sample system                                                |
|     -   3.2 Formatting                                                   |
|     -   3.3 Copy system                                                  |
|     -   3.4 /etc/fstab:                                                  |
|                                                                          |
| -   4 Bootloader Examples                                                |
|     -   4.1 /boot/grub/grub.cfg:                                         |
|     -   4.2 /etc/lilo.conf:                                              |
|                                                                          |
| -   5 Troubleshooting                                                    |
+--------------------------------------------------------------------------+

Important Notes
---------------

-   Reiser4 requires a patched kernel
-   It consumes a little more CPU than other filesystems
-   It is developed for the 2.6 kernel and not backported for 2.4
-   Even Lilo as the only bootloader officially supporting Reiser4 seems
    to have issues with it when /boot is formatted as Reiser4
-   It is still not considered stable

Tip:Gparted LiveCD is a small Linux distribution booting straight into
Gparted. It also supports Reiser4

Packages
--------

1. Install reiser4progs from AUR

2. You'll need a reiser4 patched kernel. Unfortunately, it has yet not
been ported into 3.0 kernel. You can check out here for the progress:
http://www.kernel.org/pub/linux/kernel/people/edward/reiser4/

3. Bootloader (Optional, only needed if you want to format your / (root)
as reiser4)

Note:Backing up your bootloader configuration file should be considered.

a) Recomended: make a small (as mentioned above, 20-200mb) partition for
/boot with a filesystem other than Reiser4 with Gparted, and then copy
your /boot folder to the partition. Update your bootloader config
accordingly, eg. with Grub2 do:

    # grub-mkconfig -o /boot/grub/grub.cfg

b) If you wish to put everything including /boot on a Reiser4 partition
you'll need to use Lilo. This is not advised, as you'll probably get an
error when trying to update lilo.conf:

    # lilo

4. Reboot

Note:The following steps are for using Reiser4 as your / (root). If you
just want to use Reiser in /var (or whatever) you should modify the
following instructions according to your needs.

Moving to Reiser4
-----------------

In the next steps we'll copy the data from your current root partition
to the new Reiser4 partitions. Make sure you have enough disk space on
the Reiser4 partition with:

    # df -h

> Sample system

    # fdisk -l
    * /dev/sda1: (10 Gb, 5 Gb free); Reiserfs /mnt/reiser4
    * /dev/sda2: (10 Gb, 10 Gb free); Reiser4 /
    * /dev/sda3: (200 Mb, 180 Mb free); ext2 /boot

> Formatting

Run the following commands:

    mkfs.reiser4 /dev/sdaX
    mkdir /mnt/reiser4
    mount -t reiser4 /dev/sdaX /mnt/reiser4

Note:With X being your partition number!

It is recommended that you use the Cryptcompress plugin by formatting
with the following command:

    mkfs.reiser4 -o create=ccreg40,compress=lzo1 /dev/sdaX

> Copy system

Once the partition is formated, copy you current system to the new
partition and create the system directories. You may either do this from
Arch Linux, or to make it easier (so that you do not have to use makedev
later), just boot up with the Gparted LiveCD and mount both your new
Reiser4 partition and your current root partition. Then, just copy
everything over (as root) like so:

    cd /mnt
    mkdir oldroot
    mkdir reiser4
    mount /dev/sdaX oldroot
    mount /dev/sdaY reiser4 (the Reiser4 partition)
    cp -R -a /mnt/oldroot/* /mnt/reiser4/

Then, you need to mount your /boot partition, and if you haven't
already, copy /boot from your original root partition over to it.

Note:It is suggested to empty your /boot from the Reiser4 partition to
use it as a mountpoint, which is reflected later in your fstab

    mkdir bootpart
    mount /dev/sdaZ bootpart
    cp -R -a /mnt/oldroot/boot/* /mnt/bootpart/

Don't forget to edit your bootloader's config appropriately (see
examples at the bottom of the article).

Note:In case you upgraded grub before rebooting you may need to manually
install grub to your /boot partition, otherwise, things may break and
prevent you from booting. In this case using a LiveCD to Chroot and
would be your last hope.

> /etc/fstab:

Note: If you can confirm that Reiser4 works for you, you should format
the old root partition.

    #
    # /etc/fstab: static file system information
    #
    # <file system>	<dir>	      <type>  <options>	         <dump>	<pass>
    devpts          /dev/pts      devpts  defaults             0      0
    shm             /dev/shm      tmpfs   nodev,nosuid         0      0
    tmpfs           /tmp          tmpfs   nodev,noexec,nosuid  0      0

    /dev/sda1       /             reiser4 defaults,noatime,notail 0   1
    /dev/sda2       /mnt/oldroot  ext4    defaults                0   0
    /dev/sda3       /boot         ext2    defaults                0   1

Bootloader Examples
-------------------

/boot/grub/grub.cfg:

    # (0) Arch Linux
    title  Arch Linux
    set root='(hd0,msdos3'
    kernel /vmlinuz-linux '''root=/dev/sda3''' ro noatime notail acl init=/sbin/bootchartd
    initrd /initramfs-linux.img

    # (1) Arch Linux
    title  Arch Linux Fallback
    set root='(hd0,msdos3'
    kernel /vlinuz-linux '''root=/dev/sda3''' ro
    initrd /initramfs-linux.img

Run grub-mkconfig to update your config:

    # grub-mkconfig -o /boot/grub/grub.cfg

/etc/lilo.conf:

    #
    # /etc/lilo.conf
    #

    boot=/dev/hda
    # This line often fixes L40 errors on bootup
    # disk=/dev/hda bios=0x80

    default=Arch4
    timeout=20
    lba32
    prompt
    compact

    image=/boot/vmlinuz-linux
            label=Arch4
            root=/dev/hda5
            append="video=vesafb:1024x768-24@56,ywrap,mtrr splash=verbose,theme:darch console=tty1 resume2=swap:/dev/hdb1"
    initrd=/boot/initramfs-linux.img
    read-only

    image=/boot/vmlinuz-linux
            label=Arch
            root=/dev/hda3
            append="video=vesafb:1024x768-24@56,ywrap,mtrr splash=verbose,theme:darch console=tty1 resume2=swap:/dev/hdb1"
    initrd=/boot/initramfs-linux.img
    read-only

Run lilo to update your config:

    # lilo

Troubleshooting
---------------

-   Permissions: chown -R username.group <userdir>
-   If you have problem with su command after the change of fs, you
    should reinstall coreutils package.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Reiser4&oldid=220073"

Category:

-   File systems
