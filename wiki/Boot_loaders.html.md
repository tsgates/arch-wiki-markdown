Boot loaders
============

The boot loader is the first piece of software started by the BIOS or
UEFI. It is responsible for loading the kernel with the wanted kernel
parameters, and initial RAM disk before initiating the boot process. You
can use different kinds of bootloaders in Arch, such as GRUB and
Syslinux. Some bootloaders only support BIOS or UEFI and some support
both.

This page will only contain a short introduction and the most used
configurations that users will encounter. For detailed information,
please see the corresponding pages of each boot loader.

Contents
--------

-   1 Both BIOS and UEFI boot loaders
    -   1.1 GRUB
    -   1.2 Syslinux
    -   1.3 BURG
-   2 UEFI-only boot loaders
    -   2.1 Linux Kernel EFISTUB
        -   2.1.1 Gummiboot
        -   2.1.2 rEFInd
    -   2.2 ELILO
-   3 BIOS-only boot loaders
    -   3.1 GRUB Legacy
    -   3.2 LILO
    -   3.3 NeoGRUB
-   4 Troubleshooting
    -   4.1 UEFI boot loader does not show up in firmware menu
-   5 See also

Both BIOS and UEFI boot loaders
-------------------------------

> GRUB

See GRUB.

> Syslinux

See Syslinux.

> BURG

Note:BURG is not officially supported by Arch developers.

See BURG.

UEFI-only boot loaders
----------------------

> Linux Kernel EFISTUB

The Linux kernel can be booted directly without a boot loader. See
EFISTUB for more information.

Gummiboot

Gummiboot is a UEFI Boot Manager (not a boot loader) which provides a
menu for EFISTUB kernels. See Gummiboot for more information.

rEFInd

rEFInd is a UEFI Boot Manager which provides a menu for booting EFISTUB
kernels (The stock Archlinux kernel has the EFI stub loader built in).
It is an alternative to Gummiboot. See rEFInd for more information, and
two example use-case setups (a pure Archlinux system and a dual boot
system with Windows 8.1).

> ELILO

Warning:ELILO upstream has clarified that it is no longer in active
development, meaning no new features will be added and only bug-fixes
are released. See
https://sourceforge.net/mailarchive/message.php?msg_id=31524008 for more
information. ELILO also is not officially supported by Arch developers.

ELILO is the UEFI version of the BIOS-only LILO (although they do not
share code). It was originally created for Intel Itanium systems which
supported only EFI 1.x (precursor to UEFI 2.x). It is the oldest UEFI
bootloader for Linux. Elilo config file elilo.conf is similar to LILO's
config file. ELILO does not support chainloading other EFI applications.
and does not provide a menu by default (setting up requires additional
configuration as described in elilo/docs/textmenu_chooser.txt file.
Upstream provided compiled binaries are available at
http://sourceforge.net/projects/elilo/ and AUR package at elilo-efi.

BIOS-only boot loaders
----------------------

> GRUB Legacy

Note:GRUB Legacy is not officially supported by Arch developers.

GRUB Legacy (also known as grub-0.97), is the legacy, BIOS-only branch
of GRUB. See GRUB Legacy for more information.

> LILO

Note:LILO is not officially supported by Arch developers but it does
continue to be actively developed.

See LILO.

> NeoGRUB

Note:NeoGRUB is not officially supported by Arch developers.

NeoGRUB provides a means to boot Arch from the Windows boot loader
without installing an additional boot loader. It is provided by the
EasyBCD tool running on Windows. This is a great option for dual-booting
Windows and Arch, especially if you find that Windows has trouble when
booted or chainloaded from another bootloader. See NeoGRUB for more
information.

Booting Arch from NeoGRUB has not been tested yet from Windows 8 and/or
UEFI systems.

Troubleshooting
---------------

> UEFI boot loader does not show up in firmware menu

On some UEFI motherboards like boards with an Intel Z77 chipset, adding
entries with efibootmgr or bcfg from the EFI Shell will not work because
they don't show up on the boot menu list after being added to NVRAM.

This issue is caused because the motherboards can only load Microsoft
Windows. To solve this you have to place the .efi file in the location
that Windows uses.

Copy the bootx64.efi file from the Arch Linux installation medium (FSO:)
to the Microsoft directory your ESP partition on your hard drive (FS1:).
Do this by booting into EFI shell and typing:

    FS1:
    cd EFI
    mkdir Microsoft
    cd Microsoft
    mkdir Boot
    cp FS0:\EFI\BOOT\bootx64.efi FS1:\EFI\Microsoft\Boot\bootmgfw.efi

After reboot, any entries added to NVRAM should show up in the boot
menu.

See also
--------

-   Rod Smith - Managing EFI Boot Loaders for Linux
-   Rod Smith - rEFInd, a fork or rEFIt
-   Linux Kernel Documentation on EFISTUB
-   Linux Kernel EFISTUB Git Commit
-   Rod Smith's page on EFISTUB
-   rEFInd Documentation for booting EFISTUB Kernels

Retrieved from
"https://wiki.archlinux.org/index.php?title=Boot_loaders&oldid=300698"

Category:

-   Boot loaders

-   This page was last modified on 23 February 2014, at 15:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
