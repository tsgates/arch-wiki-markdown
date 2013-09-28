HDAPS
=====

This page describes how to install HDAPS on your Arch Linux
installation. HDAPS stands for "Hard Drive Active Protection System."
Its purpose is to protect your hard drive from sudden shocks (such as
dropping or banging your laptop on a desk). It does this by parking the
disk heads, so that shocks do not cause them to crash into the drive's
platters. Hopefully, this will prevent catastrophic failure.

Note:Obviously this only makes sense for hard drives that have
mechanical parts. If you are using a Solid State Disk (SSD) you do not
need HDAPS.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Shock Detection                                                    |
|     -   1.1 tp_smapi                                                     |
|     -   1.2 invert module parameter                                      |
|                                                                          |
| -   2 Shock Protection                                                   |
|     -   2.1 hdapsd                                                       |
|                                                                          |
| -   3 GUI Utilities                                                      |
|     -   3.1 gnome-hdaps-applet                                           |
|     -   3.2 khdapsmonitor                                                |
|     -   3.3 xfce4-hdaps applet                                           |
|     -   3.4 thinkhdaps A standalone GTK applet                           |
|     -   3.5 hdaps-gl                                                     |
|                                                                          |
| -   4 See Also                                                           |
+--------------------------------------------------------------------------+

Shock Detection
---------------

Your hardware needs to support some kind of shock detection. This is
usually in the form of an accelerometer built into your laptop's
motherboard. If you have the hardware, you also need a way to
communicate what the hardware is detecting to your operating system.
This section describes drivers to communicate the accelerometer's state
to the OS so it can detect and protect against shocks.

> tp_smapi

tp_smapi is a set of drivers for many ThinkPad laptops. It is highly
recommended if you have a supported ThinkPad, even if you do not plan to
use HDAPS. Among a plethora of other useful things, tp_smapi represents
the accelerometer output as joystick devices /dev/input/js# (Note! This
could interfere with other joystick devices on your system).

Install tp_smapi from the community repository. After installing, add
tp_smapi to a file /etc/modules-load.d/tp_smapi.conf, assuming you are
using systemd. After a reboot, this will activate most of the drivers,
represented through the /sys/devices/platform/smapi filesystem.

The kernel provides its own HDAPS drivers. Previously, it was necessary
to manually insmod the module via /etc/rc.local to prevent the default
drivers from being loaded. The tp_smapi package from community now
installs hdaps.ko to /lib/modules/$(uname -r)/updates, which will let it
supercede the built-in module. Thus, you can simply add hdaps to your
MODULES array.

Note:According to this bug report, certain ThinkPad laptops use
different firmware which tp_smapi does not support and is unlikely to
support in the near future. This includes the following series: Edge,
SL, L, X1xxe. Only one of these is listed in the "unsupported hardware"
page for the project, however, and that listing suggests that the x121e
should mostly work. I get the same error with the x121e listed at the
bottom of the bug report as a different and more fundamental problem,
though, so it may be that some models of the x121e are mostly supported
and others are entirely unsupported.

> invert module parameter

For some ThinkPads, the invert module parameter is needed in order to
handle the X and Y rotation axes correctly. In that case, you can add
the option in /etc/modprobe.d/modprobe.conf:

    options hdaps invert=1

invert=1 is an example value used for a ThinkPad T410. The invert option
takes the following values:

-   invert=1 invert both X and Y axes;
-   invert=2 invert the X axes (uninvert if already both axes inverted)
-   invert=4 swap X and Y (takes place before inverting)

Note that options can be summed. For instance, invert=5 swaps the axes
and inverts them. The maximum value of invert is obviously 7. If you do
not know which option is correct for you, just try them out with
hdaps-gl or some other GUI (see below). Alternatively, you can determine
the exact value for your thinkpad model from this table under the column
labelled "HDAPS axis orientation".

Shock Protection
----------------

Now that your hardware is reporting its shock detection to the OS, we
need to do something with this data. This section describes software
utilities to transform the sensor output into shock protection.

> hdapsd

hdapsd monitors the output of the HDAPS joystick devices to determine if
a shock is about to occur, then tells the kernel to park the disk heads.

Install hdapsd with pacman. Be sure to review /etc/conf.d/hdapsd to
ensure that it is protecting the correct hard drive.

When using systemd all you need to to is to enable and start the hdapsd
daemon.

    # systemctl enable hdapsd
    # systemctl start hdapsd

GUI Utilities
-------------

Utilities exist to monitor hdapsd's status so you know what is going on
while you are using your laptop. These are entirely optional, but very
handy.

> gnome-hdaps-applet

This is a GNOME panel applet (Note: XFCE can use GNOME panel applets)
that represents the current status of your hard drive. There is already
a PKGBUILD in AUR (see here). If you do not want to monitor sda or hda
by default, edit the PKGBUILD before compiling.

> khdapsmonitor

A KDE version exists as well. khdapsmonitor in AUR (This project was
abandoned and it is for KDE3). For KDE4 there is a version of plasmoid
for HDAPS monitoring HDAPS applet. HDAPS-Monitor plasmoid is available
in AUR.

> xfce4-hdaps applet

This is a Xfce4 panel applet that can represents the current status of
your hard drive. Available in AUR. After install, add this applet to a
panel.

> thinkhdaps A standalone GTK applet

A standalone GTK applet for HDAPS disk protection status. While running
will show applet icon in the notification area. Available in AUR.

> hdaps-gl

Simple OpenGL application showing the 3D animation of your Thinkpad.
Similar to the apllication Lenovo distributes with Windows. hdaps-gl is
available in AUR.

See Also
--------

-   How to protect the harddisk through APS at ThinkWiki
-   HDAPS at ThinkWiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=HDAPS&oldid=254341"

Category:

-   File systems
