Windows and Arch Dual Boot
==========================

This is a simple article detailing different methods of Arch/Windows
coexistence.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Using Grub2                                                        |
| -   2 Using Windows boot-loader                                          |
|     -   2.1 Using Windows 7/8 Boot-Loader                                |
|     -   2.2 Using Windows 2000/XP Bootloader                             |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Using Grub2
-----------

See Grub#Dual-booting.

Using Windows boot-loader
-------------------------

Another option is sort of the reverse of what is described at the
beginning of this article where GRUB loads the Windows boot loader,
which then loads Windows. Under this option, the Windows boot loader
load GRUB, which then loads arch.

> Using Windows 7/8 Boot-Loader

Excerpted from
http://www.iceflatline.com/2009/09/how-to-dual-boot-windows-7-and-linux-using-bcdedit/

In order to have the Windows boot-loader see the linux partition, one of
the linux partitions created needs to be FAT32 (in this case,
/dev/sda3). The remainder of the setup is similar to a typical
installation. Some documents state that the partition being loaded by
the Win boot-loader must be a primary partition but I have used this
without problem on an extended partition.

-   When installing the grub bootloader, install it on your /boot
    partition rather than the MBR.
    Note: For instance, my /boot partition is /dev/sda5. So I installed
    grub at /dev/sda5 instead of /dev/sda   
     For help on doing this, see Grub#Install to Partition or
    Partitionless Disk

-   Under linux make a copy of the boot info by typing the following at
    the command shell:

    my_windows_part=/dev/sda3
    my_boot_part=/dev/sda5
    mkdir /media/win
    mount $my_windows_part /media/win
    dd if=$my_boot_part of=/media/win/linux.bin bs=512 count=1

-   Boot to windows and open up and you should be able to see the FAT32
    partition. Copy the linux.bin file to C:\. Now run cmd with
    administrator privileges (navigate to Start->All
    Programs->Accessories, Right-click on Command Prompt and select “Run
    as administrator.”)

    bcdedit /create /d “Linux” /application BOOTSECTOR

-   BCDEdit will return an alphanumeric identifier for this entry that I
    will refer to as {ID} in the remaining steps. You’ll need to replace
    {ID} by the actual returned identifier. An example of {ID} is
    {d7294d4e-9837-11de-99ac-f3f3a79e3e93}.

    bcdedit /set {ID} device partition=c:
    bcdedit /set {ID}  path \linux.bin
    bcdedit /displayorder {ID} /addlast
    bcdedit /timeout 30

Done! Reboot and enjoy. In my case I'm using the Win bootloader so that
I can map my Dell Precision M4500's second power button to boot linux
instead of windows.

> Using Windows 2000/XP Bootloader

For information on this method see
http://www.geocities.com/epark/linux/grub-w2k-HOWTO.html. I do not
believe there are any distinct advantages of this method over the Linux
bootloader; you will still need a /boot partition, and this one is
arguably more difficult to set up.

See also
--------

Booting Windows from a desktop shortcut

Retrieved from
"https://wiki.archlinux.org/index.php?title=Windows_and_Arch_Dual_Boot&oldid=254243"

Category:

-   Boot process
