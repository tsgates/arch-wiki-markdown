Acer Aspire 6920G
=================

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article will describe how to set up Arch Linux on an Acer Aspire
6920G.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Networking                                                         |
|     -   2.1 LAN                                                          |
|     -   2.2 Wireless                                                     |
|                                                                          |
| -   3 Multimedia Buttons                                                 |
| -   4 nVidia Warnings                                                    |
| -   5 Sound                                                              |
+--------------------------------------------------------------------------+

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

To see which firmware you need to install, use

    dmesg | grep -i net

Then install the firmware with

    # pacman -S iwlwifi-3945-ucode

or

    # pacman -S iwlwifi-4965-ucode

For more info, see Wireless Setup

Multimedia Buttons
------------------

As for Multimedia Buttons, I will explain How to make them work using
Keytouch. I will share my config file incase you're lazy. xD .

See Keytouch

  

nVidia Warnings
---------------

If you look down, you can see and nVidia sticker wich says GeForce 9500M
GS. Now, I've been trying every nVidia driver version, but still they
all have one problem. When you're running X, you can't go back to the
tty's . It will just show a black screen, pressing ctrl+alt+f7 will get
you back to X Windows. I Tried to report this bug, but it's hard to be
listened on those forums. They're total chaos .

You can still enjoy those pretty 3D graphics!. (Please if you get to fix
this e-mail me at jsanchezsilvera[at]gmail[dot]com) .

For Installing and Configuration Instructions See Keytouch

  

Sound
-----

The Acer Aspire 6920G seems to have a Realtek ALC889 chipset. By default
the sound card won't work.

For Alsa setup see ALSA.

edit /etc/modprobe.d/modprobe.conf and add the following line.

    options snd-hda-intel model=auto

Reboot and enjoy your multimedia.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_6920G&oldid=196473"

Category:

-   Acer
