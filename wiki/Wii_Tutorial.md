Wii Tutorial
============

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: kernel26         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This tutorial is targeted at those who may want to try running Arch
Linux on a Nintendo Wii.

The Nintendo Wii is a gaming console with limited memory resources as
the Nintendo GameCube was. Nevertheless, it incorporates a faster
processor, consumes less power, and has a richer set of peripheral
options. It is a relatively silent system as well, at least when the DVD
unit is not spinning, and has a small thermal footprint.

All of these characteristics make the Nintendo Wii console suitable for
becoming a small PowerPC Linux system on the cheap.

Note: Although installation via other operating systems may be possible,
the following instructions apply to Linux operating systems only.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation pre-requisites                                        |
|     -   1.1 USB Setup                                                    |
|     -   1.2 SD Setup                                                     |
|     -   1.3 NFS Setup                                                    |
|     -   1.4 Things To Remember                                           |
|                                                                          |
| -   2 Preface: Setting up things                                         |
|     -   2.1 Preparing partitions                                         |
|     -   2.2 Preparing your NFS Share                                     |
|     -   2.3 Preparing bootloader                                         |
|                                                                          |
| -   3 Installing Arch Linux on your Wii                                  |
|     -   3.1 Installing the kernel                                        |
|         -   3.1.1 USB Setup                                              |
|         -   3.1.2 NFS Share                                              |
|         -   3.1.3 Installing for loading with BootMii                    |
|                                                                          |
|     -   3.2 Installing the userland                                      |
|         -   3.2.1 Installing firmware for the WLAN card                  |
|         -   3.2.2 Finishing up                                           |
|                                                                          |
|     -   3.3 Booting                                                      |
|         -   3.3.1 Last minute hardware checks                            |
|         -   3.3.2 Booting from BootMii                                   |
|                                                                          |
|     -   3.4 Post installation                                            |
|         -   3.4.1 Xorg Video Driver                                      |
|         -   3.4.2 Use a Wiimote for Your Mouse                           |
|         -   3.4.3 Installing More Packages                               |
|         -   3.4.4 kernel26-mike                                          |
|         -   3.4.5 Tips                                                   |
|                                                                          |
| -   4 Arch Wii Art                                                       |
| -   5 Tarballs                                                           |
| -   6 External links                                                     |
+--------------------------------------------------------------------------+

Installation pre-requisites
---------------------------

-   A working Linux system, where you can run root-privileged commands
-   An SD card reader
-   Partitioning software, like the fdisk utility
-   FAT16 filesystem utility, like the mkfs.vfat
-   A Wii.
-   A keyboard

> USB Setup

-   A USB Stick
-   An SD card (it can be a small 32MB one)
-   ext2 filesystem utility, like mkfs.ext2

> SD Setup

-   An SD card (at least 2GB is recomended)
-   ext2 filesystem utility, like mkfs.ext2

> NFS Setup

-   An SD card (it can be a small 32MB one)
-   USB Lan Adapter (must be compatible with the Linux Kernel) or a
    wireless connection.

> Things To Remember

-   Only mount your swap partition if needed as it will shorten the life
    of your SD card or USB Thumb Drive, if you use a external HDD then
    this is not an issue.

Preface: Setting up things
--------------------------

required dependencies: (dosfstools, you can get this by typing Pacman -S
dosfstools in your terminal)

> Preparing partitions

Required partitions:

-   A primary FAT16 type partition on the first partition of SD card to
    store the "bootloader", kernel, your homebrew applications and/or
    your console save data information. The kernel requires only a few
    megabytes. The size of this partition should be estimated based on
    the other applications requirements.

-   A primary ext2 partition or alternatively an NFS share for the root
    filesystem

-   A swap partition

The instructions will assume that your SD card is seen in Linux as a
device node named /dev/sdd. The actual device node name will depend on
your Linux distribution, your SD card reader type and your existing
hardware. Usually, SD cards will end up having names like
/dev/sd<letter>.

Warning: Triple-check that you are using the right device name,
otherwise you risk wiping other block devices including your
harddisks!!!

    DISCLAIMER:

    THE FOLLOWING PROCESS WILL ERASE THE CONTENTS OF YOUR SD CARD.
    BACKUP THE DATA ON THE SD CARD BEFORE CONTINUING IF YOU WISH TO PRESERVE ANY
    INFORMATION.
    USING PARTITIONING SOFTWARE WITHOUT UNDERSTANDING HOW IT WORKS CAN
    LEAD TO DATA LOSS.

A primary FAT16 type partition on the first partition of the SD card:

-   Unmount all the SD card partitions, if mounted.

    $ df | grep /dev/sdd
    /dev/sdd1            501688     49488    452200  10% /media/disk
    $ sudo umount /media/disk

-   Start the `fdisk' utility from a shell prompt.

    $ sudo /sbin/fdisk /dev/sdd

-   Remove all SD card partitions by creating an empty partition table
    using fdisk command 'o'.

    Command (m for help): o
    Building a new DOS disklabel. Changes will remain in memory only,
    until you decide to write them. After that, of course, the previous
    content won't be recoverable.

-   Create a primary FAT16 type partition on the first partition. You
    may adjust the size according to your requirements

    Command (m for help): n
    Command action
       e   extended
       p   primary partition (1-4)
    p
    Partition number (1-4): 1
    First cylinder (1-990, default 1): <RETURN>
    Using default value 1
    Last cylinder or +size or +sizeM or +sizeK (1-990, default 990): +256M

    Command (m for help): t
    Selected partition 1
    Hex code (type L to list codes): 6
    Changed system type of partition 1 to 6 (FAT16)

-   Write the new partition layout to the SD card.

    Command (m for help): w
    The partition table has been altered!

    Calling ioctl() to re-read partition table.

    Syncing disks.

-   Create a FAT16 filesystem on the first partition and label it
    "boot".

    sudo /sbin/mkfs.vfat -n boot /dev/sdd1

  

A primary ext2 partition for the root filesystem. You can use a USB
stick or an SD card for this. Alternatively an NFS share can be used.
For example, creating the partition on the same SD card:

    $ sudo /sbin/fdisk /dev/sdd

    Command (m for help): n
    Command action
       e   extended
       p   primary partition (1-4)
    p
    Partition number (1-4): 2
    First cylinder (136-990, default 136): <RETURN>
    Using default value 136
    Last cylinder or +size or +sizeM or +sizeK (126-990, default 990): +1600M

    Command (m for help): w
    The partition table has been altered!

    Calling ioctl() to re-read partition table.

    Syncing disks.

    sudo /sbin/mkfs.ext2 -L archii /dev/sdd2

  
 A swap partition. You can use a USB stick or an SD card for this. SD
card is recommend as write speed to the SD card is faster, and swap is
always changing. For example, creating a 128MB partition on the same SD
card:

    $ sudo /sbin/fdisk /dev/sdd

    Command (m for help): n
    Command action
       e   extended
       p   primary partition (1-4)
    p
    Partition number (1-4): 3
    First cylinder (923-990, default 923): <RETURN>
    Using default value 923
    Last cylinder or +size or +sizeM or +sizeK (923-990, default 990): +128M

    Command (m for help): t
    Partition number (1-4): 2 
    Hex code (type L to list codes): 82
    Changed system type of partition 3 to 82 (Linux swap / Solaris)

    Command (m for help): w
    The partition table has been altered!

    Calling ioctl() to re-read partition table.

    Syncing disks.

    sudo /sbin/mkswap /dev/sdd3

> Preparing your NFS Share

You really do not need to do much here other than make sure you have a
few gig's to spare on w/e machine you host the share on. See the
Gamecube_Tutorial for more information. If someone who knows more about
NFS shares wants to and more information go please do so.

> Preparing bootloader

See http://bootmii.org/ for information how to install HBC and/or
BootMii version beta 3 or later on your Wii. Installing both is
recommended

Installing Arch Linux on your Wii
---------------------------------

> Installing the kernel

The Kernel can be obtained from
http://sourceforge.net/projects/gc-linux/files/kernel/ until they are
included in the Arch Linux PPC repositories.

Test Wii kernels for Arch Linux PPC can be found at
http://jonimoose.net/archii/ but you will most likely have to hex edit
them for your specific rootfs location and video mode, see below.

Choose the one matching your video mode or if you are booting with
elf/dol loader choose the *.ios.elf kernel

Mount the FAT16 partition on your SD card. For example:

    $ sudo mkdir /media/boot
    $ sudo mount /dev/sdd1 /media/boot

USB Setup

Because the command line arguments are compiled into the kernel you will
need to edit it with a hex editor like GHex to mount the correct root
file system. When you open it up in the hex editor just do a search for
"root=" and you'll find the location.

NFS Share

Because the command line arguments are compiled into the kernel you will
need to edit it with a hex editor like GHex to mount the correct root
file system. The Gamecube Tutorial has the correct information on what
you'll need to change them to. When you open it up in the hex editor
just do a search for "root=" and you'll find the location. Just remember
that you cannot use more space than what is provided.

Installing for loading with BootMii

Copy the kernel elf file to the root of the FAT16 partition. e.g to
/media/boot/

> Installing the userland

Save this somewhere as you'll be needing it:

    #
    # /etc/pacman.conf
    #
    # See the pacman.conf(5) manpage for option and repository directives

    #
    # GENERAL OPTIONS
    #
    [options]
    # The following paths are commented out with their default values listed.
    # If you wish to use different paths, uncomment and update the paths.
    #RootDir     = /
    #DBPath      = /var/lib/pacman/
    #CacheDir    = /var/cache/pacman/pkg/
    #LogFile     = /var/log/pacman.log
    HoldPkg     = pacman glibc
    # If upgrades are available for these packages they will be asked for first
    SyncFirst   = pacman
    #XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
    #XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
    #XferCommand = /usr/bin/curl %u > %o

    # Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
    #IgnorePkg   =
    #IgnoreGroup =

    #NoUpgrade   =
    #NoExtract   =

    # Misc options (all disabled by default)
    #NoPassiveFtp
    #UseSyslog
    #ShowSize
    #UseDelta
    #TotalDownload
    #
    # REPOSITORIES
    #   - can be defined here or included from another file
    #   - pacman will search repositories in the order defined here
    #   - local/custom mirrors can be added here or in separate files
    #   - repositories listed first will take precedence when packages
    #     have identical names, regardless of version number
    #   - URLs will have $repo replaced by the name of the current repo
    #
    # Repository entries are of the format:
    #       [repo-name]
    #       Server = ServerName
    #       Include = IncludePath
    #
    # The header [repo-name] is crucial - it must be present and
    # uncommented to enable the repo.
    #
    #

    # Testing is disabled by default.  To enable, uncomment the following
    # two lines.  You can add preferred servers immediately after the header,
    # and they will be used before the default mirrors.
    #[testing]
    #Include = /etc/pacman.d/mirrorlist

    [core]
    # Add your preferred servers here, they will be used first
    Server = ftp://archlinuxppc.org/$repo/os/ppc/
    Server = http://bauer.dnsdojo.com/repo/$repo/ppc
    Server = ftp://bauer.dnsdojo.com/repo/$repo/ppc

    [extra]
    # Add your preferred servers here, they will be used first
    Server = ftp://archlinuxppc.org/$repo/os/ppc/
    Server = http://bauer.dnsdojo.com/repo/$repo/ppc
    Server = ftp://bauer.dnsdojo.com/repo/$repo/ppc 

    [archii]
    #Server = http://thestorm.taricorp.net/repo/ppc/$repo repo down due to a hosting issue, thanks to whoever mirrored it
    Server = http://bauer.dnsdojo.com/repo/$repo/ppc
    Server = ftp://bauer.dnsdojo.com/repo/$repo/ppc

    # An example of a custom package repository.  See the pacman manpage for
    # tips on creating your own repositories.
    #[custom]
    #Server = file:///home/custompkgs

Mount the root partition off of your SD/USB if it's not already mounted.
For example with the partition table created above:

    $ sudo mkdir /media/archii
    $ sudo mount /dev/sdd2 /media/archii

Substitute from the following commands:

-   <rootfs> with the mountpoint of the root filesystem. e.g
    /media/archii MAKE SURE IT'S NOT A RELATIVE PATH (NO ./)
-   <file you saved> with path to the file you saved from above. e.g
    /home/user/pacman.conf

Warning: mistyping these commands can cause damage your system.

Create a directory for the pacman database:

    mkdir -p <rootfs>/var/lib/pacman

Sync pacman with the file you saved earlier.

    pacman --root <rootfs> --cachedir <rootfs>/var/cache/pacman/pkg --config <file you saved> -b <rootfs>/var/lib/pacman -Sy

If your host system is not Arch linux, you may need to copy or link the
install-info package to /usr/bin,

    ln -sf <rootfs>/usr/bin/install-info /usr/bin

Install base and base-devel package groups:

    pacman --root <rootfs> --cachedir <rootfs>/var/cache/pacman/pkg --config <file you saved> -b <rootfs>/var/lib/pacman -S base base-devel

If your host system is not Arch linux, you may need to bind mount the
info directory on the current filesystem so that the installation does
not overwrite your hosts info directory. If the previous command fails
with "error: command failed to execute correctly", then you should try
the following:

    mount --bind <rootfs>/usr/share/info /usr/share/info
    rm /usr/share/info/dir
    for j in $( { for i in /usr/share/info/*.info /usr/share/info/*.gz; do echo "$i" | sed -r 's/-([0-9]+)\.gz$/\.gz/g'; done; } | uniq) ; do install-info "$j" /usr/share/info/dir; done

Then retry the installation of base and base-devel package.

And remove the bind mount afterwards:

    umount /usr/share/info

Edit <rootfs>/etc/fstab according to your partition table. Example
/etc/fstab for the partition table created above:

    /dev/mmcblk0p2          /            ext2      defaults,noatime            0 1
    /dev/mmcblk0p1          /boot        vfat      defaults,noatime            0 1

    tmpfs                   /var/log     tmpfs     size=16m                    0 0

tmpfs line is optional. It keeps /var/log directory in RAM, reducing
disk writes to the SD card. Note that the files are lost after reboot.

noatime option is also optional. It disables recording of the last file
access time when the file is just read, reducing disk writes to the SD
card.

Edit <rootfs>/etc/rc.conf and change your hostname, and if you have a
ethernet adapter, configure internet as well. See Configuring Network
for information about configuring your network.

Copy the file you saved earlier to <rootfs>/etc/pacman.conf.

    sudo cp <file you saved> <rootfs>/etc/pacman.conf

Installing firmware for the WLAN card

First, try installing via pacman. If this succeeds, you do not need to
try the other commands in this section:

    pacman --root <rootfs> --cachedir <rootfs>/var/cache/pacman/pkg --config <file you saved> -b <rootfs>/var/lib/pacman -S openfwwf

The system provided firmware for the WLAN card to operate can be build
on the host computer or later on the Wii.

Instructions for building it on the host computer:

Build openfwwf from the AUR, but do not install it on the host computer.

Install it to your Wii root filesystem with command:

    pacman --root <rootfs> --cachedir <rootfs>/var/cache/pacman/pkg --config <file you saved> -b <rootfs>/var/lib/pacman -U openfwwf-*.pkg.tar.gz

The WLAN card is now ready to be configured. See Wireless for more
information how to configure your WLAN connection.

Finishing up

You can now unmount your USB stick, SD card, etc. For example:

    sudo umount /media/boot
    sudo umount /media/archii

> Booting

Last minute hardware checks

If you own a LAN Adapter, make sure that it is properly connected to
your Nintendo Wii console and to your LAN.

Verify that a USB keyboard is connected to your Nintendo Wii console.

Booting from BootMii

From the BootMii menu, select the SD card icon with power and reset
buttons. From the SD card menu select the kernel file you copied
earlier. The Arch Linux system should now initialize. Login as root and
change the root password.

> Post installation

Your Wii installation acts as a standard Arch Linux system. If you are
new to Arch, The Beginners Guide is a good place to start configuring
your system.

Xorg Video Driver

xf86-video-cube the gamecube/wii xorg driver is now in the Arch Linux
PPC repo's so it no longer needs to be built from source.

     pacman --root <rootfs> --cachedir <rootfs>/var/cache/pacman/pkg --config <file you saved> -b <rootfs>/var/lib/pacman -S xf86-video-cube 

From your desktop, if already booted on the Wii all that is needed is:

     pacman -S xf86-video-cube

Use a Wiimote for Your Mouse

Newer kernels will soon enable your sensor bar by default but for now
edit your rc.local to include these lines:

    #Sensor Bar
    echo 247 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio247/direction
    echo 1 > /sys/class/gpio/gpio247/value

Next install cwiid or cwiid-svn from the AUR. Finally, as root, start
cwiid

    wminput -c ir_ptr -w

Installing More Packages

If you do not have an ethernet adapter or a wireless connection, then
you may install more packages by mounting your root filesystem on your
PC and typing this:

    pacman --root <rootfs> --cachedir <rootfs>/var/cache/pacman/pkg --config <file you saved> -b <rootfs>/var/lib/pacman -Sy <package name>

kernel26-mike

https://aur.archlinux.org/packages.php?ID=29693

There's also PKGBUILD for the Mini kernel and modules that can be
installed from AUR. Note that you need to manually change the videomodes
and/or root filesystem location with a hexeditor if needed.

Tips

You need to have some swap space in order to generate locales and you
may want it for compiling packages that are not in the repos. You can
enable the swap partition with the command 'swapon'. With partition
table created above:

    swapon /dev/mmcblk0p3

Arch Wii Art
------------

-   Arch-Wii wallpaper by Ghost1227

Tarballs
--------

zc00gii made a minimal Archii tarball. There is only a root account,
with no password.
http://thestorm.taricorp.net/archii/tarballs/archii-minimum-2009-06-23.tar.bz2
(link broken I will recreate the tar when I have a chance)

Storm/JonimusPrime made a tarball with X11 configured. The password is
for both root and user archie is
'arch'.ftp://ftp.archlinuxppc.org/other/wii/archii.tar.xz The
accompanying kernel can be gotten from here

External links
--------------

-   http://bootmii.org/
-   http://gc-linux.org/
-   http://gc-linux.cvs.sourceforge.net/viewvc/gc-linux/xf86-video-cube/
-   http://www.gc-linux.org/wiki/MINI:KernelPerformanceComparisonVsIOS

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wii_Tutorial&oldid=225339"

Category:

-   PowerPC
