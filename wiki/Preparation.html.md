Beginners' guide/Preparation
============================

Tip:This is part of a multi-page article for the Beginners' Guide. Click
here if you would rather read the guide in its entirety.

This document will guide you through the process of installing Arch
Linux using the Arch Install Scripts. Before installing, you are advised
to skim over the FAQ.

The community-maintained ArchWiki is the primary resource that should be
consulted if issues arise. The IRC Channel
(irc://irc.freenode.net/#archlinux) and the forums are also excellent
resources if an answer cannot be found elsewhere. In accordance with the
Arch Way, you are encouraged to type man command to read the man page of
any command you are unfamiliar with.

Contents
--------

-   1 Preparation
    -   1.1 System requirements
    -   1.2 Prepare the latest installation medium
        -   1.2.1 Installing over the network
        -   1.2.2 Install from an existing Linux system
        -   1.2.3 Installing on a virtual machine
        -   1.2.4 Boot the installation medium
            -   1.2.4.1 Testing if you are booted into UEFI mode
        -   1.2.5 Troubleshooting boot problems

Preparation
-----------

Note:If you wish to install from an existing GNU/Linux distribution,
please see this article. This can be useful particularly if you plan to
install Arch via VNC or SSH remotely. Users seeking to perform the Arch
Linux installation remotely via an SSH connection should read Install
from SSH for additional tips.

> System requirements

Arch Linux should run on any i686 compatible machine with a minimum of
64 MB RAM. A basic installation with all packages from the base group
should take about 500 MB of disk space. If you are working with limited
space, this can be trimmed down considerably, but you will have to know
what you're doing.

> Prepare the latest installation medium

The latest release of the installation media can be obtained from the
Download page. Note that the single ISO image supports both 32 and
64-bit architectures. It is highly recommended to always use the latest
ISO image.

-   Install images are signed and it is highly recommended to verify
    their signature before use. Dowload the .sig file from the download
    page (or one of the mirrors listed there) to the same directory as
    the .iso file. On Arch Linux, use pacman-key -v iso-file.sig as
    root; in other environments make use, still as root, of gpg2
    directly with gpg2 --verify iso-file.sig. The file integrity
    checksums md5 and sha1 are also provided.

Note:The gpg2 verification will fail if you haven't downloaded the
public key corresponding to the RSA key ID. See
http://sparewotw.wordpress.com/2012/10/31/how-to-verify-signature-using-sig-file/
for details.

-   Burn the ISO image on a CD or DVD with your preferred software. On
    Arch, that's covered in Optical Disc Drive#Burning.

Note:The quality of optical drives and the discs themselves varies
greatly. Generally, using a slow burn speed is recommended for reliable
burns. If you are experiencing unexpected behaviour from the disc, try
burning at the lowest speed supported by your burner.

-   Or you can write the ISO image to a USB stick. For detailed
    instructions, see USB Installation Media.

Installing over the network

Instead of writing the boot media to a disc or USB stick, you may
alternatively boot the ISO image over the network. This works well when
you already have a server set up. Please see the PXE article for more
information, and then continue to boot the installation medium.

Install from an existing Linux system

Alternatively, it is possible to install from an already running Linux
system. See Install from Existing Linux.

Installing on a virtual machine

Installing on a virtual machine is a good way to become familiar with
Arch Linux and its installation procedure without leaving your current
operating system and repartitioning the storage drive. It will also let
you keep this Beginners' Guide open in your browser throughout the
installation. Some users may find it beneficial to have an independent
Arch Linux system on a virtual drive, for testing purposes.

Examples of virtualization software are VirtualBox, VMware, QEMU, Xen,
Varch, Parallels.

The exact procedure for preparing a virtual machine depends on the
software, but will generally follow these steps:

1.  Create the virtual disk image that will host the operating system.
2.  Properly configure the virtual machine parameters.
3.  Boot the downloaded ISO image with a virtual CD drive.
4.  Continue with Boot the installation medium.

The following articles may be helpful:

-   Arch Linux as VirtualBox guest
-   Arch Linux as VirtualBox guest on a physical drive
-   Arch Linux as VMware guest
-   Moving an existing install into (or out of) a virtual machine

Boot the installation medium

Most modern systems allow you to select the boot device during the POST
phase, usually by pressing the F12 key while the BIOS splash screen is
visible. Select the device which contains the Arch ISO. Alternatively,
you may need to change the boot order in your computer's BIOS. To do
this, press a key (usually Delete, F1, F2, F11 or F12) during the POST
phase. This will take you into the BIOS settings screen where you can
set the order in which the system searches for devices to boot from. Set
the device which contains the Arch ISO as the first device from which
boot is attempted. Select "Save & Exit" (or your BIOS's equivalent) and
the computer should then complete its normal boot process. When the Arch
menu appears, select "Boot Arch Linux" and press Enter to enter the live
environment where you will run the actual installation (if booting from
a UEFI boot disk, the option may look more like "Arch Linux archiso
x86_64 UEFI").

Once you have booted into the live environment, your shell is Zsh; this
will provide you advanced Tab completion, and other features as part of
the grml config.

Testing if you are booted into UEFI mode

In case you have a UEFI motherboard and UEFI Boot mode is enabled (and
is preferred over BIOS/Legacy mode), the CD/USB will automatically
launch Arch Linux kernel (Kernel EFISTUB via Gummiboot). To test if you
have booted into UEFI mode run:

    # mount -t efivarfs efivarfs /sys/firmware/efi/efivars              # ignore if already mounted
    # efivar -l

If efivar lists the uefi variables properly, then you have booted in
UEFI mode. If not check whether all the requirements listed at Unified
Extensible Firmware Interface#Requirements for UEFI Variables support to
work properly are met.

Troubleshooting boot problems

-   If you are using an Intel video chipset and the screen goes blank
    during the boot process, the problem is likely an issue with Kernel
    Mode Setting. A possible workaround may be achieved by rebooting and
    pressing e over the entry that you are trying to boot (i686 or
    x86_64). At the end of the string type nomodeset and press Enter.
    Alternatively, try video=SVIDEO-1:d which, if it works, will not
    disable kernel mode setting. You can also try i915.modeset=0. See
    the Intel article for more information.

-   If the screen does not go blank and the boot process gets stuck
    while trying to load the kernel, press Tab while hovering over the
    menu entry, type acpi=off at the end of the string and press Enter.

Beginners' guide

* * * * *

Preparation >> Installation >> Post-installation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Beginners%27_guide/Preparation&oldid=303518"

Categories:

-   Getting and installing Arch
-   About Arch

-   This page was last modified on 7 March 2014, at 21:08.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
