Convert a single drive system to RAID
=====================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: grub-legacy is   
                           unsupported; 0.9         
                           superblocks and MBR      
                           partitioning are also    
                           therefore non-useful     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

You already have a fully functional system setup on a single drive, but
you would like to add some redundancy to the setup by using RAID-1 to
mirror your data across 2 drives. This guide follows the following steps
to make the required changes, without losing data.

-   Create a single-disk RAID-1 array with our new disk
-   Move all your data from the old-disk to the new RAID-1 array
-   Verify the data move was successful
-   Wipe the old disk and add it to the new RAID-1 array

Warning: Make a backup first. Even though our aim is to convert to a
RAID setup without losing data, there's no guarantees the process will
be perfect, and there is a high risk of accidents happening.

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Assumptions                                                        |
| -   2 Create new RAID array                                              |
|     -   2.1 Partition the Disk                                           |
|     -   2.2 Create the RAID device                                       |
|     -   2.3 Make file systems                                            |
|                                                                          |
| -   3 Copy data                                                          |
|     -   3.1 Mount the array                                              |
|     -   3.2 Copy the data                                                |
|     -   3.3 Update GRUB legacy                                           |
|     -   3.4 Update Grub2                                                 |
|     -   3.5 Alter fstab                                                  |
|     -   3.6 Rebuild initcpio or initramfs                                |
|         -   3.6.1 First chroot into the RAID system                      |
|         -   3.6.2 Record mdadm's config                                  |
|         -   3.6.3 For Arch Linux: Rebuild initcpio                       |
|         -   3.6.4 For Ubuntu or Debian: Rebuild initramfs                |
|                                                                          |
|     -   3.7 Install GRUB on the RAID array                               |
|                                                                          |
| -   4 Verify success                                                     |
| -   5 Add original disk to array                                         |
|     -   5.1 Partition original disk                                      |
|         -   5.1.1 Note                                                   |
|                                                                          |
|     -   5.2 Add disk partition to array                                  |
|     -   5.3 Add second swap partition                                    |
|     -   5.4 Verify that email alerts are working                         |
|                                                                          |
| -   6 Automatic conversion tool alternative - Raider                     |
+--------------------------------------------------------------------------+

Assumptions
-----------

-   I will assume for the sake of the guide that the disk currently in
    your system is /dev/sda and your new disk is /dev/sdb.
-   We will create the following configuration:
    -   1 x RAID-1 array for the file-system (using 2 x partitions, 1 on
        each disk)
    -   2 x Swap Partitions using 1 partition on each disk.

The swap partitions will not be in a RAID array as having swap on RAID
serves no purpose. Refer to this article for reasons why.

-   To minimize the risk of Data on Disk (DoD) changing in the middle of
    our changes, I suggest you drop to single user mode before you start
    by using the telinit 1 command.

-   You will need to be the root user for the entire process.

Create new RAID array
---------------------

First we need to create a single-disk RAID array using the new disk.

> Partition the Disk

Use fdisk or your partitioning program of choice to setup 2 primary
partitions on your new disk. Make the swap partition half the size of
the total swap you want (the other half will go on the other disk).

Drop to single user mode:

    telinit 1

To see the current partitions:

    fdisk -l

To partition the new disk

    fdisk /dev/sdb

Then the fdisk commands to partition the new disk. Note that everything
after the "#" is an explanation of what the command is doing:

Note:Make sure to enable the bootable flag to avoid fatal boot failure /
missing operating system errors on legacy BIOS systems. gdisk (GPT) can
do it too via its 'x' menu for extra functionality -> 'a' to set
attributes -> partition# -> '2': legacy BIOS bootable.

    c # Turn off DOS compatibility (optional).
    n # new
    p # primary
    1 # first partition
    1 # start at first cylinder
    101 # end cylinder, 0.1% of the disk. Note: update this number as appropriate for your disk.
    n # new
    p # primary
    2 # second partition
    press enter # Uses the default start from the end of the first partition
    press enter # Uses the default of using all the remain space on the disk.
    t # set the partition type
    1 # for partition number 1
    82 # ... and set it to be swap
    t # set the partition type
    2 # for partition number 2 ...
    fd # ... and set it to be "linux raid auto"
    a # Toggle the bootable flag to be "on"
    2 # for partition number 2.
    p # print what the partition table will look like
    w # now write all of the above changes to disk

At the end of partitioning, your partitions should look something like
this:

    [root@arch ~]# fdisk -l /dev/sdb
    Disk /dev/sdb: 80.0 GB, 80025280000 bytes
    255 heads, 63 sectors/track, 9729 cylinders
    Units = cylinders of 16065 * 512 = 8225280 bytes
    Disk identifier: 0x00000000

       Device Boot      Start         End      Blocks   Id  System
    /dev/sdb1               1          66      530113+  82  Linux swap / Solaris
    /dev/sdb2              67        9729    77618047+  fd  Linux raid autodetect

Make sure your your partition types are set correctly. "Linux Swap" is
type 82 and "Linux raid autodetect" is type FD.

> Create the RAID device

Next, create the single-disk RAID-1 array. Note the "missing" keyword is
specified as one of our devices. We are going to fill this missing
device later.

    [root@arch ~]# mdadm --create /dev/md0 --level=1 --raid-devices=2 missing /dev/sdb2
    mdadm: array /dev/md0 started.

Note: If the above command causes mdadm to say "no such device
/dev/sdb2", then reboot, and run the command again.

If you want to use Grub 0.97 (default in the Arch Linux 2010.05 release)
on RAID 1, you need to specify an older version of metadata than the
default. Add the option "--metadata=0.90" to the above command.
Otherwise Grub will respond with "Filesystem type unknown, partition
type 0xfd" and refuse to install. This is supposedly not necessary with
Grub 2.

    [root@arch ~]# mdadm --create /dev/md0 --metadata=0.90 --level=1 --raid-devices=2 missing /dev/sdb2
    mdadm: array /dev/md0 started.

If you want to use Syslinux, you need to specify --metadata=1.0 (for the
boot partition) as of Sept. 2011

Make sure the array has been created correctly by checking /proc/mdstat:

    [root@arch ~]# cat /proc/mdstat
    Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6] [raid10]
    md0 : active raid1 sdb2[1]
         40064 blocks [2/1] [_U]

    unused devices: <none>

The devices are intact, however in a degraded state. (Because it's
missing half the array!)

> Make file systems

Use the file system of your preference here. I'll use ext3 for this
guide.

    [root@arch ~]# mkfs -t ext3 -j -L RAID-ONE /dev/md0
    mke2fs 1.38 (30-Jun-2005)
    Filesystem label=
    OS type: Linux
    Block size=4096 (log=2)
    Fragment size=4096 (log=2)
    10027008 inodes, 20027008 blocks
    1001350 blocks (5.00%) reserved for the super user
    First data block=0
    612 block groups
    32768 blocks per group, 32768 fragments per group
    16384 inodes per group
    Superblock backups stored on blocks:
            32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
            4096000, 7962624, 11239424

    Writing inode tables: done
    Creating journal (32768 blocks): done
    Writing superblocks and filesystem accounting information: done

    This filesystem will be automatically checked every 25 mounts or
    180 days, whichever comes first.  Use tune2fs -c or -i to override.

Make a file system on the swap partition:

    [root@arch ~]# mkswap -L NEW-SWAP /dev/sdb1
    Setting up swapspace version 1, size = 271314 kB
    LABEL=NEW-SWAP, UUID=9d746813-2d6b-4706-a56a-ecfd108f3fe9

Copy data
---------

The new RAID-1 array is ready to start accepting data! So now we need to
mount the array, and copy everything from the old system to the new
system

> Mount the array

    [root@arch ~]# mkdir /mnt/new-raid
    [root@arch ~]# mount /dev/md0 /mnt/new-raid

> Copy the data

    [root@arch ~]# rsync -avxHAXS --delete --progress / /mnt/new-raid

Note that by using the -x option you are limiting rsync to a single file
system. If you have a more traditional file system layout, with
different partitions for /boot, /home, and perhaps others, you will need
to rsync those file systems separately. For example:

    [root@arch ~]# rsync -avxHAXS --delete --progress /boot /mnt/new-raid/boot
    [root@arch ~]# rsync -avxHAXS --delete --progress /home /mnt/new-raid/home

Alternatively, you can use tar instead of the above rsync command if you
prefer. rsync will, however, be quicker if you are only copying over
changes. The tar command is: tar -C / -clspf - . | tar -xlspvf -

> Update GRUB legacy

Use your preferred text editor to open /mnt/new-raid/boot/grub/menu.lst.

    --- SNIP ---
    default   0
    color light-blue/black light-cyan/blue

    ## fallback
    fallback 1

    # (0) Arch Linux
    title  Arch Linux - Original Disc
    root   (hd0,0)
    kernel /vmlinuz-linux root=/dev/sda1

    # (1) Arch Linux
    title  Arch Linux - New RAID
    root   (hd1,0)
    #kernel /vmlinuz-linux root=/dev/sda1 ro
    kernel /vmlinuz-linux root=/dev/md0 md=0,/dev/sda2,/dev/sdb2
    --- SNIP ---

Notice we added the fallback line and duplicated the Arch Linux entry
with a different root directive on the kernel line.

Also update the "kopt" and "groot" sections, as shown below, if they are
in your /mnt/new-raid/boot/grub/menu.lst file, because it will make
applying distribution kernel updates easier:

    - # kopt=root=UUID=fbafab1a-18f5-4bb9-9e66-a71c1b00977e ro
    + # kopt=root=/dev/md0 ro md=0,/dev/sda2,/dev/sdb2

    ## default grub root device
    ## e.g. groot=(hd0,0)
    - # groot=(hd0,0)
    + # groot=(hd0,1)

> Update Grub2

Please refer to https://wiki.archlinux.org/index.php/GRUB2#Other_Options

> Alter fstab

You need to tell fstab on the new disk where to find the new devices.
It's better to use UUID codes here, which should not change, even if our
partition detection order changes or a drive gets removed.

To find the UUID to use:

    [root@arch ~]# blkid
    /dev/sda1: TYPE="swap" UUID="34656682b-34ad-8ed5-9233-dfab42272212" 
    /dev/sdb1: UUID="9ff5682b-d5a1-4ed5-8d63-d1df911e0142" TYPE="swap" LABEL="NEW-SWAP" 
    /dev/md0: UUID="6f2ea3d3-d7be-4c9d-adfa-dbeeedaf128e" SEC_TYPE="ext2" TYPE="ext3" LABEL="RAID-ONE" 
    /dev/sda2: UUID="13dd2227-6592-403b-931a-7f3e14a23e1f" TYPE="ext2" 
    /dev/sdb2: UUID="b28813e7-15fc-d4aa-dc8a-e2c1de641df1" TYPE="mdraid" 

Look for the partition labeled "NEW-SWAP", on /dev/sdb1, that we created
above. Copy your swap partition's UUID into the new fstab, as shown
below. Of course we also add /dev/md0, as our root mount point.

    [root@arch ~]# cat /mnt/new-raid/etc/fstab
    /dev/md0    /    ext3     defaults   0 1
    UUID=9ff5682b-d5a1-4ed5-8d63-d1df911e0142 none swap sw 0 0

> Rebuild initcpio or initramfs

First chroot into the RAID system

    [root@arch ~]# mount --bind /sys /mnt/new-raid/sys
    [root@arch ~]# mount --bind /proc /mnt/new-raid/proc
    [root@arch ~]# mount --bind /dev /mnt/new-raid/dev
    [root@arch ~]# chroot /mnt/new-raid/
    [root /]# 

If the chroot command gives you an error like
chroot: failed to run command `/bin/zsh': No such file or directory,
then use chroot /mnt/new-raid/ /bin/bash instead.

You are now chrooted in what will become the root of your RAID-1 system.
Complete the appropriate section below for your distribution (almost
every other step is identical, regardless of the Linux variant).

Record mdadm's config

For Arch Linux, use "/etc/mdadm.conf", for Ubuntu or Debian, use
"/etc/mdadm/mdadm.conf"

    nano /etc/mdadm.conf

... and change the "MAILADDR" line to be your email address, if you want
emailed alerts of problems with the RAID-1.

Then save the array configuration with UUIDs to make it easier for the
system to find /dev/md0 on boot-up. If you do not do this, you can get
an "ALERT! /dev/md0 does not exist" error when booting :

    mdadm --detail --scan >> /etc/mdadm.conf

For Arch Linux: Rebuild initcpio

Edit /etc/mkinitcpio.conf to include mdadm in the HOOKS array. Place it
after autodetect, sata, scsi and pata (whichever is appropriate for your
hardware).

    [root /]# mkinitcpio -p linux
    [root /]# exit

For Ubuntu or Debian: Rebuild initramfs

Then rebuild initramfs, incorporating the two above changes:

    update-initramfs -k `uname -r` -c -t

This will rebuild your running version - to rebuild others, this will
show a listing (in Ubuntu):

    ls /boot/ | perl -lne "/^[A-z\.\-]+/m && print $'" | egrep -e 'openvz$|generic$|server$' | sort -u

Then substitute/script in these others so that all are available for use
with the new RAID setup.

> Install GRUB on the RAID array

Start grub:

    [root@arch ~]# grub --no-floppy

Then we find our two partitions - the current one (hd0,0) (I.e. first
disk, first partition), and (hd1,1) (i.e. the partition we just added
above, on the second partition of the second drive). Check you get two
results here:

    grub> find /boot/grub/stage1
    (hd0,0)
    (hd1,1)

Then we tell grub to assume the new second drive is (hd0), i.e. the
first disk in the system (when it is not currently the case). If your
first disk fails, however, and you remove it, or you change the order
disks are detected in the BIOS so that you can boot from your second
disk, then your second disk will become the first disk in the system.
The MBR will then be correct, your new second drive will have become
your first drive, and you will be able to boot from this disk.

    grub> device (hd0) /dev/sdb

Then we install GRUB onto the MBR of our new second drive. Check that
the "partition type" is detected as "0xfd", as shown below, to make sure
you have the right partition:

    grub> root (hd0,1)
     Filesystem type is ext2fs, partition type 0xfd
    grub> setup (hd0)
     Checking if "/boot/grub/stage1" exists... yes
     Checking if "/boot/grub/stage2" exists... yes
     Checking if "/boot/grub/e2fs_stage1_5" exists... yes
     Running "embed /boot/grub/e2fs_stage1_5 (hd0)"...  16 sectors are embedded. succeeded
     Running "install /boot/grub/stage1 (hd0) (hd0)1+16 p (hd0,1)/boot/grub/stage2 /boot/grub/grub.conf"... succeeded
     Done
    grub> quit

Verify success
--------------

Reboot your computer, making sure it boots from the new RAID disk
(/dev/sdb) and not the original disk (/dev/sda). You may need to change
the boot device priorities in your BIOS to do this.

Once the GRUB on the new disk loads, make sure you select to boot the
new entry you created in menu.lst earlier.

Verify you have booted from the RAID array by looking at the output of
mount. Also check mdstat again only to confirm which disk is in the
array.

    [root@arch ~]# mount
    /dev/md0 on / type ext3 (rw)

    [root@arch ~]# cat /proc/mdstat
    Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6] [raid10]
    md0 : active raid1 sdb2[1]
         40064 blocks [2/1] [_U]

    unused devices: <none>

  
 Also swapon -s:

    [root@arch ~]# swapon -s
    Filename                Type           Size    Used    Priority
    /dev/sdb1               partition      4000144 16      -1

Note it is the swap partition on sdb that is in use, nothing from sda.

If system boots fine, and the output of the above commands is correct,
then congratulations! You're now running off the degraded RAID array. We
can add the original disk to the array now to bring it up to full
performance.

Add original disk to array
--------------------------

> Partition original disk

Copy the partition table from /dev/sdb (newly implemented RAID disk) to
/dev/sda (second disk we are adding to the array) so that both disks
have exactly the same layout.

    [root@arch ~]# sfdisk -d /dev/sdb | sfdisk /dev/sda

Alternate method - this will output the /dev/sdb partition layout to a
file, then it's used as input for partitioning /dev/sda.

    [root@arch ~]# sfdisk -d /dev/sdb > raidinfo-partitions.sdb
    [root@arch ~]# sfdisk /dev/sda < raidinfo-partitions.sdb

Use the --force if needed.

    [root@arch ~]# sfdisk --force /dev/sda < raidinfo-partitions.sdb

Verify that the partitioning is identical:

    [root@arch ~]# fdisk -l

Note

If you get an error when attempting to add the parition to the array:

    mdadm: /dev/sda1 not large enough to join array

You might have seen an earlier warning message when partitioning this
disk that the kernel still sees the old disk size - a reboot ought to
fix this, then try adding again to the array.

> Add disk partition to array

    [root@arch ~]# mdadm /dev/md0 -a /dev/sda2
    mdadm: hot added /dev/sda2

Verify that the RAID array is being rebuilt.

    [root@arch ~]# cat /proc/mdstat
    Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6] [raid10]
    md0 : active raid1 sda2[2] sdb2[1]
          80108032 blocks [2/1] [_U]
          [>....................]  recovery =  1.2% (1002176/80108032) finish=42.0min speed=31318K/sec

    unused devices: <none>

  
 Syncing can take a while. If the machine is not needed for other tasks
the speed limit can be increased.

    [root@arch ~]# cat /proc/mdstat 
    Personalities : [raid1] 
    md0 : active raid1 sda3[2] sdb3[1]
          155042219 blocks super 1.2 [2/1] [_U]
          [>....................]  recovery =  0.0% (77696/155042219) finish=265.8min speed=9712K/sec
          
    unused devices: <none>

Check the current speed limit.

    [root@arch ~]# cat /proc/sys/dev/raid/speed_limit_min 
    1000
    [root@arch ~]# cat /proc/sys/dev/raid/speed_limit_max
    200000

Increase the limits.

    [root@arch ~]# echo 400000 >/proc/sys/dev/raid/speed_limit_min
    [root@arch ~]# echo 400000 >/proc/sys/dev/raid/speed_limit_max

Then check out the syncing speed and estimated finish time.

    [root@arch ~]# cat /proc/mdstat 
    Personalities : [raid1] 
    md0 : active raid1 sda3[2] sdb3[1]
          155042219 blocks super 1.2 [2/1] [_U]
          [>....................]  recovery =  1.3% (2136640/155042219) finish=158.2min speed=16102K/sec
         
    unused devices: <none>

> Add second swap partition

The partition was created with sfdisk, but it still has to be formatted
for swap.

    [root@arch ~]# mkswap -L SWAP /dev/sda1
    Setting up swapspace version 1, size = 271314 kB
    LABEL=SWAP, UUID=1acd55dc-f73f-4639-94bc-3f30c33710c9

Then add this UUID to the fstab exactly like the other one earlier. When
done, it should look similar to this:

    [root@arch ~]# cat /mnt/new-raid/etc/fstab
    /dev/md0    /    ext3     defaults   0 1
    UUID=1acd55dc-f73f-4639-94bc-3f30c33710c9 none swap sw 0 0
    UUID=9ff5682b-d5a1-4ed5-8d63-d1df911e0142 none swap sw 0 0

It can be activated immediately:

    [root@arch ~]# swapon /dev/sda1

> Verify that email alerts are working

If you run this command, then you should get a notification email
showing the contents of /proc/mdstat :

    [root@arch ~]# mdadm --monitor --test --oneshot /dev/md0

Check that you get the test email notification. This way you can be
aware if one of the disks in the array fails (otherwise it may fail
silently, putting you at risk of data loss if another drive should also
fail). If you do not get an email notification, check the "MAILADDR"
line in mdadm.conf, and also check that sending an email to this address
from the command line (e.g. using the "mail" command) works.

Automatic conversion tool alternative - Raider
----------------------------------------------

You may consider to use Raider, which is a tool that is able to convert
a single disk in to a Raid system (1, 4, 5, 6 or 10) with a two-pass
command.

-   Website: http://raider.sourceforge.net/
-   It is also available in AUR: Raider

Retrieved from
"https://wiki.archlinux.org/index.php?title=Convert_a_single_drive_system_to_RAID&oldid=234467"

Category:

-   File systems
