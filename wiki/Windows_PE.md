Windows PE
==========

Windows PE is a lightweight version of Windows intended to be used for
installation of Windows Vista or Windows 7 and for system maintenance.
It runs entirely from memory and can be booted from the network. This
page describes how customized Windows PE images can be created, and
optionally published on the network, using only free software packages
on an Arch Linux machine along with Microsoft's Windows Automated
Installation Kit (WAIK). The WAIK can be downloaded at no cost and is
only needed to extract the boot.wim file that contains the initial copy
of Windows PE, along with a couple boot files.

Contents
--------

-   1 Use cases
-   2 Warnings
-   3 Creating a bootable Windows PE ISO
-   4 Booting Windows PE
    -   4.1 In virtual machine
    -   4.2 From CD
    -   4.3 From Network
    -   4.4 Network boot performance
-   5 Customizing Windows PE
-   6 See also

Use cases
---------

Normally, an image of Windows PE can only be created using the Windows
Automated Installation Kit (WAIK) on a Windows machine. However, it is
also possible to create and modify images of Windows PE using an (Arch)
Linux machine, and optionally publish them on the network for PXE
booting. No Windows machine is necessary. You may want to do this if:

-   you need to install Windows from the network, or boot Windows PE
    from the network for system administration, using an Arch
    Linux-based server. This may be because you do not have a
    Windows-based server, or you prefer using a Linux server because of
    its improved security and configurability, or you are already using
    a Linux server for other purposes.
-   you need to run a Windows environment to run Win32 programs, you do
    not have a Windows machine available, and you do not want to use
    Wine or the programs will not run correctly with Wine.

Warnings
--------

If you boot Windows PE on a physical computer, you are placing
Microsoft's closed-source code in control of that computer. You do so at
your own risk.

In addition, by downloading the Windows Automated Installation Kit, you
may be bound by its license, which prevents you from, among other
things, using Windows PE as a general-purpose operating system.

Creating a bootable Windows PE ISO
----------------------------------

1.  Download the Windows Automated Installation Kit (WAIK) from
    Microsoft's website.
    Warning:The entire download, KB3AIK_EN.iso, is 1.7GB.
    Tip:It may be possible to use httpfs to avoid downloading the entire
    file. Only around 118MB of it is actually needed.
2.  Make sure you have the fuse, cdrkit, and cabextract packages
    installed.
3.  Install wimlib from the Arch User Repository.
4.  Mount the WAIK ISO.

         # mkdir /media/waik
         # mount KB3AIK_EN.iso /media/waik

5.  Use the mkwinpeimg script provided with wimlib to create a bootable
    Windows PE ISO winpe.iso. See the man page for mkwinpeimg for more
    information.

        $ mkwinpeimg --iso --waik-dir=/media/waik winpe.iso

6.  Unmount the WAIK ISO.

Booting Windows PE
------------------

After creating a bootable ISO of Windows PE (winpe.iso) as described in
the previous section, you may want to boot Windows PE in the following
ways:

> In virtual machine

Run a virtual machine with winpe.iso attached as a CD-ROM. Be sure to
give it adequate memory, definitely more than the size of the ISO, since
Windows PE runs from memory. For example:

    $ qemu-system-i386 -cdrom winpe.iso -m 512

> From CD

Simply burn winpe.iso onto a CD, and you can boot from it. Again: beware
that if you do this on your Arch Linux machine, you are placing
Microsoft's closed source operating system in control of your computer.

> From Network

Windows PE can be booted from the network using PXELINUX and its MEMDISK
module.

1.  Install syslinux and tftp-hpa.
2.  Copy needed PXELINUX files to the TFTP server root directory.

        # cp /usr/lib/syslinux/{pxelinux.0,menu.c32,memdisk} /var/tftpboot

3.  Put winpe.iso in the TFTP server root directory.

        # mv winpe.iso /var/tftpboot

4.  Create a configuration file for PXELINUX similar to the following:
5.  Start the TFTP server.

        # rc.d start tftpd

6.  Configure your DHCP server (such as Dhcpd or Dnsmasq) to point to
    pxelinux.0 as the boot file, with the Linux server's IP address.
    Beware: if your DHCP server is on a router, it may not be possible
    to do this without installing custom firmware.

After completing the above steps, you should be able to boot Windows PE
from the network. Warning: With the given PXELINUX configuration file,
Windows PE will start by default after 5 seconds.

> Network boot performance

TFTP is not designed to be used to transfer large files, such as
winpe.iso, which may be 118MB or more. Performance may be improved by
using the gpxelinux.0 bootloader instead of pxelinux.0 and loading
winpe.iso using HTTP rather than TFTP.

Customizing Windows PE
----------------------

The mkwinpeimg script provided with wimlib supports making modifications
to Windows PE using the --start-script or --overlay options. See the
manual page for mkwinpeimg for more information.

You may want to do this to add additional Windows applications that you
want to run in Windows PE, or to add any additional drivers that Windows
PE needs (drivers can be loaded using the drvload command within Windows
PE).

See also
--------

-   Microsoft's documentation for Windows PE
-   Another article about making Windows PE images on Linux

Retrieved from
"https://wiki.archlinux.org/index.php?title=Windows_PE&oldid=207377"

Category:

-   System administration

-   This page was last modified on 13 June 2012, at 16:23.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
