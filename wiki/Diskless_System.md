Diskless System
===============

Related articles

-   NFS
-   NFS Troubleshooting
-   PXE
-   Mkinitcpio#Using_net

From Wikipedia:Diskless node

A diskless node (or diskless workstation) is a workstation or personal
computer without disk drives, which employs network booting to load its
operating system from a server.

Contents
--------

-   1 Server configuration
    -   1.1 DHCP
    -   1.2 TFTP
    -   1.3 Network storage
        -   1.3.1 NFS
        -   1.3.2 NBD
-   2 Client installation
    -   2.1 Directory setup
    -   2.2 Bootstrapping installation
        -   2.2.1 NFS
        -   2.2.2 NBD
-   3 Client configuration
    -   3.1 Bootloader
        -   3.1.1 GRUB
        -   3.1.2 Pxelinux
    -   3.2 Additional mountpoints
        -   3.2.1 NBD root
        -   3.2.2 Program state directories
-   4 Client boot
    -   4.1 NBD
-   5 See also

Server configuration
--------------------

First of all, we must install the following components:

-   A DHCP server to assign IP addresses to our diskless nodes.
-   A TFTP server to transfer the boot image (a requirement of all PXE
    option roms).
-   A form of network storage (NFS or NBD) to export the Arch
    installation to the diskless node.

Note:dnsmasq is capable of simultaneously acting as both DHCP and TFTP
server. For more information, see the dnsmasq article.

> DHCP

Install ISC dhcp and configure it:

    /etc/dhcpd.conf

    allow booting;
    allow bootp;

    authoritative;

    option domain-name-servers 10.0.0.1;

    option architecture code 93 = unsigned integer 16;

    group {
        next-server 10.0.0.1;

        if option architecture = 00:07 {
            filename "/grub/x86_64-efi/core.efi";
        } else {
            filename "/grub/i386-pc/core.0";
        }

        subnet 10.0.0.0 netmask 255.255.255.0 {
            option routers 10.0.0.1;
            range 10.0.0.128 10.0.0.254;
        }
    }

Note:next-server should be the address of the TFTP server; everything
else should be changed to match your network

RFC 4578 defines the "Client System Architecture Type" dhcp option. In
the above configuration, if the PXE client requests an x86_64-efi binary
(type 0x7), we appropriately give them one, otherwise falling back to
the legacy binary. This allows both UEFI and legacy BIOS clients to boot
simultaneously on the same network segment.

Start ISC DHCP systemd service.

> TFTP

The TFTP server will be used to transfer the bootloader, kernel, and
initramfs to the client.

Set the TFTP root to /srv/arch/boot. See Tftpd server for installation
and configuration.

> Network storage

The primary difference between using NFS and NBD is while with both you
can in fact have multiple clients using the same installation, with NBD
(by the nature of manipulating a filesystem directly) you will need to
use the copyonwrite mode to do so, which ends up discarding all writes
on client disconnect. In some situations however, this might be highly
desirable.

NFS

Install nfs-utils on the server.

You will need to add the root of your Arch installation to your NFS
exports:

    /etc/exports

    /srv       *(rw,fsid=0,no_root_squash,no_subtree_check)
    /srv/arch  *(rw,no_root_squash,no_subtree_check)

Next, start NFS services: rpc-idmapd rpc-mountd.

NBD

Install nbd and configure it.

    # vim /etc/nbd-server/config

    [generic]
        user = nbd
        group = nbd
    [arch]
        exportname = /srv/arch.img
        copyonwrite = false

Note:Set copyonwrite to true if you want to have multiple clients using
the same NBD share simultaneously; refer to man 5 nbd-server for more
details.

Start nbd systemd service.

Client installation
-------------------

Next we will create a full Arch Linux installation in a subdirectory on
the server. During boot, the diskless client will get an IP address from
the DHCP server, then boot from the host using PXE and mount this
installation as its root.

> Directory setup

Create a sparse file of at least 1 gigabyte, and create a btrfs
filesystem on it (you can of course also use a real block device or LVM
if you so desire).

    # truncate -s 1G /srv/arch.img
    # mkfs.btrfs /srv/arch.img
    # export root=/srv/arch
    # mkdir -p "$root"
    # mount -o loop,discard,compress=lzo /srv/arch.img "$root"

Note:Creating a separate filesystem is required for NBD but optional for
NFS and can be skipped/ignored.

> Bootstrapping installation

Install devtools and arch-install-scripts, and run mkarchroot.

    # pacstrap -d "$root" base mkinitcpio-nfs-utils nfs-utils

Note:In all cases mkinitcpio-nfs-utils is still required. ipconfig used
in early-boot is provided only by the latter.

Now the initramfs needs to be constructed.

NFS

Trivial modifications to the net hook are required in order for NFSv4
mounting to work (not supported by nfsmount--the default for the net
hook).

    # sed s/nfsmount/mount.nfs4/ "$root/usr/lib/initcpio/hooks/net" > "$root/usr/lib/initcpio/hooks/net_nfs4"
    # cp $root/usr/lib/initcpio/install/net{,_nfs4}

The copy of net is unfortunately needed so it does not get overwritten
when mkinitcpio-nfs-utils is updated on the client installation.

Edit /etc/mkinitcpio.conf and add nfsv4 to MODULES, net_nfs4 to HOOKS,
and /usr/bin/mount.nfs4 to BINARIES.

Next, we chroot into our install and run mkinitcpio:

    # arch-chroot "$root" /bin/bash
    # mkinitcpio -p linux

NBD

The mkinitcpio-nbd package needs to be installed on the client. Build it
with makepkg and install it:

    # pacman --root "$root" --dbpath "$root/var/lib/pacman" -U mkinitcpio-nbd-0.4-1-any.pkg.tar.xz

You will then need to append nbd to your HOOKS array after net; net will
configure your networking for you, but not attempt a NFS mount if
nfsroot is not specified in the kernel line.

Client configuration
--------------------

In addition to the setup mentioned here, you should also set up your
hostname, timezone, locale, and keymap, and follow any other relevant
parts of the Installation guide.

> Bootloader

GRUB

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with GRUB.       
                           Notes: (Discuss)         
  ------------------------ ------------------------ ------------------------

Though poorly documented, GRUB supports being loaded via PXE.

    # pacman --root "$root" --dbpath "$root/var/lib/pacman" -S grub

Create a grub prefix on the target installation for both architectures
using grub-mknetdir.

    # arch-chroot /srv/arch grub-mknetdir --net-directory=/boot --subdir=grub

Luckily for us, grub-mknetdir creates prefixes for all currently
compiled/installed targets, and the grub maintainers were nice enough to
give us both in the same package, thus grub-mknetdir only needs to be
run once.

Now we create a trivial GRUB configuration:

    # vim "$root/boot/grub/grub.cfg"

    menuentry "Arch Linux" {
        linux /vmlinuz-linux quiet add_efi_memmap ip=:::::eth0:dhcp nfsroot=10.0.0.1:/arch
        initrd /initramfs-linux.img
    }

GRUB dark-magic will set root=(tftp,10.0.0.1) automatically, so that the
kernel and initramfs are transferred via TFTP without any additional
configuration, though you might want to set it explicitly if you have
any other non-tftp menuentries.

Note:Modify your kernel line as-necessary, refer to Pxelinux for
NBD-related options

Pxelinux

Pxelinux is provided by syslinux, see here for detail.

> Additional mountpoints

NBD root

In late boot, you'll want to switch your root filesystem mount to both
rw, and enable compress=lzo, for much improved disk performance in
comparison to NFS.

    # vim "$root/etc/fstab"

    /dev/nbd0  /  btrfs  rw,noatime,discard,compress=lzo  0 0

Program state directories

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: systemd can      
                           apparently be told to    
                           not use persistent       
                           logging, and does this   
                           by default anyway then   
                           /var/log is tmpfs        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

You could mount /var/log, for example, as tmpfs so that logs from
multiple hosts don't mix unpredictably, and do the same with
/var/spool/cups, so the 20 instances of cups using the same spool don't
fight with each other and make 1,498 print jobs and eat an entire ream
of paper (or worse: toner cartridge) overnight.

    # vim "$root/etc/fstab"

    tmpfs   /var/log        tmpfs     nodev,nosuid    0 0
    tmpfs   /var/spool/cups tmpfs     nodev,nosuid    0 0

It would be best to configure software that has some sort of
state/database to use unique state/database storage directories for each
host. If you wanted to run puppet, for example, you could simply use the
%H specifier in the puppet unit file:

    # vim "$root/etc/systemd/system/puppetagent.service"

    [Unit]
    Description=Puppet agent
    Wants=basic.target
    After=basic.target network.target

    [Service]
    Type=forking
    PIDFile=/run/puppet/agent.pid
    ExecStartPre=/usr/bin/install -d -o puppet -m 755 /run/puppet
    ExecStart=/usr/bin/puppet agent --vardir=/var/lib/puppet-%H --ssldir=/etc/puppet/ssl-%H

    [Install]
    WantedBy=multi-user.target

Puppet-agent creates vardir and ssldir if they do not exist.

If neither of these approaches are appropriate, the last sane option
would be to create a systemd generator that creates a mount unit
specific to the current host (specifiers are not allowed in mount units,
unfortunately).

Client boot
-----------

> NBD

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: When using COW   
                           on the server, the       
                           clients all effectively  
                           have read-only mounts of 
                           the original filesystem; 
                           it should theoretically  
                           be safe to do a          
                           read-write mount on the  
                           NBD server (Discuss)     
  ------------------------ ------------------------ ------------------------

If you're using NBD, you'll need to umount the arch.img before/while you
boot your client.

This makes things particularly interesting when it comes to kernel
updates. You can't have your client filesystem mounted while you're
booting a client, but that also means you need to use a kernel separate
from your client filesystem in order to build it.

You'll need to first copy $root/boot from the client installation to
your tftp root (i.e. /srv/boot).

    # cp -r "$root/boot" /srv/boot

You will then need to umount $root before you start the client.

    # umount "$root"

Note:To update the kernel in this setup, you either need to mount
/srv/boot using NFS in fstab on the client (prior to doing the kernel
update) or mount your client filesystem after the client has
disconnected from NBD

See also
--------

-   kernel.org: Mounting the root filesystem via NFS (nfsroot)
-   syslinux.org: pxelinux FAQ

Retrieved from
"https://wiki.archlinux.org/index.php?title=Diskless_System&oldid=298232"

Category:

-   Getting and installing Arch

-   This page was last modified on 16 February 2014, at 07:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
