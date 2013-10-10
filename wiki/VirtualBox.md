VirtualBox
==========

> Summary

This article is about basic usage of VirtualBox, including running the
VirtualBox software within an Arch host, and running an Arch guest
inside a VirtualBox virtual machine.

Required software

VirtualBox

> Related

VirtualBox Extras

PhpVirtualBox

VirtualBox Arch Linux Guest On Physical Drive

Advanced VirtualBox Networking

Installing Arch Linux from VirtualBox

Moving an existing install into (or out of) a virtual machine

VirtualBox is a virtual PC emulator like VMware. It is in constant
development and new features are implemented all the time. e.g. version
2.2 introduced OpenGL 3D acceleration support for Linux and Solaris
guests. It has a Qt GUI interface, as well as headless and SDL command
line tools for managing and running virtual machines. It includes guest
additions for some guest operating systems, which integrate functions of
the guest and host systems, including sharing files, the clipboard,
video acceleration and a “seamless” window integration mode.

See the Wikipedia article on this subject for more information:
VirtualBox

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation on host                                               |
|     -   1.1 Hosts running a custom kernel                                |
|         -   1.1.1 Automatic re-compilation of the virtualbox host        |
|             modules with every update of any kernel                      |
|                                                                          |
| -   2 Setup                                                              |
|     -   2.1 Loading Kernel Modules                                       |
|     -   2.2 Guest additions disc                                         |
|     -   2.3 Booting a live disc                                          |
|     -   2.4 Starting virtual machines with a service                     |
|     -   2.5 Advanced setup                                               |
|                                                                          |
| -   3 Arch Linux guests                                                  |
|     -   3.1 Install the Guest Additions                                  |
|     -   3.2 Automatic re-compilation of the VirtualBox guest modules     |
|         with every update of any kernel                                  |
|     -   3.3 Start the sharing services                                   |
|     -   3.4 Using USB webcam / microphone                                |
|     -   3.5 Using Arch under Virtualbox EFI mode                         |
|                                                                          |
| -   4 Shared Folders as Arch Linux Guest                                 |
|     -   4.1 Synchronise guest date with host                             |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 VBOX_E_INVALID_OBJECT_STATE (0x80BB0007)                     |
|     -   5.2 USB subsystem is not working on the host or guest            |
|     -   5.3 Failed to create the host-only network interface             |
|     -   5.4 WinXP: Bit-depth cannot be greater than 16                   |
|     -   5.5 Mounting .vdi Images                                         |
|     -   5.6 Startup problems because of mount failures                   |
|     -   5.7 Copy&Paste not working on Arch Linux Guest                   |
|     -   5.8 Use Serial port in guest OS                                  |
|     -   5.9 Abort on resume                                              |
|                                                                          |
| -   6 External links                                                     |
+--------------------------------------------------------------------------+

Installation on host
--------------------

The basic GPL-licensed VirtualBox suite can be installed with the
virtualbox package, found in the official repositories.

The virtualbox-host-modules package, which contains the precompiled
modules for the stock archlinux kernel, should be installed with it. If
you are using the linux-lts kernel you should also install the
virtualbox-host-modules-lts package. For custom kernels, read the
section below.

In order to use the graphical interface, based on Qt (VirtualBox
command), you will also need to install the qt4 package. This is not
required for the simpler SDL-only GUI (VBoxSDL command) nor for the
VBoxHeadless command.

> Hosts running a custom kernel

VirtualBox works just fine with custom kernels such as Linux-ck without
the need to keep any of the official ARCH kernel packages on the system.
The trick to keeping pacman from bringing down the ARCH kernel packages
is to install virtualbox with the virtualbox-host-dkms package, which
contains the source for the virtualbox kernel modules. See FS#26721 for
further explanations.

Once virtualbox-host-dkms is installed, simply generate the kernel
modules for your custom kernel by running:

    # dkms install vboxhost/<virtualbox-host-source version> -k <your custom kernel's version>/<your architecture>

Which for the lazy is the command:

    # dkms install vboxhost/$(pacman -Q virtualbox|awk {'print $2'}|sed 's/\-.\+//') -k $(uname -rm|sed 's/\ /\//')

and load it:

    # modprobe vboxdrv

To load/compile virtualbox modules automatically at startup you can
enable dkms.service:

    # systemctl enable dkms.service

Automatic re-compilation of the virtualbox host modules with every update of any kernel

This is possible thanks to vboxhost-hook from the AUR. In vboxhost-hook,
the 'automatic re-compilation' functionality is done by a vboxhost hook
on mkinitcpio after forcing to update the linux-headers package. You
will need to add 'vboxhost' to the HOOKS array in /etc/mkinitcpio.conf,
as well as 'linux-headers' and your custom kernel(s) headers to the
SyncFirst array in /etc/pacman.conf for this to work.

Warning:The SyncFirst option is no longer available as of pacman 4.1.
Use

    $ pacman -Sy linux-headers && pacman -Su

instead to manually cause linux-headers to be updated first. See This
explanation.

The hook will call the dkms command to update the virtualbox host
modules for the version of your new kernel.

Note:If you are using this functionality it's important to look at the
installation process of the linux (or any other kernel) package.
vboxhost hook will tell you if anything goes wrong.

Setup
-----

Add the desired username to the vboxusers group. Everything may work
fine without this step but shared folders and possibly some other
optional stuff require it to work. The new group does not automatically
apply to existing sessions; the user has to log in again or start a new
environment with a command like newgrp or sudo -u username -s.

    # gpasswd -a username vboxusers

> Loading Kernel Modules

VirtualBox running on Linux uses its own kernel modules, including a
mandatory module named vboxdrv, which must be loaded before virtual
machines can run. It can be automatically loaded when Arch Linux starts
up, or it can be loaded manually when necessary.

To load the module manually:

    # modprobe vboxdrv

To load the VirtualBox driver at startup, create a *.conf file (e.g.
virtualbox.conf) in /etc/modules-load.d that contains all modules that
should be loaded:

    /etc/modules-load.d/virtualbox.conf

    vboxdrv

Note:You may need to update the kernel modules db in order to avoid 'no
such file or directory' error when loading vboxdrv. Run: depmod -a.

To start the VirtualBox graphical manager:

    $ VirtualBox

To ensure full functionality of bridged networking, ensure that the
vboxnetadp, vboxnetflt and vboxpci kernel modules are loaded as well as
the net-tools package.

> Guest additions disc

The virtualbox package also suggests installing virtualbox-guest-iso on
the host (Arch Linux) running VirtualBox. It is a disc image that can be
used to install the guest additions onto guest systems. Make it
available to the (running) guest by going to Devices and clicking
"Install Guest Additions... Host+D". Then run the guest additions
installation from inside the guest.

> Booting a live disc

Click the 'New' button to create a new virtual environment. Name it
appropriately and select Operating System type and version. Select base
memory size (note: most operating systems will need at least 512 MB to
function properly). Create a new hard disk image (a hard disk image is a
file that will contain the operating system's filesystem and files).

When the new image has been created, click 'Settings', then CD/DVD-ROM,
check 'Mount CD/DVD Drive' then select an ISO image.

> Starting virtual machines with a service

See Systemd/Services#VirtualBox virtual machines for details on how to
setup a systemd service for each virtual machine.

> Advanced setup

See VirtualBox Extras for advanced configuration.

Arch Linux guests
-----------------

Installing Arch under VirtualBox is straightforward, and additions
should be installed through pacman (not through "Install Guest
Additions" in VirtualBox, or from a mounted ISO image).

> Install the Guest Additions

Install the virtualbox-guest-utils package. Manually load the modules
with:

    # modprobe -a vboxguest vboxsf vboxvideo

Create a *.conf file (e.g. virtualbox.conf) in /etc/modules-load.d/ with
these lines:

    /etc/modules-load.d/virtualbox.conf

    vboxguest
    vboxsf
    vboxvideo

> Automatic re-compilation of the VirtualBox guest modules with every update of any kernel

This is possible thanks to vboxguest-hook from the AUR. In
vboxguest-hook, the 'automatic re-compilation' functionality is done by
a vboxguest hook on mkinitcpio after forcing to update the linux-headers
package. You will need to add vboxguest to the HOOKS array in
/etc/mkinitcpio.conf. You may need to manually recreate the initramfs
after an upgrade of the linux-headers package.

The hook will call the dkms command to update the VirtualBox guest
modules for the version of your new kernel.

Note:If you are using this functionality, it is important to look at the
installation process of the linux (or any other kernel) package.
vboxguest hook will tell you if anything goes wrong.

> Start the sharing services

After installing virtualbox-guest-utils above, you should start
VBoxClient-all to start services for sharing the clipboard, resizing the
screen, etc.

-   If you are running something that launches
    /etc/xdg/autostart/vboxclient.desktop, such as GNOME or KDE, then
    nothing needs to be done.
-   If you use .xinitrc to launch things instead, you must add the
    following to your .xinitrc before launching your WM.

    # VBoxClient-all &

> Using USB webcam / microphone

Note:You will need to have VirtualBox extension pack installed before
following the steps below. See VirtualBox_Extras#Extension_pack for
details.

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
working is to press the C key inside GRUB and type exit. Obviously, this
will only work with grub-efi, not grub-bios.  

Regenerating the grub.cfg file may also be required to fix broken UUIDs.
Check with the lsblk -f command that they match.  

Yet another useful way to get to VirtualBox boot menu is pressing F12
right after starting virtual machine. It comes in handy when using
rEFInd + EFISTUB, for example.

Shared Folders as Arch Linux Guest
----------------------------------

Shared folders are managed via the VirtualBox program on the host. They
may be added, auto-mounted and made read-only from there. Creating a
shared folder from the VirtualBox program in the host locates that
folder in /media/sf_SHAREDFOLDERNAME. At this time an additional step is
needed to have that folder created in the Arch Guest because Arch use a
package for Guest Additions. To create and access this shared folder
from the Arch Guest, this must also be done at the command line after
installing the Guest Additions package(s) from pacman:

    # groupadd vboxsf
    # gpasswd -a $USER vboxsf

If you wish, a symbolic link may be made to another folder in your home
directory for easy access. As an example, if a shared folder named
"Dropbox" was created in the VirtualBox program on the host machine,
then /media/sf_Dropbox is automatically created in the guest so this
could be done:

    $ ln -s /media/sf_Dropbox/* ~/dropbox

The .run script provided in the Guest Additions iso does this for you,
however, Arch does not recommend using that script so this step must be
done manually. The instructions for it were found here: (pastebin: [1])
.

If shared folders are not auto-mounted, try manually mount or read the
next section.

To prevent startup problems when you're using systemd, you should add
comment=systemd.automount to your /etc/fstab. This way, they are mounted
only when you access those mountpoints and not during startup. Otherwise
your system might become unusable after a kernel upgrade (if you install
your guest additions manually).

    desktop   /media/desktop    vboxsf  uid=user,gid=group,rw,dmode=700,fmode=600,comment=systemd.automount 0 0

Don't waste your time to test the nofail option. mount.vboxsf is not
able to handle this (2012-08-20).

    desktop   /media/desktop    vboxsf  uid=user,gid=group,rw,dmode=700,fmode=600,nofail 0 0

> Synchronise guest date with host

To keep sync date and time, make sure you have virtualbox-guest-utils
installed in your host (see previous section). Then run

    # systemctl enable vboxservice.service

To enable the service for next boot. To start immediately, run

    # systemctl start vboxservice.service

You also need run this daemon in order to use auto-mounting feature of
shared folders that are mentioned above.

Troubleshooting
---------------

> VBOX_E_INVALID_OBJECT_STATE (0x80BB0007)

This can occur if a VM is exited ungracefully. The solution to unlock
the VM is trivial:

    VBoxManage controlvm nArch poweroff

> USB subsystem is not working on the host or guest

Sometimes the USB subsystem is not auto-detected resulting in an error
or in a not visible USB drive on the host, even when the user is in the
vboxusers group. See this topic [2] for details.

USB subsystem will work if you add

    VBOX_USB=usbfs

to ~/.bashrc and reboot your system or open a new bash instance.

Also make sure that your user is a member of the storage group.

> Failed to create the host-only network interface

To be able to create a Host-Only Network Adapter or a Bridged Network
Adapter the kernel modules vboxnetadp and vboxnetflt need to be loaded,
you also need to make sure the net-tools package is installed. It's
possible to load these kernel modules manually with

    # modprobe -a vboxnetadp vboxnetflt

To load them automatically at boot, add a new line for each module to
/etc/modules-load.d/virtualbox.conf:

    vboxdrv
    vboxnetadp
    vboxnetflt

Note:These used to be added to the MODULES array in /etc/rc.conf. This
is now deprecated.

More information in this topic.

> WinXP: Bit-depth cannot be greater than 16

If you are running at 16-bit color depth, then the icons may appear
fuzzy/choppy. However, upon attempting to change the color depth to a
higher level, the system may restrict you to a lower resolution or
simply not enable you to change the depth at all. To fix this, run
regedit add the following key to the Virtual Windows XP registry:

    [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services]
    "ColorDepth"=dword:00000004

Then update the color depth in the desktop properties window. If nothing
happens, force the screen to redraw through some method (i.e. Host+F to
redraw/enter full screen).

> Mounting .vdi Images

This just work with static size vdi images! Dynamic size won't be easy
mountable! First we need one information from your .vdi image:

    $ VBoxManage internalcommands dumphdinfo Arch_64min.vdi |grep offData
    Header: offBlocks=4096 offData=69632

Now, add to your offData 32256. e.g. 32256 + 69632 = 101888

Now you can mount your vdi image:

    # mount -t ext4 -o rw,noatime,noexec,loop,offset=101888 Arch_64min.vdi /mnt/

> Startup problems because of mount failures

If you experience problems in a systemd setup after a kernel upgrade,
you should start the system with init=/bin/bash (if the emergency shell
does not work for you).

    root=/dev/mapper/vg_main-lv_root ro vga=792 resume=/dev/mapper/vg_main-lv_swap init=/bin/bash

Then mount the root-filesystem with write access:

    # mount / -o remount,rw

Change /etc/fstab according to #Shared Folders as Arch Linux Guest. Then
exec systemd within the Bash shell:

    # exec /bin/systemd

> Copy&Paste not working on Arch Linux Guest

Since updating virtualbox-guest-additions to version 4.2.0-2 copy&paste
from Host OS to Arch Linux Guest stopped working. It seems to be due to
VBoxClient-all requiring root access. In previous versions adding
VBoxClient-all & to ~/.xinitrc was sufficient to make copy&paste work.
Update ~/.xinitrc to match sudo VBoxClient-all & and add the line
, NOPASSWD: /usr/bin/VBoxClient-all to your username in the sudoers file
and restart X. It should all work again. The line in the sudoers file
should look similar to this:

     # Allow sudo for user 'you' and let him run VBoxClient-all without requiring a password
     you ALL = PASSWD: ALL, NOPASSWD: /usr/bin/VBoxClient-all

Note:Use visudo to edit the sudoers file. This will check for syntax
errors when saving.

> Use Serial port in guest OS

Check you permission in Serial port

    $ /bin/ls -l /dev/ttyS*
    crw-rw---- 1 root uucp 4, 64 Feb  3 09:12 /dev/ttyS0
    crw-rw---- 1 root uucp 4, 65 Feb  3 09:12 /dev/ttyS1
    crw-rw---- 1 root uucp 4, 66 Feb  3 09:12 /dev/ttyS2
    crw-rw---- 1 root uucp 4, 67 Feb  3 09:12 /dev/ttyS3

Add you user in uucp group.

    # gpasswd -a YOURUSER uucp 

and relogon.

> Abort on resume

There is a known bug that causes abort on resume:
https://www.virtualbox.org/ticket/11289. The workaround is simple:
always use Host+q or the menu to close the VM.

External links
--------------

-   VirtualBox User Manual

Retrieved from
"https://wiki.archlinux.org/index.php?title=VirtualBox&oldid=254909"

Categories:

-   Emulators
-   Virtualization
