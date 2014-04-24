HP Pavilion ze5500
==================

This install is written specifically with a HP Pavilion ze5570 notebook,
however all notebooks in the series have pretty much the same hardware.
Manufactured in 2003 and 2004, the Pavilion 5500 series are older
computers but with some lovin' can do pretty well. It's got a Pentium 4
so it's able to run Arch i686 (50786 chip technically but really i686).

Contents
--------

-   1 Specifications
-   2 What does not work
-   3 Multimedia keys
-   4 Network
-   5 Touchpad
-   6 Video
-   7 Suspend

Specifications
--------------

  Hardware     Description
  ------------ ----------------------------------------------------------------
  Processor    Mobile Intel Pentium 4 processor 2.66
  Memory       448 MB
  Video        ATi Mobility Radeon IGP 345M, 64MB Shared memory.
  Hard Drive   Fujitsu MHT2060A ATA 60GB
  CD Drive     Samsung SN-324F CDRW/DVD
  Ethernet     National Semiconductor DP83815 10/100 Mb/s Ethernet Controller
  Wireless     Broadcom BCM4306 802.11b/g
  Sound        Sound Blaster Pro-compatible 16-bit
  Trackpad     Synaptics with dedicated vertical scroll
  Display      13.3 inch XGA TFT (1024x769)

What does not work
------------------

Everything pretty much works with little or no configuration. The
wireless network card will require special firmware but everything else
pretty much works, and there are a few other exceptions:

-   Suspend to RAM: Fail. Legacy ACPI, so forget it. Hibernate,
    fortunately, does work.
-   Multimedia keys: Only four of eight register events.
-   Other keys: All regular keys work, but not some fn-combos (including
    numlock).

Multimedia keys
---------------

There was once a module (omnibook) and program (omke) that could enable
multi-media and other keys. However, with the 2.6.32 kernel they no
longer function... appear to not be updated anymore.

Network
-------

Ethernet card works just fine out of the box, however to get wireless
working you'll need to install Broadcoms' firmware
(b43-firmware-legacy).

Touchpad
--------

Touchpad works great.

Video
-----

See ATI.

Suspend
-------

Broke (Suspend to RAM) and... probably will never be fixed. Tried every
pm-utils option I could think of, and all different modes of s2ram.
Hibernate does run well though, just put resume=/dev/your-swap-partition
in your /boot/grub/menu.lst and rebuild the kernel RAM disk (initrd)
with the resume hook. Also for my USB network card to resume following
hibernation I had to suspend the USB 1.0 module before hibernating:

    echo 'SUSPEND_MODULES="button uhci_hcd"' >> /etc/pm/config.d/config

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_ze5500&oldid=304872"

Category:

-   HP

-   This page was last modified on 16 March 2014, at 08:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
