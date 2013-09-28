Via Unichrome
=============

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Different Unichrome family display drivers                         |
|     -   1.1 The VIA proprietary drivers                                  |
|     -   1.2 The Xorg-driver                                              |
|     -   1.3 The Unichrome-driver                                         |
|     -   1.4 The OpenChrome driver                                        |
|         -   1.4.1 Troubleshooting                                        |
|         -   1.4.2 Hardware Specific                                      |
|             -   1.4.2.1 VIA Technologies, Inc. CN896/VN896/P4M900        |
|                 [Chrome 9 HC]                                            |
|                                                                          |
| -   2 Unichrome and OpenGL                                               |
| -   3 DPMS problems                                                      |
| -   4 Hangup on exit                                                     |
| -   5 External Resources                                                 |
+--------------------------------------------------------------------------+

Different Unichrome family display drivers
------------------------------------------

> The VIA proprietary drivers

These are considered unstable and insecure. They are however the only
way to get any form of 3D acceleration or even reliable modesetting on
certain chipsets, and can be installed using the via-chrome9-dkms,
xf86-video-via-chrome9 & via-chrome9-dri packages from the AUR.

> The Xorg-driver

The driver that comes with Xorg. Supports VIA CLE266, KM400/KN400,
K8M/N800, PM/N800 and CN400 chipsets. Accelerates 2D, 3D, Xvideo and
mpeg2 decoding using XvMC. Nowadays the Xorg-driver is mostly
unmaintained as the development focus is on OpenChrome-driver.

You can install the Xorg driver with command:

    pacman -S xf86-video-via

The xorg.conf driver name is via.

Just remember that this driver is no longer available in pacman repos.
You have to use AUR and ABS in order to install it: [1]

> The Unichrome-driver

Another driver with the development focus on stability and clean code.
Unichrome driver only supports CLE266, KM400, P4M800 and K8M800
chipsets. Does not support accelerated mpeg2-decoding.

You can install the unichrome driver with command:

    pacman -S xf86-video-unichrome

The xorg.conf driver name is via.

> The OpenChrome driver

The most advanced and developed driver for Unichromes. Supports CLE266,
KM400/KN400/KM400A/P4M800, CN400/PM800/PN800/PM880, K8M800,
CN700/VM800/P4M800Pro, CX700, P4M890, K8M890 and P4M900/VN896 chipsets.
Accelerates 2D, 3D, Xvideo and mpeg2 decoding using XvMC. This driver is
the way to go if you want to be on the bleeding edge.

You can install the OpenChrome driver with command:

    pacman -S xf86-video-openchrome

Troubleshooting

To enable any of the following options to fix issues, first create a new
file 10-openchrome.conf in /etc/X11/xorg.conf.d/:

    Section "Device"
        Identifier "My Device Name"
        Driver "openchrome"
    EndSection

If your X-Server shows artifacts and fails to redraw some windows, try
disabling the "EnableAGPDMA" option:

    Option     "EnableAGPDMA"               "false"

If your machine freeze at startup (GDM) or after login (slim), try
adding the XAA option "XaaNoImageWriteRect". Note that this only applies
if you are using the XAA acceleration method (configured by the
"AccelMethod" option). As of 0.2.906, the default acceleration method is
EXA.

    Option "XaaNoImageWriteRect"

If you experience significant CPU usage and low UI framerate, try
adding:

    Option "AccelMethod" "XAA"

Hardware Specific

VIA Technologies, Inc. CN896/VN896/P4M900 [Chrome 9 HC]

The EXA acceleration method may cause significant CPU usage and low UI
framerate. Refer to the "AccelMethod" option in the #Troubleshooting
section.

Unichrome and OpenGL
--------------------

OpenGL support for Via's graphic chipsets is seriously outdated. At the
moment you will not be able to run more fancy applications, games or
compositing desktops like Compiz Fusion that rely on OpenGL as a
backend, because the more recent OpenGL extensions are not yet supported
in Unichrome 3D driver. You will be able to run simple
OpenGL-applications though. The 3D driver for Unichrome is provided by
the the DRI project.

Install unichrome-dri, libgl and mesa -packages to get OpenGL to work.

DPMS problems
-------------

If you experience problems with DPMS not turning off laptop's backlight,
try adding:

    Option "VBEModes" "true"

to the device section of xorg.conf.

Hangup on exit
--------------

If your computer crashes when closing X, you may try not using vesa
driver for kernel console. Just delete the vga stuff from kernel line on
grub or append line on lilo.

External Resources
------------------

-   OpenChrome-project
-   Unichrome-project

Retrieved from
"https://wiki.archlinux.org/index.php?title=Via_Unichrome&oldid=255638"

Category:

-   X Server
