HCL/Firmwares/UEFI
==================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Required info                                                      |
| -   2 Lenovo ThinkPad t420s                                              |
| -   3 Lenovo ThinkPad x121e                                              |
|     -   3.1 Required info                                                |
|     -   3.2 Additional notes                                             |
|                                                                          |
| -   4 Intel DZ77GA-70K                                                   |
|     -   4.1 Additional notes                                             |
|                                                                          |
| -   5 Asus M5A99X EVO                                                    |
| -   6 Lenovo Thinkpad Edge E430 3254-DAQ                                 |
|     -   6.1 System Info                                                  |
|     -   6.2 Observations                                                 |
|     -   6.3 Important Info                                               |
|         -   6.3.1 From WonderWoofy                                       |
+--------------------------------------------------------------------------+

> Required info

1.  System OEM/Vendor (like Dell, HP, Lenovo etc.) and Model (like
    ThinkPad x121e etc.) - all info needed
2.  Processor with the model number (full info like Intel Core i7 xxxx
    1.8 GHz - for eg.)
3.  Chipset info (Intel P67 or H67 etc.)
4.  Motherboard with full model number - required if desktop, optional
    for laptop
5.  BIOS/UEFI vendor - AMI Aptio, Phoenix SecureCore Tiano, Insyde H2O
    etc. (very important) with updated month/year (will be shown as
    copyright year in some firmwares)
6.  Were you able to create a working entry in UEFI Boot menu using
    efibootmgr? Any specific issues like black screen or something like
    http://forum-en.msi.com/index.php?topic=153411.0 ?
7.  If you were able to launch the UEFI Shell in ways other than using
    (USB)/efi/boot/bootx64.efi or Archboot, how?
8.  Output of UEFI Shell "ver" command.
9.  If efibootmgr did not work for you and you were able to launch UEFI
    Shell, did you use bcfg command to create UEFI Boot Menu entry? Did
    bcfg created boot entry work for you?
10. Filesystem of UEFI System Partition? FAT32 or FAT16? (Mostly it
    should be FAT32 but some firmwares have problems with it, which is a
    violation of UEFI Spec.)
11. Any graphics/video card issues that occur in UEFI boot alone and not
    in BIOS boot? Like Nvidia closed-source driver's lack of Kernel Mode
    Setting etc.

Note:In any user discussion in irc , forum or mailing lists etc.
regarding UEFI, add your system info here and link to this page in the
discussion to help solve the issue(s) quickly.

Original Post: https://bbs.archlinux.org/viewtopic.php?id=133074.

* * * * *

> Lenovo ThinkPad t420s

-   intel core i7 2640M 2.80GHz
-   Phoenix SecureCore Tiano, 2011
-   UEFI bios version 8CET51WW (1.31), dated 2011-11-29
-   efibootmgr can create entries in menu just fine. looks good.
-   FAT32

> Lenovo ThinkPad x121e

Required info

1.  System OEM/Vendor (like Dell, HP, Lenovo etc.) and Model (like
    ThinkPad x121e etc.) - all info needed
    -   Lenovo ThinkPad x121e 3045CTO

2.  Processor with the model number (full info like Intel Core i7 xxxx
    1.8 GHz - for eg.)
    -   Intel(R) Core(TM) i3-2367M CPU @ 1.40GHz GenuineIntel

3.  Chipset info (Intel P67 or H67 etc.)
    -   Still not sure how to identify this (see original thread for a
        couple of possibilities!)

4.  Motherboard with full model number - required if desktop, optional
    for laptop
    -   N/A

5.  BIOS/UEFI vendor - AMI Aptio, Phoenix SecureCore Tiano, Insyde H2O
    etc. (very important) with updated month/year (will be shown as
    copyright year in some firmwares)
    -   On original install:
        -   Phoenix SecureCore Tiano
        -   Date: 10/25/2011
        -   Vendor: LENOVO
        -   Version: 8QET53WW (1.14 )

    -   After BIOS update:
        -   Date: 01/11/2012
        -   Version: 8QET54WW (1.15 )

6.  Were you able to create a working entry in UEFI Boot menu using
    efibootmgr? Any specific issues like black screen or something like
    http://forum-en.msi.com/index.php?topic=153411.0 ?
    -   Yes. No.

7.  If you were able to launch the UEFI Shell in ways other than using
    (USB)/efi/boot/bootx64.efi or Archboot, how?
    -   Have not managed to launch UEFI shell...

8.  Output of UEFI Shell "ver" command.
    -   See previous answer.

9.  If efibootmgr did not work for you and you were able to launch UEFI
    Shell, did you use bcfg command to create UEFI Boot Menu entry? Did
    bcfg created boot entry work for you?
    -   N/A

10. Filesystem of UEFI System Partition? FAT32 or FAT16? (Mostly it
    should be FAT32 but some firmwares have problems with it, which is a
    violation of UEFI Spec.)
    -   FAT16. FAT32 does NOT work.
    -   More info at https://bbs.archlinux.org/viewtopic.php?id=131149.

Additional notes

-   Works fine with MBR partition map in BIOS mode.
-   Also works fine with GPT partition map in UEFI mode but ONLY if the
    EFI partition is formatted as fat 16.
-   Cannot get it to boot from a GPT disk in BIOS mode.
-   I did not try archboot.

* * * * *

> Intel DZ77GA-70K

1.  System OEM/Vendor (like Dell, HP, Lenovo etc.) and Model (like
    ThinkPad x121e etc.) - all info needed
    -   Intel DZ77GA-70K

2.  Processor with the model number (full info like Intel Core i7 xxxx
    1.8 GHz - for eg.)
    -   Intel Core i7 3770K

3.  Chipset info (Intel P67 or H67 etc.)
    -   Z77

4.  Motherboard with full model number - required if desktop, optional
    for laptop
    -   Intel DZ77GA-70K

5.  BIOS/UEFI vendor - AMI Aptio, Phoenix SecureCore Tiano, Insyde H2O
    etc. (very important) with updated month/year (will be shown as
    copyright year in some firmwares)
    -   (from hardinfo, under a bios boot)

     -BIOS-
      Date		: 07/13/2012
      Vendor		: Intel Corp. (www.intel.com)
      Version		: GAZ7711H.86A.0049.2012.0713.1518
     -Board-
      Name		: DZ77GA-70K
      Vendor		: Intel Corporation (www.intel.com)

1.  Were you able to create a working entry in UEFI Boot menu using
    efibootmgr? Any specific issues like black screen or something like
    http://forum-en.msi.com/index.php?topic=153411.0 ?
    -   No. Linux cannot boot through uefi on this motherboard, with
        this bios revision.

2.  If you were able to launch the UEFI Shell in ways other than using
    (USB)/efi/boot/bootx64.efi or Archboot, how?
    -   No, however bootx64.efi works, archboot does not.

3.  Output of UEFI Shell "ver" command.

     UEFI Interactive Shell v2.0
     Copyright 2009-2011 Intel(r) Corporation. All rights reserved. Beta build 1.0
     UEFI v2.31 (American Megatrends, 0x0004028D)

1.  If efibootmgr did not work for you and you were able to launch UEFI
    Shell, did you use bcfg command to create UEFI Boot Menu entry? Did
    bcfg created boot entry work for you?
    -   booting through bcfg produced the same results as booting from
        the shell, didn't work.

2.  Filesystem of UEFI System Partition? FAT32 or FAT16? (Mostly it
    should be FAT32 but some firmwares have problems with it, which is a
    violation of UEFI Spec.)
    -   Both FAT32 and FAT16 do not work.

3.  Any graphics/video card issues that occur in UEFI boot alone and not
    in BIOS boot? Like Nvidia closed-source driver's lack of Kernel Mode
    Setting etc.
    -   Kernel hangs after attempting to boot, no graphics output after
        changing to the kernel. Graphics output before that is fine.

Additional notes

More info at archlinux forums and stack overflow. Similar problems with
a different motherboard. Seems to be a buggy uefi implementation by
intel.

* * * * *

> Asus M5A99X EVO

1.  System OEM/Vendor
    -   Asus M5A99X EVO

2.  Processor with the model number
    -   AMD FX(tm)-8150 Eight-Core Processor

3.  Chipset info
    -   AMD 990X/SB950

4.  BIOS/UEFI vendor

      Vendor: American Megatrends Inc.
      Version: 0901
      Release Date: 12/02/2011

1.  Were you able to create a working entry in UEFI Boot menu using
    efibootmgr?
    -   Yes

2.  If you were able to launch the UEFI Shell in ways other than using
    (USB)/efi/boot/bootx64.efi
    -   Yes, option in the Exit menu of the UEFI BIOS "Launch UEFI from
        system partition"

3.  Output of UEFI Shell "ver" command.
    -   To be updated

4.  Filesystem of UEFI System Partition? FAT32 or FAT16?
    -   FAT32

5.  Any graphics/video card issues that occur in UEFI boot alone and not
    in BIOS boot? Like Nvidia closed-source driver's lack of Kernel Mode
    Setting etc.
    -   No

* * * * *

> Lenovo Thinkpad Edge E430 3254-DAQ

The below information was added by user User:The.ridikulus.rat .

System Info

1.  Lenovo Thinkpad Edge E430 3254-DAQ (India)
2.  Intel Core i5 3210M 2.50 GHz (3rd Gen aka Ivy Bridge), 4 GB DDR3 RAM
3.  Intel HM77 Express Chipset
4.  UEFI Firmware Vendor : Phoenix SecureCore Tiano
5.  UEFI/BIOS Version : H0ET73WW (2.07)
6.  Embedded Controller Version : H0HT73WW (2.07)
7.  UEFI Specification/Revision : 2.31 (ie. 2.3.1)
8.  Lenovo UEFI/BIOS Build Date : 29-OCT-2012
9.  External Ports: 3 USB 3.0, 1 USB 2.0, 1 VGA, 1 HDMI, 1 RJ45
    Ethernet/LAN port (Realtek), 1 ExpressCard 34 port, 1 3.5mm
    Headphones jack
10. 1 Tray-Load CD/DVD Writer
11. Switchable Graphics : Intel HD Graphics 4000 and Nvidia GeForce 610M
    (1GB Dedicated RAM)
12. WiFi / WLAN Card : Intel Centrino Wireless-N 2230 (B/G/N + Bluetooth
    4.0)

Observations

1.  UEFI Secure Boot support is present in firmware, but I have
    currently disabled it. System came pre-installed with Windows 7 Pro
    x64 in BIOS-MBR mode, with BIOS version 1.14 (which did not include
    UEFI Secure Boot).
2.  After BIOS update, all boot entries got erased and I had to recreate
    them using efibootmgr.
3.  Using a 1 GiB FAT32 UEFISYS partition (/dev/sda1) mounted at
    /boot/efi (i.e. separate from /boot). Kernel and initramfs files
    synced during update using
    UEFI_Bootloaders#Sync_EFISTUB_Kernel_in_UEFISYS_partition_using_Systemd.
4.  No issues with efibootmgr for creating entries for rEFInd and GRUB
    2.x . But unable to create direct EFISTUB entries as described at
    UEFI_Bootloaders#Using_efibootmgr_entry (echo'ed kernel parameters
    are truncated by efibootmgr).
5.  Currently using rEFInd (textonly mode) as main boot manager (1st in
    boot menu) with grub-efi-x86_64 (2nd in boot menu) and grub-bios
    installed as fallback. rEFInd is first in boot menu (installed at
    <UEFISYS>/EFI/refind/refindx64.efi). No need for
    /EFI/Microsoft/Boot/bootmgfw.efi hack. Dual-booting Windows 8 Pro
    x64 UEFI-GPT (chainloaded from rEFInd/GRUB) works without any
    issues. Windows boot files are stored in same UEFISYS partition.
6.  Both UEFI Shell v2 and v1 work, launched from rEFInd or
    grub-efi-x86_64. No option in the firmware setup/menu to directly
    launch the shell.
7.  Currently using only intel and nouveau drivers. Haven't yet tried
    nvidia binary drivers and bumblebee graphics switching support.
    Kernel Mode Setting enabled.
8.  grub-bios works if the firmware is changed to boot "Legacy only"
    without any boot/active flag in 0xEE Protective MBR partition entry.
9.  Gummiboot v8 works fine without any errors.
10. Using only PARTUUID in /etc/fstab and in bootloader config files.

Important Info

I didn't use Archiso or Archboot to install the system. I transferred
the Arch installation from my old Sony Vaio laptop to my new Thinkpad
E430 using an external USB HDD and rsync from within SystemRescueCD,
after manually creating the partitions using GParted, and then manually
setup fstab and rEFInd. After that I rebooted into Arch and installed
grub-efi-x86_64 and grub-bios.

From WonderWoofy

On an E430-3254(CTO) I had the same issues as the.ridikulus.rat with
efibootmgr and truncated kerl command line parameters. This usually lead
to the inability of the kernel to find the initramfs. What I ended up
doing is putting the kernel and intramfs in the root of the ESP, and
from there the efibootmgr entries worked nicely. This does lead to an
ESP that is not organized in the recommended way though.

Also, I did actually install via Archboot, and all worked fine. I have
actually installed twice on this machine, once to a Momentus XT and once
to a Samsung 830. The first time I used a CD, and therefore selected the
"UEFI First" preference in the bios. This supposedly will try UEFI
(\EFI\boot\bootx64.efi) first, and if that fails it will look to the
MBR. Unfortunately, it did not honor this setting for the optical drive,
and I had to turn off legacy bios mode entirely to get it to boot in
UEFI from the CD. Interestingly, this "UEFI First" setting works just
fine for interal drives. USB flash drives are a whole different story
though, and more information can be found here.

* * * * *

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Firmwares/UEFI&oldid=239709"

Category:

-   Hardware Compatibility List
