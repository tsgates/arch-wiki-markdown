LinHES R6 Hints and Tips
========================

This page will be the equivalent of TJC's Hints and Tips pages for
previous Knoppmyth versions of LinHES. Please expand this guide with any
information, tips or warning you feel would be useful. If you find
anything missing please add it in.

Contents
--------

-   1 Upgrade Preparation
-   2 R6 Installation Walk-through (Detailed)
-   3 Troubleshooting
-   4 R6.02.00 Upgrade Walk-through

Upgrade Preparation
-------------------

When upgrading to R6 with multiple drives, fix your /etc/fstab before
you start to use either labels or uuid. As in the past, during an
upgrade the installer inspects the root partition for this file and uses
it to setup mount points. Unfortunately because R6 uses the modern SCSI
emulation layer drivers for all hard disks, what used to be /dev/hdb1 is
now /dev/sdb1, or possibly /dev/sda1, or /dev/sdc1, or ... Well you get
the picture...

Using an unambiguous label or UUID is the best way to solve the problem.
For example this is what the fstab entries for my HD and LVM volumes
look like using labels:

/etc/fstab:

LABEL=Root / ext3 defaults,errors=remount-ro 0 1

LABEL=myth /myth auto defaults,auto 0 2

LABEL=swap1 none swap defaults 0 0

  
 and this is what they'd look like using UUID.

/etc/fstab:

UUID=24f28fc6-717e-4bcd-a5f7-32b959024e26 / ext3
defaults,errors=remount-ro 0 1

UUID=03ec5dd3-45c0-4f95-a363-61ff321a09ff /myth auto defaults,auto 0 2

UUID=4209c845-f495-4c43-8a03-5363dd433153 none swap defaults 0 0

Note that the only change is to replace the device names with the
appropriate LABEL/UUID identifiers.

  
 Hint: running blkid will list the UUIDs for all of your partitions and
volumes. E.g.:

root@black2:~# blkid /dev/hda1: LABEL="Root"
UUID="24f28fc6-717e-4bcd-a5f7-32b959024e26" SEC_TYPE="ext2" TYPE="ext3"

/dev/hda2: LABEL="swap1" UUID="4209c845-f495-4c43-8a03-5363dd433153"
TYPE="swap"

/dev/mapper/vg-myth: LABEL="myth"
UUID="03ec5dd3-45c0-4f95-a363-61ff321a09ff" SEC_TYPE="ext2" TYPE="ext3"

R6 Installation Walk-through (Detailed)
---------------------------------------

This section is for first time installs or upgrades from R5. To upgrade
to a later version of R6 see the appropriate section below.

Boot the LinHES CD or USB media.

-   Screen 1: Select the "Install or Upgrade" option. If upgrading, you
    will go directly to screen 10 and everything will be processed
    automatically based on your backups.

Warning: If upgrading from an R5.x box, make sure that you run the
mythbackup script before you attempt an install of R6.

-   Screen 2: Select a target file-system

-   Screen 3: Select the type of install (Full/auto or Upgrade). Also
    assign partition sizes for the OS, swap, and data partitions. The
    defaults should be fine. Users can also select which file-system
    format is used. Currently the default is for ext3, but other options
    such as ext4/RFS/XFS/JFS are also available.

-   Screen 4: Assign a host-name

Note: Make sure you are satisfied with the host-name you select since
you cannot easily change it after the installation due to a number of
other configuration files/mysql tables that will depend on it.

-   Screen 5: Setup the network options. Users may select from wired or
    wireless configurations with all the standard options such as
    dynamic IP/static IP, devices, mtu size, etc.

Note: For more of MTU sizes a.k.a jumbo frames, see the Jumbo Frames
article.

-   Screen 6: Setup host options. Choices here include system
    configuration (standalone/frontend/master backend/slave backend).
    Initial resolution (i.e. SDTV or HDTV) and remote configure are also
    on this screen. The setup GUI contains many options for remote
    controls that are preconfigured for you. Users also set the option
    to use or not use mythwelcome on this screen.

Note: Make sure you understand the architecture of mythtv networks. A
selection of standalone should only be made if this is and will be the
only mythtv box on your network. For more on this, see [insertlink this]
page on the official mythtv wiki.

-   Screen 7: Setup timezone/zipcode

-   Screen 8: Setup NFS options if media is stored on a remote NFS
    share. Also configure automatic updates

-   Screen 9: Setup user accounts and passwords

Warning: Make sure to create a non-mythtv account, assign a root
password and assign a mythtv password on this screen before you
continue.

-   Screen 10: Sanity check/"Are you sure you wish to continue?" screen.

This concludes the installation. The scripts will take over and in about
5 min you will reboot into your LinHES installation.

Troubleshooting
---------------

No Sound after upgrading. Note: If you do not have sound after
upgrading, try running alsaconf as root to reconfigure your alsa
drivers. Then alsamixer, and finallly "alsactl store" to save the
settings.

L99 99 99 99 99 99 99 If you have more than one drive the new bootloader
might have the drives in the wrong order. This will result in a screen
full of 99's upon booting. For example if you have a IDE/PATA drive and
a SATA one, and boot from the SATA drive. As root try the following
commands.

-   grub

-   grub> root (hd1,0)

-   grub> setup (hd1)

-   grub> quit

R6.02.00 Upgrade Walk-through
-----------------------------

If you're upgrading from a previous version of R6 it should be a pretty
easy process.

-   Step 1: Make a backup from the System Menu???

-   Step 2: Exit the frontend and open an xterm by pressing Alt-X.

-   Step 3: sudo pacman -S linhes-scripts

-   Step 4: sudo upgrade_to_0.22.sh

Retrieved from
"https://wiki.archlinux.org/index.php?title=LinHES_R6_Hints_and_Tips&oldid=238860"

Category:

-   Audio/Video

-   This page was last modified on 6 December 2012, at 00:50.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
