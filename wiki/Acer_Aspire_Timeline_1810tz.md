Acer Aspire Timeline 1810tz
===========================

Small howto for installing arch on the Acer Aspire Timeline 1810tz

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
|     -   1.1 lspci                                                        |
|                                                                          |
| -   2 Wireless                                                           |
| -   3 Wired                                                              |
| -   4 xorg                                                               |
|     -   4.1 Issues                                                       |
|     -   4.2 Extarkeys                                                    |
|                                                                          |
| -   5 KMS                                                                |
| -   6 Sound                                                              |
| -   7 Webcam                                                             |
| -   8 Powersaving                                                        |
|     -   8.1 powertop                                                     |
|     -   8.2 tmpfs                                                        |
|     -   8.3 noatime                                                      |
|     -   8.4 Fan-Control                                                  |
|                                                                          |
| -   9 Misc                                                               |
|     -   9.1 Keyboard in X                                                |
|     -   9.2 mplayer 1080p 720p                                           |
|                                                                          |
| -   10 External Resources                                                |
+--------------------------------------------------------------------------+

Hardware
========

-   Audio: Intel Corporation 82801I (ICH9 Family) HD Audio Controller
    (rev 03)
-   Video: Intel GMA 4500MHD
-   Processor: U4100 @ 1.30GHz
-   Wired: Atheros Communications Device 1063 (rev c0)
-   Wireless: Intel Corporation WiFi Link 1000 Series

lspci
-----

    00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
    00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
    00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
    01:00.0 Ethernet controller: Atheros Communications Device 1063 (rev c0)
    02:00.0 Network controller: Intel Corporation WiFi Link 1000 Series

Wireless
========

Detailed info found at Wireless Out of the box with Kernel ≥2.6.34.X.

Wired
=====

Out of the box with Kernel ≥2.6.32.X.

xorg
====

Detailed info found at Xorg

    pacman -S  xorg-server xorg xf86-input-synaptics xf86-input-keyboard xf86-video-intel 

> Issues

I was experiencing some problems with the Touchpad, it was becoming
unresponsive kind of laggy. Here is a forum thread that helped

    ~/.xinitrc

    xinput --set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Two-Finger Pressure" 280

Extarkeys
---------

To enable mute volume up and down do following

install xbindkeys

    pacman -S xbindkeys

    ~/.xbindkeysrc.scm

    (xbindkey '("XF86AudioMute") "amixer sset Master toggle")
    (xbindkey '("XF86AudioRaiseVolume")' "amixer set Master 2dB+ unmute")
    (xbindkey '("XF86AudioLowerVolume")' "amixer set Master 2dB- unmute")

autostart xbindkeys while starting X. I use the .xinitrc for this.

    ~/.xinitrc

    # keybindings 
    xbindkeys

KMS
===

Enable Intel KMS. This works quite nice.

Sound
=====

Detailed info found at Alsa

Webcam
======

Works out of the box

    mplayer tv:// 

I added !uvcvideo to rc.conf modules to prevent it from auto loading to
save power. Can be loaded by modprobe when needed.

Powersaving
===========

enable power saving wireless(add to /etc/rc.local)

    iwconfig wlan0 power on

powertop
--------

powertop can give some nice hints how to save power.

add to /etc/rc.local

    echo min_power > /sys/class/scsi_host/host0/link_power_management_policy
    echo 1500 > /proc/sys/vm/dirty_writeback_centisecs

tmpfs
-----

Stop writing logs and tmp stuff to the Hard-drive.

Warning: All logs will be gone after reboot

add to /etc/fstab

    none	/var/log	tmpfs	size=10M	0	0
    none	/tmp	tmpfs	size=100M	0	0
    none	/var/tmp	tmpfs	size=20M	0	0

noatime
-------

Added noatime to all my partitions in /etc/fstab to reduce hdd IO. This
is usually done when using an SSD but i think it can't harm if i also
use it on my normal Hard drive.

    /dev/sda3 / ext4 defaults,noatime 0 1

Fan-Control
-----------

Acerhdf [1] is a module you can load to control the fan-speed. Download
the latest version, unpack it and follow instructions in the readme
file. You probably need to add your bios-version in the config-file.
Your bios-version is in the error message when you load the module. Add
acerhdf in your rc.conf. If it doesn't work, you can also follow these
instructions: Acer_Aspire_One#acerhdf

Misc
====

Keyboard in X
-------------

Disable caps lock and set keyboard layout in X

    ~/.xinitrc

    # set german keyboard layout and disable caps lock
    setxkbmap -layout de -option ctrl:nocaps &&

mplayer 1080p 720p
------------------

-   720p: works out of the box
-   1080p: currently not working

Trying to get it to work:

-   Multithreaded mplayer aur/mplayer-mt-git does improve the situation
    but not solve the problem.
    -   mplayer -lavdopts threads=4 -vo gl2

-   aur/mplayer-coreavc-svn tries to install wine so I didn't test it
-   VA-API GPU Acceleration coming for GM45 around Q3 2010 [2].
    -   using aur/mplayer-vaapi mplayer -vo vaapi file should play the
        content with out a problem as soon as support arrives.

External Resources
==================

-   Linux Laptop
-   lesswatts.org
-   Ubuntu wiki
-   Timeline on Notebookcheck

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_Timeline_1810tz&oldid=228769"

Category:

-   Acer
