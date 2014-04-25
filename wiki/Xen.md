Xen
===

Related articles

-   KVM
-   QEMU
-   VirtualBox
-   VMware
-   Moving an existing install into (or out of) a virtual machine

From Xen Overview:

Xen is an open-source type-1 or baremetal hypervisor, which makes it
possible to run many instances of an operating system or indeed
different operating systems in parallel on a single machine (or host).
Xen is the only type-1 hypervisor that is available as open source. Xen
is used as the basis for a number of different commercial and open
source applications, such as: server virtualization, Infrastructure as a
Service (IaaS), desktop virtualization, security applications, embedded
and hardware appliances.

Contents
--------

-   1 Introduction
-   2 System requirements
-   3 Configuring dom0
    -   3.1 Installation of the Xen hypervisor
    -   3.2 Modification of the bootloader
    -   3.3 Creation of a network bridge
    -   3.4 Installation of Xen systemd services
    -   3.5 Confirming successful installation
-   4 Using Xen
    -   4.1 Create a domU "hard disk"
    -   4.2 Create a domU configuration
    -   4.3 Managing a domU
-   5 Configuring a hardware virtualized (HVM) Arch domU
-   6 Configuring a paravirtualized (PV) Arch domU
-   7 Common Errors
-   8 Resources

Introduction
------------

The Xen hypervisor is a thin layer of software which emulates a computer
architecture allowing multiple operating systems to run simultaneously.
The hypervisor is started by the boot loader of the computer it is
installed on. Once the hypervisor is loaded, it starts the "dom0" (short
for "domain 0", sometimes called the host or privileged domain) which in
our case runs Arch Linux. Once the dom0 has started, one or more "domUs"
(short for user domains, sometimes called VMs or guests) can be started
and controlled from the dom0. Xen supports both paravirtualized (PV) and
hardware virtualized (HVM) domUs. See Xen.org for a full overview.

System requirements
-------------------

The Xen hypervisor requires kernel level support which is included in
recent Linux kernels and is built into the linux and linux-lts Arch
kernel packages. To run HVM domUs, the physical hardware must have
either Intel VT-x or AMD-V (SVM) virtualization support. In order to
verify this, run the following command when the Xen hypervisor is not
running:

    $ grep -E "(vmx|svm)" --color=always /proc/cpuinfo

If the above command does not produce output, then hardware
virtualization support is unavailable and your hardware is unable to run
HVM domUs. If you believe the CPU supports one of these features you
should access the host system's BIOS configuration menu during the boot
process and look if options related to virtualization support have been
disabled. If such an option exists and is disabled, then enable it, boot
the system and repeat the above command. The Xen hypervisor also
supports PCI passthrough where PCI devices can be passed directly to the
domU even in the absence of dom0 support for the device. In order to use
PCI passthrough, the CPU must support IOMMU/VT-d.

Configuring dom0
----------------

The Xen hypervisor relies on a full install of the base operating
system. Before attempting to install the Xen hypervisor, the host
machine should have a fully operational and up-to-date install of Arch
Linux. This installation can be a minimal install with only the base
package and does not require a Desktop environment or even Xorg. If you
are building a new host from scratch, see the Installation guide for
instructions on installing Arch Linux. The following configuration steps
are required to convert a standard installation into a working dom0
running on top of the Xen hypervisor:

-   Installation of the Xen hypervisor
-   Modification of the bootloader to boot the Xen hypervisor
-   Creation of a network bridge
-   Installation of Xen systemd services

> Installation of the Xen hypervisor

To install the Xen hypervisor install either the current stable xen or
the bleeding edge unstable xen-hg-unstable packages available in the
Arch User Repository. Both packages provide the Xen hypervisor, current
xl interface and all configuration and support files, including systemd
services. The multilib repository needs to be enabled to install Xen
(See Pacman#Repositories for details). Install the xen-docs package from
the Arch User Repository for the man pages and documentation.

> Modification of the bootloader

The boot loader must be modified to load a special Xen kernel (xen.gz)
which is then used to boot the normal kernel. To do this a new
bootloader entry is needed.

For GRUB users, the Xen package provides the /etc/grub.d/09_xen
generator file. The file /etc/xen/grub.conf can be edited to customize
the Xen boot commands. For example, to allocate 512 MiB of RAM to dom0
at boot, modify /etc/xen/grub.conf by replacing the line:

    #XEN_HYPERVISOR_CMDLINE="xsave=1"

with

    XEN_HYPERVISOR_CMDLINE="dom0_mem=512M xsave=1"

After customizing the options, update the bootloader configuration with
the following command:

    # grub-mkconfig -o /boot/grub/grub.cfg

More information on using the GRUB bootloader is available at GRUB.

For syslinux users, add a stanza like this:

    LABEL xen
           MENU LABEL My Xen
           KERNEL mboot.c32
           APPEND ../xen-4.3.0.gz --- ../vmlinuz-linux console=tty0 root=/dev/sda3 ro --- ../initramfs-linux.img

Also this requires mboot.c32 to be in the same directory as the config
file. If you have /boot and /usr in the same partition you can possibly
link it. I do not know since I have /boot in a separate partition. So,
for users with /boot in a separate partition from /usr

    # cp /usr/lib/syslinux/mboot.c32 /boot/syslinux

> Creation of a network bridge

Xen requires that network communications between domUs and the dom0 (and
beyond) be set up manually. The use of both DHCP and static addressing
is possible, and the choice should be determined by the network
topology. Complex setups are possible, see the Networking article on the
Xen wiki for details and /etc/xen/scripts for scripts for various
networking configurations. A basic bridged network, in which a virtual
switch is created in dom0 that every domU is attached to, can be setup
by modifying the example configuration files provided by Netctl in
etc/netctl/examples. By default, Xen expects a bridge to exist named
xenbr0. To set this up with netctl, do the following:

    # cd /etc/netctl
    # cp examples/bridge xenbridge-dhcp

Make the following changes to /etc/netctl/xenbridge-dhcp:

    Description="Xen bridge connection"
    Interface=xenbr0
    Connection=bridge
    BindsToInterface=(eth0) # Use the name of the external interface found with the 'ip link' command
    IP=dhcp

assuming your existing network connection is called eth0.

Start the network bridge with:

    # netctl start xenbridge-dhcp

when the prompt returns, check all is well:

    # brctl show

    bridge name	bridge id		STP enabled	interfaces
    xenbr0		8000.001a9206c0c0	no		eth0

If the bridge is working it can be set to start automatically after
rebooting with:

    # netctl enable xenbridge-dhcp

> Installation of Xen systemd services

The Xen dom0 requires the xenstored, xenconsoled, and xendomains system
services (see Systemd for details).

Archlinux uses systemd, but the current xen package has init scripts.
You can start the daemons mentioned above like so:

     # /etc/rc.d/xencommons start

> Confirming successful installation

Reboot your dom0 host and ensure that the Xen kernel boots correctly and
that all settings survive a reboot. A properly set up dom0 should report
the following when you run xl list (as root):

    # xl list

    Name                                        ID   Mem VCPUs	State	Time(s)
    Domain-0                                     0   511     2     r-----   41652.9

Of course, the Mem, VCPUs and Time columns will be different depending
on machine configuration and uptime. The important thing is that dom0 is
listed.

In addition to the required steps above, see best practices for running
Xen which includes information on allocating a fixed amount of memory
and how to dedicate (pin) a CPU core for dom0 use. It also may be
beneficial to create a xenfs filesystem mount point by including in
/etc/fstab

     none /proc/xen xenfs defaults 0 0

Using Xen
---------

Xen supports both paravirtualized (PV) and hardware virtualized (HVM)
domUs. In the following sections the steps for creating HVM and PV domUs
running Arch Linux are described. In general, the steps for creating an
HVM domU are independent of the domU OS and HVM domUs support a wide
range of operating systems including microsot Windows. To use HVM domUs
the dom0 hardware must have virtualization support. Paravirtualized
domUs do not require virtualization support, but instead require
modifications to the guest operating system making the installation
procedure different for each operating system (see the Guest Install
page of the Xen wiki for links to instructions). Some operating systems
(e.g., Microsoft Windows) cannot be installed as a PV domU. In general,
HVM domUs often run slower than PV domUs since HVMs run on emulated
hardware. While there are some common steps involved in setting up PV
and HVM domUs, the processes are substantially different. In both cases,
for each domU, a "hard disk" will need to be created and a configuration
file needs to be written. Additionally, for installation each domU will
need access to a copy of the installation ISO stored on the dom0 (see
the Download Page to obtain the Arch Linux ISO).

> Create a domU "hard disk"

Xen supports a number of different types of "hard disks" including
Logical Volumes, raw partitions, and image files. To create a sparse
file, that will grow to a maximum of 10GiB, called domU.img, use:

    truncate -s 10G domU.img

If file IO speed is of greater importance than domain portability, using
Logical Volumes or raw partitions may be a better choice.

Xen may present any partition / disk available to the host machine to a
domain as either a partition or disk. This means that, for example, an
LVM partition on the host can appear as a hard drive (and hold multiple
partitions) to a domain. Note that making sub-partitons on a partition
will make accessing those partitions on the host machine more difficult.
See the kpartx man page for information on how to map out partitions
within a partition.

> Create a domU configuration

Each domU requires a separate configuration file that is used to create
the virtual machine. Full details about the configuration files can be
found at the | Xen Wiki or the xl.cfg man page. Both HVM and PV domUs
share some components of the configuration file. These include

     name = "domU"
     memory = 256
     disk = [ "file:/path/to/ISO,sdb,r", "phy:/path/to/partition,sda1,w" ]
     vif = [ 'mac=00:16:3e:XX:XX:XX,bridge=xenbr0' ]
     

The name= is the name by which the xl tools manage the domU and needs to
be unique across all domUs. The disk= includes information about both
the the installation media (file:) and the partition created for the
domU phy. If an image file is being used instead of a physical
partition, the phy: needs to be changed to file:. The vif= defines a
network controller. The 00:16:3e MAC block is reserved for Xen domains,
so the last three digits of the mac= must be randomly filled in (hex
values 0-9 and a-f only).

> Managing a domU

If a domU should be started on boot, create a symlink to the
configuration file in /etc/xen/auto and ensure the xendomains service is
set up correctly. Some useful commands for managing domUs are:

    # xl top
    # xl list
    # xl console domUname
    # xl shutdown domUname
    # xl destroy domUname

Configuring a hardware virtualized (HVM) Arch domU
--------------------------------------------------

In order to use HVM domUs install the mesa-libgl and bluez-libs
packages.

A minimal configuration file for a HVM Arch domU is:

     name = 'HVM_domU'
     builder = 'hvm'
     memory = 256
     vcpus = 2
     disk = [ 'phy:/dev/mapper/vg0-hvm_arch,xvda,w', 'file:/path/to/ISO,hdc:cdrom,r' ]
     vif = [ 'mac=00:16:3e:00:00:00,bridge=xenbr0' ]
     vnc = 1
     vnclisten = '0.0.0.0'
     vncdisplay = 1
     

Since HVM machines do not have a console, they can only be connected to
via a vncviewer. The configuration file allows for unauthenticated
remote access of the domU vncserver and is not suitable for unsecured
networks. The vncserver will be available on port 590X, where X is the
value of vncdisplay, of the dom0. The domU can be created with:

    # xl create /path/to/config/file

and its status can be checked with

    # xl list

Once the domU is created, connect to it via the vncserver and install
Arch Linux as described in the Installation guide.

Configuring a paravirtualized (PV) Arch domU
--------------------------------------------

A minimal configuration file for a PV Arch domU is:

     name = "PV_domU"
     kernel = "/mnt/arch/boot/x86_64/vmlinuz"
     ramdisk = "/mnt/arch/boot/x86_64/archiso.img"
     extra = "archisobasedir=arch archisolabel=ARCH_201301"
     memory = 256
     disk = [ "phy:/path/to/partition,sda1,w", "file:/path/to/ISO,sdb,r" ]
     vif = [ 'mac=00:16:3e:XX:XX:XX,bridge=xenbr0' ]
     

This file needs to tweaked for your specific use. Most importantly, the
archisolabel=ARCH_201301 line must be edited to use the release
year/month of the ISO being used. If you want to install 32-bit Arch,
change the kernel and ramdisk paths from /x86_64/ to /i686/.

Before creating the domU, the installation ISO must be loop-mounted. To
do this, ensure the directory /mnt exists and is empty, then run the
following command (being sure to fill in the correct ISO path):

    # mount -o loop /path/to/iso /mnt

Once the ISO is mounted, the domU can be created with:

    # xl create -c /path/to/config/file

The -c option will enter the domU's console when successfully created
and install Arch Linux as described in the Installation guide. There
will be a few deviations, however. The block devices listed in the disks
line of the cfg file will show up as /dev/xvd*. Use these devices when
partitioning the domU. After installation and before the domU is
rebooted, the xen-blkfront xen-fbfront xen-netfront xen-kbdfront modules
must be added to Mkinitcpio. Without these modules, the domU will not
boot correctly. For booting, it is not necessary to install Grub. Xen
has a Python-based grub emulator, so all that is needed to boot is a
grub.cfg file: (It may be necessary to create the /boot/grub directory)

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
"https://wiki.archlinux.org/index.php?title=Xen&oldid=306152"

Categories:

-   Virtualization
-   Kernel

-   This page was last modified on 20 March 2014, at 18:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
