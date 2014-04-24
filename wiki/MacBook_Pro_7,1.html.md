MacBook Pro 7,1
===============

Summary help replacing me

Details the installation and configuration of Arch Linux on Apple's
MacBook Pro 7,1

> Related

MacBook

MacBook Pro 7,1

MacBook Pro 8,1 / 8,2 / 8,3 (2011)

MacBook Pro 9,2 (Mid-2012)

Contents
--------

-   1 Installation
    -   1.1 Dual Boot
        -   1.1.1 EFI-Mode
        -   1.1.2 CSM-Mode
    -   1.2 Bootloader
        -   1.2.1 EFI-Mode
        -   1.2.2 CSM-Mode or BIOS-compatibility
            -   1.2.2.1 Can't find root device
-   2 Network
-   3 Video
    -   3.1 Nouveau
    -   3.2 Nvidia

Installation
------------

To install an x86_64 system, follow the MacBook EFI installation
instructions. It is recommended to read the UEFI, GPT and UEFI
Bootloaders pages before trying any of this on your machine. Also of
note, GIST.

See notes on video support before attempting installation!

The following assumes that you have somehow managed to install archlinux
to a single partition on your drive, and that you still have your osx
installation on a different partition.

> Dual Boot

If you want to dualboot osx and linux, the easiest way to do so is to
use rEFInd. rEFInd is a updated and maintained fork of rEFIt and should
be used in its place.

I've found it easiest to install rEFInd from osx. Depending on your
setup, you'll either install it to your osx partition, or to the ESP
partition (install.sh --esp). See here for instructions. Installing to
the ESP partition can cause some startup delay, which can be overcome by
simply renaming rEFInd's installation folder to "BOOT" and the
executable to "bootx64.efi"[1]

Assuming that rEFInd was installed to the ESP, I've found it convenient
to later mount the ESP as my "/boot" directory. That way, by setting

    scan_all_linux_kernels

in your refind.conf, rEFInd will automatically pickup the kernel. All
you need to add is a "refind_linux.conf" file to the root of the ESP,
containing your boot args. I use:

    "Boot with defaults"    "root=/dev/sda3 rootfstype=xfs ro add_efi_memmap"

Note that my root partion is sda3 and that I use the xfs filesystem on
it, yours may differ! So my ESP partition looks like this when mounted
under "/boot":

    EFI/
     APPLE/
     BOOT/
      bootx64.efi
      drivers/
      icons/
      keys/
      refind.conf
    initramfs-linux-fallback.img
    initramfs-linux.img
    refind_linux.conf
    syslinux/ *** My bootloader of choice, see below ***
    vmlinuz-linux

Note that the EFI/BOOT directory is normally named EFI/REFIND and that
the bootx64.efi is normally named refind_x64.efi.

EFI-Mode

You should now be able to boot your mac in efi-mode via the kernel's
efistub feature. rEFInd should present you with an option to do so. See
here for more general information on the topic. This however has some
drawbacks, as mentioned in the Video section below.

CSM-Mode

Booting your mac in csm- or legacy-mode provides a solution. To do so,
we need a hybrid mbr, with at least one 'active/bootable' partition. See
here for more general information on how to setup a hybrid mbr. Simply
boot in efi-mode, then assuming you have three partitions, the ESP
partition, an osx and a linux partition you'll need to use gdisk to set
things up.

    gdisk /dev/sda

Press 'p' to print your partition table, which should look somewhat like
mine:

    Number  Start (sector)    End (sector)  Size       Code  Name
      1              40          409639   200.0 MiB   0700  EFI System Partition
      2          409640       393186215   187.3 GiB   AF00  OSX
      3       393186216       625142414   110.6 GiB   8300  Linux filesystem

Press 'r' to enter recovery and transformation mode.

Now press 'o' to print your mbr. It should only list a single partition
covering the entire disk. Or depending on with which tools you used to
partition your disk maybe some other entries.

Press 'h' to create a new hybrid mbr. You'll be prompted for some input:

    Type from one to three GPT partition numbers, separated by spaces, to be
    added to the hybrid MBR, in sequence:

I chose to mirror my gpt, so I entered '1 2 3', but it should be enough
to just use one partition here. In my example, this would need to be the
ESP partition, so '1', but in case you don't want to use the ESP to
store your kernels, this could also be the linux partition, so '3'. You
decide :)

Another and maybe more secure way to mirror the gpt is only to enter '1'
for the first and only partition, the EFI or boot partition. This
prevents the strange behaviour of MacOS. It can happen that MacOS or its
bootsystem can't find his partition and will end up in a rather long
loop. Then proceed as written below.

Make sure to say 'Yes' to the next promt:

    Place EFI GPT (0xEE) partition first in MBR (good for GRUB)? (Y/N): y

Then set at least one partition as active/bootable:

    Creating entry for GPT partition #1 (MBR partition #2)
    Enter an MBR hex code (default 07): 
    Set the bootable flag? (Y/N): y

Note the MBR hex code depends on the partition type, press 'l' in
gdisk's main menu to list them.

Press 'o' (make sure you're still in the recovery menu!!!) again to see
your new hybrid mbr, in my case:

    Number  Boot  Start Sector   End Sector   Status      Code
      1                     1           39   primary     0xEE
      2      *             40       409639   primary     0x07
      3                409640    393186215   primary     0xAF
      4             393186216    625142414   primary     0x83

Or if you choose to only mirror the first one, it can also looks like
this:

    Number  Boot  Start Sector   End Sector   Status      Code
      1                     1           39   primary     0xEE
      2      *             40       409639   primary     0xEF

Even if the mbr table looks like this (note that in the second table
only the last two lines are missing), the bootloader will know what to
boot. You can compare start and end sectors between the two tables if
you wish.

Press 'w' to write the table to disk and reboot.

> Bootloader

The next important thing is the bootloader, which acts as the bridge
from refind to your kernel. Based on the Mode you use to install arch,
either EFI or CSM, you can choose a bootloader of your choice. But for
now, We provide you with information about Syslinux and Gummiboot,
because these are the two we tested successfully for now.

In both cases I assume that you managed to mount the EFI partition
mentioned above to /boot/ already.

Grub is the one bootloader, which can handle both the EFI and the CSM
mode. But because it's mighty, it also can be complex and the
configuration are far-reaching. I recommending you, unless you want to
configure the smallest detail in the bootloader for an unforgetting
adventure during a booting, to use gummiboot (EFI-only) or syslinux
(CSM-only), because both are really easy to setup.

EFI-Mode

If you don't need the power and it's powersaving feature of the nvidia
blob, then you should install gummiboot or Grub, because these are the
one which actually works fine with EFI.

Let's start with:

    # pacman -S gummiboot

to install this package and run

    # gummiboot install

After this, you need to create a config file for gummiboot and add an
entry for the arch booting. The sdaX means that you have to replace it
with your root partition, in this case it may be /dev/sda3.

    # nano /boot/loader/entries/arch.conf

    title          Arch Linux
    linux          /vmlinuz-linux
    initrd         /initramfs-linux.img
    options        root=/dev/sdaX rw

As usual, for more information on configuring and using gummiboot, see
gummiboot.

CSM-Mode or BIOS-compatibility

Otherwise, if you don't want to miss out the advantages of the nvidia
blob, I suggest you to install syslinux or also Grub. We'll use syslinux
because it's the simplest to setup, but others should also work. Install
it via pacman, and then just execute

    syslinux-install_update -i -a -m

It should detect your hybrid mbr and install itself automatically. Refer
to Syslinux for more details.

Make sure to configure the bootloader's menu entries correctly:
(syslinux)

    LABEL arch
    MENU LABEL Arch Linux
    LINUX ../vmlinuz-linux
    APPEND root=/dev/sda3 ro vga=865
    INITRD ../initramfs-linux.img

Note that 'sda3' refers to the gpt mapping, 'vga=865' means 1280x800
framebuffer resolution, nicer when using the nvidia driver.

Can't find root device

If booting fails, first try to use the initramfs-linux-fallback.img, as
it includes more modules than your 'auto-detected' initramfs, and should
allow the kernel to actually find your root partition. You'll then need
to rebuild your regular initramfs. Rebuild it with

    mkinitcpio -p linux

If you're lucky, the whole booting process with the regular
initramfs-linux will end up successfully, if not, then try to add the
following configuration and rebuild the initramfs again. I needed to
include modules in the initramfs file. In /etc/mkinitcpio.conf:

    MODULES="ata_generic libata xfs"

Note, that you'll only need xfs if your root partition is actually
formatted with it, exchange it with the appropriate module for the
file-system you use.

  
 Once you reboot, rEFInd should now present you with three options, two
linux entries and one for osx. One linux entry will boot the kernel via
efistub in efi-mode, the other will call syslinux(or your chosen
bootloader) which then should boot the system in csm-mode. Do the latter
from now on!

The easiest way to see if you were successful, is to install the Nvidia
driver and start X.

Network
-------

Wireless Setup provides instructions on how to identify your card, but
if your MacBook Pro 7,1 is like mine then you'll head to Broadcom
Wireless and use this command.

    $ lspci -vnn -d 14e4:

If from this you discover that your full PCI-ID is [14e4:432b], then the
following advice applies to you: Don't waste time on the b43 driver.
I've been fiddling with it for weeks, and switching to broadcom-wl made
all the problems go away. broadcom-wl might make your device names
funky, but that's easily fixed with the udev rule documented on Broadcom
Wireless.

I also recommend netctl.

Video
-----

According to the Debian Wiki the MacBook Pro 7,1 has an NVIDIA GeForce
GT 320M in it.

> Nouveau

Works out of the box, performance however is not that great and your
system will get quite hot when running nouveau.

> Nvidia

The drivers work, but so far only when booting the mac in csm- or
legacy-mode. See here for some discussion on the topic.

In short, booting in efi-mode, will crash the nvidia module when X
starts, resulting in a black screen, so in order to use nvidia's driver,
you'll need to boot your machine in csm-mode.

This can't be achieved directly, but depends on apple's firmware
agreeing that your partition layout warrants this as presumably they
implemented the feature to allow booting of windows xp/7, neither which
can ordinarily boot off a gpt partitioned disk.

  
 To be continued..

Retrieved from
"https://wiki.archlinux.org/index.php?title=MacBook_Pro_7,1&oldid=304032"

Category:

-   Apple

-   This page was last modified on 11 March 2014, at 15:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
