Savage
======

Related articles

-   Xorg

Savage is a video chipset that was manufactured by S3 and VIA. This
driver supports Savage, ProSavage and Twister chipsets.

Contents
--------

-   1 Xorg driver
    -   1.1 Installation
    -   1.2 Configuration
-   2 Framebuffer handling

Xorg driver
-----------

> Installation

If you already have installed Xorg you only need to install
xf86-video-savage from the Official repositories.

> Configuration

Create a configuration file in /etc/X11/xorg.conf.d/ named
99-savage.conf (or a name you prefer):

    # nano /etc/X11/xorg.conf.d/99-savage.conf

Paste following text and save the file:

    Section "Device"
            Identifier	"gfxcard"
            Driver		"savage"
    # You will likely have to use NoAccel.  You can try EXA, but it's likely you will end up
    # with a corrupted screen or a hard lockup.
            Option		"NoAccel" "True"
    # Use ShadowFB instead of acceleration.  It's unlikely that acceleration will provide
    # any benefits on this ancient chipset anyway.
            Option		"ShadowFB" "Enable"
    # The following two options might or might not improve performance.  Remove the "#" to
    # try using them:
    #       Option		"NoPciBurst" "Enable"
    #       Option		"FramebufferWC"
    # If Xorg crashes on startup (hangs with black screen) you may try out the following 
    # two lines (by removing the "#" before the line):
    #       Option		"NoDDC"
    # The 1024 in UseTiming is for a Notebook with a native resolution of 1024x768 pixel.
    # If you have a native resolution of 800x600 pixel you should use "UseTiming800" instead.
    #       Option		"UseTiming1024"
    # EXA might or might not work.  It's likely that it will not, but if you want to try it,
    # uncomment the following line and comment out the "NoAccel" option:
    #       Option         "AccelMethod" "EXA"
    EndSection
    Section "Screen"
            Identifier	"Screen 0"
            Device		"gfxcard"
            Monitor		"Monitor 0"
    # You can try setting DefaultDepth to 24, but many Savage cards only have 8MB of RAM
    # and may not be able to achieve higher resolutions with 24-bit color.
            DefaultDepth	16
    EndSection
    Section "Monitor"
            Identifier	"Monitor 0"
            Option		"DPMS" "Disable"
    EndSection

This decade-old chipset has little support and is likely better off
without acceleration. I included a few commented-out options which might
improve speed, but this configuration is likely to work as-is with any
supported Savage chip. It was tested using a Savage/IX.

Framebuffer handling
--------------------

Unfortunately, there is no framebuffer driver for the Savage chipset.
Your best bet is to set the framebuffer video mode by the vga kernel
parameter. For example, put vga = 0x314 at the end of your parameters
for an 800x600 framebuffer, or vga = 0x317 for a 1024x768 framebuffer.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Savage&oldid=301688"

Categories:

-   Graphics
-   X Server

-   This page was last modified on 24 February 2014, at 12:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
