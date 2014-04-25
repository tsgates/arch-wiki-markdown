Acer Aspire V5-573G
===================

  ----------------- -------------------- ----------------------
  Device            Status               Modules
  Intel graphics    Working              i965
  Nvidia graphics   Working, see below   nvidia, bumblebee
  Graphic outputs   Not working          nvidia, bumblebee
  Ethernet          Working              r8169
  Wireless          Working              ath9k
  Bluetooth         Working              ath3k
  Audio             Working              snd_hda_intel
  Touchpad          Working              xf86-input-synaptics
  Camera            Working              uvcvideo
  ----------------- -------------------- ----------------------

Contents
--------

-   1 Hardware
    -   1.1 Summary
    -   1.2 PulseAudio upmixing
    -   1.3 Shutdown issues
    -   1.4 Outputs
    -   1.5 Note

Hardware
--------

CPU: Intel(R) Core(TM) i5-4200U CPU @ 1.60GHz

Chipset: Intel Lynx Point

RAM: 8GB DDR3

Display: 15.6" IPS (1920x1080)

Graphics adapter: Intel HD Graphics 4400, NVIDIA GeForce GT750M

Soundcard: Integrated HDA

Network: Qualcomm Atheros AR9462 wireless, Realtek RTL8111/8168/8411
wired

Hard disk: TOSHIBA MQ01ABF0 SCSI, likely 5400RPM

Webcam: SuYin HD Webcam

Touchpad: Synaptics

Summary

Everything pretty much works out of the box, follow standard
documentation for details.

PulseAudio upmixing

If you do not have 4.0 sound sources, you may want to make PulseAudio
automatically upmix 2.0 to 4.0. To do this, add
default-sample-channels=4 to ~/.config/pulse/daemon.conf (create the
file if needed).

Shutdown issues

Some users have reported issues with shutting the laptop down correctly.
This issue doesn't affect my machine, likely because of a new hardware
revision. The issue is resolved as of kernel 3.13.

Outputs

VGA out works fine out of the box. Since the NVIDIA chip is wired to the
HDMI out, you can get this working using Bumblebee with
xf86-video-intel-virtual-crtc and hybrid-screenclone. See Bumblebee FAQ

Note

Most of this should also apply to the Acer Aspire V7-582PG and Acer
Aspire V7-582G - those are higher tier models of the same, confirmed to
be the same motherboard. Touchscreen wasn't tested on those.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_V5-573G&oldid=304893"

Category:

-   Acer

-   This page was last modified on 16 March 2014, at 09:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
