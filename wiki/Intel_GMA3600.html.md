Intel GMA3600
=============

Summary help replacing me

Information on Intel GMA3600 / GMA36500 CPU integrated graphics

> Related

Intel Graphics

Xorg

The Intel GMA 3600 series is a family of integrated video adapters based
on the PowerVR SGX 545 graphics core. It is used in the Atom N2600 and
Atom N2800.

Contents
--------

-   1 News
-   2 Kernel module driver
-   3 Xorg driver
-   4 Playing video
-   5 Cedarview-drm module port
-   6 See also

News
----

Intel release a graphics driver for PowerVR:
http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=21938

Be aware: The current version 1.03 (10/01/2012) has the following
dependencies:

Bundle "Ant"

    * Kernel: 3.0.0
    * Mesa GL: 7.9
    * Xorg: 1.9

Bundle "Bee"

    * Kernel: 3.1.0
    * Mesa GL: 7.11
    * Xorg: 1.11

This means, unleass you run a really outdated system this driver is
useless for Arch-Linux.

Kernel module driver
--------------------

Kernel has an experimental support for this adapter since v3.3. Since
Kernel v3.5 the GMA3600 power features are supported. Now suspend/resume
should properly work.

If after resume you got a blank screen try the following

    sudo touch /etc/pm/sleep.d/99video

Xorg driver
-----------

At the moment there is no accelerated driver for Xorg Server, but some
support is available using the Xorg modesetting driver:

    pacman -S xf86-video-modesetting

/etc/X11/xorg.conf.d/20-gpudriver.conf:

    Section "Device"
        Identifier "Intel GMA3600"
        Driver     "modesetting"
    EndSection

The modesetting driver allows disabling/enabling LVDS, VGA, etc. ports
and changing resolution using xrandr.

The following can be used to disable LVDS and force enable VGA if
needed.

/etc/X11/xorg.conf.d/20-gpudriver.conf:

    Section "Device"
        Identifier "Intel GMA3600"
        Driver     "modesetting"
        Option     "Monitor-LVDS-0" "Ignore"
        Option     "Monitor-VGA-0" "Monitor"
    EndSection

    Section "Monitor"
        Identifier "Ignore"
        Option     "Ignore"
    EndSection

    Section "Monitor"
        Identifier "Monitor"
        Option     "Enable"
    EndSection

Playing video
-------------

It is unable to utilize whole chip power and play fullHD movies using
graphics acceleration. As workaround you could utilize the maximum power
of your Atom CPU to decode video:

    mplayer -lavdopts threads=4 -fs myvideo.avi

Cedarview-drm module port
-------------------------

You can get around the Kernel 3.1.0 requirement from the package by
using the following git repository1 (thanks to thomas001):

     git clone https://github.com/thomas001/cedarview-drm.git cedarview-drm-master
     (Intended for Linux Kernel releases 3.7 to 3.9)

     git clone -b linux-3.5 https://github.com/thomas001/cedarview-drm.git
     (Intended for Linux Kernel releases 3.4 and 3.5)

Currently the following kernel versions are tested:

    * vanilla 3.7.8
    * vanilla 3.4.32 --- use linux-3.5 branch

You can either compile the module directly using a command like:

     make -C /lib/modules/`uname -r`/build M=`pwd` KMYDIR=`pwd`

or you employ DKMS:

     cp -r /path/too/cedarview-drm /usr/src/cedarview-drm-1.0.3
     dkms add cedarview-drm/1.0.3

Afterwards you have to build the module and maybe regenerate your
initramfs, as follows:

     mkinitcpio -p linux

See also
--------

-   https://www.change.org/en-GB/petitions/intel-listen-to-the-community-and-develop-gma3600-drivers-for-linux
-   http://ubuntuforums.org/showthread.php?t=1953734
-   http://communities.intel.com/message/158477

Retrieved from
"https://wiki.archlinux.org/index.php?title=Intel_GMA3600&oldid=266172"

Categories:

-   Graphics
-   X Server

-   This page was last modified on 14 July 2013, at 08:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
