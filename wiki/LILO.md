LILO
====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> Summary

An overview of the installation and use of the LILO multi-boot loader.

> Overview

In order to boot Arch Linux, a Linux-capable boot loader such as
GRUB(2), Syslinux, LILO or GRUB Legacy must be installed to the Master
Boot Record or the GUID Partition Table. The boot loader is responsible
for loading the kernel and initial ramdisk before initiating the boot
process.

The LInux LOader, or LILO for short, is a legacy multi-boot loader for
Linux systems. In spite of being the standard choice over the course of
several years, it has been slowly phased out thanks to the advent of
GRUB, an alternative boot loader offering easier configuration and less
chance of rendering systems unbootable. However, many users still prefer
the simplicity of traditional LILO, and it is still actively developed.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Sample setup                                                 |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

LILO can be installed during system installation by selecting lilo
during package selection.

It can be installed after the fact with the package lilo, available in
the Official Repositories.

Configuration
-------------

LILO is configured by editing the /etc/lilo.conf file and running lilo
afterwards to apply the new configuration. If choosing LILO during the
Arch Linux installation process, the configuration file should have been
already performed.

As a reminder, consider that LILO needs to be run after every kernel
upgrade, otherwise the system is likely to be left in an unbootable
state.

More help on setting up LILO can be found in the LILO-mini-HOWTO.

> Sample setup

A typical LILO setup:

Tip:If LILO is really slow while loading the bzImage, try adding compact
to /etc/lilo.conf's global section, as shown below.

    /etc/lilo.conf

    #
    # /etc/lilo.conf
    #

    boot=/dev/hda
    # This line often fixes L40 errors on bootup
    # disk=/dev/hda bios=0x80

    default=Arch
    timeout=100
    lba32
    prompt
    compact

    image=/boot/vmlinuz-linux
            label=Arch
    	append="devfs=nomount"
    	vga=788
            root=/dev/hda2
            read-only

    image=/boot/vmlinuz-linux
            label=ArchRescue
            root=/dev/hda8
            read-only

    other=/dev/hda1
            label=Windows

    # End of file

You can use hwinfo --framebuffer to determine what vga modes you can
use.

See also
--------

-   List of kernel parameters that can be used at boot time
-   List of kernel paramaters with further explanation and grouped by
    like options ('Kernel Boot Command-Line Parameter Reference', Linux
    Kernel In A Nutshell)

Retrieved from
"https://wiki.archlinux.org/index.php?title=LILO&oldid=204865"

Category:

-   Boot loaders
