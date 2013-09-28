Acer Extensa 5200
=================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Basic informations about that laptop. Some parameters may be diffrent

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Kernel                                                             |
| -   3 Networking                                                         |
|     -   3.1 Wireless                                                     |
|                                                                          |
| -   4 Power Management                                                   |
|     -   4.1 ACPI                                                         |
|     -   4.2 CPU frequency scaling                                        |
|     -   4.3 Hibernate                                                    |
|                                                                          |
| -   5 Xorg                                                               |
| -   6 External Resources                                                 |
+--------------------------------------------------------------------------+

Hardware
========

Processor: Intel Celeron M 440 @ 1.86

Video: Intel Corporation Mobile 915GM/GMS/910GML Express Integrated
Graphics Controller (rev 03)

Audio: Intel Corporation 82801G (ICH7 Family) High Definition Audio
Controller (rev 02)

Wired NIC: Broadcom Corporation BCM4401-B0 100Base-TX Ethernet (rev 02)

Wireless NIC: Broadcom Corporation Dell Wireless 1390 Wlan Mini-PCI Card
(ref 01)

Kernel
======

On default kernel everything seems to be ok, but if you want to
hibernate you need kernel23-suspend2

Networking
==========

Ethernet works fine

Wireless
--------

For my Broadcom i use Ndiswrapper. Drivers are [here].

In the fact, you need only two files, bcmwl5.inf and bcmwl5.sys. You can
download it [here] , that's LESS THEN ONE MEGABYTE!!

Just install ndiswrapper

    # pacman -S ndiswrapper ndiswrapper-utils

Remove module from your existing kernel

    # rmmod bcm43xx

download and extract drivers and install them

    # wget http://cave0.tl.krakow.pl/~ert16/bcmwl5.tar.bz2
    # tar -jxf bcmwl5.tar.bz2
    # cd bcmwl5
    # ndiswrapper -i bcmwl5.inf

you can test driver by using

    # iwlist  wlan0 scan
    wlan0     No scan results

Power Management
================

ACPI
----

Just install acpid and acpitool

    #pacman -S acpid acpitool

and add it to daemons in /etc/rc.conf

    DAEMONS=( acpid )

now everything should work fine. After reboot you can check it by

    $ acpitool 
     Battery #1     : charged, 100.0%
     AC adapter     : on-line
     Thermal zone 1 : ok, 46 C
     Thermal zone 2 : ok, 46 C

CPU frequency scaling
---------------------

Works by default width KDE manager, but I preffer cpufreqd install
cpufreqd and cpufrqutils.

    #pacman -S cpufrequtils cpufreqd 

If you are using XFCE you may want plugin that shows your courrent cpu
frequency.

    #pacman -S xfce4-cpufreq-plugin

Now, load your kernel-module that will manage your cpu, for me this will
be p4_clockmod

    #modprobe p4_clockmod

check if it runs correctly

    #cpufreq-info
    cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
    Report errors and bugs to linux@brodo.de, please.
    analyzing CPU 0:
      driver: p4-clockmod
      CPUs which need to switch frequency at the same time: 0
      hardware limits: 233 MHz - 1.87 GHz
      available frequency steps: 233 MHz, 467 MHz, 700 MHz, 933 MHz, 1.17 GHz, 1.40 GHz, 1.63 GHz, 1.87 GHz
      available cpufreq governors: ondemand, conservative, performance
      current policy: frequency should be within 1.87 GHz and 1.87 GHz.
                      The governor "performance" may decide which speed to use
                      within this range.
      current CPU frequency is 1.87 GHz.

now, configure cpufreqd, that will change your cpufreq governor and
other settings when you plug out your AC, or your battery will be low.
Edit /etc/cpufreqd.conf and uncomment lines

    [acpi]
    acpid_socket=/var/run/acpid.socket
    [/acpi]

And make it quiet

    verbosity=0

If you want to change settings by cpufreqd-set, uncomment lines

    enable_remote=1
    remote_group=root

Now, you can lunch daemon up and check if it is working correctly

    #/etc/rc.d/cpufreqd start

If everything works change your system settings. Edit /etc/rc.conf, and
add module p4_clockmod to the list of preloaded modules

    MODULES=( p4_clockmod )

and add daemons to the list at the end of the file

    DAEMONS=( acpid cpufreqd  )

On XFCE right-click on you panel and add monitor to see informations
about your current CPU speed.

Hibernate
---------

Follow the manual about Suspend to Disk

After configuration uncomment

    Runi915resolution yes

Xorg
====

install 915resolution by

    pacman -S 915resolution

edit /etc/conf.d/915resolution and insert lines

    MODE="38"
    RESOLUTION="1280 800"

Add 915resolution to startup scripts in /etc/rc.conf

    DAEMONS=( 915resolution )

Before you start binding your special keys you need set keymap. My
keymap is Here. You need save it in the file, and load when you start
Xorg.

    xmodmap keymap

External Resources
==================

-   This report has been listed in the Linux Laptop and Notebook
    Installation Guides Survey: Acer.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Extensa_5200&oldid=196484"

Category:

-   Acer
