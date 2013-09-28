Ivman HowTo
===========

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Depend on HAL,   
                           and last release time is 
                           2007.2.5 (Discuss)       
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
| -   4 Troubleshooting                                                    |
|     -   4.1 Check if HAL detects                                         |
|     -   4.2 Run Ivman in debug mode                                      |
|                                                                          |
| -   5 Other Resources                                                    |
+--------------------------------------------------------------------------+

Introduction
------------

This document outlines the procedure needed to set up Ivman, a package
that provides support for automount. It provides the ability to have USB
Drives, CDs, floppies, and other removable media automatically mounted
when they are inserted.

Warning: This article uses software not in the official Arch Linux
repository.

Installation
------------

-   Install pmount (and Hal and Dbus which are dependencies)

    # pacman -S pmount

-   Install the ivman package from AUR.

Configuration
-------------

By default, Ivman will mount drives to /media/LINUXDEVICENAME. For
example your flash drive will mount as /media/sdb1. If you prefer to
have it mounted based on volume label:

-   Edit /etc/ivman/IvmConfigBase.xml, add the following before the
    </ivm:BaseConfig> line:

       <ivm:Option name="mountcommand" value="pmount -u 002 '$hal.block.device$' '$hal.volume.label$'" />

       <ivm:Option name="umountcommand" value="pumount '$hal.block.device$'" />

-   Ensure that hal and ivman are in DAEMONS in /etc/rc.conf
-   Reboot or run /etc/rc.d/hal start && /etc/rc.d/ivman start
-   Plug in a flash drive and check /media for the directories
-   When done with the drive, unmount with pumount /media/sdb1

Troubleshooting
---------------

> Check if HAL detects

Run hal-device or lshal -m to obtain debugging information on what
hal/ivman sees.

> Run Ivman in debug mode

Instead of running /etc/rc.d/ivman start, run ivman -d --nofork to view
debugging output.

Other Resources
---------------

-   AutoFS -- an alternative automount system.
-   Ivman -- another article on Ivman.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ivman_HowTo&oldid=204420"

Category:

-   File systems
