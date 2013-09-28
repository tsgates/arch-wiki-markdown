Xen
===

This document explains how to use Xen 4.2 in Arch. It uses the new
oxenstored / xl toolstack (replaces the xend / xm toolstack which was
deprecated in Xen 4.1).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 What is Xen?                                                       |
| -   2 Types of Virtualization Available with Xen                         |
|     -   2.1 Paravirtual (PV)                                             |
|     -   2.2 Hardware Virtual (HVM)                                       |
|                                                                          |
| -   3 Obtaining Xen                                                      |
| -   4 Configuring Xen                                                    |
|     -   4.1 Bootloader Configuration                                     |
|     -   4.2 Systemd Services                                             |
|     -   4.3 Xenfs Mountpoint                                             |
|     -   4.4 Bridged Networking                                           |
|     -   4.5 Final Steps                                                  |
|                                                                          |
| -   5 Using Xen                                                          |
|     -   5.1 Creating a Paravirtualized (PV) Arch domU                    |
|     -   5.2 Useful xl command examples                                   |
|                                                                          |
| -   6 Common Errors                                                      |
| -   7 Resources                                                          |
+--------------------------------------------------------------------------+

What is Xen?
------------

According to the Xen development team:

"The Xen hypervisor, the powerful open source industry standard for
virtualization, offers a powerful, efficient, and secure feature set for
virtualization of x86, x86_64, IA64, PowerPC, and other CPU
architectures. It supports a wide range of guest operating systems
including Windows®, Linux®, Solaris®, and various versions of the BSD
operating systems."

The Xen hypervisor is a thin layer of software which emulates a computer
architecture. It is started by the boot loader of the computer it is
installed on, and allows multiple operating systems to run
simultaneously on top of it. Once the Xen hypervisor is loaded, it
starts the "Dom0" (short for "domain 0"), or privileged domain, which in
our case runs a Linux kernel (other possible Dom0 operating systems are
NetBSD and OpenSolaris). The physical hardware must, of course, be
supported by this kernel to run Xen. Once the Dom0 has started, one or
more "DomUs" (short for user domains, sometimes called VMs) can be
started and controlled from Dom0.

Xen.org provides a full overview

Types of Virtualization Available with Xen
------------------------------------------

> Paravirtual (PV)

Paravirtualized guests require a kernel with support for Xen built in.
This is default for all recent Linux kernels and some other Unix-like
systems. Paravirtualized domUs usually run faster than HVM domains as
they do not have to run in emulated hardware.

> Hardware Virtual (HVM)

For OSes that do not natively support Xen (e.g. Windows), HVM offers
full hardware virtualization. To use HVM in Xen, the host system
hardware must include either Intel VT-x or AMD-V (SVM) virtualization
support. In order to verify this, run the following command on the host
system:

    grep -E "(vmx|svm)" --color=always /proc/cpuinfo

If the above command does not produce output, then hardware
virtualization support is unavailable and your hardware is unable to run
Xen HVM guests. It is also possible that the host CPU supports one of
these features, but that the functionality is disabled by default in the
system BIOS. To verify this, access the host system's BIOS configuration
menu during the boot process and look for an option related to
virtualization support. If such an option exists and is disabled, then
enable it, boot the system and repeat the above command.

Obtaining Xen
-------------

Xen is available from the AUR. The recommended current stable version is
Xen 4.2, and the bleeding edge unstable package can be found here. Both
packages provide the Xen hypervisor, current xl interface and all
configuration and support files, including systemd services.

Xen, unlike certain other virtualization systems, relies on a full
install of the base operating system. Before attempting to install Xen,
your host machine should have a fully operational and up-to-date install
of Arch Linux. If you are building a new host from scratch, see the
Installation Guide for instructions on installing Arch Linux.

Like all AUR packages, the Xen binaries are built from source. Note that
it is possible (but not necessary) to build the package on a separate
machine and transfer the xz package over, assuming that the machines
share the same architecture (e.g. x86_64). For Xen, an internet
connection is needed during its compilation because further source files
are downloaded during the process. Xen.org recommends a host to be
64-bit. This requires the 'multilib' repository to be enabled in
etc/pacman.conf.

To build the package you will need the following:

    base-devel zlib lzo2 python2 ncurses openssl libx11 yajl 
    libaio glib2 bridge-utils iproute gettext
    dev86 bin86 iasl markdown git wget

    optional packages:  ocaml ocaml-findlib

You will need to enable the 'extra' repository to get bin86. A tool such
as yaourt or packer can aid in downloading, compiling and installing
dependencies for AUR packages.

Configuring Xen
---------------

The following configuration steps are required once the Xen package is
installed.

The dom0 host requires

-   an entry in the bootloader configuration file
-   systemd services to be started at boot time
-   a xenfs filesystem mount point
-   bridged networking configuration

In addition to these required steps, the current xen.org wiki has a
section regarding best practices for running Xen. It includes
information on allocating a fixed amount of memory dom0 and how to
dedicate (pin) a CPU core for dom0 use.

> Bootloader Configuration

Xen requires that you boot a special xen kernel (xen.gz) which in turn
boots your system's normal kernel. A new bootloader entry is needed. To
boot into the Xen system, we need a new menuentry in grub.cfg. The Xen
package provides a grub2 generator file: /etc/grub.d/09_xen. This file
can be edited to customize the Xen boot commands, and will add a
menuentry to your grub.cfg when the following command is run:

    grub-mkconfig -o /boot/grub/grub.cfg

Example non-xen menuentry for LVM with gpt partition table

    menuentry 'Arch ' {
      insmod part_gpt
      insmod lvm
      insmod ext2
      set root='lvm/vg0-arch'
      linux /boot/vmlinuz-linux root=/dev/mapper/vg0-arch ro init=/usr/lib/systemd/systemd quiet
      initrd /boot/initramfs-linux.img
    }

The menuentry to boot the same arch system after Xen has been installed.
Get the UUID for lvm/vg0-arch by using blkid.

    menuentry 'Arch Xen 4.2' {
      insmod lvm
      insmod part_gpt
      insmod ext2
      set root='lvm/vg0-arch'
      search --no-floppy --fs-uuid --set=root 346de8aa-6150-4d7b-a8c2-1c43f5929f99
      multiboot /boot/xen.gz placeholder dom0_mem=1024M
      module /boot/vmlinuz-linux placeholder root=/dev/mapper/vg0-arch ro init=/usr/lib/systemd/systemd quiet
      module  /boot/initramfs-linux.img
    }

Example for a physical partition

    Arch Linux(XEN)
    menuentry "Arch Linux(XEN)" {
        set root=(hd0,X)
      search --no-floppy --fs-uuid --set=root 346de8aa-6150-4d7b-a8c2-1c43f5929f99
        multiboot /boot/xen.gz dom0_mem=1024M
        module /boot/vmlinuz-linux-xen-dom0 root=/dev/sda ro
        module /boot/initramfs-linux-xen-dom0.img
    }

More at Grub2

> Systemd Services

Issue the following commands as root so that the services are started at
bootup:

    # systemctl enable xenstored.service
    # systemctl enable xenconsoled.service
    # systemctl enable xendomains.service

> Xenfs Mountpoint

Include in your /etc/fstab

     none /proc/xen xenfs defaults 0 0

> Bridged Networking

Previous versions of Xen provided a bridge connection whereas Xen 4.2
requires that network communications between the guest, the host (and
beyond) is set up separately. The use of both DHCP and static addressing
is possible, and the choice should be determined by your network
topology. With basic bridged networking, a virtual switch is created in
dom0 that every domu is attached to. More complex setups are possible,
see the Networking article on the Xen wiki for details.

Netcfg greatly simplifies network configuration and is now included as
standard in the base package. Example configuration files are provided
in etc/network.d/examples and Xen 4.2 provides scripts for various
networking configurations in /etc/xen/scripts.

By default, Xen expects a bridge to exist named xenbr0. To set this up
with netcfg, do the following:

    # cd /etc/network.d
    # cp examples/bridge xenbridge-dhcp

make the following changes to xen-bridge:

    INTERFACE="xenbr0"
    BRIDGE_INTERFACE="eth0" # Use the name of the external interface found with the 'ip link' command
    DESCRIPTION="Xen bridge connection"

assuming your existing eth0 connection is called eth0-dhcp, edit
/etc/conf.d/netcfg

    NETWORKS=(eth0-dhcp xenbridge-dhcp)

restart the network:

    systemctl restart netcfg.service

when the prompt returns, check all is well

    ip addr show
    brctl show

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
       inet 127.0.0.1/8 scope host lo
       inet6 ::1/128 scope host 
          valid_lft forever preferred_lft forever
    3: xenbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
       link/ether 00:1a:92:06:c0:c0 brd ff:ff:ff:ff:ff:ff
       inet 192.168.1.3/24 brd 192.168.1.255 scope global xenbr0
       inet6 fe80::21a:92ff:fe06:c0c0/64 scope link 
          valid_lft forever preferred_lft forever

    bridge name	bridge id		STP enabled	interfaces
    xenbr0		8000.001a9206c0c0	no		eth0

> Final Steps

Reboot your dom0 host and ensure that the Xen kernel boots correctly and
that all settings survive a reboot. A properly set up dom0 should report
show the following when you run xl list (as root):

    # xl list
    Name                                        ID   Mem VCPUs	State	Time(s)
    Domain-0                                     0   511     2     r-----   41652.9

Of course, the Mem, VCPUs and Time columns will be different depending
on machine configuration and uptime. The important thing is that dom0 is
listed.

Using Xen
---------

Once the dom0 is fully operational, domUs may be created / imported.
Each OS has a slightly different method of installation, see the Guest
Install page of the Xen wiki for links to instructions.

> Creating a Paravirtualized (PV) Arch domU

This is how to install Arch as a user domain (or VM) on an
already-running Xen host. To install Arch as the Xen host (dom0), see
the previous section.

To begin, download the latest install ISO from the nearest mirror:
Dowload page. Place the ISO file on the dom0 host. (it is recommended
that its checksum be verified, too)

Create the hard disks for the new domU. This can be done with LVM, raw
hard disk partitions or image files. To create a 10GiB blank hard disk
file, the following command can be used:

    truncate -s 10G sda.img

This creates a sparse file, which grows (to a maximum of 10GiB) only
when data is added to the image. If file IO speed is of greater
importance than domain portability, using a Logical Volume or raw
partition may be a better choice.

Next, loop-mount the installation ISO. To do this, ensure the directory
/mnt exists and is empty, then run the following command (being sure to
fill in the correct ISO path):

    # mount -o loop /path/to/iso /mnt

Create the bootstrap domU configuration file:

    /etc/xen/archdomu.cfg

    kernel = "/mnt/arch/boot/x86_64/vmlinuz"
    ramdisk = "/mnt/arch/boot/x86_64/archiso.img"
    extra = "archisobasedir=arch archisolabel=ARCH_201301"
    memory = 256
    name = "archdomu"
    disk = [ "phy:/path/to/partition,sda1,w", "file:/path/to/ISO,sdb,r" ]
    vif = [ 'mac=00:16:3e:__random_three_mac_bytes__,bridge=xenbr0' ]

This file needs to tweaked for your specific use. Most importantly, the
archisolabel=ARCH_201301 line must be edited to use the release
year/month of the ISO being used. If you want to install 32-bit Arch,
change the kernel and ramdisk paths from /x86_64/ to /i686/. The
"phy:/path/to/partition,sda1,w" line must be edited to point to the
partition created for the domU. If an image file is being used, the phy:
needs to be changed to file:. Finally, a MAC address must be assigned.
The 00:16:3e MAC block is reserved for Xen domains, do the last three
digits may be randomly filled in (hex values 0-9 and a-f only). See the
xl.cfg man page for more information on what the .cfg file lines do. The
AUR package xen-docs will need to be installed to access the man pages.

Create the new domU:

    # xl create -c /etc/xen/archdomu.cfg

The -c option will enter the new domain's console when successfully
created. At this point, Arch should be installed as usual. The
Installation Guide should be followed. There will be a few deviations,
however. The block devices listed in the disks line of the cfg file will
show up as /dev/xvd*. Use these devices when partitioning the domU.
After installation and before the domU is rebooted, the following
modules must be added to /etc/mkinitcpio.conf:

    MODULES="xen-blkfront xen-fbfront xen-netfront xen-kbdfront"

Without these modules, the domU will not boot correctly. After saving
the edit, rebuild the initramfs with the following command:

    mkinitcpio -p linux

For booting, it is not necessary to install Grub. Xen has a Python-based
grub emulator, so all that is needed to boot is a grub.cfg file: (It may
be necessary to create the /boot/grub directory)

    /boot/grub/grub.cfg

    menuentry 'Arch GNU/Linux, with Linux core repo kernel' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-core repo kernel-true-__UUID__' {
            insmod gzio
            insmod part_msdos
            insmod ext2
            set root='hd0,msdos1'
            if [ x$feature_platform_search_hint = xy ]; then
              search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1  __UUID__
            else
              search --no-floppy --fs-uuid --set=root __UUID__
            fi
            echo    'Loading Linux core repo kernel ...'
            linux   /boot/vmlinuz-linux root=UUID=__UUID__ ro
            echo    'Loading initial ramdisk ...'
            initrd  /boot/initramfs-linux.img
    }

This file must be edited to match the UUID of the root partition. From
within the domU, run the following command:

    # blkid

Replace all instances of __UUID__ with the real UUID of the root
partition (the one that mounts as "/").

Shutdown the domU with the poweroff command. The console will be
returned to the hypervisor when the domain is fully shut down, and the
domain will no longer appear in the xl domains list. Now the ISO file
may be unmounted:

    # umount /mnt

The domU cfg file should now be edited. Delete the "kernel = ", "ramdisk
= ", and "extra = " lines and replace them with the following line:

    bootloader = "pygrub"

Also remove the ISO disk from the "disk = " line.

The Arch domU is now set up. It may be started with the same line as
before:

    # xl create -c /etc/xen/archdomu.cfg

If the domU should be started on boot, create a symlink to the cfg file
in /etc/xen/auto and ensure the xendomains service is set up correctly.

> Useful xl command examples

    # xl top
    # xl list
    # xl console domUname
    # xl shutdown domUname
    # xl destroy domUname

Common Errors
-------------

-   'xl list' complains about libxl

- Either you have not booted into the Xen system, or xen modules listed
in xencommons script are not installed

-   xl create fails

- check the guest's kernel is located correctly, check the pv-xxx.cfg
file for spelling mistakes (like using initrd instead of ramdisk)

-   Arch linux guest hangs with a ctrl-d message

- press ctrl-d until you get back to a prompt, rebuild its initramfs
described

-   Error message "failed to execute
    '/usr/lib/udev/socket:/org/xen/xend/udev_event'
    'socket:/org/xen/xend/udev_event': No such file or directory"

- caused by /etc/udev/rules.d/xend.rules; xend is (a) deprecated and (b)
not used, so it is safe to remove xend.rules

Resources
---------

-   The homepage at xen.org
-   The wiki at xen.org

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xen&oldid=255049"

Categories:

-   Virtualization
-   Kernel
