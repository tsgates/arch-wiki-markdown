Flashing BIOS from Linux
========================

This article aims on providing information on flashing your system BIOS
under Linux. Most manufacturers provide a Windows executable or a BIOS
executable that can only be run under Windows. However, there are a few
utilities, that allow you to upgrade your system BIOS under Linux.

Warning:Flashing motherboard BIOS is a dangerous activity that can
render your motherboard inoperable! While the author of this article has
successfully run this procedure many times, your mileage may vary. Be
careful! You may want to consider updating microcode instead if it is
supported by your system.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 BiosDisk                                                           |
|     -   2.1 Installation                                                 |
|     -   2.2 Usage                                                        |
|                                                                          |
| -   3 Flashrom                                                           |
|     -   3.1 Installation                                                 |
|         -   3.1.1 Method 1: Official repositories (Recommended)          |
|         -   3.1.2 Method 2: AUR                                          |
|                                                                          |
|     -   3.2 Usage                                                        |
|                                                                          |
| -   4 FreeDOS                                                            |
|     -   4.1 Unetbootin                                                   |
|     -   4.2 Gentoo                                                       |
|     -   4.3 Images that are too large for a floppy                       |
|     -   4.4 Usage                                                        |
+--------------------------------------------------------------------------+

Introduction
------------

There are a few ways that you can use to flash the system BIOS under
Linux.

BiosDisk
--------

BiosDisk BiosDisk simplifies the process of flashing your system BIOS
under Linux

> Installation

biosdisk-git is available from the AUR.

> Usage

To use the biosdisk utility to create a BIOS flash image, first download
the latest raw BIOS image for your system from your manufacturer's
website. Make sure however, that you always get the BIOS executable and
NOT the Windows executable. You then have one of several options: create
a floppy, create a dd floppy image, create a user-installable
distribution-specific package (e.g. RPM), or actually install the image
for your bootloader.

-   The mkfloppy action will create the biosdisk image and write it
    directly to a floppy disk. Usage is the following:

        biosdisk mkfloppy [-o option] [-d device] [-k baseimage] /path/to/.exe 

-   The mkimage action will create a floppy image on the user's hard
    drive. Usage is the following:

        biosdisk mkimage [-o option] [-i destination] [-k baseimage] /path/to/.exe 

-   The mkpkg action will create the floppy image, and use it to create
    a user-installable package specific to the distribution (example:
    RPM). When the package is installed, it will use the distribution's
    built-in tools to update the system's bootloader so that the user
    can boot to the image from the hard drive to flash the BIOS, without
    needing a floppy drive. Currently only Red Hat/Fedora RPM packages
    are supported. Usage is as follows:

        biosdisk mkpkg [-o option] [--install] [--distro=] [--name=] [--version=] [--release=] /path/to/{.exe | .img}

-   The install action will create the biosdisk image, copy the image
    file to /boot, and then update the bootloader with an entry for the
    image. Then all the user has to do is boot the system and select the
    image to flash the BIOS; this will load the biosdisk image directly
    from the hard drive and flash the BIOS.

        biosdisk install [-o option] [--name=] /path/to/{.exe | .img}

Flashrom
--------

Flashromis a utility for identifying, reading, writing, verifying and
erasing flash chips. It is designed to flash
BIOS/EFI/coreboot/firmware/optionROM images on mainboards,
network/graphics/storage controller cards, and various programmer
devices.

> Installation

Method 1: Official repositories (Recommended)

Install the flashrom package from the official repositories.

Method 2: AUR

flashrom-svn is also available in the AUR.

> Usage

Find out if your motherboard and chipset is supported by flashrom at
this website. Supported Hardware You can also find out if your hardware
is supported by issuing the following command

    sudo flashrom

The above command will tell you your motherboard and chipset. You can
then find out if your's is supported by issuing this command

    flashrom -L | grep whatevernameyougotfromthefirstcommand

Read the BIOS image into a file:

     $ flashrom -r backup.bin

Write a BIOS image (proprietary or LinuxBIOS) on the ROM chip:

     $ flashrom -w newbios.bin
     $ flashrom -v newbios.bin

FreeDOS
-------

FreeDOS a free DOS-compatible operating system, is up to the challenge,
no need for proprietary DOS versions. So, all you need is a bootable
floppy disk image with FreeDOS kernel on it.

> Unetbootin

By far the easiest way to make a bootable FreeDOS USB Stick is using
unetbootin, available in the Official Repositories.

You should format a pendrive with FAT16 and flag it as "boot" (you may
do this through a GUI with gparted, qtparted or partitionmanager). Then,
after mounting the flash drive, select under distribution FreeDOS and
your mounted stick. The app will automatically download the image for
you and copy it to the drive. Finally, you may copy everything you want
to flash there (BIOS, firmwares, etc).

If you want to do it the hard way, keep reading. ;)

> Gentoo

Check out FreeDOS Flash Drive on the Gentoo Wiki if you want to create a
bootable FreeDOS Flash drive.

> Images that are too large for a floppy

If your flash image is too large for a floppy, go to the FreeDos
bootdisk website, and download the 10Mb hard-disk image. This image is a
full disk image, including partitions, so adding your flash utility will
be a little trickier:

    # modprobe loop
    # losetup /dev/loop0 <image-file>
    # fdisk -lu /dev/loop0

You can do some simply maths now: block size (usually 512) times the
start of the first partition. At time of writing, the first partition
starts at block 63. This means that the partitions starts at offset 512
* 63 = 32256:

    # mount -o offset=32256 /dev/loop0 /mnt

Now you can copy your flash utility onto the filesystem as normal. Once
you're done:

    # umount /mnt
    # losetup -d /dev/loop0

The image can now be copied to a USB stick for booting, or booted as a
memdisk as per normal instructions.

> Usage

Step 1: Download FreeDOS boot disk floppy image We are fortunate that
guys at FDOS site have prepared one suitable for us. Use the OEM
Bootdisk version, the one with just kernel and command.com, because it
leaves more free space on disk for the flash utility and new BIOS image.
After you download the image, you need to decompress it. In other words:

    wget http://www.fdos.org/bootdisks/autogen/FDOEM.144.gz
    gunzip FDOEM.144.gz

Step 2: Copy your BIOS flash utility and new BIOS image to the mounted
floppy disk image

Requirement for this step is that you have support for the vfat and loop
file systems in the kernel. Or you can have those features compiled as
modules. In the latter case, load the modules before the next step, like
this.

    modprobe vfat
    modprobe loop

Consult /proc/fileystems to see if you have the needed file systems
supported. If you do, you should be able to "loop mount" the floppy disk
image to some temporary path:

    mkdir /tmp/floppy
    mount -t vfat -o loop FDOEM.144 /tmp/floppy

If the mount went without errors, copy BIOS flash utility and new BIOS
image to the mounted floppy disk image. You'll probably have to unzip
the archive you downloaded from your motherboard vendor site, to get to
those two files. Here's just an example for my motherboard (in your
case, files will have different names, of course):

    # unzip 775Dual-VSTA\(2.60\).zip
    Archive: 775Dual-VSTA(2.60).zip
     inflating: 75DVSTA2.60
     inflating: ASRflash.exe
    # cp 75DVSTA2.60 ASRflash.exe /tmp/floppy

Doublecheck that everything went OK, that those two files weren't too
big for the floppy:

    Filesystem           1K-blocks      Used Available Use% Mounted on
    /tmp/FDOEM.144
                             1424       990       434  70% /tmp/floppy

Finally, unmount the floppy disk image:

    umount /tmp/floppy

Step 3: Burn a bootable CD which will emulate floppy device for us

Next step is to burn the floppy image to a CD/DVD-RW media, but in a way
that it can be booted afterwards. First we need to make a bootable CD
image, and then burn it. Notice that on some modern distributions,
cdrecord is renamed to wodim, and mkisofs to genisoimage, but the
parameters below should be the same.

    mkisofs -o bootcd.iso -b FDOEM.144 FDOEM.144
    cdrecord -v bootcd.iso

Alternative Step 3: Add your image to Grub's menu. You will need to
install syslinux and copy memdisk to /boot, and put your image there as
well.

     cp /usr/lib/syslinux/memdisk /boot
     cp FDOEM.144 /boot/flashbios.img

Now add an entry to your /boot/grub/menu.lst:

     title Flash BIOS
     kernel /memdisk
     initrd /flashbios.img

Or for GRUB2 in /boot/grub/grub.cfg:

     menuentry "Flash BIOS" {
     linux16 /boot/memdisk
     initrd16 /boot/flashbios.img
     }

Step 4: Reboot, flash, reboot, enjoy your new BIOS

Finally reboot your machine, make sure that your CD drive is first in
the boot sequence, and then run your BIOS upgrade procedure when the CD
boots. If using the GRUB method, just choose the new entry on the list,
and it should boot into FreeDOS.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Flashing_BIOS_from_Linux&oldid=255089"

Category:

-   Mainboards and BIOS
