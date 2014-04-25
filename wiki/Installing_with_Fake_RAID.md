Installing with Fake RAID
=========================

Related articles

-   Installing with Software RAID or LVM
-   Convert a single drive system to RAID
-   Installation guide
-   Beginners' guide

The purpose of this guide is to enable use of a RAID set created by the
on-board BIOS RAID controller and thereby allow dual-booting of Linux
and Windows from partitions inside the RAID set using GRUB. When using
so-called "fake RAID" or "host RAID", the disc sets are reached from
/dev/mapper/chipsetName_randomName and not /dev/sdX.

Contents
--------

-   1 What is "fake RAID"
-   2 History
-   3 Supported hardware
-   4 Preparation
    -   4.1 Configure RAID sets
-   5 Boot the installer
-   6 Load dmraid
-   7 Perform traditional installation
    -   7.1 Partition the RAID set
    -   7.2 Mounting the filesystem
    -   7.3 Install and configure Arch
-   8 install bootloader
    -   8.1 Use GRUB2
-   9 Troubleshooting
    -   9.1 Booting with degraded array
    -   9.2 Error: Unable to determine major/minor number of root device
    -   9.3 dmraid mirror fails to activate
    -   9.4 No block devices for partitions on existing RAID array
-   10 See also

What is "fake RAID"
-------------------

From Wikipedia:RAID:

Operating system-based RAID doesn't always protect the boot process and
is generally impractical on desktop versions of Windows. Hardware RAID
controllers are expensive and proprietary. To fill this gap, cheap "RAID
controllers" were introduced that do not contain a RAID controller chip,
but simply a standard disk controller chip with special firmware and
drivers. During early stage boot-up, the RAID is implemented by the
firmware. When a protected-mode operating system kernel such as Linux or
a modern version of Microsoft Windows is loaded, the drivers take over.

These controllers are described by their manufacturers as RAID
controllers, and it is rarely made clear to purchasers that the burden
of RAID processing is borne by the host computer's central processing
unit -- not the RAID controller itself -- thus introducing the
aforementioned CPU overhead which hardware controllers do not suffer
from. Firmware controllers often can only use certain types of hard
drives in their RAID arrays (e.g. SATA for Intel Matrix RAID, as there
is neither SCSI nor PATA support in modern Intel ICH southbridges;
however, motherboard makers implement RAID controllers outside of the
southbridge on some motherboards). Before their introduction, a "RAID
controller" implied that the controller did the processing, and the new
type has become known in technically knowledgeable circles as "fake
RAID" even though the RAID itself is implemented correctly. Adaptec
calls them "host RAID".

See also FakeRaidHowto @ Community Ubuntu Documentation for more
information.

Despite the terminology, "fake RAID" via dmraid is a robust software
RAID implementation that offers a solid system to mirror or stripe data
across multiple disks with negligible overhead for any modern system.
dmraid is comparable to mdraid (pure Linux software RAID) with the added
benefit of being able to completely rebuild a drive after a failure
before the system is ever booted. However, be aware that not all BIOS
RAID implementations support drive rebuilding. Instead they rely on
non-linux software to perform the rebuild. If your system cannot rebuild
a drive in the BIOS RAID setup utility, you are strongly encouraged to
use mdraid (pure Linux Software Raid via mdadm - see RAID) instead of
dmraid or you will find yourself unable to rebuild an array in case of a
drive failure - or unable to retrieve information from your array in
case of a motherboard failure without a lot of additional work.

History
-------

In Linux 2.4, the ATARAID kernel framework provided support for fake
RAID (software RAID assisted by the BIOS). For Linux 2.6 the
device-mapper framework can, among other nice things like LVM and EVMS,
do the same kind of work as ATARAID in 2.4. Whilst the new code handling
the RAID I/O still runs in the kernel, device-mapper is generally
configured by a userspace application. It was clear that when using the
device-mapper for RAID, detection would go to userspace.

Heinz Maulshagen created the dmraid tool to detect RAID sets and create
mappings for them. The controllers supported are (mostly cheap) fake
RAID IDE/SATA controllers which contain BIOS functions. Common examples
include: Promise FastTrak controllers; HighPoint HPT37x; Intel Matrix
RAID; Silicon Image Medley; and NVIDIA nForce.

Supported hardware
------------------

-   Tested with ICH10R on 2009.08 (x86_64) -- pointone 23:10, 29
    November 2009 (EST)
-   Tested with Sil3124 on 2009.02 (i686) -- loosec
-   Tested with nForce4 on Core Dump (i686 and x86_64) -- loosec
-   Tested with Sil3512 on Overlord (x86_64) -- loosec
-   Tested with nForce2 on 2011.05 (i686) -- Jere2001; drankinatty
-   Tested with nVidia MCP78S on 2011.06 (x86_64) -- drankinatty
-   Tested with nVidia CK804 on 2011.06 (x86_64) -- drankinatty
-   Tested with AMD Option ROM Utility using pdc_adma on 2011.12
    (x86_64)

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: The installation 
                           steps do not reflect the 
                           current ArchLinux        
                           installation procedure.  
                           Need to be updated. Btw, 
                           it appears that Intel    
                           now recommends mdadm     
                           instead of dmraid (see   
                           Discussion). Update in   
                           progress. (Discuss)      
  ------------------------ ------------------------ ------------------------

Preparation
-----------

Warning:Backup all data before playing with RAID. What you do with your
hardware is only your own fault. Data on RAID stripes is highly
vulnerable to disc failures. Create regular backups or consider using
mirror sets. Consider yourself warned!

-   Open up any needed guides (e.g. Beginners' guide, Installation
    guide) on another machine. If you do not have access to another
    machine, print it out.
-   Download the latest Arch Linux install image.
-   Backup all important files since everything on the target partitions
    will be destroyed.

> Configure RAID sets

Warning:If your drives are not already configured as RAID and Windows is
already installed, switching to "RAID" may cause Windows to BSOD during
boot.[1]

-   Enter your BIOS setup and enable the RAID controller.
    -   The BIOS may contain an option to configure SATA drives as
        "IDE", "AHCI", or "RAID"; ensure "RAID" is selected.
-   Save and exit the BIOS setup. During boot, enter the RAID setup
    utility.
    -   The RAID utility is usually either accessible via the boot menu
        (often F8, F10 or CTRL+I) or whilst the RAID controller is
        initializing.
-   Use the RAID setup utility to create preferred stripe/mirror sets.

Tip:See your motherboard documentation for details. The exact procedure
may vary.

Boot the installer
------------------

See Installation guide#Pre-Installation for details.

Load dmraid
-----------

Load device-mapper and find RAID sets:

    # modprobe dm_mod
    # dmraid -ay
    # ls -la /dev/mapper/

Warning: Command "dmraid -ay" could fail after boot to Arch linux
Release: 2011.08.19 as image file with initial ramdisk environment does
not support dmraid. You could use an older Release: 2010.05. Note that
you must correct your kernel name and initrd name in grubs menu.lst
after installing as these releases use different naming

Example output:

    /dev/mapper/control            <- Created by device-mapper; if present, device-mapper is likely functioning
    /dev/mapper/sil_aiageicechah   <- A RAID set on a Silicon Image SATA RAID controller
    /dev/mapper/sil_aiageicechah1  <- First partition on this RAID Set

If there is only one file (/dev/mapper/control), check if your
controller chipset module is loaded with lsmod. If it is, then dmraid
does not support this controller or there are no RAID sets on the system
(check RAID BIOS setup again). If correct, then you may be forced to use
software RAID (this means no dual-booted RAID system on this
controller).

If your chipset module is NOT loaded, load it now. For example:

    # modprobe sata_sil

See /lib/modules/`uname -r`/kernel/drivers/ata/ for available drivers.

To test the RAID sets:

    # dmraid -tay

Perform traditional installation
--------------------------------

Switch to tty2 and start the installer:

    # /arch/setup

> Partition the RAID set

-   Under Prepare Hard Drive choose Manually partition hard drives since
    the Auto-prepare option will not find your RAID sets.
-   Choose OTHER and type in your RAID set's full path (e.g.
    /dev/mapper/sil_aiageicechah). Switch back to tty1 to check your
    spelling.
-   Create the proper partitions the normal way.

Tip:This would be a good time to install the "other" OS if planning to
dual-boot. If installing Windows XP to "C:" then all partitions before
the Windows partition should be changed to type [1B] (hidden FAT32) to
hide them during the Windows installation. When this is done, change
them back to type [83] (Linux). Of course, a reboot unfortunately
requires some of the above steps to be repeated.

> Mounting the filesystem

If -- and this is probably the case -- you do not find your newly
created partitions under Manually configure block devices, filesystems
and mountpoints:

-   Switch back to tty1.

-   Deactivate all device-mapper nodes:

    # dmsetup remove_all

-   Reactivate the newly-created RAID nodes:

    # dmraid -ay
    # ls -la /dev/mapper

-   Switch to tty2, re-enter the Manually configure block devices,
    filesystems and mountpoints menu and the partitions should be
    available.

Warning:NEVER delete a partition in cfdisk to create 2 partitions with
dmraid after Manually configure block devices, filesystems and
mountpoints have been set. (really screws with dmraid metadata and
existing partitions are worthless) Solution: delete the array from the
bios and re-create to force creation under a new /dev/mapper ID,
reinstall/repartition.

> Install and configure Arch

Tip:Utilize three consoles: the setup GUI to configure the system, a
chroot to install GRUB, and finally a cfdisk reference since RAID sets
have weird names.

-   tty1: chroot and grub-install
-   tty2: /arch/setup
-   tty3: cfdisk for a reference in spelling, partition table and
    geometry of the RAID set

Leave programs running and switch to when needed.

Re-activate the installer (tty2) and proceed as normal with the
following exceptions:

-   Select Packages
    -   Ensure dmraid is marked for installation

-   Configure System
    -   Add dm_mod to the MODULES line in mkinitcpio.conf. If using a
        mirrored (RAID 1) array, additionally add dm_mirror
    -   Add chipset_module_driver to the MODULES line if necessary
    -   Add dmraid to the HOOKS line in mkinitcpio.conf; preferably
        after sata but before filesystems

install bootloader
------------------

> Use GRUB2

Please read GRUB2 for more information about configuring GRUB2.
Currently, the latest version of grub-bios is not compatiable with
fake-raid. If you got an error like this when you run grub-install:

     $ grub-install /dev/mapper/sil_aiageicechah
     Path `/boot/grub` is not readable by GRUB on boot. Installation is impossible. Aborting.

You could try an old version of grub. Check AUR for available packages.

1. download an old version package for grub

2. install these old version packages by using "pacman -U *.pkg.tar.xz"

3. (Optional) Install os-prober if you have other OS like windows.

4. $ grub-install /dev/mapper/sil_aiageicechah

5. $ grub-mkconfig -o /boot/grub/grub.cfg

6. (Optional) put grub2-bios, grub2-common in /etc/pacman.conf's
IgnorePkg array, if you don't want pacman upgrade it.

That's all, grub-mkconfig will generate the configure automatically. You
could edit /etc/default/grub to modify the configure (timeout, color,
etc) before grub-mkconfig.

Troubleshooting
---------------

> Booting with degraded array

One drawback of the fake RAID approach on GNU/Linux is that dmraid is
currently unable to handle degraded arrays, and will refuse to activate.
In this scenario, one must resolve the problem from within another OS
(e.g. Windows) or via the BIOS/chipset RAID utility.

Alternatively, if using a mirrored (RAID 1) array, users may temporarily
bypass dmraid during the boot process and boot from a single drive:

1.  Edit the kernel line from the GRUB menu
    1.  Remove references to dmraid devices (e.g. change
        /dev/mapper/raidSet1 to /dev/sda1)
    2.  Append disablehooks=dmraid to prevent a kernel panic when dmraid
        discovers the degraded array

2.  Boot the system

> Error: Unable to determine major/minor number of root device

If you experience a boot failure after kernel update where the boot
process is unable to determine major/minor number of root device, this
might just be a timing problem (i.e. dmraid -ay might be called before
/dev/sd* is fully set up and detected). This can effect both the normal
and LTS kernel images. Booting the 'Fallback' kernel image should work.
The error will look something like this:

    Activating dmraid arrays...
    no block devices found
    Waiting 10 seconds for device /dev/mapper/nvidia_baaccajap5
    Root device '/dev/mapper/nvidia_baaccajap5' doesn't exist attempting to create it.
    Error: Unable to determine major/minor number of root device '/dev/mapper/nvidia_baaccajap5'

To work around this problem:

-   boot the Fallback kernel
-   insert the 'sleep' hook in the HOOKS line of /etc/mkinitcpio.conf
    after the 'udev' hook like this:

    HOOKS="base udev sleep autodetect block dmraid filesystems"

-   rebuild the kernel image and reboot

> dmraid mirror fails to activate

Does everything above work correctly the first time, but then when you
reboot dmraid cannot find the array?

This is because Linux software raid (mdadm) has already attempted to
mount the fakeraid array during system init and left it in an umountable
state. To prevent mdadm from running, move the udev rule that is
responsible out of the way:

    # cd /lib/udev/rules.d
    # mkdir disabled
    # mv 64-md-raid.rules disabled/
    # reboot

> No block devices for partitions on existing RAID array

If your existing array, set up before attempting to install arch,
appears in /dev/mapper/raidnamehere, but does not have any partitions
(raidnamehere1, etc) re-check the status of your RAID partitions.

Arch may not create block devices for partitions that work in another OS
if there are certain, even minor, problems.

gparted is useful to diagnose and repair most problems. Unfortunately,
you may have to repartition from scratch.

See also
--------

-   Related forum thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_with_Fake_RAID&oldid=304854"

Categories:

-   Getting and installing Arch
-   File systems

-   This page was last modified on 16 March 2014, at 08:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
