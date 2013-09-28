HP Pavilion ze5500
==================

  
 This install is written specifically with a HP Pavilion ze5570
notebook, however all notebooks in the series have pretty much the same
hardware. Manufactured in 2003 and 2004, the Pavilion 5500 series are
older computers but with some lovin' can do pretty well. It's got a
Pentium 4 so it's able to run Arch i686 (50786 chip technically but
really i686).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Specifications                                                     |
| -   2 Likes/Dislikes                                                     |
| -   3 Multimedia keys                                                    |
| -   4 Network                                                            |
| -   5 Touchpad                                                           |
| -   6 Video                                                              |
| -   7 Suspend                                                            |
| -   8 ACPID and CPU Frequency Scaling                                    |
| -   9 Post Install Thoughts                                              |
+--------------------------------------------------------------------------+

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
  Wireless     Broadcom BCM4306 802.11 b/g
  Sound        Sound Blaster Pro-compatible 16-bit
  Trackpad     Synaptics with dedicated vertical scroll
  Display      13.3 inch XGA TFT (1024x769)

Likes/Dislikes
--------------

What I like:

-   Video processor for being seven years old can still do most of what
    I want.
-   Battery life is good, I'm guessing about four hours.
-   Screen brightness, not quite of today's values but definitely has a
    good brightness.
-   Touchpad has a button for disabling/enabling... nice.
-   Disk drive - Using JFS works great and new hard drive. Also editing
    swap values helped out a bit.

What I dislike

-   Heavy - not quite like those old cell-phones though :).
-   Legacy power management.
-   Compositing with the open-source driver still needs work.

What doesn't work

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

Touchpad works great. However to get a nice clean setup (i.e. without
all the default [and crazy] options pre-set) you'll need a
configuration. Here is a full-optioned one.

Video
-----

ATi drivers suck. OK, that's harsh. Really like the open source effort
going in the the ATi drivers, but they just aren't running smooth yet
(2010-03-03). The catalyst drivers are broke and have been for some
time. With the open source drivers, composting is slow and have a few
other glitches, nonetheless they do alright if a couple options are
enabled in the config.

Suspend
-------

Broke (Suspend to RAM) and... probably will never be fixed. Tried every
pm-utils option I could think of, and all different modes of s2ram.
Hibernate does run well though, just put resume=/dev/your-swap-partition
in your /boot/grub/menu.lst and rebuild the kernel RAM disk (initrd)
with the resume hook. Also for my USB network card to resume following
hibernation I had to suspend the USB 1.0 module before hibernating:

    echo 'SUSPEND_MODULES="button uhci_hcd"' >> /etc/pm/config.d/config

ACPID and CPU Frequency Scaling
-------------------------------

To Do.

Haven't bothered with ACPID as KDE 4 has it's own event detection
implementation. Haven't got a chance to install CPU Frequency utilities.

Post Install Thoughts
---------------------

Good computer, maybe though KDE 4 might not be right for it. It does ok
but with the disk just crashed on there, it can have some bad hiccups at
times. I think it might actually be OK if I put more RAM in it (448MB
just isn't enough for KDE) will have to see, or if I could find a way to
lower system disk I/O amount (to allow better balance of system parts).
Nonetheless, liking it does ok, liking it very much.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_ze5500&oldid=196649"

Category:

-   HP
