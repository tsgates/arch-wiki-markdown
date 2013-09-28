Remastering the Install ISO
===========================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Preparation                                                        |
| -   3 Customizations                                                     |
| -   4 Creating a new ISO                                                 |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Introduction
------------

Remastering the official Arch Linux install ISO image is not necessary
for most applications. However, in some circumstances it is desirable. A
short, and non-inclusive list includes:

-   Basic hardware is not supported by the core install. (A rare
    circumstance)
-   Installation on a non-internet capable machine.
-   Deployment of Arch Linux on many similar machines, requiring the
    same installation procedure, and the administrator does not have the
    time (or desire) to install each machine manually.

Preparation
-----------

To remaster the Arch Linux ISO, you will need a copy of the original ISO
image. Download it from the download page

Tip: remember that # means that it must be done by root, while $ means
that it should be done by a user.

Now, create a new directory to mount the ISO:

    # mkdir /mnt/archiso

Mount the ISO to this directory (note: It being an image, the resulting
mount is read-only):

    # mount -t iso9660 -o loop /path/to/archISO /mnt/archiso

Now that the ISO is mounted, we must copy its contents to another
directory, where they can be edited:

    $ cp -a /mnt/archiso ~/customiso

Customizations
--------------

Edit the contents of ~/customiso as needed.

-   Some helpful hints:
    -   The kernels (IDE and scsi) that are booted by the cd are found
        at isolinux/vmlinuz and isolinux/vmlinuz_scsi, you may want to
        replace them with home-brewed ones. I recommend that you do not
        use your own, completely new, configs, but instead fetch the
        ones out of the kernels that already exist and edit as desired,
        this can be done using scripts/extract-ikconfig from any kernel
        source tree
    -   Kernel sources, as well as default Arch kernel configs, which
        are used if a user chooses to build a kernel at install time are
        located at arch/
    -   The filesystem you are given while in the install environment is
        at root-image.fs.sfs, if you'd like to edit this:

1. Copy it to another location

    $ cp root-image.fs.sfs ~

2. Extract the sqfs image from the file (squashfs-tools is needed for
this)

    $ unsquashfs root-image.fs.sfs 

3. This will generate a new folder called squashfs-root with a file
called root-image.fs in it. This file contains a ext2 filesystem. Mount
this filesystem to make changes to it.

    # mkdir /mnt/rootfs
    # mount ~/squashfs-root/root-image.fs /mnt/rootfs

4. You can do a chroot into this folder to be able to install new
software in the image using pacman.

    $ arch-chroot /mnt/rootfs

5. When you're done fiddling around, exit from the chroot, unmount the
rootfs and create the new squashfs image

    # exit
    # umount /mnt/rootfs
    $ mksquashfs squashfs-root root-image.fs.sfs

6. You'll now have a new root-image.fs.sfs, which you can copy back to
your ISO, replacing the old one

    $ cp root-image.fs.sfs customiso/root-image.fs.sfs

Creating a new ISO
------------------

Once you have edited your custom ISO to your needs, you must create a
new ISO image. This can be done with genisoimage, which is part of
cdrkit.

    $ genisoimage -l -r -J -V "ARCH_201209" -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c isolinux/boot.cat -o ~/arch-custom.iso ~/customiso

There should now be a file called arch-custom.iso in the home folder of
the user that created the iso. This can now be burned to a CD (DVD) and
used as intended. Enjoy your very own, customized, Arch Install CD.
Remember that the iso label must be the same as the one from the
original ISO (in this case ARCH_201209) or otherwise the image will not
work.

If installing the image into a pen drive with unetbootin remember also
that the label of the pen drive partition must be ARCH_201209. This can
be changed with e2label for ext3 partitions.

Note:In the most recent series of Arch ISO's, it has been reported that
unetbootin sometimes breaks the image. Please use dd to create
installer.

See also
--------

-   http://www.knoppix.net/wiki/KnoppixRemasteringHowto
-   http://syslinux.zytor.com/iso.php
-   http://busybox.net/
-   http://xentac.net/svn/arch-jc/trunk/bin/mkiso

Retrieved from
"https://wiki.archlinux.org/index.php?title=Remastering_the_Install_ISO&oldid=256181"

Category:

-   Getting and installing Arch
