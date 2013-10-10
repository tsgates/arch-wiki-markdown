Diskless System
===============

> Summary

Detailed explanation of diskless system setup.

> Related

NFS

NFS Troubleshooting

PXE

Mkinitcpio#Using_net

From Wikipedia:Diskless node

A diskless node (or diskless workstation) is a workstation or personal
computer without disk drives, which employs network booting to load its
operating system from a server.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Server configuration                                               |
|     -   1.1 DHCP                                                         |
|     -   1.2 TFTP                                                         |
|     -   1.3 Network storage                                              |
|         -   1.3.1 NFS                                                    |
|             -   1.3.1.1 NFSv4                                            |
|             -   1.3.1.2 NFSv3                                            |
|                                                                          |
|         -   1.3.2 NBD                                                    |
|                                                                          |
| -   2 Client installation                                                |
|     -   2.1 Directory setup                                              |
|     -   2.2 Bootstrapping installation                                   |
|         -   2.2.1 NFSv3                                                  |
|         -   2.2.2 NFSv4                                                  |
|         -   2.2.3 NBD                                                    |
|                                                                          |
| -   3 Client configuration                                               |
|     -   3.1 Bootloader                                                   |
|         -   3.1.1 GRUB                                                   |
|         -   3.1.2 Pxelinux                                               |
|                                                                          |
|     -   3.2 Additional mountpoints                                       |
|         -   3.2.1 NBD root                                               |
|         -   3.2.2 Program state directories                              |
|                                                                          |
| -   4 Client boot                                                        |
|     -   4.1 NBD                                                          |
|                                                                          |
| -   5 References                                                         |
+--------------------------------------------------------------------------+

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

Install ISC dhcp.

    # pacman -Syu dhcp

Configure ISC DHCP.

    # vim /etc/dhcpd.conf

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

Start ISC DHCP.

    # systemctl start dhcpd4.service

> TFTP

The TFTP server will be used to transfer the bootloader, kernel, and
initramfs to the client.

Set the TFTP root to /srv/arch/boot. See Tftpd server for installation
and configuration.

> Network storage

The primary difference between using NFS and NBD is while with both you
can in fact have multiple clients using the same installation, with NBD
(by the nature of manipulating a filesystem directly) you'll need to use
the copyonwrite mode to do so, which ends up discarding all writes on
client disconnect. In some situations however, this might be highly
desirable.

NFS

Install nfs-utils on the server.

    # pacman -Syu nfs-utils

NFSv4

You'll need to add the root of your arch installation to your NFS
exports:

    # vim /etc/exports

    /srv       *(rw,fsid=0,no_root_squash,no_subtree_check)
    /srv/arch  *(rw,no_root_squash,no_subtree_check)

Next, start NFS.

    # systemctl start rpc-idmapd.service rpc-mountd.service

NFSv3

    # vim /etc/exports

    /srv/arch *(rw,no_root_squash,no_subtree_check,sync)

Next, start NFSv3.

    # systemctl start rpc-mountd.service rpc-statd.service

Note:If you're not worried about data loss in the event of network
and/or server failure, replace sync with async--additional options can
be found in the NFS article.

NBD

Install nbd.

    # pacman -Syu nbd

Configure nbd.

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

Start nbd.

    # systemctl start nbd.service

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

    # pacman -Syu devtools arch-install-scripts
    # mkarchroot "$root" base mkinitcpio-nfs-utils nfs-utils

Note:In all cases mkinitcpio-nfs-utils is still required--ipconfig used
in early-boot is provided only by the latter.

Now the initramfs needs to be constructed. The shortest configuration,
#NFSv3, is presented as a "base" upon which all subsequent sections
modify as-needed.

NFSv3

    # vim "$root/etc/mkinitcpio.conf"

    MODULES="nfsv3"
    HOOKS="base udev autodetect modconf block filesystems keyboard fsck net"
    BINARIES=""

Note:You'll also need to add the appropriate module for your ethernet
controller to the MODULES array.

The initramfs now needs to be rebuilt; the easiest way to do this is via
arch-chroot.

    # arch-chroot "$root" /bin/bash
    (chroot) # mkinitcpio -p linux
    (chroot) # exit

NFSv4

Trivial modifications to the net hook are required in order for NFSv4
mounting to work (not supported by nfsmount--the default for the net
hook).

    # sed s/nfsmount/mount.nfs4/ "$root/usr/lib/initcpio/hooks/net" | tee "$root/usr/lib/initcpio/hooks/net_nfs4"
    # cp "$root/usr/lib/initcpio/install/{net,net_nfs4}"

The copy of net is unfortunately needed so it does not get overwritten
when mkinitcpio-nfs-utils is updated on the client installation.

From the base mkinitcpio.conf, replace the nfsv3 module with nfsv4,
replace net with net_nfs4, and add /sbin/mount.nfs4 to BINARIES and
don't forget to add your network driver to MODULES like this for a
Realtek Ethernet controller.

    # vim "$root/etc/mkinitcpio.conf"

    MODULES="nfsv4 8139cp"
    HOOKS="base udev autodetect modconf block filesystems keyboard fsck net_nfs4"
    BINARIES="/sbin/mount.nfs4"

Note:You'll also need to add the appropriate module for your ethernet
controller to the MODULES array.

NBD

The mkinitcpio-nbd package needs to be installed on the client.

    # pacman --root "$root" --dbpath "$root/var/lib/pacman" -U mkinitcpio-nbd-0.4-1-any.pkg.tar

You will then need to append nbd to your HOOKS array after net; net will
configure your networking for you, but not attempt a NFS mount if
nfsroot is not specified in the kernel line.

Client configuration
--------------------

In addition to the setup mentioned here, you should also set up your
hostname, timezone, locale, and keymap, and follow any other relevant
parts of the Installation Guide.

> Bootloader

GRUB

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with GRUB2.      
                           Notes: (Discuss)         
  ------------------------ ------------------------ ------------------------

Though poorly documented, grub also supports being loaded via PXE.
Because of an endianness bug in grub-core/net/tftp.c not fixed until bzr
revision 4548 (grub-bios 2.00 is revision 4542), you will need to build
grub-bios-bzr; it makes the most sense to do this on the host
installation. In addition, due to a bug in
grub-core/net/drivers/efi/efinet.c not fixed until bzr revision 4751
you'll need to build grub-efi-x86_64-bzr as well. The Arch User
Repository article describes how to build AUR packages.

    # pacman --root "$root" --dbpath "$root/var/lib/pacman" -U grub-bios-bzr-4751-1-x86_64.pkg.tar.xz

Only because we want to use the grub-bios-bzr installation on the
target, we arch-chroot the target installation so we can use its
grub-mknetdir instead.

    # arch-chroot /srv/arch grub-mknetdir --net-directory=/boot --subdir=grub

Next, flip to the grub-efi-x86_64-bzr package you built, and run
grub-mknetdir exactly as above a second time.

    # pacman --root "$root" --dbpath "$root/var/lib/pacman" -U grub-bios-bzr-4751-1-x86_64.pkg.tar.xz

Now we create a trivial grub configuration:

    # vim "$root/boot/grub/grub.cfg"

    menuentry "Arch Linux" {
        linux /vmlinuz-linux quiet add_efi_memmap ip=:::::eth0:dhcp nfsroot=10.0.0.1:/arch
        initrd /initramfs-linux.img
    }

GRUB dark-magic will set root=(tftp,10.0.0.1) automatically, so that the
kernel and initramfs are transferred via TFTP without any additional
configuration, though you might want to set it explicitly if you have
any other non-tftp menuentries.

Note:Modify your kernel line as-necessary, refer to #Pxelinux for
NBD-related options

Pxelinux

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Syslinux.   
                           Notes: (Discuss)         
  ------------------------ ------------------------ ------------------------

Note:syslinux at present has no UEFI networking stack, so you'll be
unable to use syslinux-efi-git (as is possible with #GRUB) and still
expect to be able to tftp your kernel and initramfs; pxelinux still
works fine for legacy PXE booting

Install syslinux.

    # pacman -Syu syslinux

Copy the pxelinux bootloader (provided by the syslinux package) to the
boot directory of the client.

    # cp /usr/lib/syslinux/pxelinux.0 "$root/boot"
    # mkdir "$root/boot/pxelinux.cfg"

We also created the pxelinux.cfg directory, which is where pxelinux
searches for configuration files by default. Because we don't want to
discriminate between different host MACs, we then create the default
configuration.

    # vim "$root/boot/pxelinux.cfg/default"

    default linux

    label linux
    kernel vmlinuz-linux
    append initrd=initramfs-linux.img quiet ip=:::::eth0:dhcp nfsroot=10.0.0.1:/arch

NFSv3 mountpoints are relative to the root of the server, not fsid=0. If
you're using NFSv3, you'll need to pass 10.0.0.1:/srv/arch to nfsroot.

Or if you are using NBD, use the following append line:

    append ro initrd=initramfs-linux.img ip=:::::eth0:dhcp nbd_host=10.0.0.1 nbd_name=arch root=/dev/nbd0

Note:You will need to change nbd_host and/or nfsroot, respectively, to
match your network configuration (the address of the NFS/NBD server)

The pxelinux configuration syntax identical to syslinux; refer to the
upstream documentation for more information.

The kernel and initramfs will be transferred via TFTP, so the paths to
those are going to be relative to the TFTP root. Otherwise, the root
filesystem is going to be the NFS mount itself, so those are relative to
the root of the NFS server.

To actually load pxelinux, replace filename "/grub/i386-pc/core.0"; in
/etc/dhcpd.conf with filename "/pxelinux.0"

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

You'll then need to umount $root before you start the client.

    # umount "$root"

Note:To update the kernel in this setup, you either need to mount
/srv/boot using NFS in fstab on the client (prior to doing the kernel
update) or mount your client filesystem after the client has
disconnected from NBD

References
----------

kernel.org: Mounting the root filesystem via NFS (nfsroot)

syslinux.org: pxelinux FAQ

Retrieved from
"https://wiki.archlinux.org/index.php?title=Diskless_System&oldid=256155"

Category:

-   Getting and installing Arch
