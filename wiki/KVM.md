KVM
===

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: qemu-kvm no      
                           longer exists as all of  
                           its features have been   
                           merged into qemu. Whole  
                           page needs update.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

KVM, Kernel-based Virtual Machine, is a hypervisor built right into the
Linux kernel. It is similar to Xen in purpose but much simpler to get
running. To start using the hypervisor, just load the appropriate kvm
kernel modules and the hypervisor is up. As with Xen's full
virtualization, in order for KVM to work, you must have a processor that
supports Intel's VT-x extensions or AMD's AMD-V extensions.

Using KVM, one can run multiple virtual machines running unmodified
GNU/Linux, Windows, or any other operating system. (See Guest Support
Status). Each virtual machine has private virtualized hardware: a
network card, disk, graphics adapter, etc. See KVM Howto.

Differences among KVM, Xen, VMware, and QEMU can be found at the KVM
FAQ. KVM is used alongside Libvirt for better management with "virsh"
command set. Check Libvirt for more details.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Get the packages                                                   |
| -   2 Set up kernel modules                                              |
| -   3 How to use KVM                                                     |
|     -   3.1 Create a guest OS image                                      |
|     -   3.2 Install the guest OS                                         |
|     -   3.3 Running the system                                           |
|     -   3.4 GUI tool                                                     |
|                                                                          |
| -   4 Paravirtualized guests (virtio)                                    |
|     -   4.1 Preparing an (Arch) Linux guest                              |
|     -   4.2 Preparing a Windows guest                                    |
|     -   4.3 Preparing a FreeBSD guest                                    |
|                                                                          |
| -   5 Resizing the image                                                 |
|     -   5.1 Up-to-date way                                               |
|     -   5.2 Old way                                                      |
|                                                                          |
| -   6 Enabling KSM                                                       |
| -   7 Enable HugePages                                                   |
| -   8 Bridged Networking                                                 |
|     -   8.1 Using netcfg                                                 |
|     -   8.2 Additional notes                                             |
|                                                                          |
| -   9 Mouse integration                                                  |
| -   10 Mounting the QEMU image                                           |
| -   11 Starting KVM virtual machines on boot up                          |
| -   12 Tips and tricks                                                   |
|     -   12.1 Live snapshots                                              |
|     -   12.2 Poor Man's Networking                                       |
|     -   12.3 Performance Tuning                                          |
|     -   12.4 Nested virtualization                                       |
+--------------------------------------------------------------------------+

Get the packages
----------------

Arch Linux kernels provide the appropriate kernel modules to support
KVM. You can check if your kernel supports KVM with the following
command (assuming your kernel is built with CONFIG_IKCONFIG_PROC):

    $ zgrep KVM /proc/config.gz

KVM requires that the virtual machine host's processor has
virtualization support (named VT-x for Intel processors and AMD-V for
AMD processors). You can check whether your processor supports hardware
virtualization with the following command:

    $ lscpu

You processor supports virtualization only if there is a line telling
you so.

You can also run:

    $ grep -E "(vmx|svm)" --color=always /proc/cpuinfo

If nothing is displayed after running that command, then your processor
does not support hardware virtualization, and you will not be able to
use KVM.

Set up kernel modules
---------------------

First, you need to add your user account into the kvm group to use the
/dev/kvm device.

    # gpasswd -a <Your_Login_Name> kvm

Note:If you use systemd and are a local user, this is not necessary, as
access is now granted by systemd/udev.

Secondly, you have to choose one of the following depending on the
manufacturer of the VM host's CPU.

-   If you have Intel's VT-x extensions, modprobe the kvm_intel module.

    # modprobe kvm_intel

-   If you have AMD's AMD-V (code name "Pacifica") extensions, modprobe
    the kvm-amd module.

    # modprobe kvm_amd

If modprobing kvm_intel or kvm_amd fails but modprobing kvm succeeds,
(and lscpu claims that hardware acceleration is supported), check your
BIOS settings. Some vendors (especially laptop vendors) disable these
processor extensions by default. To determine whether there's no
hardware support or there is but the extensions are disabled in BIOS,
the output from dmesg after having failed to modprobe will tell.

If you want these modules to persist, see Kernel_modules#Loading.

How to use KVM
--------------

> Create a guest OS image

    $ qemu-img create -f qcow2 <Image_Name> <size> 

> Install the guest OS

A CD/DVD image (ISO file) can be used for the installation.

    $ qemu-kvm -hda <Image_Name> -m 512 -cdrom /path/to/the/ISO/image -boot d -vga std 

> Running the system

    $ qemu-kvm -hda <Image_Name> -m 512 -vga std

Note: you may want to assign multiple CPUs to the guest by using -smp X
(where X is the number of CPUs). The maximum number of assigned CPUs for
one guest is 16. Windows only supports 2 sockets. To assign more than 2
CPUs use the cores parameter e.g. -smp 8,cores=8.

Note:The default amount of main memory assigned to KVM guests is 128 MB.
If that is not sufficient, add the -m argument and the desired amount of
main memory specified in megabytes (e.g. -m 1024). Also note that recent
Windows operating systems (tested with Windows Vista and Windows 7)
require the qcow2 disk image format. Other disk image formats may give a
0x80070057 error during the installation.

See QEMU for more information, and the Using the Kernel-based Virtual
Machine section.

> GUI tool

You can use a GUI tool, such as qtemu for simple use or qemu-launcher
for particle control, to manage your virtual machines.

Leave the "QEMU start command" as qemu and append -enable-kvm to the
additional start options. With newer versions of qemu, it might not be
necessary to append -enable-kvm as the qemu executable will detect that
KVM is running and start in the correct mode.

If you start your VM with a GUI tool and installation is very slow, you
should check for proper KVM support, as QEMU may be falling back to pure
software emulation.

Paravirtualized guests (virtio)
-------------------------------

KVM offers guests the ability to use paravirtualized block and network
devices, which leads to better performance and lower overhead. For
Windows, a paravirtualized network driver can be obtained here. FreeBSD
has the ability to use virtio drivers since 10.0 (unreleased). A
backport of the drivers are available in the port emulators/virtio-kmod
for FreeBSD 8.3 and 9.0.

A virtio block device requires the option -drive instead of the simple
-hd* plus if=virtio:

    $ qemu-kvm -boot order=c -drive file=drive.img,if=virtio

(ps: -boot order=c is absolutely required when you want to boot from it.
There is no auto-detection as with -hd* ...)

Almost the same goes for the network:

    $ qemu-kvm -net nic,model=virtio

> Preparing an (Arch) Linux guest

Note:The Arch setup scripts for the installer do not handle vd* disk
devices correctly and required additional steps as detailed in this post
https://bbs.archlinux.org/viewtopic.php?pid=1042283.

To use virtio devices after an Arch Linux guest has been installed, the
following modules can be loaded in the guest: virtio, virtio_pci,
virtio_blk, virtio_net, and virtio_ring (for 32-bit guests, the specific
"virtio" module is not necessary).

If you want to boot from a virtio disk, the initial ramdisk must be
rebuilt. Add the appropriate modules in /etc/mkinitcpio.conf like this:

    MODULES="virtio_blk virtio_pci virtio_net"

and rebuild the initial ramdisk:

    # mkinitcpio -p linux

Virtio disks are recognized with the prefix v (e.g. vda, vdb, etc.);
therefore, changes must be made in at least /etc/fstab and
/boot/grub/menu.lst when booting from a virtio disk. When using grub-pc
which references disks by UUID's, nothing has to be done.

Edit or create /boot/grub/device.map:

    (hd0) /dev/vda

Note:The following may be outdated since official installation ISO
2011.08.19. The repositories now offer GRUB v2.

To enable virtio at Arch Linux installation time, manual GRUB
installation is required (for arch-release-media 2010.05). Though AIF
correctly detects the virtio disks and sets up the right prefixes, the
/boot/grub/device.map file must be created before configuring the
bootloader.

So when installing Arch Linux, you can install GRUB by switching to
another virtual terminal (Ctrl+Alt+F2) and running the following
commands.

    # grub
    > device (hd0) /dev/vda
    > root (hd0,0)
    > setup (hd0)
    > quit

Note:(hd0,0) numbering may change depending on your configuration.
Reference: http://lists.mandriva.com/bugs/2009-08/msg03424.php.

Once you have installed GRUB, switch back to the main terminal with
Ctrl+Alt+F1.

Further information on paravirtualization with KVM can be found here.

> Preparing a Windows guest

Preparing a Windows guest for running with a virtio disk driver is a bit
tricky.

In your KVM host (running Arch Linux), download the virtio disk driver
from the Fedora repository.

Now you need to create a new disk image, which fill force Windows to
search for the driver. To do it, stop the virtual machine if its running
and issue the following command:

    $ qemu-img create -f qcow2 fake.img 1G

Run the original Windows guest (still in the IDE mode). Add the fake
disk and a CD-ROM with the driver.

    $ qemu-kvm -drive file=windows.img,if=ide -m 512 -drive file=fake.img,if=virtio -cdrom virtio-win-0.1-30.iso -vga std

If you have problems booting windows.img ISO image, or the virtio cd
drivers not being detected, use this command.

    $ qemu-kvm -drive file=fake.img,if=virtio -m 512 -boot d -drive file=windows.img,media=cdrom -drive file=virtio-win-0.1-30.iso,media=cdrom

Windows will detect the fake disk and try to find a driver for it. If it
fails, go to Device Manager, locate the SCSI drive with an exclamation
mark icon (should be open), click "Update driver" and select the virtual
CD-ROM. Don't forget to mark the checkbox which says to search for
directories recursively.

When the installation is successful, you can turn off the virtual
machine and launch it again, now with the virtio driver.

    $ qemu-kvm -drive file=windows.img,if=virtio -m 512 -vga std

Note:If you encounter the Blue Screen of Death, make sure you did not
forget the -m parameter, and that you do not boot with virtio instead of
ide for the system drive before drivers are installed.

Note:The flag "boot=on" was removed due to newer versions no need it
anymore.

Preparing virtio networkdrivers is a bit easier, simply add the -net
argument as explained above.

    $ qemu-kvm -drive file=windows.img,if=virtio -m 512 -vga std -net nic,model=virtio -cdrom virtio-win-cdrom virtio-win-0.1-30.iso

Then install the virtio drivers from the disk you downloaded; Go to the
Device Manager, locate the network adapter with an exclamation mark icon
(should be open), click "Update driver" and select the virtual CD-ROM.
Don't forget to mark the checkbox which says to search for directories
recursively.

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

Resizing the image
------------------

Warning:Resizing an image containing an NTFS boot filesystem could make
the VM installed on it unbootable. One solution, which is really tricky
and for expert users only, is shown here along with a deep explanation
of the problem.

> Up-to-date way

Since version 0.13.0 of qemu, the resize option has been added to the
qemu-img executable. By this switch it is possible to resize a qcow2
image directly, with no need to pass through raw conversion. For
example, this command will increase my_image.qcow2 image space by 10
Gigabytes

    qemu-img resize my_image.qcow2 +10G

> Old way

It is possible to increase the size of a qcow2 image later, at least
with ext3. Convert it to a raw image, expand its size with dd, convert
it back to qcow2, replace the partition with a larger one, do a fsck and
resize the filesystem.

    $ qemu-img convert -O raw image.qcow2 image.img
    $ dd if=/dev/zero of=image.img bs=1G count=0 seek=[NUMBER_OF_GB]
    $ qemu-img convert -O qcow2 -o cluster_size=64K image.img imageplus.qcow2
    $ qemu-kvm -hda imageplus.qcow2 -m 512 -cdrom </Path/to/the/ISO/Image> -boot d -vga std
    # fdisk /dev/sda [delete the partition, create new one occupying whole disk]
    # e2fsck -f /dev/sda1
    # resize2fs /dev/sda1

Enabling KSM
------------

Kernel Samepage Merging (KSM) is a feature of the Linux kernel
introduced in the 2.6.32 kernel. KSM allows for an application to
register with the kernel to have its pages merged with other processes
that also register to have their pages merged. For KVM, the KSM
mechanism allows for guest virtual machines to share pages with each
other. In an environment where many of the guest operating systems are
similar, this can result in significant memory savings.

There should be a /sys/kernel/mm/ksm/ directory containing several
files. You can turn KSM on or off by echoing a 1 or 0 (respectively) to
/sys/kernel/mm/ksm/run:

    # echo 1 > /sys/kernel/mm/ksm/run

Or set it up by creating the file /etc/tmpfiles.d/ksm.conf:

    w /sys/kernel/mm/ksm/run - - - - 1

If KSM is running, and there are pages to be merged (i.e. more than one
similar VM is running), then /sys/kernel/mm/ksm/pages_shared should be
non-zero. From the kernel documentation in Documentation/vm/ksm.txt:

    The effectiveness of KSM and MADV_MERGEABLE is shown in /sys/kernel/mm/ksm/:

    pages_shared     - how many shared unswappable kernel pages KSM is using
    pages_sharing    - how many more sites are sharing them i.e. how much saved
    pages_unshared   - how many pages unique but repeatedly checked for merging
    pages_volatile   - how many pages changing too fast to be placed in a tree
    full_scans       - how many times all mergeable areas have been scanned

    A high ratio of pages_sharing to pages_shared indicates good sharing, but
    a high ratio of pages_unshared to pages_sharing indicates wasted effort.
    pages_volatile embraces several different kinds of activity, but a high
    proportion there would also indicate poor use of madvise MADV_MERGEABLE.

An easy way to see how well KSM is performing is to simply print the
contents of all the files in that directory.

    # grep . /sys/kernel/mm/ksm/*

    /sys/kernel/mm/ksm/full_scans:151
    /sys/kernel/mm/ksm/max_kernel_pages:246793
    /sys/kernel/mm/ksm/pages_shared:92112
    /sys/kernel/mm/ksm/pages_sharing:131355
    /sys/kernel/mm/ksm/pages_to_scan:100
    /sys/kernel/mm/ksm/pages_unshared:123942
    /sys/kernel/mm/ksm/pages_volatile:1182
    /sys/kernel/mm/ksm/run:1
    /sys/kernel/mm/ksm/sleep_millisecs:20

Enable HugePages
----------------

You may also want to enable hugepages to improve the performance of your
virtual machine. With an up to date Arch Linux and a running KVM you
probably already have everything you need. Check if you have the
directory /dev/hugepages. If not create it. Now we need the right
permissions to use this directory. Check if the group kvm exist and if
you are member of this group. This should be the case if you already
have a running virtual machine.

    $ getent group kvm

    kvm:x:78:USERNAMES

Add to your /etc/fstab:

    hugetlbfs       /dev/hugepages  hugetlbfs       mode=1770,gid=78        0 0

Of course the gid must match that of the kvm group. The mode of 1770
allows anyone in the group to create files but not unlink or rename each
other's files. Make sure /dev/hugepages is mounted properly:

    # umount /dev/hugepages
    # mount /dev/hugepages
    $ mount | grep huge

    hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime,mode=1770,gid=78)

Now you can calculate how many hugepages you need. Check how large your
hugepages are:

    $ cat /proc/meminfo | grep Hugepagesize

Normally that should be 2048 kB ≙ 2 MB. Let's say you want to run your
virtual machine with 1024 MB. 1024 / 2 = 512. Add a few extra so we can
round this up to 550. Now tell your machine how many hugepages you want:

    # echo 550 > /proc/sys/vm/nr_hugepages

If you had enough free memory you should see:

    $ cat /proc/meminfo | grep HugePages_Total

    HugesPages_Total:  550

If the number is smaller, close some applications or start your virtual
machine with less memory (number_of_pages x 2):

    $ kvm -m 1024 -mem-path /dev/hugepages [-hda yourimage.img] [-your_other_options]

Note the -mem-path parameter. This will make use of the hugepages. You
can check now, while your virtual machine is running, how many pages are
used:

    $ cat /proc/meminfo | grep HugePages

    HugePages_Total:     550
    HugePages_Free:       48
    HugePages_Rsvd:        6
    HugePages_Surp:        0

Now that everything seems to work you can enable hugepages by default if
you like. Add to your /etc/sysctl.conf:

    vm.nr_hugepages = 550

See also: Debian wiki and linux-kvm.com.

Bridged Networking
------------------

> Using netcfg

Bridged networking is used when you want your VM to be on the same
network as your host machine. This will allow it to get a static or DHCP
IP address on your network, and then you can access it using that IP
address from anywhere on your LAN. The preferred method for setting up
bridged networking for KVM is to use the netcfg package. You will also
need to install bridge-utils.

For more information, see: Netcfg Tips#Configuring a bridge for use with
virtual machines (VMs)

You can follow this page to configure the bridge: Libvirt#Bridged
Networking

> Additional notes

Other information can be found here: QEMU#Tap Networking with QEMU and
QEMU#Networking with VDE2.

If you are using iptables, it is recommended for performance and
security reasons to disable the firewall on the bridge:

    # cat >> /etc/sysctl.conf <<EOF
    net.bridge.bridge-nf-call-ip6tables = 0
    net.bridge.bridge-nf-call-iptables = 0
    net.bridge.bridge-nf-call-arptables = 0
    EOF
    # sysctl -p /etc/sysctl.conf

See the libvirt wiki and Fedora bug 512206. If you get errors by sysctl
during init (boot) about non-existing files, make the bridge module load
at boot. See Kernel_modules#Loading.

Alternatively, you can configure iptables to allow all traffic to be
forwarded across the bridge by adding a rule like this:

    -I FORWARD -m physdev --physdev-is-bridged -j ACCEPT

Mouse integration
-----------------

To prevent the mouse from being grabbed when clicking on the guest
operating system's windows, add the option -usbdevice tablet. This means
QEMU is able to report the mouse position without having to grab the
mouse. This also overrides PS/2 mouse emulation when activated.

    $ qemu-kvm -hda <Image_Name> -m 512 -vga std -usbdevice tablet

Mounting the QEMU image
-----------------------

There are many ways to mount partitions encapsulated in an image file or
partition. One option is to use network block devices:

    # modprobe nbd max_part=63
    $ qemu-nbd -c /dev/nbd0 [image.img]
    # mount /dev/nbd0p1 [/mnt/qemu]

An alternative is to use kpartx from the multipath-tools package:

    $ kpartx -l [image.img]
    $ kpartx -a [image.img]
    # mount /dev/mapper/[image.img]p1 [/mnt/qemu]

The first command merely lists the partitions detected in the image's
partition table, while the second one maps them using the kernel's
device mapper. In order to remove the partition mapping again, the
procedure is as follows:

    # umount [/mnt/qemu]
    $ kpartx -d [image.img]

Starting KVM virtual machines on boot up
----------------------------------------

If you use virt-manager and virsh as your VM tools, then this is very
simple. At the command line to set a VM to automatically start at
boot-up:

    $ virsh autostart <domain>

To disable autostarting:

    $ virsh autostart --disable <domain>

Virt-manager is equally easy having an autostart check box in the boot
options of the VM.

Note VMs started by QEMU or KVM from the command line are not then
manageable by virt-manager.

For an alternative check QEMU#Starting_QEMU_virtual_machines_on_boot.

Tips and tricks
---------------

> Live snapshots

A feature called external snapshotting allows one to take a live
snapshot of a virtual machine without turning it off. Currently it only
works with qcow2 and raw file based images.

Once a snapshot is created, KVM attaches that new snapshotted image to
virtual machine that is used as its new block device, storing any new
data directly to it while the original disk image is taken offline which
you can easily copy or backup. After that you can merge the snapshotted
image to the original image, again without shutting down your virtual
machine.

Here's how it works.

Current running vm

    # virsh list --all
    Id    Name                           State
    ----------------------------------------------------
    3     archey                            running

List all its current images

    # virsh domblklist archey 
    Target     Source
    ------------------------------------------------
    vda        /vms/archey.img

Notice the image file properties

    # qemu-img info /vms/archey.img
    image: /vms/archey.img
    file format: qcow2
    virtual size: 50G (53687091200 bytes)
    disk size: 2.1G
    cluster_size: 65536

Create a disk-only snapshot. The switch --atomic makes sure that the VM
is not modified if snapshot creation fails.

    # virsh snapshot-create-as archey snapshot1 --disk-only --atomic

List if you want to see the snapshots

    # virsh snapshot-list archey
    Name                 Creation Time             State
    ------------------------------------------------------------
    snapshot1           2012-10-21 17:12:57 -0700 disk-snapshot

Notice the new snapshot image created by virsh and its image properties.
It weighs just a few MiBs and is linked to its original "backing
image/chain".

    # qemu-img info /vms/archey.snapshot1
    image: /vms/archey.snapshot1
    file format: qcow2
    virtual size: 50G (53687091200 bytes)
    disk size: 18M
    cluster_size: 65536
    backing file: /vms/archey.img

At this point, you can go ahead and copy the original image with
cp -sparse=true or rsync -S. Then you can merge the original image back
into the snapshot.

    # virsh blockpull --domain archey --path /vms/archey.snapshot1

Now that you have pulled the blocks out of original image, the file
/vms/archey.snapshot1 becomes the new disk image. Check its disk size to
see what it means. After that is done, the original image
/vms/archey.img and the snapshot metadata can be deleted safely. The
virsh blockcommit would work opposite to blockpull but it seems to be
currently under development in qemu-kvm 1.3 (including snapshot-revert
feature), scheduled to be released sometime next year.

This new feature of KVM will certainly come handy to the people who like
to take frequent live backups without risking corruption of the file
system.

> Poor Man's Networking

Setting up bridged networking can be a bit of a hassle sometimes. If the
sole purpose of the VM is experimentation, one strategy to connect the
host and the guests is to use SSH tunneling.

The basic steps are as follows:

-   Setup an SSH server in the host OS
-   (optional) Create a designated user used for the tunneling (e.g.
    tunneluser)
-   Install SSH in the VM
-   Setup authentication

See: SSH for the setup of SSH, especially SSH#Forwarding_Other_Ports.

When using the default user network stack, the host is reachable at
address 10.0.2.2.

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Usage of         
                           /etc/rc.local is         
                           discouraged. This should 
                           be a proper systemd      
                           service file. (Discuss)  
  ------------------------ ------------------------ ------------------------

If everything works and you can SSH into the host, simply add something
like the following to your /etc/rc.local

    # Local SSH Server
    echo "Starting SSH tunnel"
    sudo -u vmuser ssh tunneluser@10.0.2.2 -N -R 2213:127.0.0.1:22 -f
    # Random remote port (e.g. from another VM)
    echo "Starting random tunnel"
    sudo -u vmuser ssh tunneluser@10.0.2.2 -N -L 2345:127.0.0.1:2345 -f

In this example a tunnel is created to the SSH server of the VM and an
arbitrary port of the host is pulled into the VM.

This is a quite basic strategy to do networking with VMs. However, it is
very robust and should be quite sufficient most of the time.

> Performance Tuning

Pass all available host processor features:

    -cpu host

Enable the virtio module for your network:

    -net nic,model=virtio

Same goes for your hard drive:

    -drive file='disk.img',if=virtio

For more about paravitualisation (virtio) see this page.

If you have a raw image, disable the cache:

    -drive file='disk.img',if=virtio,cache=none

See: http://www.linux-kvm.org/page/Tuning_KVM.

> Nested virtualization

Enable nested feature for kvm_intel:

     modprobe -r kvm_intel
     modprobe kvm_intel nested=1

Verify that feature is activated:

     # systool -m kvm_intel -v | grep nested
       nested              = "Y"

Create wrapper around qemu-kvm:

     # cat /usr/bin/qemu-kvm-nested 
     #!/bin/bash
     /usr/bin/qemu-system-x86_64 -cpu host "$@"
     # chmod a+x /usr/bin/qemu-kvm-nested
     # ls -la /usr/bin/qemu-kvm
     lrwxrwxrwx 1 root root 18 29 oct.  15:38 /usr/bin/qemu-kvm -> qemu-system-x86_64
     # ln -s /usr/bin/qemu-kvm-nested /usr/bin/qemu-kvm
     # ls -la /usr/bin/qemu-kvm
     lrwxrwxrwx 1 root root 24 12 nov.  13:09 /usr/bin/qemu-kvm -> /usr/bin/qemu-kvm-nested

Boot VM and check if vmx flag is present:

     grep vmx /proc/cpuinfo

Retrieved from
"https://wiki.archlinux.org/index.php?title=KVM&oldid=250607"

Categories:

-   Virtualization
-   Kernel
