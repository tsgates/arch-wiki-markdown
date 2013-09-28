Migrate installation to new hardware
====================================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page summarizes some hints and ideas (especially handy commands)
useful when moving an Arch Linux system to new hardware. The goal is to
achieve the same ArchLinux installation, as far as software and
configuration is concerned, but also to clean config files and to update
to more recent techniques.

Basically, there are two ways:

1.  Bottom to Top: Install a fresh Arch Linux system on the new
    hardware, and try to install and configure all packages from the
    old.
2.  Top to Bottom: Bitwise copy the old partitions to the new system,
    trying to get the kernel working without forgetting some tweaks.

Which way you choose depends heavily on how the new system differs from
your old and how exactly you want to reproduce the system.

Warning:Some of the following instructions can be dangerous: you are
advised to backup all of your important data on the old system before
continuing.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Bottom to Top                                                      |
|     -   1.1 On the old system                                            |
|         -   1.1.1 What software?                                         |
|         -   1.1.2 Copy to some backup space.                             |
|                                                                          |
|     -   1.2 On the new system                                            |
|         -   1.2.1 Wiki articles                                          |
|         -   1.2.2 Copy from backup space                                 |
|         -   1.2.3 Install software                                       |
|                                                                          |
| -   2 Top to Bottom                                                      |
|     -   2.1 Move the system to the new HDDs                              |
|         -   2.1.1 Update fstab                                           |
|                                                                          |
|     -   2.2 Reconfigure the bootloader                                   |
|     -   2.3 Regenerate kernel image                                      |
|     -   2.4 Update the graphic drivers                                   |
|     -   2.5 Reconfigure audio                                            |
|     -   2.6 Reconfigure network                                          |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Bottom to Top
-------------

> On the old system

What software?

    $ pacman -Qqe | grep -vx "$(pacman -Qqm)" > Packages
    $ pacman -Qqm > Packages.aur

gives you a nice list of explicitly installed packages. Don't forget the
software not installed through pacman.

Copy to some backup space.

-   You can consider backing up /var/cache/pacman/pkg if you do not go
    from x86 to x86_64
-   /etc should be backed up, in order to peek if necessary.

> On the new system

Wiki articles

-   Read some Wiki articles concerning new hardware, for examples your
    new SSD.
-   Stick to the well-written installation guidelines here in this wiki.
    Since you are experienced, the Quick_Arch_Linux_Install could be
    enough.
-   Try to configure as much as possible sticking to current wiki
    articles and forum posts.

Copy from backup space

-   Copy the pacman cache to var/cache/pacman/pkg
-   Don't forget to edit /etc/pacman.d/mirrorlist

Install software

As root, grab a cup of coffee and execute:

    # xargs -a Packages pacman -S --noconfirm --needed

Top to Bottom
-------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

-   See these forum threads:
    -   https://bbs.archlinux.org/viewtopic.php?id=71038
    -   https://bbs.archlinux.org/viewtopic.php?pid=543214

> Move the system to the new HDDs

Note:If you are planning to keep the hard drive where the system is
already installed, you can skip this section.

-   connect origin and destination HDDs to the same pc (either the old
    or the new one) and copy the filesystem(s)
-   copy the filesystem(s) using temporary storage devices (external
    HDDs, DVDs...)
-   transfer over network (using a live system on the new pc?)
-   consider that you might need adapters (PATA->SATA, USB-HDD-Cases,
    etc.) and choose a fast connection (or prepare for long copy times)
-   command for making an identical copy of the original filesystem: see
    Disk Cloning

Update fstab

-   using /dev paths: this should change depending on how the new drives
    are connected to the mainboard, on the BIOS and on the new
    partitions scheme
-   using fs labels: should be safe
-   using UUIDs

> Reconfigure the bootloader

-   because of:
    -   new HDD and partitions configuration
    -   new BIOS configuration

-   GRUB allows to edit entries with 'e'
-   use a live system?
-   update framebuffer mode (if new gpu)

> Regenerate kernel image

-   initially the Fallback image could work
-   regenerate image
    -   mkinitcpio -p linux

> Update the graphic drivers

-   if changed driver (e.g. from ATI to NVIDIA) can uninstall the old
    drivers

> Reconfigure audio

-   alsamixer volume
    -   save settings

> Reconfigure network

-   if need to change hostname:
    -   /etc/rc.conf
    -   /etc/hosts
    -   other apps using hostname: synergy, nut (network ups tools)
        -   "# grep -Ri 'hostname' /etc" should give some hints on the
            files to be updated

See also
--------

-   Disk Cloning
-   Migrating Between Architectures Without Reinstalling
-   Moving an existing install into (or out of) a virtual machine

Retrieved from
"https://wiki.archlinux.org/index.php?title=Migrate_installation_to_new_hardware&oldid=240020"

Categories:

-   Getting and installing Arch
-   System recovery
