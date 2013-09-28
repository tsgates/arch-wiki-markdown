GRUB EFI Examples
=================

Summary

It is well know that different motherboard manufactures implement UEFI
differently. The purpose of this page is to show hardware-specific
methods known to work when installing/restoring GRUB in efi mode.

Related Articles

Grub

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Apple Mac EFI systems                                              |
|     -   1.1 Generic Macs                                                 |
|                                                                          |
| -   2 Asus                                                               |
|     -   2.1 Z68 Family and U47 Family                                    |
|     -   2.2 P8Z77 Family                                                 |
|                                                                          |
| -   3 Intel                                                              |
|     -   3.1 S5400 Family                                                 |
+--------------------------------------------------------------------------+

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

    efibootmgr -c -g -d /dev/sda -p 1 -w -L "Archlinux Grub" -l '\EFI\arch_grub\grubx64.efi'

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

FROM WITHIN THE CHROOT

    # mount -t vfat /dev/sdXY /boot/efi
    # grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch --recheck
    # grub-mkconfig -o /boot/grub/grub.cfg
    # mkdir /boot/efi/boot && cd /boot/efi
    # wget https://edk2.svn.sourceforge.net/svnroot/edk2/trunk/edk2/ShellBinPkg/UefiShell/X64/Shell.efi
    # cp Shell.efi shellx64.efi && cp Shell.efi /boot/efi/boot
    # umount /boot/efi

-   Reboot and enter the BIOS (the Delete key will do this).
-   Using the arrow keys, move to the 'exit' menu and drop down to the
    EFI shell you just downloaded and copied to three places.
-   You will need to add an entry to your boot menu manually. Below is
    an example, see the UEFI#Launching UEFI Shell article for more.
    Below is an example added a new entry to a menu with 3 current
    entries.

FROM WITHIN THE EFI SHELL

    Shell> bcfg boot dump -v
    Shell> bcfg boot add 3 fs0:\EFI\arch\grubx64.efi "Arch Linux (grub manually added)"
    Shell> exit

-   Reboot the machine and enter the BIOS.
-   Navigate to the 'Boot' section and adjust the boot order to your
    liking with the "Arch Linux (grub manually added)" being the one on
    your SSD.
-   Boot to this entry and enjoy your system.

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

Retrieved from
"https://wiki.archlinux.org/index.php?title=GRUB_EFI_Examples&oldid=249668"

Category:

-   Boot loaders
