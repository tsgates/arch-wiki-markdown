Trident
=======

Summary

This article describes the installation of the Xorg 2D acceleration
graphics driver and a framebuffer driver for Trident cards.

Related

Xorg

The Trident driver supports the accelerated video chipsets made by the
now-defunct Trident. It supports chips from the (Cyber)Blade, Image,
ProVidia and TGUI series. It also supports some ISA and VLB Trident
cards.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Xorg driver                                                        |
|     -   1.1 Installation                                                 |
|     -   1.2 Configuration                                                |
|                                                                          |
| -   2 Framebuffer driver                                                 |
|     -   2.1 Installation                                                 |
|     -   2.2 Configuration                                                |
|                                                                          |
| -   3 FAQ                                                                |
|     -   3.1 tridentfb does no longer work after a minor kernel update    |
|     -   3.2 The AUR package is not up to date - tridentfb cannot be      |
|         build with the current kernel                                    |
+--------------------------------------------------------------------------+

Xorg driver
-----------

> Installation

If you already have installed Xorg you only need to install
xf86-video-trident from the Official Repositories.

> Configuration

For some notebooks with trident cards installation instructions
including known-to-work xorg configurations are provided, so you may
want to search this wiki for your device first. If your device is not
listed, keep following this general guide.

Create a configuration file in /etc/X11/xorg.conf.d/ named
99-trident.conf (or a name you prefer):

    # nano /etc/X11/xorg.conf.d/99-trident.conf

Paste following text and save the file:

    Section "Device"
            Identifier	"gfxcard"
            Driver		"trident"
    # Options under this line may (or may not) improve performace
    # If you experience segmentation faults on attempting to log out of X, uncomment the
    # following option.  If you do, comment or remove the "AccelMethod" option.
    #       Option		"NoAccel" "True"
    #       Option		"ShadowFB" "Enable"
    #       Option		"NoPciBurst" "Enable"
    #       Option		"FramebufferWC"
    # If Xorg crashes on startup (hangs with black screen) you may try out
    # the following two lines (by removing the "#" before the line):
    #       Option		"NoDDC"
    # The 1024 in UseTiming is for a Notebook with a native resolution of 1024x768 pixel.
    # If you have a native resolution of 800x600 pixel you should use "UseTiming800" instead.
    #       Option		"UseTiming1024"
    # If Xorg still crashes at startup and the error 'Failed to load module "xaa"' is found
    # in /var/log/Xorg.0.log, remove the "#" in the following line to use EXA acceleration:
    #       Option         "AccelMethod" "EXA"
    EndSection
    Section "Screen"
            Identifier	"Screen 0"
            Device		"gfxcard"
            Monitor		"Monitor 0"
            DefaultDepth	16
    EndSection
    Section "Monitor"
            Identifier	"Monitor 0"
            Option		"DPMS" "Disable"
    EndSection

As trident cards a quite slow, using only 16 bit as color depth (see
DefaultDepth in the Screen Section) is a good idea to speed things up.
By only using 8 bit you can speed up things even more, but in my
expirence a lot of programs have problems with color conversion an
picture in my browser looked bit like Andy Warhol pictures. So you may
want to keep 16.

On my Notebook Xorg does not properly detect the native screen
resolution, which causes Xorg to crash. In the past adding "NoDDC" to
the driver section solved this problem, but as of 02.11.2012 I also have
to add "UseTiming1024". Make sure the number matches the native x
resolution of your display. For example I have a display with a
resolution of 1024x768, so I'm using "UseTiming1024". If you have for
example a resolution of 800x600, you would use "UseTiming800" instead.

I also added a few options which can improve speed, but commented it
out. You may want to try them out be removing the "#" at the begin of
the corresponding line.

Framebuffer driver
------------------

> Installation

A framebuffer driver called tridentfb is included in the kernel source,
but not include in the default Arch Linux kernel package. You could
recompile the kernel with tridentfb enabled, but much easier is
installing the tridentfb package from the AUR.

> Configuration

To configure the resolution to meet the native resolution of your screen
you need to create a configuration file in /etc/modprobe.d/. You can do
this for example by:

    # nano /etc/modprobe.d/tridentfb.conf

If you have a native resolution of 1024x768, you want to have a color
depth of 8 bit and a refresh rate of 60Hz you should use this as
configuration.

    options tridentfb mode_option=1024x768-8@60

The format is: mode_option=XRESxYRES-DEPTH@REFRESHRATE

It's also a good idea to include the module and the configuration file
in the initrd. To do this, you have to edit /etc/mkinitcpio.conf. Simply
add tridentfb to the MODULES="..." array and also
"/etc/modprobe.d/tridentfb.conf" to the FILES="..." array to also make
your configuration available in the initrd. Now run

    # mkinitcpio -p linux

to update your initrd. After every update of tridentfb you have to run
mkinitcpio, if you have tridentfb included in your initrd.

FAQ
---

> tridentfb does no longer work after a minor kernel update

If you have updateded you kernel from version 3.x.y to 3.x.(y+1) and
experience problems, just rebuild and reinstall the package. Also the
package has to be rebuild and reinstalled after major kernel updates.

> The AUR package is not up to date - tridentfb cannot be build with the current kernel

You have updated the kernel but the PKGBUILD has not been updated yet to
work with your current kernel? No problem! Only two numbers have to be
changed in the PKGBUILD to work with your kernel version: Change
pkgver=X.X to meet your kernel major version, for example to
"pkgver=3.6" for kernel 3.6.4 and also change the last entry of the
depends array to make tridentfb conflict with the linux kernel one
version higher then your current kernel. If you are using kernel 3.6.4
the new entry should look like: 'linux<3.7'

Retrieved from
"https://wiki.archlinux.org/index.php?title=Trident&oldid=236686"

Categories:

-   Graphics
-   X Server
