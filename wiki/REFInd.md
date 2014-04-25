rEFInd
======

rEFInd is a fork of rEFIt Boot Manager (used in Intel Macs) by Rod Smith
(author of gdisk). rEFInd fixes many issues in rEFIt with respect to
non-Mac UEFI booting and also has support for booting EFISTUB kernels
and contains some features specific to them.

Contents
--------

-   1 Planning the partitions and kernel location
-   2 Boot EFISTUB using rEFInd
-   3 A dual boot setup for Archlinux and Windows 8.1 using rEFInd
-   4 Upgrading rEFInd
-   5 Systemd Automation (Upgrading)
-   6 Apple Macs
-   7 VirtualBox

Planning the partitions and kernel location
-------------------------------------------

rEFInd is a UEFI boot manager that was written to handle EFI boot, and
make booting Windows, Linux and Mac OS a relatively pain free process,
particularly as the linux kernel is now built with its own EFI stub boot
loader.

It is convenient to set up the arch linux system so that the kernel and
initial ramdisk files are in a journalled filesystem, so that repairs
are possible in the event of errors in the filesystem, and keep only a
minimal set of necessary files on the EFI, which is required to be
formatted as VFAT.

It is also desirable to have the system rebootable immediately after a
kernel update, without further preparation or moving the kernel files
from the location that they are created by pacman.

The assumption here is that the EFI will be mounted after the install as
/boot/efi

If the root partition is mounted as / and a directory called /boot is
created, then a convenient way to mount the EFI partition is to mount it
as /boot/efi. Then the normal install location for the kernel and
initial ramdisk is in /boot/ and the (VFAT) EFI is mounted at
/boot/efi/. Then the rEFInd binary and associated directories and files
can be placed in a newly created directory at /boot/efi/EFI/refind/

Boot EFISTUB using rEFInd
-------------------------

Tip:If you're new to EFISTUB and/or rEFInd, you need to read The rEFInd
Boot Manager: Methods of Booting Linux before going any further. This
section illustrates only one possible use-case for a pure Arch linux
system which is not suitable for all configurations, and includes a
section with one use-case for dual booting Archlinux with Windows 8.1.

Note:refind-efi includes a install script from upstream at
/usr/bin/refind-install which does the job of setting-up of rEFInd
similar to the steps below.

Note:For 32-bit aka IA32 EFI, replace x64 with ia32 (case-sensitive) in
the commands below.

-   Mount efivarfs

    # mount -t efivarfs efivarfs /sys/firmware/efi/efivars              # ignore if already mounted

-   Install the refind-efi package.

-   Copy the following files from their source directory to their
    destination

    # cp /usr/share/refind/refind_x64.efi /boot/efi/EFI/refind/refind_x64.efi
    # cp /usr/share/refind/refind.conf-sample  /boot/efi/EFI/refind/refind.conf
    # cp -r /usr/share/refind/icons /boot/efi/EFI/refind/
    # cp -r /usr/share/refind/fonts /boot/efi/EFI/refind/
    # cp -r /usr/share/refind/drivers_x64 /boot/efi/EFI/refind/

-   Edit rEFInd's config file at /boot/efi/EFI/refind/refind.conf. The
    file is well commented and self explanatory. rEFInd should
    automatically find kernel files in /boot, but it is also possible to
    add a menu entry for Arch Linux. Set the default boot item to the
    Archlinux kernel by adding the line:

    default_selection vmlinuz

A menu entry can be added to refind.conf such as

    refind.conf

    menuentry "Arch Linux" {
            icon     EFI/refind/icons/os_linux.icns
            volume   "/"
            loader   /boot/vmlinuz-linux
            initrd   /boot/initramfs-linux.img
            options  "root=PARTUUID=3518bb68-d01e-45c9-b973-0b5d918aae96 rw rootfstype=ext4"
    }

but this may not be necessary unless standard options need to be
changed. Note that the "volume" line contains the label of the volume
where the root partition is. For alphameric characters only it is not
necessary to put the name in quotes, but if you use special characters
then the kernel will not boot unless the name is in quotes. Also the
partition can be referenced using the PARTUUID or the UUID provided the
appropriate string is used as verified from the output of the blkid
command. If the root partition is not ext4 then the rootfstype will be
as needed for the partition type, but should be detected automatically
without this parameter.

Note that if you choose to mount your ESP as a different name to
/boot/efi then replace these paths as appropriate as in the lines above.

Note:Modify the loader and initrd paths if you did not place them in
your ESP's root. Replace the string after PARTUUID with your root's
PARTUUID. Please note in the example above that PARTUUID/PARTLABEL
identifies a GPT partition, and differs from the UUID/LABEL, which
identifies a filesystem. Using the PARTUUID/PARTLABEL is advantageous
because it is invariant if you reformat the partition with another
filesystem. It's also useful if you don't have a filesystem on the
partition (or use LUKS, which doesn't support LABELs).

To find the PARTUUID (or UUID) for the root partition use:

    # blkid

and

    # lsblk -f

to get the partition information matched to the correct root partition.

-   If the kernel and initramfs are located at /boot as default, you can
    create a refind_linux.conf file inside the directory where the
    kernel and initramfs files are located. Or you can copy the sample
    file to the same directory that the kernel and initramfs are located
    using:

    # cp /usr/share/refind/refind_linux.conf-sample /boot/refind_linux.conf

    refind_linux.conf

    "Boot with defaults"    "root=PARTUUID=XXXXXXXX rootfstype=XXXX ro"
    "Boot to terminal"      "root=PARTUUID=XXXXXXXX rootfstype=XXXX ro systemd.unit=multi-user.target"

where the PARTUUID from the blkid command is used, and the rootfstype is
commonly ext4.

This file tells rEFInd where the root partition is located for the
system boot, so the PARTUUID is that for the root partition.

The drivers that were copied to the refind directory in the ESP include
an ext4 driver, and allow the rEFInd binary to read the kernel and
initramfs file in the ext4 /boot directory.

Tip:Each line of refind_linux.conf is displayed as a submenu by rEFInd.
Access the submenu with "+" or "insert" or "F2" keys.

-   Create a boot entry in the UEFI NVRAM in the motherboard using
    efibootmgr

    # efibootmgr -c -d /dev/sdX -p Y -l /EFI/refind/refind_x64.efi -L "rEFInd"

where sdX is drive containing the EFI partition, and Y is the partition
number for the EFI on that drive.

The entries can be checked by just using the command

    # efibootmgr

on its own to verify that there is now a refind entry, and the boot
order should show that this is the first entry in the list.

For a few system types if the efibootmgr command does not create NVRAM
entries correctly, then an alternative is to use bcfg from within a UEFI
shell version 2, to write and manage NVRAM entries. Information about
this is available elsewhere in the wiki.

Note:As of refind-efi 0.2.7, refind can auto-detect kernels in /boot, if
there are UEFI drivers for the filesystem used by /boot partition (or /
partition if no separate /boot is used) in the ESP, and are loaded by
rEFInd. This is enabled in the default configuration in refind.conf (you
may need to include the PATH to the drivers folders in the ESP). See [1]
for more info.

Once the system is rebooted when the install is complete the system
should then boot to the graphical rEFInd screen after the POST is
complete, and by default a 20 second timeout will run after which the
system should boot by default to Archlinux (The timeout period can be
changed by editing refind.conf). Once the system has booted then the
root user can login and continue to configure the newly installed
system.

During the 20 second timeout period the rEFInd boot manager can be
interrupted to select different icons that can be booted, and it is also
possible to change the boot kernel parameters in a similar way to what
many users have been familiar with in the past using grub.

It is also possible to get a screenshot of the graphical rEFInd screen
by hitting F10 and a bmp image file will be written to the top level
directory of the EFI.

When the Archlinux kernel is updated via pacman then no further action
is needed other than to reboot if the setup described above is used. For
customised setups where the kernel is not placed in the /boot directory
then the kernel and initramfs files may need to be moved to the
directory where they will be booted before the new kernel will be active
after reboot.

A dual boot setup for Archlinux and Windows 8.1 using rEFInd
------------------------------------------------------------

A second use-case is where an arch install is to be added to a
pre-existing Windows 8.1 setup as a dual boot system, where booting to
both operating systems is desired as well as any factory Recovery
partitions.

Here only the differences between the pure Archlinux setup above and the
dual boot system are highlighted.

Normally Windows 8 or 8.1 boots under Secure Boot. Although in principle
Secure Boot could be setup for Archlinux it is not straighforward, and
it is recommended to switch off Secure Boot in the BIOS if the machine
is to be dual booted with Archlinux. Check that the machine still boots
correctly with Secure Boot turned off.

It is also necessary to switch off Fastboot from within Windows 8.1
before attempting to install Archlinux in a dual boot system. Fastboot
is a type of hybrid suspend with part of the system stored during
shutdown. If Fastboot is not turned off then corruption is likely if
Windows is booted again after the system has booted Archlinux.

The changes that are therefore recommended for a pre-existing Windows 8
or 8.1 system on which Archlinux is going to be installed are as
follows:

    1) Within Windows 8.1 switch off Fastboot and check that Windows restarts without any problem.
    2) Switch off Secure Boot from the BIOS settings, and check that Windows restarts correctly.

In order to create space on the disk for linux partitions it is
recommended that, with Windows 8.1 running, go to the Windows Disk
Management facility and shrink the C: drive to make space for new
partitions in which Archlinux will be installed.

Note here that if you change the partitions using an externally booted
partition editor such as gparted it is possible that Windows, or any
Recovery boot partitions may not boot once the partitions, or
particularly the partition numbers, have been changed.

It is straightforward to create new partitions using the Archlinux
install iso during the install process using the gdisk command.

It is recommended not to create additional EFI partitions, and to
utilise the existing EFI partition that the pre-existing Windows system
uses. Hence it is only necessary to create a root partition ( / ), and
possibly an additional partition for /home or /opt ( often as ext4, but
any suitable linux partition type can be used by preference). A linux
swap partition may also be desirable and in this use case it is no
different to a standard Archlinux install. For an existing UEFI system
the main hard drive will have a GPT partition table, and from the
Archlinux install iso, once booted, the gdisk facility is simple to use
to create the additional linux partitions.

Once the partitions have been created then a filesystem must be created
in each new partition except swap.

This can be done using for example mkfs -t ext4 /dev/sdXY as necessary
for each new linux partition.

The only difference between a dual boot system and the pure linux
install described in the first section of this page, is that the rEFInd
files are placed in a new directory that is created in the pre-existing
EFI, leaving the existing directories and files for Windows and recovery
binary files untouched.

Hence create a new directory within the EFI:

    /boot/efi/EFI/refind

Then install rEFInd as in the pure linux case above, and copy the same
set of files and directories as above into this directory.

The remainder of the install is the same as for a pure Archlinux
install.

Once the remainder of the Archlinux install is complete, then booting
the new system should result in the rEFInd screen with Archlinux as the
default entry visible, but with additional icons visible for booting
Windows 8.1 as well as Recovery to Factory Settings if this was provided
by the original manufacturer. Note that if the Recovery boot is
initiated it will overwrite the linux partitions, and so would normally
only be used in the event that the Windows 8.1 system was unrecoverable,
in which case Archlinux would then need to be installed again from
scratch.

Upgrading rEFInd
----------------

When a new version of the refind package is installed as an update via
pacman, then all that is necessary is to copy the refind directories and
files, except the refind.conf and refind_linux.conf as in the pure
Archlinux install section above.

To automatically update rEFInd to the latest version, you could run
refind-install (in cronjob) as alternative to the systemd script below.
The command will be executed as follow:

    /usr/bin/refind-install

    Installing rEFInd on Linux....
    ESP was found at /boot/efi using vfat
    Found rEFInd installation in /boot/efi/EFI/refind; upgrading it.
    Installing driver for ext4 (ext4_x64.efi)
    Copied rEFInd binary files

    Notice: Backed up existing icons directory as icons-backup.
    Existing refind.conf file found; copying sample file as refind.conf-sample
    to avoid overwriting your customizations.

    rEFInd has been set as the default boot manager.
    Existing //boot/refind_linux.conf found; not overwriting.

    Installation has completed successfully.

Systemd Automation (Upgrading)
------------------------------

To automate the process of copying refind files and updating the nvram
(if needed) use the following script.

Note:If you want to change the directory that refind is installed in the
UEFISYS partition, just change the value of $refind_dir in the script

    /usr/lib/systemd/scripts/refind_name_patchv2

    #!/usr/bin/env bash
    ## COPYRIGHT 2013 : MARK E. LEE (BLUERIDER) : mlee24@binghamton.edu; mark@markelee.com

    ## LOG
    ## 1/17/2013 : Version 2 of refind_name_patch is released
    ##           : Supports long subdirectory location for refind
    ##           : Updates nvram when needed
    ##           : 10% speed boost
    ## 7/15/2013 : Changed arch to match 32-bit (ia32) and 64-bit (x64) naming scheme
    ##           : Changed directory copying in update-efi-dir to copy tools and drivers directories explicitly
    ##           : Changed efibootmgr writing code to be more concise and added (-w) to write the entry as per dusktreader's excellent guide : https://docs.google.com/document/d/1pvgm3BprpXoadsQi38FxqMOCUZhcSqFhZ26FZBkmn9I/edit
    ##           : Function to check if NVRAM boot entry was already listed was fixed to use awk and an if then clause
    ##           : ref_bin_escape was modified from : ref_bin_escape=${ref_bin//\//\\\\} to remove extra backslashes (error does not show up when using cmdline)
    ## 7/29/2013 : Changed location of tools,drivers, and binary directory to match capricious upstream move to /usr/share/refind

    function main () {  ## main insertion function
      declare -r refind_dir="/boot/efi/EFI/refind"; ## set the refind directory
      arch=$(uname -m | awk -F'_' '{if ($1 == "x86") {print "x"$2} else if ($1 == "i686") {print "ia32"}}') &&  ## get bit architecture
      update-efi-dir;  ## updates or creates the refind directory
      update-efi-nvram;  ## updates nvram if needed
    }

    function update-efi-dir () {  ## setup the refind directory
      if [ ! -d $refind_dir ]; then  ## check if refind directory exists
        echo "Couldn't find $refind_dir";
        mkdir $refind_dir &&  ## make the refind directory if needed
        echo "Made $refind_dir";
      fi;
      if [ "$arch" ]; then  ## check if anything was stored in $arch
        cp -r /usr/share/refind/{refind_$arch.efi,keys,images,icons,fonts,docs,{tools,drivers}_$arch} $refind_dir/  && ## update the bins and dirs
        echo "Updated binaries and directory files for refind at $refind_dir";
       else
        echo "Failed to detect an x86 architecture";
        exit;
      fi;
    }

    function update-efi-nvram () { ## update the nvram with efibootmgr
      declare -r ref_bin=${refind_dir/\/boot\/efi}/refind_$arch.efi;  ## get path of refind binary (without /boot/efi)
      declare -r ref_bin_escape=${ref_bin//\//\\};  ## insert escape characters into $ref_bin
      [ "$(efibootmgr -v | awk "/${ref_bin_escape//\\/\\\\}/")" ] && ( ## check if boot entry is in nvram \
        echo "Found boot entry, no need to update nvram";
        ) || ( ## if boot entry is not in nvram; add it
        declare -r esp=$(mount -l | awk '/ESP/ {print $1}') &&  ## get ESP partition
        efibootmgr -cgw -d ${esp:0:8} -p ${esp:8} -L "rEFInd" -l $ref_bin_escape && ## update nvram
        echo "
        Updated nvram with entry rEFInd to boot $ref_bin
        Did not copy configuration files, please move refind.conf to $refind_dir/";
        )
    }
    main;  ## run the main insertion function

    /usr/lib/systemd/system/refind_update.path

    [Unit]
    Description=Update rEFInd bootloader files

    [Path]
    PathChanged=/usr/share/refind/refind_<arch>.efi
    Unit=refind_update.service

    [Install]
    WantedBy=multi-user.target

    /usr/lib/systemd/system/refind_update.service

    [Unit]
    Description=Update rEFInd directories, binaries, and nvram

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/bash /usr/lib/systemd/scripts/refind_name_patchv2
    RemainAfterExit=no

Enable the systemd path unit by running:

    # systemctl enable refind_update.path

Apple Macs
----------

In case of Apple Macs, try mactel-boot for an experimental "bless"
utility for Linux. If that does not work, use "bless" from within OSX to
set rEFInd as default bootloader. Assuming UEFISYS partition is mounted
at /mnt/efi within OSX, do

    $ sudo bless --setBoot --folder /mnt/efi/EFI/refind --file /mnt/efi/EFI/refind/refind_x64.efi

VirtualBox
----------

In case of VirtualBox, see
VirtualBox#Using_Arch_under_Virtualbox_EFI_mode.

Retrieved from
"https://wiki.archlinux.org/index.php?title=REFInd&oldid=304016"

Category:

-   Boot loaders

-   This page was last modified on 11 March 2014, at 12:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
