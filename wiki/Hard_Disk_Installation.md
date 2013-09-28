Hard Disk Installation
======================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page will document how to install arch from another hard disk on
your computer. This allows you to use a swap partition for the
installation, rather than optical media. It may also be useful for
remote installations.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Download the Installation Media                                    |
| -   2 Disable Swap Partition                                             |
| -   3 Determine Where the Installation Filesystem Is                     |
| -   4 Rewrite your Partition Table                                       |
| -   5 Copy the Installation Filesystem                                   |
| -   6 Install Grub to Partition's Boot Sector                            |
| -   7 Chainload Grub from your Existing Bootloader                       |
| -   8 Reboot and Install                                                 |
+--------------------------------------------------------------------------+

Download the Installation Media
-------------------------------

Choose a installation mode (core, ftp) and download the USB variant. We
will not need to modify the installation media. Please choose the most
recent version. At the time of writing, I performed:

     curl -O ftp://mirror.cs.vt.edu/pub/ArchLinux/iso/2008.06/archlinux-2008.06-core-i686.img

  

Disable Swap Partition
----------------------

Before we begin, disable your swap partition (in my case, /dev/sda2.)
Comment out the corresponding line in your /etc/fstab. This will keep
your new current system from trying to mount the installation media as
swap (if you reboot the system before installling arch.)

     swapoff /dev/sda2

Determine Where the Installation Filesystem Is
----------------------------------------------

The USB media contain a standard PC partition map. We're only interested
in the partition inside the USB media containing the installation
filesystem. Use fdisk to examine the partition map, and determine the
starting location of the partition, and its filetype (which may change
in later versions of Arch, I suppose.)

     $ fdisk archlinux-2008.06-core-i686.img 
     You must set cylinders.
     You can do this from the extra functions menu.

It's safe to ignore this. Now change the displayed units to 512 byte
sectors.

     Command (m for help): u
     Changing display/entry units to sectors

Now print the partition table.

     Command (m for help): p
     
     Disk archlinux-2008.06-core-i686.img: 0 MB, 0 bytes
     53 heads, 12 sectors/track, 0 cylinders, total 0 sectors
     Units = sectors of 1 * 512 = 512 bytes
     Disk identifier: 0x00000000
     
                               Device Boot      Start         End      Blocks   Id  System
     archlinux-2008.06-core-i686.img1   *          63      629822      314880   83  Linux
     Partition 1 has different physical/logical beginnings (non-Linux?):
          phys=(0, 1, 1) logical=(0, 5, 4)
     Partition 1 has different physical/logical endings:
          phys=(39, 52, 12) logical=(990, 15, 3)

Take specific note of two things. The first is the starting location of
the partition (63 in this case.) The second is the system type (Linux).
You can now exit fdisk.

     Command (m for help): q

Rewrite your Partition Table
----------------------------

Now modify the partition table on your hard disk. I won't provide an
example of this, all you need to do is change the system type (using the
t command of fdisk) if it is different than what was noted above.

Copy the Installation Filesystem
--------------------------------

Now we can copy the installation system over to the partition. We'll use
the dd command for this. Use the start of the partition (in units of 512
bytes) that you noted above as the argument to skip

     # dd if=archlinux-2008.06-core-i686.img of=/dev/sda2 bs=512 skip=63
     629760+0 records in
     629760+0 records out
     322437120 bytes (322 MB) copied, 19.86 s, 16.2 MB/s

Use fsck to make sure we didn't mangle the copy:

     # fsck -f /dev/sda2fsck 1.40.8 (13-Mar-2008)
     e2fsck 1.40.8 (13-Mar-2008)
     Pass 1: Checking inodes, blocks, and sizes
     Pass 2: Checking directory structure
     Pass 3: Checking directory connectivity
     Pass 3A: Optimizing directories
     Pass 4: Checking reference counts
     Pass 5: Checking group summary information
     
     /dev/sda2: ***** FILE SYSTEM WAS MODIFIED *****
     /dev/sda2: 243/78936 files (8.2% non-contiguous), 310519/314880 blocks

If this is successful, you can move on.

Install Grub to Partition's Boot Sector
---------------------------------------

I'm going to assume you're using grub. We'll install grub to the boot
sector of the partition, then chain load the arch installation system.
Here's how this works. Note that you need to use the grub device path
corresponding to the partition, ie, the one you'd use in menu.lst.

     # grub
     
         GNU GRUB  version 0.97  (640K lower / 3072K upper memory)
     
      [ Minimal BASH-like line editing is supported.  For the first word, TAB
        lists possible command completions.  Anywhere else TAB lists the possible
        completions of a device/filename. ]
     
     grub> root (hd0,1)
      Filesystem type is ext2fs, partition type 0x83
     
     grub> setup (hd0,1)
      Checking if "/boot/grub/stage1" exists... yes
      Checking if "/boot/grub/stage2" exists... yes
      Checking if "/boot/grub/e2fs_stage1_5" exists... yes
      Running "embed /boot/grub/e2fs_stage1_5 (hd0,1)"... failed (this is not fatal)
      Running "embed /boot/grub/e2fs_stage1_5 (hd0,1)"... failed (this is not fatal)
      Running "install /boot/grub/stage1 (hd0,1) /boot/grub/stage2 p /boot/grub/menu
     .lst "... succeeded
     Done.
     
     grub> quit

Chainload Grub from your Existing Bootloader
--------------------------------------------

Add a section like this to /boot/grub/menu.lst. Again, replace (hd0,1)
with whatever is appropriate:

     title ArchLinux Installation System
     root (hd0,1)
     makeactive
     chainloader +1

Reboot and Install
------------------

Now you're ready to install arch. Reboot arch, select the ArchLinux
Installation System you enabled, and you should be presented with the
Arch Installation Bootmenu, just as if you'd booted off CD or USB.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hard_Disk_Installation&oldid=206168"

Category:

-   Getting and installing Arch
