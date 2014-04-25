Installing Arch Linux in VMware
===============================

Related articles

-   VMware
-   Installing VMWare vCLI

This article handles installing Archlinux in a VMware-based virtual
environment such as VMware ESX, VMware Workstation/Fusion and VMware
Player.

Contents
--------

-   1 Drivers included in the Linux kernel
-   2 VMware tools versus Open-VM-Tools
-   3 Open-VM-Tools modules
-   4 Open-VM-Tools utilities
-   5 Installing Open-VM-Tools
-   6 Installing the official VMware tools
-   7 Time synchronization
    -   7.1 Host machine as time source
    -   7.2 External server as time source
-   8 Xorg configuration
    -   8.1 Enable 3d Acceleration
    -   8.2 Multiple Monitor Support
-   9 Paravirtual SCSI-adapter
-   10 VMCI
-   11 Drag and drop
-   12 Copy and paste
    -   12.1 Rebuilding the vmblock module
-   13 Shared folders with the host
    -   13.1 Enable shared folders at boot
    -   13.2 Prune mlocate DB
-   14 Trouble shooting
    -   14.1 Mouse not working as expected
    -   14.2 Back and forward mouse buttons not working
    -   14.3 Network connection not working

Drivers included in the Linux kernel
------------------------------------

-   vmw_balloon (VMware Balloon Driver): This is VMware physical memory
    management driver which acts like a "balloon" that can be inflated
    to reclaim physical pages by reserving them in the guest and
    invalidating them in the monitor, freeing up the underlying machine
    pages so they can be allocated to other guests. The balloon can also
    be deflated to allow the guest to use more physical memory. If this
    driver is loaded memory which is deallocated in the virtual machine
    can be reused in the host machine. Without this driver the memory
    would be allocated to the guest until the guest is terminated.
-   vmw_pvscsi (VMware PVSCSI driver support): This driver supports
    VMware's para virtualized SCSI HBA.
-   vmw_vmci (VMware VMCI Driver): This is VMware's Virtual Machine
    Communication Interface. It enables high-speed communication between
    host and guest in a virtual environment via the VMCI virtual device.
-   vmw_vsock_vmci_transport (VMware VMCI transport for Virtual Sockets,
    Alias: vmware_vsock): This module implements a VMCI transport for
    Virtual Sockets. Enable this transport if your Virtual Machine runs
    on a VMware hypervisor.
-   vmwgfx (DRM driver for VMware Virtual GPU): Choose this option if
    you would like to run 3D acceleration in a VMware virtual machine.
    This is a KMS enabled DRM driver for the VMware SVGA2 virtual
    hardware.
-   vmxnet3 (VMware VMXNET3 ethernet driver): This driver supports
    VMware's vmxnet3 virtual ethernet NIC.

VMware tools versus Open-VM-Tools
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

The open-vm-tools-dkms package contains the following modules:

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

Install the open-vm-tools and the open-vm-tools-dkms package from the
official repositories.

Build the dkms modules as the post install message suggests. Note that
the post install message might not display the 100% correct version.

    dkms add open-vm-tools/2013.04.16
    dkms install -m open-vm-tools -v 2013.04.16 -k $(uname -r)

Instead of dkms install you can use the following command if you do not
mind that only the specific version of open-vm-tools get installed:

     dkms autoinstall -k $(uname -r)

If you upgrade to a newer version of open-vm-tools-dkms you can
uninstall the old version with:

     dkms remove open-vm-tools/<version> --all 

Note:If the build fails, you can try using the linux-lts kernel instead
of the most recent kernel version.

As of September 2013, open-vm-tools does not compile against Linux 3.11.

Patches are floating around: here.

Start the service and enable it at boot if you wish:

    # systemctl start vmtoolsd
    # systemctl enable vmtoolsd

The open-vm-tools reads the file /etc/arch-release which is empty:

    # cat /proc/version > /etc/arch-release

Note:There is a bug in vmtoolsd where the service is not able to
properly shut down and hangs for 60 seconds. A quick workaround is
described here.

Installing the official VMware tools
------------------------------------

Install the ifconfig(1) program for the installer to work properly from
net-tools.

Install Linux kernel headers (linux-headers) for the installer to work
properly:

    # cd /lib/modules/$(uname -r)/build/include/linux
    # ln -sv ../generated/uapi/linux/version.h

Create bogus init directories for the installer to work properly:

    # for x in {0..6}; do mkdir -pv /etc/init.d/rc$x.d; done

Mount the VMware Tools virtual CDROM when offered:

    # mount /dev/cdrom /mnt

For VMware Player, if the installation does not include the ISO then the
same can be downloaded from this location.

Extract the tarball:

    # cd /root
    # tar zxf /mnt/VMwareTools*.tar.gz
    # cd vmware-tools-distrib

Make sure you have the base-devel installed, which provides the
development tools to build the kernel modules.

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

Note:In case the vmci and vmhgfs modules fail to build then try the
solutions and patches mentioned here and here.

As of Dec 15 2013, I used the scripts from this github repo.

Clone to a directory, copy the official VMwareTools tarball and execute
untar-and-patch-and-compile.sh as root.

There is also a pending issue here, where one line has to be patched
before vmhgfs compiles.

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

Install the dependencies xf86-input-vmmouse, xf86-video-vmware, and
svga-dri.

Configure the vmwgfx module to load at boot.

Create the following file:

    /etc/X11/xorg.conf.d/20-gpudriver.conf

     Section "Device"
            Identifier "Card0"
            Driver     "vmware"
     EndSection

Afterwards, a reboot is required.

If you are booting into a graphical target you are almost done.
/etc/xdg/autostart/vmware-user.desktop will get started which will setup
most of the things needed to work with the virtual machine.

If you are booting into multi-user.target then you need to enable the
vmtoolsd.service:

     # systemctl enable vmtoolsd.service

> Enable 3d Acceleration

To enable 3d acceleration go to Edit virtual machine settings > Hardware
> Display and enable the checkbox for Accelerate 3D graphics

> Multiple Monitor Support

If you chose the official VMware tools like I did, make sure that the
following is run after X startup so that you can go to "View > Cycle
Multiple Monitors". For some reason I cannot figure out, this for me
also automatically starts after 15 to 30 seconds after session login,
but thankfully it auto exits if it detects the same process. Make sure
to run it in the background otherwise it will block .xinitrc

     /usr/lib/vmware-tools/sbin64/vmtoolsd -n vmusr &

Paravirtual SCSI-adapter
------------------------

Due to less overhead the paravirtual scsi-adapter can give a substantial
performance boost in ESX.

This can be used as follows: open the /etc/mkinitcpio.conf file and add
the following to the MODULES array:

    MODULES=(...vmw_pvscsi...)

Afterwards, run the command:

    mkinitcpio -p linux

Shutdown the virtual machine and change the scsi-adapter type to:
VMware Paravirtual. It's safe to ignore the warning that will pop up.

VMCI
----

The VMCI interface is enabled by default in VMware Workstation and
Fusion. In VMware ESX the interface is restricted, which means that
communication is only possible between ESX and the virtual machine, not
between virtual machines themselves. This can be changed in the Virtual
Machine settings, traffic between ESX and the Virtual Machine can not be
disabled.

Note: If use the official VMware tools, you might have to backlist the
stock kernel's vmw_vmci module in order to get vmci to load, which
vmhgfs depends on

Drag and drop
-------------

Drag and Drop from files, from VMware Workstation/Fusion into the
Virtual Machines, can be disabled by editing /etc/conf.d/open-vm-tools:

    VM_DRAG_AND_DROP="no"

Copy and paste
--------------

Install gtkmm since it is required for copy/paste but not listed as a
dependency as reported here.

Run the following command after starting X (or add it to your ~/.xinitrc
file) to automatically synchronize your X clipboard with the host's.
This allows you to copy text from your virtual machine and paste it in
the host, and vice versa.

    vmware-user-suid-wrapper

If you get the following error (which, in rare cases, you might have to
run strace vmware-user-suid-wrapper to see it!)

    vmware-user: could not open /proc/fs/vmblock/dev

you need to first insert the vmblock module into your kernel.

    sudo modprobe vmblock

To have the module loaded at boot, see Kernel Modules#Loading.

> Rebuilding the vmblock module

If your kernel already has the vmblock module loaded,

    lsmod | grep vmblock

and vmware-user-suid-wrapper still does not work, then you will have to
build the open-vm-tools-modules package yourself from the Arch Build
System:

    # abs community/open-vm-tools-modules
    $ cp -R /var/abs/community/open-vm-tools-modules/ .
    $ cd ./open-vm-tools-modules/
    $ makepkg -s
    # pacman -U open-vm-tools-modules-*.xz

Afterwards, restart your machine for the newly rebuilt & re-installed
modules to take effect!

Shared folders with the host
----------------------------

Note:This functionality is only available in VMware Workstation and
Fusion

Create a new Shared Folder by selecting VM > Settings... in the VMware
Workstation menu. Select the Options tab and then ic|Shared Folder.
Enable the Always enabled option and create a new share. For Windows XP,
you can create a share named C with the host path C:\.

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

Note: If you are using the official VMware tools, you might have to
blacklist the stock kernel's vmw_vmci from loading in order to have the
official tools' vmci load, which vmhgfs depends on.

> Enable shared folders at boot

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

There is an issue with mouse input when running X11 in a VMware host. If
you experience one or more of the following:

-   the automatic grab/ungrab feature of VMware will not automatically
    grab input when the cursor enters the window
-   mouse input lag
-   mouse clicks are not registered in some programs

You may need to disable the catch-all evdev driver in X11: edit
/etc/X11/xorg.conf.d/10-evdev.conf and comment out the section with the
identifier evdev pointer catchall [xf86-input-vmmouse does not work
expected].

> Back and forward mouse buttons not working

Try to add the following line to your .vmx file:

     mouse.vusb.enable = "TRUE"

Or try this combination for smooth mouse (1 to 1 mapping of host OS),
forwards, backwards button working, and auto-focus grab and ungrab (at
least on Win8.1 host):

In VMware Workstation preferences:

     Preferences > Input > Optimize mouse for gaming: Never

evdev catchall NOT commented out in /etc/X11/xorg.conf.d/10-evdev.conf

No Section "InputClass" with vmmouse driver.

In the *.vmx file add or change:

     usb.generic.allowHID = "TRUE"
     mouse.vusb.enable = "TRUE"
     mouse.vusb.useBasicMouse = "FALSE"

> Network connection not working

Add the following line to your .vmx file:

     ethernet0.virtualDev = "vmxnet3"

More informations about the network adpater types can be found on the
following page: Choosing a network adapter for your virtual machine

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Arch_Linux_in_VMware&oldid=294827"

Categories:

-   Getting and installing Arch
-   Virtualization

-   This page was last modified on 29 January 2014, at 03:56.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
