MacBook
=======

Summary

Details the installation and configuration of Arch Linux on Apple's
MacBook and MacBook Pro lines of notebooks.

Related

Official Arch Linux Install Guide

Beginners Guide

General Recommendations

MacBook

MacBookPro

MacBook_Pro_7,1

MacBook_Pro_8,1_/_8,2_/_8,3_(2011_Macbook_Pro)

MacBook_Pro_9,2_(Mid-2012)

Installing Arch Linux on a MacBook is quite similar to installing it on
any other computer. However, due to the specific hardware configuration
on a MacBook, there are a few deviations and special considerations
which warrant a separate guide. For more background information, please
see the Official Arch Linux Install Guide, Beginners Guide, Beginners
Guide Appendix, and Post Installation Tips. This guide contains
installation-instructions that can be used on any Apple computer whose
hardware is supported by the Linux kernel. If you have a Macbook5,2
(Polycarbonate, Non-Unibody) and are having additional issues, please
see Macbook5,2 for additional help.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Overview                                                           |
| -   2 Installation of Mac OS X and Firmware Update                       |
| -   3 Partitions                                                         |
|     -   3.1 Arch Linux Only                                              |
|         -   3.1.1 EFI                                                    |
|         -   3.1.2 BIOS-compatibility                                     |
|                                                                          |
|     -   3.2 Mac OS X with Arch Linux                                     |
|         -   3.2.1 EFI                                                    |
|         -   3.2.2 BIOS-compatibility                                     |
|                                                                          |
|     -   3.3 Mac OS X, Windows XP, & Arch Linux Triple boot               |
|                                                                          |
| -   4 Booting Directly from GRUB                                         |
|     -   4.1 Compilation                                                  |
|     -   4.2 Example grub.cfg                                             |
|                                                                          |
| -   5 Installation                                                       |
|     -   5.1 Additional steps for Arch Linux only install                 |
|                                                                          |
| -   6 Post-Install Configuration                                         |
|     -   6.1 Xorg                                                         |
|         -   6.1.1 Video                                                  |
|             -   6.1.1.1 NVIDIA note                                      |
|             -   6.1.1.2 Macbook 6.2+ - EFI                               |
|             -   6.1.1.3 MacbookPro 5.5, NVIDIA and secondary display     |
|                                                                          |
|         -   6.1.2 Touchpad                                               |
|         -   6.1.3 Keyboard                                               |
|             -   6.1.3.1 NVIDIA note                                      |
|                                                                          |
|     -   6.2 Wifi                                                         |
|     -   6.3 Power management                                             |
|         -   6.3.1 Laptop-mode-tools                                      |
|         -   6.3.2 Suspend to RAM (kernel suspend)                        |
|         -   6.3.3 Suspend to disk (hibernate)                            |
|                                                                          |
|     -   6.4 Light sensor                                                 |
|     -   6.5 Sound                                                        |
|     -   6.6 Bluetooth                                                    |
|     -   6.7 iSight                                                       |
|     -   6.8 Temperature Sensors                                          |
|     -   6.9 Color Profile                                                |
|     -   6.10 Apple Remote                                                |
|     -   6.11 HFS Partition Sharing                                       |
|     -   6.12 HFS+ Partitions                                             |
|     -   6.13 Home Sharing                                                |
|         -   6.13.1 In OS X                                               |
|             -   6.13.1.1 Step 1: Change UID and GID(s)                   |
|             -   6.13.1.2 Step 2: Change "Home" Permissions               |
|                                                                          |
|         -   6.13.2 In Arch                                               |
|                                                                          |
|     -   6.14 Avoid long EFI wait before booting                          |
|     -   6.15 Mute startup chime                                          |
|                                                                          |
| -   7 rEFIt                                                              |
|     -   7.1 Problems with rEFIt                                          |
|                                                                          |
| -   8 Model-specific information                                         |
|     -   8.1 MacBook                                                      |
|         -   8.1.1 Mid 2007 13" - Version 2,1                             |
|                                                                          |
|     -   8.2 MacBook Pro                                                  |
|         -   8.2.1 10,1                                                   |
|                                                                          |
|     -   8.3 MacBook Air                                                  |
|         -   8.3.1 Mid 2012 13" - Version 5,2                             |
|         -   8.3.2 Mid 2012 11.5" - Version 5,1                           |
|             -   8.3.2.1 Installing using the Archboot 2012.06 image      |
|                                                                          |
|         -   8.3.3 Mid 2011 - Version 4,x                                 |
|         -   8.3.4 Early 2008 - Version 1,1                               |
|                                                                          |
| -   9 See also                                                           |
+--------------------------------------------------------------------------+

Overview
--------

Specifically, the procedure for installing Arch Linux on a MacBook is:

1.  Install Mac OS X: Regardless of the desired end-configuration, it
    helps to start from a clean install of OS X.
2.  Firmware Update: This should help reduce errors and provide newer
    features for the hardware.
3.  Partition: This step either resizes or deletes the OS X partition
    and creates partitions for Arch Linux.
4.  Install Arch Linux: The actual installation procedure.
5.  Post-Install Configuration: MacBook specific configuration.

Tip: rEFIt is a popular bootloader for EFI-firmware computers (including
Macs). It can be installed at any time during the installation. For
instructions, please see #rEFIt.

Installation of Mac OS X and Firmware Update
--------------------------------------------

Apple already has excellent instructions for installing Mac OS X. Follow
their instructions. Finally, once OS X is installed, go to:

    Apple Menu --> Software Update

And update all software. Once this has run, you will need to reboot your
computer. Do this, and then run Software Update again to check to make
sure that all updates have been installed.

Note: Sometimes Software Update may not pick up all the firmware updates
available for your computer. However, you can try to search these
upgrades directly into the Apple's Support site.

If you are not going to have Mac OS X installed, make backups of these
files:

    /System/Library/Extensions/IOUSBFamily.kext/Contents/PlugIns/AppleUSBVideoSupport.kext/Contents/MacOS/AppleUSBVideoSupport

You will need this file later for iSight functionality.

    /Library/ColorSync/Profiles/Displays/<FILES HERE>

You will need the file(s) here for adjusting the color profile.

Partitions
----------

The next step in the installation is to re-partition the hard drive. If
Mac OS X was installed using the typical procedure, then your drive
should have a GPT format and the following partitions:

-   EFI: a 200 MB partition at the beginning of the disk.It is often
    read as msdos or FAT by some partitioning tools and usually labeled
    #1.
-   Mac OS X: the (HFS+) partition that should take up all of the
    remaining disk space. Usually labeled #2.
-   Recovery: A recovery partition (only for Mac OS X 10.7+).

How to partition depends on how many operating systems you want install.
The following options will be explained:

-   Arch Linux Only for single boot.
-   Mac OS X with Arch Linux for dual boot.

If you do not know which option to pick, we recommend the dual boot so
you can still return to Mac OS X whenever you want.

> Arch Linux Only

This situation is the easiest to deal with. Mostly, partitioning is the
same as any other hardware that Arch Linux can be installed on. The only
special consideration is the MacBook firmware boot sound. To ensure that
this sound is off: mute the volume in Mac OS X before continuing
further. The MacBook firmware relies on the value in Mac OS X, if
available. Note that if you choose to get rid of the OS X partition,
there is no easy way to update your machines firmware unless you use an
external drive to boot Mac OS X. You can boot in EFI mode (recommended)
or bios-compatibility mode, if in doubt choose EFI.

To install using EFI, follow the instruction to make a EFI bootable
media. Once done double check that your USB key actually boots in EFI
mode checking the EFI kernel variables. You will need to format the EFI
partition with the hfsplus filesystem (hfsprogs) instead vfat otherwise
mactel-boot will fail, and in Macbooks you cannot use efibootmgr.

EFI

-   This requires GRUB to work
-   Boot installation medium and switch to a free tty.
-   Run cgdisk (gptfdisk package).
-   Create the necessary partitions.

Simple example (no LVM, crypto):

Note: The swap partition is optional, on machines with a RAM of size 4GB
or more, good performance can be expected without a swap partition.
Also, a swap file can be created later, see Swap file.

Note: For more information on partitioning, see Partitioning hard disks:
General information.

    partition  mountpoint  size    type  label
    /dev/sda1  /boot/efi   200MiB  vfat  EFI
    /dev/sda2  /boot       100MiB  ext2  boot
    /dev/sda3  -           adjust  swap  swap
    /dev/sda4  /           10GiB   ext4  root
    /dev/sda5  /home       remain. ext4  home

-   Done, you can continue to #Installation

BIOS-compatibility

-   Boot installation medium and switch to a free tty.
-   Run parted. The simplest way is to change the partition table to
    msdos and then partition as normal. GRUB is compatible with GPT.

-   Create the necessary partitions.

-   Done, you can continue to #Installation

> Mac OS X with Arch Linux

The easiest way to partition your hard drive, so that Mac OS X and Arch
Linux will co-exist, is to use partitioning tools in Mac OS X and then
finish with Arch Linux tools.

Warning: It is highly recommended that this only be attempted after a
clean install of Mac OS X. Using these methods on a pre-existing system
may have undesired results.

Note: If you have any problems, try using gparted (i.e. instead of using
Disk Utility and/or cgdisk). It is capable of shrinking the OS X
partition and creating Linux partitions ready for installation.

Procedure:

-   In Mac OS X, run Disk Utility.app (located in
    /Applications/Utilities)

-   Select the drive to be partitioned in the left-hand column (not the
    partitions!). Click on the partition tab on the right.

-   Select the volume to be resized in the Volume scheme.

-   Decide how much space you wish to have for your Mac OS X partition,
    and how much for Arch Linux. Remember that a typical installation of
    Mac OS X requires around 15-20 GiB, depending on the number of
    software applications and files.

-   Finally, type the new (smaller) size for the Mac OS X partition in
    the size box and click Apply. This will create a new partition out
    of the empty space. You will delete this partition later.

Note: if you wish to have a shared partition between Mac OS X and Arch
Linux, then additional steps will need to happen here. Please see Shared
Partition.

-   If the above completed successfully, then you can continue. If not,
    then you may need to fix your partitions from within Mac OS X first.

-   Boot the Arch install CD by holding down the alt key during Boot.
    Follow one of the procedures below according to your choice of
    boot-method.

EFI

-   Run cgdisk

-   Delete the partition you made in Disk Utility.app and create the
    necessary partitions for Arch Linux. Mac OS X likes to see a 128MiB
    gap after partitions, so when you create the first partition after
    the last Mac OS X-partition, type in +128M when cgdisk asks for the
    first sector for the partition. A simple example (no LVM, crypto):

Note: The swap partition is optional, on machines with a RAM of size 4GB
or more, good performance can be expected without a swap partition.
Also, a swap file can be created later, see Swap file.

Note: If you want to be able to boot GRUB from the Apple boot loader,
you can create a small hfs+ partition (for convenience, use mac osx to
format it in Disk Utility.app afterwards). Follow the GRUB EFI install
procedure, and mount your /boot/efi directory to the hfs+ partition you
created. Finally, finish up again in Mac OS X by blessing the partition.
This will set GRUB as the default boot option (holding alt at startup
goes to the mac boot options screen still. See
http://mjg59.dreamwidth.org/7468.html)

Note: For more information on partitioning, see Partitioning hard disks:
General information.

Note: OSX's EFI partition can be shared with archlinux, making the
creation of an additional EFI partition dedicated to arch completely
optional

    partition  mountpoint  size       type  label
    /dev/sda1  /boot/efi   200MiB     vfat  EFI
    /dev/sda2  -           ?          hfs+  Mac OS X
    /dev/sda3  -           ?          hfs+  Recovery
    /dev/sda4  -           100MiB     hfs+  Boot Arch Linux from the Apple boot loader (optional)
    /dev/sda5  /boot       100MiB     boot  boot
    /dev/sda6  -           ?          swap  swap (optional)
    /dev/sda7  /           10GiB      ext4  root
    /dev/sda8  /home       remaining  ext4  home

-   Done, you can continue to #Installation

BIOS-compatibility

-   Run parted

    # parted

-   Delete the empty space partition and partition the space as you
    would for any other installation. Note that MBR is limited to 4
    primary partitions (including the efi partition). That leaves 2
    primary partitions for arch. One strategy is to have a system and
    home partition, and use a swap file (I have not tried to use logical
    partitions). Another is to dedicate one partition to a shared
    partition (see below).

-   Next, create new filesystems on those partitions which need them,
    especially the partition which will contain /boot. If you're not
    sure how to do this using mkfs.ext2 (or whatever), run /arch/setup
    and work through until you get to Prepare Hard Drive and use the
    "Manually configure block devices..." option, then exit the
    installer. This is necessary so that rEFIt will set the right
    partition type in the MBR in the next step (without an existing
    filesystem, it seems to ignore the partition type set by parted),
    without which GRUB will refuse to install to the right partition.

-   At this point you should reboot your computer and have rEFIt fix the
    partition tables on your hard drive. (If you do not do this, you may
    have to reinstall GRUB later on in order to have your Mac recognize
    the Linux partition.) When you are into the rEFIt menu, select
    update partition table, then press Y.

    # reboot

-   Done, you can continue to #Installation

> Mac OS X, Windows XP, & Arch Linux Triple boot

This may not work for everyone but it has been successfully tested on a
Macbook from late 2009.

The easiest way to partition your hard drive, so that all these
operating systems can co-exist, is to use disk utility in Mac OS X, use
the formatter on windows XP install CP, and then finish with Arch Linux
tools.

Warning: It is highly recommended that this only be attempted after a
clean install of Mac OS X. Using these methods on a pre-existing system
may have undesired results. At least back your stuff up with timemachine
or clonezilla before you begin.

Procedure:

-   In Mac OS X, run Disk Utility (located in /Applications/Utilities)

-   Select the drive to be partitioned in the left-hand column (not the
    partitions!). Click on the partition tab on the right.

-   Select the volume to be resized in the volume scheme.

-   Decide how much space you wish to have for your Mac OS X partition,
    how much fo XP, and how much for Arch Linux. Remember that a typical
    installation of Mac OS X requires around 15-20 GiB, and XP about the
    same, depending on the number of software applications and files.
    Something like OSX 200Gb, XP 25Gb, Arch 25Gb should be fine.

-   Put your decisions into action by pressing the + button and adding
    the new partitions, Label them as you like and make sure that your
    XP partition is the last one on the disk and is formatted for FAT32.
    It is probably best to have Arch formatted in HFS format as to not
    confuse you later, it will be reformatted anyway.

So in linux terms your partitions will be something like:

-   sda (disk)
-   sda1 (Mac boot partition - you cannot see this one in OSX)
-   sda2 (OSX install in HFS+)
-   sda3 (Arch install temporarly in HFS)
-   sda4 (XP install in FAT32)

-   Finally, click apply. This will create a new partition out of the
    empty space.

Note: Using this method you may not be able to have a shared partition
between Mac OS X and Arch Linux, this is because the mac will only allow
for 4 active partitions. You will however be able to mount a HFS
partition in Arch for one workaround. There are other workarounds
possible also.

-   If the above completed successfully, you can continue. If not, then
    you may need to fix your partitions from within Mac OS X first.

-   You will not be needing boot camp this way, the program rEFIt is
    much more flexible (though not as flexible as GRUB). Download and
    install rEFIt [[1]]

-   Go into a terminal in OS X and perform the following, this will
    enable the rEFIt boot manager.

    cd /efi/refit
    ./enable.sh

-   Reboot to check the rEFIt is working, it should appear on boot. When
    it comes up go to the rEFIt partition manager and agree to the
    changes.

-   Put your XP install CD and boot it with rEFIt - You may have to
    reboot a few times until it is recognized by the boot loader.
    Install XP and once it is installed use the OSX install CD to get
    your drivers running nicely in XP.
    -   Note: when installing XP make sure you select your XP partition
        and format it again inside the XP installer. If you do not
        reformat it will not work.

-   Boot the Arch install CD, log in as root and run /arch/setup

-   Follow the install as normal but note that you will have to tell
    that arch installer to mount sda3 as the root partition and format
    it as ext3, there will not be a /boot or swap partition so ignore
    those warnings.

-   At this point, if you are dual booting, you should reboot your
    computer and have rEFIt fix the partition tables on your hard drive.
    (If you do not do this, you may have to reinstall GRUB later on in
    order to have your Mac recognize the Linux partition.) When you are
    into the rEFIt menu, select update partition table, then press Y.

    # reboot

-   Done! Please continue to #Installation

Booting Directly from GRUB
--------------------------

It is possible to boot directly from GRUB in EFI mode without using
rEFIt. These instructions are known to work on a Macbook 7,1. It is
advisable to host GRUB on either a FAT32 or HFS+ partition, but ext2 or
ext3 may also work. GRUB's appleloader command does not currently work
with the 7,1, but support can be added with the patch available here.

After the GRUB install is in the desired location, the firmware needs to
be instructed to boot from that location. This can be done from either
an existing OS X install or an OS X install disk. The following command
assumes that the GRUB install is in /efi/grub on an existing OS X
partition:

     sudo bless --folder /efi/grub --file /efi/grub/grub.efi

> Compilation

Some models may need EFI_ARCH set to i386.

     bzr branch --revision -2 bzr://bzr.savannah.gnu.org/grub/trunk/grub grub
     cd grub
     ./autogen.sh
     patch -p1 < appleloader_macbook_7_1.patch
     export EFI_ARCH=x86_64
     ./configure --with-platform=efi --target=${EFI_ARCH} --program-prefix=""
     make
     cd grub-core
     ../grub-mkimage -O ${EFI_ARCH}-efi -d . -o grub.efi -p "" part_gpt part_msdos ntfs ntfscomp hfsplus fat ext2 normal chain boot configfile linux multiboot
     cp grub.efi *.mod *.lst yourinstalllocation

> Example grub.cfg

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: kernel26         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Note that there may be a better method for loading Windows.

    set debug=video
    insmod efi_gop

    menuentry "Arch Linux EFI" {
      set root=(hd0,3)
      #search --set -f /boot/vmlinuz26-efi-physical
      #loadbios /boot/vbtrace_bios.bin /boot/int10.bin
      linux /boot/vmlinuz26-efi-physical root=/dev/sda3 reboot=pci resume=/dev/sda3 resume_offset=151552
      initrd /boot/kernel26-efi-physical.img
    }

    menuentry "MacOSX" {
      set root=(hd0,2)
      # Search the root device for Mac OS X's loader.
      #search --set -f /usr/standalone/i386/boot.efi
      # Load the loader.
      chainloader /usr/standalone/i386/boot.efi
    }

    menuentry "Windows 7" {
      appleloader HD
    }

    menuentry "Boot from CD" {
      appleloader CD
    }

    menuentry "Boot from USB" {
      appleloader USB
    }

Installation
------------

Note: This section is only required if you want to have Mac OS X
installed along with Arch Linux. If not, follow the steps in the
official install guide, then skip to #Post-Install Configuration.

-   Boot from the Arch Linux install CD or the latest Archboot iso
    (unofficial) depending on your needs.

Note: On MacBook Pro 7,1, I had an error booting the installation media
Version 2012.12.01: "unable to handle kernel NULL pointer dereference at
0000000000000010" during pacpi_set_dmamode. To fix this problem, boot
with the option: acpi=off. After chrooting, add MODULES="ata_generic"
into /etc/mkinitcpio.conf and execute mkinitcpio -p linux, see:
Installation Guide, 9 Configure the system.

Note: Some MacBook users report strange keyboard output such as long
delays and character doubling. To fix this problem, boot with the
following options: arch noapic irqpoll acpi=force

-   Log in as root

Note: If you want to do a netinstall rather than installing the possibly
outdated packages on the iso and depend on a wireless network that is
encrypted, you should change to a free tty and connect manually before
proceeding, see Beginners_Guide

-   Proceed through the installation as described in the Official Arch
    Linux Install Guide except in the following areas:
    -   In the prepare hard drive stage, do only the set filesystem
        mountpoints step, taking care to assign the correct partitions.
        Partitions have already been created if you followed #Partition
    -   (for booting with EFI) After the install boot loader stage, exit
        the installer and install GRUB.
    -   (for booting with BIOS-compatibility) In the install boot loader
        stage, edit the menu.lst file and add reboot=pci to the end of
        the kernel lines, for example:

            kernel /vmlinuz26 root=/dev/sda5 ro reboot=pci

        This will allow your MacBook to reboot correctly from Arch.

    -   (for booting with BIOS-compatibility) Also in the install boot
        loader stage, install GRUB on whatever partition that /boot is
        on.
        Warning: Do not install GRUB onto /dev/sda !!! Doing so is
        likely to lead to an unstable post-environment.
    -   In the configure system stage, edit /etc/mkinitcpio.conf and add
        the usbinput hook to the HOOKS line somewhere after the
        autodetect hook. This will load the drivers for your keyboard in
        case you need to use it before Arch boots (e.g. entering a LUKS
        password or using the troubleshooting shell).

-   When the install process is complete, reboot your computer.

    # reboot

-   If using optical media, hold down the eject key as your MacBook
    starts, this should eject the Arch Linux install disk.

-   If dual-booting Mac OS X and Arch Linux, hold down the alt (option)
    key while the system boots to use the Mac bootloader to select which
    OS to boot.

> Additional steps for Arch Linux only install

Note: Do this after you tested that your setup is working. This
procedure has been tested on a MacBook 4,1 with an msdos partition
table. It may not work on newer versions. Please update if it works for
you.

-   In order for Linux to boot up straight away, you will have to tell
    the firmware that your /boot partition is bootable, or you will
    always have to hold down the option (alt) key whenever you want to
    start up your computer.
-   In order to do this you will need the original Mac OS X install disk
-   Boot into it (you may need to hold the option (alt) key during boot
    again to access it)
    -   Open Terminal.app (found under the Utilities menu in the menu
        bar), and type:

    # diskutil list

-   -   Find the device name of your /boot partition (this is your root
        (/) partition, if you don't have it separate). The format should
        be /dev/disk0sX, where X is a number from 1 to infinity
    -   If using EFI type (replace X with the appropriate number):

    # bless --folder=/Volumes/efi --file=/Volumes/efi/efi/arch/grubx64.efi --setBoot
    # bless --mount=/Volumes/efi --file=/Volumes/efi/efi/arch/grubx64.efi --setBoot

-   -   If using BIOS-compatibility type (replace X with the appropriate
        number):

    # bless --device /dev/disk0sX --setBoot --legacy --verbose

-   Remove the installation disk and restart your computer
-   After a few seconds of grey screen, your boot loader screen should
    appear automatically.

Post-Install Configuration
--------------------------

> Xorg

Install and configure Xorg by following the Xorg article.

Video

Different MacBook models have different graphic cards.

To see which graphics card you have type:

    $ lspci | grep VGA

-   If it returns a string containing intel you only need the
    xf86-video-intel driver. You can install it by typing

    # pacman -S xf86-video-intel

-   if it returns nVidia, read NVIDIA.

-   otherwise if it returns ATI or AMD, read ATI.

NVIDIA note

Tip: MBP 6.2 - With the proprietary NVIDIA drivers, support for Pure
Video HD is available for hardware video decoding.

For MacBooks with NVIDIA graphics, for the backlight to work properly
you may need the nvidia-bl package found in the AUR.

Tip:If backlight control doesn't work after installing nvidia-bl, you
should blacklist apple_bl kernel module.

Tip:Alternatively, you can choose to use the pommed-light package found
in the AUR. If you do so, you may wish to change the step settings in
/etc/pommed.conf.mactel to something around 5000-10000 depending on how
many levels of brightness you desire. The max brightness is around
80000, so take that into account.

Macbook 6.2+ - EFI

As of 4/30/2011, the proprietary nvidia driver is not known to work
under X with this model in efi mode. The nouveau driver should work out
of the box, but dri should be installed from the mesa-git package.

MacbookPro 5.5, NVIDIA and secondary display

As of January 1 2011, the latest NVIDIA drivers (290.10) might not work
properly when a secondary display is used (tested with TwinView),
NVIDIA's current long-live supported 275xx drivers seem to work fine.
Install nvidia-275xx and nvidia-utils-275xx from AUR, and possibly
lib32-nvidia-utils-275xx if you are on x86_64 system and want 32-bits
support.

MacbookPro 5.5 has an NVIDIA 9400m graphics card. This problem might
apply to other devices as well.

Touchpad

The touchpad should have basic functionality by default. A true
multitouch driver which behaves very similarly to native OSX can be
installed from the AUR: xf86-input-multitouch-git. It supports 1, 2 and
3 finger gestures, including differentiation between horizontal and
vertical 3 finger swipe. Additional details are available at the
driver's project page.

xf86-input-multitouch-git does not support any sort of configuration
without editing the driver's source. Some users are also experiencing
issues with false clicks from palm touches. There is now a much more
configurable fork available as xf86-input-mtrack-git. Configuration
options are documented in the readme.

The following mtrack options work well on a Macbook 7,1:

     Option "Thumbsize" "50"
     Option "ScrollDistance" "100"

Probably you need also to add:

     MatchDevicePath "/dev/input/event10"

Special Note About Older Macbook Models (confirmed on MacBook 2,1): On
older Macbook models (pre-multitouch), the touchpad will not function
properly until you install the xf86-input-synaptics package. Please see
Touchpad Synaptics for more information on installing and configuring
this package.

Note on Macbook Pro(5,5): I found it is much simpler to use the
xf86-input-synaptics[2] in Extra. Although it does not have much
function as 3 finger swipe, this driver provides faster response.
Gsynaptics[3] also provides a simple GUI config. Below is a Xorg config
file /etc/X11/xorgconfig.d/60-synaptics.conf for reference only.

     Section "InputClass"
           Identifier "touchpad catchall"
           Driver "synaptics"
           MatchIsTouchpad "on"
           MatchDevicePath "/dev/input/event*"
           Option "SHMConfig" "on"
           Option "TapButton1" "1"
           Option "TapButton2" "3"
           Option "TapButton3" "2"
           Option "PalmDetect" "on"
           Option "VertEdgeScroll" "off"
           Option "HorizEdgeScroll" "off"
           Option "CornerCoasting" "off"
           Option "EdgeMotionUseAlways" "off"
           Option "AreaLeftEdge" "10"
           Option "AreaRightEdge" "1270"
     EndSection

Keyboard

MacBook keyboard works by default. For swaping fn keys with Fx keys see
Apple Keyboard.

To enable it you can map with right application like xbindkeys or
through DE preferences; but another very good way, that we recommend, is
to install pommed from the AUR.

    Edit the /etc/pommed.conf according to your hardware on MacBook, building
    it from /etc/pommed.conf.mac or /etc/pommed.conf.ppc example files.

Note that you can also run it without a configuration file, the defaults
may work for you. Then

    Put pommed at the end in your DAEMONS array in your /etc/rc.conf

finally reboot your pc.

Tip: if you are using Gnome or KDE you can easily configure 3rd level
functionality, multimedia key, etc. in Keyboard Preferences.

Note: see the Xorg input hotplugging page for other configuration
information.

The keyboard backlight is controlled by
/sys/class/leds/smc::kbd_backlight. Write the desired value to
brightness in that directory.

NVIDIA note

If the brightness does not function correctly through pommed, make sure
you have installed the nvidia-bl package and insert

     find . -name "*" -exec sed -i 's/mbp_backlight/nvidia_backlight/' '{}' \;

into the second line of the pommed PKGBUILD build() function and remake
the package. From this forum post.

Another possible solution is to modify the pommed PKGBUILD build():

     find . -name "*" -exec sed -i 's/nvidia_backlight/apple_backlight/' '{}' \;

If the previous does not work try the following,

run nvidia-settings, edit the file '/etc/X11/xorg.conf' and add this
line into the Device section:

     Option "RegistryDwords" "EnableBrightnessControl=1"

save and reboot and check backlight buttons work. More information
available at ubuntu macbook pro 5,5

> Wifi

Tip: MBP 6.2: since kernel 2.6.32.35-1 this works out of the box

Different MacBook models have different wireless cards.

You can easily check what card do your MacBook have by:

    # lspci | grep Network

-   if you have an Atheros all should works-out-of-the-box.

-   instead if you have a Broadcom follow the Broadcom BCM4312 page.

-   5.0 and 6.0 generation MacBooks may have a BCM43xx, follow the
    instructions for the broadcom-wl driver on the Broadcom wireless
    page. The interfaces can swap during reboot so its best to define
    them in a udev rule (instructions on the Broadcom wireless page).

-   8.1 generation MacBooks have BCM4331, for which support is not
    present in either Linux (3.0 and 3.1) or the proprietary drivers by
    Broadcom. There is however preliminary support for it in Linux 3.2.
    To run the drivers on earlier kernels, you will need to use
    compat-wireless

Note: if your connection frequently drops, you may have to turn off wifi
power management. If you are running pm-utils, you may override wireless
power management by creating an executable file /etc/pm/wireless with
the lines

    #!/bin/sh
    /sbin/iwconfig wlan0 power off

> Power management

Laptop-mode-tools

Because the MacBook is obviously a laptop, you may wish to control its
power management features using something like Laptop Mode Tools.

However, Laptop Mode Tools is known to disable the keyboard in console
mode after being idle for a few seconds (does not happen when using X).
If this happens to you set

    CONTROL_USB_AUTOSUSPEND=0

in /etc/laptop-mode/conf.d/usb-autosuspend.conf. See this forum thread
for the original workaround.

Suspend to RAM (kernel suspend)

Suspend (the kernel suspend) should work out of the box (I had a problem
in which the machine would "suspend immediately after resume" in certain
conditions when suspending by closing the lid. This was solved by
de-selecting the option "event_when_closed_battery" in gconf-editor →
gnome-power-manager → actions).

For a macbook2,1 (bought in 2007) s2ram works using

    s2ram -f -a 3 

To make it work with kde4 you have to create a file named "config" into
/etc/pm/config.d containing

    SLEEP_MODULE="uswsusp"
    S2RAM_OPTS="-f -a 3"

For a MacBook Pro 3,1 (bought in 2008), the following command should
work, both in X and in a console:

    s2ram -f -a 1

Note: If you use pm-utils suspending lead (at least for me) disk freeze.
Try changing /etc/pm/config.d/module to

    SLEEP_MODULE=tuxonice

For a macbook5.5, s2ram may work using (be sure to run it in X)

    s2ram -f -p -m

Suspend to disk (hibernate)

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Swap#Swap   
                           file.                    
                           Notes: These part is     
                           duplication of Swap file 
                           section in Swap. Should  
                           check and merge it to    
                           Swap. (Discuss)          
  ------------------------ ------------------------ ------------------------

Hibernate should work if you have a swap partition. If you opted for a
swap file because of the MBR limitation to 4 primary partitions, you can
still get hibernate functionality by following these instructions (this
is mostly taken from http://ubuntuforums.org/showthread.php?t=1042946):

-   Create a swapfile (here 2G = bs*count):

    sudo dd if=/dev/zero of=/swapfile bs=1024 count=2M

It is recommended, but not necessary, to create the swapfile on a newly
created partition, so that fragmentation is minimum.

    # chmod 600 swapfile 
    # mkswap swapfile 
    mkswap: swapfile: warning: don't erase bootbits sectors
            on whole disk. Use -f to force.
    Setting up swapspace version 1, size = 2097148 KiB
    no label, UUID=6bf46166-4f9e-433a-aac1-91cb3f5cf8ba
    # 
    Note that we will not use this UUID later.

-   Add the swapfile in fstab:

    /swapfile   none   swap   sw   0   0

-   Determine the UUID of partition on which the swapfile is
    (/sbin/blkid is provided by util-linux-ng)

    # blkid -g
    # blkid
    /dev/sda4: UUID="388014d3-1d18-4ca0-980e-ef2f9fdebde4" TYPE="ext3" 

388014d3-1d18-4ca0-980e-ef2f9fdebde4 is the number we are looking for.

-   Determine the physical offset of the swapfile:

    $ sudo filefrag -v /swapfile | head
    Filesystem type is: ef53
    Filesystem cylinder groups is approximately 132
    File size of /swapfile is 2147483648 (524288 blocks, blocksize 4096)
     ext logical physical expected length flags
       0       0    24576              12 merged
       1      12    24589    24587   1024 merged
       2    1036    25615    25612   1024 merged
       3    2060    26640    26638   1024 merged
       4    3084    27665    27663   1024 merged
       5    4108    28690    28688   1024 merged
    $ 

Here, 24576 is the number we want.

-   Edit /boot/grub/menu.lst and add:

    resume=/dev/disk/by-uuid/388014d3-1d18-4ca0-980e-ef2f9fdebde4 resume_offset=24576

to your kernel stanza options (or use the kopt method as in the post).
Note that the "resume=UUID=" actually did not work for me. I had to use
the /dev/disk/by-uuid syntax.

Note: "ro" has to be at the end of the line, like this:

    kernel /boot/vmlinuz-linux root=/dev/sda4 resume=/dev/sda4 resume_offset=24576 ro

-   Nothing to do with update-grub nor mkinitcpio.
-   Reboot once
-   Try to hibernate

> Light sensor

If you want to use the built in light sensor to automatically adjust
screen and keyboard backlight brightness check out Lighter [4] (simple
perl script, easy to fine-tune) and Lightum [5] (Requires Gnome or KDE
but is older and more complete than Lighter).

> Sound

Tip: MBP 5.5: since kernel 2.6.32 this works out of the box - just
unmute the front speakers and store the sound level

First of all follow ALSA wiki page, then if something does not work
correctly, continue reading this part.

Edit your /etc/modprobe.d/50-sound.conf or /etc/modprobe.d/modprobe.conf
appending this line:

    options snd_hda_intel model=intel-mac-auto

This should automatically specify the codec in your MacBook.
Alternatively, for MacBookPro5,X, you can use:

    options snd_hda_intel model=mb5

(note that the jack output is controlled with "HP").

If you have an iMac8,1, you should instead use

    options snd-hda-intel model=mbp3 position_fix=2

Note: you can try to specify other options, agree with in your hardware.
All other possible settings are listed in Kernel Documentation, avaible
online:

-   ALSA-Configuration.txt
-   HD-Audio.txt
-   HD-Audio-Models.txt.

Then, reboot.

> Bluetooth

Note:Bluetooth should work out-of-the box. The hid2hci utility is used
by default since bluez 4.91

See the article on Bluetooth to install and configure all software
needed.

> iSight

Note:Linux kernel from 2.6.26 includes the Linux UVC driver natively.
MBP 6.2+ (Kernel ~2.6.37+) iSight works out of the box without the need
to use firmware from OS X.

You can use many applications to test the camera:

-   MPlayer

    # mplayer tv:// -tv driver=v4l2:width=320:height=240:device=/dev/video0 -fps 30

-   Cheese
-   Skype
-   Ekiga

A simple solution to take snapshots is:

    # mplayer tv:// -vf screenshot

and the pressing the s key to take a snapshot. Files are of the format
shot\d\d\d\d.png and are reported in the standard output.

> Temperature Sensors

For reading temperature just install and configure lm_sensors. See Lm
sensors page.

> Color Profile

We can use color profiles from Mac OS.

First, install xcalib from the AUR.

Second copy pre-saved color profiles placed in
/Library/ColorSync/Profiles/Displays/ on Mac OS partition to
~/colorprofiles/ for example.

There are color profile files agree with in MacBook models; select the
right one:

-   Color LCD-4271800.icc for MacBook Pro with CoreDuo CPU
-   Color LCD-4271880.icc for MacBook with Core2Duo
-   Color LCD-4271780.icc for MacBook (not Pro) based on CoreDuo or
    Core2Duo.

Tip: also Mac OS allows to save current color profile from Displays ->
Color section of the Mac OS System Preferences, in this case file is
saved to /Users/<username>/Library/ColorSync/Profiles.

Finally you can activate it by running

    # xcalib ~/colorprofile.icc

Warning: previous command set the color profile only for the current
session; this mean that you must run it every time you login in your
system. For automating it you can execute the command by Autostart
Application, concording with your DE (or add the command to your login
manager's initialization script, e.g. /etc/gdm/Init/Default).

Note: see xcalib man pages for further information.

> Apple Remote

First, to correctly install and configure the lirc software that control
IR see Lirc wiki.

Then make LIRC use /dev/usb/hiddev0 (or /dev/hiddev0) by editing
/etc/conf.d/lircd. Here is how mine look:

    #
    # Parameters for lirc daemon
    #
    LIRC_DEVICE="/dev/usb/hiddev0"
    LIRC_DRIVER="macmini"
    LIRC_EXTRAOPTS=""
    LIRC_CONFIGFILE="/etc/lirc/lircd.conf"

Use irrecord (available when installing lirc) to create a configuration
file matching your remote control signals (alternatively, you can try to
use the lircd.conf below):

    sudo irrecord -d /dev/usb/hiddev0 -H macmini output_conf_file

Start lircd and use irw to check if it works.

Example of an /etc/lirc/lircd.conf:

    begin remote

      name  lircd.conf.macbook
      bits            8
      eps            30
      aeps          100

      one             0     0
      zero            0     0
      pre_data_bits   24
      pre_data       0x87EEFD
      gap          211994
      toggle_bit_mask 0x87EEFD01

          begin codes
              Repeat                   0x01
              Menu                     0x03
              Play                     0x05
              Prev                     0x09
              Next                     0x06
              Up                       0x0A
              Down                     0x0C
          end codes

    end remote

> HFS Partition Sharing

First, we need hfsprogs package from AUR.

we have to list our partitions. Use

    fdisk -l /dev/sda

example output:

    # fdisk -l /dev/sda
        Device  Boot     Start         End      Blocks   Id  Type
     /dev/sda1               1          26      204819   ee  GPT
     /dev/sda2              26       13602   109051903+  af  Unknown
     /dev/sda3   *       13602       14478     7031250   83  Linux
     /dev/sda4           14478       14594      932832+  82  Linux swap / Solaris

As we see, the "Unknown" partition is our OS X partition, which is
located in /dev/sda2.

Create a "mac" folder in /media:

    sudo mkdir /media/mac

Add at the end of /etc/fstab this line:

    /dev/sda2    /media/mac     hfsplus auto,user,rw,exec   0 0

Mount it :

    mount /media/mac

and check it:

    ls /media/mac

> HFS+ Partitions

HFS+ partitions, now the default in Mac OS X, are not fully supported by
Linux and are mounted as read-only by default. In order to write to an
HFS+ partition, it is necessary to disable journaling. This can be
accomplished using Mac OS X Disk Utility. Refer to this Apple support
page for more information.

> Home Sharing

UID Synchronization

In OS X

Note: it is strongly recommended that UID/GID manipulation be done
immediately after a new user account is created, in OS X as well as in
Arch Linux. If you installed OS X from scratch, then this operation is
guaranteed to work after logging into your account for the first time.

Step 1: Change UID and GID(s)

Pre-Leopard

1.  Open NetInfo Manager located in the /Applications/Utilities folder.

1.  If not done for you already, enable access to user account
    transactions by clicking on the closed lock at the bottom of the
    window, and entering your account password, or root password if you
    have created a root account.

1.  Navigate to /users/<new user name> where <new user name> is the name
    of the account that will have read/write access to the folder that
    will be shared with the primary user in Arch.

1.  Change the UID value to 1000 (the value used by default for first
    user created in Arch).

1.  Also change the GID value to 1000 (the value used by default for
    user account creation in Arch).

1.  Navigate to /groups/<new user name>, automatically saving the
    changes you have made so far.

Note: if you get an error message that the transaction is not allowed,
log out and log back in.

Leopard

In Leopard, the NetInfo Manager application is not present. A different
set of steps is required for UID synchronization:

1.  Open System Preferences.

1.  Click on Accounts.

1.  Unlock the pane if not already done so.

1.  Right-click on the desired user and select Advanced Options.

1.  Write down the value of the User ID field, you will need it later
    on. Change both the UID and GID to match the UID and GID of the
    account wished to be shared with in Arch (1000 by default for the
    first user created in Arch).

Step 2: Change "Home" Permissions

1.  Open up Terminal in the /Applications/Utilities folder.

1.  Enter the following command to reclaim the permission settings of
    your home folder, replacing <your user name>, <your user group> and
    <your old UID> with the user name whose UID and GID values you just
    changed, the group name whose GID value you just changed and the old
    UID number, respectively.

    sudo find /User/<your user name> -user <your old UID> -exec chown <your user name>:<your user group> {} \;

In Arch

To synchronize your UID in Arch Linux, you are advised to perform this
operation while creating a new user account. It is therefore recommended
that you do this as soon as you install Arch Linux.

Now you must substitute Arch's home with Mac OS's home, by modify
entries of the famous /etc/fstab file.

> Avoid long EFI wait before booting

If your Macbook spends 30 seconds with "white screen" before booting you
need to tell the firmware where is the booting partition.

Boot Mac OS X, if do not have it installed, you can use the install DVD
(select language, then click Utilities->Terminal), or another MacBook
with Mac OS X (connect the two computers via firewire or thunderbolt,
start the other Macbook keeping pressed T, boot your MacBook keeping
pressed Options).

Either way, once you got a Mac OS X terminal running on your MacBook you
need to execute, as root, a different command if the boot partition is
EFI or it is not:

    # bless --device /dev/disk0s1 --setBoot            # if the booting partition is EFI

or

    # bless --device /dev/disk0s1 --setBoot --legacy   # if the booting partition is not EFI

(given that if your GRUB or EFI is on sda1, /dev/disk1s2 if it is on
sdb2, etc). See also https://bbs.archlinux.org/viewtopic.php?pid=833215
and https://support.apple.com/kb/HT1533 .

> Mute startup chime

If you forgot to mute before installing, you can still mute again if you
have a Mac OS X Install disk. Boot from it, select language, then click
Utilities->Terminal, and enter

    # /usr/sbin/nvram SystemAudioVolume=%01

(or whatever volume you want).

rEFIt
-----

Note: You probably want to have a look at refind, which is some type of
successor of rEFIt.

Note: this is not a requirement. It only gives you a menu to choose
between OS X and Arch Linux upon every boot.

For more see, refit myths.

In OS X, download the ".dmg" from -> Refit Homepage and install it.

Note: if you have already partitioned your hard disk in preparation for
the Arch installation, rEFIt may not be enabled by default. You will
have to run the "enable.sh" script installed in /efi/refit/.

Open up Terminal and enter:

    cd /efi/refit; ./enable.sh

> Problems with rEFIt

If you experience problems after the install of Arch or rEFIt,
especially is the right OS is not showing up to boot to or if it dumps
you at a GRUB prompt stuck like the following:

    GRUB>_

Then have a look at this link:

http://mac.linux.be/content/problems-refit-and-grub-after-installation

It can give you a basic idea on how to boot off the Arch live cd, mount
the problem Arch install, chroot, use gptsync, and reinstall GRUB. This
is probably for more advanced users who can translate the commands from
a debian system to an Arch system and also apply it to the partitions on
their machine. Be careful not to install GRUB in the wrong spot.

If you need a copy of gptsync you can wget it from here:
http://packages.debian.org/sid/gptsync or try these, for 64 bit:

    wget http://ftp.us.debian.org/debian/pool/main/r/refit/gptsync_0.14-2_amd64.deb

and for i386:

    wget http://ftp.us.debian.org/debian/pool/main/r/refit/gptsync_0.14-2_i386.deb

since they are .deb packages you will need the program deb2targz

    pacman -S deb2targz

Model-specific information
--------------------------

> MacBook

Mid 2007 13" - Version 2,1

Note:I used the 201212 ISO image.

Warning:Current linux-3.8.x packages do not work with their EFI stub and
refind-efi. Either use an older package (linux 3.7.10-1 works with
refind-efi 0.6.8-1) or you may use a bootloader which does not rely on
EFI stub. Similiar issues are reported with gummiboot.

Since older Macbooks have a 32bit EFI running, the usual installation
image is not recognized. You need to either remove the UEFI support from
the disc
(Unified_Extensible_Firmware_Interface#Remove_UEFI_boot_support_from_ISO)
or build a 32bit EFI version of the disc. The paragraphs below will take
the first path to success, booting into BIOS mode and its pitfalls. For
a try the other way round, read
Unified_Extensible_Firmware_Interface#Create_UEFI_bootable_USB_from_ISO
first.

First prepare your harddisc according to your wishes. In this scenario
it was a "Linux only" approach with

    /dev/sda1 HFS+ AF00 200M -> EFI boot system on Apple HFS+ partition
    /dev/sda2 ext4 8300 147G -> arch system
    /dev/sda3 swap 8200 1G   -> swap

The hfsprogs package contains the tools to handle HFS/HFS+ filesystems.
The rEFInd bootloader recognizes it on its own. Usually the partition
for the EFI bootloader is a FAT32 (vfat) partition. In this case I tried
rEFIt first, which apparently needs the HFS+ filesystem to work, and
kept it at that.

The mount points are:

    /dev/sda2 -> /
    /dev/sda1 -> /boot/efi

The bootloader in use was rEFInd instead of rEFIt. To install it, the
rEFInd homepage provides a good guide. The pitfall here is, that the
system bootet in BIOS compatibility mode and not in EFI mode. You can't
therefore use efibootmgr, because the EFI variables (even with 'modprobe
efivars') are not available. While installing the system get yaourt and
mactel-boot from the AUR. The hfs-bless utility comes in handy, when
blessing the EFI bootloader. This is done by calling e.g.

    hfs-bless /boot/efi/EFI/refind/refind.efi

Since the Linux kernel does come with EFI stub enabled, it seemed a good
idea to run it through a bootloader first. Especially if it runs not out
of the box. But using rEFInd makes GRUB (or any other bootloader)
obsolete, because of that.

Not running out of the box is unfortunately the initial stage for the
kernel. Since we installed it in BIOS mode, two modules are missing to
grant access to the root partition while booting. Hence the
'initfsram-linux.img' can not be found/loaded. Adding the following
modules to your 'MODULES' line in /etc/mkinitcpio.conf solved this
(original post).

    # nano /etc/mkinitcpio.conf

    MODULES="ahci sd_mod"

Rebuild your kernel image

    mkinitcpio -p linux

The bootloader rEFInd can scan kernels even out of the '/boot/efi/...'
directory and assumes an efi kernel even without the extension '.efi'.
If you don't want to try out special kernels, this should work without
the hassle to copy each kernel after building to some spot special.

If you happen to get multiple entries for one boot image, it often
results of a previous installation of a bootloader within the MBR. To
remove that, try the following - taken from the original post. This is
valid for GPT partitioned discs, so please check your environment and
save your MBR first.

    sudo dd if=/dev/zero of=/dev/sda bs=440 count=1

> MacBook Pro

10,1

-   MacBookPro Retina.

> MacBook Air

Mid 2012 13" - Version 5,2

Kernel panics using default boot media under arch kernel 3.5. Adding
'intremap=off' fixes this. Additionally, there are problems loading the
'applesmc' module (meaning the temperature sensors, fan, and keyboard
backlight do not work). These problems are fixed in the linux 3.6-rc4
mainline kernel (I have tested).

Mid 2012 11.5" - Version 5,1

If you have issues with waking from sleep while in X11 such as a black
screen or showing the console with a frozen mouse cursor then remove
xf86-input-synaptics and install mtrack-git from aur. This fixed errors
such as

     (EE) [dix] bcm5974: unable to find touch point 0

and backtraces that causes X11 to crash. This might apply to Version 5,2
assuming they use the same trackpad.

Installing using the Archboot 2012.06 image

Several people have reported problems installing Arch Linux on the MBA
version 5,2 (See problems booting archlinux on a MacBook Air Mid 2012).
A common problem is that the screen is not detected and therefore goes
black when the installer boots. To fix this problem one has to select
the normal install (Not the LTS) during boot and press tab to edit the
boot flags. Then add noapic flag to the boot line. This should fix the
screen going black. Install the system as you normally would. It may
help later in the configuration process if the support packages are
installed already at this stage.

When the install has finished again add the noapic flag to the GRUB boot
line (if you use GRUB) and also add i915.diescreaming=1 (or perhaps
i915.die). This should keep the screen from going black when booting the
new system. After you enter the system the wireless driver should be
loaded. If you installed the support packages during installation you
should have the wifi-menu command. Run it and select the network you
want to use. One could also use wpa_supplicant but wifi-menu is quite
fast to use at this stage. Now you are ready to upgrade the system. As
of writing there have been a lot of changes to Archlinux since the
2012.06 image of Archboot was released (filesystem and glibc). Therefore
the upgrade process can be a bit difficult. The current solution has
sucessfully upgraded a standart archboot version to a up-to-date version
as of October 2012 and this step should be obsolete in future releases
of archboot.

First ignore the new "big" changes to Arch Linux,

     pacman -Suy --ignore glibc,libarchive,curl,filesystem 

If this only upgrades pacman then run the command again. Remember to
make sure that pacman is ignoring the packages you don't want upgraded
now. Otherwise you may break the system and have to reinstall! Now
upgrade to the new filesystem,

    pacman -S filesystem --force

As described here (Glibc upgrade guide) there may be conflicts with
installed packages that require the /lib directory. Follow the guide and
remove any packages that use /lib. The stock 3.4.2 kernel from Archboot
should be on this list so first upgrade this,

    pacman -S linux

This may give some errors saying that the system may not boot because of
missing modules. Ignore this warning for now. The stock install may also
contain gcc in the /lib directory so also remove this if needed and any
other packages that have conflicts. Now Glibc should be the only package
in /lib so run the system upgrade and accept all changes,

    pacman -Su

Finally reinstall the kernel so that it can find the correct modules,

    pacman -S linux

Now this command shouldn't give any errors like last time. You can also
reinstall gcc at this point. After a rebooted the system should startup
and the new kernel should have fixed the problem with the screen going
black. If want to boot Xorg then you may need to remove the
i915.diescreaming=1 line from GRUB. If not then attach a external screen
and try to fix the problem that way. Some people have reported commands
that may help on the forum.

Mid 2011 - Version 4,x

Works out-of-the-box since kernel 3.2. It is recommended to use
Archboot, install GRUB and use EFI.

Early 2008 - Version 1,1

Everything works out of the box though you'll need b43-fwcutter (or
simply b43-firmware) for the wireless adapter to work. Since this model
has a single USB, you may find it easiest to install Arch by using a USB
hub with an USB wireless adapter and the arch installation media.

See also
--------

-   http://www.netsoc.tcd.ie/~theorie/interblag/2010/01/30/installing-arch-linux-on-a-mac-pro/
-   http://allanmcrae.com/2010/04/installing-arch-on-a-macbook-pro-5-5/
-   http://allanmcrae.com/2012/04/installing-arch-on-a-macbook-pro-8-1/
-   http://linux-junky.blogspot.com/2011/08/triple-boot-archlinux-windows-7-and-mac.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=MacBook&oldid=255296"

Category:

-   Apple
