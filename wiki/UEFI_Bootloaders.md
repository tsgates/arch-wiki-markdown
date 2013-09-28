UEFI Bootloaders
================

This page contains info about various UEFI Bootloaders capable of
booting Linux kernel. It is recommended to read the UEFI and GPT pages
before reading this page. The following bootloaders are explained here:

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Linux Kernel EFISTUB                                               |
|     -   1.1 Setting up EFISTUB                                           |
|     -   1.2 Booting EFISTUB                                              |
|         -   1.2.1 Using rEFInd                                           |
|             -   1.2.1.1 Systemd Automation                               |
|             -   1.2.1.2 Apple Macs                                       |
|             -   1.2.1.3 VirtualBox                                       |
|                                                                          |
|         -   1.2.2 Using gummiboot                                        |
|         -   1.2.3 Using UEFI Shell                                       |
|         -   1.2.4 Using efibootmgr entry                                 |
|                                                                          |
| -   2 GRUB 2.x                                                           |
| -   3 SYSLINUX                                                           |
| -   4 ELILO                                                              |
| -   5 EFILINUX                                                           |
| -   6 Package Naming Guidelines                                          |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Linux Kernel EFISTUB
--------------------

Linux (Kernel >= 3.3) supports EFISTUB (EFI BOOT STUB) booting. It is
enabled by by default on Arch Linux kernels or can be activated by
setting CONFIG_EFI_STUB=y in the Kernel configuration (see The EFI Boot
Stub for more information).

A single EFISTUB kernel is not capable of launching other kernels, hence
each EFISTUB Kernel + Initramfs pair requires a separate boot menu
entry. It is recommended to use a UEFI Boot Manager to manage multiple
kernels.

> Setting up EFISTUB

1.  Create a FAT32 UEFI System Partition
2.  Mount the UEFI System Partition at /boot/efi with
    # mount <UEFI Partition> /boot/efi if you're going to be using
    GRUB2, or at /boot with # mount <UEFI Partition> /boot if you're
    going to be using Gummiboot or rEFInd. Gummiboot cannot boot across
    partitions, and will never have such capability due to its nature,
    so it's paramount that you mount the UEFI System Partition at /boot
    for use with Gummiboot so that the kernel and initramfs lie on the
    same partition as the bootmanager.

Note: As of refind-efi 0.6.5, refind now automatically detects kernels
in /boot. They do not have to be renamed to have a .efi extension
either, as long as you are using refind.

> Booting EFISTUB

Warning:Linux Kernel EFISTUB booting uses \ instead of / and should be
relative to the UEFI System Partition's root. For example, if the
initramfs is located in /boot/efi/EFI/arch/initramfs-linux.img, the
corresponding UEFI formatted line would be
\EFI\arch\initramfs-linux.img. Failure to convert the options will lead
to a system hang without any error message from the firmware or kernel.

Note: Support of initrd path name with / in EFISTUB booting has been
added in mainline 3.9-rc1 and stable 3.8.2. Leading / can be ignored but
the path still has to be full path. Example:
initrd=EFI/arch/initramfs-linux.img

  

One can boot the EFISTUB kernel using one of the following ways :

Using rEFInd

rEFInd is a fork of rEFIt Boot Manager (used in Intel Macs) by Rod Smith
(author of GPT-fdisk). rEFInd fixes many issues in rEFIt with respect to
non-Mac UEFI booting and also has support for booting EFISTUB kernels
and contains some features specific to them. More info about rEFInd
support for EFISTUB is at The rEFInd Boot Manager: Methods of Booting
Linux.

1.  Install refind-efi package with # pacman -S refind-efi
2.  Copy the following files from their source directory to their
    destination

Note:<arch> is the bit architecture of the system. Run $ uname -m to get
the architecture. Replace <arch> with "ia32" for 32 bit systems, and
<arch> with "x64" for 64 bit systems.

  rEFInd File Source                   UEFI Destination
  ------------------------------------ ----------------------------------------
  /usr/lib/refind/refind_<arch>.efi    /boot/efi/EFI/refind/refind_<arch>.efi
  /usr/lib/refind/config/refind.conf   /boot/efi/EFI/refind/refind.conf
  /usr/share/refind/icons              /boot/efi/EFI/refind/icons
  /usr/lib/refind/drivers_<arch>       /boot/efi/EFI/tools/drivers

Tip:Refind's configuration file is located in
/boot/efi/EFI/refind/refind.conf. The file is well commented.

Note:As of refind-efi 0.6.5-1, refind can auto-detect kernels in /boot,
if there are UEFI drivers for the filesystem used by /boot partition (or
/ partition if no separate /boot is used) in the ESP, and are loaded by
rEFInd. To enable rEFInd to detect and load the drivers and /boot
kernels you must enable the appropriate options in refind.conf (mainly
mention the PATH for the drivers location in the ESP) and also copy your
refind_linux.conf to /boot/refind_linux.conf .

Tip:Pass kernel specific commands by copying
/usr/lib/refind/config/refind_linux.conf to
/boot/efi/EFI/arch/refind_linux.conf. This file should be located in the
same directory as the EFISTUB kernel. Edit the configuration file to be
similar to the template below. Replace the string after PARTUUID with
your root's PARTUUID

Note:Please notice the difference between the standard UUID and the
PARTUUID shown by $ ls -l /dev/disk/by-partuuid/

    $esp/EFI/arch/refind_linux.conf

    "Boot with defaults" "root=PARTUUID=3518bb68-d01e-45c9-b973-0b5d918aae96 ro rootfstype=ext4 add_efi_memmap systemd.unit=graphical.target"
    "Boot to Terminal"   "root=PARTUUID=3518bb68-d01e-45c9-b973-0b5d918aae96 ro rootfstype=ext4 add_efi_memmap systemd.unit=multi-user.target"

Tip:Each line of refind_linux.conf is displayed as a submenu by rEFInd.
Access the submenu with "+" or "insert" keys.

Tip:In non-Mac systems, create an entry for rEFInd using efibootmgr
where sdX is the UEFI disk, and Y is the UEFI partition number. Run :

     # modprobe efivars
     # efibootmgr -c -g -d /dev/sdX -p Y -w -L "rEFInd" -l '\EFI\refind\refind_<arch>.efi'

Systemd Automation

Tip:To automate the process of copying refind files and updating the
nvram (if needed) use the following script

Note:Save this script as /usr/lib/systemd/scripts/refind_name_patchv2

Tip:If you want to change the directory that refind is installed in the
UEFISYS partition, just change the value of $refind_dir in the script

    #!/bin/bash
    ## COPYRIGHT 2013 : MARK E. LEE (BLUERIDER) : mlee24@binghamton.edu; mark@markelee.com

    ## LOG
    ## 1/17/2013 : Version 2 of refind_name_patch is released
    ##           : Supports long subdirectory location for refind
    ##           : Updates nvram when needed
    ##           : 10% speed boost

    function main () {  ## main insertion function
      declare -r refind_dir="/boot/efi/EFI/refind"; ## set the refind directory
      declare -r arch=$(uname -m | awk -F'_' '{if ($1 == "x86"){print $2}}') &&  ## get bit architecture
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
        cp -r /usr/{share/refind/*,lib/refind/refind_x*$arch*.efi} $refind_dir/ && ## update bin and dirs
        echo "Updated binaries and directory files for refind at $refind_dir";
       else
        echo "Failed to detect an x86 architecture";
        exit;
      fi;
    }

    function update-efi-nvram () { ## update the nvram with efibootmgr
      declare -r ref_bin=${refind_dir/\/boot\/efi}/$(ls /usr/lib | grep $arch*.efi);  ## get path of refind binary (without /boot/efi)
      declare -r ref_bin_escape=${ref_bin//\//\\\\};  ## insert escape characters into $ref_bin
      modprobe efivars && ## grab the efi variables for efibootmgr
      efibootmgr -v | grep $ref_bin_escape && ( ## check if boot entry is in nvram
        echo "Found boot entry, no need to update nvram";
        ) || ( ## if boot entry is not in nvram; add it
        declare -r esp=$(mount -l | awk '/ESP/ {print $1}') &&  ## get ESP partition
        efibootmgr -c -g -d ${esp:0:8} -p ${esp:8} -w -L "rEFInd" -l $ref_bin_escape && ## update nvram
        echo "
        Updated nvram with entry rEFInd to boot $ref_bin
        Did not copy configuration files, please move refind.conf to $refind_dir/";
        )
    }

    main;  ## run the main insertion function

Note:Save the following service file as
/usr/lib/systemd/system/refind_update.path

    [Unit]
    Description=Update rEFInd bootloader files

    [Path]
    PathChanged=/usr/lib/refind/refind_<arch>.efi
    Unit=refind_update.service

    [Install]
    WantedBy=multi-user.target

Note:Save the following service file as
/usr/lib/systemd/system/refind_update.service

    [Unit]
    Description=Update rEFInd directories, binaries, and nvram

    [Service]
    Type=oneshot
    ExecStart=/bin/bash /usr/lib/systemd/scripts/refind_name_patchv2
    RemainAfterExit=no

Tip:Enable the systemd path unit by running :

    # systemctl enable refind_update.path

Apple Macs

In case of Apple Macs, try mactel-boot for an experimental "bless"
utility for Linux. If that does not work, use "bless" form within OSX to
set rEFInd as default bootloader. Assuming UEFISYS partition is mounted
at /mnt/efi within OSX, do

    $ sudo bless --setBoot --folder /mnt/efi/EFI/refind --file /mnt/efi/EFI/refind/refind_x64.efi

VirtualBox

In case of VirtualBox, see
VirtualBox#Using_Arch_under_Virtualbox_EFI_mode.

Using gummiboot

Gummiboot is a UEFI Boot Manager which provides a nice menu for EFISTUB
Kernels. It is available in [extra] as gummiboot. See
https://wiki.archlinux.org/index.php/Gummiboot for more info.

Using UEFI Shell

It is possible to launch EFISTUB kernel form UEFI Shell as if it is a
normal UEFI application. In this case the kernel parameters are passed
as normal parameters to the launched EFISTUB kernel file.

    > fs0:
    > cd \EFI\arch
    > vmlinuz-arch.efi root=PARTUUID=3518bb68-d01e-45c9-b973-0b5d918aae96 ro rootfstype=ext4 add_efi_memmap initrd=EFI/arch/initramfs-arch.img

You can also write a simple archlinux.nsh file with your boot parameters
and put it in your UEFI System Partition, then run it with:

    fs0:
    archlinux

Example Script:

    echo -on
    \EFI\arch\vmlinuz-arch.efi root=PARTUUID=3518bb68-d01e-45c9-b973-0b5d918aae96 ro rootfstype=ext4 add_efi_memmap initrd=EFI/arch/initramfs-arch.img

This way you can specify UUID's without needing to remember the name or
type out 20-30 characters.

Using efibootmgr entry

Note:This method may not work due to limitations in how the kernel
handles uefi runtime variables. For example in some Lenovo Thinkpads the
initrd path is truncated (verified using efibootmgr -v command) and
therefore the kernel fails to boot.

Note:Some UEFI firmwares may not support embedding command line
parameters to uefi applications in the boot entries.

It is possible to directly embed the kernel parameters within the boot
entry created by efibootmgr. This means that in your BIOS/UEFI you will
be able to select Arch Linux directly in the default boot order, and on
startup it will boot into Arch directly without any kind of boot
selection GUI.

Do (as root):

Install efibootmgr if you haven't already.

     # pacman -S --needed efibootmgr

Load the EFI module.

    # modprobe efivars

Finally, add the efistub. WARNING: Make sure you replace the following
before running this command:

-   /dev/sda -- the drive that contains the EFI boot partition
-   -p 1 -- the partition number of the EFI boot partition
-   /dev/sda2 -- your / partition
-   ext4 -- if you use a different file system

    # efibootmgr -c -d /dev/sda -p 1 -L "Arch Linux" -l '\EFI\arch\vmlinuz-arch.efi' -u root=UUID=$(blkid /dev/sda2 -o value -s UUID) ro rootfstype=ext4 add_efi_memmap initrd=EFI/arch/initramfs-arch.img

It is a good idea to run

    # efibootmgr -v

to verify that the resulting entry is correct. You should also consider
reordering the boot options (efibootmgr -o) to place the Arch entry
last, which could make the system easier to recover if it fails.

More info about efibootmgr at UEFI#efibootmgr. Forum post
https://bbs.archlinux.org/viewtopic.php?pid=1090040#p1090040 .

Note:Some firmwares may have trouble with the "initrd path" when using
ucs-2 as shown above. In this case, one may put vmlinuz-linux.efi and
the initramfs in the root of the ESP and adjust the efibootmgr entry
accordingly.

When booting using this method, care must be taken to synchronize the
kernel with the ESP following a kernel upgrade but before rebooting. If
you fail to do so, your system will not boot until you update the ESP by
some other means (e.g. using the installation media to mount your hard
drive).

GRUB 2.x
--------

GRUB 2.x contains its own filesystem drivers and does not rely on the
firmware to access the files. It can directly read files from /boot and
does not require the kernel and initramfs files to be in the UEFISYS
partition. Detailed information at GRUB#UEFI_systems_2. For bzr
development version try AUR package - grub-efi-x86_64-bzr.

SYSLINUX
--------

Note:Syslinux UEFI support is currently part of version 6.00-preXX or in
firmware branch of upstream git repo. It is considered alpha quality by
upstream. The below information is provided mainly to enable
bug-testing. Please report all issues upstream.

Note:Syslinux UEFI can boot only those kernels that support EFI Handover
Protocol. Thus LTS kernels are not supported.

Install syslinux-efi-git AUR package and copy /usr/lib/syslinux/efi64/*
to $esp/EFI/syslinux/ ($esp is the mountpoint of UEFISYS partition)
(efi64 is for x86_64 UEFI firmwares, replace with efi32 for i386 UEFI
firmwares), and then create a boot entry using efibootmgr in the
firmware boot manager.

ELILO
-----

ELILO is the UEFI version of LILO Boot Loader. It was originally created
for Intel Itanium systems which supported only EFI (precursor to UEFI).
It is the oldest UEFI bootloader for Linux. It is still in development
but happens at a very slow pace. Upstream provided compiled binaries are
available at http://sourceforge.net/projects/elilo/ . Elilo config file
elilo.conf is similar to LILO's config file. AUR package - elilo-efi.

EFILINUX
--------

EFILINUX is a reference implementation of a UEFI Linux bootloader and
precursor to Kenrel EFISTUB support. It is considered to be a alpha
quality software (as on 16-MAY-2012). Upstream sources are at
https://github.com/mfleming/efilinux . and the usage instructions are at
http://thread.gmane.org/gmane.linux.kernel/1172645 and
http://article.gmane.org/gmane.linux.kernel/1175060 . AUR packages -
efilinux-efi and efilinux-efi-x86_64-git (only for x86_64 UEFI).

Package Naming Guidelines
-------------------------

UEFI bootloader package(s) should be suffixed with -efi-x86_64 or
-efi-i386 to denote package built for 64-bit and 32-bit UEFI
respectively. If a single package contains both 64-bit and 32-bit UEFI
applications, then -efi suffix should be used in the pkgname.

See also
--------

-   Rod Smith - Managing EFI Boot Loaders for Linux
-   Rod Smith - rEFInd, a fork or rEFIt
-   Linux Kernel Documentation on EFISTUB
-   Linux Kernel EFISTUB Git Commit
-   Rod Smith's page on EFISTUB
-   rEFInd Documentation for booting EFISTUB Kernels

Retrieved from
"https://wiki.archlinux.org/index.php?title=UEFI_Bootloaders&oldid=255974"

Category:

-   Boot loaders
