Installing Arch Linux in VMware
===============================

Summary

Installing Archlinux in VMware: open-vm-tools and configuring Xorg

Related

VMware

Installing VMWare vCLI

This article handles installing Archlinux in a VMware-based virtual
environment such as VMware ESX, VMware Workstation/Fusion and VMware
Player.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 VMware Tools versus Open-VM-Tools                                  |
| -   2 Open-VM-Tools modules                                              |
| -   3 Open-VM-Tools utilities                                            |
| -   4 Installing Open-VM-Tools                                           |
| -   5 Installing the official VMware Tools                               |
| -   6 Time synchronization                                               |
|     -   6.1 Host machine as time source                                  |
|     -   6.2 External server as time source                               |
|                                                                          |
| -   7 Xorg configuration                                                 |
|     -   7.1 Enable 3d accleration                                        |
|                                                                          |
| -   8 Paravirtual SCSI-Adapter                                           |
| -   9 VMCI                                                               |
| -   10 DRAG AND DROP                                                     |
| -   11 COPY AND PASTE                                                    |
|     -   11.1 Rebuilding the vmblock module                               |
|                                                                          |
| -   12 Shared Folders with the Host                                      |
|     -   12.1 Enable shared folders at boot                               |
|     -   12.2 Prune mlocate DB                                            |
|                                                                          |
| -   13 Trouble shooting                                                  |
|     -   13.1 Mouse not working as expected                               |
|     -   13.2 Network connection not working                              |
+--------------------------------------------------------------------------+

VMware Tools versus Open-VM-Tools
---------------------------------

VMware Tools for linux exists in 2 forms: the official VMware Tools and
Open-VM-Tools. VMware Tools is based on a stable snapshot of
Open-VM-Tools. Open-VM-Tools contains more experimental code and
features. The official VMware Tools are not available for Archlinux.

Originally, VMware Tools provided the best drivers for network and
storage, combined with the functionality for other features such as time
synchronization. However, for quite a while now the drivers for the
network adapter en scsi adapter are part of the linux kernel, and VMware
Tools is only needed for extra features and support for the "old" vmxnet
adapter.

Open-VM-Tools modules
---------------------

The open-vm-tools-modules package contains the following modules:

-   vmblock: kernel filesystem module, enables drag&drop functionality
    between the host system and the virtual machine in VMware
    Workstation/Fusion.
-   vmhgfs: kernel filesystem module, enables file/directory sharing
    between the host system and the virtual machine in VMware
    Workstation/Fusion.
-   vmsync: experimental filesystem sync driver, enables filesystem
    quiescing when creating backups and snapshots.
-   vmci: virtual machine communication interface, high performance
    interface between virtual machines on the same host and between
    virtual machines and the host itself.
-   vsock: part of vmci.
-   vmxnet: driver for the old vmxnet netwerk-adapter.

Open-VM-Tools utilities
-----------------------

The open-vm-tools package comes with the following utilities:

-   vmtoolsd: service responsible for the virtual machine status report.
-   vmware-check-vm: tool to check whether a utility has been started on
    a physical or virtual machine.
-   vmware-xferlogs: Dumps logging/debugging information to the virtual
    machine logfile.
-   vmware-toolbox-cmd: tool to obtain virtual machine information of
    the host such as statistics,...
-   vmware-user-suid-wrapper: tool to enable clipboard sharing
    (copy/paste) between host and virtual machine.

Installing Open-VM-Tools
------------------------

Install the open-vm-tools and the open-vm-tools-modules package in the
[community] repository.

    # pacman -S open-vm-tools open-vm-tools-modules

Start the service and enable it at boot:

    # systemctl start vmtoolsd
    # systemctl enable vmtoolsd

The open-vm-tools reads the file /etc/arch-release which is empty:

    # cat /proc/version > /etc/arch-release

Installing the official VMware Tools
------------------------------------

Install the ifconfig(1) program for the installer to work properly:

    # pacman -S net-tools

Install Linux kernel headers for the installer to work properly:

    # pacman -S linux-headers
    # cd /lib/modules/$(uname -r)/build/include/linux
    # ln -sv ../generated/uapi/linux/version.h

Create bogus init directories for the installer to work properly:

    # for x in `seq 0 6`; do mkdir -pv /etc/init.d/rc$x.d; done

Mount the VMware Tools virtual CDROM when offered:

    # mount /dev/cdrom /mnt

Extract the tarball:

    # cd /root
    # tar zxf /mnt/VMwareTools*.tar.gz
    # cd vmware-tools-distrib

Make sure you have the development tools installed to build the kernel
modules

    # pacman -S base-devel

Run the installer and use the default answers for all questions:

     # ./vmware-install.pl

You can safely ignore the following build failures:

-   VMNEXT 3 virtual network card
-   "Warning: This script could not find mkinitrd or updatte-initramfs
    and cannot remake the initrd file!"

Reboot your computer:

    # systemctl reboot

Log in and start the VMware Tools:

    # /etc/init.d/rc6.d/K99vmware-tools start

Time synchronization
--------------------

Configuring time synchronization in a virtual machine is important:
fluctuations are bound to occur more easily in a virtual machine
compared to a physical host. This is mostly due to the fact that the CPU
is shared by more than one virtual machine.

There are 2 options to set up time synchronization: the host machine as
source or an external server as source.

> Host machine as time source

To use the host as a time source (for example in an ESX server), run the
following command (one time is enough):

    vmware-toolbox-cmd timesync enable

To synchronize your guest clock with the host after your host machine
wakes up from sleeping (like a laptop computer):

    sudo hwclock --hctosys --localtime

I run the above command every time I wake up my sleeping laptop and
resume using Arch Linux inside the VMWare Player.

> External server as time source

See NTP.

Xorg configuration
------------------

Note:To use Xorg in a virtual machine, a minimum of 32MB VGA memory is
needed, and the VMware hardware version has to be > 8, version 7 is no
longer functioning correctly.

Install the following dependencies:

    pacman -S xf86-input-vmmouse xf86-video-vmware svga-dri

Configure the vmwgfx module to load at boot.

Create the following file:

    /etc/X11/xorg.conf.d/20-gpudriver.conf

     Section "Device"
            Identifier "Card0"
            Driver     "vmware"
     EndSection

Afterwards, a reboot is required.

If you're booting into a graphical target you're almost done.
/etc/xdg/autostart/vmware-user.desktop will get started which will setup
most of the things needed to work with the virtual machine.

If you're booting into multi-user.target then you need to enable the
vmtoolsd.service:

     # systemctl enable vmtoolsd.service

> Enable 3d accleration

To enable 3d acceleration go to Edit virtual machine settings ->
Hardware -> Display and enable the checkbox for Accelerate 3D graphics

Paravirtual SCSI-Adapter
------------------------

Due to less overhead the paravirtual scsi-adapter can give a substantial
performance boost in ESX.

This can be used as follows: open the /etc/mkinitcpio.conf file and add
the following to the MODULES array:

    MODULES=(...vmw_pvscsi...)

Afterwards, run the command:

    mkinitcpio -p linux

Shutdown the virtual machine and change the scsi-adapter type to:
VMware Paravirtual. It's safe to ignore the warning that'll pop up.

VMCI
----

The VMCI interface is enabled by default in VMware Workstation and
Fusion. In VMware ESX the interface is restricted, which means that
communication is only possible between ESX and the virtual machine, not
between virtual machines themselves. This can be changed in the Virtual
Machine settings, traffic between ESX and the Virtual Machine can not be
disabled.

DRAG AND DROP
-------------

Drag and Drop from files, from VMware Workstation/Fusion into the
Virtual Machines, can be disabled by editing /etc/conf.d/open-vm-tools:

    VM_DRAG_AND_DROP="no"

COPY AND PASTE
--------------

Install the following package (it is required for copy/paste but not
listed as a dependency as reported here)

    pacman -S gtkmm

Run the following command after starting X (or add it to your ~/.xinitrc
file) to automatically synchronize your X clipboard with the host's.
This allows you to copy text from your virtual machine and paste it in
the host, and vice versa.

    vmware-user-suid-wrapper

If you get the following error (which, in rare cases, you might have to
run `strace vmware-user-suid-wrapper` to see it!)

    vmware-user: could not open /proc/fs/vmblock/dev

you need to first insert the vmblock module into your kernel.

    sudo modprobe vmblock

To have the module loaded at boot, see Kernel Modules#Loading.

> Rebuilding the vmblock module

If your kernel already has the vmblock module loaded,

    lsmod | grep vmblock

and vmware-user-suid-wrapper still doesn't work, then you'll have to
build the open-vm-tools-modules package yourself from the Arch Build
System:

    sudo abs community/open-vm-tools-modules
    cp -R /var/abs/community/open-vm-tools-modules/ .
    cd ./open-vm-tools-modules/
    makepkg -s
    pacman -U open-vm-tools-modules-*.xz

Afterwards, restart your machine for the newly rebuilt & re-installed
modules to take effect!

Shared Folders with the Host
----------------------------

Note: This functionality is only available in VMware Workstation and
Fusion

Create a new Shared Folder by selecting VM -> Settings... in the VMware
Workstation menu. Select the Options tab and then Shared Folder. Enable
the Always enabled option and create a new share. For Windows XP, you
can create a share named C with the Host Path C:\.

Add the following rule to /etc/fstab (adjust the uid/gid where needed)
for each shared folder:

    .host:/shared_folder /mnt/shared vmhgfs defaults,user,ttl=5,uid=root,gid=root,fmask=0133,dmask=0022 0 0

Create the mount directories and Shared Folders:

    mkdir /mnt/shared
    mount /mnt/shared

Temporary mounts are also possible:

    mount -t -v -o rw .host:/shared_folder /mnt/shared

Note: an alternative way, tested on VMware player

    .host:/ /mnt/shared vmhgfs defaults 0 0
    mount -t vmhgfs .host:/ /mnt/shared

Enable shared folders at boot

For shared folders to be working you need to have loaded the vmhgfs
driver. Simply create the following systemd files:

    /etc/systemd/system/mnt-hgfs.mount

    [Unit]
    Description=Load VMware shared folders
    ConditionPathExists=.host:/
    ConditionVirtualization=vmware

    [Mount]
    What=.host:/
    Where=/mnt/hgfs
    Type=vmhgfs
    Options=defaults,noatime

    [Install]
    WantedBy=multi-user.target

    /etc/systemd/system/mnt-hgfs.automount

    [Unit]
    Description=Load VMware shared folders
    ConditionPathExists=.host:/
    ConditionVirtualization=vmware

    [Automount]
    Where=/mnt/hgfs

    [Install]
    WantedBy=multi-user.target

Make sure that the folder /mnt/hgfs exists:

     # mkdir -p /mnt/hgfs

Enable the mount target with:

     # systemctl enable mnt-hgfs.automount

> Prune mlocate DB

When using mlocate, it's useless to index the shared directories in the
locate DB. Therefore, add the directories to PRUNEPATHS in
/etc/updatedb.

Trouble shooting
----------------

> Mouse not working as expected

If you have the problem that mouse clicks are not registered in some
programs you can try the following: edit
/etc/X11/xorg.conf.d/10-evdev.conf and comment out the section with the
identifier evdev pointer catchall [xf86-input-vmmouse does not work
expected]

> Network connection not working

Add the following line to your .vmx file:

     ethernet0.virtualDev = "vmxnet3"

More informations about the network adpater types can be found on the
following page: Choosing a network adapter for your virtual machine

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Arch_Linux_in_VMware&oldid=253863"

Categories:

-   Getting and installing Arch
-   Virtualization
