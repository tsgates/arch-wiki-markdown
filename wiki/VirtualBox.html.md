VirtualBox
==========

Related articles

-   PhpVirtualBox
-   VirtualBox Arch Linux Guest On Physical Drive
-   Installing Arch Linux from VirtualBox
-   Moving an existing install into (or out of) a virtual machine

VirtualBox is a hypervisor used to run operating systems in a special
environment, called a virtual machine, on top of the existing operating
system. VirtualBox is in constant development and new features are
implemented continuously. It comes with a Qt GUI interface, as well as
headless and SDL command-line tools for managing and running virtual
machines.

In order to integrate functions of the host system to the guests,
including shared folders and clipboard, video acceleration and a
seamless window integration mode, guest additions are provided for some
guest operating systems.

See the Wikipedia article on this subject for more information:
VirtualBox

Contents
--------

-   1 Installation steps for Arch Linux hosts
    -   1.1 Core packages
    -   1.2 VirtualBox kernel modules
        -   1.2.1 Hosts running an official kernel
        -   1.2.2 Hosts running a custom kernel
    -   1.3 Load the VirtualBox kernel modules
    -   1.4 Add usernames to the vboxusers group
    -   1.5 Guest additions disc
    -   1.6 Use the right front-end
-   2 Installation steps for Arch Linux guests
    -   2.1 Install the Guest Additions
    -   2.2 VirtualBox guest kernel modules
        -   2.2.1 Guests running an official kernel
        -   2.2.2 Guests running a custom kernel
    -   2.3 Load the Virtualbox kernel modules
    -   2.4 Launch the VirtualBox guest services
-   3 Export VirtualBox virtual machines to other hypervisors
    -   3.1 Remove additions
    -   3.2 Use the right virtual disk format
        -   3.2.1 Supported formats by VirtualBox
        -   3.2.2 Specific virtual disk format differences
        -   3.2.3 Convert your virtual disk format
    -   3.3 Create the VM configuration for your hypervisor
-   4 Advanced configuration
    -   4.1 Using USB webcam / microphone
    -   4.2 Using Arch under Virtualbox EFI mode
    -   4.3 Synchronize guest date with host
    -   4.4 Enable shared folders
        -   4.4.1 Manually mounting
    -   4.5 Replace the virtual disk manually from the .vbox file
    -   4.6 Starting virtual machines with a service
    -   4.7 Extension pack
    -   4.8 Accessing a guest server
    -   4.9 Sharing keyboard and mouse
    -   4.10 Sharing files
    -   4.11 D3D acceleration in Windows guests
    -   4.12 Virtual hard disks
        -   4.12.1 Cloning a Disk Image and Reassigning a UUID
        -   4.12.2 Compacting Linux disks
        -   4.12.3 Compacting Windows disks
        -   4.12.4 Increasing Windows disk size
        -   4.12.5 Disk image format conversion
            -   4.12.5.1 QEMU to VDI
            -   4.12.5.2 VMware to VDI
    -   4.13 Starting virtual machines with a key binding
    -   4.14 Detecting web-cams and other USB devices
    -   4.15 Sending CTRL+ALT+F1
    -   4.16 VirtualBox on a USB key
-   5 Troubleshooting
    -   5.1 Windows XP guest and old Nokia phones not working
    -   5.2 Fix ISO images problems
    -   5.3 GUI does not match GTK Theme
    -   5.4 OpenBSD
    -   5.5 VBOX_E_INVALID_OBJECT_STATE (0x80BB0007)
    -   5.6 USB subsystem is not working on the host or guest
    -   5.7 Failed to create the host-only network interface
    -   5.8 WinXP: Bit-depth cannot be greater than 16
    -   5.9 Mounting .vdi images
    -   5.10 Use serial port in guest OS
    -   5.11 Windows 8.x Error Code 0x000000C4
    -   5.12 Windows 8 VM fails to boot with error "ERR_DISK_FULL"
-   6 External links

Installation steps for Arch Linux hosts
---------------------------------------

In order to launch VirtualBox virtual machines on your Arch Linux box,
follow these installation steps.

> Core packages

First, from the official repositories, install the virtualbox package
which contains the GPL-licensed VirtualBox suite with the SDL and
headless command-line tools included. The virtualbox package comes with
virtualbox-host-modules as a required dependency.

You can install the qt4 optional dependency in order to use the
graphical interface which is based on Qt. This is not required if you
intend to use VirtualBox in command-line only. See below to learn the
differences.

> VirtualBox kernel modules

Next, in order for VirtualBox to virtualize your guest installation, you
will need to add kernel modules to your host kernel.

As you have to know, the binary compatibility of kernel modules depends
on the API of the kernel against which they have been compiled. The
problem with the Linux kernel is that these interfaces might not be the
same from one kernel version to another. In order to avoid compatibility
problems and subtle bugs, each time the Linux kernel is upgraded, it is
advised to recompile the kernel modules against the Linux kernel version
that has just been installed. This is what Arch Linux packagers actually
do with the VirtualBox kernel modules packages: each time a new Arch
Linux kernel is released, the Virtualbox modules are upgraded
accordingly.

Therefore, if you are using a kernel from the official repositories or a
custom one (self-compiled or installed from the AUR), the kernel module
package you will need to install will thus vary.

Hosts running an official kernel

-   If you are using the linux kernel, make sure the
    virtualbox-host-modules package is still installed. The latter has
    been installed when you installed the virtualbox package.
-   If you are using the LTS version of the kernel (linux-lts), you need
    to install the virtualbox-host-modules-lts package.
    virtualbox-host-modules can now be removed if you want.

Hosts running a custom kernel

If you use or intend to use a self-compiled kernel from sources, you
have to know that VirtualBox does not require any virtualization modules
(e.g. virtuo, kvm,...). The VirtualBox kernel modules provide all the
necessary for VirtualBox to work properly. You can thus disable in your
kernel .config file these virtualization modules if you do not use other
hypervisors like Xen, KVM or QEMU.

The virtualbox-host-modules package works fine with custom kernels of
the same version of the Arch Linux stock kernel such as linux-ck.
However, if you are using a custom kernel which is not of the same
version of the Arch Linux stock one, you will have to install the
virtualbox-host-dkms package instead. The latter comes bundled with the
source of the VirtualBox kernel modules that will be compiled to
generate these modules for your kernel.

Since the virtualbox-host-modules comes with the official Arch Linux
kernel (linux) as a dependency, if you want to remove this default
kernel you do not use, you will have to install virtualbox-host-dkms as
well. Then, you will be able to remove virtualbox-host-modules then
linux (if no other packages require it).

As the virtualbox-host-dkms package requires compilation, make sure you
have the kernel headers corresponding to your custom kernel version to
prevent this error from happening
Your kernel headers for kernel your custom kernel version cannot be found at /usr/lib/modules/your custom kernel version/build or /usr/lib/modules/your custom kernel version/source.

-   If you use a self-compiled kernel and have used make modules_install
    to install its modules, folders
    /usr/lib/modules/your custom kernel version/build and (...)/source
    will be symlinked to your kernel sources. These will act as the
    kernel headers you need. If you have not removed these kernel
    sources yet, you have nothing to do.
-   If you use a custom kernel from AUR, make sure the package
    linux-headers is installed.

Once virtualbox-host-dkms is installed, simply generate the kernel
modules for your custom kernel by running the following command
structure:

    # dkms install vboxhost/virtualbox-host-source version -k your custom kernel version/your architecture

Tip:Use this all-in-one command instead, if you do not want to adapt the
above command:

    # dkms install vboxhost/$(pacman -Q virtualbox|awk {'print $2'}|sed 's/\-.\+//') -k $(uname -rm|sed 's/\ /\//')

To automatically recompile the VirtualBox kernel modules when their
sources get upgraded (i.e. when the virtualbox-host-dkms package gets
upgraded) and avoid to type again the above dkms install command
manually afterwards, enable the dkms service with:

    # systemctl enable dkms

Note:If you do not have the dkms service enabled while the
virtualbox-host-dkms package is being updated, the VirtualBox modules
will not be updated and you will have to type in manually the
dkms install command described above to compile the latest version of
the Virtualbox kernel modules. If you do not want to type in manually
this command, if the dkms service is automatically loaded at startup,
you just need to reboot and your VirtualBox modules will be recompiled
silently.

If you want to keep that dkms deamon disabled, you can use an initramfs
hook that will automatically trigger the dkms install command described
above at boot time. This requires to reboot to recompile the VirtualBox
modules. To enable this hook, install the vboxhost-hook package from the
AUR and add vboxhost to your HOOKS array in /etc/mkinitcpio.conf. Again,
make sure the right linux headers are available for the new kernel
otherwise the compilation will fail.

Tip:Like the dkms command, the vboxhost hook will tell you if anything
goes wrong during the recompilation of the VirtualBox modules.

> Load the VirtualBox kernel modules

Among the kernel modules VirtualBox uses, there is a mandatory module
named vboxdrv, which must be loaded before any virtual machines can run.
It can be automatically loaded when Arch Linux starts up, or it can be
loaded manually when necessary.

To load the module manually:

    # modprobe vboxdrv

Note:In order to avoid no such file or directory errors when using
modprobe, you may need to update the kernel dependency modules database
modprobe is using with depmod -a.

To load the VirtualBox module at boot time, refer to
Kernel_modules#Loading and create a *.conf file (e.g. virtualbox.conf)
in /etc/modules-load.d/ with the line:

    /etc/modules-load.d/virtualbox.conf

    vboxdrv

To ensure full functionality of bridged networking, ensure that the
vboxnetadp, vboxnetflt and vboxpci kernel modules are loaded as well and
that the net-tools package is installed.

Note:If the VirtualBox kernel modules were loaded in the kernel while
you updated the modules, you need to reload them manually to use the new
updated version.

> Add usernames to the vboxusers group

To use the USB ports of your host machine in your virtual machines, add
to the vboxusers group the usernames that will be authorized to use this
feature. The new group does not automatically apply to existing
sessions; the user has to log out and log in again, or start a new
environment with the newgrp command or with sudo -u $USER -s. To add the
current user to the vboxusers group, type:

    # gpasswd -a $USER vboxusers

> Guest additions disc

It is also recommended to install the virtualbox-guest-iso package on
the host running VirtualBox. This package will act as a disc image that
can be used to install the guest additions onto guest systems other than
Arch Linux.

> Use the right front-end

Now, you are ready to use VirtualBox. Congratulations!

Multiple front-ends are available to you which two are available by
default:

-   If you want to use VirtualBox in command-line only (only launch and
    change settings of existing virtual machines), you can use the
    VBoxSDL command. VBoxSDL does only provide a simple window that
    contains only the pure virtual machine, without menus or other
    controls.
-   If you want to use VirtualBox in command-line without any GUI
    running (e.g. on a server) to create, launch and configure virtual
    machines, use the VBoxHeadless which produces no visible output on
    the host at all, but instead only delivers VRDP data.

If you installed the qt4 optional dependency, you also have a nice
looking GUI interface with menus which is usable with the mouse.

Finally, you can use PhpVirtualBox to administrate your virtual machines
via a web interface.

Refer to the VirtualBox manual to learn how to create virtual machines.

Warning:If you store the virtual disk images on a Btrfs file system, you
should consider disabling Copy-on-Write for the directory before
creating any images.

Installation steps for Arch Linux guests
----------------------------------------

Follow these installation steps to install VirtualBox additions on your
fresh Arch Linux guest installation.

> Install the Guest Additions

On other GNU/Linux distribution, the Guest Additions can be installed in
two different ways:

-   either via the regular installation process described in the
    Virtualbox manual (on the host, clicking "Install Guest Additions"
    from the Virtualbox menu, then on the guest, mounting the cdrom
    manually in /mnt, then execute /mnt/VBoxLinuxAdditions.run);
-   or via a simple package you can install from the official
    repositories.

On Arch Linux guests, the official process does not work, you will get
Unable to determine your Linux distribution as an error message. You
have thus to use the second way and install virtualbox-guest-utils which
provides virtualbox-guest-modules as a required dependency.

> VirtualBox guest kernel modules

Guests running an official kernel

-   If you are using the linux kernel, make sure the
    virtualbox-guest-modules package is still installed. The latter has
    been installed when you installed the virtualbox-guest-utils
    package.
-   If you are using the LTS version of the kernel (linux-lts), you need
    to install the virtualbox-guest-modules-lts package.
    virtualbox-guest-modules can now be removed if you want.

Guests running a custom kernel

As this installation step is quite similar to the Vitualbox kernel
modules section for the host described above, please refer to that
section for more information and replace all virtualbox-guest-modules,
virtualbox-host-dkms and vboxhost-hook by virtualbox-guest-modules,
virtualbox-guest-dkms and vboxguest-hook respectively.

> Load the Virtualbox kernel modules

To load the modules manually, type:

    # modprobe -a vboxguest vboxsf vboxvideo

To load the VirtualBox module at boot time, refer to
Kernel_modules#Loading and create a *.conf file (e.g. virtualbox.conf)
in /etc/modules-load.d/ with these lines:

    /etc/modules-load.d/virtualbox.conf

    vboxguest
    vboxsf
    vboxvideo

> Launch the VirtualBox guest services

After the rather big installation step dealing with VirtualBox kernel
modules, now you need to start the guest services. The guest services
are actually just a binary executable called VBoxClient which will
interact with your X Window System. VBoxClient manages the following
features:

-   the shared clipboard and the drag and drop between the host and the
    guest;
-   the seamless window mode;
-   the fact that the guest display is automatically resized according
    to the size of the guest window;
-   and finally checking the VirtualBox host version.

All these features can be enabled indepently and manually with their
dedicated flags.

    $ VBoxClient --clipboard --draganddrop --seamless --display --checkhostversion

But VirtualBox provides a currently undocumented feature, a Bash script
VBoxClient-all which enables all these features automatically and checks
if a X11 server is really running before enabling some of them.

    $ VBoxClient-all

To start that script automatically when system starts run the following
command as root (or sudo):

    $ systemctl enable vboxservice

If you don't want to use systemd: (If you are unsure, use the method
above):

-   if you are using a desktop environment, you just need enable a
    checkbox or add the /usr/sbin/VBoxClient-all to the autostart
    section in your DE settings (the DE will typically set a flag to a
    .desktop file in ~/.config/autostart - see the Autostart section for
    more details -);
-   if you do not have any desktop environment, add the following line
    to the top of ~/.xinitrc (copy the file from /etc/skel/.xinitrc if
    it does not exist) above any exec options:

    ~/.xinitrc

    /usr/bin/VBoxClient-all

Now, you should have a working ArchLinux guest. Congratulations!

Export VirtualBox virtual machines to other hypervisors
-------------------------------------------------------

If you plan to use your virtual machine, created with VirtualBox, on
another computer which has not necessarily VirtualBox installed, you
might be interested in following the next steps.

> Remove additions

If you have installed the VirtualBox additions to your VirtualBox
virtual machine, please uninstall them first. Your guest, especially if
it is using an OS from the Windows family, might behave weirdly, crash
or even might not boot at all if you are still using the specific
VirtualBox drivers in another hypervisor.

Tip:If you intend to use a virtualization solution from Parallels Inc
for your Mac, the product Parallels Transporter can be used to create a
virtual machine from a Windows or GNU/Linux virtual machine (or even
from a native installation). With such a product, you do not need to
apply follow the next step and can stop reading here.

> Use the right virtual disk format

Supported formats by VirtualBox

VirtualBox comes with its own container for the virtual hard drives: the
Virtual Disk Image (VDI) file format. Even if this format is used by
default when you create a virtual machine with VirtualBox, you can
specify another one. Indeed VirtualBox does flawlessly support other
formats:

-   VMDK: this format has been initially developed by VMware for their
    products, but it is now an open format. If you intend to use any
    VMware product, you will need to use this format since it is the
    only one supported by VMware.

-   VHD: this is the format used by Microsoft in Windows Virtual PC and
    Hyper-V. If you intend to use any of these Microsoft products, you
    will have to choose this format.

Tip:Since Windows 7, this format can be mounted directly without any
additional application.

-   Version 2 of the HDD format used by Parallels (Desktop for Mac).

-   QED and QCOW used by QEMU.

The format you will need to choose depends on the hypervisor that will
be used.

Specific virtual disk format differences

Before converting your virtual drive, please keep in mind these specific
virtual disk format differences:

-   The VMDK does offer the ability to be split into several files of up
    to 2GB. This feature is specially useful if you want to store the
    virtual machine on machines which do not support very large files.
    Other formats do not provide such an equivalent feature.

-   Changing the logical capacity of an existing virtual drive with
    VirtualBox VBoxManage command is only supported for VDI and VHD
    formats used in dynamic allocation mode to expand (not shrink) their
    capacity.

Convert your virtual disk format

VirtualBox only supports the virtual disk conversion between VDI, VMDK
and VHD formats. Here is an example of conversion from a VDI to VMDK
vitual drive.

    $ VBoxManage clonehd ArchLinux_VM.vdi ArchLinux_VM.vmdk --format VMDK

If you want to replace the virtual disk you defined during the virtual
machine creation process by the one you have just converted, use the
VBoxManage storagectl command, or the GUI, or modify the .vbox
configuration file.

> Create the VM configuration for your hypervisor

If your hypervisor (like VMware) does not support import of VirtualBox
configuration files (.vbox), you will have to create a new virtual
machine and specify its hardware configuration as close as possible as
your initial VirtualBox virtual machine.

Note:Pay a close attention to the installation mode (BIOS or UEFI) used
to install the guest operating system. While an option is available on
VirtualBox to choose between these 2 modes, on VMware, you will have to
add the following line to your .vmx file.

    ArchLinux_vm.vmx

    firmware = "efi"

Finally, ask your hypervisor to use the existing virtual disk you have
converted and launch the virtual machine.

Tip:If you are using VMware products and do not want to run through the
whole GUI to find the right location to add your new virtual drive
device, you can replace the location of the current .vmdk file by
editing your .vmx configuration file manually.

Advanced configuration
----------------------

> Using USB webcam / microphone

Note:You will need to have VirtualBox extension pack installed before
following the steps below. See #Extension pack for details.

1.  Make sure the virtual machine is not running and your webcam /
    microphone is not being used.
2.  Bring up the main VirtualBox window and go to settings for Arch
    machine. Go to USB section.
3.  Make sure "Enable USB Controller" is selected. Also make sure that
    "Enable USB 2.0 (EHCI) Controller" is selected too.
4.  Click the "Add filter from device" button (the cable with the '+'
    icon).
5.  Select your USB webcam/microphone device from the list.
6.  Now click OK and start your VM.

> Using Arch under Virtualbox EFI mode

My experience with this configuration was pretty terrible, but it does
work.

UPD. Using efibootmgr has the same effect as using VirtualBox boot menu
(see the note below): settings disappear after VM shutdown. First,
efibootmgr does *not* work. It will appear to work, but all changes it
makes appear to be overwritten on reboot. After performing a standard
UEFI/GPT installation, reboot and you should get dumped to the EFI
shell. Type exit and you will get a menu. Select the Boot Management
Manager, Boot Options, Add Boot Option. Use the file browser to find the
grub efi file and select it. Add a label if you want. Afterwards, select
Change Boot Order from the menu, use arrow keys to select your Arch
option, and + to move it up to the top. GRUB should boot by default now.

Other options are: 1) move your loader to \EFI\boot\bootx64.efi, 2)
create \startup.nsh script, which executes desirable loader, like this:

    \startup.nsh

    HD16a0a1:\EFI\refind\refindx64.efi

Here I'm using consistent mapping name (HD16a0a1). It is probably a good
idea, because they do survive configuration changes.

Note:Another useful way to get back to the EFI menu after autobooting is
working is to press the c key inside GRUB and type exit. Obviously, this
will only work with grub-efi, not grub-bios.

Regenerating the grub.cfg file may also be required to fix broken UUIDs.
Check with the lsblk -f command that they match.  

Yet another useful way to get to VirtualBox boot menu is pressing F12
right after starting virtual machine. It comes in handy when using
rEFInd + EFISTUB, for example.

> Synchronize guest date with host

To keep the date and time synchronized, make sure you have
virtualbox-guest-utils installed in your host (see above). To enable the
service for subsequent boots, run

    # systemctl enable vboxservice

To start immediately, run

    # systemctl start vboxservice

You also need run this daemon in order to use the auto-mounting feature
of shared folders that are mentioned above.

> Enable shared folders

Shared folders are managed via the VirtualBox program on the host. They
may be added, auto-mounted and made read-only from there.

If automounting is enabled, and the vboxservice is enabled, creating a
shared folder from the VirtualBox program on the host will mount that
folder in /media/sf_SHAREDFOLDERNAME on the guest. To have that folder
created on the Arch Guest, after the Guest Additions have been
installed, you need to add your username to the vboxsf group.

    # groupadd vboxsf
    # gpasswd -a $USER vboxsf

Note:For automounting to work, you have to enable the vboxservice
service.

If you want a shared folder (e.g /media/sf_Dropbox) to be symlinked to
another folder in your home directory for easy access, you can type on
the guest:

    $ ln -s /media/sf_Dropbox/* ~/dropbox

The VBoxLinuxAdditions.run script provided in the Guest Additions iso
does this for you, however, Arch does not recommend using it.

Manually mounting

Look at the following for more info: [1]

Syntax:

    mount -t vboxsf <shared-folder-name> <mount-point-on-guest-system>

If you get an error like:

    /sbin/mount.vboxsf: mounting failed with the error: No such device

Try:

    modprobe vboxsf

For additional info, see this post.

  
 To prevent startup problems when you're using systemd, you should add
comment=systemd.automount to your /etc/fstab. This way, they are mounted
only when you access those mount points and not during startup.
Otherwise your system might become unusable after a kernel upgrade (if
you install your guest additions manually).

    desktop   /media/desktop    vboxsf  uid=user,gid=group,rw,dmode=700,fmode=600,comment=systemd.automount 0 0

Don't waste your time to test the nofail option. mount.vboxsf is not
able to handle this (2012-08-20).

    desktop   /media/desktop    vboxsf  uid=user,gid=group,rw,dmode=700,fmode=600,nofail 0 0

> Replace the virtual disk manually from the .vbox file

If you think that editing a simple XML file is more convenient than
playing with the GUI or with VBoxManage and you want to replace (or add)
a virtual disk to your virtual machine, simply replace in the .vbox
configuration file corresponding to your virtual machine the GUID, the
file location and the format to your needs:

    ArchLinux_vm.vbox

    <HardDisk uuid="{670157e5-8bd4-4f7b-8b96-9ee412a712b5}" location="ArchLinux_vm.vdi" format="VDI" type="Normal"/>

then in the <AttachedDevice> sub-tag of <StorageController>, replace the
GUID by the new one.

    ArchLinux_vm.vbox

    <AttachedDevice type="HardDisk" port="0" device="0">
      <Image uuid="{670157e5-8bd4-4f7b-8b96-9ee412a712b5}"/>
    </AttachedDevice>

Note:If you do not know the GUID of the drive you want to add, but you
have just used VBoxManage for the conversion, this command will output
the GUID just after the conversion. Using a random GUID does not work,
as each UUID is stored inside each disk images.

> Starting virtual machines with a service

Find hereafter the implementation details of a systemd service that will
be used to consider a virtual machine as a service.

    /etc/systemd/system/vboxvmservice@.service

    [Unit]
    Description=VBox Virtual Machine %i Service
    Requires=systemd-modules-load.service
    After=systemd-modules-load.service

    [Service]
    User=<user>
    Group=vboxusers
    ExecStart=/usr/bin/VBoxHeadless -s %i
    ExecStop=/usr/bin/VBoxManage controlvm %i savestate

    [Install]
    WantedBy=multi-user.target

Note:Replace <user> with a user that is a member of the vboxusers group.
Make sure the user chosen is the same user that will create/import
virtual machines, otherwise the user will not see the VM appliances.

To enable the service that will launch the virtual machine at next boot,
use:

    # systemctl enable vboxvmservice@your virtual machine name

To start the service that will launch directly the virtual machine, use:

    # systemctl start vboxvmservice@your virtual machine name

VirtualBox 4.2 introduces a new way for UNIX-like systems to have
virtual machines started automatically, other than using a systemd
service.

> Extension pack

VirtualBox requires an extension pack in order to provide support for
RDP, as well as USB 2.0 and PXE booting for Intel network cards, etc.,
available at this webpage: VirtualBox Downloads. This PUEL licensed
extension pack is free for personal use.

To install the Extension pack you download and save it to your hard
drive and then open the VirtualBox main program. Click on preferences
and on the left side click Extensions. On the right side, click the add
package icon and then open the folder that has the extension and click
to install it.

Additionally you can install the Extension Pack from the command line
using VBoxManage.

    VBoxManage extpack install <tarball> |
                       uninstall [--force] <name> |
                       cleanup

As an alternative, you could also use virtualbox-ext-oracle from the
AUR.

> Accessing a guest server

To access Apache server on a Virtual Machine from the host machine only,
simply execute the following lines on the host:

    $ VBoxManage setextradata GuestName "VBoxInternal/Devices/pcnet/0/LUN#0/Config/Apache/HostPort" 8888
    $ VBoxManage setextradata GuestName "VBoxInternal/Devices/pcnet/0/LUN#0/Config/Apache/GuestPort" 80
    $ VBoxManage setextradata GuestName "VBoxInternal/Devices/pcnet/0/LUN#0/Config/Apache/Protocol" TCP

Where 8888 is the port the host should listen on and 80 is the port the
VM will send Apache's signal on.

To use a port lower than 1024 on the host machine, changes need to be
made to the firewall on that host machine. This can also be set up to
work with SSH or any other services by changing "Apache" to the
corresponding service and ports.

Note:pcnet refers to the network card of the VM. If you use an Intel
card in your VM settings, change pcnet to e1000.

> Sharing keyboard and mouse

-   To capture the keyboard and mouse, click the mouse inside the
    virtual machine display.
-   To uncapture, press right Ctrl.

To get seamless mouse integration between host and guest, install the
#Guest Additions inside the guest.

> Sharing files

In the settings of the virtual machine go to shared folders tab and add
the folders you want to share.

-   NOTE: You need to install Guest Additions in order to use this
    feature.

    In a Linux host, Devices → Install Guest Additions
    Yes (when asked to download the CD image)
    Mount (when asked to register and mount)

In a Linux host, create one or more folders for sharing files, then set
the shared folders via the virtualbox menu (guest window).

In a Windows guest, starting with VirtualBox 1.5.0, shared folders are
browseable and are therefore visible in Windows Explorer. Open Windows
Explorer and look for it under My Networking Places → Entire Network →
VirtualBox Shared Folders.

Launch the Windows Explorer (run explorer command) to browse the network
places -> expand with the (+) sign : entire network → VirtualBox shared
folders → \\Vboxsvr → then you can now expand all your configured shared
folders here, and set up shortcuts for Linux folders in the guest
filesystem. You can alternatively use the "Add network place wizard",
and browse to "VBoxsvr".

Alternatively, on the Windows command line, you can also use the
following:

    net use x: \\VBOXSVR\sharename

While VBOXSVR is a fixed name, replace x: with the drive letter that you
want to use for the share, and sharename with the share name specified
with VBoxManage.

In a Windows guest, to improve loading and saving files (e.g. MS Office)
by VirtualBox Shared Folders edit c:\windows\system32\drivers\etc\hosts
as below:

    127.0.0.1 localhost vboxsvr

In a Linux guest, use the following command:

    # mount -t vboxsf [-o OPTIONS] sharename mountpoint
      (Notes: sharename is optional or same as selected in the VirtualBox-Dialog , mountpoint of the shared directory in the hosts filesystem)

Automatically mounting a shared folder is possible through the
linux-guest /etc/fstab file. You may also specify the uid=#,gid=# (where
# is replaced by the actual numerical uid and gid) to mount the share
with normal user permissions instead of root permissions. (this can be
helpful to mount parts of your host ~/home for use in your Linux-guest.
To do this add an entry in the following format to the linux-guest
/etc/fstab:

    sharename mountpoint vboxsf uid=#,gid=# 0 0

Replace sharename with the share name specified with VBoxManage, and
mountpoint with the path where you want the share to be mounted (e.g.
/mnt/share). The usual mount rules apply, that is, create this directory
first if it does not exist yet. Note that if you have told VirtualBox to
"automatically mount" the shared folder, this step may not be necessary
and your folder will be found somewhere under /media.

Beyond the standard options supplied by the mount command, the following
are available:

    iocharset=CHARSET

to set the character set used for I/O operations (utf8 by default) and

    convertcp=CHARSET

to specify the character set used for the shared folder name (utf8 by
default).

> D3D acceleration in Windows guests

Recent versions of Virtualbox have support for accelerating OpenGL
inside guests. This can be enabled with a simple checkbox in the
machine's settings, right below where video ram is set, and installing
the Virtualbox guest additions. However, most Windows games use Direct3D
(part of DirectX), not OpenGL, and are thus not helped by this method.
However, it is possible to gain accelerated Direct3D in your Windows
guests by borrowing the d3d libraries from Wine, which translate d3d
calls into OpenGL, which is then accelerated. These libraries are now
part of Virtualbox guest additions software.

After enabling OpenGL acceleration as described above, reboot the guest
into safe mode (press F8 before the Windows screen appears but after the
Virtualbox screen disappears), and install Virtualbox guest additions,
during install enable checkbox "Direct3D support". Reboot back to normal
mode and you should have accelerated Direct3D.

Note: This hack may or may not work for some games depending on what
hardware checks they make and what parts of D3D they use.

Note: This was tested on Windows XP, 7 and 8.1. If method does not work
on your Windows version please add data here.

> Virtual hard disks

Cloning a Disk Image and Reassigning a UUID

Assigns a new UUID to the given image file. This way, multiple copies of
a container can be registered.

    $ VBoxManage internalcommands sethduuid /path/to/disk.vdi

Compacting Linux disks

Boot the Linux guest VM and remove all bloat (unwanted packages, temp
files, etc.). When satisfied, wipe the freespace using dd or preferably
dcfldd:

    $ dcfldd if=/dev/zero of=fillfile bs=4M

When the fillfile hits the limit of the virtual hdd, the vast majority
of user-space (non-reserved blocks) will be filled. Alternatively, run
the command as root to get all of them. Example message: "8192 blocks
(8192Mb) written.dcfldd:: No space left on device."

Once this occurs, simply remove the fill file and powerdown the VM:

    $ rm -f fillfile && sudo shutdown -hF now

Note: The -F switch will force a disk check upon a reboot which is
advised following the compact operation.

Now compact the disk:

    $ VBoxManage modifyhd /path/to/your.vdi --compact

Compacting Windows disks

See this article.

Increasing Windows disk size

Warning:This has only been tested with Windows XP and Windows 7 guests.

If you find that you are running out of space due to the small hard
drive size you selected when created your VM, you can take the following
steps:

Create a new vdi in ~/.VirtualBox/HardDisks by running:

    # cd ~/.VirtualBox/HardDisks
    # VBoxManage createhd -filename new.vdi --size 10000

where size is in mb, in this example 10000MB ~= 10GB, and new.vdi is
name of new hard drive to be created.

Next the old vdi needs to be cloned to the new vdi, this may take some
time so wait while it occurs:

    # VBoxManage clonehd old.vdi new.vdi --existing

Detach old harddrive and attach new hard drive, replace VMName with
whatever you called your VM:

    # VBoxManage modifyvm VMName --hda none
    # VBoxManage modifyvm VMName --hda new.vdi

Boot the VM, run Partition Wizard 5 to resize the partition on the fly,
and reboot.

Remove old vdi from VirtualBox and delete

    # VBoxManage closemedium disk old.vdi
    # rm old.vdi

Disk image format conversion

The qemu-img program can be used to convert images from one format to
another or to add compression or encryption to an image. qemu-img is
provided by the qemu package.

QEMU to VDI

From QEMU 0.12.x on, qemu-img is able to convert directly to VDI and
back, if necessary:

    $ qemu-img convert -O vdi test.qcow2 test.vdi

VMware to VDI

You can

      $ VBoxManage clonehd source.vmdk target.vdi --format VDI

although recent versions of VirtualBox are able to use (and also create)
.vmdk images directly.

> Starting virtual machines with a key binding

It can be useful to start the virtual machines directly rather than
start the Virtual Box console. To do this, simply assign a keybinding in
.xbindkeysrc to

    "VBoxManage startvm vm-name"
    keycode
    keyname

If you have a space in the vm name, then enclose the vm-name in single
apostrophes. For eg.

    "VBoxManage startvm 'Windows 7'"
    m:0x0 + c:163
    XF86Mail

> Detecting web-cams and other USB devices

Make sure you filter any devices that are not a keyboard or a mouse so
they do not start up at boot and this insures that Windows will detect
the device at start-up.

> Sending CTRL+ALT+F1

If your guest operating system is a GNU/Linux distribution and you want
to open a new TTY shell or exit X via typing Ctrl+Alt+F1, you can easily
send this command to the guest simply by hitting your Host Key (usually
the right Ctrl key + F1 or F2, according to what you need to do.

> VirtualBox on a USB key

When using VirtualBox on a USB key, for example to start an installed
machine with an ISO image, you will manually have to create VDMKs from
the existing drives. However, once the new VMDKs are saved and you move
on to another machine, you may experience problems launching an
appropriate machine again. To get rid of this issue, you can use the
following script to launch VirtualBox. This script will clean up and
unregister old VMDK files and it will create new, proper VMDKs for you:

    #!/bin/bash

    # Erase old VMDK entries
    rm ~/.VirtualBox/*.vmdk

    # Clean up VBox-Registry
    sed -i '/sd/d' ~/.VirtualBox/VirtualBox.xml

    # Remove old harddisks from existing machines
    find ~/.VirtualBox/Machines -name \*.xml | while read file; do
      line=`grep -e "type\=\"HardDisk\"" -n $file | cut -d ':' -f 1`
      if [ -n "$line" ]; then
        sed -i ${line}d $file
        sed -i ${line}d $file
        sed -i ${line}d $file
      fi
      sed -i "/rg/d" $file
    done

    # Delete prev-files created by VirtualBox
    find  ~/.VirtualBox/Machines -name \*-prev -exec rm '{}' \;

    # Recreate VMDKs
    ls -l /dev/disk/by-uuid | cut -d ' ' -f 9,11 | while read ln; do
      if [ -n "$ln" ]; then
        uuid=`echo "$ln" | cut -d ' ' -f 1`
        device=`echo "$ln" | cut -d ' ' -f 2 | cut -d '/' -f 3 | cut -b 1-3`

        # determine whether drive is mounted already
        checkstr1=`mount | grep $uuid`
        checkstr2=`mount | grep $device`
        checkstr3=`ls ~/.VirtualBox/*.vmdk | grep $device`
        if [[ -z "$checkstr1" && -z "$checkstr2" && -z "$checkstr3" ]]; then
          VBoxManage internalcommands createrawvmdk -filename ~/.VirtualBox/$device.vmdk -rawdisk /dev/$device -register
        fi
      fi
    done

    # Start VirtualBox
    VirtualBox

Note that your user has to be added to the "disk" group to create VMDKs
out of existing drives.

Troubleshooting
---------------

> Windows XP guest and old Nokia phones not working

To get working Windows XP and Nokia phones with PC Suite mode,
VirtualBox needs two simple steps:

1. Add a rule to udev with /etc/udev/rules.d/40-permissions.rules:

    LABEL="usb_serial_start"
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", \
    GROUP="usbfs", MODE="0660", GROUP="dialout"
    LABEL="usb_serial_end"

2. Create the group usbfs and add its user to it

    # groupadd usbfs
    # usermod -a -G usbfs $USER

After logging out, connect a Nokia phone with PC Suite mode and start
Windows XP to test the new rule.

> Fix ISO images problems

While VirtualBox can mount ISO images without problem, there are some
image formats which cannot reliably be converted to ISO. For instance,
ccd2iso ignores .ccd and .sub files, which can give disk images with
broken files.

In this case, you will either have to use CDEmu for Linux inside
VirtualBox or any other utility used to mount disk images.

> GUI does not match GTK Theme

See Uniform Look for Qt and GTK Applications for information about
theming Qt based applications like Virtualbox or Skype.

> OpenBSD

Some people with older computers can have trouble running an OpenBSD VM,
manifesting as bunch of segmentation faults and total unusability.
Starting VirtualBox with the -norawr0 argument may solve the problem.
You can do it like this:

    $ VBoxSDL -norawr0 -vm NameOfYourOpenBSDVM

> VBOX_E_INVALID_OBJECT_STATE (0x80BB0007)

This can occur if a VM is exited ungracefully. The solution to unlock
the VM is trivial:

    $ VBoxManage controlvm <your virtual machine name> poweroff

> USB subsystem is not working on the host or guest

Sometimes, on old Linux hosts, the USB subsystem is not auto-detected
resulting in an error
Could not load the Host USB Proxy service: VERR_NOT_FOUND or in a not
visible USB drive on the host, even when the user is in the vboxusers
group. This problem is due to the fact that VirtualBox switched from
usbfs to sysfs in version 3.0.8. If the host doesn't understand this
change, you can revert to the old behaviour by defining the following
environment variable in any file that is sourced by your shell (e.g.
your ~/.bashrc if you're using bash):

    ~/.bashrc

    VBOX_USB=usbfs

Then make sure, the environment has been made aware of this change
(reconnect, source the file manually, launch a new shell instance or
reboot).

Also make sure that your user is a member of the storage group.

> Failed to create the host-only network interface

To be able to create a Host-Only Network Adapter or a Bridged Network
Adapter, the kernel modules vboxnetadp and vboxnetflt need to be loaded,
you also need to make sure the net-tools package is installed. You can
load these kernel modules manually with:

    # modprobe -a vboxdrv vboxnetadp vboxnetflt

To load these modules automatically at boot, refer to
Kernel_modules#Loading and use a program name of virtualbox.

> WinXP: Bit-depth cannot be greater than 16

If you are running at 16-bit color depth, then the icons may appear
fuzzy/choppy. However, upon attempting to change the color depth to a
higher level, the system may restrict you to a lower resolution or
simply not enable you to change the depth at all. To fix this, run
regedit in Windows and add the following key to the Windows XP VM's
registry:

    [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services]
    "ColorDepth"=dword:00000004

Then update the color depth in the "desktop properties" window. If
nothing happens, force the screen to redraw through some method (i.e.
Host+f to redraw/enter full screen).

> Mounting .vdi images

Mounting vdi images only works with fixed size (static) images; dynamic
size images aren't easily mountable.

First we need one information from your .vdi image:

    $ VBoxManage internalcommands dumphdinfo <your .vdi file location> | grep offData
    Header: offBlocks=4096 offData=69632

Then, add to your offData 32256. (e.g. 32256 + 69632 = 101888)

Now you can mount your vdi image with the following command:

    # mount -t ext4 -o rw,noatime,noexec,loop,offset=101888 <your .vdi file location> /mnt/

You can also use mount.vdi script that, which you can use as (install
script itself to /sbin):

    # mount -t vdi -o fstype=ext4,rw,noatime,noexec <your .vdi file location> /mnt/

  

> Use serial port in guest OS

Check you permission for the serial port:

    $ /bin/ls -l /dev/ttyS*
    crw-rw---- 1 root uucp 4, 64 Feb  3 09:12 /dev/ttyS0
    crw-rw---- 1 root uucp 4, 65 Feb  3 09:12 /dev/ttyS1
    crw-rw---- 1 root uucp 4, 66 Feb  3 09:12 /dev/ttyS2
    crw-rw---- 1 root uucp 4, 67 Feb  3 09:12 /dev/ttyS3

Add your user to the uucp group.

    # gpasswd -a $USER uucp 

and log out and log in again.

> Windows 8.x Error Code 0x000000C4

If you get this error code while booting, even if you choose OS Type Win
8, try to enable the CMPXCHG16B CPU instruction:

    $ vboxmanage setextradata <your virtual machine name> VBoxInternal/CPUM/CMPXCHG16B 1

> Windows 8 VM fails to boot with error "ERR_DISK_FULL"

Situation: Your Windows 8 VM refuses to start. VirtualBox throws an
error stating the virtual disk is full. However, you are certain that
the disk is not full. Bring up your VM's settings at Settings > Storage
> Controller:SATA and select "Use Host I/O Cache".

External links
--------------

-   VirtualBox User Manual

Retrieved from
"https://wiki.archlinux.org/index.php?title=VirtualBox&oldid=304230"

Categories:

-   Emulators
-   Virtualization

-   This page was last modified on 13 March 2014, at 05:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
