Lenovo Ideapad Y560
===================

The Lenovo Ideapad Y560 is a multimedia laptop available with several
different option packages. This wiki will focus on support for as many
variations as possible. At the time of writing, the Ideapad Y560 is
available with the following options:

CPU: Intel® Core™ i3-370M Processor ( 2.40GHz 1066MHz 3MB )

Intel® Core™ i5-460M Processor ( 2.53GHz 1066MHz 3MB )

Intel® Core™ i7-720QM Processor ( 1.60GHz 1333MHz 6MB )

Intel® Core™ i7-740QM Processor ( 1.73GHz 1333MHz 6MB )

Screen: 15.6” (1366×768) Widescreen

Memory: Up to 8GB ram

Graphics: ATI Mobility Radeon HD 5730

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Initial Installation                                               |
| -   2 Graphics                                                           |
|     -   2.1 Catalyst                                                     |
|     -   2.2 Radeon                                                       |
|                                                                          |
| -   3 Networking                                                         |
|     -   3.1 Wireless                                                     |
|     -   3.2 Ethernet                                                     |
|                                                                          |
| -   4 The Linux-Ideapad Kernel                                           |
| -   5 Sound                                                              |
| -   6 Touchpad                                                           |
+--------------------------------------------------------------------------+

Initial Installation
--------------------

Lenovo's default partitioning scheme thankfully included an extended
partition. Using a utility such as gparted, it is recommended to shrink
your windows partitions to at least half the size of the drive and
increase the extended partition to fill in the gap, then installing Arch
within new logical partitions inside. Installing the bootloader to
/dev/sda will allow it to boot into all of the operating systems, though
you will need to chainload windows (chainloader +1 boot option, see the
Beginner's Guide for an example).

Graphics
--------

The Lenovo Ideapad Y560's ATi 5730 graphics card works very well with
both the open-source Radeon driver and the proprietary Catalyst driver,
though there are minor performance differences to note:

Catalyst: Decent 2D performance, stock settings appear to work fine. 3D
acceleration performance is highest with this driver, though 2D
accelerated performance is not quite as good as the open-source driver.
Noticeable performance reduction in fullscreen video performance (both
applications such as VLC and web-based videos such as flash videos from
sites like YouTube.

Radeon: Superb 2D and 2D accelerated performance, as well as decent 3D
performance (though not as good as Catalyst). Fullscreen video is fine,
and image-rendering programs/GPU-intensive applications tend to work
well (with exception of 3D games, though this is under active
development and so may have changed since the writing of this article).

Both drivers support overclocking, though the benefit of doing so on the
Ideapad is negligible compared to the potential damage that can be done
to the system, as the card will idle at about ~50-60C and can easily
overheat due to the poor cooling system designed by Lenovo. [note:
Admiralspark]

> Catalyst

Taken from Catalyst

Note: As of 11/29/2012, the official repo's have the catalyst driver
included

To install the proprietary ATi graphics drivers, use:

    # pacman -S catalyst-dkms catalyst-utils

It remains to be seen what will be done when X.Org upgrades break the
driver.

  
 catalyst-daemon is the alternative package to install, and it will pull
in catalyst-utils as well, and will auto-recompile the kernel every time
it is updated.

Autofglrx will run every boot, taking ~40 milliseconds to check if the
module needs to be recompiled. This will preserve multiple fglrx modules
for multiple kernels.

Once installed, you will need to configure the xorg.conf. Fortunately, a
simple way to do this exists that will work with the 5730 without
modification:

    aticonfig --initial --input=/etc/X11/xorg.conf

Now reboot, and check operations with applications like glx-gears,
glxinfo, etc. See the main Catalyst article for reference and more
complete instructions.

> Radeon

Taken from ATI

The installation of the Radeon driver is quite simple:

    pacman -S xf86-video-ati

uDev will automatically load the correct driver, and no further xorg
configuration is necessary. However, there is a problem on our machines
with the default behavior of Radeon. The ATi driver will default to full
clock, or its highest speed setting. This will cause the machine to run
very hot, causing it to overheat and lock up/BIOS forced shutdown at
100C under any decent CPU load, as they share a single copper heatsink
that cannot cool both units fast enough. The solution is to use dynamic
clock speeds (much like the kernel's ondemand governor), which will keep
the GPU in a low-speed state until needed, also preserving battery life:

    # echo dynpm > /sys/class/drm/card0/device/power_method

You can also use a profile power method:

    # echo profile > /sys/class/drm/card0/device/power_method
    # echo auto > /sys/class/drm/card0/device/power_profile

This method appears to have better performance in some cases, though
dynpm works well in all but the highest-usage cases.

For HDMI audio on the Radeon driver, see Radeon#HDMI_Audio

Networking
----------

> Wireless

As of Kernel 3.2.x, wireless works out-of-the-box with the iwlwifi
driver.

> Ethernet

There is a bug in the kernel which causes the tg3 module to load before
broadcom, rendering the Intel Ethernet adapter useless. To fix, you will
need to change the following lines in your /etc/rc.conf:

    MODULES=(broadcom tg3)

Now the ethernet interface, eth0, should load without issue.

The Linux-Ideapad Kernel
------------------------

The linux-ideapad kernel is optimized for the Lenovo Y5xx laptops,
though it should work on any laptop that uses the same chipset as the
Ideapad. Includes all changes from the parent package by graysky
linux-ck, as well as:

-   Optimized for Intel Core2/i3/i5/i7 processors
-   BFQ I/O enabled by default
-   tun/tap driver for VPN use
-   1000MHz timer (reduced latency)
-   Low-latency preemptible kernel options
-   Networking filesystems: CIFS, NFS client/server As of version
    3.6.8-1, CFS is re-enabled
-   Filesystem support added for NTFS, EXT4, EXT3, EXT2, VFAT, iso9660,
    as well as USB mass storage devices
-   FUSE module for network filesystems
-   iwlwifi driver
-   broadcom/tg3
-   Ideapad rfkill switch support
-   Ideapad switchable graphics (non-i7 models that included the intel
    integrated graphics card with the ATi/nVidia)
-   other small tweaks for performance, constantly being updated.
    Suggestions should be left on the linux-ideapad page.
-   Many unused drivers switched on by default are disabled, reducing
    the final kernel size significantly

Sound
-----

ALSA works fine with the sound card, using the snd_hda_intel module.
However, uDev does not automatically mute the speakers when a headset is
plugged in, and will need to be scripted or done manually through
alsamixer. As of 11/29/2012, this issue has been corrected

Touchpad
--------

You will want to edit the /etc/X11/xorg.conf.d/10-synaptics.conf file,
as root, and replace the contents with the following options:

    Section "InputClass"
          Identifier "touchpad"
          Driver "synaptics"
          MatchIsTouchpad "on"
                 Option "TapButton1" "1"
                 Option "TapButton2" "2"
                 Option "TapButton3" "3"
                 Option "VertEdgeScroll" "on"
                 Option "VertTwoFingerScroll" "on"
                 Option "HorizEdgeScroll" "on"
                 Option "HorizTwoFingerScroll" "on"
                 Option "CircularScrolling" "on"
                 Option "CircScrollTrigger" "2"
                 Option "EmulateTwoFingerMinZ" "40"
                 Option "EmulateTwoFingerMinW" "8"
                 Option "CoastingSpeed" "0"
    EndSection

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_Ideapad_Y560&oldid=237334"

Category:

-   Lenovo
