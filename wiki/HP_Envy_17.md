HP Envy 17
==========

  

  ------------- ------------------- ------------------
  Device        Status              Modules
  Intel         Working             xf86-video-intel
  AMD           Not Working         
  Ethernet      Working             atl1c
  Wireless      Working             iwlwifi
  Audio         Partially Working   snd_hda_intel
  Touchpad      Working             synaptics
  Camera        Working             
  Card Reader   Working             rts5229
  ------------- ------------------- ------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Configuration                                                      |
|     -   2.1 Video                                                        |
|     -   2.2 Audio                                                        |
|     -   2.3 SD Card Reader                                               |
+--------------------------------------------------------------------------+

Hardware
========

  --------------------- -----------------------------------------
  CPU                   Intel Core i7-2670QM (2.2GHz Quad-core)
  RAM                   8 GB (2x4GB)
  Display               17.3" LCD
  Integrated Graphics   Intel HD 3000
  Discrete Graphics     AMD Radeon HD 7690 (1 GB)
  Sound                 Intel HD Audio
  Ethernet              Atheros AR8151 v2.0 Gigabit Ethernet
  Wireless              Intel Centrino Advanced-N 6235
  Hard Disk             750 GB 7200rpm SATA
  Touchpad              Synaptics ClickPad
  --------------------- -----------------------------------------

Configuration
=============

This is based on the 2012 HP Envy 17.

Video
-----

The intel graphics work fine out of the box. Unfortunately, the hybrid
graphics setup is muxless, so vgaswitcheroo won't work. There is some
work in progress towards getting the muxless AMD/Intel setup working.
Try here if you really need the hybrid graphics.

The proprietary driver has not been thoroughly tested.

Audio
-----

This can cause serious problems. By default, snd-usb-audio is loaded to
control the subwoofer. To circumvent this, append

    blacklist snd-usb-audio

to /etc/modprobe.d/audio.conf.

snd-hda-intel does not load automatically for a 5 channel setup. It must
be loaded with model=ref for the subwoofer to work. However, loading
with model=ref results in the internal speakers remaining on while
headphones are plugged in. To prevent this, snd-hda-intel must be loaded
with mode=auto. One example of how to deal with this is to append

    options snd-hda-intel model=auto

to /etc/modprobe.d/audio.conf. This will load the card without the
subwoofer, but with headphone muting at boot. In order to switch, force
unload the module (# rmmod -f snd-hda-intel) and reload it with the
other setting (e.g # modprobe snd-hda-intel model=ref). This has been
flagged as an upstream bug here.

SD Card Reader
--------------

As of 3.8 a third party module is not needed, device is accessible @
/dev/mmcX

The module for pre 3.8 rts5229 is in the AUR.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Envy_17&oldid=253194"

Category:

-   HP
