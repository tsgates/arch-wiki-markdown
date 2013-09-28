HP Compaq NX6325
================

This article describes specific steps to configure hardware on the
notebook model HP Compaq NX6325.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Wireless                                                           |
| -   2 Power management                                                   |
| -   3 Audio                                                              |
|     -   3.1 Multimedia keys                                              |
|                                                                          |
| -   4 Video                                                              |
|     -   4.1 Xorg.conf                                                    |
|                                                                          |
| -   5 Fingerprint, card slots, etc.                                      |
+--------------------------------------------------------------------------+

Wireless
========

The Compaq nx6325 has the BCM4311 or BCM4312 wireless chipset. The b43
drivers that come with the latest kernel will get these to work. The
b43-firmware package must also be installed from the AUR. Details can be
found here

Power management
================

NOTE: All and any of these are optional. Laptop Mode Tools and Acpid are
highly advised.

Laptop Mode tools with a combination of Cpufreq, acpi and pm-utils will
work on this notebook. Thorough installation and configuration
instructions for each tool can be found:

-   Laptop Mode Tools
-   CPU Frequency Scaling (may not be required)
-   Acpid
-   Pm-utils

Audio
=====

Sound works fine, just follow the ALSA how-to. For a more complete
solution (with greater options) consider installing pulseaudio.

Multimedia keys
---------------

A modern Desktop Environment will take care of this Automatically.
However to manually enable the multimedia keys (volume up/down/mute),
create a file .Xmodmap in your home directory, add the following lines:

    keycode 160 = XF86AudioMute
    keycode 176 = XF86AudioRaiseVolume
    keycode 174 = XF86AudioLowerVolume

and restart X.

Video
=====

The free xf86-video-driver driver works perfectly for the Radeon Xpress
200M that ships with the nx6325. The proprietry catalyst driver no
longer works for this card, support has been dropped.

Xorg.conf
---------

Xorg now automatically takes care of the Xorg configuration. No
xorg.conf is needed, however if one is presented it will attempt to load
it.

For troubleshooting or setting up a complicated environment, refer to
Xorg

Fingerprint, card slots, etc.
=============================

The multi-card reader work out-of-the-box with the latest kernel.

The Authentec fingerprint reader works with the installation and
configuration of fprint

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Compaq_NX6325&oldid=196624"

Category:

-   HP
