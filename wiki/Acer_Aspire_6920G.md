Acer Aspire 6920G
=================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Already covered  
                           by Beginners' guide.     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article will describe how to set up Arch Linux on an Acer Aspire
6920G.

Contents
--------

-   1 Hardware
-   2 Networking
    -   2.1 LAN
    -   2.2 Wireless
-   3 Multimedia Buttons
-   4 nVidia Warnings
-   5 Sound

Hardware
--------

There are several versions of this model, so there may be some variation
in hardware specs.

+--------------------------------------+--------------------------------------+
| Hardware                             | Description                          |
+======================================+======================================+
| Processor                            | Intel(R) Core(TM)2 DuoCPU T8300 @    |
|                                      | 2.40GHz                              |
+--------------------------------------+--------------------------------------+
| System Memory                        | 4GB DDR2 667 MHz                     |
+--------------------------------------+--------------------------------------+
| Graphic Card                         | NVIDIA® GeForce® 9500M GS with up to |
|                                      | 1280 MB of TurboCache™ (512 MB of    |
|                                      | dedicated GDDR2 VRAM, up to 768 MB   |
|                                      | of shared system memory              |
+--------------------------------------+--------------------------------------+
| Display                              | 16” Full HD 1920 x 1080 resolution,  |
|                                      | high-brightness (250- cd/m2) Acer    |
|                                      | CineCrystal™ TFT LCD, two lamps, 8   |
|                                      | ms high-def response time, 16:9      |
|                                      | aspect ratio                         |
+--------------------------------------+--------------------------------------+
| Sound Card                           | Intel High Definition Audio          |
|                                      | Controller                           |
+--------------------------------------+--------------------------------------+
| CD/DVD                               | Blu-Ray DVD±RW DL                    |
+--------------------------------------+--------------------------------------+
| Lan                                  | Attansic Technology Corp. Atheros    |
|                                      | AR8121/AR8113/AR8114 PCI-E Ethernet  |
|                                      | Controller                           |
+--------------------------------------+--------------------------------------+
| WLan                                 | Intel® Wireless WiFi Link 4965AGN    |
|                                      | (dual-band quad-mode                 |
|                                      | 802.11a/b/g/Draft-N)                 |
+--------------------------------------+--------------------------------------+
| WPan                                 | Bluetooth® 2.0+EDR (Enhanced Data    |
|                                      | Rate)                                |
+--------------------------------------+--------------------------------------+
| Webcam                               | Acer Crystal Eye webcam              |
+--------------------------------------+--------------------------------------+
| Touchpad                             | Synaptics PS/2 Port Touchpad         |
+--------------------------------------+--------------------------------------+
| I/O Interface                        | -   1 x ExpressCard™/54 slot         |
|                                      | -   1 x 5-in-one card reader: SD™    |
|                                      |     Card, MultiMediaCard, Memory     |
|                                      |     Stick®, Memory Stick PRO™ or     |
|                                      |     xD-Picture Card™                 |
|                                      | -   4 x USB 2.0 Ports                |
|                                      | -   1 x HDMI™ port with HDCP support |
|                                      | -   1 x Consumer infrared (CIR) port |
|                                      | -   1 x External display (VGA) port  |
|                                      | -   1 x RF-in jack                   |
|                                      | -   1 x Headphone/speaker/line-out   |
|                                      |     jack with S/PDIF support         |
|                                      | -   1 x Microphone-in jack, Line-in  |
|                                      |     jack                             |
|                                      | -   1 x Acer Bio-Protection          |
|                                      |     fingerprint solution             |
|                                      | -   1 x Modem: 56K ITU V.92          |
|                                      | -   1 x Acer CineDash media console  |
|                                      |     capacitive human interface       |
|                                      |     device                           |
|                                      | -   1 x 105-/106-key keyboard        |
|                                      |     English                          |
+--------------------------------------+--------------------------------------+

Networking
----------

> LAN

The LAN card should work out of the box with the current release
(2010.05 at time of writing).

> Wireless

See Wireless network configuration

Multimedia Buttons
------------------

Multimedia buttons can be configured using Keytouch, available in the
AUR.

For more information, see Keytouch

nVidia Warnings
---------------

The Acer Aspire uses a Geforce 9500M GS graphics card. As of the time of
writing, this can sometimes produce errors when returning to the TTY
while running X. While this bug has been reported, if you have more
information, please e-mail me at jsanchezsilvera[at]gmail[dot]com.

For information on installing and configuring nVidia drivers, visit the
NVIDIA wiki.

Sound
-----

The Acer Aspire 6920G seems to have a Realtek ALC889 chipset. By default
the sound card won't work.

For Alsa setup see ALSA.

edit /etc/modprobe.d/modprobe.conf and add the following line.

    options snd-hda-intel model=auto

Reboot and enjoy your multimedia.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_6920G&oldid=304916"

Category:

-   Acer

-   This page was last modified on 16 March 2014, at 09:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
