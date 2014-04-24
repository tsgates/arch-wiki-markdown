Installing Arch Linux on ZFS
============================

Related articles

-   ZFS
-   Playing with ZFS
-   ZFS Installation
-   ZFS on FUSE

This article details the steps required to install Arch Linux onto a
root ZFS filesystem. This article supplements the Beginners' guide.

Contents
--------

-   1 Installing archzfs
    -   1.1 Embedding archzfs into archiso
    -   1.2 Using the archzfs repository
-   2 Partition the destination drive
    -   2.1 Partition scheme
-   3 Format the destination disk
-   4 Setup the ZFS filesystem
    -   4.1 Create the root zpool
    -   4.2 Create necessary filesystems
    -   4.3 Swap partition
    -   4.4 Configure the root filesystem
-   5 Install and configure Arch Linux
-   6 Install and configure the bootloader
    -   6.1 For BIOS motherboards
    -   6.2 For UEFI motherboards
-   7 Unmount and restart
-   8 After the first boot
-   9 See also

Installing archzfs
------------------

Using the archzfs repository is highly recommended for effortless
updates.

Warning:The ZFS packages are tied to the kernel version they were built
against. This means it will not be possible to perform kernel updates
until new packages (or package sources) are released by the ZFS package
maintainer.

Note:This guide uses the unofficial archzfs repository hosted at
http://demizerone.com/demz-repo-core. This repository is maintained by
Jesus Alvarez and is signed with his PGP key: 0EE7A126.

> Embedding archzfs into archiso

See ZFS article.

> Using the archzfs repository

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Unofficial  
                           user repositories.       
                           Notes: See               
                           Help:Style#Unofficial    
                           repositories for         
                           details. (Discuss)       
  ------------------------ ------------------------ ------------------------

Activate the required network connection and then edit
/etc/pacman.d/mirrorlist and configure the mirrors for pacman to use.
Once that is done, edit /etc/pacman.conf and add the archzfs repository:

    [demz-repo-core]
    Server = http://demizerone.com/$repo/$arch

Note:You should change the repo name from 'demz-repo-core' to
'demz-repo-archiso' if you are using the standard Arch ISOs to install
(did not build your own, above).

Next, add the archzfs maintainer's PGP key to the local trust:

    # pacman-key -r 0EE7A126
    # pacman-key --lsign-key 0EE7A126

Note:The repository maintainer is recovering from surgery and has
temporarily handed publish control to someone else so you may need to
use that key instead: 5EE46C4C [1]

Finally, update the pacman databases and install archzfs:

    # pacman -Syy archzfs

Tip:This is also the best time to install your favorite text editor
(otherwise nano or vi will have to be used) and the proper partition
tools: for UEFI and GPT install dosfstools and gptfdisk.

Partition the destination drive
-------------------------------

Review Beginners' guide#Prepare_the_storage_drive for information on
determining the partition table type to use for ZFS. ZFS supports GPT
and MBR partition tables.

ZFS manages its own partitions, so only a basic partition table scheme
is required. The partition that will contain the ZFS filesystem should
be of the type bf00, or "Solaris Root".

> Partition scheme

Here is an example, using MBR, of a basic partition scheme that could be
employed for your ZFS root setup:

    Part     Size   Type
    ----     ----   -------------------------
       1     512M   Ext boot partition (8300)
       2     XXXG   Solaris Root (bf00)

Here is an example using GPT. The BIOS boot partition contains the
bootloader.

    Part     Size   Type
    ----     ----   -------------------------
       1       2M   BIOS boot partition (ef02)
       1     512M   Ext boot partition (8300)
       2     XXXG   Solaris Root (bf00)

An additional partition may be required depending on your hardware and
chosen bootloader. Consult Beginners'
guide#Install_and_configure_a_bootloader for more info.

Tip:Bootloaders with support for ZFS are described in #Install and
configure the bootloader.

Format the destination disk
---------------------------

Format the boot partition as well as any other system partitions. Do not
do anything to the Solaris partition nor to the BIOS boot partition. ZFS
will manage the first, and your bootloader the second.

Setup the ZFS filesystem
------------------------

First, make sure the ZFS modules are loaded,

    # modprobe zfs

> Create the root zpool

    # zpool create zroot /dev/disk/by-id/id-to-partition

Warning:Always use id names when working with ZFS, otherwise import
errors will occur.

> Create necessary filesystems

If so desired, sub-filesystem mount points such as /home and /root can
be created with the following commands:

    # zfs create zroot/home -o mountpoint=/home
    # zfs create zroot/root -o mountpoint=/root

Note that if you want to use other datasets for system directories (/var
or /etc included) your system will not boot unless they are listed in
/etc/fstab! We will address that at the appropriate time in this
tutorial.

> Swap partition

ZFS does not allow the use swapfiles, but it is possible to use a ZFS
volume as swap partition. It is important to set the ZVOL block size to
match the system page size; for x86_64 systems that is 4k.

Create a 8 GB (or whatever is required) ZFS volume:

    # zfs create -V 8G -b 4K zroot/swap

Initialize and enable the volume as a swap partition:

    # mkswap /dev/zvol/zroot/swap
    # swapon /dev/zvol/zroot/swap

After using pacstrap to install the base system, edit /zroot/etc/fstab
to ensure the swap partition is mounted at boot:

    /dev/zvol/zroot/swap none swap defaults 0 0

Make sure to unmount all ZFS filesystems before rebooting the machine,
otherwise any ZFS pools will refuse to be imported:

    # zfs umount -a

> Configure the root filesystem

First, set the mount point of the root filesystem:

    # zfs set mountpoint=/ zroot

and optionally, any sub-filesystems:

    # zfs set mountpoint=/home zroot/home
    # zfs set mountpoint=/root zroot/root

and if you have seperate datasets for system directories (ie /var or
/usr)

    # zfs set mountpoint=legacy zroot/usr
    # zfs set mountpoint=legacy zroot/var

and put them in /etc/fstab

    /etc/fstab

    # <file system>        <dir>         <type>    <options>             <dump> <pass>
    zroot/usr              /usr          zfs       defaults,noatime      0      0
    zroot/var              /var          zfs       defaults,noatime      0      0

Set the bootfs property on the descendant root filesystem so the boot
loader knows where to find the operating system.

    # zpool set bootfs=zroot zroot

Export the pool,

    # zpool export zroot

Warning:Do not skip this, otherwise you will be required to use -f when
importing your pools. This unloads the imported pool.

Note:This might fail if you added a swap partition above. Need to turn
it off with the swapoff command.

Finally, re-import the pool,

    # zpool import -d /dev/disk/by-id -R /mnt zroot

Note:-d is not the actual device id, but the /dev/by-id directory
containing the symbolic links.

If there is an error in this step, you can export the pool to redo the
command. The ZFS filesystem is now ready to use.

Be sure to bring the zpool.cache file into your new system. This is
required later for the ZFS daemon to start.

    # cp /etc/zfs/zpool.cache /mnt/etc/zfs/zpool.cache

if you don't have /etc/zfs/zpool.cache, create it:

    # zpool set cachefile=/etc/zfs/zpool.cache zroot

Install and configure Arch Linux
--------------------------------

Follow the following steps using the Beginners' guide. It will be noted
where special consideration must be taken for ZFSonLinux.

-   First mount any boot or system partitions using the mount command.

-   Install the base system.

-   The procedure described in Beginners' guide#Generate an fstab is
    usually overkill for ZFS. ZFS usually auto mounts its own
    partitions, so we do not need ZFS partitions in fstab file, unless
    the user made datasets of system directories. To generate the fstab
    for filesystems, use:

    # genfstab -U -p /mnt | grep boot >> /mnt/etc/fstab

-   Edit the /etc/fstab:

> Note:

-   If you chose to create datasets for system directories, keep them in
    this fstab! Comment out the lines for the '/, /root, and /home
    mountpoints, rather than deleting them. You may need those UUIDs
    later if something goes wrong.
-   Anyone who just stuck with the guide's directions can delete
    everything except for the swap file and the boot/EFI partition. It
    seems convention to replace the swap's uuid with
    /dev/zvol/zroot/swap.

-   When creating the initial ramdisk, first edit /etc/mkinitcpio.conf
    and add zfs before filesystems. Also, move keyboard hook before zfs
    so you can type in console if something goes wrong. You may also
    remove fsck (if you are not using Ext3 or Ext4). Your HOOKS line
    should look something like this:

    HOOKS="base udev autodetect modconf block keyboard zfs filesystems"

-   Regenerate the initramfs with the command:

    # mkinitcpio -p linux

Install and configure the bootloader
------------------------------------

> For BIOS motherboards

Follow GRUB#BIOS_systems_2 to install GRUB onto your disk. grub-mkconfig
does not properly detect the ZFS filesystem, so it is necessary to edit
grub.cfg manually:

    /boot/grub/grub.cfg

    set timeout=2
    set default=0

    # (0) Arch Linux
    menuentry "Arch Linux" {
        set root=(hd0,msdos1)
        linux /vmlinuz-linux zfs=zroot
        initrd /initramfs-linux.img
    }

if you did not create a separate /boot participation, kernel and initrd
paths have to be in the following format:

     /dataset/@/actual/path  

Example:

       linux /@/boot/vmlinuz-linux zfs=zroot
       initrd /@/boot/initramfs-linux.img

> For UEFI motherboards

Use EFISTUB and rEFInd for the UEFI boot loader. See Beginners'
guide#For UEFI motherboards. The kernel parameters in refind_linux.conf
for ZFS should include zfs=bootfs or zfs=zroot so the system can boot
from ZFS. The root and rootfstype parameters are not needed.

Unmount and restart
-------------------

We are almost done!

    # exit
    # umount /mnt/boot
    # zfs umount -a
    # zpool export zroot

Now reboot.

Warning:If you do not properly export the zpool, the pool will refuse to
import in the ramdisk environment and you will be stuck at the busybox
terminal.

After the first boot
--------------------

If everything went fine up to this point, your system will boot. Once.
For your system to be able to reboot without issues, you need to enable
the zfs service and set the hostid.

When running ZFS on root, the machine's hostid will not be available at
the time of mounting the root filesystem. There are two solutions to
this. You can either place your spl hostid in the kernel parameters in
your boot loader. For example, adding spl.spl_hostid=0x00bab10c.

The other solution is to make sure that there is a hostid in
/etc/hostid, and then regenerate the initramfs image. Which will copy
the hostid into the initramfs image.

    # hostid > /etc/hostid
    # mkinitcpio -p linux

Your system should work and reboot properly now.

See also
--------

-   HOWTO install Ubuntu to a Native ZFS Root
-   ZFS cheatsheet
-   Funtoo ZFS install guide

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Arch_Linux_on_ZFS&oldid=301976"

Category:

-   Getting and installing Arch

-   This page was last modified on 25 February 2014, at 02:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
