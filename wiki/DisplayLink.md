DisplayLink
===========

The following steps are the most recent ones that the DisplayLink
support guy was suggesting. I packaged the revisions in AUR, that
compiled and worked great so far. According to the Plugable information
they should work with almost every DisplayLink (DL-1**) device although
they don't suggest using their devices with Linux for production use for
now.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Load the framebuffer device                                  |
|     -   2.2 Update Xorg.conf                                             |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 X crashes or keeps blank                                     |
|     -   3.2 Cannot start in framebuffer mode. Please specify busIDs for  |
|         all framebuffer devices                                          |
+--------------------------------------------------------------------------+

Installation
------------

Install the packages `udlfb` and `xf86-video-fbdev-for-displaylink`.
Remember to remove any of them if already installed. The
`xf86-video-fbdev-for-displaylink` is originally a patched
`xf86-video-fbdev`, so you need to remove that one. Also keep the order
when installing.

-   UDLFB
-   xf86-video-fbdev

Configuration
-------------

These instructions assume that you already have an up and running X
server and are simply adding a monitor to your existing setup. You
should also have a knowledge of installing from the AUR and an active
internet connection.

> Load the framebuffer device

You installed the udlfb kernel module, but it has to be loaded in order
for the kernel to see the DisplayLink device. When loading make sure
that you activate the `fb_defio` flag.

    # modprobe udlfb fb_defio=1

At this point, if your monitor is connected, it should go from either a
black screen or the red-green-blue-checkers test pattern to a solid
green screen, indicating the framebuffer is loaded and ready for an
application to use it. You should also see a new device in /dev, likely
/dev/fb1.

To automatically load it at boot, udlfb and it´s parameters need to be
built into mkinitcpio. Therefore create or change the following conf
files:

    /etc/modprobe.d/udlfb.conf

    options udlfb fb_defio=1

    /etc/mkinitcpio.conf

    MODULES="... udlfb ..."
    FILES="/etc/modprobe.d/udlfb.conf"

Then, rebuild the kernel image:

    # mkinitcpio -p linux

For more information on this, see Mkinitcpio.

> Update Xorg.conf

You must update your xorg.conf in order to use your additional display.
When using the 710-S I was only able to use it if I set the DisplayLink
device as screen0 and my internal display as screen1. I do not know if
this is a common problem or just local to my setup.

Add this to the bottom of xorg.conf:

    ################ DisplayLink Stuff ###################
    Section "Device"
           Identifier      "DisplayLinkDevice"
           Driver          "fbdev"
           BusID           "USB"               # needed to use multiple DisplayLink devices 
           Option          "fbdev" "/dev/fb0"  # change to whatever device you want to use
    #      Option          "rotate" "CCW"      # uncomment for rotation
    EndSection

    Section "Monitor"
           Identifier      "DisplayLinkMonitor"
    EndSection

    Section "Screen"
           Identifier      "DisplayLinkScreen"
           Device          "DisplayLinkDevice"
           Monitor         "DisplayLinkMonitor"
           DefaultDepth    16
    EndSection

Then you can adjust your server layout to your needs. Well, almost.

Then edit your server layout to look something like this

    Screen		0	"DisplayLinkScreen"
    Screen		1	"Internal" RightOf "DisplayLinkScreen"
    Option		"Xinerama" "on"

Change Internal to whatever your main display is called. Reboot your
system and the two should be linked together!

Troubleshooting
---------------

> X crashes or keeps blank

If X crashes, or nothing shows up when you boot, try to start X only
using the external display

    Screen		0	"DisplayLinkScreen"
    #Screen		1	"Internal" RightOf "DisplayLinkScreen"
    #Option		"Xinerama" "on"

You may need to set your screen depths to be the same. Make sure that in
both Screen sections it is set to 16. (This is because xinerama require
that the screens use the same bitdepth)

    DefaultDepth	16

With fbdev this is not true anymore, because fbdev provides virtual
24bit support. Just use everything with DefaultDepth 24.

> Cannot start in framebuffer mode. Please specify busIDs for all framebuffer devices

I have not yet been able to correct this issue. It seems like it's an
incompatibility between fbdev and nvidia driver.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DisplayLink&oldid=206682"

Category:

-   Other hardware
