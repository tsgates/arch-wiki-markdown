Dell Latitude LS
================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page is a work in progress!

Contents
--------

-   1 Specifications
    -   1.1 LS500
-   2 Current Problems
-   3 Hardware
    -   3.1 NIC
-   4 Power Management
-   5 Links

Specifications
==============

LS500
-----

BIOS: A09

CPU: PIII-M 500MHz

RAM: 128MB

HDD: 30GB IBM Travelstar 4200RPM (7GB Windows 2000, 23GB Arch)

PCMCIA Cards: None

Kernel: 2.6.24-ARCH

  

Current Problems
================

1.  HAL does not mount USB Storage devices
2.  Hard Disk will fail upon mounting when a soft-reboot has occured.
    Only solution so far is to hard-reboot.

  

Hardware
========

NIC
---

Works out of the box.

  

Power Management
================

Power management does not work out of the box as ACPI is unsupported on
this laptop but it does support APM.

    pacman -S apmd

Edit the DAEMONS line in /etc/rc.conf accordingly. You may also want to
edit /boot/grub/menu.lst and add the following to the kernel line:

    acpi=off apm=power_off nolapic noapic

Links
=====

-   Latitude LS - Ubuntu Wiki
-   Latitude LS Drivers/BIOS
-   Latitude LS Documentation
-   Latitude LS BIOS @ bay-wolf.com

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_LS&oldid=196583"

Category:

-   Dell

-   This page was last modified on 23 April 2012, at 12:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
