Via
===

Contents
--------

-   1 Different Unichrome family display drivers
    -   1.1 The VIA proprietary drivers
    -   1.2 The OpenChrome driver
        -   1.2.1 Troubleshooting
            -   1.2.1.1 Black screen when booting from LiveCD
-   2 Unichrome and OpenGL
-   3 DPMS problems
-   4 Hangup on exit
-   5 See also

Different Unichrome family display drivers
------------------------------------------

> The VIA proprietary drivers

These are considered unstable and insecure. They are however the only
way to get any form of 3D acceleration or even reliable modesetting on
certain chipsets, and can be installed using one of the following
packages from the AUR:

-   via-chrome9-dkms
-   xf86-video-via-chrome9
-   via-chrome9-dri

> The OpenChrome driver

The most advanced and developed driver for Unichromes. Supports CLE266,
KM400/KN400/KM400A/P4M800, CN400/PM800/PN800/PM880, K8M800,
CN700/VM800/P4M800Pro, CX700, P4M890, K8M890 and P4M900/VN896 chipsets.
Accelerates 2D, 3D, Xvideo and mpeg2 decoding using XvMC. This driver is
the only way to go if you want to be on the bleeding edge.

To get the OpenChrome driver, install the xf86-video-openchrome package.

The xorg.conf driver name is openchrome.

Troubleshooting

To enable any of the following options to fix issues, first create a new
file 10-openchrome.conf in /etc/X11/xorg.conf.d/:

    Section "Device"
        Identifier "My Device Name"
        Driver "openchrome"
    EndSection

If your X Server shows artifacts and fails to redraw some windows, try
disabling the EnableAGPDMA option:

    Option     "EnableAGPDMA"               "false"

If your machine freeze at startup (GDM) or after login (slim), try
adding the XAA option XaaNoImageWriteRect. Note that this only applies
if you are using the XAA acceleration method (configured by the
AccelMethod option). Since 0.2.906, the default acceleration method is
EXA.

    Option "XaaNoImageWriteRect"

If you experience significant CPU usage and low UI framerate, try
adding:

    Option "AccelMethod" "XAA"

Black screen when booting from LiveCD

If you experience a black screen when booting from Live-CD, add
modprobe.blacklist=viafb on the kernel command line.

Note:The nomodeset option will probably not work here.

After installing the system you will need to blacklist the viafb module.

Unichrome and OpenGL
--------------------

OpenGL support for Via's graphic chipsets is seriously outdated. At the
moment you will not be able to run more fancy applications, games or
compositing desktops like Compiz Fusion that rely on OpenGL as a
backend, because the more recent OpenGL extensions are not yet supported
in Unichrome 3D driver. You will be able to run simple
OpenGL-applications though. The 3D driver for Unichrome is provided by
the the DRI project.

Install unichrome-dri, mesa-libgl and mesa packages to get OpenGL to
work.

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

See also
--------

-   OpenChrome-project
-   Unichrome-project

Retrieved from
"https://wiki.archlinux.org/index.php?title=Via&oldid=303142"

Categories:

-   Graphics
-   X Server

-   This page was last modified on 4 March 2014, at 15:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
