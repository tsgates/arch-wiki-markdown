VirtualBox Extras
=================

Summary

Describes some additional functionality of VirtualBox.

Related

VirtualBox - Main VirtualBox article.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Basic virtual machine setup                                        |
|     -   1.1 Audio                                                        |
|     -   1.2 RAM and video memory                                         |
|     -   1.3 CD-ROM                                                       |
|                                                                          |
| -   2 Extension pack                                                     |
| -   3 Networking                                                         |
|     -   3.1 NAT                                                          |
|     -   3.2 Bridged                                                      |
|                                                                          |
| -   4 Sharing keyboard and mouse                                         |
| -   5 Sharing files                                                      |
| -   6 D3D acceleration in Windows guests                                 |
| -   7 Virtual hard disks                                                 |
|     -   7.1 Cloning a Disk Image and Reassigning a UUID                  |
|     -   7.2 Compacting Linux disks                                       |
|     -   7.3 Compacting Windows disks                                     |
|     -   7.4 Increasing Windows disk size                                 |
|     -   7.5 Disk image format conversion                                 |
|         -   7.5.1 QEMU to VDI                                            |
|         -   7.5.2 VMware to VDI                                          |
|                                                                          |
| -   8 Windows XP guest and Nokia phones                                  |
| -   9 Starting virtual machines with a key binding                       |
| -   10 Detecting web-cams and other USB devices                          |
| -   11 Sending CTRL+ALT+F1                                               |
| -   12 Starting VMs at system boot on headless servers                   |
| -   13 Accessing a guest server                                          |
| -   14 Daemon Tools                                                      |
| -   15 VirtualBox on a USB key                                           |
| -   16 phpVirtualBox                                                     |
| -   17 Troubleshooting                                                   |
|     -   17.1 OpenBSD                                                     |
+--------------------------------------------------------------------------+

Basic virtual machine setup
---------------------------

> Audio

In the machine settings, go to the audio tab and select the correct
driver according to your sound system (ALSA, OSS or PulseAudio).

> RAM and video memory

You can change the default values by going to Settings → General.

> CD-ROM

You can change the default values by going to Settings → CD/DVD-ROM.

Check mount CD/DVD drive and select one of the following options.

Extension pack
--------------

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

Networking
----------

VirtualBox guests may be networked through various methods; among them,
there is #NAT and #Bridged networking. Using the #NAT method is the
simplest and the default for new virtual machines.

In order to use host-only and internal network settings you have to load
the vboxnetadp kernel module. Host-only Networks have to be created
first in VBox Manager->File->Preferences->Network, only then will you be
able to select the adapters name in a VMs Network settings. The
VirtualBox manual covers the available options for these two network
types. They have been omitted here due to them being, for the most part,
OS agnostic.

> NAT

From VirtualBox:

-   access the VM's Settings menu;
-   click on Network from the list to the left; finally,
-   in the Attached to drop-down list, select NAT.

VirtualBox's bundled DHCP server enables the guest system to be
configured with DHCP. The NAT IP address on the first card is 10.0.2.0,
10.0.3.0 on the second and so on.

> Bridged

Bridged networking may be setup through various methods; among them,
there is the native way, which requires minimal setup at the expense of
having less control. For other methods, see Advanced VirtualBox
Networking. Since newer versions, VirtualBox can bridge between a guest
and a wireless host interface without the help of third party utilities.

Before continuing, load the required module:

    # modprobe vboxnetflt

From VirtualBox:

-   access the VM's Settings menu;
-   click on Network from the list to the left;
-   in the Attached to drop-down list, select Bridged Adapter; finally,
-   in the Name drop-down list, select the name of the host interface
    that is connected to the network that the guest OS should be part
    of.

Start the virtual machine and configure its network as usual; e.g., DHCP
or static.

Sharing keyboard and mouse
--------------------------

-   To capture the keyboard and mouse, click the mouse inside the
    virtual machine display.
-   To uncapture, press right Ctrl.

To get seamless mouse integration between host and guest, install the
#Guest Additions inside the guest.

Sharing files
-------------

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

D3D acceleration in Windows guests
----------------------------------

Recent versions of Virtualbox have support for accelerating OpenGL
inside guests. This can be enabled with a simple checkbox in the
machine's settings, right below where video ram is set, and installing
the Virtualbox guest additions. However, most Windows games use Direct3D
(part of DirectX), not OpenGL, and are thus not helped by this method.
However, it is possible to gain accelerated Direct3D in your Windows
guests by borrowing the d3d libraries from Wine, which translate d3d
calls into OpenGL, which is then accelerated.

After enabling OpenGL acceleration as described above, go to
http://www.nongnu.org/wined3d/ in your Windows guest and grab the
"Latest version (Installer):". Reboot the guest into safe mode (press F8
before the Windows screen appears but after the Virtualbox screen
disappears), and install wined3d, accepting the defaults during the
install. (You may check the box for DirectX 10 support if you like,
don't touch anything else.) Reboot back to normal mode and you should
have accelerated Direct3D.

Note: This hack may or may not work for some games depending on what
hardware checks they make and what parts of D3D they use.

Note: This has only been tried on Windows XP and Windows 7 RC guests
AFAIK, and does not work on the Windows 7 guest. If you have experience
with this on a different windows version, please add that data here.

Virtual hard disks
------------------

> Cloning a Disk Image and Reassigning a UUID

Assigns a new UUID to the given image file. This way, multiple copies of
a container can be registered.

    $ VBoxManage internalcommands sethduuid /path/to/disk.vdi

> Compacting Linux disks

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

> Compacting Windows disks

See this article.

> Increasing Windows disk size

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

> Disk image format conversion

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

Windows XP guest and Nokia phones
---------------------------------

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

Starting virtual machines with a key binding
--------------------------------------------

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

Detecting web-cams and other USB devices
----------------------------------------

Make sure you filter any devices that are not a keyboard or a mouse so
they do not start up at boot and this insures that Windows will detect
the device at start-up.

Sending CTRL+ALT+F1
-------------------

If your guest O/S is a Linux distro, and you want to open a new tty text
shell or exit X via typing Ctrl+Alt+F1, you can easily send this command
to the guest O/S simply by hitting your 'Host Key' (usually the Ctrl in
the Right side of your keyboard) + F1 or F2, etc.

Starting VMs at system boot on headless servers
-----------------------------------------------

Add this line to /etc/rc.local

    exec /bin/su -c 'VBoxManage startvm --type headless <UUID|NAME>' PREFERED_USER >/dev/null 2>&1

Where <UUID|NAME> is the guest identifier, and PREFERRED_USER is the
user profile that contains the VM definitions and .vdi files.

Since exec replaces the currently running process, you will not be able
to start a second VM, or execute any other commands, after the exec. Try
the following if this is a problem:

    su -c 'VBoxHeadless -s <UUID|NAME> &' -s /bin/sh PREFERED_USER >/dev/null 2>&1

Using fully qualified path to su and VBoxHeadless is recommend. Add
additional lines like above to start additional VMs. Commands following
these in /etc/rc.local will be executed. Based on some rooting around in
the VirtualBox documentation, I get the impression this will be a little
more robust than 'VBoxManage ... --type headless' in future VBox
releases.

To determine the available VMs for a user:

    su -c 'VBoxManage list vms' PREFERED_USER

To save the state of a running VM:

    su -c 'VBoxManage controlvm <UUID|NAME> savestate' PREFERED_USER

/etc/rc.local.shutdown would be a good spot for this.

Accessing a guest server
------------------------

To access apache on a VM from the Host machine ONLY, simply execute the
following lines on the Host:

    $ VBoxManage setextradata GuestName "VBoxInternal/Devices/pcnet/0/LUN#0/Config/Apache/HostPort" 8888
    $ VBoxManage setextradata GuestName "VBoxInternal/Devices/pcnet/0/LUN#0/Config/Apache/GuestPort" 80
    $ VBoxManage setextradata GuestName "VBoxInternal/Devices/pcnet/0/LUN#0/Config/Apache/Protocol" TCP

Where 8888 is the port the host should listen on and 80 is the port the
VM will send Apache's signal on. To use a port lower than 1024 on the
host machine changes need to be made to the firewall on the host
machine. This can also be set up to work with SSH, etc.. by changing
"Apache" to whatever service and using different ports.

Note: "pcnet" refers to the network card of the VM. If you use an Intel
card in your VM settings change "pcnet" to "e1000"

-   from [1]

Daemon Tools
------------

While VirtualBox can mount ISO images without a problem, there are some
image formats which cannot reliably be converted to ISO. For instance,
ccd2iso ignores .ccd and .sub files, which can give disk images with
broken files, fuseiso and MagicISO will do the same.

In this case you will either have to use CDEmu for Linux or Daemon Tools
inside VirtualBox.

VirtualBox on a USB key
-----------------------

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

phpVirtualBox
-------------

An open source, AJAX implementation of the VirtualBox user interface
written in PHP. As a modern web interface, it allows you to access and
control remote VirtualBox instances. See PhpVirtualBox for more
information.

Troubleshooting
---------------

> OpenBSD

Some people with older computers can have trouble running an OpenBSD VM,
manifesting as bunch of segmentation faults and total unusability.
Starting VirtualBox with the -norawr0 argument may solve the problem.
You can do it like this:

    $ VBoxSDL -norawr0 -vm NameOfYourOpenBSDVM

Retrieved from
"https://wiki.archlinux.org/index.php?title=VirtualBox_Extras&oldid=249863"

Categories:

-   Emulators
-   Virtualization
