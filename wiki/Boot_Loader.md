Boot Loader
===========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: This page is      
                           created to ease the      
                           transition from GRUB     
                           Legacy to GRUB.          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The boot loader is responsible for loading the kernel and initial RAM
disk before initiating the boot process. You can use different kinds of
bootloaders in Arch, such as GRUB, Syslinux, LILO or GRUB Legacy. For
UEFI Bootloaders, please see this page.

This page will only contain a short introduction and the most used
configurations that users will encounter. For detailed information,
please see the corresponding pages of each boot loader.

Configuration
-------------

> Configuration files

Different boot loader use different files for configuration.

+--------------------------------------+--------------------------------------+
| Boot Loader                          | Configuration File                   |
+======================================+======================================+
| GRUB                                 | /boot/grub/grub.cfg                  |
+--------------------------------------+--------------------------------------+
| GRUB Legacy                          | /boot/grub/menu.lst                  |
+--------------------------------------+--------------------------------------+
| LILO                                 | /etc/lilo.conf                       |
+--------------------------------------+--------------------------------------+
| Syslinux                             | /boot/syslinux/syslinux.cfg          |
+--------------------------------------+--------------------------------------+

> Kernel parameters

Kernel command line parameters are often supplied by the bootloader. See
Kernel parameters.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Boot_Loader&oldid=255306"

Category:

-   Boot loaders
