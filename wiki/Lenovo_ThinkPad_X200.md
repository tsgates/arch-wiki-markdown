Lenovo ThinkPad X200
====================

  Summary
  ---------------------------------------------------------------------------------
  This article covers the Arch Linux support for the Lenovo ThinkPad X200 laptop.

The Lenovo ThinkPad X200 is a wonderful high-quality laptop featuring a
12.1" widescreen WXGA monitor, an Intel Core 2 Duo processor (2.26 -
2.66GHz), an Intel Graphics Media Accelerator 4500MHD and up to 4GB of
RAM whilst still maintaining impressive battery life.

While Arch Linux is running flawlessly on this laptop there are a few
things you have to configure manually. This article will aid you in
configuring your system and will provide additionally hints to make your
ThinkPad X200 experience even better.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setup                                                              |
|     -   1.1 Wireless                                                     |
|     -   1.2 Graphics                                                     |
|     -   1.3 Audio                                                        |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Disable bluetooth at boot                                    |
|     -   2.2 Enable tap to select                                         |
|     -   2.3 Hard Disk Shock Protection                                   |
|     -   2.4 Mute button                                                  |
|     -   2.5 Power consumption and fan control                            |
|     -   2.6 Suspend to RAM                                               |
|                                                                          |
| -   3 Unsupported                                                        |
| -   4 Troubleshooting                                                    |
|     -   4.1 System feels unresponsive                                    |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Setup
-----

> Wireless

The ThinkPad X200 has a Intel PRO/Wireless 5100 AGN wireless adapter
included. In order to make it work you have to install the
iwlwifi-5000-ucode package when you install from a 2010.05 snapshot in
order to get the firmware, by now the package is included in the
linux-firmware package.

Now you can choose whatever network configuration programs you want to
use. If you do not already know which network manager you want to use,
we highly recommend netcfg.

If you experience connectivity problems such as a slow connection or
aborts, especially when connected to an (Enterprise) WPA2 network, then
try to load the iwlwifi module with the options 11n_disable=1,
11n_disable=2, swcrypto=1, bt_coex_active=0. There is no clear
recommendation which of these options to be used as for some users
11n_disable=1 already solves the problem sufficiently, for others
bt_coex_active=0. Thus, play around with each of them. Example:

    modprobe iwlwifi 11n_disable=2

If some of them work out for you, then make the options permanent by
creating the file /etc/modprobe.d/wireless.conf and adding the
following:

    options iwlwifi 11n_disable=2
    # Disable blinking LED wireless light 
    options iwlwifi led_mode=1

> Graphics

The graphics card is supported by the xf86-video-intel driver package
from the extra repository. The Xorg server makes use of this
automatically. There's no need for a Xorg configuration file.

    # pacman -S xf86-video-intel

> Audio

Audio is supported out of the box after installing the necessary alsa
packages from the core repository.

    # sudo pacman -S alsa-lib

See Alsa for more information.

Configuration
-------------

Note:Useful configuration settings and examples for an X200 are
maintained in this github repo.

> Disable bluetooth at boot

In order to disable bluetooth at boot you just need to add the following
line to a newly created /etc/tmpfiles.d/disable-bluetooth.conf file.
Please note, that there is no longer support for a /etc/rc.local file.

    w /proc/acpi/ibm/bluetooth - - - - disable

> Enable tap to select

You can enable the double click through tapping on your track point.
Create a /etc/tmpfiles.d/enable-tap-to-select.conf with the following
content:

    w /sys/devices/platform/i8042/serio1/press_to_select - - - - 1

> Hard Disk Shock Protection

The ThinkPad X200 comes with an integrated 2-axis accelerometer
providing the possibility of parking the hard drive's disk heads
preventing from data loss due to heavy shocks.

First you'll have to install tp_smapi and hdapsd from AUR. Then you have
to load the hdaps module provided by tp_smapi with the option invert=5
passed. This will correct the orientation of the accelerometer's axises.
If you are using systemd, create a file
/etc/modules-load.d/tp_smapi.conf with the following line:

    # Load tp_smapi at boot
    options tp_smapi invert=7

Then you need to start the hdapsd daemon:

    # systemctl enable hdapsd
    # systemctl start hdapsd

Now check your log files with journalctl if you see any
parking/unparking entries which indicate that hdapsd is successfully
configured.

For full information see: HDAPS

Note:If you experience parking / un-parking events when not moving your
hard disk, then you might use the wrong invert value. Install and run
hdaps-gl and check whether it shows your machine in the correct
orientation when turning the machine. If not, you need to change the
invert value. Alternatively to reloading the module you can also
directly write a value between 0 and 7 to
/sys/devices/platform/hdaps/invert.

> Mute button

If the mute button on your keyboard is not working, then be sure to add
acpi_osi="Linux" to your boot parameter in /etc/default/grub.

    GRUB_CMDLINE_LINUX_DEFAULT="quiet acpi_osi=Linux"

> Power consumption and fan control

You might notice a beeping whilst your system is running. This is due to
missing fan control. Install the tlp package from AUR to enable
extensive fan and power consumption control.

You can further disable the nmi-watchdog by creating the file
/etc/tmpfiles.d/disable-nmi-watchdog.conf with the following line:

    w /proc/sys/kernel/nmi_watchdog - - - - 0

This will disable the watchdog at startup.

Additionally you might want to define different brightness level and
automatically dim your screen when you are running on battery. A DE and
WM independent solution is the usage of pm-utils. Detailed instructions
can be found here. They are tested to work with a X200T.

> Suspend to RAM

Suspend to RAM is working out of the box with the standard Arch Linux
kernel after installing pm-utils from extra.

    # pacman -S pm-utils

Issue the command

    # pm-suspend

as root to suspend to RAM. The laptop will wake up on any key press or
on opening the lid.

Note: Very seldom after resuming the backlight won't come back on. The
following page on ThinkWiki might provide information on how to solve
this issue: Problem with display remaining black after resume.

Unsupported
-----------

Unlike those on older models, the fingerprint reader on the X200
("Authentec 2810") is unsupported on linux as there are no working
drivers either in the kernel or outside[1].

Troubleshooting
---------------

> System feels unresponsive

If your system feels unresponsive and lagging, you can try creating a
file called /etc/modprobe.d/drm_kms.conf:

    options drm_kms_helper poll=N

See also
--------

-   Thinkwiki: X200 Overview
-   ThinkWiki: How to reduce power consumption

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X200&oldid=255163"

Category:

-   Lenovo
