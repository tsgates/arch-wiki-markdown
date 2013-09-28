HP Envy 14
==========

  

  ---------------- ------------------- -------------------
  Device           Status              Modules
  Intel            Working             xf86-video-intel
  AMD              Working             xf86-video-radeon
  Ethernet         Working             atl1c
  Wireless         Working             iwlagn
  Audio            Working             snd_hda_intel
  Touchpad         Working             
  Camera           Working             uvcvideo
  USB 3.0          Partially Working   xhci-hcd
  USB 2.0          Working             ehci-hcd
  eSATA            Working             
  Card Reader      Working             
  Function Keys    Working             
  Suspend to RAM   Working             
  ---------------- ------------------- -------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Configuration                                                      |
|     -   2.1 CPU                                                          |
|     -   2.2 Video                                                        |
|         -   2.2.1 Intel                                                  |
|         -   2.2.2 AMD                                                    |
|             -   2.2.2.1 Switching                                        |
|                                                                          |
|     -   2.3 Audio                                                        |
|         -   2.3.1 HDMI                                                   |
|                                                                          |
|     -   2.4 Touchpad                                                     |
|     -   2.5 Suspend to RAM                                               |
|     -   2.6 Webcam                                                       |
|     -   2.7 Function Keys                                                |
+--------------------------------------------------------------------------+

Hardware
========

CPU Intel Core i7 i7-2630QM (2 GHz Quad-core, 6 MB Cache,
hyperthreading, Turbo Boost (2.9 GHz))

Mainboard Intel HM65

RAM 8 GB (2x4GB)

Display 14.5" HD LED (1366x768)

Graphics adapter AMD Radeon HD 6630M, 1GB memory

Soundcard Intel HD Audio

Network Atheros Communications AR8151 v2.0 Gigabit Ethernet, Intel
Corporation Centrino Advanced-N 6230 Wireless

Hard disk 750 GB 7200rpm SATA

Webcam Quanta Computer, Inc.

Touchpad Synaptics ClickPad

Configuration
=============

This article is based on HP Envy 14 2090eo (LS782EA) model. Wireless
chip might be different on other regions.

CPU
---

Works out of the box. See CPU Frequency Scaling for more information on
power saving. Both cpufrequtils and cpupower work. Latter is recommended
for additional features.

Video
-----

This laptop has two graphics chips, one on the CPU and the other AMD
Radeon 6630M with dedicated 1 GB RAM.

Note: that the screen goes black after booting because the backlight is
disabled by default. Increase back light using shift-fn-f3 key
combination. After installing add command

    echo 1 > /sys/class/backlight/acpi_video0/brightness

to /etc/rc.local for turning the back light on automatically.

> Intel

After enabling using vga_swictheroo works perfectly. No Xorg
configuration needed.

> AMD

Radeon card is used by default. No Xorg configuration needed.

Switching

WIP, see Tackling the Switchable graphics

Audio
-----

Works out of the box.

> HDMI

Works out of the box. (Tested only with AMD graphics)

Touchpad
--------

Works out of the box.

Suspend to RAM
--------------

Works out of the box.

Webcam
------

Works out of the box.

Function Keys
-------------

Works out of the box, including keyboard back light activation
(shift-fn-f5).

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Envy_14&oldid=196625"

Category:

-   HP
