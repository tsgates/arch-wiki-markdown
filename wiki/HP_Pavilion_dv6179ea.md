HP Pavilion dv6179ea
====================

Work in progress, this might take a while - by Grimn

Currently using Arch Core Dump (2.6.23 kernel).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Arch Installation                                                  |
| -   2 Kernel                                                             |
| -   3 Touchpad                                                           |
| -   4 cpufreq                                                            |
| -   5 Sound                                                              |
| -   6 Wireless                                                           |
| -   7 Webcam                                                             |
| -   8 Quickplay buttons                                                  |
| -   9 Card Reader                                                        |
| -   10 Sensors                                                           |
+--------------------------------------------------------------------------+

> Arch Installation

I used the FTP method to install Arch and thus I thought it wouldn't
make much difference if I used 0.7.2 ISO, but guess what? It doesn't
work well!

Might be because of the kernel (2.6.16) since this laptop is really
picky when it comes to kernel version (as I'll explain later),
everything seems to be working alright until you start formating the
partitions you want, then it takes ages to just write a few blocks on
the disk!

So I strongly advise for everyone with these model (and this might be
true with all the dv6000t series as well) to use, at least, the 0.8beta1
ISO instead.

Apart from this detail, the installation went pretty smoothly.

> Kernel

If you use kernel older than 2.6.20 you'll need to use noacpi or
acpi=noirq parameters to boot.

> Touchpad

There isn't much to say, just follow the Touchpad_Synaptics entry.

> cpufreq

Section 2.1 of SpeedStep entry has pretty much what you need but notice,
as it's said in section 1 on the same entry, that since you're using
kernel >= 2.6.20 the speedstep_centrino module is redundant so just load
acpi_cpufreq instead.

Also I advise the use of "conservative" governor because it saves
battery since it will always stay on the lowest frequency supported
until the cpu use justifies an increase in it's frequency (it's a dual
core cpu so believe me, you won't need to have it always on max :)).

The values of min and max frequency should be:

    # valid freq suffixes: Hz, kHz (default), MHz, GHz, THz
     min_freq="1.0GHz"
     max_freq="1.83GHz"

> Sound

Works fine with the newer versions of alsa.

Also there's a problem with suspend2ram, as stated in stalwart's blog,
when waking up from suspend the sound form jack doesn't work anymore. I
haven't tested with the newer versions of alsa though.

> Wireless

Just follow section 2.1.6 of Wireless entry for drivers instalation and
then section 3 for setup.

> Webcam

OUTDATED! This stopped working after some updates (kernel I think)

You'll need uvcvideo module, once you have it and it's in use you'll see
a /dev/video0 entry in your system.

To test it use luvcview

    # luvcview -d /dev/video0 -f yuv

Or use ekiga.

> Quickplay buttons

If you use KDE this can be done easily, just go to Control Center ->
Regional & Accessibility -> Keyboard Layout and choose Hewlett-Packard
Pavillion ZT11xx layout and most of the QuickPlay buttons as well as fn
keys will work.

If you do not use KDE or want more information about keybinding just
check Gentoo's Wiki entry on Multimedia Keys, it's really helpful.

> Card Reader

Seems to work fine out-of-the-box.

> Sensors

sensors-detect detects 3 modules: i2c-i801, eeprom and coretemp but
Ksensors only has 2 coretemp entries (concerning the cpus) but no
sensors are detected.

Still trying to get it working properly.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_dv6179ea&oldid=196640"

Category:

-   HP
