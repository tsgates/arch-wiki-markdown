QEMU
====

From the QEMU about page,

QEMU is a generic and open source machine emulator and virtualizer.

When used as a machine emulator, QEMU can run OSes and programs made for
one machine (e.g. an ARM board) on a different machine (e.g. your own
PC). By using dynamic translation, it achieves very good performance.

When used as a virtualizer, QEMU achieves near native performances by
executing the guest code directly on the host CPU. QEMU supports
virtualization when executing under the Xen hypervisor or using the KVM
kernel module in Linux. When using KVM, QEMU can virtualize x86, server
and embedded PowerPC, and S390 guests.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing QEMU                                                    |
| -   2 Creating a hard disk image                                         |
| -   3 Preparing the installation media                                   |
| -   4 Installing the operating system                                    |
|     -   4.1 Standard method (software emulation)                         |
|     -   4.2 KVM method (hardware virtualization)                         |
|                                                                          |
| -   5 Overlay images                                                     |
| -   6 Moving data between host and guest OS                              |
|     -   6.1 Network                                                      |
|     -   6.2 QEMU's built-in SMB server                                   |
|     -   6.3 Mounting a partition inside a raw disk image                 |
|         -   6.3.1 With manually specifying byte offset                   |
|         -   6.3.2 With loop module autodetecting partitions              |
|         -   6.3.3 With kpartx                                            |
|                                                                          |
|     -   6.4 Mounting qcow2 image                                         |
|     -   6.5 Using any real partition as the single primary partition of  |
|         a hard disk image                                                |
|         -   6.5.1 By specifying kernel and initrd manually               |
|         -   6.5.2 Simulate virtual disk with MBR using linear RAID       |
|                                                                          |
| -   7 Networking                                                         |
|     -   7.1 User-mode networking                                         |
|     -   7.2 Tap networking with QEMU                                     |
|         -   7.2.1 Basic idea                                             |
|         -   7.2.2 Bridge virtual machines to external network            |
|         -   7.2.3 Simpler bridge method                                  |
|         -   7.2.4 Host-only networking                                   |
|         -   7.2.5 Internal networking                                    |
|         -   7.2.6 Link-level address caveat                              |
|                                                                          |
|     -   7.3 Networking with VDE2                                         |
|         -   7.3.1 What is VDE?                                           |
|         -   7.3.2 Basics                                                 |
|         -   7.3.3 Startup scripts                                        |
|             -   7.3.3.1 systemd                                          |
|                                                                          |
|         -   7.3.4 Alternative method                                     |
|                                                                          |
|     -   7.4 Improving networking performance                             |
|                                                                          |
| -   8 Graphics                                                           |
|     -   8.1 std                                                          |
|     -   8.2 vmware                                                       |
|     -   8.3 none                                                         |
|                                                                          |
| -   9 Graphical front-ends for QEMU                                      |
| -   10 Windows-specific notes                                            |
|     -   10.1 Choosing a Windows version                                  |
|     -   10.2 Windows 95 boot floppy                                      |
|     -   10.3 Windows 2000 installation bug                               |
|     -   10.4 Optimizing Windows 9X CPU usage                             |
|     -   10.5 Remote Desktop Protocol                                     |
|     -   10.6 Windows virtio drivers                                      |
|                                                                          |
| -   11 General problems                                                  |
|     -   11.1 Keyboard seems broken or the arrow keys do not work         |
|     -   11.2 Virtual machine runs too slowly                             |
|                                                                          |
| -   12 Starting QEMU virtual machines on boot                            |
|     -   12.1 With libvirt                                                |
|     -   12.2 Custom script                                               |
|                                                                          |
| -   13 Spice support                                                     |
| -   14 See also                                                          |
+--------------------------------------------------------------------------+

Installing QEMU
---------------

Install qemu from the official repositories. qemu-kvm has been fully
merged with upstream qemu starting with version 1.3.0, so the qemu-kvm
package is gone.

You can use KVM with the qemu package, if supported by your processor
and kernel, provided that you start QEMU with the -enable-kvm argument.

Creating a hard disk image
--------------------------

To run QEMU you will need a hard disk image, unless you are booting a
live system from CD-ROM or the network (and not doing so to install an
operating system to a hard disk image). A hard disk image is a file
which stores the contents of the emulated hard disk.

A hard disk image may simply contain the literal contents, byte for
byte, of the hard disk. This is usually called raw format, and it
provides the least I/O overhead, although the images may take up a large
amount of space.

Alternatively, the hard disk image can be in a format such as qcow2 that
can save enormous amounts of space by only allocating space to the image
file when the guest operating system actually writes to those sectors on
its virtual hard disk. The image appears as the full size to the guest
operating system, even though it may take up only a very small amount of
space on the host system.

QEMU provides the qemu-img command to create hard disk images. The
following command creates a 4GB image named myimage.qcow2 in the qcow2
format:

    $ qemu-img create -f qcow2 myimage.qcow2 4G

You may use -f raw to create a raw disk instead, although you can also
do so simply by creating a file of the needed size using dd or
fallocate.

Preparing the installation media
--------------------------------

To install an operating system into your disk image, you need the
installation media (e.g. CD-ROM, floppy, or ISO image) for the operating
system.

Tip:If you would like to run an Arch Linux virtual machine, you can
install it using the official installation media for Arch Linux. It is
also possible to set up an Arch Linux virtual machine without the
installation media, provided that your host machine is running Arch
Linux, although this is more difficult; it is detailed here.

The installation media should not be mounted because QEMU accesses the
media directly. Also, if using physical media (e.g. CD-ROM or floppy),
it is a good idea to first dump the media to a file because this both
improves performance and does not require you to have direct access to
the devices (that is, you can run QEMU as a regular user without having
to change access permissions on the media's device file). For example,
if the CD-ROM device node is named /dev/cdrom, you can dump it to a file
with the command:

    # dd if=/dev/cdrom of=mycdimg.iso

Do the same for floppy drives:

    # dd if=/dev/fd of=myfloppy.img

Installing the operating system
-------------------------------

To install the operating system on the disk image, you must attach both
the disk image and the installation media to the virtual machine, and
have it boot from the installation media.

This is the first time you will need to start the emulator. By default,
QEMU will show the virtual machine's video output in a window. One thing
to keep in mind: when you click inside the QEMU window, the mouse
pointer is grabbed. To release it press Ctrl+Alt.

Warning:QEMU should never be run as root. If you must launch it in a
script as root, you should use the -runas option to make QEMU drop root
privileges.

> Standard method (software emulation)

On i386 systems, to install from a bootable ISO file as CD-ROM, run QEMU
with:

    $ qemu -cdrom <iso_image> -boot d <qemu_image>

On x86_64 systems:

    $ qemu-system-x86_64 -cdrom <iso_image> -boot d <qemu_image>

See the parameters in qemu --help for loading other media types such as
floppy or disk images, or physical drives.

After the operating system has finished installing, the QEMU image can
be booted directly, for example on i386:

    $ qemu <qemu_image>

Tip:By default only 128MB of memory is assigned to the machine, the
amount of memory can be adjusted with the -m switch, for example -m 512.

> KVM method (hardware virtualization)

KVM, short for Kernel-based Virtual Machine, is a full virtualization
solution for Linux on x86 hardware containing virtualization extensions
(Intel VT or AMD-V). It relies on the kernel modules kvm and either
kvm-intel or kvm-amd and interfaces via /dev/kvm.

For 32 bit systems : The command to use with the standard qemu package
is:

    $ qemu -enable-kvm

For 64 bit systems: The command to use with the standard qemu package
is:

    $ qemu-system-x86_64 -enable-kvm

There is a dedicated KVM wiki page with more detailed information and
instructions.

Note:If you need to replace floppies or CDs as part of the installation
process, you can use the QEMU machine monitor (press Ctrl-Alt-2 in the
virtual machine's window) to remove and attach storage devices to a
virtual machine. Type info block to see the block devices, and use the
change command to swap out a device. Press Ctrl-Alt-1 to go back to the
virtual machine.

Overlay images
--------------

A good idea is to use overlay images. This way you can a create hard
disk image once and tell QEMU to store changes in an external file. This
makes it easy to revert the virtual machine's disk to a previous state.

To create an overlay image, type:

    $ qemu-img create -b [[base_image]] -f qcow2 [[overlay_image]]

After that you can run qemu with:

    $ qemu [overlay_image]

or if you are on a x86_64 system:

    $ qemu-system-x86_64 [overlay_image]

and the original image will be left untouched. One hitch, the base image
cannot be renamed or moved, the overlay remembers the base's full path.

Moving data between host and guest OS
-------------------------------------

> Network

Data can be shared between the host and guest OS using any network
protocol that can transfer files, such as NFS, SMB, NBD, HTTP, FTP, or
SSH, provided that you have set up the network appropriately and enabled
the appropriate services.

The default user-mode networking allows the guest to access the host OS
at the IP address 10.0.2.2. Any servers that you are running on your
host OS, such as a SSH server or SMB server, will be accessible at this
IP address. So on the guests, you can mount directories exported on the
host via SMB or NFS, or you can access the host's HTTP server, etc. It
will not be possible for the host OS to access servers running on the
guest OS, but this can be done with other network configurations (see
#Tap networking with QEMU).

> QEMU's built-in SMB server

Note:QEMU's "built-in" SMB server is currently (as of qemu-1.0.1-1)
broken because it does not specify the state_directory option in the
smb.conf file it writes. This issue is fixed in upstream QEMU.

QEMU's documentation says it has a "built-in" SMB server, but actually
it just starts up Samba with an automatically generated configuration
file and makes it accessible to the guest at a different IP address
(10.0.2.4 by default). This only works for user networking, and this
isn't necessarily very useful since the guest can also access the normal
Samba service on the host if you have set up shares on it.

To enable this feature, start QEMU with a command like:

    $ qemu [hd_image] -net nic -net user,smb=/path/to/shared/dir

where /path/to/shared/dir is a directory that you want to share between
the guest and host.

Then, in the guest, you will be able to access the shared directory on
the host 10.0.2.4 with the share name "qemu". For example, in Windows
Explorer you would go to \\10.0.2.4\qemu.

> Mounting a partition inside a raw disk image

When the virtual machine is not running, it is possible to mount
partitions that are inside a raw disk image file by setting them up as
loopback devices. This does not work with disk images in special
formats, such as qcow2, although those can be mounted using qemu-nbd.

Warning:You must make sure to unmount the partitions before running the
virtual machine again. Otherwise data corruption could occur, unless you
had mounted the partitions read-only.

With manually specifying byte offset

One way to mount a disk image partition is to mount the disk image at a
certain offset using a command like the following:

    # mount -o loop,offset=32256 [hd_image] [tmp_dir]

The offset=32256 option is actually passed to the losetup program to set
up a loopback device that starts at byte offset 32256 of the file and
continues to the end. This loopback device is then mounted. You may also
use the sizelimit option to specify the exact size of the partition, but
this is usually unnecessary.

Depending on your disk image, the needed partition may not start at
offset 32256. Run fdisk -l [hd_image] to see the partitions in the
image. fdisk gives the start and end offsets in 512-byte sectors, so
multiply by 512 to get the correct offset to pass to mount.

With loop module autodetecting partitions

The Linux loop driver actually supports partitions in loopback devices,
but it is disabled by default. To enable it, do the following:

-   Get rid of all your loopback devices (unmount all mounted images,
    etc.).
-   Unload the loop module.

    # modprobe -r loop

-   Load the loop module with the max_part parameter set.

    # modprobe loop max_part=15

Tip:You can put an entry in /etc/modprobe.d to load the loop module with
max_part=15 every time, or you can put loop.max_part=15 on the kernel
command line, depending on whether you have the loop.ko module built
into your kernel or not.

Set up your image as a loopback device:

    # losetup -f [os_image]

Then, if the device created was /dev/loop0, additional devices
/dev/loop0pX will have been automatically created, where X is the number
of the partition. These partition loopback devices can be mounted
directly. For example:

    # mount /dev/loop0p1 [tmp_dir]

With kpartx

kpartx from the multipath-tools package can read a partition table on a
device and create a new device for each partition. For example:

    # kpartx -a /dev/loop0

> Mounting qcow2 image

You may mount a qcow2 image using qemu-nbd. See Wikibooks.

> Using any real partition as the single primary partition of a hard disk image

Sometimes, you may wish to use one of your system partitions from within
QEMU. Using a raw partition for a virtual machine will improve
performance, as the read and write operations do not go through the
filesystem layer on the physical host. Such a partition also provides a
way to share data between the host and guest.

In Arch Linux, device files for raw partitions are, by default, owned by
root and the disk group. If you would like to have a non-root user be
able to read and write to a raw partition, you need to change the owner
of the partition's device file to that user.

Warning:Although it is possible, it is not recommended to allow virtual
machines to alter critical data on the host system, such as the root
partition.

Warning:You must not mount a filesystem on a partition read-write on
both the host and the guest at the same time. Otherwise, data corruption
will result.

After doing so, you can attach the partition to a QEMU virtual machine
as a virtual disk.

However, things are a little more complicated if you want to have the
entire virtual machine contained in a partition. In that case, there
would be no disk image file to actually boot the virtual machine since
you cannot install a bootloader to a partition that is itself formatted
as a filesystem and not as a partitioned device with a MBR. Such a
virtual machine can be booted either by specifying the kernel and initrd
manually, or by simulating a disk with a MBR by using linear RAID.

By specifying kernel and initrd manually

QEMU supports loading Linux kernels and init ramdisks directly, thereby
circumventing bootloaders such as GRUB. It then can be launched with the
physical partition containing the root filesystem as the virtual disk,
which will not appear to be partitioned. This is done by issuing a
command similar to the following:

    $ qemu -kernel /boot/vmlinuz-linux -initrd /boot/initramfs-linux.img -append root=/dev/sda /dev/sda3

In the above example, the physical partition being used for the guest's
root filesystem is /dev/sda3 on the host, but it shows up as /dev/sda on
the guest.

You may, of course, specify any kernel and initrd that you want, and not
just the ones that come with Arch Linux.

Simulate virtual disk with MBR using linear RAID

A more complicated way to have a virtual machine use a physical
partition, while keeping that partition formatted as a filesystem and
not just having the guest partition the partition as if it were a disk,
is to simulate a MBR for it so that it can boot using a bootloader such
as GRUB.

You can do this using software RAID in linear mode (you need the
linear.ko kernel driver) and a loopback device: the trick is to
dynamically prepend a master boot record (MBR) to the real partition you
wish to embed in a QEMU raw disk image.

Suppose you have a plain, unmounted /dev/hdaN partition with some
filesystem on it you wish to make part of a QEMU disk image. First, you
create some small file to hold the MBR:

    $ dd if=/dev/zero of=/path/to/mbr count=32

Here, a 16 KB (32 * 512 bytes) file is created. It is important not to
make it too small (even if the MBR only needs a single 512 bytes block),
since the smaller it will be, the smaller the chunk size of the software
RAID device will have to be, which could have an impact on performance.
Then, you setup a loopback device to the MBR file:

    # losetup -f /path/to/mbr

Let's assume the resulting device is /dev/loop0, because we would not
already have been using other loopbacks. Next step is to create the
"merged" MBR + /dev/hdaN disk image using software RAID:

     # modprobe linear
     # mdadm --build --verbose /dev/md0 --chunk=16 --level=linear --raid-devices=2 /dev/loop0 /dev/hdaN

The resulting /dev/md0 is what you will use as a QEMU raw disk image (do
not forget to set the permissions so that the emulator can access it).
The last (and somewhat tricky) step is to set the disk configuration
(disk geometry and partitions table) so that the primary partition start
point in the MBR matches the one of /dev/hdaN inside /dev/md0 (an offset
of exactly 16 * 512 = 16384 bytes in this example). Do this using fdisk
on the host machine, not in the emulator: the default raw disc detection
routine from QEMU often results in non kilobyte-roundable offsets (such
as 31.5 KB, as in the previous section) that cannot be managed by the
software RAID code. Hence, from the the host:

    # fdisk /dev/md0

Press X to enter the expert menu. Set number of 's'ectors per track so
that the size of one cylinder matches the size of your MBR file. For two
heads and a sector size of 512, the number of sectors per track should
be 16, so we get cylinders of size 2x16x512=16k.

Now, press R to return to the main menu.

Press P and check that the cylinder size is now 16k.

Now, create a single primary partition corresponding to /dev/hdaN. It
should start at cylinder 2 and end at the end of the disk (note that the
number of cylinders now differs from what it was when you entered fdisk.

Finally, 'w'rite the result to the file: you are done. You now have a
partition you can mount directly from your host, as well as part of a
QEMU disk image:

    $ qemu -hdc /dev/md0 [...]

You can of course safely set any bootloader on this disk image using
QEMU, provided the original /dev/hdaN partition contains the necessary
tools.

Networking
----------

> User-mode networking

By default, without any -netdev arguments, QEMU will use user-mode
networking with a built-in DHCP server. Your virtual machines will be
assigned an IP address when they run their DHCP client, and they will be
able to access the physical host's network through IP masquerading done
by QEMU. This only works with the TCP and UDP protocols, so ICMP,
including ping, will not work.

This default configuration allows your virtual machines to easily access
the Internet, provided that the host is connected to it, but the virtual
machines will not be directly visible on the external network, nor will
virtual machines be able to talk to each other if you start up more than
one concurrently.

QEMU's user-mode networking can offer more capabilities such as built-in
TFTP or SMB servers, or attaching guests to virtual LANs so that they
can talk to each other. See the QEMU documentation on the -net user flag
for more details.

However, user-mode networking has limitations in both utility and
performance. More advanced network configurations require the use of tap
devices or other methods.

> Tap networking with QEMU

Basic idea

Tap devices are a Linux kernel feature that allows you to create virtual
network interfaces that appear as real network interfaces. Packets sent
to a "tap" interface are delivered to a userspace program, such as QEMU,
that has bound itself to the interface.

QEMU can use tap networking for a virtual machine so that packets sent
to the tap interface will be sent to the virtual machine and appear as
coming from a network interface (usually an Ethernet interface) in the
virtual machine. Conversely, everything that the virtual machine sends
through its network interface will appear on the tap interface.

Tap devices are supported by the Linux bridge drivers, so it is possible
to bridge together tap devices with each other and possibly with other
host interfaces such as eth0. This is desirable if you want your virtual
machines to be able to talk to each other, or if you want other machines
on your LAN to be able to talk to the virtual machines.

Bridge virtual machines to external network

The following describes how to bridge a virtual machine to a host
interface such as eth0, which is probably the most common configuration.
This configuration makes it appear that the virtual machine is located
directly on the external network, on the same Ethernet segment as the
physical host machine.

Warning:Beware that since your virtual machines will appear directly on
the external network, this may expose them to attack. Depending on what
resources your virtual machines have access to, you may need to take all
the precautions you normally would take in securing a computer to secure
your virtual machines.

We will replace the normal Ethernet adapter with a bridge adapter and
bind the normal Ethernet adapter to it. See
http://en.gentoo-wiki.com/wiki/KVM#Networking_2 .

-   Make sure that the following packages are installed:
    -   bridge-utils (provides brctl, to manipulate bridges)
    -   uml_utilities (provides tunctl, to manipulate taps)

-   Enable IPv4 forwarding:

    sysctl net.ipv4.ip_forward=1

To make the change permanent, change net.ipv4.ip_forward = 0 to
net.ipv4.ip_forward = 1 in /etc/sysctl.conf.

-   Load the tun module and configure it to be loaded on boot. See
    Kernel modules for details.

-   Now create the bridge. See Bridge with netcfg for details.

Remember to name your bridge as br0, or change the scripts below to your
bridge's name.

-   Create the script that QEMU uses to bring up the tap adapter with
    root:kvm 750 permissions:

    /etc/qemu-ifup

    #!/bin/sh
      
    echo "Executing /etc/qemu-ifup"
    echo "Bringing up $1 for bridged mode..."
    sudo /sbin/ip link set $1 up promisc on
    echo "Adding $1 to br0..."
    sudo /usr/sbin/brctl addif br0 $1
    sleep 2

-   Create the script that QEMU uses to bring down the tap adapter in
    /etc/qemu-ifdown with root:kvm 750 permissions:

    /etc/qemu-ifdown

    #!/bin/sh
     
    echo "Executing /etc/qemu-ifdown"
    sudo /sbin/ip link set $1 down
    sudo /usr/sbin/brctl delif br0 $1
    sudo /sbin/ip link delete dev $1

-   Use visudo to add the following to your sudoers file:

    Cmnd_Alias      QEMU=/sbin/ip,/sbin/modprobe,/usr/sbin/brctl,/usr/bin/tunctl
    %kvm     ALL=NOPASSWD: QEMU

-   Make sure the user(s) wishing to use this new functionality are in
    the kvm group. Exit and log in again if necessary.

-   You launch QEMU using the following run-qemu script:

    run-qemu

    #!/bin/bash
    USERID=`whoami`
    IFACE=$(sudo tunctl -b -u $USERID)

    # This line creates a random mac address. The downside is the dhcp server will assign a different ip each time
    printf -v macaddr "52:54:%02x:%02x:%02x:%02x" $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff )) $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff ))
    # Instead, uncomment and edit this line to set an static mac address. The benefit is that the dhcp server will assign the same ip.
    # macaddr='52:54:be:36:42:a9'
      
    qemu -net nic,macaddr=$macaddr -net tap,ifname="$IFACE" $*
      
    sudo tunctl -d $IFACE &> /dev/null

Then to launch a VM, do something like this

    $ run-qemu -hda myvm.img -m 512 -vga std

-   If you cannot get a DHCP address in the host, it might be because
    iptables are up by default in the bridge. In that case (from
    http://www.linux-kvm.org/page/Networking ):

    # cd /proc/sys/net/bridge
    # ls
    bridge-nf-call-arptables  bridge-nf-call-iptables
    bridge-nf-call-ip6tables  bridge-nf-filter-vlan-tagged
    # for f in bridge-nf-*; do echo 0 > $f; done

And if you still cannot get networking to work, see:
Linux_Containers#Bridge_device_setup.

Simpler bridge method

Use -net bridge, which creates a tap on an existing bridge. This method
does not require a script and readily accomodates multiple taps and
multiple bridges.

First, copy /etc/qemu/bridge.conf.sample to /etc/qemu/bridge.conf. Now
modify /etc/qemu/bridge.conf to contain the names of all bridges to be
used:

    /etc/qemu/bridge.conf

    allow <bridge0>
    allow <bridge1>
    <etc>

Now start the VM. The most basic usage would be:

    $ qemu-system-x86_64 <other options> -net nic -net bridge,br=<bridge0>

With multiple taps, the most basic usage requires specifying the vlan
for all additional nics:

    $ qemu-system-x86-64 <other options> -net nic -net bridge,br=<bridge0> -net nic,vlan=1 -net bridge,vlan=1,br=<bridge1>

Host-only networking

If the bridge is given an IP address and traffic destined for it is
allowed, but no "real" interface (e.g. eth0) is also connected to the
bridge, then the virtual machines will be able to talk to each other and
the physical host. However, they will not be able to talk to anything on
the external network, provided that you do not set up IP masquerading on
the physical host. This configuration is called "host-only" networking
by other virtualization software such as VirtualBox.

You may want to have a DHCP server running on the bridge interface to
service the virtual network. For example, to use the 172.20.0.1/16
subnet with Dnsmasq as the DHCP server:

    # ip addr add 172.20.0.1/16 dev br0
    # ip link set br0 up
    # dnsmasq --interface=br0 --bind-interfaces --dhcp-range=172.20.0.2,172.20.255.254

Internal networking

If you do not give the bridge an IP address and add an iptables rule to
drop all traffic to the bridge in the INPUT chain, then the virtual
machines will be able to talk to each other, but not to the physical
host or to the outside network. This configuration is called "internal"
networking by other virtualization software such as VirtualBox. You will
need to either assign static IP addresses to the virtual machines or run
a DHCP server on one of them.

Link-level address caveat

By giving the -net nic argument to QEMU, it will, by default, assign a
virtual machine a network interface with the link-level address
52:54:00:12:34:56. However, when using bridged networking with multiple
virtual machines, it is essential that each virtual machine has a unique
link-level (MAC) address on the virtual machine side of the tap device.
Otherwise, the bridge will not work correctly, because it will receive
packets from multiple sources that have the same link-level address.
This problem occurs even if the tap devices themselves have unique
link-level addresses because the source link-level address is not
rewritten as packets pass through the tap device.

To solve this problem, the last 8 digits of the link-level address of
the virtual NICs should be randomized, as in the script above, to make
sure that each virtual machine has a unique link-level address.

> Networking with VDE2

What is VDE?

VDE stands for Virtual Distributed Ethernet. It started as an
enhancement of uml_switch. It is a toolbox to manage virtual networks.

The idea is to create virtual switches, which are basically sockets, and
to "plug" both physical and virtual machines in them. The configuration
we show here is quite simple; However, VDE is much more powerful than
this, it can plug virtual switches together, run them on different hosts
and monitor the traffic in the switches. Your are invited to read the
documentation of the project.

The advantage of this method is you do not have to add sudo privileges
to your users. Regular users should not be allowed to run modprobe.

Basics

VDE support can be installed via the vde2 package in the official
repositories.

In our config, we use tun/tap to create a virtual interface on my host.
Load the tun module (see here for more info):

    # modprobe tun

Now create the virtual switch:

    # vde_switch -tap tap0 -daemon -mod 660 -group kvm

This line creates the switch, creates tap0, "plugs" it, and allows the
users of the group kvm to use it.

The interface is plugged in but not configured yet. To configure it, run
this command:

    # ip addr add 192.168.100.254/24 dev tap0

Now, you just have to run KVM with these -net options as a normal user:

    $ qemu -net nic -net vde -hda ...

Configure your guest as you would do in a physical network. We gave them
static addresses and let them access the WAN using IP forwarding and
masquerading on our host:

    # echo "1" > /proc/sys/net/ipv4/ip_forward
    # iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE

Startup scripts

systemd

Example of script to put in /usr/lib/systemd/scripts/

    /usr/lib/systemd/scripts/qemu-network-env

    #!/bin/sh
    # QEMU/VDE network environment preparation script

    # The IP configuration for the tap device that will be used for
    # the virtual machine network:

    TAP_DEV=tap0
    TAP_IP=192.168.100.254
    TAP_MASK=24
    TAP_NETWORK=192.168.100.0


    # Host interface
    NIC=eth0

    case "$1" in
      start)
            echo -n "Starting VDE network for QEMU: "

            # If you want tun kernel module to be loaded by script uncomment here 
    	#modprobe tun 2>/dev/null
    	## Wait for the module to be loaded
     	#while ! lsmod |grep -q "^tun"; do echo Waiting for tun device;sleep 1; done

            # Start tap switch
            vde_switch -tap "$TAP_DEV" -daemon -mod 660 -group kvm

            # Bring tap interface up
            ip address add "$TAP_IP"/"$TAP_MASK" dev "$TAP_DEV"
            ip link set "$TAP_DEV" up

            # Start IP Forwarding
            echo "1" > /proc/sys/net/ipv4/ip_forward
            iptables -t nat -A POSTROUTING -s "$TAP_NETWORK"/"$TAP_MASK" -o "$NIC" -j MASQUERADE
            ;;
      stop)
            echo -n "Stopping VDE network for QEMU: "
            # Delete the NAT rules
            iptables -t nat -D POSTROUTING "$TAP_NETWORK"/"$TAP_MASK" -o "$NIC" -j MASQUERADE

            # Bring tap interface down
            ip link set "$TAP_DEV" down

            # Kill VDE switch
            pgrep -f vde_switch | xargs kill -TERM 
            ;;
      restart|reload)
            $0 stop
            sleep 1
            $0 start
            ;;
      *)
            echo "Usage: $0 {start|stop|restart|reload}"
            exit 1
    esac
    exit 0

Example of systemd service to put in /usr/lib/systemd/system/

    /usr/lib/systemd/system/qemu-network-env.service

    [Unit]
    Description=Manage VDE Switch

    [Service]
    Type=oneshot
    ExecStart=/usr/lib/systemd/scripts/qemu-network-env start
    ExecStop=/usr/lib/systemd/scripts/qemu-network-env stop
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target

After that you can enable the service if you want to start this at boot
time

    # systemctl enable qemu-network-env

If you want to start it (you can replace start by stop or restart)

    # systemctl start qemu-network-env

Alternative method

If the above method does not work or you do not want to mess with kernel
configs, TUN, dnsmasq and iptables you can do the following for the same
result.

    # vde_switch -daemon -mod 660 -group kvm

    # slirpvde --dhcp --daemon

Then to start the vm with a connection to the network of the host:

    $ kvm -net nic,macaddr=52:54:00:00:EE:03 -net vde whatever.qcow

> Improving networking performance

The performance of virtual networking should be better with tap devices
and bridges than with user-mode networking or vde, since tap devices and
bridges are implemented in-kernel.

In addition, networking performance can be improved by assigning virtual
machines a virtio network device rather than the default emulation of an
e1000 NIC. To do this, add a model=virtio flag to the -net nic option:

    -net nic,model=virtio

This will only work if the guest machine has a driver for virtio network
devices. Linux does, and the required driver (virtio_net) is included
with Arch Linux, but there is no guarantee that virtio networking will
work with arbitrary operating systems. There do exist virtio drivers for
Windows, but you need to install them manually.

Graphics
--------

QEMU can use the following different graphic outputs: std, cirrus,
vmware, qxl, xenfs and vnc. With the vnc option you can run your guest
standalone and connect to it via VNC. Other options are using std,
vmware, cirrus.

> std

With -vga std you can get a resolution of up to 2560 x 1600 pixels.

> vmware

Although it is a bit buggy, it performs better than std and cirrus. On
the guest, install the VMware drivers. For Arch Linux guests:

    # pacman -S xf86-video-vmware xf86-input-vmmouse

> none

If you do not want to see the graphical output from your virtual machine
because you will be accessing it entirely through the network or serial
port, you can run QEMU with the -nographic option.

Graphical front-ends for QEMU
-----------------------------

Unlike other virtualization progrems such as VirtualBox and VMware, QEMU
does not provide a GUI to manage virtual machines (other than the window
that appears when running a virtual machine), nor does it provide a way
to create persistent virtual machines with saved settings. All
parameters to run a virtual machine must be specified on the command
line at every launch, unless you have created a custom script to start
your virtual machine(s). However, there are several GUI front-ends for
QEMU:

-   virt-manager (part of libvirt)
-   qemu-launcher
-   qemulator (AUR)
-   qtemu

Windows-specific notes
----------------------

> Choosing a Windows version

QEMU can run any version of Windows. However, 98, Me and XP will run at
quite a low speed. You should choose either Windows 95 or Windows 2000.
Surprisingly, 2000 seems to run faster than 98. The fastest one is 95,
which can from time to time make you forget that you are running an
emulator :)

If you own both Win95 and Win98/WinME, then 98lite (from
http://www.litepc.com) might be worth trying. It decouples Internet
Explorer from operating system and replaces it with original Windows 95
Explorer. It also enables you to do a minimal Windows installation,
without all the bloat you normally cannot disable. This might be the
best option, because you get the smallest, fastest and most stable
Windows this way.

It is possible to run Windows PE in QEMU.

> Windows 95 boot floppy

If you are using the Windows 95 boot floppy, choosing SAMSUNG as the
type of CD-ROM seems to work.

> Windows 2000 installation bug

There are problems when installing Windows 2000. Windows setup will
generate a lot of edb*.log files, one after the other containing nothing
but blank spaces in C:\WINNT\SECURITY which quickly fill the virtual
hard disk. A workaround is to open a Windows command prompt as early as
possible during setup (by pressing Shift+F10) which will allow you to
remove these log files as they appear by typing:

    del %windir%\security\*.log

Note:According to the official QEMU website, "Windows 2000 has a bug
which gives a disk full problem during its installation. When installing
it, use the -win2k-hack QEMU option to enable a specific workaround.
After Windows 2000 is installed, you no longer need this option (this
option slows down the IDE transfers)."

> Optimizing Windows 9X CPU usage

Windows 9X uses an idle loop instead of the HLT (halt) instruction.
Consequently, the emulator will consume all CPU resources when running
Windows 9X guests — even if no work is being done. This only applies to
DOS and DOS-based Windows versions (3.X, 95/98/ME) — NT-based and later
Windows versions are not affected.

To resolve this issue, install Rain, Waterfall or CpuIdle in the Windows
9X guest. (Rain might be preferred because it does only what is needed —
replacing the idle loop with the HLT instruction — and nothing more.)

See Tutorial: Windows 95/98 guest OSes for more information.

> Remote Desktop Protocol

If you use a MS Windows guest, you might want to use RDP to connect to
your guest VM. If you are using a VLAN or are not in the same network as
the guest, use:

    $ qemu -nographic -net user,hostfwd=tcp::5555-:3389

Then connect with either rdesktop or freerdp to the guest, for example:

    $ xfreerdp -g 2048x1152 localhost:5555 -z -x lan

> Windows virtio drivers

You can use virtio devices with Windows if you install the virtio guest
drivers for Windows.

General problems
----------------

> Keyboard seems broken or the arrow keys do not work

Should you find that some of your keys do not work or "press" the wrong
key (in particular, the arrow keys), you likely need to specify your
keyboard layout as an option. The keyboard layouts can be found in
/usr/share/qemu/keymaps.

    qemu -k [keymap] [disk_image]

> Virtual machine runs too slowly

There are a number of techniques that you can use to improve the
performance if your virtual machine. For example:

-   Use KVM if possible : add -machine type=pc,accel=kvm to the qemu
    start command you use.
-   Make sure you have assigned the virtual machine enough memory. By
    default, QEMU only assigns 128MiB of memory to each virtual machine.
    Use the -m option to assign more memory. For example, -m 1024 runs a
    virtual machine with 1024MiB of memory.
-   If the host machine has multiple CPUs, assign the guest more CPUs
    using the -smp option.
-   Use the -cpu host option to make QEMU emulate the host's exact CPU.
    If you don't do this, it may be trying to emulate a more generic
    CPU.
-   If supported by drivers in the guest operating system, use virtio
    for network and/or block devices. For example:

    $ qemu -net nic,model=virtio -net tap,if=tap0,script=no -drive file=mydisk.raw,media=disk,if=virtio

-   Use TAP devices instead of user-mode networking.
-   If the guest OS is doing heavy writing to its disk, you may benefit
    from certain mount options on the host's filesystem. For example,
    you can mount an ext4 filesystem with the option barrier=0. You
    should read the documentation for any options that you change, since
    sometimes performance-enhancing options for filesystems come at the
    cost of data integrity.
-   If you are running multiple virtual machines concurrently that all
    have the same operating system installed, you can save memory by
    enabling kernel same-page merging:

    # echo 1 > /sys/kernel/mm/ksm/run

-   In some cases, memory can be reclaimed from running virtual machines
    by running a memory ballooning driver in the guest operating system
    and launching QEMU with the -balloon virtio option.

Starting QEMU virtual machines on boot
--------------------------------------

> With libvirt

If a virtual machine is set up with libvirt, it can be configured
through the virt-manager GUI to start at host boot by going to the Boot
Options for the virtual machine and selecting "Start virtual machine on
host boot up".

> Custom script

To run QEMU VMs on boot, you can use following rc-script and config.

  ------------------------- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  QEMU_MACHINES             List of VMs to start
  qemu_${vm}_type           QEMU binary to call. If specified, will be prepended with /usr/bin/qemu- and that binary will be used to start the VM. I.e. you can boot e.g. qemu-system-arm images with qemu_my_arm_vm_type="system-arm". If not specified, /usr/bin/qemu will be used.
  qemu_${vm}                QEMU command line to start with. Will always be prepended with -name ${vm} -pidfile /var/run/qemu/${vm}.pid -daemonize -nographic.
  qemu_${vm}_haltcmd        Command to shutdown VM safely. I am using -monitor telnet:.. and power off my VMs via ACPI by sending system_powerdown to monitor. You can use ssh or some other ways.
  qemu_${vm}_haltcmd_wait   How much time to wait for safe VM shutdown. Default is 30 seconds. rc-script will kill qemu process after this timeout.
  ------------------------- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  :  Config file options

Config file example:

    /etc/conf.d/qemu.conf

    # VMs that should be started on boot
    # use the ! prefix to disable starting/stopping a VM
    QEMU_MACHINES=(vm1 vm2)

    # NOTE: following options will be prepended to qemu_${vm}
    # -name ${vm} -pidfile /var/run/qemu/${vm}.pid -daemonize -nographic

    qemu_vm1_type="system-x86_64"

    qemu_vm1="-enable-kvm -m 512 -hda /dev/mapper/vg0-vm1 -net nic,macaddr=DE:AD:BE:EF:E0:00 \
     -net tap,ifname=tap0 -serial telnet:localhost:7000,server,nowait,nodelay \
     -monitor telnet:localhost:7100,server,nowait,nodelay -vnc :0"

    qemu_vm1_haltcmd="echo 'system_powerdown' | nc.openbsd localhost 7100" # or netcat/ncat

    # You can use other ways to shutdown your VM correctly
    #qemu_vm1_haltcmd="ssh powermanager@vm1 sudo poweroff"

    # By default rc-script will wait 30 seconds before killing VM. Here you can change this timeout.
    #qemu_vm1_haltcmd_wait="30"

    qemu_vm2="-enable-kvm -m 512 -hda /srv/kvm/vm2.img -net nic,macaddr=DE:AD:BE:EF:E0:01 \
     -net tap,ifname=tap1 -serial telnet:localhost:7001,server,nowait,nodelay \
     -monitor telnet:localhost:7101,server,nowait,nodelay -vnc :1"

    qemu_vm2_haltcmd="echo 'system_powerdown' | nc.openbsd localhost 7101"

rc-script:

    /etc/rc.d/qemu

    #!/bin/bash
    . /etc/rc.conf
    . /etc/rc.d/functions

    [ -f /etc/conf.d/qemu.conf ] && source /etc/conf.d/qemu.conf

    PIDDIR=/var/run/qemu
    QEMU_DEFAULT_FLAGS='-name ${vm} -pidfile ${PIDDIR}/${vm}.pid -daemonize -nographic'
    QEMU_HALTCMD_WAIT=30

    case "$1" in
      start)
        [ -d "${PIDDIR}" ] || mkdir -p "${PIDDIR}"
        for vm in "${QEMU_MACHINES[@]}"; do
           if [ "${vm}" = "${vm#!}" ]; then
             stat_busy "Starting QEMU VM: ${vm}"
             eval vm_cmdline="\$qemu_${vm}"
             eval vm_type="\$qemu_${vm}_type"

             if [ -n "${vm_type}" ]; then
               vm_cmd="/usr/bin/qemu-${vm_type}"
             else
               vm_cmd='/usr/bin/qemu'
             fi

             eval "qemu_flags=\"${QEMU_DEFAULT_FLAGS}\""

             ${vm_cmd} ${qemu_flags} ${vm_cmdline} >/dev/null
             if [  $? -gt 0 ]; then
               stat_fail
             else
               stat_done
             fi
           fi
        done
        add_daemon qemu
        ;;

      stop)
        for vm in "${QEMU_MACHINES[@]}"; do
          if [ "${vm}" = "${vm#!}" ]; then
            # check pidfile presence and permissions
            if [ ! -r "${PIDDIR}/${vm}.pid" ]; then
              continue
            fi

            stat_busy "Stopping QEMU VM: ${vm}"

            eval vm_haltcmd="\$qemu_${vm}_haltcmd"
            eval vm_haltcmd_wait="\$qemu_${vm}_haltcmd_wait"
            vm_haltcmd_wait=${vm_haltcmd_wait:-${QEMU_HALTCMD_WAIT}}
            vm_pid=$(cat ${PIDDIR}/${vm}.pid)
      
            # check process existence
            if ! kill -0 ${vm_pid} 2>/dev/null; then
              stat_done
              rm -f "${PIDDIR}/${vm}.pid"
              continue
            fi

            # Try to shutdown VM safely
            _vm_running='yes'
            if [ -n "${vm_haltcmd}" ]; then
              eval ${vm_haltcmd} >/dev/null

              _w=0
              while [ "${_w}" -lt "${vm_haltcmd_wait}" ]; do
                sleep 1
                if ! kill -0 ${vm_pid} 2>/dev/null; then
                  # no such process
                  _vm_running=''
                  break
                fi
                _w=$((_w + 1))
              done

            else
              # No haltcmd - kill VM unsafely
              _vm_running='yes'
            fi

            if [ -n "${_vm_running}" ]; then
                # kill VM unsafely
                kill ${vm_pid} 2>/dev/null
                sleep 1
            fi

            # report status
            if kill -0 ${vm_pid} 2>/dev/null; then
              # VM is still alive
              #kill -9 ${vm_pid}
              stat_fail
            else
              stat_done
            fi

            # remove pidfile
            rm -f "${PIDDIR}/${vm}.pid"
          fi
        done
        rm_daemon qemu
        ;;

      restart)
        $0 stop
        sleep 1
        $0 start
        ;;

      *)
        echo "usage: $0 {start|stop|restart}"

    esac

Spice support
-------------

The Spice project aims to provide a complete open source solution for
interaction with virtualized desktop devices. Its main focus is to
provide high-quality remote access to QEMU virtual machines. Spice
project homepage

The official QEMU package is built without Spice support. To build your
version with Spice enabled you need to have the Arch Build System on
your system.

Install spice from the AUR first.

Then update ABS on your system to the latest version and copy
/var/abs/extra/qemu to somewhere (here we use ~/temp/ as an example) you
like:

    $ sudo abs
    $ cp -r /var/abs/extra/qemu ~/temp

Go to your copy of the package folder (here ~/temp/qemu and add
--enable-spice after .configure in the build() function of the PKGBUILD:

    $ cd ~/temp/qemu
    $ sed -i "s/\.\/configure/& --enable-spice/g" PKGBUILD

Then build and install the package:

    $ makepkg -i

See also
--------

-   Official QEMU website
-   Official KVM website
-   QEMU Wikibook
-   Hardware virtualization with QEMU by AlienBOB
-   Building a Virtual Army by Falconindy

Retrieved from
"https://wiki.archlinux.org/index.php?title=QEMU&oldid=252483"

Categories:

-   Emulators
-   Virtualization
