Mach64
======

The Mach 64 chip is an old graphic accelerator developped by ATI. This
board has basic 3D capabilites. Its support on Linux is poor but exists.
This page is a walkthrough to setup Mach 64 graphics chipsets (including
ATI Rage Pro) and obtain direct rendering on some of them.

Contents
--------

-   1 Installing the basic features
-   2 3D acceleration and direct rendering
-   3 Configuration
-   4 Testing direct rendering

Installing the basic features
-----------------------------

2D and Xv acceleration in X can be achieved installing xf86-video-mach64
from the official repositories.

3D acceleration and direct rendering
------------------------------------

Warning:You may experience crashes if using the Mach 64 DRM module.
Direct rendering on Mach 64 is not very reliable because it never got
much support.

On Linux, the Mach 64 chip uses the DRI/DRM system for direct rendering.
The DRI part is available in the official repositories, but the DRM
module is not included in the mainline kernel. So we have to build it
separately. A package in the AUR simplifies this task: mach64drm.

As soon as the DRM module is built and installed, make sure you
installed the DRI part mach64-dri.

Configuration
-------------

Here is an example of X configuration for a Mach 64 chip (may not be
mandatory in all cases):

    Section "Device"
           Identifier  "Card0"
           Driver      "mach64"
           Card        "ATI Rage Pro - Mach64"
           Option "DMAMode" "async"
           Option "ForcePCIMode" "false"
           Option "AgpMode" "2"
           Option "AgpSize" "32"
           Option "BufferSize" "2"
           Option "LocalTextures" "true"
           # Uncomment the following option if X segfaults as soon as anything using acceleration is called.
           # Option "ExaNoComposite" "true"
           # The following line will also prevent segmentation faults, but is not recommended since
           # it will disable all acceleration.
           # Option "NoAccel" "true"
           # The following enables the shadow framebuffer, which improves non-accelerated performance.
           # Use only with the "NoAccel" option.
           # Option "ShadowFB" "true"
    EndSection

Details:

-   Driver: most important, allows you to use the mach64 driver.
-   DMAMode: async - default, sync (synchronous DMA), mmio (PIO/MMIO) -
    Dispatch Buffers.
-   ForcePCIMode: boolean, disables AGP aperture. Set to True if you
    have a PCI card.
-   AgpMode (AGP 1x or 2x): 1 or 2. If not set, defaults to agpgart's
    mode.
-   AgpSize: sets the AGP aperture in MB - The video card can access
    this amount of system memory using AGP and shared access in order to
    expand its memory capacity - enlarging this allows more textures to
    be stored here.
-   BufferSize: sets DMA buffer memory size in MB. Default is 2 MB. May
    be 1 or 2.
-   LocalTextures: boolean, by default, AGP cards will only use AGP
    memory for textures. To force using local card memory for textures
    in addition to AGP, you may set this option to true.

The AgpSize option changes the amount of system memory used for the AGP
aperture and is not limited by the size of the card's on-board video
memory. This memory is used for the DMA buffers BufferSize option), and
the remainder is allocated for AGP textures. Of course, the
AgpMode/AgpSize options are ignored for PCI cards or if ForcePCIMode is
enabled on an AGP card. However, the BufferSize option can be used to
change the size of the DMA buffers in system memory for both PCI and AGP
cards (but it's not recommended to reduce the buffer size unless you are
short on system RAM).

-   ExaNoComposite - Required to prevent segmentation faults in EXA
    handler.

The Modules Section:

    Section "Module"
           <Your modules>
           Load  "glx"
           Load  "dri"
    EndSection

The DRI Section:

    Section "DRI"
           Mode 0666 #allows anybody to use DRI
    EndSection

The DRI Section (For machines where security is a concern):

    Section "DRI"
           Group "video" #change to any desired group to restrict access
           Mode 0660
    EndSection

Testing direct rendering
------------------------

Restart X. After you are in X, you can run the command:

    $ glxinfo | egrep "direct rendering|OpenGL renderer"

This should return something like this:

    Direct rendering: Yes
    OpenGL renderer string: Mesa DRI Mach64 [Rage Pro] 20051019 AGP 2x x86/MMX/SSE

If OpenGL renderer string says "Software Rasterizer", DRI is not
working, even if direct rendering says "yes".

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mach64&oldid=258565"

Categories:

-   Graphics
-   X Server

-   This page was last modified on 24 May 2013, at 12:54.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
