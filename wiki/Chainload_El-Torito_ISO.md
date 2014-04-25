Chainload El-Torito ISO
=======================

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Work in progress. This is what I've researched so far, I'll add more
when I find more.

Aims:

-   To boot multiple ISOs from a single USB flash drive.
-   Drive should be multi-purpose. Space for other files such as
    documents.
-   Quick easy setup; deal more with files and less with partitions.
    This makes the drive more portable and flexible on legacy OSs. Drive
    should have .iso files rather than iso9660 partitions.
-   Setup should be reliable on various BIOSs for more portability.
-   The ability to remove the drive after boot would be very useful.

Contents
--------

-   1 Gujin MBR & ISO9660 Partitions
    -   1.1 Problems
-   2 Grub4Dos
    -   2.1 Gujin Floppy
    -   2.2 Memory Mapping
    -   2.3 Workaround For Crap BIOSs
-   3 CD Emulation
    -   3.1 Self-contained ISOs
    -   3.2 ?INT13h & Real Mode?
    -   3.3 Gujin ISO Modification
-   4 Physical Workaround
-   5 Red Herrings

Gujin MBR & ISO9660 Partitions
------------------------------

This solution inspired me but has it's problems:
Install_from_USB_stick#Gujin

> Problems

-   When Gujin is installed as the MBR it requires it's own partition.
    This can be a nuisance to set up properly. If this partition is
    mounted and written to, it becomes corrupt.
-   Most GNOME installations automount all the many iso9660 partitions I
    have.
-   I usually duplicate the ISOs as files and partitions.
-   Gujin isn't able to boot ISOs on some BIOSs even though CDs can
    boot.

After much research I came up with some improvements and information.
I'm trying to present these improvements in a modular fashion, rather
than giving possible complete solutions.

Grub4Dos
--------

Grub4Dos is a fork of Grub Legacy which is actively maintained and has
some useful ideas. It is familiar to Grub users, easier to manage and
opens up some new features.

-   Make fat32 filesystem on partition 1.
-   Install Grub4Dos to MBR.
-   Copy Grub4Dos files to partition 1's / or /boot.

> Gujin Floppy

The need for a Gujin partition is removed by the use of a Gujin boot
floppy image which is booted from Grub4Dos.

-   Get Gujin standard tarball.
-   Extract floppy image

    tar -xzf standard-2.8.1.tar.gz full.img.gz -O | gzip -d > gujin-2.8.1.fdi

-   Edit menu.lst, add:

    title Gujin Boot Loader 2.8.1
    map --mem /boot/gujin-2.8.1.fdi (fd0)
    map --hook
    rootnoverify (fd0)
    chainloader (fd0)+1

Grub4Dos can boot the Gujin floppy image which then generates the menu
of available ISOs.

> Memory Mapping

Files can be loaded into memory first, allowing for flash drive removal.

    map --mem From... To...
    map --hook

> Workaround For Crap BIOSs

Some BIOSs cannot boot from CD or USB drives, or fail to enter setup or
boot menu.

-   Install a Grub clone on the HDD if none already.
-   Chainload flash drive. From Grub commandline:

    chainloader (hd1)+1
    boot

CD Emulation
------------

Many ISOs including Arch's require emulation.

-   Gujin - I'm not sure if Gujin is an emulator or uses some other
    trick.
-   isoemu - Sounds right but actually just uses INT13h.
    http://www.911cd.net/forums//index.php?showtopic=8955
-   Grub 2 - Apparently Grub 2 plan to support el-torito chainload to
    ISOs but they do not seem to regard it as a priority or always
    realise what the actual goal is.

http://grub.enbug.org/FeatureRequests
http://savannah.gnu.org/bugs/?10780

> Self-contained ISOs

Some ISOs have all data needed for boot in the kernel and ramdisk files.
They can be booted directly from Grub4Dos without emulation.

> ?INT13h & Real Mode?

When an OS is in 'real mode', it hooks INT13h BIOS interrupt call and
doesn't require emulation. Old or very minimal OSs stay in real mode but
new and advanced OSs such as Linux leave real mode. At this point they
crash unless properly emulated.

Not sure how accurate I am; I do not fully understand this.

> Gujin ISO Modification

According to the website, Gujin can modify .iso files, presumably so
that they can be booted directly without emulation. I haven't tried this
yet and can't find much info on it.

Physical Workaround
-------------------

Maybe, instead of a flash drive, a USB SD card reader and some SD cards
could be used instead. Still a hassle though.

Red Herrings
------------

When searching, I found quite a lot of information on how to chainload a
*REAL* CD rather than a .iso file or iso9660 partition. For example:
http://www.lrz-muenchen.de/~bernhard/grub-chain-cd.html
http://cutecomputer.wordpress.com/2006/10/10/boot-cdrom-through-grub/

I also came across alot of info on how to boot self-contained or INT13h
ISOs.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Chainload_El-Torito_ISO&oldid=196981"

Category:

-   Boot process

-   This page was last modified on 23 April 2012, at 13:50.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
