Windows and Arch Dual Boot
==========================

This is a simple article detailing different methods of Arch/Windows
coexistence.

Contents
--------

-   1 Potential Data Loss
    -   1.1 Renaming Files on NTFS partitions
    -   1.2 Fast Start-Up
-   2 BIOS Systems
    -   2.1 Using a Linux boot loader
    -   2.2 Using Windows boot loader
        -   2.2.1 Windows 7/8 boot loader
        -   2.2.2 Windows 2000/XP boot loader
-   3 UEFI Systems
-   4 See also

Potential Data Loss
-------------------

> Renaming Files on NTFS partitions

Windows is limited to filepaths being shorter than 260 characters.

Windows also puts certain characters off limits in filenames for reasons
that run all the way back to DOS:

-   < (less than)
-   > (greater than)
-    : (colon)
-   " (double quote)
-   / (forward slash)
-   \ (backslash)
-   | (vertical bar or pipe)
-    ? (question mark)
-   * (asterisk)

These are limitations of Windows and not NTFS: any other OS using the
NTFS partition will be fine. Windows will fail to detect these files and
running chkdsk will most likely cause them to be deleted.

> Fast Start-Up

Fast Start-Up is a feature in Windows 8 that hibernates the computer
rather than actually shutting it down to speed up boot times. Your
system can lose data if Windows hibernates and you dual boot into
another OS and make changes to files.

NTFS-3G added a safe-guard to prevent read-write mounting of hibernated
disks, but the NTFS driver within the Linux kernel has no such
safeguard.

BIOS Systems
------------

> Using a Linux boot loader

You may use GRUB or Syslinux.

> Using Windows boot loader

With this setup the Windows bootloader loads GRUB which then boots Arch.

Windows 7/8 boot loader

The following section contains excerpts from
http://www.iceflatline.com/2009/09/how-to-dual-boot-windows-7-and-linux-using-bcdedit/.

The remainder of the setup is similar to a typical installation. Some
documents state that the partition being loaded by the Windows boot
loader must be a primary partition but I have used this without problem
on an extended partition.

-   When installing the GRUB boot loader, install it on your /boot
    partition rather than the MBR.
    Note:For instance, my /boot partition is /dev/sda5. So I installed
    GRUB at /dev/sda5 instead of /dev/sda. For help on doing this, see
    GRUB#Install to partition or partitionless disk

-   Under Linux make a copy of the boot info by typing the following at
    the command shell:

    my_windows_part=/dev/sda3
    my_boot_part=/dev/sda5
    mkdir /media/win
    mount $my_windows_part /media/win
    dd if=$my_boot_part of=/media/win/linux.bin bs=512 count=1

-   Boot to Windows and open up and you should be able to see the FAT32
    partition. Copy the linux.bin file to C:\. Now run cmd with
    administrator privileges (navigate to Start > All Programs >
    Accessories, right-click on Command Prompt and select Run as
    administrator):

    bcdedit /create /d “Linux” /application BOOTSECTOR

-   BCDEdit will return an alphanumeric identifier for this entry that I
    will refer to as {ID} in the remaining steps. You’ll need to replace
    {ID} by the actual returned identifier. An example of {ID} is
    {d7294d4e-9837-11de-99ac-f3f3a79e3e93}.

    bcdedit /set {ID} device partition=c:
    bcdedit /set {ID}  path \linux.bin
    bcdedit /displayorder {ID} /addlast
    bcdedit /timeout 30

Reboot and enjoy. In my case I'm using the Windows boot loader so that I
can map my Dell Precision M4500's second power button to boot Linux
instead of Windows.

Windows 2000/XP boot loader

For information on this method see
http://www.geocities.com/epark/linux/grub-w2k-HOWTO.html. I do not
believe there are any distinct advantages of this method over the Linux
boot loader; you will still need a /boot partition, and this one is
arguably more difficult to set up.

UEFI Systems
------------

Both Gummiboot and rEFInd autodetect Windows Boot Manager
\EFI\Microsoft\Boot\bootmgfw.efi and show it in their boot menu, so
there is no manual config required.

For GRUB(2) follow GRUB#Windows_Installed_in_UEFI-GPT_Mode_menu_entry.

Syslinux (as of version 6.01) and ELILO do not support chainloading
other EFI applications, so they cannot be used to chainload
\EFI\Microsoft\Boot\bootmgfw.efi .

See also
--------

-   Booting Windows from a desktop shortcut
-   UTC in Windows

Retrieved from
"https://wiki.archlinux.org/index.php?title=Windows_and_Arch_Dual_Boot&oldid=300206"

Categories:

-   Boot process
-   Getting and installing Arch

-   This page was last modified on 23 February 2014, at 12:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
