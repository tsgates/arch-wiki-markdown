Tvcard
======

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setting up Winfast 2000XP Tvcard                                   |
|     -   1.1 Finding the right card number                                |
|     -   1.2 Finding the right Tuner number                               |
|                                                                          |
| -   2 TLG2300                                                            |
| -   3 Other External Helpful Links                                       |
+--------------------------------------------------------------------------+

Setting up Winfast 2000XP Tvcard
--------------------------------

Tvcards are all very similar to setup. This document shows you how to
setup a "Winfast 2000XP Tvcard". Other cards should be similar, and
should follow the same basic premise.

Edit the /etc/modules.conf file Add in:

    #
    # /etc/modprobe.d/modprobe.conf (for v2.6 kernels)
    # card ...... that setting is "34"
    # tuner ..... that setting is "43"

    alias char-major-81     bttv
    options bttv card=34
    options bttv tuner=43 

Reboot and it should now work with kdetv or tvtime.

> Finding the right card number

Below is a list of cards and their respective numbers

    0 - AutoDetect
    1 - MIRO PCTV
    2 - Hauppauge old
    3 - ST
    4 - Intel
    5 - Diamond DTV2000
    6 - AVerMedia TVPhone
    7 - MATRIX-Vision MV-Delta
    8 - Fly Video II
    9 - TurboTV
    10 - Hauppauge new (bt878)
    11 - MIRO PCTV pro
    12 - ADS Technologies Channel Surfer TV
    13 - AVerMedia TVCapture 98
    14 - Aimslab VHX
    15 - Zoltrix TV-Max
    16 - Pixelview PlayTV (bt878)
    17 - Leadtek WinView 601
    18 - AVEC Intercapture
    19 - LifeView FlyKit w/o Tuner
    20 - CEI Raffles Card
    21 - Lucky Star Image World ConferenceTV
    22 - Phoebe Tv Master + FM
    23 - Modular Technology MM205 PCTV, bt878
    24 - Askey/Typhoon/Anubis Magic TView CPH051/061 (bt878)
    25 - Terratec/Vobis TV-Boostar
    26 - Newer Hauppauge WinCam (bt878)
    27 - MAXI TV Video PCI2
    28 - Terratec TerraTV+
    29 - Imagenation PXC200
    30 - FlyVideo 98
    31 - iProTV
    32 - Intel Create and Share PCI
    33 - Terratec TerraTValue
    34 - Leadtek WinFast 2000
    35 - Chronos Video Shuttle II
    36 - Typhoon TView TV/FM Tuner
    37 - PixelView PlayTV pro
    38 - TView99 CPH063
    39 - Pinnacle PCTV Rave
    40 - STB2
    41 - AVerMedia TVPhone 98
    42 - ProVideo PV951
    43 - Little OnAir TV
    44 - Sigma TVII-FM
    45 - MATRIX-Vision MV-Delta 2
    46 - Zoltrix Genie TV
    47 - Terratec TV/Radio+ 

> Finding the right Tuner number

Below is a list of Tuners and their respective numbers.

    tuner=n type of tuner chip
    --------------------------------------------------------------

    tuner=0 Temic PAL (4002 FH5)
    tuner=1 Philips PAL_I (FI1246 and compatibles)
    tuner=2 Philips NTSC (FI1236,FM1236 and compatibles)
    tuner=3 Philips (SECAM+PAL_BG) (FI1216MF, FM1216MF, FR1216MF)
    tuner=4 NoTuner
    tuner=5 Philips PAL_BG (FI1216 and compatibles)
    tuner=6 Temic NTSC (4032 FY5)
    tuner=7 Temic PAL_I (4062 FY5)
    tuner=8 Temic NTSC (4036 FY5)
    tuner=9 Alps HSBH1
    tuner=10 Alps TSBE1
    tuner=11 Alps TSBB5
    tuner=12 Alps TSBE5
    tuner=13 Alps TSBC5
    tuner=14 Temic PAL_BG (4006FH5)
    tuner=15 Alps TSCH6
    tuner=16 Temic PAL_DK (4016 FY5)
    tuner=17 Philips NTSC_M (MK2)
    tuner=18 Temic PAL_I (4066 FY5)
    tuner=19 Temic PAL* auto (4006 FN5)
    tuner=20 Temic PAL_BG (4009 FR5) or PAL_I (4069 FR5)
    tuner=21 Temic NTSC (4039 FR5)
    tuner=22 Temic PAL/SECAM multi (4046 FM5)
    tuner=23 Philips PAL_DK (FI1256 and compatibles)
    tuner=24 Philips PAL/SECAM multi (FQ1216ME)
    tuner=25 LG PAL_I+FM (TAPC-I001D)
    tuner=26 LG PAL_I (TAPC-I701D)
    tuner=27 LG NTSC+FM (TPI8NSR01F)
    tuner=28 LG PAL_BG+FM (TPI8PSB01D)
    tuner=29 LG PAL_BG (TPI8PSB11D)
    tuner=30 Temic PAL* auto + FM (4009 FN5)
    tuner=31 SHARP NTSC_JP (2U5JF5540)
    tuner=32 Samsung PAL TCPM9091PD27
    tuner=33 MT20xx universal
    tuner=34 Temic PAL_BG (4106 FH5)
    tuner=35 Temic PAL_DK/SECAM_L (4012 FY5)
    tuner=36 Temic NTSC (4136 FY5)
    tuner=37 LG PAL (newer TAPC series)
    tuner=38 Philips PAL/SECAM multi (FM1216ME MK3)
    tuner=39 LG NTSC (newer TAPC series)
    tuner=40 HITACHI V7-J180AT
    tuner=41 Philips PAL_MK (FI1216 MK)
    tuner=42 Philips 1236D ATSC/NTSC
    tuner=43 Philips NTSC MK3 (FM1236MK3 or FM1236/F)
    tuner=44 Philips 4 in 1 (ATI TV Wonder Pro/Conexant)
    tuner=45 Microtune 4049 FM5 

TLG2300
-------

The TLG2300 is a device that supports analog and digital TV, also
includes and FM receiver. It's identified with the following device id:

    $ lsusb
    Bus 001 Device 007: ID 1b24:4001

The TLG2300 driver is called poseidon. It should be automatically
loaded, but you need to get the firmware first and put it under
/lib/firmware. The file is called tlg2300_firmware.bin and can be
obtained from the Windows drivers.

    user@machine:~$ stat /lib/firmware/tlg2300_firmware.bin 
      File: `/lib/firmware/tlg2300_firmware.bin'
      Size: 52748     	Blocks: 112        IO Block: 4096   regular file
    Device: 801h/2049d	Inode: 12820901    Links: 1
    Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)

To test the analog TV with VLC, /dev/video1 is the v4l video device in
my case, hw:1,0 is the audio output, NTSC standard, and the frequencies
are obtained from mplayer/stream/frequency.c file.

    vlc v4l2:///dev/video1  :input-slave=alsa://hw:1,0 :v4l2-standard=3 :v4l2-tuner-frequency=513250

If you put this on your .asoundrc:

    pcm.telegent {
    	type hw
    	card 1
    }

You will be able to use

    vlc v4l2:///dev/video1  :input-slave=alsa://telegent :v4l2-standard=3 :v4l2-tuner-frequency=513250

To add several channels you can create a play list with all the
frequencies, and use Next and Previous to change through them.

Other External Helpful Links
----------------------------

http://tldp.org/HOWTO/BTTV/modprobe.html

http://www.linuxtv.org/v4lwiki/index.php/Leadtek_WinFast_2000

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tvcard&oldid=225288"

Category:

-   Other hardware
