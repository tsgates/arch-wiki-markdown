Dual boot with Windows when SafeBoot is installed
=================================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This is a discussion about how to create a dual boot setup with Windows
when whole disk SafeBoot (now called McAfee Endpoint Encryption)
encryption is employed. This may be the case particularly if one is
issued a company laptop that comes pre-installed with Windows and is
encrypted. While one can wipe the drive and install a) Linux alone or b)
Linux and an unencrypted version of Windows, some sacrifices and risks
may exist. For example, company patches and updates may no longer work
properly, IT policies may be violated, data is no longer protected, and,
if Linux alone is installed, the capability to share files, access
company specific intranet applets, and other limitations may be
experienced.

This article will explain one method for creating a dual boot setup
while leaving the company-installed encryption and operating system
intact and fully functional.

Note:This author only has experience with Windows 7 and an account
created in the Administrator group. It is unknown whether this works
with other versions of Windows or with reduced user privileges.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Why is a solution needed?                                          |
| -   2 Alternatives Considered                                            |
| -   3 The Method Proposed                                                |
| -   4 Step by Step Walkthrough                                           |
|     -   4.1 Defragment the Windows Partition                             |
|     -   4.2 Shrink the Windows Partition                                 |
|     -   4.3 Edit the Partition Table                                     |
|     -   4.4 Add an Option to Boot Linux                                  |
|     -   4.5 Backup the SafeBoot MBR                                      |
|     -   4.6 Install Linux                                                |
|     -   4.7 Test Configuration                                           |
|     -   4.8 Create a Shared TrueCrypt Volume                             |
|                                                                          |
| -   5 Summary                                                            |
| -   6 Troubleshooting                                                    |
| -   7 Additional Resources                                               |
+--------------------------------------------------------------------------+

Why is a solution needed?
-------------------------

The situation of a fully encrypted system is a difficult one because
even the MBR is encrypted and SafeBoot uses its encrypted bootloader to
load the real partition table and load Windows. Thus, if one attempts to
simply partition the disk with [c]fdisk, writing the partition table
will render one's system unbootable. Likewise, even if there is a free
partition, a) one isn't able to update the partition table with the
correct type (which is necessary), b) one can't install the bootloader
(e.g. grub) to the MBR, and c) even if one installs the bootloader to
the partition instead of the MBR, there is no way to make the system
aware that such a bootloader exists via the partition table. It is quite
a difficult situation to work with.

Some are content with using live distributions or running Linux from a
flash drive; the primary author of this article found such methods
frustrating and limiting. There is also quite a lot of discussion about
how to get around this situation, [1] [2] [3] and thus an article seemed
relevant after a firsthand experience and success.

Alternatives Considered
-----------------------

The primary author of this article has experience with only one
successful method, but considered several, including:

-   Trying to create a "live clone" (full system backup while Windows
    was running) in order to possess a decrypted copy of the OS, wiping
    the drive, and then reinstalling the OS to a partition encrypted
    with an opensource encryption system. This may prevent company
    patches from operating successfully and may violate policies if a
    company mandates a particular encryption method.
-   Trying to use dd to simply block-copy everything from one disk onto
    an external drive, wipe the internal drive and re-partition, and
    then dd the external drive back to the internal, and dd a backup of
    the SafeBoot MBR back to the internal drive. This seems a bit risky,
    and also requires that one have another hard drive at least as big
    as the original encrypted partition.
-   While not really a solution in the dual-boot category, simply
    running Linux inside of a virtualization program is a perfectly
    reasonable solution. It is by far the simplest. The primary author
    simply doesn't like the idea and wanted a fully dual-boot setup,
    however he does have VirtualBox setup in Windows to avoid excessive
    reboots if Windows usage is needed heavily for any particular task.

The Method Proposed
-------------------

In brief, the successful setup used by this author is as follows:

-   Use Windows 7 build in partition editor to partition the drive
    -   Partition 1: Windows
    -   Partition 2: Linux /boot
    -   Partition 3: Linux /
    -   Partition 4: TrueCrypt device for shared files

-   Use Partition Wizard HomeEdition to tweak some things
-   Use EasyBCD to add an entry for Arch Linux at boot time
-   Install Arch using System_Encryption_with_LUKS
-   Configure grub
-   Reboot and hold breath
-   Install TrueCrypt on both OSs and create a TrueCrypt volume

Step by Step Walkthrough
------------------------

> Defragment the Windows Partition

If the issued computer is encrypted with SafeBoot, it will likely
contain one primary partition where Windows is installed. We need to
shrink this partition in order to make space for Linux. To shrink this
partition as much as possible, defragmenting is helpful. Windows 7 comes
with a built in defragmenting utility, available through the control
panel. Open this program and defrag on the primary drive (probably
called C:\). Do this several times, if desired.

It may be helpful to use an additional program as well. Wikipedia has a
list of various options HERE. The author of this article used Auslogics
Disk Defrag, which worked well and had the ability to view what specific
files were unmovable. Such files will hinder the minimum size possible
to shrink the volume in the next step.

-   Screenshot of Auslogic Disk Defrag HERE
-   Screenshot showing an unmovable file related to SafeBoot HERE (click
    any gray, unmovable square to see details)

For some other options for maximizing the amount one can shrink a
Windows partition, see the article HERE. While it is written for Windows
Vista, it contains some applicable suggestions for Windows 7 as well.
The author of this article disabled system restore temporarily and was
able to shrink the partition another 6 GB.

Note: After shrinking the partition in the next step, you should undo
any system-critical adjustments you made during this step. In other
words, re-enable system recovery, paging file, etc.

> Shrink the Windows Partition

Once defragmenting is complete, open the control panel and either search
for "partition" or navigate to System and Security > Administrative
Tools > Create and Format Hard Disk Partitions. This will open Windows
7's built-in partition editor as shown HERE. Right click on the Windows
7 partition and choose "Shrink Volume." This will open a dialog
prompting you for the amount you want to shrink the volume. The dialog
will also inform you of the maximum amount possible to shrink the
volume. Shrink the volume by the desired size, or, if unmovable files
prevent you from shrinking it as much as you'd like, just shrink it as
much as possible. For a more picture-filled walkthrough, see this
article

When this step completes, the Windows partition will be smaller and the
rest of the partition will be denoted as "Unallocated space." Right
click the unallocated section and choose "New Simple Volume." Windows
will walk you through the steps necessary to create a new volume. Repeat
these steps for the desired number of partitions. On possible setup
would be like so:

-   Windows 7 (C:\): size will be whatever it was set to in this step
-   Linux boot: 64 MB. This is necessary if one wants an encrypted Linux
    partition
-   Linux \: If only the OS will be installed to this partition, perhaps
    make it ~30-50GB depending on your application needs
-   TrueCrypt partition: for shared files between Windows and Linux.
    Make it take the rest of the unallocated space.

For each of these drives, the format doesn't really matter because
they'll all be reformatted. Choose FAT or NTFS and let Windows create
the volumes. For a walkthrough on adding volumes from unallocated space,
see this article.

Note: if the fourth partition added is surrounded by green and denoted
as an extended partition, do not worry. Windows 7 does this
automatically and we will fix it in the next step.

> Edit the Partition Table

It is now necessary to edit the partition table so that it shows the
Linux partitions as actual Linux partitions rather than FAT or NTFS
(whatever was created in the last step). Since we can't use fdisk to
write the partition table, we'll use a tool in Windows itself. This
author used MiniTool Partition Wizard Home Edition, a free partition
tool recommended highly by CNET. Open the program and right click on a
partition that will contain a Linux filesystem. Choose "Change partition
type ID" from the drop down menu. Choose the manual ID entry option and
set the type to 0x83, as shown HERE. Repeat this with any other
partitions that will be formatted with Linux filesystems. For a
walkthrough on this step, see this article.

Lastly, if a fourth partition was created in the previous step, click
it, and then go to the Disk menu and choose "Convert dynamic disk to
basic disk." This will change the extended partition to a simple one.
For a walkthrough on this, see this article.

When finished, click the "Apply" button in the upper left of the main
window.

> Add an Option to Boot Linux

Next, we're going to add a Linux option to the Windows boot options
using a free program called EasyBCD. Theoretically, this should be
possible using Windows 7's built in program, bcdedit, as shown HERE. The
author had difficulty attempting this due to privilege errors, and was
successful with EasyBCD and thus never retried with bcdedit. Open
EasyBCD and click "Add New Entry" on the left. Choose the Linux/BSD tab
and set the bootloader type (Grub (legacy)) for Arch and partition. Make
sure that if you are going to have a dedicated boot partition that you
point EasyBCD to that partition, not the one that will contain the root
filesystem. A screenshot of these settings may be found HERE.

Next view the entry by clicking "View Settings," and make sure
everything looks appropriate. For a legacy grub setting pointing toward
the second partition on the disk, the boot entry should look like THIS.

> Backup the SafeBoot MBR

Note: It is highly recommended that one make a backup of the SafeBoot
MBR before proceeding. If anything accidentally happens to it, you can
restore it and will have a functioning system. Without a backup, if you
use [c]fdisk and write the partition table to the MBR, or install Grub
to the MBR, you will lose the ability to ever, ever, ever get back to
your Windows installation.

To back up the SafeBoot MBR, boot into a live Linux CD and have a flash
drive inserted:

    # mount /dev/sdb1 /mnt (or whatever the desired flash drive address is)
    # dd if=/dev/sda of=/mnt/safeboot.mbr bs=512 count=1
    # umount /dev/sdb1

If anything happens while installing Arch and you wipe the SafeBoot MBR,
you can restore it by reversing the process. Again, boot into a Live CD
and insert the flash drive:

    # mount /dev/sdb1 /mnt
    # dd if=/mnt/safeboot.mbr of=/dev/sda bs=512 count=1
    # umount /dev/sdb1

Now reboot and things should be as they were.

> Install Linux

With all of these steps completed, reboot into an Arch Install CD. See
the Official_Arch_Linux_Install_Guide if you are unsure about how to
install Arch. For an encrypted system, follow the directions covered
aptly at System_Encryption_with_LUKS. Regardless of what method you use
for installation, do not install the bootloader to the MBR. Once you
finish installing and configuring files, follow these steps:

-   Mount your boot partition if it's not already mounted

-   -   If you installed manually or know you do not have a filesystem
        on your boot partition yet, make one

    # mkfs.ext2 /dev/sda2

-   -   Then mount the partition

    # mount /dev/sda2 /mnt/boot

-   Verify that grub files are present

    # ls /mnt/boot/grub/

-   -   If files like stage1 and the like are present, proceed
    -   If not, make the directory /mnt/boot/grub (if necessary) and
        copy the necessary files to the grub folder

    # mkdir /mnt/boot/grub
    # cp -a /usr/lib/grub/i386-pc/* /mnt/boot/grub/

-   Get ready to chroot into the installed system

    # mount -t proc /proc /mnt/proc
    # mount -t sysfs /sys /mnt/sys
    # mount -o bind /dev /mnt/dev

-   Chroot into /mnt

    # chroot /mnt

-   Now run grub

    # grub
    # root (hd0,1)
    # setup (hd0,1)

Note: The above example assumes that /boot is on /dev/sda2, which is the
second partition on the drive. Since grub starts from 0, this
corresponds to (hd0, 1) or first disk (hd0), second partition (,1). See
the GRUB article for more information.

-   Depending on the process you took, it's not a bad idea to re-install
    the kernel26 package if /boot wans't properly mounted during the
    installation of the base package. Sync pacman from the chroot
    environment and then reinstall the kernel26 package:

    # pacman -Sy
    # pacman -S kernel26

-   If using system encryption, be sure to add encrypt to
    /etc/mkinitcpio and regenerate the initramfs with

    # mkinitcpio

See System_Encryption_with_LUKS#Configure_System for more details.

-   Finally, if /boot/grub/menu.lst does not exist, copy and edit it:

    # exit (get out of the chroot)
    # cp /boot/grub/menu.lst /mnt/boot/grub/
    # nano /mnt/boot/grub/menu.lst

Edit the entry according to GRUB#Dual_booting_with_GNU.2FLinux (don't
forget to add the required extra options if using an encrypted system.
See System_Encryption_with_LUKS#Install_Bootloader for more details).

> Test Configuration

When satisfied, exit the installer and reboot. Be sure to press any
necessary keys to tell the computer to boot from the hard drive if the
Arch CD is still in the optical bay; many computers default to booting
from media, if present. Windows should now present you with an option to
boot either Windows or Linux. Select Linux. If all goes well, you should
see the grub boot menu and can select your new installation of Arch to
boot. If you get a grub prompt, do not fret: you may still be able to
boot. Try entering the grub commands manually:

    grub > root (hd0,1)
    grub > kernel /vmlinuz26 root=/dev/mapper/map-name cryptdevice=/dev/sda3:map-name ro
    grub > initrd /kernel26.img
    grub > boot

It this works, then the issue exists in the EasyBCD entry we made
earlier. If it doesn't grub may not have been installed to the right
location.

> Create a Shared TrueCrypt Volume

Once your Arch system is setup as desired, TrueCrypt may be used to
create a shared device or file for sharing files between Windows and
Linux. See the TrueCrypt article for details. This author created a
TrueCrypt volume from Arch, formatted to FAT and then re-formatted to
NTFS. Following using the GUI to create the volume, these steps were
taken:

    $ sudo pacman -S ntfs-3g ntfsprogs
    $ sudo truecrypt --filesystem=none --slot=1 /dev/sda4
    $ sudo mkfs.ntfs /dev/mapper/truecrypt1

After this process completes, /dev/mapper/truecrypt1 will be properly
formatted and can be mounted to a mountpoint for use:

    $ sudo mount /dev/mapper/truecrypt1 /mnt

NTFS does not use Linux permissions and attributes, so it may be helpful
to pass options like the following:

    $ sudo mount -o ntfs-3g uid=1000,gid=100,fmask=113,noatime /dev/mapper/truecrypt1 /mnt

See NTFS-3G for more information.

Note:TrueCrypt includes its own ability to both map and mount an
encrypted file or device in one step, however as of version 7.0a
(current Arch version as of 4/19/2011), some have reported problems with
NTFS formatted devices and mounting. This author has found that the
two-step process outlined above (first, using
truecrypt --filesystem=none --slot=1 /dev/sda4, and then the system's
mount command, mount /dev/mapper/truecrypt1 /mnt) works reliably. A bug
report exists HERE and contains a post by this author with more detail.

Finally, reboot into Windows, install TrueCrypt, and attempt to mount
the device. Once verified that both OSs can mount the volume, begin
adding any files that one desires to share between OSs.

  

Summary
-------

If all of the above goes smoothly, one should have a dual-booting, fully
encrypted system (if Linux was installed using the LUKS/dm-crypt method)
with the exception of a Linu /boot partition. In addition, both Window
and Linux can share files via the TrueCrypt volume. The process seems to
be advantageous to other methods in that it does not require juggling of
the SafeBoot mbr, using dd or other tools to clone the drive and then
clone it back after partitioning, does not require extra external hard
drives for such cloning, leaves any company-installed components alone
(with the exception of shrinking their footprint), and yet maintains a
high level of system security.

Troubleshooting
---------------

-   If one encounters a grub shell but can boot if manually entering the
    proper commands, reboot into Windows and verify the EasyBCD settings
    mentioned above. Verify that the bootloader type was correct (grub
    legacy vs. grub2 vs. others) and that the drive was correct. The
    drive chosen should be that containing Linux /boot, not the main
    Linux OS root partition.
-   Do not attempt to install grub to the root Linux partition, as this
    will wipe the LUKS/dm-crypt header and render the partition unusable
    unless you have a backup of the header. In other words, be very
    careful when issuing the command grub > setup (hd0,X) and make sure
    that X is the boot partition, not the encrypted root partition.
-   If trying to install grub and one sees an error about an unknown
    filesystem or partition type and the code 0x7, you've either pointed
    grub to the wrong place (wrong partition number), or did not
    successfully change the partition type ID. 0x7 is the identifier for
    NTFS. Reboot back into Windows, open the Partition Wizard discussed
    above, and manually change the type to 0x83. Then reboot and attempt
    to install grub again. After issuing grub > root (hd0,1), grub
    should report back Filesystem type is ext2fs, partition type 0x83.
    This is what you want.

Additional Resources
--------------------

[1] http://ubuntuforums.org/showthread.php?t=1039401

[2] http://blog.nixpanic.net/2008/06/starting-safeboot-with-grub.html

[3]
http://mbrfde.blogspot.com/2008/11/dual-boot-ubuntu-with-safeboot-fde_19.html

-   Tools
    -   MiniTool Partition Wizard Home Edition
    -   Auslogic Disk Defragmenter
    -   NeoSmart EasyBCD

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dual_boot_with_Windows_when_SafeBoot_is_installed&oldid=207066"

Categories:

-   Security
-   File systems
-   Boot process
