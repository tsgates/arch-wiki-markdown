Poulsbo
=======

Related articles

-   Intel Graphics
-   Xorg
-   MPlayer

The Intel GMA 500 series, also known by it's codename Poulsbo or Intel
System Controller Hub US15W, is a family of integrated video adapters
based on the PowerVR SGX 535 graphics core. It is typically found on
boards for the Atom Z processor series. Features include hardware
decoding capability of up to 720p/1080i video content in various
state-of-the-art codecs, e.g. H.264.

As the PowerVR SGX 535 graphics core was developed by Imagination
Technologies and then licensed by Intel, the standard opensource Intel
drivers do not work with this hardware.

On this page you find comprehensive information about how to get the
best out of your Poulsbo hardware using Arch Linux.

Contents
--------

-   1 Kernel's gma500_gfx module
-   2 Modesetting driver and dual monitor Setup
-   3 Troubleshooting
    -   3.1 Poor video performance
    -   3.2 Fix suspend
        -   3.2.1 Old fbdev driver (default)
        -   3.2.2 modesetting xorg driver
    -   3.3 Set backlight brightness
    -   3.4 Memory allocation optimization
    -   3.5 SDL fullscreen viewport is too large/small
-   4 See also

Kernel's gma500_gfx module
--------------------------

With kernel 2.6.39, a new psb_gfx module appeared in the kernel
developed by Alan Cox to support Poulsbo hardware. As of kernel 3.3.rc1
the driver has left staging and been renamed gma500_gfx. ([1])

> Advantages

-   Native resolution (1366x768) with early KMS (tested on Asus Eee
    1101HA)
-   Up to date kernel and Xorg
-   2D acceleration
-   Works out of the box

> Disadvantages

-   Some are unable to get native resolution (e.g 1366x768)
-   No 3D acceleration possible
-   Poor multimedia performance (use mplayer with x11 or sdl so
    fullscreen video will be quite slow)

To check if the driver is loaded, the output of lsmod | grep gma should
look like this:

    gma500_gfx            131893  2 
    i2c_algo_bit            4615  1 gma500_gfx
    drm_kms_helper         29203  1 gma500_gfx
    drm                   170883  2 drm_kms_helper,gma500_gfx
    i2c_core               16653  5 drm,drm_kms_helper,i2c_algo_bit,gma500_gfx,videodev

Modesetting driver and dual monitor Setup
-----------------------------------------

To setup different resolution for external monitor using xrandr,
xf86-video-modesetting from official repo is needed. If you choose to
use the git package (xf86-video-modesetting-git), remember to recompile
it after a new version of Xorg. After installing, an Xorg file is needed
to setup the driver. Use this for device section:

    /etc/X11/xorg.conf.d/20-gpudriver.conf

     Section "Device"
        Identifier "gma500_gfx"
        Driver     "modesetting"
        Option     "SWCursor"       "ON" 
     EndSection

Note:The above configuration file will replace the xf86-video-fbdev
driver. If you want to revert back, just replace modesetting with fbdev.

Troubleshooting
---------------

> Poor video performance

If you have problems playing 720p and 1080i videos, yes, that's normal
while there are not accelerated XV drivers. But you can improve it up to
the point of going well and smoothly for most videos (even HD ones) with
these tricks:

1.  add pm-powersave false to /etc/rc.local. man pm-powersave for more
    info.
2.  use xf86-video-modesetting-git as indicated above.
3.  always use mplayer or any variant/gui. VLC and others are usually
    much more slower.
4.  When possible, Use multithreaded decoding with mplayer (Many Atom
    CPUs can) & framedropping
    mplayer -lavdopts threads=4 -framedrop yourvideofile.avi
5.  substitute the normal mplayer with mplayer-minimal-svn, and compile
    with aggressive optimizations:
    -march=native -fomit-frame-pointer -O3 -ffast-math'. (About makepkg)
6.  use linux-lqx as it is a very good performance kernel. Edit PKGBUILD
    so you can do menuconfig and make sure you select your processor and
    remove generic optimizations for other processors. (About kernels)

> Fix suspend

Old fbdev driver (default)

If suspend does not work, there are various quirk options you can try.
First, make sure that you have pm-utils and pm-quirks installed. See the
manpage for pm-suspend for a list of them all. One that has been
reported to help is quirk-vbemode-restore, which saves and restores the
current VESA mode.

To test it, open a terminal and use the following command

    # pm-suspend --quirk-vbemode-restore 

That should suspend your system. If you are able to resume, you'll want
to use this option every time you suspend.

    # echo "ADD_PARAMETERS='--quirk-vbemode-restore'" > /etc/pm/config.d/gma500 

If you are not able to resume and you get a black screen instead, try
the above quirk command with only one dash

    # pm-suspend -quirk-vbemode-restore 

If this also fails, you might try removing pm-utils's video resume
script, so that it's not run when you resume the machine.

    # cd /usr/lib/pm-utils/sleep.d
    # mv 99video ~

Tip: If you stuck with a black screen after resume, be aware that
besides the black screen, your system works fine. Instead of hard
rebooting, you could try to blindly reboot your system, since the last
thing you used before suspend was the terminal. Alternatively, if you
have ssh enabled on your machine you could do it remotely.

modesetting xorg driver

On some machines, when using modesetting driver the screen gets messed
up with random data. Although the computer still works, you must go to a
console and kill X or reboot "blindly". This is not optimal, so here is
a solution:

First, see your available screens and modes running xrandr:

     # xrandr
     Screen 0: minimum 320 x 200, current 1280 x 720, maximum 2048 x 2048
     LVDS-0 connected 1280x720+0+0 222mm x 125mm
       1280x720       60.0*+
     HDMI-0 connected 1280x720+0+0 531mm x 298mm
       1920x1080      60.0 +
       1680x1050      59.9  
       1680x945       60.0  
       1400x1050      74.9     59.9  
       1600x900       60.0  
       1280x1024      75.0     60.0  
       1440x900       75.0     59.9  
       1280x960       60.0  
       1366x768       60.0  
       1360x768       60.0  
       1280x800       74.9     59.9  
       1152x864       75.0  
       1280x768       74.9     60.0  
       1280x720       60.0* 
       1024x768       75.1     70.1     60.0  
       1024x576       60.0  
       832x624        74.6  
       800x600        72.2     75.0     60.3     56.2  
       848x480        60.0  
       640x480        72.8     75.0     60.0  
       720x400        70.1

Edit or create (giving executive permissions) /etc/pm/sleep.d/99xrandr,
writing the correct names and modes for your solution:

     #!/bin/sh
     #
     # turn off and on the screens so we force to clean video data
     case "$1" in
     hibernate|||suspend)
     xrandr --output LVDS-0 --off
     xrandr --output HDMI-0 --off
     ;;
     thaw|||resume)
     xrandr --output LVDS-0 --off
     xrandr --output HDMI-0 --off
     xrandr --output LVDS-0 --mode 1280x720
     /usr/local/bin/brillo-
     ;;
     *) exit $NA
     ;;
     esac

In my case, I turn off both screens, and turn on only the main screen
upon awakening. Feel free to customize to your needs. On some machines,
the screen turns on by default even when the system was put to sleep
with the screen turned off, so you need to turn it off twice.

Note: This only works if you call pm-suspend or pm-hibernate inside X.
If it is called from a daemon or a tty, it won't work.

> Set backlight brightness

All that is needed to set the brightness is sending a number (0-100) to
/sys/class/backlight/psblvds/brightness. This obviously requires sysfs
to be enabled in the kernel, as it is in the Arch Linux kernel. To set
display to minimal brightness, issue this command as root:

    # echo 0 > /sys/class/backlight/psb-bl/brightness

Or, for full luminosity:

    # echo 100 > /sys/class/backlight/psb-bl/brightness

A very short script is available to do this with less typing written by
mulenmar.

    #! /bin/sh
    sudo sh -c "echo $1 > /sys/class/backlight/psb-bl/brightness"

Simply save it as brightness.sh, and give it executable permissions.
Then you can use it like so:

Set brightness to minimum:

    ./brightness.sh 0

Set brightness to half:

    ./brightness.sh 50

Sudo may obviously ask for your password, so you have to be in the
sudoers file. A variation of this script can be found here.

Note:If changing /sys/class/backlight/psblvds/brightness does not work,
you may need to add acpi_osi=Linux acpi_backlight=vendor to your kernel
parameters. After rebooting, a new folder will appear under
/sys/class/backlight/; making changes to the brightness file in that
folder should work. For example, in some Asus netbooks the backlight can
be controlled by writing a value (0-10) to
/sys/class/backlight/eeepc-wmi/brightness.

> Memory allocation optimization

You can often improve performance by limiting the amount of RAM used by
the system so that there will be more available for the videocard. If
you have 1GB RAM use mem=896mb or if you have 2GB RAM use mem=1920mb.
Add them to your kernel parameters.

> SDL fullscreen viewport is too large/small

If X segfaults before you even have a SDL app running, see FS#35187: X
segfaults when starting a SDL app full-screen].

The Shuttle XS36VL computer has a VGA, HDMI and DVI-D port. For some
reason, xrandr sees some non-existing ports:

    $ xrandr -q
    Screen 0: minimum 320 x 200, current 1024 x 768, maximum 2048 x 2048
    VGA-0 connected 1024x768+0+0 (normal left inverted right x axis y axis) 337mm x 270mm
       1280x1024      60.0 +   75.0  
       1024x768       75.1     70.1     60.0* 
       832x624        74.6  
       800x600        72.2     75.0     60.3     56.2  
       640x480        72.8     75.0     66.7     60.0  
       720x400        70.1  
    LVDS-0 connected 1024x768+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
       1024x768       60.0*+
       960x720        60.0  
       928x696        60.1  
       896x672        60.0  
       800x600        60.0     60.3     56.2  
       700x525        60.0  
       640x512        60.0  
       640x480        60.0     59.9  
       512x384        60.0  
       400x300        60.3     56.3  
       320x240        60.1  
    DVI-0 disconnected (normal left inverted right x axis y axis)
    DisplayPort-0 disconnected (normal left inverted right x axis y axis)
    DVI-1 disconnected (normal left inverted right x axis y axis)
    DisplayPort-1 disconnected (normal left inverted right x axis y axis)

In the xrandr output, + means Preferred mode, * means the current mode.
In this case, only VGA-0 is really connected physically. LVDS-0 seems
rubbish as xrandr --output LVDS-0 --mode 640x480 has no effect on the
physical output. However, this configuration does affect the ability of
SDL (and other?) programs to display full-screen. To allow SDL programs
to display with a correct viewport, one has to disable the LVDS-0
output:

    $ xrandr --output LVDS-0 --off
    ...
    LVDS-0 connected (normal left inverted right x axis y axis)

    ...

After doing so, qemu -full-screen works for me.

See also
--------

-   An experience about configuring Poulsbo (Spanish)
-   Ubuntu Wiki
-   Ubuntu Forums
-   Ubuntu 12.04 gma500 (poulsbo) boot options (blog post)
-   Poulsbo Discussion in Arch BBS

Retrieved from
"https://wiki.archlinux.org/index.php?title=Poulsbo&oldid=290258"

Categories:

-   Graphics
-   X Server

-   This page was last modified on 24 December 2013, at 17:11.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
