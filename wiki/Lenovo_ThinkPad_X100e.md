Lenovo ThinkPad X100e
=====================

  

Contents
--------

-   1 Live notes & install instructions
-   2 Preface
-   3 Configuration Notes
-   4 Known Issues
-   5 Pre-install
-   6 Installation Notes
    -   6.1 Partitioning (SSD Specific Notes)
    -   6.2 Filesystem creation (SSD Specific Notes)
    -   6.3 Arch Setup - Prepare Hard Drives
    -   6.4 Arch Setup - Select Packages
    -   6.5 Arch Setup - Configure System
        -   6.5.1 /etc/rc.conf
        -   6.5.2 /etc/fstab
    -   6.6 Arch Setup - Install Bootloader
-   7 First Boot - System update and configuration
    -   7.1 System updates and installation
    -   7.2 Wireless network device

Live notes & install instructions
---------------------------------

I've made good progress on getting the x100e working and all hotkeys are
working, it's stable. There are only a few issues that are still being
ironed out. I've been using gdocs for a scratch pad and if you want to
see the current status of my notes (rough as they are) see:
http://ethanschoonover.com/x100e

Note that once I iron things out (particularly on the power management
front) I'll do a bit of editing and post the final content here.

Preface
-------

The Lenovo Thinkpad x100e is the first netbook-form factor unit in the
Thinkpad series and makes an appealing Arch Linux laptop. Key features:

-   excellent keyboard
-   solid build quality
-   easily accessible system components (disk, ram, wifi/wwan PCI slots)
-   cheaply available wifi card upgrades (Intel 5100 for 5ghz N support,
    see caveats below)
-   WWAN card availability (can be ordered built in or purchased later,
    untested in this initial write up)

Possible negatives include:

-   The unit does run hot and ejects a steady stream of hot air from the
    left hand vents. The following write up does not yet include
    experiments with undervolting or fan/power control which may help
    address that issue.
-   Battery life is not “netbook” class. With a six cell 17+ battery
    (default when ordered) 2-3 hours are reasonable. With a three cell
    17 battery pack, the unit gets about 1.5 hours (at full brightness,
    wifi up, no power savings, max CPU speed, so this might change with
    later tweaking).

Configuration Notes
-------------------

This writeup was done based around a single x100e unit in two specific
configurations (two different wifi cards, noted below):

-   2GB RAM
-   40GB SSD (Intel X25-V)
-   no WWAN card
-   First wifi card: Realtek 8172 (working on 2.4GHz b/g/n)
-   Second wifi card: Intel 5100 agn (working on 2.4GHz and 5Ghz b/g/n
    but ‘n’ connections drop after 5 minutes at time of this writeup -
    Sept. 2010 - Intel is working on a fix and there is a stopgap
    workaround to turn off ‘n’ functionality)

Known Issues
------------

Prior to kernel 2.6.35 there were several issues that plagued Linux
installation on the x100e, including audio jack issues, wifi driver
problems, display issues.

Some of these remain but for the most part a straight Arch install with
kernel 2.6.35 or later on the x100e gets most things working almost
immediately. Wifi continues to need love and care to bring up
successfully, but once configured seems relatively reliable on both the
Realtek wifi card.

Thinkwiki reports that wifi should work out of the box on kernels
2.6.32-22.33 but this did not seem to be the case as of 2.6.35. Others
may have better success with out of the box support and if so please
note here.

If using the Intel 5100 agn wifi card (must be the lenovo part, FRU
43Y6517, as the BIOS detects non lenovo cards and will fail to boot) the
card will work out of the box 2.6.35 or later (possibly eariler kernels
as well, but those weren’t tested in this writeup).

Poweroff stalls unless clocksource-jiffies kernel parameter is set.
There may be other work arounds or kernel parameters that would address
this. noalpic-timer parameter also works but results in failure to bring
CPUs up to high res mode (though I assume jiffies prevents high res mode
too... out of my depth here and will be researching more).

Upon resume from suspend to ram, there are rare incidents of the
filesystem not mounting properly and being set to a read-only state due
to a journaling failure at the time of suspend. This seems to be
addressed in a patch submitted for inclusion in kernel 2.6.36-rc4. It is
unclear whether this is related to the x100e alone, the Intel X25-V
alone, or the specific combination of unit/drive. It is rare enough in
the installation described here that no steps have been taken to patch
ahead of expected availabilty of kernel 2.6.36.

Pre-install
-----------

For this successful installation, the net install ISO (2010.05, current
at time of initial writeup) was used. Many of the issues that the x100e
faced with 2.6 kernels have been addressed as of kernel 2.6.35. There is
no optical drive in the x100e so you’ll need to use a USB key or network
boot. See Putting installation media on a USB key or the Beginners'
guide for more details on booting off a USB key.

Installation Notes
------------------

Unless otherwise specificed, defaults were used throughout the Arch
setup process.

> Partitioning (SSD Specific Notes)

Note:The partitioning and disk related content below is not relevant
unless you are also using an SSD in this unit. If using a harddisk you
can just auto configure or manually configure if you feel confident that
you know what you're doing.

In this writeup, the Windows hard drive was removed and replaced with a
solid state disk (Intel X25-V 40GB). See the excellent Solid State
Drives article for details on how best to set up this drive. The working
procedure used was to manually partition the drive prior to entering the
Arch setup process. At the command line:

    # fdisk -H 224 -S 56 /dev/sda

The head and sector values are designed to align with the expected erase
block size of the SSD for optimal performance, but there are
alternatives. see the above linked SSD article for more details.

Four new primary partitions were created to the following
specifications. The root partition may be (likely is?) too large but
this was a first-time Arch install and bigger rather than smaller seemed
a safe bet.

    partition	purpose (to be assigned later)	type		size		fs type (later)
    1		/boot					83/Linux	+100M		ext2
    2		/					83/Linux	+18G		ext4
    3		swap					82/Linux	+2G		swap
    4		/home					83/Linux	remaining	ext4

> Filesystem creation (SSD Specific Notes)

The filesystem creation as follows for this example (stripe-width to
align to erase block size, as was the H/S specification for fdisk
above):

    # mke2fs -t ext2 stripe-width=32 -L boot /dev/sda1
    # mke2fs -t ext4 stripe-width=32 -L root /dev/sda2
    # mkswap-L swap /dev/sda3
    # mke2fs -t ext4 stripe-width=32 -L home /dev/sda4

Note that the labels as included here using the -L parameter are
optional but if set should then be automatically detected and applied to
the GRUB configuration. GRUB2 does not detect/apply these labels
automatically (defaulting to UUID).

> Arch Setup - Prepare Hard Drives

During the “Prepare Hard Drives” setup in Arch setup:

-   Manually configure block devices, filesystems and mount points
-   Setup will detect existing partitions, select “yes” to use as
    starting point
-   Select partitions in sequence and do not recreate filesystems
-   Match filesystem types to partitions along with intended mount
    points

Note:/etc/fstab will also need to be modified (see below) for optimal
SSD performance.

> Arch Setup - Select Packages

No additional packages need to be selected, though the “Wireless Tools”
package can be installed at this time. The Realtek wifi driver needs
special care and handling, and there will be some manual changes
required to get it working later.

> Arch Setup - Configure System

/etc/rc.conf

The only change needed during initial setup is hostname. There will be
some other modules added later.

/etc/fstab

Again, see the SSD article for more details on this. If using an SSD as
configured above, the follow ing fstab changes will optimize
performance/minimize writes:

    /dev/sda1 /boot ext2 defaults 0 1
    /dev/sda2 / ext4 defaults,noatime,discard 0 1
    /dev/sda3 swap swap defaults 0 0
    /dev/sda4 /home ext4 defaults,noatime,discard 0 2

> Arch Setup - Install Bootloader

GRUB or GRUB2 both work fine here. Keep it simple, go with GRUB unless
you have a specific need for GRUB2.

Continue with system configuration after rebooting from internal disk.

First Boot - System update and configuration
--------------------------------------------

> System updates and installation

Standard stuff. Get curl in preparation for AUR and the Realtek wifi
drivers if needed.

    # pacman -Syu
    # pacman -S curl

> Wireless network device

If you find that you can't make use of your wireless interface due to
the following error:

    # ip link set dev eth0 up
    SIOCSIFFLAGS: Operation not possible due to RF-kill

And you see the interface as "Hard blocked" by rfkill:

    # rfkill list
    0: phy0: Wireless LAN
            Soft blocked: no
            Hard blocked: yes

Try these steps:

1.  Reboot.
2.  When the ThinkPad splash appears, press Enter, then F1 to access the
    BIOS configuration interface.
3.  Go to Config > Network.
4.  Enable "Wireless LAN and WiMAX Radios".
5.  Press F10 and save changes.

Note:remainder ot content to be added asap after I complete testing,
formatting

Currently able to get power usage to under 12W with wifi *on*: [1]

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X100e&oldid=298173"

Category:

-   Lenovo

-   This page was last modified on 16 February 2014, at 07:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
