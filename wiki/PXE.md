PXE
===

Summary

Detailed guide to booting official installation media via PXE.

Related

Network Installation Guide

From Wikipedia:Preboot Execution Environment:

The Preboot eXecution Environment (PXE, also known as Pre-Execution
Environment; sometimes pronounced "pixie") is an environment to boot
computers using a network interface independently of data storage
devices (like hard disks) or installed operating systems.

In this guide, PXE is used to boot the installation media with an
appropriate option-rom that supports PXE on the target.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preparation                                                        |
| -   2 Server setup                                                       |
|     -   2.1 Network                                                      |
|     -   2.2 DHCP + TFTP                                                  |
|     -   2.3 HTTP                                                         |
|                                                                          |
| -   3 Installation                                                       |
|     -   3.1 Boot                                                         |
|     -   3.2 Post-boot                                                    |
|                                                                          |
| -   4 Alternate Methods                                                  |
|     -   4.1 NFS                                                          |
|     -   4.2 NBD                                                          |
|     -   4.3 Low memory                                                   |
+--------------------------------------------------------------------------+

Preparation
-----------

Download the latest official install media from here.

Next mount the image:

    # mkdir -p /mnt/archiso
    # mount -o loop,ro archlinux-2013.02.01-dual.iso /mnt/archiso

Server setup
------------

You'll need to setup a DHCP, TFTP, and HTTP server to configure
networking, load pxelinux/kernel/initramfs, and finally load the root
filesystem (respectively).

> Network

Bring up your wired NIC, and assign it an address appropriately.

    # ip link set eth0 up
    # ip addr add 192.168.0.1/24 dev eth0

> DHCP + TFTP

You'll need both a DHCP and TFTP server to configure networking on the
install target and to facilitate the transfer of files between the PXE
server and client; dnsmasq does both, and is extremely easy to set up.

Install dnsmasq:

    # pacman -S dnsmasq

Configure dnsmasq:

    # vim /etc/dnsmasq.conf

    port=0
    interface=eth0
    bind-interfaces
    dhcp-range=192.168.0.50,192.168.0.150,12h
    dhcp-boot=/arch/boot/syslinux/pxelinux.0
    dhcp-option-force=209,boot/syslinux/archiso.cfg
    dhcp-option-force=210,/arch/
    enable-tftp
    tftp-root=/mnt/archiso

Start dnsmasq:

    # systemctl start dnsmasq.service

> HTTP

Thanks to recent changes in archiso, it is now possible to boot from
HTTP (archiso_pxe_http initcpio hook) or NFS (archiso_pxe_nfs initcpio
hook); among all alternatives, darkhttpd is by far the most trivial to
setup (and the lightest-weight).

First, install darkhttpd:

    # pacman -S darkhttpd

Then start darkhttpd using our /mnt/archiso as the document root:

    # darkhttpd /mnt/archiso

    darkhttpd/1.8, copyright (c) 2003-2011 Emil Mikulic.
    listening on: http://0.0.0.0:80/

Installation
------------

For this portion you'll need to figure out how to tell the client to
attempt a PXE boot; in the corner of the screen along with the normal
post messages, usually there will be some hint on which key to press to
try PXE booting first. On an IBM x3650 F12 brings up a boot menu, the
first option of which is Network; on a Dell PE 1950/2950 pressing F12
initiates PXE booting directly.

> Boot

Looking at journald on the PXE server will provide some additional
insight to what exactly is going on during the early stages of the PXE
boot process:

    # journalctl -u dnsmasq -f

    dnsmasq-dhcp[2544]: DHCPDISCOVER(eth1) 00:1a:64:6a:a2:4d 
    dnsmasq-dhcp[2544]: DHCPOFFER(eth1) 192.168.0.110 00:1a:64:6a:a2:4d 
    dnsmasq-dhcp[2544]: DHCPREQUEST(eth1) 192.168.0.110 00:1a:64:6a:a2:4d 
    dnsmasq-dhcp[2544]: DHCPACK(eth1) 192.168.0.110 00:1a:64:6a:a2:4d 
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/syslinux/pxelinux.0 to 192.168.0.110
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/syslinux/archiso.cfg to 192.168.0.110
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/syslinux/whichsys.c32 to 192.168.0.110
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/syslinux/archiso_pxe_choose.cfg to 192.168.0.110
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/syslinux/ifcpu64.c32 to 192.168.0.110
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/syslinux/archiso_pxe_both_inc.cfg to 192.168.0.110
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/syslinux/archiso_head.cfg to 192.168.0.110
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/syslinux/archiso_pxe32.cfg to 192.168.0.110
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/syslinux/archiso_pxe64.cfg to 192.168.0.110
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/syslinux/archiso_tail.cfg to 192.168.0.110
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/syslinux/vesamenu.c32 to 192.168.0.110
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/syslinux/splash.png to 192.168.0.110

After you load pxelinux.0 and archiso.cfg via TFTP, you'll (hopefully)
be presented with a syslinux boot menu with several options, two of
which are of potential usefulness to us.

Select either

    Boot Arch Linux (x86_64) (HTTP)

or

    Boot Arch Linux (i686) (HTTP)

depending on your CPU architecture.

Next the kernel and initramfs (appropriate for the architecture you
selected) will be transferred, again via TFTP:

    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/x86_64/vmlinuz to 192.168.0.110
    dnsmasq-tftp[2544]: sent /mnt/archiso/arch/boot/x86_64/archiso.img to 192.168.0.110

If all goes well, you should then see activity on darkhttpd coming from
the PXE-target; at this point the kernel would be loaded on the
PXE-target, and in init:

    1348347586 192.168.0.110 "GET /arch/aitab" 200 678 "" "curl/7.27.0"
    1348347587 192.168.0.110 "GET /arch/x86_64/root-image.fs.sfs" 200 107860206 "" "curl/7.27.0"
    1348347588 192.168.0.110 "GET /arch/x86_64/usr-lib-modules.fs.sfs" 200 36819181 "" "curl/7.27.0"
    1348347588 192.168.0.110 "GET /arch/any/usr-share.fs.sfs" 200 63693037 "" "curl/7.27.0"

After the root filesystem is downloaded via HTTP, you'll eventually end
up at a root zsh prompt with that fancy grml config.

> Post-boot

Unless you want all traffic to be routed through your PXE server (which
won't work anyway unless you set it up properly), you'll want to kill
dnsmasq and get a new lease on the install target, as appropriate for
your network layout.

    # systemctl stop dnsmasq.service

You can also kill darkhttpd; the target has already downloaded the root
filesystem, so it's no longer needed. While you're at it, you can also
unmount the installation image:

    # umount /mnt/archiso

At this point you can follow the official installation guide.

Alternate Methods
-----------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: verify (Discuss) 
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

As implied in the syslinux menu, there are several other alternatives:

> NFS

You will need to setup a NFS server with the root export at the root of
your mounted installation media--that would be /mnt/archiso if you
followed the earlier sections of this guide.

> NBD

Install nbd and configure it:

    # vim /etc/nbd-server/config

    [generic]
    [archiso]
        readonly = true
        exportname = /srv/archlinux-2013.02.01-dual.iso

> Low memory

The copytoram initramfs option can be used to control whether the root
filesystem should be copied to ram in its entirety in early-boot.

It highly recommended to leave this option alone, and should only be
disabled if entirely necessary (systems with less than ~256MB physical
memory). Append copytoram=n to your kernel line if you wish to do so.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PXE&oldid=248919"

Categories:

-   Getting and installing Arch
-   Networking
-   Boot process
