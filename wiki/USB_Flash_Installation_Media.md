USB Flash Installation Media
============================

Related articles

-   CD Burning
-   Archiso

This page discusses various mutiplatform methods on how to create a Arch
Linux Installer USB drive (also referred to as "flash drive", "USB
stick", "USB key", etc) for booting in BIOS and UEFI systems. The result
will be a LiveUSB (LiveCD-like) system that can be used for installing
Arch Linux, system maintenance or for recovery purposes, and that,
because of the nature of SquashFS, will discard all changes once the
computer shuts down.

If you would like to run a full install of Arch Linux from a USB drive
(i.e. with persistent settings), see Installing Arch Linux on a USB key.
If you would like to use your bootable Arch Linux USB stick as a rescue
USB, see Change Root.

Contents
--------

-   1 BIOS and UEFI Bootable USB
    -   1.1 Using dd
        -   1.1.1 In GNU/Linux
        -   1.1.2 In Windows
            -   1.1.2.1 Using Universal USB Installer
            -   1.1.2.2 Using Cygwin
            -   1.1.2.3 dd for Windows
        -   1.1.3 In Mac OS X
        -   1.1.4 How to restore the USB drive
    -   1.2 Using manual formatting
        -   1.2.1 In GNU/Linux
        -   1.2.2 In Windows
-   2 Other Methods for BIOS systems
    -   2.1 In GNU/Linux
        -   2.1.1 Using UNetbootin
    -   2.2 In Windows
        -   2.2.1 Win32 Disk Imager
        -   2.2.2 USBWriter for Windows
        -   2.2.3 The Flashnul way
        -   2.2.4 Loading the installation media from RAM
            -   2.2.4.1 Preparing the USB flash drive
            -   2.2.4.2 Copy the needed files to the USB flash drive
            -   2.2.4.3 Create the configuration file
            -   2.2.4.4 Final steps
        -   2.2.5 Universal USB Installer
-   3 Troubleshooting
-   4 See Also

BIOS and UEFI Bootable USB
--------------------------

> Using dd

Note:This method is recommended due to its simplicity. If it does not
work switch to the alternative method #Using manual formatting below.

Warning:This will irrevocably destroy all data on /dev/sdx.

In GNU/Linux

Tip:Check that the USB flash installation media is not mounted with
lsblk.

Note:Use /dev/sdx instead of /dev/sdx1, and adjust x to reflect the
targeted device.

    # dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx && sync

Note:If you are using a previously bootable USB disk you need to
reformat it first.

In Windows

Using Universal USB Installer

This is probably the most straightforward way to create a bootable Arch
linux USB stick from Windows. Download Universal USB Installer, which
runs on Windows XP/Vista/7/8. There's no installation involved, you
directly download a single executable. Download the Arch iso file and
run Universal-USB-Installer-1.9.5.2.exe (the version numbers will vary).
The use of the program is fairly self-explanatory. You select the
distribution you'd like to create a bootable USB for (archlinux), the
iso file you downloaded, and the USB flash disk you want to install to.

Tip: The Arch syslinux installer uses the USB disk label to facilitate
mounting the correct drive. The current version of UUI (1.9.5.2) sets
the disk label to UUI, when Arch is expecting something else. You can
easily fix this by right clicking the USB drive icon and clicking on
Properties to change the label. For archlinux-2014.02.01-dual.iso, the
label should be ARCH_201402. It should be clear what the label should be
for other versions of the ISO, but in any case Arch will tell you what
the label needs to be if you attempt to boot from the USB with an
incorrect label.

Warning: Make sure you don't accidentally click on one of the ads on the
pendrivelinux.com page which feature prominent Download buttons -- these
are likely to carry virus/spyware/trojan payloads. The Pendrive download
button is small and near the middle of the page.

Using Cygwin

Make sure your Cygwin installation contains the dd package.

Tip:If you do not want to install Cygwin, you can download dd for
Windows from here. See the next section for more information.

Place your image file in your home directory:

    C:\cygwin\home\John\

Run cygwin as administrator (required for cygwin to access hardware). To
write to your USB drive use the following command:

    dd if=image.iso of=\\.\[x]: bs=4M

where image.iso is the path to the iso image file within the cygwin
directory and \\.\[x]: is your USB flash drive where x is the windows
designated letter, e.g. \\.\d:.

On Cygwin 6.0 find out the correct partition with:

    cat /proc/partitions

and write the ISO image with the information from the output. Example:

Warning:This will irrevocably delete all files on your USB flash drive,
so make sure you do not have any important files on the stick before
doing this.

    dd if=image.iso of=/dev/sdb bs=4M

dd for Windows

Note:Some users have an "isolinux.bin missing or corrupt" problem when
booting the media with this method.

A GPL licensed dd version for Windows is available at
http://www.chrysocome.net/dd. The advantage of this over Cygwin is a
smaller download. Use it as shown in instructions for Cygwin above.

To begin, download the latest version of dd for Windows. Once
downloaded, extract the archive's contents into Downloads or elsewhere.

Now, launch your command prompt as an administrator. Next, change
directory (cd) into the Downloads directory.

If your Arch Linux ISO is elsewhere you may need to state the full path,
for convenience you may wish to put the Arch Linux ISO into the same
folder as the dd executable. The basic format of the command will look
like this.

    dd if=archlinux-2013-XX-xx-dual.iso of=\\.\x: bs=4m

Warning:This command will replace the drive's contents and its
formatting with the ISO's. You will likely be unable to recover its
contents in the event of an accidental copy. Be absolutely sure that you
are directing dd to the correct drive before executing!

Simply replace the various null spots (indicated by an "x") with the
correct date and correct drive letter.

Here is a complete example.

    dd if=ISOs\archlinux-2013.08.01-dual.iso of=\\.\d: bs=4M

In Mac OS X

To be able to use dd on your USB device on a Mac you have to do some
special maneuvers. First of all insert your usb device, OS X will
automount it, and in Terminal.app run:

    $ diskutil list

Figure out what your USB device is called with mount or
sudo dmesg | tail (e.g. /dev/disk1) and unmount the partitions on the
device (i.e., /dev/disk1s1) while keeping the device proper (i.e.,
/dev/disk1):

    $ diskutil unmountDisk /dev/disk1

Now we can continue in accordance with the instructions above (but use
bs=8192 if you are using the OS X dd, the number comes from 1024*8).

    dd if=image.iso of=/dev/disk1 bs=8192

    20480+0 records in
    20480+0 records out
    167772160 bytes transferred in 220.016918 secs (762542 bytes/sec)

It is probably a good idea to eject your drive before physical removal
at this point:

    $ diskutil eject /dev/disk1

How to restore the USB drive

Because the ISO image is a hybrid which can either be burned to a disc
or directly written to a USB drive, it does not include a standard
partition table.

After you install Arch Linux and you are done with the USB drive, you
should zero out its first 512 bytes (meaning the boot code from the MBR
and the non-standard partition table) if you want to restore it to full
capacity:

    # dd count=1 bs=512 if=/dev/zero of=/dev/sdx && sync

Then create a new partition table (e.g. "msdos") and filesystem (e.g.
EXT4, FAT32) using gparted, or from a terminal:

-   For EXT2/3/4 (adjust accordingly), it would be:

    # cfdisk /dev/sdx
    # mkfs.ext4 /dev/sdx1
    # e2label /dev/sdx1 USB_STICK

-   For FAT32, install the dosfstools package and run:

    # cfdisk /dev/sdx
    # mkfs.vfat -F32 /dev/sdx1
    # dosfslabel /dev/sdx1 USB_STICK

> Using manual formatting

In GNU/Linux

This method is more complicated than writing the image directly with dd,
but it does keep the flash drive usable for data storage.

-   Make sure that the latest syslinux package (version 6.02 or newer)
    is installed on the system.

-   A MBR (msdos) partition table with at least one partition,
    containing a FAT32 filesystem must be present on the device. If not,
    create the partition and/or filesystem before continuing.

-   Mount the ISO image.

    # mkdir -p /mnt/iso
    # mount -o loop archlinux-2013.10.01-dual.iso /mnt/iso

Note:In any of the following commands, adjust /dev/sdX1 according to
your system.

-   Mount the FAT32 filesystem on the USB flash device, and copy the
    contents of the isofile to it.

    # mkdir -p /mnt/usb
    # mount /dev/sdX1 /mnt/usb
    # cp -a /mnt/iso/* /mnt/usb
    # sync
    # umount /mnt/{usb,iso}

-   Adjust the configuration files archiso_sys32 and archiso_sys64. This
    step is not required when using Archboot instead of Archiso. This
    command replaces the archisolabel=ARCH_2013XX part with your
    equivalent of archisodevice=/dev/disk/by-uuid/47FA-4071 in both
    files.

Warning:Failure to label the drive "ARCH_2013XX" (with the appropriate
release month) or to use an UUID (to re-label it to whatever you like)
prevents booting from the created medium.

    $ sed -i "s|label=ARCH_.*|device=/dev/disk/by-uuid/$(blkid -o value -s UUID /dev/sdX1)|" archiso_sys{32,64}.cfg

-   If want to use UUID to boot, such as by running the above command,
    and want to boot the stick using from a system using EFI, you need
    to update /mnt/usb/loader/entries/archiso-x86_64.conf (or similar
    for 32-bit ISO) similarly, by removing archisolabel=ARCH_2013XX and
    adding archisodevice=/dev/disk/by-uuid/your-uuid-here.

Note:Again, adjust /dev/sdX1.

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: This makes no    
                           sense as you are         
                           changing files on a      
                           device you just          
                           unmounted, and also      
                           doesn't match the 2014   
                           isos. Really, the        
                           Archiso/Archboot USB     
                           media creation process   
                           needs separate pages     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

-   Install Syslinux to the flash drive by following
    Syslinux#Manual_install. Overwrite the existing syslinux modules
    (*.c32 files) present in the USB (from the ISO) with the ones from
    the syslinux package. This is necessary to avoid boot failure
    because of a possible version mismatch.

-   Mark the partition as active by following
    Syslinux#MBR_partition_table

In Windows

> Note:

-   Do not use any Bootable USB Creator utility for creating the UEFI
    bootable USB. Do not use dd for Windows to dd the ISO to the USB
    drive.

-   In the below commands X: is assumed to be the USB flash drive in
    Windows.

-   Windows used backward slash \ as path-separator, so the same is used
    in the below commands.

-   All commands should be run in Windows command prompt as
    administrator.

-   > denotes the Windows command prompt.

-   Partition and format the USB drive using Rufus USB partitioner.
    Select partition scheme option as MBR for BIOS and UEFI and File
    system as FAT32. Uncheck "Create a bootable disk using ISO image"
    and "Create extended label and icon files" options. Use

-   Change the Volume Label of the USB flash drive X: to match the LABEL
    mentioned in archisolabel= part in
    <ISO>\loader\entries\archiso-x86_64.conf. This step is required for
    Official ISO (Archiso) but not required for Archboot.

-   Extract the ISO (similar to extracting ZIP archive) to the USB flash
    drive (using 7-Zip.

-   Download latest official syslinux 6.xx binaries (zip file) from
    https://www.kernel.org/pub/linux/utils/boot/syslinux/ and extract
    it.

-   Run the following command (in Windows cmd prompt, as admin):

Note:Use X:\boot\syslinux\ for Archboot iso.

    > cd bios\
    > for /r %Y in (*.c32) do copy "%Y" "X:\arch\boot\syslinux\" /y
    > copy mbr\*.bin X:\arch\boot\syslinux\ /y

-   Install Syslinux to the USB by running (use win64\syslinux64.exe for
    x64 Windows):

Note:Use /boot/syslinux for Archboot iso.

    > cd bios\
    > win32\syslinux.exe -d /arch/boot/syslinux -i -a -m X:

> Note:

-   The above step install Syslinux ldlinux.sys to the USB partition
    VBR, sets the partition as active/boot in the MBR partition table
    and write the MBR boot code to the 1st 400-byte boot code region of
    the USB.

-   The -d switch expects path with forward slash path-separator like in
    *unix systems.

Other Methods for BIOS systems
------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Can someone      
                           verify these work/are    
                           even needed to be        
                           mentioned? (Discuss)     
  ------------------------ ------------------------ ------------------------

> In GNU/Linux

Using UNetbootin

UNetbootin can be used on any Linux distribution or Windows to copy your
iso to a USB device. However, Unetbootin overwrites syslinux.cfg, so it
creates a USB device that does not boot properly. For this reason,
Unetbootin is not recommended -- please use dd or one of the other
methods discussed in this topic.

Warning:UNetbootin writes over the default syslinux.cfg; this must be
restored before the USB device will boot properly.

Edit syslinux.cfg:

    sysconfig.cfg

    default menu.c32
    prompt 0
    menu title Archlinux Installer
    timeout 100

    label unetbootindefault
    menu label Archlinux_x86_64
    kernel /arch/boot/x86_64/vmlinuz
    append initrd=/arch/boot/x86_64/archiso.img archisodevice=/dev/sdx1 ../../

    label ubnentry0
    menu label Archlinux_i686
    kernel /arch/boot/i686/vmlinuz
    append initrd=/arch/boot/i686/archiso.img archisodevice=/dev/sdx1 ../../

In /dev/sdx1 you must replace x with the first free letter after the
last letter in use on the system where you are installing Arch Linux
(e.g. if you have two hard drives, use c.). You can make this change
during the first phase of boot by pressing Tab when the menu is shown.

> In Windows

Win32 Disk Imager

Warning:This will destroy all information on your USB flash drive!

First, download the program from here. Next, extract the archive and run
the executable. Now, select the Arch Linux ISO under the Image File
section and the USB flash device letter (for example, [D:\]) under the
Device section. Finally, click Write when ready.

Tip:By default, the Win32 Disk Imager's file-browser assumes disk image
files end with a .img extension. However, you can simply change the
Files of type drop-down list to *.* and continue on to selecting your
Arch Linux ISO.

Note:After installation, you may need to restore the USB flash drive
following a process as outlined here.

USBWriter for Windows

Download the program from http://sourceforge.net/projects/usbwriter/ and
run it. Select the arch image file, the target USB stick, and click on
the write button. Now you should be able to boot from the usb stick and
install Arch Linux from it.

The Flashnul way

flashnul is an utility to verify the functionality and maintenance of
Flash-Memory (USB-Flash, IDE-Flash, SecureDigital, MMC, MemoryStick,
SmartMedia, XD, CompactFlash etc).

From a command prompt, invoke flashnul with -p, and determine which
device index is your USB drive, e.g.:

    C:\>flashnul -p

    Avaible physical drives:
    Avaible logical disks:
    C:\
    D:\
    E:\

When you have determined which device is the correct one, you can write
the image to your drive, by invoking flashnul with the device index, -L,
and the path to your image, e.g:

    C:\>flashnul E: -L path\to\arch.iso

As long as you are really sure you want to write the data, type yes,
then wait a bit for it to write. If you get an access denied error,
close any Explorer windows you have open.

If under Vista or Win7, you should open the console as administrator, or
else flashnul will fail to open the stick as a block device and will
only be able to write via the drive handle windows provides

Note:Confirmed that you need to use drive letter as opposed to number.
flashnul 1rc1, Windows 7 x64.

Loading the installation media from RAM

This method uses Syslinux and a Ramdisk (MEMDISK) to load the entire
Arch Linux ISO image into RAM. Since this will be running entirely from
system memory, you will need to make sure the system you will be
installing this on has an adequate amount. A minimum amount of RAM
between 500 MB and 1 GB should suffice for a MEMDISK based, Arch Linux
install.

For more information on Arch Linux system requirements as well as those
for MEMDISK see the Beginners' guide and here.

Tip:Once the installer has completed loading you can simply remove the
USB stick and even use it on a different machine to start the process
all over again. Utilizing MEMDISK also allows booting and installing
Arch Linux to and from the same USB flash drive.

Preparing the USB flash drive

Begin by formatting the USB flash drive as FAT32. Then create the
following folders on the newly formatted drive.

-   Boot
    -   Boot/ISOs
    -   Boot/Settings

Copy the needed files to the USB flash drive

Next copy the ISO that you would like to boot to the Boot/ISOs folder.
After that, extract from the following files from the latest release of
syslinux from here and copy them into the following folders.

-   ./win32/syslinux.exe to the Desktop or Downloads folder on your
    system.
-   ./memdisk/memdisk to the Settings folder on your USB flash drive.

Create the configuration file

After copying the needed files, navigate to the USB flash drive,
/boot/Settings and create a syslinux.cfg file.

Warning:On the INITRD line, be sure to use the name of the ISO file that
you copied to your ISOs folder!

    /Boot/Settings/syslinux.cfg

    DEFAULT arch_iso

    LABEL arch_iso
            MENU LABEL Arch Setup
            LINUX memdisk
            INITRD /Boot/ISOs/archlinux-2013.08.01-dual.iso
            APPEND iso

For more information on Syslinux see the Arch Wiki article.

Final steps

Finally, create a *.bat file where syslinux.exe is located and run it
("Run as administrator" if you are on Vista or Windows 7):

    C:\Documents and Settings\username\Desktop\install.bat

    @echo off
    syslinux.exe -m -a -d /Boot/Settings X:

Universal USB Installer

The Windows tool [1] can be used to quickly create a Live USB media with
multiple Installers of many Linux distros. Once created, Installers can
be added or removed without reformatting the USB drive.

Troubleshooting
---------------

-   For the MEMDISK Method, if you get the famous "30 seconds" error
    trying to boot the i686 version, press the Tab key over the
    Boot Arch Linux (i686) entry and add vmalloc=448M at the end. For
    reference: If your image is bigger than 128MiB and you have a 32-bit
    OS, then you have to increase the maximum memory usage of vmalloc.
    [2]

-   If you get the "30 seconds" error due to the
    /dev/disk/by-label/ARCH_XXXXXX not mounting, try renaming your USB
    media to ARCH_XXXXXX (e.g. ARCH_201302).

See Also
--------

-   Gentoo wiki - LiveUSB/HOWTO
-   Fedora wiki - How to create and use Live USB
-   openSUSE wiki - SDB:Live USB stick

Retrieved from
"https://wiki.archlinux.org/index.php?title=USB_Flash_Installation_Media&oldid=304224"

Category:

-   Getting and installing Arch

-   This page was last modified on 12 March 2014, at 22:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
