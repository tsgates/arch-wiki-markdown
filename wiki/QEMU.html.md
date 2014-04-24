QEMU
====

Related articles

-   KVM
-   Libvirt
-   VirtualBox
-   Xen
-   VMware

From the QEMU about page:

QEMU is a generic and open source machine emulator and virtualizer.

When used as a machine emulator, QEMU can run OSes and programs made for
one machine (e.g. an ARM board) on a different machine (e.g. your x86
PC). By using dynamic translation, it achieves very good performance.

QEMU can use other hypervisors like Xen or KVM to use CPU extensions
(HVM) for virtualization. When used as a virtualizer, QEMU achieves near
native performances by executing the guest code directly on the host
CPU.

Contents
--------

-   1 Installing QEMU
-   2 Graphical front-ends for QEMU
-   3 Running virtualized system
    -   3.1 Enabling KVM
-   4 Creating new virtualized system
    -   4.1 Creating a hard disk image
        -   4.1.1 Overlay storage images
        -   4.1.2 Resizing an image
    -   4.2 Preparing the installation media
    -   4.3 Installing the operating system
-   5 Moving data between host and guest OS
    -   5.1 Network
    -   5.2 QEMU's built-in SMB server
    -   5.3 Mounting a partition inside a raw disk image
        -   5.3.1 With manually specifying byte offset
        -   5.3.2 With loop module autodetecting partitions
        -   5.3.3 With kpartx
    -   5.4 Mounting a partition inside a qcow2 image
    -   5.5 Using any real partition as the single primary partition of
        a hard disk image
        -   5.5.1 By specifying kernel and initrd manually
        -   5.5.2 Simulate virtual disk with MBR using linear RAID
-   6 Networking
    -   6.1 Link-level address caveat
    -   6.2 User-mode networking
    -   6.3 Tap networking with QEMU
        -   6.3.1 Host-only networking
        -   6.3.2 Internal networking
        -   6.3.3 Bridged networking using qemu-bridge-helper
        -   6.3.4 Creating bridge manually
    -   6.4 Networking with VDE2
        -   6.4.1 What is VDE?
        -   6.4.2 Basics
        -   6.4.3 Startup scripts
        -   6.4.4 Alternative method
    -   6.5 VDE2 Bridge
        -   6.5.1 Basics
        -   6.5.2 Startup scripts
-   7 Graphics
    -   7.1 std
    -   7.2 vmware
    -   7.3 qxl
    -   7.4 none
    -   7.5 vnc
-   8 Installing virtio drivers
    -   8.1 Preparing an (Arch) Linux guest
    -   8.2 Preparing a Windows guest
        -   8.2.1 Block device drivers
        -   8.2.2 Network drivers
    -   8.3 Preparing a FreeBSD guest
-   9 Tips and tricks
    -   9.1 Starting QEMU virtual machines on boot
        -   9.1.1 With libvirt
        -   9.1.2 Custom script
    -   9.2 Mouse integration
    -   9.3 Pass-through host USB device
    -   9.4 Enabling KSM
    -   9.5 Spice support
    -   9.6 Copy and paste
    -   9.7 Windows-specific notes
        -   9.7.1 Remote Desktop Protocol
-   10 Troubleshooting
    -   10.1 Mouse cursor is jittery or erratic
    -   10.2 Keyboard seems broken or the arrow keys do not work
    -   10.3 Virtual machine runs too slowly
-   11 See also

Installing QEMU
---------------

Install qemu from the official repositories.

Graphical front-ends for QEMU
-----------------------------

Unlike other virtualization programs such as VirtualBox and VMware, QEMU
does not provide a GUI to manage virtual machines (other than the window
that appears when running a virtual machine), nor does it provide a way
to create persistent virtual machines with saved settings. All
parameters to run a virtual machine must be specified on the command
line at every launch, unless you have created a custom script to start
your virtual machine(s). However, there are several GUI front-ends for
QEMU:

-   virt-manager (part of libvirt)
-   qemu-launcher
-   qtemu

From AUR:

-   aqemu-git
-   qemulator
-   gnome-boxes

Running virtualized system
--------------------------

qemu-system-* binaries (for example qemu-system-i386 or
qemu-system-x86_64, depending on emulated architecture) are used to run
the virtualized system. The usage is:

    $ qemu-system-i386 options disk_image

Options are the same for all qemu-system-* binaries, see qemu(1) for
documentation of all options.

By default, QEMU will show the virtual machine's video output in a
window. One thing to keep in mind: when you click inside the QEMU
window, the mouse pointer is grabbed. To release it, press Ctrl+Alt.

Warning:QEMU should never be run as root. If you must launch it in a
script as root, you should use the -runas option to make QEMU drop root
privileges.

> Enabling KVM

KVM must be supported by your processor and kernel, and necessary kernel
modules must be loaded. See KVM for more information.

To start QEMU in KVM mode, append -enable-kvm to the additional start
options.

Note:If you start your VM with a GUI tool and experience very bad
performance, you should check for proper KVM support, as QEMU may be
falling back to software emulation.

Creating new virtualized system
-------------------------------

Tip:If you are virtualizing Arch Linux, it is possible to create a disk
image directly on an existing Arch Linux system, see Creating Arch Linux
disk image#Install Arch Linux in a disk image without the installation
media for details.

> Creating a hard disk image

Tip:See the QEMU Wikibook for more information on QEMU images.

To run QEMU you will need a hard disk image, unless you are booting a
live system from CD-ROM or the network (and not doing so to install an
operating system to a hard disk image). A hard disk image is a file
which stores the contents of the emulated hard disk.

A hard disk image can be raw, so that it is literally byte-by-byte the
same as what the guest sees, and will always use the full capacity of
the guest hard drive on the host. This method provides the least I/O
overhead, but can waste a lot of space, as not-used space on the guest
cannot be used on the host.

Alternatively, the hard disk image can be in a format such as qcow2
which only allocates space to the image file when the guest operating
system actually writes to those sectors on its virtual hard disk. The
image appears as the full size to the guest operating system, even
though it may take up only a very small amount of space on the host
system. Using this format instead of raw will likely affect performance.

QEMU provides the qemu-img command to create hard disk images. For
example to create a 4 GB image in the raw format:

    $ qemu-img create -f raw image_file 4G

You may use -f qcow2 to create a gcow2 disk instead.

Note:You can also simply create a raw image by creating a file of the
needed size using dd or fallocate.

Warning:If you store the hard disk images on a Btrfs file system, you
should consider disabling Copy-on-Write for the directory before
creating any images.

Overlay storage images

You can create a storage image once (the 'backing' image) and have QEMU
keep mutations to this image in an overlay image. This allows you to
revert to a previous state of this storage image. You could revert by
creating a new overlay image at the time you wish to revert, based on
the original backing image.

To create an overlay image, issue a command like:

    $ qemu-img create -b backing_image.qemu.raw -f qcow2 image.qemu.raw.overlay.1

After that you can run your QEMU VM as usual (see #Running virtualized
system):

    $ qemu-system-i386 image.qemu.raw.overlay.1

The backing image will then be left intact and mutations to this storage
will be recorded in the overlay image file.

When the path to the backing image changes, repair is required.

Warning:The backing image's absolute filesystem path is stored in the
(binary) overlay image file. Changing the backing image's path requires
some effort.

Make sure that the original backing image's path still leads to this
image. If necessary, make a symbolic link at the original path to the
new path. Then issue a command like:

    $ qemu-img rebase -b /new/backing_image.qemu.raw /new/image.qemu.raw.overlay.1

At your discretion, you may alternatively perform an 'unsafe' rebase
where the old path to the backing image is not checked:

    $ qemu-img rebase -u -b /new/backing_image.qemu.raw /new/image.qemu.raw.overlay.1

Resizing an image

Warning:Resizing an image containing an NTFS boot file system could make
the VM installed on it unbootable. For full explanation see here and
workaround below.

The qemu-img executable has the resize option, which enables easy
resizing of a hard drive image. It works for both raw and qcow2. For
example, to increase image space by 10 GB, run:

    $ qemu-img resize disk_image +10G

Tip:Workaround resizing an image containing an NTFS boot file system
(this example is for qcow2 format image but method is the same for other
formats):

Important: first shut down any VMs using the image!

Then convert to raw format, add space at the end, and convert back
again:

    $ qemu-img convert -f qcow2 -O raw myimg.qcow2 myimg.raw  # (creates raw format copy of disk image)
    $ truncate -s +4G myimg.raw                               # (adds 4 GB blank space at the end of the image file)
    $ mv myimg.qcow2 myimg.qcow2.bak                          # (keep the original image as backup - can delete later once everything is working)
    $ qemu-img convert -f raw -O qcow2 myimg.raw myimg.qcow2  # (convert the enlarged raw image back to qcow2)
    $ rm myimg.raw                                            # (delete the raw image since we will not be using it)
    $ chown --reference=myimg.qcow2.bak myimg.qcow2           # (match original image file ownerhip)
    $ chmod --reference=myimg.qcow2.bak myimg.qcow2           # (match original image file permissions)

Then resize partitions using preferred tool (e.g. for Windows Vista or
later, you can just boot Windows and use the built-in Disk Management
utility).

> Preparing the installation media

To install an operating system into your disk image, you need the
installation medium (e.g. optical disk, USB-drive, or ISO image) for the
operating system. The installation medium should not be mounted because
QEMU accesses the media directly.

Tip:If using an optical disk, it is a good idea to first dump the media
to a file because this both improves performance and does not require
you to have direct access to the devices (that is, you can run QEMU as a
regular user without having to change access permissions on the media's
device file). For example, if the CD-ROM device node is named
/dev/cdrom, you can dump it to a file with the command:

    $ dd if=/dev/cdrom of=cd_image.iso

> Installing the operating system

This is the first time you will need to start the emulator. To install
the operating system on the disk image, you must attach both the disk
image and the installation media to the virtual machine, and have it
boot from the installation media.

For example on i386 systems, to install from a bootable ISO file as
CD-ROM:

    $ qemu-system-i386 -cdrom iso_image -boot order=d qemu_image

See qemu(1) for information about loading other media types, such as
floppy or disk images, or physical drives.

After the operating system has finished installing, the QEMU image can
be booted directly (see #Running virtualized system).

> Tip:

-   By default only 128 MB of memory is assigned to the machine. The
    amount of memory can be adjusted with the -m switch, for example
    -m 512.
-   Instead of specifying -boot order=x, some users may feel more
    comfortable using a boot menu: -boot menu=on, at least during
    configuration and experimentation.
-   If you need to replace floppies or CDs as part of the installation
    process, you can use the QEMU machine monitor (press Ctrl+Alt+2 in
    the virtual machine's window) to remove and attach storage devices
    to a virtual machine. Type info block to see the block devices, and
    use the change command to swap out a device. Press Ctrl+Alt+1 to go
    back to the virtual machine.

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

QEMU's documentation says it has a "built-in" SMB server, but actually
it just starts up Samba with an automatically generated configuration
file and makes it accessible to the guest at a different IP address
(10.0.2.4 by default). This only works for user networking, and this is
not necessarily very useful since the guest can also access the normal
Samba service on the host if you have set up shares on it.

To enable this feature, start QEMU with a command like:

    $ qemu-system-i386 disk_image -net nic -net user,smb=shared_dir_path

where shared_dir_path is a directory that you want to share between the
guest and host.

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

    # mount -o loop,offset=32256 disk_image mountpoint

The offset=32256 option is actually passed to the losetup program to set
up a loopback device that starts at byte offset 32256 of the file and
continues to the end. This loopback device is then mounted. You may also
use the sizelimit option to specify the exact size of the partition, but
this is usually unnecessary.

Depending on your disk image, the needed partition may not start at
offset 32256. Run fdisk -l disk_image to see the partitions in the
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
command-line, depending on whether you have the loop.ko module built
into your kernel or not.

Set up your image as a loopback device:

    # losetup -f disk_image

Then, if the device created was /dev/loop0, additional devices
/dev/loop0pX will have been automatically created, where X is the number
of the partition. These partition loopback devices can be mounted
directly. For example:

    # mount /dev/loop0p1 mountpoint

With kpartx

kpartx from the multipath-tools-git package from the AUR can read a
partition table on a device and create a new device for each partition.
For example:

    # kpartx -a /dev/loop0

> Mounting a partition inside a qcow2 image

You may mount a partition inside a qcow2 image using qemu-nbd. See
Wikibooks.

> Using any real partition as the single primary partition of a hard disk image

Sometimes, you may wish to use one of your system partitions from within
QEMU. Using a raw partition for a virtual machine will improve
performance, as the read and write operations do not go through the file
system layer on the physical host. Such a partition also provides a way
to share data between the host and guest.

In Arch Linux, device files for raw partitions are, by default, owned by
root and the disk group. If you would like to have a non-root user be
able to read and write to a raw partition, you need to change the owner
of the partition's device file to that user.

> Warning:

-   Although it is possible, it is not recommended to allow virtual
    machines to alter critical data on the host system, such as the root
    partition.
-   You must not mount a file system on a partition read-write on both
    the host and the guest at the same time. Otherwise, data corruption
    will result.

After doing so, you can attach the partition to a QEMU virtual machine
as a virtual disk.

However, things are a little more complicated if you want to have the
entire virtual machine contained in a partition. In that case, there
would be no disk image file to actually boot the virtual machine since
you cannot install a bootloader to a partition that is itself formatted
as a file system and not as a partitioned device with a MBR. Such a
virtual machine can be booted either by specifying the kernel and initrd
manually, or by simulating a disk with a MBR by using linear RAID.

By specifying kernel and initrd manually

QEMU supports loading Linux kernels and init ramdisks directly, thereby
circumventing bootloaders such as GRUB. It then can be launched with the
physical partition containing the root file system as the virtual disk,
which will not appear to be partitioned. This is done by issuing a
command similar to the following:

Note:In this example, it is the host's images that are being used, not
the guest's. If you wish to use the guest's images, either mount
/dev/sda3 read-only (to protect the file system from the host) and
specify the /full/path/to/images or use some kexec hackery in the guest
to reload the guest's kernel (extends boot time).

    $ qemu-system-i386 -kernel /boot/vmlinuz-linux -initrd /boot/initramfs-linux.img -append root=/dev/sda /dev/sda3

In the above example, the physical partition being used for the guest's
root file system is /dev/sda3 on the host, but it shows up as /dev/sda
on the guest.

You may, of course, specify any kernel and initrd that you want, and not
just the ones that come with Arch Linux.

Simulate virtual disk with MBR using linear RAID

A more complicated way to have a virtual machine use a physical
partition, while keeping that partition formatted as a file system and
not just having the guest partition the partition as if it were a disk,
is to simulate a MBR for it so that it can boot using a bootloader such
as GRUB.

You can do this using software RAID in linear mode (you need the
linear.ko kernel driver) and a loopback device: the trick is to
dynamically prepend a master boot record (MBR) to the real partition you
wish to embed in a QEMU raw disk image.

Suppose you have a plain, unmounted /dev/hdaN partition with some file
system on it you wish to make part of a QEMU disk image. First, you
create some small file to hold the MBR:

    $ dd if=/dev/zero of=/path/to/mbr count=32

Here, a 16 KB (32 * 512 bytes) file is created. It is important not to
make it too small (even if the MBR only needs a single 512 bytes block),
since the smaller it will be, the smaller the chunk size of the software
RAID device will have to be, which could have an impact on performance.
Then, you setup a loopback device to the MBR file:

    # losetup -f /path/to/mbr

Let us assume the resulting device is /dev/loop0, because we would not
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
routine from QEMU often results in non-kilobyte-roundable offsets (such
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

    $ qemu-system-i386 -hdc /dev/md0 [...]

You can, of course, safely set any bootloader on this disk image using
QEMU, provided the original /dev/hdaN partition contains the necessary
tools.

Networking
----------

The performance of virtual networking should be better with tap devices
and bridges than with user-mode networking or vde because tap devices
and bridges are implemented in-kernel.

In addition, networking performance can be improved by assigning virtual
machines a virtio network device rather than the default emulation of an
e1000 NIC. See #Installing virtio drivers for more information.

> Link-level address caveat

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

Make sure that each virtual machine has a unique link-level address, but
it should always start with 52:54:. Use the following option, replace X
with arbitrary hexadecimal digit:

    $ qemu-system-i386 -net nic,macaddr=52:54:XX:XX:XX:XX -net vde disk_image

Generating unique link-level addresses can be done in several ways:

1. Manually specify unique link-level address for each NIC. The benefit
is that the DHCP server will assign the same IP address each time the
virtual machine is run, but it is unusable for large number of virtual
machines.

2. Generate random link-level address each time the virtual machine is
run. Practically zero probability of collisions, but the downside is
that the DHCP server will assign a different IP address each time. You
can use the following command in a script to generate random link-level
address in a macaddr variable:

    printf -v macaddr "52:54:%02x:%02x:%02x:%02x" $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff )) $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff ))
    qemu-system-i386 -net nic,macaddr="$macaddr" -net vde disk_image

3. Use the following script qemu-mac-hasher.py to generate the
link-level address from the virtual machine name using a hashing
function. Given that the names of virtual machines are unique, this
method combines the benefits of the aforementioned methods: it generates
the same link-level address each time the script is run, yet it
preserves the practically zero probability of collisions.

    qemu-mac-hasher.py

    #!/usr/bin/env python

    import sys
    import zlib

    if len(sys.argv) != 2:
        print("usage: %s <VM Name>" % sys.argv[0])
        sys.exit(1)

    crc = zlib.crc32(sys.argv[1].encode("utf-8")) & 0xffffffff
    crc = str(hex(crc))[2:]
    print("52:54:%s%s:%s%s:%s%s:%s%s" % tuple(crc))

In a script, you can use for example:

    vm_name="VM Name"
    qemu-system-i386 -name "$vm_name" -net nic,macaddr=$(qemu-mac-hasher.py "$vm_name") -net vde disk_image

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
TFTP or SMB servers, or attaching guests to VLANs so that they can talk
to each other. See the QEMU documentation on the -net user flag for more
details.

However, user-mode networking has limitations in both utility and
performance. More advanced network configurations require the use of tap
devices or other methods.

> Tap networking with QEMU

Tap devices are a Linux kernel feature that allows you to create virtual
network interfaces that appear as real network interfaces. Packets sent
to a tap interface are delivered to a userspace program, such as QEMU,
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

Warning:If you bridge together tap device and some host interface, such
as eth0, your virtual machines will appear directly on the external
network, which will expose them to possible attack. Depending on what
resources your virtual machines have access to, you may need to take all
the precautions you normally would take in securing a computer to secure
your virtual machines. If the risk is too great, virtual machines have
little resources or you set up multiple virtual machines, better
solution might be to use host-only networking and set up NAT. In this
case you only need one firewall on the host instead of multiple
firewalls for each guest.

Host-only networking

If the bridge is given an IP address and traffic destined for it is
allowed, but no real interface (e.g. eth0) is connected to the bridge,
then the virtual machines will be able to talk to each other and the
host system. However, they will not be able to talk to anything on the
external network, provided that you do not set up IP masquerading on the
physical host. This configuration is called host-only networking by
other virtualization software such as VirtualBox.

> Tip:

-   If you want to set up IP masquerading, e.g. NAT for virtual
    machines, see the Internet sharing#Enable NAT page.
-   You may want to have a DHCP server running on the bridge interface
    to service the virtual network. For example, to use the
    172.20.0.1/16 subnet with dnsmasq as the DHCP server:

    # ip addr add 172.20.0.1/16 dev br0
    # ip link set br0 up
    # dnsmasq --interface=br0 --bind-interfaces --dhcp-range=172.20.0.2,172.20.255.254

Internal networking

If you do not give the bridge an IP address and add an iptables rule to
drop all traffic to the bridge in the INPUT chain, then the virtual
machines will be able to talk to each other, but not to the physical
host or to the outside network. This configuration is called internal
networking by other virtualization software such as VirtualBox. You will
need to either assign static IP addresses to the virtual machines or run
a DHCP server on one of them.

Bridged networking using qemu-bridge-helper

Note:This method is available since QEMU 1.1, see
http://wiki.qemu.org/Features/HelperNetworking.

This method does not require a start-up script and readily accommodates
multiple taps and multiple bridges. It uses
/usr/lib/qemu/qemu-bridge-helper binary, which allows creating tap
devices on an existing bridge.

Tip:See Bridge with netctl for information on creating bridge.

First, copy /etc/qemu/bridge.conf.sample to /etc/qemu/bridge.conf. Now
modify /etc/qemu/bridge.conf to contain the names of all bridges to be
used by QEMU:

    /etc/qemu/bridge.conf

    allow bridge0
    allow bridge1
    ...

Now start the VM. The most basic usage would be:

    $ qemu-system-i386 -net nic -net bridge,br=bridge0 [...]

With multiple taps, the most basic usage requires specifying the VLAN
for all additional NICs:

    $ qemu-system-i386 -net nic -net bridge,br=bridge0 -net nic,vlan=1 -net bridge,vlan=1,br=bridge1 [...]

Creating bridge manually

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: This section     
                           needs serious cleanup    
                           and may contain          
                           out-of-date information. 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Tip:Since QEMU 1.1, the network bridge helper can set tun/tap up for you
without the need for additional scripting. See #Bridged networking using
qemu-bridge-helper.

The following describes how to bridge a virtual machine to a host
interface such as eth0, which is probably the most common configuration.
This configuration makes it appear that the virtual machine is located
directly on the external network, on the same Ethernet segment as the
physical host machine.

We will replace the normal Ethernet adapter with a bridge adapter and
bind the normal Ethernet adapter to it. See
http://en.gentoo-wiki.com/wiki/KVM#Networking_2[dead link 2013-07-23].

-   Install bridge-utils, which provides brctl to manipulate bridges.

-   Enable IPv4 forwarding:

    # sysctl net.ipv4.ip_forward=1

To make the change permanent, change net.ipv4.ip_forward = 0 to
net.ipv4.ip_forward = 1 in /etc/sysctl.d/99-sysctl.conf.

-   Load the tun module and configure it to be loaded on boot. See
    Kernel modules for details.

-   Now create the bridge. See Bridge with netctl for details. Remember
    to name your bridge as br0, or change the scripts below to your
    bridge's name.

-   Create the script that QEMU uses to bring up the tap adapter with
    root:kvm 750 permissions:

    /etc/qemu-ifup

    #!/bin/sh
      
    echo "Executing /etc/qemu-ifup"
    echo "Bringing up $1 for bridged mode..."
    sudo /usr/bin/ip link set $1 up promisc on
    echo "Adding $1 to br0..."
    sudo /usr/bin/brctl addif br0 $1
    sleep 2

-   Create the script that QEMU uses to bring down the tap adapter in
    /etc/qemu-ifdown with root:kvm 750 permissions:

    /etc/qemu-ifdown

    #!/bin/sh
     
    echo "Executing /etc/qemu-ifdown"
    sudo /usr/bin/ip link set $1 down
    sudo /usr/bin/brctl delif br0 $1
    sudo /usr/bin/ip link delete dev $1

-   Use visudo to add the following to your sudoers file:

    Cmnd_Alias      QEMU=/usr/bin/ip,/usr/bin/modprobe,/usr/bin/brctl
    %kvm     ALL=NOPASSWD: QEMU

-   You launch QEMU using the following run-qemu script:

    run-qemu

    #!/bin/bash
    USERID=$(whoami)

    # Get name of newly created TAP device; see https://bbs.archlinux.org/viewtopic.php?pid=1285079#p1285079
    precreationg=$(/usr/bin/ip tuntap list | /usr/bin/cut -d: -f1 | /usr/bin/sort)
    sudo /usr/bin/ip tuntap add user $USERID mode tap
    postcreation=$(/usr/bin/ip tuntap list | /usr/bin/cut -d: -f1 | /usr/bin/sort)
    IFACE=$(comm -13 <(echo "$precreationg") <(echo "$postcreation"))

    # This line creates a random MAC address. The downside is the DHCP server will assign a different IP address each time
    printf -v macaddr "52:54:%02x:%02x:%02x:%02x" $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff )) $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff ))
    # Instead, uncomment and edit this line to set a static MAC address. The benefit is that the DHCP server will assign the same IP address.
    # macaddr='52:54:be:36:42:a9'
      
    qemu-system-i386 -net nic,macaddr=$macaddr -net tap,ifname="$IFACE" $*
      
    sudo ip link set dev $IFACE down &> /dev/null
    sudo ip tuntap del $IFACE mode tap &> /dev/null 

Then to launch a VM, do something like this

    $ run-qemu -hda myvm.img -m 512 -vga std

Tip:If you cannot get a DHCP address in the host, it might be because
iptables is up by default in the bridge.

-   It is recommended for performance and security reasons to disable
    the firewall on the bridge:

    /etc/sysctl.d/10-disable-firewall-on-bridge.conf

    net.bridge.bridge-nf-call-ip6tables = 0
    net.bridge.bridge-nf-call-iptables = 0
    net.bridge.bridge-nf-call-arptables = 0

Run sysctl -p /etc/sysctl.d/10-disable-firewall-on-bridge.conf to apply
the changes immediately.

See the libvirt wiki and Fedora bug 512206. If you get errors by sysctl
during boot about non-existing files, make the bridge module load at
boot. See Kernel modules#Loading.

Alternatively, you can configure iptables to allow all traffic to be
forwarded across the bridge by adding a rule like this:

    -I FORWARD -m physdev --physdev-is-bridged -j ACCEPT

> Networking with VDE2

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: This section     
                           needs serious cleanup    
                           and may contain          
                           out-of-date information. 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

What is VDE?

VDE stands for Virtual Distributed Ethernet. It started as an
enhancement of uml_switch. It is a toolbox to manage virtual networks.

The idea is to create virtual switches, which are basically sockets, and
to "plug" both physical and virtual machines in them. The configuration
we show here is quite simple; However, VDE is much more powerful than
this, it can plug virtual switches together, run them on different hosts
and monitor the traffic in the switches. You are invited to read the
documentation of the project.

The advantage of this method is you do not have to add sudo privileges
to your users. Regular users should not be allowed to run modprobe.

Basics

VDE support can be installed via the vde2 package in the official
repositories.

In our config, we use tun/tap to create a virtual interface on my host.
Load the tun module (see Kernel modules for details):

    # modprobe tun

Now create the virtual switch:

    # vde_switch -tap tap0 -daemon -mod 660 -group users

This line creates the switch, creates tap0, "plugs" it, and allows the
users of the group users to use it.

The interface is plugged in but not configured yet. To configure it, run
this command:

    # ip addr add 192.168.100.254/24 dev tap0

Now, you just have to run KVM with these -net options as a normal user:

    $ qemu-system-i386 -net nic -net vde -hda [...]

Configure networking for your guest as you would do in a physical
network.

Tip:You might want to set up NAT on tap device to access the internet
from the virtual machine. See Internet sharing#Enable NAT for more
information.

Startup scripts

Example of main script starting VDE:

    /etc/systemd/scripts/qemu-network-env

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
     	#while ! lsmod | grep -q "^tun"; do echo "Waiting for tun device"; sleep 1; done

            # Start tap switch
            vde_switch -tap "$TAP_DEV" -daemon -mod 660 -group users

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

Example of systemd service using the above script:

    /etc/systemd/system/qemu-network-env.service

    [Unit]
    Description=Manage VDE Switch

    [Service]
    Type=oneshot
    ExecStart=/etc/systemd/scripts/qemu-network-env start
    ExecStop=/etc/systemd/scripts/qemu-network-env stop
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target

Change permissions for qemu-network-env to be executable

    # chmod u+x /etc/systemd/scripts/qemu-network-env

You can start it as usual (see systemd#Using units for details):

    # systemctl start qemu-network-env

Alternative method

If the above method does not work or you do not want to mess with kernel
configs, TUN, dnsmasq, and iptables you can do the following for the
same result.

    # vde_switch -daemon -mod 660 -group users
    # slirpvde --dhcp --daemon

Then, to start the VM with a connection to the network of the host:

    $ qemu-system-i386 -net nic,macaddr=52:54:00:00:EE:03 -net vde disk_image

> VDE2 Bridge

Based on quickhowto: qemu networking using vde, tun/tap, and bridge
graphic. Any virtual machine connected to vde is externally exposed. For
example, each virtual machine can receive DHCP configuration directly
from your ADSL router.

Basics

Remember that you need tun module and bridge-utils package.

Create the vde2/tap device:

    # vde_switch -tap tap0 -daemon -mod 660 -group users
    # ip link set tap0 up

Create bridge:

    # brctl addbr br0

Add devices:

    # brctl addif br0 eth0
    # brctl addif br0 tap0

And configure bridge interface:

    # dhcpcd br0

Startup scripts

All devices must be set up. And only the bridge needs an IP address. For
physical devices on the bridge (e.g. eth0), this can be done with netctl
using a custom Ethernet profile with:

    /etc/netctl/ethernet-noip

    Description='A more versatile static Ethernet connection'
    Interface=eth0
    Connection=ethernet
    IP=no

VDE2 tap interface can be activated with the VDE2 interface custom
systemd service.

And finally, you can create the bridge interface with netctl.

Graphics
--------

QEMU can use the following different graphic outputs: std, cirrus,
vmware, qxl, and none.

> std

With -vga std you can get a resolution of up to 2560 x 1600 pixels.

> vmware

Although it is a bit buggy, it performs better than std and cirrus. On
the guest, install the VMware drivers (xf86-video-vmware and
xf86-input-vmmouse for Arch Linux guests).

> qxl

QXL is a paravirtual graphics driver with 2D support. To use it, these
condition must be met:

-   Spice has to be enabled on the host system.
-   A driver has to be installed on the guest (e.g. xf86-video-qxl which
    is available in the AUR).
-   The virtual machine has to be started with -vga qxl switch.

> none

This is like a PC that has no VGA card at all. You would not even be
able to access it with the -vnc option. Also, this is different from the
-nographic option which lets QEMU emulate a VGA card, but disables the
SDL display.

> vnc

Given that you used the -nographic option, you can add the -vnc display
option to have QEMU listen on display and redirect the VGA display to
the VNC session. There is an example of this in the #Starting QEMU
virtual machines on boot section's example configs.

    $ qemu-system-i386 -vga std -nographic -vnc :0
    $ gvncviewer :0

When using VNC, you might experience keyboard problems described (in
gory details) here. The solution is not to use the -k option on QEMU,
and to use gvncviewer from gtk-vnc. See also this message posted on
libvirt's mailing list.

Installing virtio drivers
-------------------------

QEMU offers guests the ability to use paravirtualized block and network
devices using the virtio drivers, which provide better performance and
lower overhead.

-   A virtio block device requires the option -drive instead of the
    simple -hd* plus if=virtio:

    $ qemu-system-i386 -boot order=c -drive file=disk_image,if=virtio

Note:-boot order=c is absolutely necessary when you want to boot from
it. There is no auto-detection as with -hd*.

-   Almost the same goes for the network:

    $ qemu-system-i386 -net nic,model=virtio

Note:This will only work if the guest machine has drivers for virtio
devices. Linux does, and the required drivers are included in Arch
Linux, but there is no guarantee that virtio devices will work with
other operating systems.

> Preparing an (Arch) Linux guest

To use virtio devices after an Arch Linux guest has been installed, the
following modules must be loaded in the guest: virtio, virtio_pci,
virtio_blk, virtio_net, and virtio_ring. For 32-bit guests, the specific
"virtio" module is not necessary.

If you want to boot from a virtio disk, the initial ramdisk must be
rebuilt. Add the appropriate modules in /etc/mkinitcpio.conf like this:

    MODULES="virtio_blk virtio_pci virtio_net"

and rebuild the initial ramdisk:

    # mkinitcpio -p linux

Virtio disks are recognized with the prefix v (e.g. vda, vdb, etc.);
therefore, changes must be made in at least /etc/fstab and
/boot/grub/grub.cfg when booting from a virtio disk.

Tip:When referencing to disks by UUID in both /etc/fstab and bootloader,
nothing has to be done.

Further information on paravirtualization with KVM can be found here.

> Preparing a Windows guest

Block device drivers

Preparing a Windows guest for booting from virtio disk is a bit tricky.

You can download the virtio disk driver from the Fedora repository.

Now you need to create a new disk image, which fill force Windows to
search for the driver. For example:

    $ qemu-img create -f qcow2 fake.qcow2 1G

Run the original Windows guest (with the boot disk still in IDE mode)
with the fake disk (in virtio mode) and a CD-ROM with the driver.

    $ qemu-system-i386 -m 512 -vga std -drive file=windows_disk_image,if=ide -drive file=fake.qcow2,if=virtio -cdrom virtio-win-0.1-74.iso

Windows will detect the fake disk and try to find a driver for it. If it
fails, go to the Device Manager, locate the SCSI drive with an
exclamation mark icon (should be open), click Update driver and select
the virtual CD-ROM. Do not forget to select the checkbox which says to
search for directories recursively.

When the installation is successful, you can turn off the virtual
machine and launch it again, now with the boot disk attached in virtio
mode:

    $ qemu-system-i386 -m 512 -vga std -drive file=windows_disk_image,if=virtio

Note:If you encounter the Blue Screen of Death, make sure you did not
forget the -m parameter, and that you do not boot with virtio instead of
ide for the system drive before drivers are installed.

Network drivers

Installing virtio network drivers is a bit easier, simply add the -net
argument as explained above.

    $ qemu-system-i386 -m 512 -vga std -drive file=windows_disk_image,if=virtio -net nic,model=virtio -cdrom virtio-win-0.1-74.iso

Windows will detect the network adapter and try to find a driver for it.
If it fails, go to the Device Manager, locate the network adapter with
an exclamation mark icon (should be open), click Update driver and
select the virtual CD-ROM. Do not forget to select the checkbox which
says to search for directories recursively.

> Preparing a FreeBSD guest

Install the emulators/virtio-kmod port if you are using FreeBSD 8.3 or
later up until 10.0-CURRENT where they are included into the kernel.
After installation, add the following to your /boot/loader.conf file:

    virtio_loader="YES"
    virtio_pci_load="YES"
    virtio_blk_load="YES"
    if_vtnet_load="YES"
    virtio_balloon_load="YES"

Then modify your /etc/fstab by doing the following:

    sed -i/etc/fstab.bak "s/ad/vtbd/g" /etc/fstab

And verify that /etc/fstab is consistent. If anything goes wrong, just
boot into a rescue CD and copy /etc/fstab.bak back to /etc/fstab.

Tips and tricks
---------------

> Starting QEMU virtual machines on boot

With libvirt

If a virtual machine is set up with libvirt, it can be configured
through the virt-manager GUI to start at host boot by going to the Boot
Options for the virtual machine and selecting "Start virtual machine on
host boot up".

Custom script

To run QEMU VMs on boot, you can use following systemd unit and config.

    /etc/systemd/system/qemu@.service

    [Unit]
    Description=QEMU virtual machine

    [Service]
    Environment="type=system-x86_64" "haltcmd=kill -INT $MAINPID"
    EnvironmentFile=/etc/conf.d/qemu.d/%i
    ExecStart=/usr/bin/env qemu-${type} -name %i -nographic $args
    ExecStop=/bin/sh -c ${haltcmd}
    TimeoutStopSec=30
    KillMode=none

    [Install]
    WantedBy=multi-user.target

Note:According to systemd.service(5) and systemd.kill(5) man pages it is
necessary to use the KillMode=none option. Otherwise the main qemu
process will be killed immediately after the ExecStop command quits (it
simply echoes one string) and your quest system will not be able to
shutdown correctly.

Then create per-VM configuration files, named
/etc/conf.d/qemu.d/vm_name, with the following variables set:

 type 
    QEMU binary to call. If specified, will be prepended with
    /usr/bin/qemu- and that binary will be used to start the VM. I.e.
    you can boot e.g. qemu-system-arm images with type="system-arm".
 args 
    QEMU command line to start with. Will always be prepended with
    -name ${vm} -nographic.
 haltcmd 
    Command to shut down a VM safely. I am using -monitor telnet:.. and
    power off my VMs via ACPI by sending system_powerdown to monitor.
    You can use SSH or some other ways.

Example configs:

    /etc/conf.d/qemu.d/one

    type="system-x86_64"

    args="-enable-kvm -m 512 -hda /dev/mapper/vg0-vm1 -net nic,macaddr=DE:AD:BE:EF:E0:00 \
     -net tap,ifname=tap0 -serial telnet:localhost:7000,server,nowait,nodelay \
     -monitor telnet:localhost:7100,server,nowait,nodelay -vnc :0"

    haltcmd="echo 'system_powerdown' | nc localhost 7100" # or netcat/ncat

    # You can use other ways to shut down your VM correctly
    #haltcmd="ssh powermanager@vm1 sudo poweroff"

    /etc/conf.d/qemu.d/two

    args="-enable-kvm -m 512 -hda /srv/kvm/vm2.img -net nic,macaddr=DE:AD:BE:EF:E0:01 \
     -net tap,ifname=tap1 -serial telnet:localhost:7001,server,nowait,nodelay \
     -monitor telnet:localhost:7101,server,nowait,nodelay -vnc :1"

    haltcmd="echo 'system_powerdown' | nc localhost 7101"

To set which virtual machines will start on boot-up, use

    # systemctl enable qemu@vm_name
    # systemctl disable qemu@vm_name

> Mouse integration

To prevent the mouse from being grabbed when clicking on the guest
operating system's window, add the option -usbdevice tablet. This means
QEMU is able to report the mouse position without having to grab the
mouse. This also overrides PS/2 mouse emulation when activated. For
example:

    $ qemu-system-i386 -hda disk_image -m 512 -vga std -usbdevice tablet

> Pass-through host USB device

To access physical USB device connected to host from VM, you can start
QEMU with following option:

    $ qemu-system-i386 -usbdevice host:vendor_id:product_id disk_image

You can find vendor_id and product_id of your device with lsusb command.

Note:If you encounter permission errors when running QEMU, see
Udev#Writing udev rules for information on how to set permissions of the
device.

> Enabling KSM

Kernel Samepage Merging (KSM) is a feature of the Linux kernel that
allows for an application to register with the kernel to have its pages
merged with other processes that also register to have their pages
merged. The KSM mechanism allows for guest virtual machines to share
pages with each other. In an environment where many of the guest
operating systems are similar, this can result in significant memory
savings.

To enable KSM, simply run

    # echo 1 > /sys/kernel/mm/ksm/run

To make it permanent, you can use systemd's temporary files:

    /etc/tmpfiles.d/ksm.conf

    w /sys/kernel/mm/ksm/run - - - - 1

If KSM is running, and there are pages to be merged (i.e. at least two
similar VMs are running), then /sys/kernel/mm/ksm/pages_shared should be
non-zero. See https://www.kernel.org/doc/Documentation/vm/ksm.txt for
more information.

Tip:An easy way to see how well KSM is performing is to simply print the
contents of all the files in that directory:

    $ grep . /sys/kernel/mm/ksm/*

> Spice support

The Spice project aims to provide a complete, open-source solution for
interaction with virtualized desktop devices. Its main focus is to
provide high-quality remote access to QEMU virtual machines.

The official qemu package is built with Spice support.

You can start your VM:

    $ qemu-system-i386 -vga qxl -spice port=5930,disable-ticketing

Then connect with the the spice client

    $ spicec -h 127.0.0.1 -p 5930

> Tip:

-   Spice guest drivers can be downloaded here in the Guest section.
-   The key combination to escape mouse and keyboard grab can be
    configured, the default is Shift+F12:

        $ spicec --hotkeys release-cursor=ctrl+alt

-   virt-manager has a Spice client built in.

> Copy and paste

To have copy and paste between the host and the guest you need to enable
the spice agent communication channel. It requires to add a
virtio-serial device to the guest, and open a port for the spice
vdagent. It is also required to install the spice vdagent in guest
(spice-vdagent for Arch guests, Windows guest tools for Windows guests).
Make sure the agent is running (and for future, started automatically).

Start QEMU with the following options:

    $ qemu-system-i386 -vga qxl -spice port=5930,disable-ticketing -device virtio-serial-pci -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 -chardev spicevmc,id=spicechannel0,name=vdagent

The -device virtio-serial-pci option adds the virtio-serial device,
-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0
opens a port for spice vdagent in that device and
-chardev spicevmc,id=spicechannel0,name=vdagent adds a spicevmc chardev
for that port.

It is important that the chardev= option of the virtserialport device
matches the id= option given to the chardev option (spicechannel0 in
this example). It is also important that the port name is
com.redhat.spice.0, because that is the namespace where vdagent is
looking for in the guest. And finally, specify name=vdagent so that
spice knows what this channel is for.

> Windows-specific notes

QEMU can run any version of Windows from Windows 95 through Windows 8.

It is possible to run Windows PE in QEMU.

Remote Desktop Protocol

If you use a MS Windows guest, you might want to use RDP to connect to
your guest VM. If you are using a VLAN or are not in the same network as
the guest, use:

    $ qemu-system-i386 -nographic -net user,hostfwd=tcp::5555-:3389

Then connect with either rdesktop or freerdp to the guest. For example:

    $ xfreerdp -g 2048x1152 localhost:5555 -z -x lan

Troubleshooting
---------------

> Mouse cursor is jittery or erratic

If the cursor jumps around the screen uncontrollably, entering this on
the terminal before starting QEMU might help:

    $ export SDL_VIDEO_X11_DGAMOUSE=0

If this helps, you can add this to your bashrc file.

> Keyboard seems broken or the arrow keys do not work

Should you find that some of your keys do not work or "press" the wrong
key (in particular, the arrow keys), you likely need to specify your
keyboard layout as an option. The keyboard layouts can be found in
/usr/share/qemu/keymaps.

    $ qemu-system-i386 -k keymap disk_image

> Virtual machine runs too slowly

There are a number of techniques that you can use to improve the
performance if your virtual machine. For example:

-   Use the -cpu host option to make QEMU emulate the host's exact CPU.
    If you do not do this, it may be trying to emulate a more generic
    CPU.
-   If the host machine has multiple CPUs, assign the guest more CPUs
    using the -smp option.
-   Make sure you have assigned the virtual machine enough memory. By
    default, QEMU only assigns 128 MiB of memory to each virtual
    machine. Use the -m option to assign more memory. For example,
    -m 1024 runs a virtual machine with 1024 MiB of memory.
-   Use KVM if possible: add -machine type=pc,accel=kvm to the QEMU
    start command you use.
-   If supported by drivers in the guest operating system, use virtio
    for network and/or block devices. For example:

    $ qemu-system-i386 -net nic,model=virtio -net tap,if=tap0,script=no -drive file=disk_image,media=disk,if=virtio

-   Use TAP devices instead of user-mode networking. See #Tap networking
    with QEMU.
-   If the guest OS is doing heavy writing to its disk, you may benefit
    from certain mount options on the host's file system. For example,
    you can mount an ext4 file system with the option barrier=0. You
    should read the documentation for any options that you change
    because sometimes performance-enhancing options for file systems
    come at the cost of data integrity.
-   If you have a raw disk image, disable the cache:

    $ qemu-system-i386 -drive file=disk_image,if=virtio,cache=none

-   If you are running multiple virtual machines concurrently that all
    have the same operating system installed, you can save memory by
    enabling kernel same-page merging:

    # echo 1 > /sys/kernel/mm/ksm/run

-   In some cases, memory can be reclaimed from running virtual machines
    by running a memory ballooning driver in the guest operating system
    and launching QEMU with the -balloon virtio option.

See http://www.linux-kvm.org/page/Tuning_KVM for more information.

See also
--------

-   Official QEMU website
-   Official KVM website
-   QEMU Emulator User Documentation
-   QEMU Wikibook
-   Hardware virtualization with QEMU by AlienBOB
-   Building a Virtual Army by Falconindy
-   QEMU, KVM, Xen & libvirt by Robert Warnke and Thomas Ritzau

Retrieved from
"https://wiki.archlinux.org/index.php?title=QEMU&oldid=303200"

Categories:

-   Emulators
-   Virtualization

-   This page was last modified on 5 March 2014, at 00:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
