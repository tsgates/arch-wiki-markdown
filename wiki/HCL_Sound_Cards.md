HCL/Sound Cards
===============

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List (HCL)
  Full Systems
  Laptops - Desktops - Servers - Virtual Machines
  Components
  Video Cards - Sound Cards - Wired Net Adapters - Modems - Wireless Adapters - Monitors - Bluetooth Adapters - Printers - Scanners - TV Cards - Digital Cameras - Web Cameras - UPS - Floppy Drives - CD and DVD Writer/Readers - SCSI Adapters - Gadgets - SATA IDE Cards - Keyboards - Main Boards - RAID Controllers
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 ADI Onboard Sound Driver                                           |
|     -   1.1 Analog Devices ADI 198x Integrated Audio                     |
|                                                                          |
| -   2 Cirrus Logic                                                       |
|     -   2.1 CrystalClear SoundFusion Audio Accelerator                   |
|                                                                          |
| -   3 Creative Labs                                                      |
|     -   3.1 Audigy 2 ZS                                                  |
|     -   3.2 Audigy MP3+                                                  |
|     -   3.3 Audigy SE                                                    |
|     -   3.4 Live! 24-bit                                                 |
|     -   3.5 Sound Blaster 5.1                                            |
|                                                                          |
| -   4 INTEL Sound                                                        |
|     -   4.1 82801I (ICH9 Family) HD Audio Controller (rev 02)            |
|     -   4.2 82801H (ICH8 Family)                                         |
|                                                                          |
| -   5 REALTEK Sound                                                      |
|     -   5.1 Realtek High Definition Audio                                |
|                                                                          |
| -   6 Roland/Edirol                                                      |
|     -   6.1 Edirol UM2 USB Midi Interface                                |
+--------------------------------------------------------------------------+

ADI Onboard Sound Driver
========================

Analog Devices ADI 198x Integrated Audio
----------------------------------------

works on Dell Dimension 8400 out of the box with i686 Arch

Cirrus Logic
============

CrystalClear SoundFusion Audio Accelerator
------------------------------------------

Works out of the box (snd_cs46xx)

Creative Labs
=============

Audigy 2 ZS
-----------

Works out of the box

Audigy MP3+
-----------

Works out of the box (snd_emu10k1)

Audigy SE
---------

Works out of the box

Live! 24-bit
------------

Works out of the box

Sound Blaster 5.1
-----------------

Works out of the box

INTEL Sound
===========

82801I (ICH9 Family) HD Audio Controller (rev 02)
-------------------------------------------------

Works out of the box (module snd_hda_intel)

82801H (ICH8 Family)
--------------------

Works out of the box (Tested on MacBook Pro Rev3 with module
snd-hda-intel, module option model=mbp3)

REALTEK Sound
=============

Realtek High Definition Audio
-----------------------------

Did NOT work on the Toshiba Satelitte A135-S2276 Laptop

Roland/Edirol
=============

Edirol UM2 USB Midi Interface
-----------------------------

Works out of the box with the ALSA sequencer.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Sound_Cards&oldid=196370"

Category:

-   Hardware Compatibility List
