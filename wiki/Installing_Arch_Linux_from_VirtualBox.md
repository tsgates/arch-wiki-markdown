Installing Arch Linux from VirtualBox
=====================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: There's no such  
                           thing as a PUEL edition  
                           anymore (only the        
                           extension pack is closed 
                           source) and there's no   
                           longer a core ISO image. 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This HOWTO will guide you through the process of installing Arch Linux
from a host machine on a raw disk using VirtualBox. This method offers
the ability to continue to work with the computer while installing.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Step 1: Installing VirtualBox                                      |
| -   2 Step 2: Creating a raw disk .vmdk image                            |
| -   3 Step 3: Downloading an Archlinux install image                     |
| -   4 Step 4: Creating a virtual machine                                 |
| -   5 Step 5: Installing the system                                      |
| -   6 Troubleshooting                                                    |
|     -   6.1 It doesn't boot on real hardware!                            |
+--------------------------------------------------------------------------+

Step 1: Installing VirtualBox
-----------------------------

See the detailed article VirtualBox for installation instructions. You
have to install the PUEL edition.

Step 2: Creating a raw disk .vmdk image
---------------------------------------

In order to use a raw disk in VirtualBox, your user must have write
rights for the device. There are two ways to achieve this: either by
directly changing the access rights of the device or by adding your user
to the disk group. The latter way is preferred. To do this, run:

    # gpasswd -a user disk

Note: To apply the new group settings, you have to log out and log in
again.

Now you must create a special .vmdk virtual machine disk file, so
VirtualBox will save the data to a raw disk instead of the file. Let the
file be saved in your user's VirtualBox directory, named raw.vmdk.
You'll create it using this command:

    $ VBoxManage internalcommands createrawvmdk -filename /home/user/.VirtualBox/VDI/raw.vmdk -rawdisk /dev/sdb -register

Where user is your user name and /dev/sdb is the device you want to
install Archlinux on.

For more information on using raw host disks, see the VirtualBox user
manual.

Step 3: Downloading an Archlinux install image
----------------------------------------------

If you have a working Internet connection on your host machine, which
you probably do, you should go for the FTP ISO image. Otherwise download
the core image. To obtain the image, go to:
https://archlinux.org/download/

Step 4: Creating a virtual machine
----------------------------------

Start up the VirtualBox GUI and run the New Virtual Machine Wizard:

1.  Give the machine a name and choose Arch Linux for the operating
    system.
2.  Choose the amount of memory to be allocated to the machine. At least
    160 MiB is needed.
3.  Select the raw.vmdk disk image.
4.  Click Finish.

Now go to File » Virtual Disk Manager and add the installation CD-ROM
image you've downloaded. Close the window, go to the Settings of the
virtual machine and choose the CD/DVD-ROM item on the left. Finally
check the Mount CD/DVD Drive box, choose the ISO Image File option and
select the installation media.

Step 5: Installing the system
-----------------------------

The main part is behind you. You have prepared a virtual machine with
mounted installation media. Remember that inside the virtual machine,
your disk will be named /dev/sda. Now you can loosely continue with one
of these guides:

-   Official Arch Linux Install Guide
-   Installing Arch Linux on a USB key

Troubleshooting
---------------

> It doesn't boot on real hardware!

This is most probably caused by the autodetect hook in
/etc/mkinitcpio.conf, which removes unneeded modules from the initramfs
image. If you have this hook in that file, remove it from the file and
run:

    # mkinitcpio -p linux

to regenerate the initramfs image.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Arch_Linux_from_VirtualBox&oldid=237762"

Categories:

-   Getting and installing Arch
-   Virtualization
