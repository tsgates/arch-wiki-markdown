NeoGRUB
=======

NeoGRUB is an implementation of GRUB4DOS provided by the EasyBCD
bootloader-configurator for Windows. When installed to the Windows
bootloader (via Add New Entry - NeoGrub ) from EasyBCD, it embeds an
implementation of GRUB Legacy inside the Windows Bootloader. This
implementation can boot Arch Linux and other Linuxes directly, without
chainloading a Linux bootloader installed on the linux's /boot.

This can be helpful if you find that updates to Arch are breaking your
Arch's GRUB or Syslinux.

One caveat: NeoGRUB is only known to support the following filesystems:
FAT16, FAT32, MINIX fs, ext2, ReiserFS, JFS, XFS that means that your
/boot partition must be one of these filesystems if you use NeoGRUB.
your / and other partitions can be whatever.

When you install NeoGRUB to the windows bootloader, click Configure. A
configuration file window pops up, prompting you for GRUB configuration
syntax for the NeoGrub. Here's an example to boot Arch Linux:

    title Arch
    find --set-root /boot/vmlinuz-linux
    kernel /boot/vmlinuz-linux ro root=/dev/sda3

    initrd /boot/initramfs-linux.img

adjust the /dev/sda3 line accordingly to point to your Linux /
partition. Also, if you use a kernel other than default (such as
linux-lts or the -ck kernel) adjust the initramfs and vmlinuz files
accordingly.

More information of the nature and workings of EasyBCD and NeoGRUB is at
the developer's site:

-   https://neosmart.net/wiki/easybcd/neogrub/
-   https://neosmart.net/wiki/easybcd/neogrub/linux/

note that that last link has an example to boot Ubuntu. Ubuntu adds
version numbers to its vmlinuz and initrd files, which would require
that you update the NeoGRUB every kernel update. Arch does not have this
problem. Also note that Arch uses initramfs, not initrd, but you still
use the syntax in the code box above.

Retrieved from
"https://wiki.archlinux.org/index.php?title=NeoGRUB&oldid=292266"

Category:

-   Boot loaders

-   This page was last modified on 10 January 2014, at 21:56.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
