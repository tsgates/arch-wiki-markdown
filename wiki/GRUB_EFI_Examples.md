GRUB EFI Examples
=================

Summary help replacing me

It is well know that different motherboard manufactures implement UEFI
differently. The purpose of this page is to show hardware-specific
methods known to work when installing/restoring GRUB in efi mode.

Related Articles

Grub

Contents
--------

-   1 Apple Mac EFI systems
    -   1.1 Generic Macs
-   2 Asus
    -   2.1 Z68 Family and U47 Family
    -   2.2 P8Z77 Family
    -   2.3 M5A97
-   3 Intel
    -   3.1 S5400 Family
-   4 Lenovo
    -   4.1 K450 IdeaCentre
    -   4.2 M92p ThinkCentre

Apple Mac EFI systems
---------------------

> Generic Macs

Use bless command from within Mac OS X to set grubx64.efi as the default
boot option. You can also boot from the Mac OS X install disc and launch
a Terminal there if you only have Linux installed. In the Terminal,
create a directory and mount the EFI System Partition:

    # cd /Volumes
    # mkdir efi
    # mount -t msdos /dev/disk0s1 /Volumes/efi

Then run bless on grub.efi and on the EFI partition to set them as the
default boot options.

    # bless --folder=/Volumes/efi --file=/Volumes/efi/efi/arch_grub/grubx64.efi --setBoot
    # bless --mount=/Volumes/efi --file=/Volumes/efi/efi/arch_grub/grubx64.efi --setBoot

More info at
https://help.ubuntu.com/community/UEFIBooting#Apple_Mac_EFI_systems_.28both_EFI_architecture.29.

Note:TODO: GRUB upstream Bazaar mactel branch
http://bzr.savannah.gnu.org/lh/grub/branches/mactel/changes. No further
update from grub developers.

Note:TODO: Experimental "bless" utility for Linux by Fedora developers -
mactel-boot. Requires more testing.

Asus
----

> Z68 Family and U47 Family

    # cp /boot/efi/EFI/arch_grub/grubx64.efi /boot/efi/shellx64.efi

After this launch the UEFI Shell from the UEFI setup/menu (in ASUS UEFI
BIOS, switch to advanced mode, press Exit in the top right corner and
choose "Launch EFI shell from filesystem device"). The GRUB2 menu will
show up and you can boot into your system. Afterwards you can use
efibootmgr to setup a menu entry, for example if you have the uefi
partition in /dev/sda1: (read Unified_Extensible_Firmware_Interface)

    efibootmgr -c -g -d /dev/sda -p 1 -w -L "Arch Linux (GRUB)" -l /EFI/arch_grub/grubx64.efi

If your motherboard has no such option (or even if it does), you can use
UEFI shell (Unified_Extensible_Firmware_Interface#UEFI_Shell) to create
a UEFI boot option for the Arch partition temporarily.

Once you boot into the EFI shell, add a UEFI boot menu entry:

    Shell> bcfg boot add 0 fs1:\EFI\arch_grub\grubx64.efi "Arch Linux (GRUB2)"

where fs1 is the mapping corresponding to the UEFI System Partition and
\EFI\arch_grub\grubx64.efi is the the from the --bootloader-id from the
grub-install command above.

This will temporarily add a UEFI boot option for the next boot to get
into Arch. Once in Arch, modprobe efivars and confirm that efibootmgr
creates no errors (no errors meaning you successfully booted in UEFI
mode). Then Grub2#Install_to_UEFI_SYSTEM_PARTITION can be performed
again and should successfully permanently add a boot entry in the UEFI
menu.

> P8Z77 Family

-   Boot to live media and chroot into the target system.
-   Make sure that a 100 MB fat32 partition is marked as "EFI System"
    (gdisk terminology uses hex code ef00).

Note:If you get the message WARNING: Not enough clusters for a 32 bit
FAT!, reduce cluster size with mkfs.vfat -s2 -F32 ... otherwise the
partition may be unreadable by UEFI.

FROM WITHIN THE CHROOT

    # mount -t vfat /dev/sdXY /boot/efi
    # grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch --recheck
    # grub-mkconfig -o /boot/grub/grub.cfg
    # wget https://edk2.svn.sourceforge.net/svnroot/edk2/trunk/edk2/ShellBinPkg/UefiShell/X64/Shell.efi
    # umount /boot/efi

The EFI partition should be contain just two files:

    /Shell.efi
    /EFI/arch/grubx64.efi

-   Reboot and enter the BIOS (the Delete key will do this).
-   Using the arrow keys, move to the 'exit' menu and drop down to the
    EFI shell.
-   Add an entry for Arch to the menu. Below is an example, see the
    UEFI#Launching UEFI Shell article for more.

FROM WITHIN THE EFI SHELL

    Shell> bcfg boot dump -v
    Shell> bcfg boot add 1 fs0:\EFI\arch\grubx64.efi "Arch Linux (grub manually added)"
    Shell> exit

-   Reboot the machine and enter the BIOS.
-   Navigate to the 'Boot' section and adjust the boot order to with the
    "Arch Linux (grub manually added)" being the one on the SSD.
-   Boot to this entry and enjoy.

> M5A97

Finish the standard Arch install procedures, making sure that you
install grub-efi-x86_64 and partition your boot hard disk as GPT.

From [1]:

The UEFI system partition will need to be mounted at /boot/efi/ for the
GRUB install script to detect it:

    # mkdir -p /boot/efi
    # mount -t vfat /dev/sdXY /boot/efi

Where X is your boot hard disk and Y is the efi partition you created
earlier.

Install GRUB UEFI application to /boot/efi/EFI/arch_grub and its modules
to /boot/grub/x86_64-efi using:

    # modprobe dm-mod
    # grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck --debug
    # mkdir -p /boot/grub/locale
    # cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

Generate a configuration for GRUB

    # grub-mkconfig -o /boot/grub/grub.cfg

Then copy the modified UEFI Shell v2 binary UefiShellX64.efi into your
ESP root.

    # cp ~/Shell2/UefiShellX64.efi /mnt/boot/efi/shellx64.efi

The reason that we need this shell application is that the efibootmgr
command will fail silently during grub-install.

After this launch the UEFI Shell from the UEFI setup/menu (in ASUS UEFI
BIOS, switch to advanced mode, press Exit in the top right corner and
choose "Launch EFI shell from filesystem device"). The UEFI shell will
show up. From here we need to add our GRUB UEFI app to the bootloader.

    Shell> bcfg boot add 3 fs0:\EFI\Arch_Grub\grubx64.efi "Arch_Grub"

where fs0 is the mapping corresponding to the UEFI System Partition and
3 is the zero based boot entry index.

To list the current boot entries you can run:

    Shell> bcfg boot dump -v

Intel
-----

> S5400 Family

This board can run in BIOS or in EFI mode. BIOS mode requires an
MBR-partitioned hard drive, EFI a GPT hard drive. Please note that this
board operates on the Intel EFI v1.10 specification, and is i386 only.
The normal procedure for UEFI installation can be followed, with the
exception of the following changes.

-   Instead of using the grub-efi-x86_64 package, grub-efi-i386 has to
    be used
-   The bcfg command is not available for pre-UEFI (v2.0) firmware. A
    startup.nsh file can be used on the root of the EFI partition
    containing the path to the bootloader. For example:

fs0:\EFI\arch_grub\boot.efi has to be placed in the startup.nsh file on
the root of the EFI partition.

-   The grub.cfg file has to be placed in the same directory as the grub
    EFI file, otherwise grub will not find it and enter the interactive
    shell

  

Lenovo
------

> K450 IdeaCentre

The "EFI System" partition requires the file EFI\Boot\bootx64.efi to be
present in order to boot, otherwise you will receive "Error 1962: No
operating system found. Boot sequence will automatically repeat."
Assuming the "EFI System" partition is mounted on /boot/efi:

     # grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub --recheck --debug
     # mkdir /boot/efi/EFI/Boot
     # touch /boot/efi/EFI/Boot/bootx64.efi

This is a workaround for what is likely a bug in the UEFI
implementation.

> M92p ThinkCentre

This system whitelists efi labels. It will only boot from a label called
"Red Hat Enterprise Linux". So specify the bootloader id appropriately:

     # grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="Red Hat Enterprise Linux" --recheck --debug

Retrieved from
"https://wiki.archlinux.org/index.php?title=GRUB_EFI_Examples&oldid=299086"

Category:

-   Boot loaders

-   This page was last modified on 20 February 2014, at 14:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
