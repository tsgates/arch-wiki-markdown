Moving an existing install into (or out of) a virtual machine
=============================================================

> Summary

Instructions on transferring your current install in or out of a virtual
machine.

> Related

VirtualBox

VMware

QEMU

Migrate installation to new hardware

This article describes how to transfer your current Arch Linux
installation in or out of a virtual environment (i.e. QEMU, VirtualBox,
VMware), and is heavily based on the Full System Backup with rsync
article. A virtual machine ("VM", for short) uses different hardware,
which needs to be addressed by re-generating the initramfs image and
possibly adjusting the fstab – especially if it's an SSD.

While any Linux filesystem should work, it's recommended that you go
with ext4, at least at first, until you get the hang of it.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Moving out of a VM                                                 |
|     -   1.1 Set up a shared folder                                       |
|     -   1.2 Transfer the system                                          |
|     -   1.3 Chroot and reinstall the bootloader                          |
|     -   1.4 Adjust the fstab                                             |
|     -   1.5 Re-generate the initramfs image                              |
|                                                                          |
| -   2 Moving into a VM                                                   |
|     -   2.1 Create the container                                         |
|     -   2.2 Transfer the system                                          |
|     -   2.3 Convert the container to a compatible format                 |
|     -   2.4 Chroot and reinstall the bootloader                          |
|     -   2.5 Adjust the fstab                                             |
|     -   2.6 Disable any Xorg-related files                               |
|     -   2.7 Re-generate the initramfs image                              |
|                                                                          |
| -   3 Troubleshoot                                                       |
|     -   3.1 "mount: special device /dev/loop5p1 does not exist"          |
|     -   3.2 "Waiting 10 seconds for device /dev/sda1; ERROR: Unable to   |
|         find root device '/dev/sda1'"                                    |
|     -   3.3 "Missing operating system. FATAL: INT18: BOOT FAILURE"       |
|     -   3.4 I'm asked for the root password, for maintenance             |
+--------------------------------------------------------------------------+

Moving out of a VM
------------------

Moving out of a virtual environment is relatively easy.

> Set up a shared folder

This part is specific to each program, so please visit their wiki page.

If you don't already have an ext4 partition, see Prepare the storage
drive from the Beginners' Guide.

If you're on Windows, install Ext2Fsd to be able to mount it.

> Transfer the system

From the virtual machine, open a terminal and transfer the system:

    # rsync -aAXv /* /path/to/shared/folder --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/home/*/.gvfs}

> Chroot and reinstall the bootloader

Boot a "live" Linux distribution, mount the root partition and chroot
into it:

    # mount /dev/sdb2 /mnt
    # arch-chroot /mnt

Reinstall either Syslinux or GRUB, using the instructions from the
Beginners' Guide. Don't forget to update the configuration file (i.e.
syslinux.cfg or grub.cfg).

> Adjust the fstab

Since your entire root tree has been transferred to a single partition,
edit the fstab file to reflect the right partition(s):

    # nano /etc/fstab

Check with the blkid command, since lsblk is not very useful inside a
chroot.

> Re-generate the initramfs image

Because the hardware has changed, while you're still in the chroot,
re-generate the initramfs image:

    # mkinitcpio -p linux 

And that's about it.

You'll most likely need to set up the network, since the virtual machine
was probably piggybacking on the host OS's network settings. See
Configure the network from the Beginners' Guide.

Moving into a VM
----------------

Moving into a virtual environment takes a little more effort.

> Create the container

This will create a 10 GB raw image:

    # dd if=/dev/zero of=/media/Backup/backup.img bs=1024 count=10482381

If you want to create one the exact size of your root partition, run
fdisk -l and use the value from the Blocks column. Note that you will
transfer you entire root tree, so that includes the /boot and /home
folders. If you have any separate partitions for those, you need to take
them into account when creating the container.

Now load the necessary module and mount it as a loopback device, on
/dev/loop5 (for example):

    # modprobe loop
    # losetup /dev/loop5 /media/Backup/backup.img

Install gparted and slap a partition table on it (e.g. "msdos") and a
filesystem (e.g. "ext4"):

    # pacman -S gparted
    # gparted /dev/loop5

Tip:If you want, you can add however many partitions you want: home,
boot, var, tmp, whatever floats your boat. Of course, it will add a
layer of complexity, but it's doable. The point is that you don't
necessarily need another container.

> Transfer the system

Mount the loopback device and transfer the system:

Note:If the container was saved somewhere other than /mnt or /media,
don't forget to add it to the exclude list.

    # mkdir /mnt/Virtual
    # mount /dev/loop5p1 /mnt/Virtual
    # rsync -aAXv /* /mnt/Virtual --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/home/*/.gvfs}

> Convert the container to a compatible format

Change directory to where the loopback file is located and choose the
appropriate command for your virtual machine:

    $ cd /media/Backup
    $ qemu-img convert -c -f raw -O qcow backup.img backup.qcow2
    $ VBoxManage convertfromraw --format VDI backup.img backup.vdi
    $ VBoxManage convertfromraw --format VMDK backup.img backup.vmdk

> Chroot and reinstall the bootloader

Hook up the converted file from above, and the latest Arch Linux ISO
into the virtual CD-ROM. Then start the virtual machine and chroot into
it:

    # mount /dev/sda1 /mnt
    # arch-chroot /mnt

Reinstall either Syslinux or GRUB, using the instructions from the
Beginners' Guide. Don't forget to update its configuration file:

-   For Syslinux, it should be APPEND root=/dev/sda1 ro in syslinux.cfg.

-   For GRUB, it's recommended that you automatically re-generate a
    grub.cfg.

> Adjust the fstab

Since your entire root tree has been transferred to a single partition,
edit the fstab file. You may use the UUID or label if you want, but
those are more useful in multi-drive, multi-partition configurations (to
avoid confusions). For now, /dev/sda1 for your entire system is just
fine.

    # nano /etc/fstab

    tmpfs                    /tmp      tmpfs     nodev,nosuid          0   0
    /dev/sda1                /         ext4      defaults,noatime      0   1

> Disable any Xorg-related files

Having an nvidia, nouveau, radeon, intel, etc., entry in the Device
section from one of the Xorg configuration files will prevent it from
starting, since you will be using emulated hardware (including the video
card). So it's recommended that you move/rename or delete the following:

    # mv /etc/X11/xorg.conf /etc/X11/xorg.conf.bak
    # mv /etc/X11/xorg.conf.d/10-monitor /etc/X11/xorg.conf.d/10-monitor.bak

> Re-generate the initramfs image

Because the hardware has changed, while you're still in the chroot,
re-generate the initramfs image and do a proper shutdown:

    # mkinitcpio -p linux
    # poweroff

Finally, pull out the LiveCD (the ISO file) and start the virtual
machine.

Note:At this point you may notice that you no longer have a wallpaper.
Don't worry about it. It's most likely because it is located on a
different partition mounted in /media or /mnt, folders which were
excluded from the transfer.

Enjoy your new virtual environment.

Troubleshoot
------------

> "mount: special device /dev/loop5p1 does not exist"

First, check the loopback device with fdisk for the starting block:

    # fdisk -l /dev/loop5

    Disk /dev/loop5: 10.7 GB, 10733958144 bytes
    255 heads, 63 sectors/track, 1304 cylinders, total 20964762 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x000b45e8

          Device Boot      Start         End      Blocks   Id  System
    /dev/loop5p1   *        2048    20963327    10480640   83  Linux

Then use it as an offset when mounting it:

    # mount -o offset=$((2048 * 512)) /dev/loop5 /mnt/Virtual/

> "Waiting 10 seconds for device /dev/sda1; ERROR: Unable to find root device '/dev/sda1'"

    Waiting 10 seconds for device /dev/sda1 ...
    ERROR: Unable to find root device '/dev/sda1'.
    You are being dropped to a recovery shell
        Type 'exit' to try and continue booting
    sh: can't access tty; job control turned off
    [rootfs /]# _

It most likely means that you didn't run poweroff like you were
instructed to, and closed the VM with the "close" button, which is the
equivalent of a power outage. Now you need to regenerate your initramfs
image. To do that, you can start the VM using the Fallback entry. If you
don't have a Fallback entry, press Tab (for Syslinux) or e (for GRUB)
and rename it initramfs-linux-fallback.img. After it boots, open up a
terminal and run:

    # mkinitcpio -p linux
    # poweroff

> "Missing operating system. FATAL: INT18: BOOT FAILURE"

You will need to install (reinstall) a bootloader. See the instructions
from the Beginners' Guide.

Also, check the boot order from the BIOS or from the VM's settings and
make sure that the drive containing the bootloader is the first to boot.

> I'm asked for the root password, for maintenance

    :: Checking Filesystems                        [BUSY]
    fsck.ext4: Unable to resolve '...'

This means that you forgot to add the drive's UUID, label or device name
in /etc/fstab. The UUID is different every time you format it (or in
this case, create one from scratch), and they likely do not match. Check
with blkid.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Moving_an_existing_install_into_(or_out_of)_a_virtual_machine&oldid=229506"

Categories:

-   Getting and installing Arch
-   Virtualization
