Digitenne
=========

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: kernel26         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page describes the procedure to watch encrypted DVB-T broadcasts in
the Netherlands

Contents
--------

-   1 Used Hardware
-   2 testing the DVB-T receiver
    -   2.1 Check device nodes
    -   2.2 Testing the DVB-T receiver with vlc
    -   2.3 Test the DVB-T receiver with tzap and mplayer
        -   2.3.1 Install mplayer and tzap
        -   2.3.2 Scan channels
        -   2.3.3 Tune the DVB-T receiver
        -   2.3.4 Play the captured datastream
-   3 Cardreader
    -   3.1 Plugin cardreader
    -   3.2 Install oscam from aur
    -   3.3 Oscam configuration
        -   3.3.1 /etc/oscam/oscam.conf
        -   3.3.2 /etc/oscam/oscam.server
        -   3.3.3 /etc/oscam/oscam.services
        -   3.3.4 /etc/oscam/oscam.user
    -   3.4 Starting Oscam
-   4 Softcam (sasc-ng)
    -   4.1 Install sasc-ng from aur
    -   4.2 Configure Sasc-ng
        -   4.2.1 /etc/conf.d/sasc-ng
        -   4.2.2 /etc/camdir/cardclient.conf
        -   4.2.3 /etc/rc.d/sasc-ng
    -   4.3 Starting Sasc-ng
    -   4.4 Testing Softcam with tzap and mplayer
    -   4.5 Expanding for 2 or more DVB-T tuners
-   5 VDR Integration
    -   5.1 VDR installation
    -   5.2 install vdr-plugin-sc-hg from aur
    -   5.3 VDR - oscam connection
        -   5.3.1 /var/lib/vdr/plugins/sc/cardclient.conf
    -   5.4 Scanning channels
    -   5.5 Watch TV
-   6 Mythtv Integration
    -   6.1 Mythtv-setup
        -   6.1.1 1. General
        -   6.1.2 2. Capture cards
        -   6.1.3 3. Video sources
        -   6.1.4 4. Input connections
        -   6.1.5 5. Channel Editor
        -   6.1.6 6. Storage Directories
        -   6.1.7 7. System events
    -   6.2 Start mythtv
-   7 References

Used Hardware
-------------

I use the following hardware:

-   PCTV NanoStick 73e SE (solo)
    http://linuxtv.org/wiki/index.php/Pinnacle_PCTV_nano_Stick_%2873e%29
-   smargo smartreader + https://www.cardwriter.nl/nl/pd1184675949.htm
-   Digitenne smartcard
-   1.6GHz P4 512MB ram

testing the DVB-T receiver
--------------------------

> Check device nodes

First check if the device nodes of the DVB-T receiver are present:

    $ ls -l /dev/dvb/adapter0/*
    crw-rw---- 1 root video 212, 4 May 15 10:21 /dev/dvb/adapter0/demux0
    crw-rw---- 1 root video 212, 5 May 15 10:21 /dev/dvb/adapter0/dvr0
    crw-rw---- 1 root video 212, 3 May 15 10:21 /dev/dvb/adapter0/frontend0
    crw-rw---- 1 root video 212, 7 May 15 10:21 /dev/dvb/adapter0/net0

> Testing the DVB-T receiver with vlc

Now use VLC to test the receiver:

    # pacman -S vlc

    $vlc
    Media -> Open Capture device,
    Capture mode : DVB
    Adapter card to tune: /dev/dvb/adapter0
    DVB type: DVB-T
    Transponder / multiplex frequency: 722000
    Bandwidth: auto => play

Now VLC will scan all channels, and after 10 minutes the first moving
image should appear on the screen.

If you do not have permission to open /dev/dvb/adapter0 then vlc will
issue the next errors:

    dvb access error: FrontEndOpen: opening device failed (Permission denied)
    main input error: open of `dvb://frequency=0000' failed: (null)

In that case add yourself to the group "video", and logout and login:

    # usermod -a -G video yourusername

> Test the DVB-T receiver with tzap and mplayer

Install mplayer and tzap

First install mplayer and tzap (part of linuxtv-dvb-apps)

    # pacman -S linuxtv-dvb-apps mplayer

Scan channels

Now scan the digitenne channels in the Netherlands:

    $ mkdir ~/.tzap
    $ scan /usr/share/dvb/dvb-t/nl-All -o zap | tee ~/.tzap/channels.conf
    scanning /usr/share/dvb/dvb-t/nl-All
    using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
    initial transponder 474000000 0 1 9 3 1 3 0
    initial transponder 474000000 0 2 9 3 1 3 0
    >>> tune to: 474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
    0x0000 0x044d: pmt_pid 0x1b62 Digitenne -- Nederland 1 (running)
    0x0000 0x044e: pmt_pid 0x1b6c Digitenne -- Nederland 2 (running)
    0x0000 0x044f: pmt_pid 0x1b76 Digitenne -- Nederland 3 (running)
    0x0000 0x0450: pmt_pid 0x1b80 Digitenne -- TV Rijnmond (running)
    0x0000 0x0457: pmt_pid 0x1bc6 Digitenne -- Radio Rijnmond (running)
    0x0000 0x0458: pmt_pid 0x1bd0 Digitenne -- Radio 1 (running)
    0x0000 0x0459: pmt_pid 0x1bda Digitenne -- Radio 2 (running)
    0x0000 0x045a: pmt_pid 0x1be4 Digitenne -- 3FM (running)
    0x0000 0x045b: pmt_pid 0x1bee Digitenne -- Radio 4 (running)
    0x0000 0x045c: pmt_pid 0x1bf8 Digitenne -- Radio 5 (running)
    0x0000 0x045d: pmt_pid 0x1c02 Digitenne -- Radio 6 (running)
    0x0000 0x045f: pmt_pid 0x1c16 Digitenne -- FunX (running)
    Network Name 'Digitenne'
    >>> tune to: 482000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
    WARNING: >>> tuning failed!!!
    ...

This yields the file ~/.tzap/channels.conf:

     Nederland 1:474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:7011:7012:1101
     Nederland 2:474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:7021:7022:1102
     Nederland 3:474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:7031:7032:1103
     TV Rijnmond:474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:7041:7042:1104
     Radio Rijnmond:474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7112:1111
     Radio 1:474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7122:1112
     Radio 2:474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7132:1113
     3FM:474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7142:1114
     Radio 4:474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7152:1115
     Radio 5:474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7162:1116
     Radio 6:474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7172:1117
     FunX:474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7192:1119
     Veronica/Disney XD:498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:3011:3012:31
     RTL 8:498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:3021:3022:32
     ��n:498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:3031:3032:33
     Ketnet/Canvas:498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:3041:3042:34
     Nickelodeon/TeenNick:498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:3051:3052:35
     Discovery Channel:498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:3061:3062:36
     Eurosport:498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:3071:3072:37
     Private Spice:498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:3081:3082:38
     Nederland 1:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:7011:7012:1101
     Nederland 2:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:7021:7022:1102
     Nederland 3:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:7031:7032:1103
     TV Noord-Holland:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:7041:7042:1104
     Radio Noord-Holland:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7112:1111
     Radio 1:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7122:1112
     Radio 2:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7132:1113
     3FM:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7142:1114
     Radio 4:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7152:1115
     Radio 5:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7162:1116
     Radio 6:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7172:1117
     FunX:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7192:1119
     Nederland 1:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:7011:7012:1101
     Nederland 2:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:7021:7022:1102
     Nederland 3:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:7031:7032:1103
     TV West:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:7041:7042:1104
     Radio West:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7112:1111
     Radio 1:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7122:1112
     Radio 2:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7132:1113
     3FM:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7142:1114
     Radio 4:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7152:1115
     Radio 5:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7162:1116
     Radio 6:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7172:1117
     FunX:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:7192:1119
     Eredivisie Live 1:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:2011:2012:21
     Eredivisie 2/AT5:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:2021:2022:22
     KinderNet/ComedyCentral:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:2031:2032:23
     MTV:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:2041:2042:24
     Animal Planet:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:2051:2052:25
     CNN:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:2061:2062:26
     BBC Entertainment:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:2071:2072:27
     NGC:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:2081:2082:28
     BNR Nieuwsradio:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:2172:217
     Arrow Classic Rock:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:2182:218
     Radio 538:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:2192:219
     SSU 1:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:6210
     SSU 2:762000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:6211
     RTL 4:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1011:1012:11
     RTL 5:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1021:1022:12
     RTL 7:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1031:1032:13
     SBS 6:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1041:1042:14
     NET 5:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1051:1052:15
     SLAM!FM:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:1112:111
     Radio 10 Gold:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:1122:112
     Q-Music:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:1132:113
     100%NL:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:1142:114
     Classic FM:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:1152:115
     Sky Radio:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:1162:116
     Radio Veronica:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:1172:117

Here we can see Digitenne uses 4 transports to broadcast all the
channels. This means it's possible to record all Digitenne channels with
only 4 DVB-T receivers. The receiver is in range of 3 transmitters for
Nederland 1, 2 and 3, the rest of the channels is received once:

    Transport 474 MHz, 618 Mhz, 722 MHz, 
    Nederland 1
    Nederland 2
    Nederland 3
    TV Rijnmond / TV Noord-Holland / TV West

    Transport 498 MHz:
    Veronica/Disney XD
    RTL 8
    Een
    Ketnet/Canvas
    Nickelodeon/TeenNick
    Discovery Channel
    Eurosport
    Private Spice

    Transport 762MHz:
    Eredivisie Live 1
    Eredivisie 2/AT5
    KinderNet/ComedyCentral
    MTV
    Animal Planet
    CNN
    BBC Entertainment
    NGC:

    Transport 818 MHz:
    RTL 4
    RTL 5
    RTL 7
    SBS 6
    NET 5

Tune the DVB-T receiver

Now the tuner can be set to Nederland 1

    $ tzap -a 0 -r 'Nederland 1'
    using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
    reading channels from file '/home/cedric/.tzap/channels.conf'
    tuning to 474000000 Hz
    video pid 0x1b63, audio pid 0x1b64
    status 1b | signal 0dbd | snr 0062 | ber 001fffff | unc 00000000 | FE_HAS_LOCK
    status 1b | signal 0d83 | snr 0063 | ber 00000000 | unc 00001e81 | FE_HAS_LOCK
    status 1b | signal 0d17 | snr 0069 | ber 00000000 | unc 00001ef6 | FE_HAS_LOCK

Play the captured datastream

Use another terminal to start mplayer. After a few seconds Nederland 1
should appear on the screen.

    $ mplayer /dev/dvb/adapter0/dvr0 
    MPlayer SVN-r33159-4.5.2 (C) 2000-2011 MPlayer Team
    162 audio & 359 video codecs
    mplayer: could not connect to socket
    mplayer: No such file or directory
    Failed to open LIRC support. You will not be able to use your remote control.

    Playing /dev/dvb/adapter0/dvr0.
    TS file format detected.
    VIDEO MPEG2(pid=7021) AUDIO MPA(pid=7022) NO SUBS (yet)!  PROGRAM N. 0
    VIDEO:  MPEG2  704x576  (aspect 3)  25.000 fps  15000.0 kbps (1875.0 kbyte/s)
    Load subtitles in /dev/dvb/adapter0/
    ==========================================================================
    Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
    Selected video codec: [ffmpeg2] vfm: ffmpeg (FFmpeg MPEG-2)
    ==========================================================================
    ==========================================================================
    Opening audio decoder: [mp3lib] MPEG layer-2, layer-3
    AUDIO: 48000 Hz, 2 ch, s16le, 160.0 kbit/10.42% (ratio: 20000->192000)
    Selected audio codec: [mp3] afm: mp3lib (mp3lib MPEG layer-2, layer-3)
    ==========================================================================
    AO: [oss] 48000Hz 2ch s16le (2 bytes per sample)
    Starting playback...
    Unsupported PixelFormat 61
    Unsupported PixelFormat 53
    Movie-Aspect is 1.78:1 - prescaling to correct movie aspect.
    VO: [vdpau] 704x576 => 1024x576 Planar YV12 
    A:22383.9 V:22383.9 A-V:  0.052 ct: -0.257 569/569  4%  3% 24.6% 3 0

Cardreader
----------

> Plugin cardreader

After the Smargo smartreader+ is inserted in the PC, dmesg should show a
new serial port (ttyUSB0) is added:

    $ dmesg
    [18014.724903] usb 2-1: new full speed USB device using uhci_hcd and address 4
    [18014.887673] ftdi_sio 2-1:1.0: FTDI USB Serial Device converter detected
    [18014.887788] usb 2-1: Detected FT232BM
    [18014.887794] usb 2-1: Number of endpoints 2
    [18014.887799] usb 2-1: Endpoint 1 MaxPacketSize 64
    [18014.887804] usb 2-1: Endpoint 2 MaxPacketSize 64
    [18014.887808] usb 2-1: Setting MaxPacketSize 64
    [18014.889396] ftdi_sio ttyUSB0: Unable to read latency timer: -32
    [18014.890893] usb 2-1: FTDI USB Serial Device converter now attached to ttyUSB0

> Install oscam from aur

https://aur.archlinux.org/packages.php?ID=45646

    # pacman -S cmake
    $ wget https://aur.archlinux.org/packages/oscam/oscam.tar.gz
    $ tar -xf oscam.tar.gz 
    $ cd oscam
    $ makepkg
    # pacman -U oscam-1.00-1-i686.pkg.tar.xz

> Oscam configuration

Oscam uses the following configuration files:

/etc/oscam/oscam.conf

    # main configuration
    [global]
    nice	      = -1
    WaitForCards  = 1

    # logging
    pidfile	      = /var/run/oscam.pid
    logfile	      = /var/log/oscam/oscam.log
    usrfile	      = /var/log/oscam/oscamuser.log
    cwlogdir      = /var/log/oscam/cw

    # monitor
    [monitor]
    port	      = 8988
    aulow	      = 120
    monlevel      = 1

    # web interface
    [webif]
    httpport       = 8888
    httpuser       = myusername
    httppwd        = mypassword
    httpallowed    = 192.168.31.201

    # protocols

    [newcamd]
    key            = 000102030405060708090A0B0C0D
    port           = 15050@0B00:0E030

/etc/oscam/oscam.server

    # reader configuration

    [reader]
    label    = reader1
    protocol = mouse
    detect   = CD
    device   = /dev/ttyUSB0
    group    = 1
    emmcache = 1,3,2
    services = services1
    caid     = 0B00
    mhz      = 500
    cardmhz  = 500

/etc/oscam/oscam.services

    # definition of services 
    #
    # format:
    # [name]
    # caid=CAID[,CAID]...
    # provid = provider ID[,provider ID]...
    # srvid = service ID[,service ID]...

    [services1]
    caid=0B00
    provid=0E030
    srvid=

/etc/oscam/oscam.user

    # user configuration

    [account]
    user       = user1
    pwd        = password1
    monlevel   = 0
    uniq       = 0
    group      = 1
    au         = 1
    ident 	   = 0B00:0E030
    caid       = 0B00

    # user for group 2 with monitor access, AU enabled

    #[account]
    user       = user2
    pwd        = password2
    monlevel   = 0
    uniq       = 0
    group      = 1
    au         = 1
    ident 	   = 0B00:0E030
    caid       = 0B00

Now create the directory where oscam can log to:

    # mkdir /var/log/oscam

> Starting Oscam

    # /etc/rc.d/oscam start

This should yield the following messages in /var/log/oscam.log:

    -------------------------------------------------------------------------------
    >> OSCam <<  cardserver started at Thu May 19 19:08:47 2011
    -------------------------------------------------------------------------------
    2011/05/19 19:08:47   1556 s   version=0.99.4svn, build #3146, system=i686-pc-linux, nice=-1
    2011/05/19 19:08:47   1556 s   max. clients=509, client max. idle=120 sec
    2011/05/19 19:08:47   1556 s   max. logsize=unlimited
    2011/05/19 19:08:47   1556 s   client timeout=5000 ms, fallback timeout=2500 ms, cache delay=0 ms
    2011/05/19 19:08:47   1556 s   shared memory initialized (size=4340618, id=229378)
    2011/05/19 19:08:47   1556 s   auth size=4772
    2011/05/19 19:08:47   1556 s   services reloaded: 0 services freed, 1 services loaded
    2011/05/19 19:08:47   1556 s   userdb reloaded: 0 accounts freed, 1 accounts loaded, 0 expired, 0 disabled
    2011/05/19 19:08:47   1556 s   signal handling initialized (type=sysv)
    2011/05/19 19:08:47   1556 s   can't open file "/etc/oscam/oscam.srvid" (err=2), no service-id's loaded
    2011/05/19 19:08:47   1556 s   can't open file "/etc/oscam/oscam.tiers" (err=2), no tier-id's loaded
    2011/05/19 19:08:47   1556 s   can't open file "/etc/oscam/oscam.provid" (err=2), no provids's loaded
    2011/05/19 19:08:47   1557 s   monitor: initialized (fd=7, port=8988)
    2011/05/19 19:08:47   1557 s   camd 3.3x: disabled
    2011/05/19 19:08:47   1557 s   camd 3.5x: disabled
    2011/05/19 19:08:47   1557 s   cs378x: disabled
    2011/05/19 19:08:47   1557 s   newcamd: initialized (fd=8, port=15050, crypted)
    2011/05/19 19:08:47   1557 s   CAID: 0B00
    2011/05/19 19:08:47   1557 s   provid #0: 00E030
    2011/05/19 19:08:47   1557 s   cccam: disabled
    2011/05/19 19:08:47   1557 s   radegast: disabled
    2011/05/19 19:08:47   1557 s   logger started (pid=1558)
    2011/05/19 19:08:47   1557 s   http started (pid=1559)
    2011/05/19 19:08:47   1559 h   HTTP Server listening on port 8888
    2011/05/19 19:08:47   1557 s   reader started (pid=1560, device=/dev/ttyUSB0, detect=cd, mhz=500, cardmhz=500)
    2011/05/19 19:08:47   1557 s   waiting for local card init
    2011/05/19 19:08:51   1557 s   init for all local cards done
    2011/05/19 19:08:51   1557 s   anti cascading disabled
    2011/05/19 19:08:51   1557 s   dvbapi: dvbapi disabled

Now insert the Digitenne smartcard in the cardreader. This should yield
the following messages in /var/log/oscam/oscam.log:

    2011/05/19 19:13:25   1560 r02 card detected
    2011/05/19 19:13:29   1560 r02 ATR: 3B 24 ** 30 42 30 30 
    2011/05/19 19:13:30   1560 r02 Maximum frequency for this card is formally 5 Mhz, clocking it to 5.00 Mhz
    2011/05/19 19:13:32   1560 r02 type: Conax, caid: 0B00, serial: 128****58, hex serial: 55****c6, card: v64
    2011/05/19 19:13:32   1560 r02 Providers: 1
    2011/05/19 19:13:32   1560 r02 Provider: 1  Provider-Id: 000000
    2011/05/19 19:13:32   1560 r02 Provider: 1  SharedAddress: 002A8**7
    2011/05/19 19:13:32   1560 r02 Package: 1, id: 1010, date: 2011/03/01 - 2011/03/31, name: Digitenne
    2011/05/19 19:13:32   1560 r02 [conax-reader] ready for requests

Softcam (sasc-ng)
-----------------

Sasc-ng and sascng-kernel26-patch are only needed for mythtv. VDR uses
vdr-plugin-sc-hg instead.

> Install sasc-ng from aur

First you need to install sascng-kernel26-patch:
https://aur.archlinux.org/packages.php?ID=48512

    $ wget https://aur.archlinux.org/packages/sascng-kernel26-patch/sascng-kernel26-patch.tar.gz
    $ tar -xf sascng-kernel26-patch.tar.gz 
    $ cd sasc-ng-kernel26-patch/
    $ makepkg
    # pacman -U sascng-kernel26-patch-2.6.39-2-i686.pkg.tar.xz

Then install sasc-ng: https://aur.archlinux.org/packages.php?ID=27885

    # pacman -S mercurial
    $ wget https://aur.archlinux.org/packages/open-sasc-ng/open-sasc-ng.tar.gz
    $ tar -xf open-sasc-ng.tar.gz
    $ cd open-sasc-ng
    $ makepkg
    # pacman -U open-sasc-ng-560-4-i686.pkg.tar.xz

> Configure Sasc-ng

/etc/conf.d/sasc-ng

    # Use -j <real>:<virtual> to link adapters
    SASCNG_ARGS="-j 0:1"
    DVBLOOPBACK_ARGS="num_adapters=1"
    LOGDIR="/var/log/"
    CAMDIR=/etc/camdir

/etc/camdir/cardclient.conf

    # Comment lines can start with # or ;
    #
    # every client line starts with the client name, followed by some arguments:
    # 'hostname' is the name of the server
    # 'port'     is the port on the server
    # 'emm'      is a flag to allow EMM transfers to the server
    #            (0=disabled 1=enabled)
    # 'caid'     (optional) caid on which this client should work
    # 'mask'     (optional) mask for caid e.g. caid=1700 mask=FF00 would allow
    #            anything between 1700 & 17FF.
    #            Default is 1700 & FF00. If only caid is given mask is FFFF.
    #            You may give multiple caid/mask values comma separated
    #            (e.g. 1702,1722,0d0c/ff00).
    # 'username' is the login username
    # 'password' is the login password
    #
    # newcamd client
    # 'cfgkey' is the config key (28bytes)
    newcamd:localhost:15050:1/0B00/FF00:user2:password2:000102030405060708090A0B0C0D

/etc/rc.d/sasc-ng

When the built-in logging is used it can happen that sasc-ng uses 100%
CPU. Then it can only be killed by

    # killall -s 16 sasc-ng. 

Disable therefore the internal logging like this: Now the messages of
sasc-ng end up in /var/log/everything.log

     #!/bin/bash
     
     . /etc/rc.conf
     . /etc/rc.d/functions
     
     [ -f /etc/conf.d/sasc-ng ] && . /etc/conf.d/sasc-ng
     
     PID=$(pidof -o %PPID /usr/sbin/sasc-ng)
     
     case $1 in
     start)
             stat_busy "Loading dvbloopback kernel module"
     
             [[ -z $DVBLOOPBACK_ARGS ]] && stat_die 1
     
             modprobe dvbloopback $DVBLOOPBACK_ARGS
             sleep 1
     
             stat_done
     
             stat_busy "Starting SASC-NG daemon"
     
             [[ -z $SASCNG_ARGS ]] && stat_die 2
             [[ -z $CAMDIR ]] && stat_die 3
             [[ -z $LOGDIR ]] && stat_die 4
     
             #[[ -z $PID ]] && /usr/sbin/sasc-ng -D $SASCNG_ARGS --cam-dir=$CAMDIR -l $LOGDIR/sasc-ng.log
     	[[ -z $PID ]] && /usr/sbin/sasc-ng -D $SASCNG_ARGS --cam-dir=$CAMDIR
             if [ $? -gt 0 ]; then
                     stat_die 5
             else
                     add_daemon sasc-ng
                     stat_done
             fi
             ;;
     stop)
             stat_busy "Stoping SASC-NG daemon"
             [[ ! -z $PID ]] && kill $PID &> /dev/null
     
             if [ $? -gt 0 ]; then
                     stat_die 6
             else
                     rm_daemon sasc-ng
                     stat_done
             fi
     
             stat_busy "Unloading dvbloopback kernel module"
     
             sleep 2
             modprobe -r dvbloopback
     
             stat_done
             ;;
     
     restart)
             $0 stop
             sleep 1
             $0 start
             ;;
     
     *)
             echo "usage: $0 {start|stop|restart}" >&2
             exit 1
     esac
     

> Starting Sasc-ng

    # /etc/rc.d/sasc-ng start

This yields the following messages in dmesg:

    [ 8130.913490] /home/cedric/open-sasc-ng/src/sc-build/contrib/sasc-ng/dvbloopback/module/dvb_loopback.c: frontend loopback driver v0.0.1
    [ 8130.913502] dvbloopback: registering 1 adapters
    [ 8130.913627] DVB: registering new adapter (DVB-LOOPBACK)

    This yields the following messages in /var/log/oscam.log:
     May 19 20:51:50.858 : Version: 0.0.2-61975953edd0+
     May 19 20:51:50.995 CAM: initializing plugin: SoftCam (1.0.0pre-HG-61975953edd0+): A software emulated CAM
     May 19 20:51:51.051 CAM(general.info): SC version 1.0.0pre-HG-61975953edd0+ initializing (VDR 1.6.0)
     May 19 20:51:51.107 CAM: starting plugin:
     May 19 20:51:51.164 CAM(general.info): SC version 1.0.0pre-HG-61975953edd0+ starting (VDR 1.6.0)
     May 19 20:51:51.220 CAM(core.load): ** Plugin config:
     May 19 20:51:51.276 CAM(core.load): ** Key updates (AU) are enabled (active CAIDs) (no prestart)
     May 19 20:51:51.334 CAM(core.load): ** Local systems DON'T take priority over cached remote
     May 19 20:51:51.383 CAM(core.load): ** Concurrent FF recordings are NOT allowed
     May 19 20:51:51.439 CAM(core.load): ** Force transfermode with digital audio
     May 19 20:51:51.496 CAM(core.load): ** ECM cache is set to enabled
     May 19 20:51:51.552 CAM(core.load): ** ScCaps are 1 2 0 0 0 0 0 0 0 0
     May 19 20:51:51.620 CAM(general.info): loading cardclient config from /etc/camdir/cardclient.conf
     May 19 20:51:51.687 CAM(cardclient.newcamd): now using protocol version 525 (cdLen=8)
     May 19 20:51:51.744 CAM(cardclient.core): hostname=localhost port=15050 emm=1 emmCaids 0b00/ff00
     May 19 20:51:51.789 CAM(cardclient.core): Newcamd: username=user2 password=password2 key=000102030405060708090A0B0C0D
     May 19 20:51:51.846 CAM(cardclient.core): client 'Newcamd' ready
     May 19 20:51:51.945 CAM(core.net): connecting to localhost:15050/tcp (127.0.0.1)
     May 19 20:51:52.204 CAM(cardclient.login): Newcamd: CaID=0b00 admin=1 srvUA=00000000551F0EC6 provider 00E030/0000000000000000000000/00000000002A8F87
     May 19 20:51:52.376 CAM(general.error): failed open /etc/camdir/SoftCam.Key: No such file or directory
     May 19 20:51:52.511 CAM(general.error): failed open /etc/camdir/smartcard.conf: No such file or directory
     May 19 20:51:52.556 CAM(general.error): failed open /etc/camdir/cardslot.conf: No such file or directory
     May 19 20:51:52.601 CAM(general.error): failed open /etc/camdir/override.conf: No such file or directory
     May 19 20:51:52.647 CAM(general.error): no keys loaded for softcam!
     May 19 20:51:52.692 CAM(core.load): ** registered systems:
     May 19 20:51:52.737 CAM(core.load): ** Cardclient        (pri -15)
     May 19 20:51:52.794 CAM(core.load): ** Conax             (pri -10)
     May 19 20:51:52.850 CAM(core.load): ** ConstCW           (pri -20)
     May 19 20:51:52.907 CAM(core.load): ** Cryptoworks       (pri -10)
     May 19 20:51:52.963 CAM(core.load): ** Irdeto            (pri -10)
     May 19 20:51:53.035 CAM(core.load): ** Irdeto2           (pri  -8)
     May 19 20:51:53.080 CAM(core.load): ** Nagra             (pri -10)
     May 19 20:51:53.126 CAM(core.load): ** Nagra2            (pri -10)
     May 19 20:51:53.182 CAM(core.load): ** Fake-NDS          (pri -12)
     May 19 20:51:53.239 CAM(core.load): ** SC-Conax          (pri  -5)
     May 19 20:51:53.295 CAM(core.load): ** SC-Cryptoworks    (pri  -5)
     May 19 20:51:53.352 CAM(core.load): ** SC-Irdeto         (pri  -5)
     May 19 20:51:53.408 CAM(core.load): ** SC-Nagra          (pri  -5)
     May 19 20:51:53.465 CAM(core.load): ** SC-Seca           (pri  -5)
     May 19 20:51:53.521 CAM(core.load): ** SC-Viaccess       (pri  -5)
     May 19 20:51:53.577 CAM(core.load): ** SC-VideoGuard2    (pri  -5)
     May 19 20:51:53.623 CAM(core.load): ** Seca              (pri -10)
     May 19 20:51:53.684 CAM(core.load): ** @SHL              (pri -10)
     May 19 20:51:53.740 CAM(core.load): ** Viaccess          (pri -10)
     May 19 20:51:54.817 frontend: Starting thread on /dev/dvb/adapter1/frontend1
     The thread scheduling parameters indicate:
     policy = 0
     priority = 0
     May 19 20:51:54.818 dvr: Starting thread on /dev/dvb/adapter1/dvr1
     The thread scheduling parameters indicate:
     policy = 1
     priority = 99
     May 19 20:51:54.818 demux: Starting thread on /dev/dvb/adapter1/demux1
     The thread scheduling parameters indicate:
     policy = 0
     priority = 0
     May 19 20:51:54.988 : Listening on port 5456
     May 19 20:53:53.011 CAM(core.net): idle timeout, disconnected localhost:15050
    This yields the following messages in /var/log/oscam/oscam.log:
     2011/05/19 20:51:52   1557 s   client(1) connect from 127.0.0.1 (pid=7297, pipfd=14)
     2011/05/19 20:51:52   7297 c01 encrypted newcamd:15050-client 127.0.0.1 granted (user2, au(auto)=reader1)
     2011/05/19 20:51:52   7297 c01 user user2 authenticated successfully (generic)
     2011/05/19 20:51:52   7297 c01 AU enabled for user user2 on reader reader1

> Testing Softcam with tzap and mplayer

Issue the following commands in 3 separate terminals:

    $ tzap -a 1 -r 'Discovery Channel'
    $ cat /dev/dvb/adapter1/dvr0 >test.ts
    $ mplayer test.ts

After a few seconds Discovery Channel should appear on the screen. This
yields the following messages in /var/log/oscam/oscam.log:

    2011/05/19 20:53:53   7297 c01 Connection closed to client
    2011/05/19 20:53:53   7297 c01 user2 disconnected  from 127.0.0.1
    2011/05/19 20:59:38   1557 s   client(1) connect from 127.0.0.1 (pid=7315, pipfd=14)
    2011/05/19 20:59:38   7315 c01 encrypted newcamd:15050-client 127.0.0.1 granted (user2, au(auto)=reader1)
    2011/05/19 20:59:38   7315 c01 user user2 authenticated successfully (generic)
    2011/05/19 20:59:38   7315 c01 AU enabled for user user2 on reader reader1
    2011/05/19 20:59:38   7315 c01 user2 (0B00&00E030/0024/47:4A33): found (290 ms) by reader1
    2011/05/19 20:59:43   7315 c01 user2 (0B00&00E030/0024/47:FEE2): found (265 ms) by reader1

This yields the following messages in /var/log/sasc-ng.log:

     May 19 20:59:37.396 CAM(core.ecm): 0.1: is no longer idle
     May 19 20:59:37.453 MSG: Got unprocessed message type: 1
     May 19 20:59:37.515 CAM(core.ecm): 0.1: triggered SID -1/36 idx -1/1 mode -1/0 -
     May 19 20:59:37.611 CAM(core.ecm): 0.1: new caDescr: 09 04 0B 00 EB FD
     May 19 20:59:37.656 CAM(core.ecm): 0.1: CA descriptors for SID 36 (len=6)
     May 19 20:59:37.706 CAM(core.ecm): 0.1: descriptor 0b 00 eb fd
     May 19 20:59:37.762 CAM(core.ecm): 0.1: found 0b00(0000) (Conax) id 0000 with ecm bfd/80 (new)
     May 19 20:59:37.819 CAM(core.ecm): 0.1: try system Conax (0b00) id 0000 with ecm bfd (pri=-10)
     May 19 20:59:37.838 CAM(core.au): 0: chain caid 0b00 -> Cardclient(-15) [00b6-82/ff/00]
     May 19 20:59:37.955 CAM(conax.key): missing 20 E key
     May 19 20:59:38.111 CAM(core.ecm): system: no key found for C 20 M
     May 19 20:59:38.156 CAM(conax.key): missing 20 E key
     May 19 20:59:38.202 CAM(core.ecm): 0.1: try system Cardclient (0b00) id 0000 with ecm bfd (pri=-15)
     May 19 20:59:38.247 CAM(cardclient.core): cc-loop
     May 19 20:59:38.303 CAM(cardclient.core): now trying client Newcamd (localhost:15050)
     May 19 20:59:38.360 CAM(core.net): connecting to localhost:15050/tcp (127.0.0.1)
     May 19 20:59:38.066 CAM(core.au): 0: starting chain 0b00
     May 19 20:59:38.432 CAM(cardclient.login): Newcamd: CaID=0b00 admin=1 srvUA=00000000551F0EC6 provider 00E030/0000000000000000000000/00000000002A8F87
     Called cSascDvbDevice::SetCaDescr
     May 19 20:59:38.936 CSA: Got command(1): E idx: 1 pid: 0 key: 67b4...1a
     Called cSascDvbDevice::SetCaDescr
     May 19 20:59:39.106 CSA: Got command(1): O idx: 1 pid: 0 key: 170e...77
     May 19 20:59:39.162 CAM(core.ecm): cache add prgId=36 source=1 transponder=0 ecm=bfd/80
     May 19 20:59:39.218 CAM(core.ecm): 0.1: correct key found
     Called cSascDvbDevice::SetCaDescr
     May 19 20:59:41.436 CSA: Got command(1): E idx: 1 pid: 0 key: 67b4...1a
     Called cSascDvbDevice::SetCaDescr
     May 19 20:59:41.461 CAM(core.load): saved ecm cache to /etc/camdir/ecm.cache
     May 19 20:59:41.651 CSA: Got command(1): O idx: 1 pid: 0 key: 170e...77
     Called cSascDvbDevice::SetCaDescr
     May 19 20:59:43.932 CSA: Got command(1): E idx: 1 pid: 0 key: 23b4...20
     Called cSascDvbDevice::SetCaDescr
     May 19 20:59:53.968 CSA: Got command(1): O idx: 1 pid: 0 key: 60b5...3e
     Buffer has room, reading 32900 bytes
     May 19 20:59:54.285 CSA: Creating csa for rb: 1
     Buffer has room, reading 188 bytes
     Buffer has room, reading 188 bytes
     Returning 32768
     Buffer has room, reading 32900 bytes
     Buffer has room, reading 188 bytes
     Buffer has room, reading 188 bytes
     Returning 32768
     Buffer has room, reading 32900 bytes
     Buffer has room, reading 188 bytes
     Returning 32768
     Buffer has room, reading 32900 bytes
     Buffer has room, reading 188 bytes
     Returning 32768
     Called cSascDvbDevice::SetCaDescr
     May 19 21:00:04.069 CSA: Got command(1): E idx: 1 pid: 0 key: 461b...cd
     Called cSascDvbDevice::SetCaDescr
     May 19 21:00:13.931 CSA: Got command(1): O idx: 1 pid: 0 key: 12bf...2d
     Called cSascDvbDevice::SetCaDescr
     May 19 21:00:23.936 CSA: Got command(1): E idx: 1 pid: 0 key: bc12...41
     Called cSascDvbDevice::SetCaDescr

> Expanding for 2 or more DVB-T tuners

For 2 tuners edit /etc/conf.d/sasc-ng:

    # Use -j <real>:<virtual> to link adapters
    #for 2 tuners
    SASCNG_ARGS="-j 0:2 -j 1:3"
    DVBLOOPBACK_ARGS="num_adapters=2"
    LOGDIR="/var/log/"
    CAMDIR=/etc/camdir

This will create 2 virtual adapters (adapter 2 and 3):

    $ ls -l /dev/dvb/
    total 0
    drwxr-xr-x 2 root root 120 Jul 11 11:01 adapter0
    drwxr-xr-x 2 root root 120 Jul 11 11:01 adapter1
    drwxr-xr-x 2 root root 280 Jul 11 11:01 adapter2
    drwxr-xr-x 2 root root 280 Jul 11 11:01 adapter3

For 3 tuners edit /etc/conf.d/sasc-ng:

    # Use -j <real>:<virtual> to link adapters
    #for 3 tuners
    SASCNG_ARGS="-j 0:3 -j 1:4 -j 2:5"
    DVBLOOPBACK_ARGS="num_adapters=3"
    LOGDIR="/var/log/"
    CAMDIR=/etc/camdir

This will create 3 virtual adapters (adapter 3, 4 and 5):

    $ ls -l /dev/dvb/
    total 0
    drwxr-xr-x 2 root root 120 Jul 11 11:01 adapter0
    drwxr-xr-x 2 root root 120 Jul 11 11:01 adapter1
    drwxr-xr-x 2 root root 120 Jul 11 11:01 adapter2
    drwxr-xr-x 2 root root 280 Jul 11 11:01 adapter3
    drwxr-xr-x 2 root root 280 Jul 11 11:01 adapter4
    drwxr-xr-x 2 root root 280 Jul 11 11:01 adapter5

VDR Integration
---------------

> VDR installation

First install VDR as described here:
https://wiki.archlinux.org/index.php/VDR#Installation

> install vdr-plugin-sc-hg from aur

    $ wget https://aur.archlinux.org/packages/vd/vdr-plugin-sc-hg/vdr-plugin-sc-hg.tar.gz
    $ tar -xf vdr-plugin-sc-hg.tar.gz
    $ cd vdr-plugin-sc-hg
    # pacman -U vdr-plugin-sc-hg-574-1-i686.pkg.tar.xz

> VDR - oscam connection

First create the directory to store the configuration files:

    # mkdir /var/lib/vdr/plugins/sc
    # chown vdr /var/lib/vdr/plugins/sc

/var/lib/vdr/plugins/sc/cardclient.conf

    # Comment lines can start with # or ;
    #
    # every client line starts with the client name, followed by some arguments:
    # 'hostname' is the name of the server
    # 'port'     is the port on the server
    # 'emm'      is a flag to allow EMM transfers to the server
    #            (0=disabled 1=enabled)
    # 'caid'     (optional) caid on which this client should work
    # 'mask'     (optional) mask for caid e.g. caid=1700 mask=FF00 would allow
    #            anything between 1700 & 17FF.
    #            Default is 1700 & FF00. If only caid is given mask is FFFF.
    #            You may give multiple caid/mask values comma separated
    #            (e.g. 1702,1722,0d0c/ff00).
    # 'username' is the login username
    # 'password' is the login password
    #
    # newcamd client
    # 'cfgkey' is the config key (28bytes)
    newcamd:localhost:15050:1/0B00/FF00:user2:password2:000102030405060708090A0B0C0D

Now start oscam and vdr:

    # /etc/rc.d/oscam start
    # /etc/rc.d/vdr start

This should yield the following lines in /var/log/everything.log, only
the lines for the softcam plugin are shown:

     Starting Linux Video Disk Recorder: vdr
     Searching for plugins (VDR 1.7.20/1.7.20) (cache miss): sc xineliboutput dvbsddevice.
     Aug 27 08:28:30 localhost vdr: [3049] VDR version 1.7.20 started
     Aug 27 08:28:30 localhost vdr: [3049] switched to user 'vdr'
     ...
     Aug 27 08:28:31 localhost vdr: [3049] initializing plugin: sc (1.0.0pre-HG-0ece27f23b8b+): A software emulated CAM
     Aug 27 08:28:31 localhost vdr: [3049] [general.info] SC version 1.0.0pre-HG-0ece27f23b8b+ initializing (VDR 1.7.20)
     Aug 27 08:28:31 localhost vdr: [3049] initializing plugin: xineliboutput (1.0.90-cvs): X11/xine-lib output plugin
     ...
     Aug 27 08:28:31 localhost vdr: [3049] starting plugin: sc
     Aug 27 08:28:31 localhost vdr: [3049] [general.info] SC version 1.0.0pre-HG-0ece27f23b8b+ starting (VDR 1.7.20)
     Aug 27 08:28:31 localhost vdr: [3049] [general.info] loading cardclient config from /var/lib/vdr/plugins/sc/cardclient.conf
     Aug 27 08:28:31 localhost vdr: [3049] [general.warn] no write permission on /var/lib/vdr/plugins/sc/cardclient.conf. Changes will not be saved!
     Aug 27 08:28:31 localhost vdr: [3054] Netwatcher thread started (pid=3049, tid=3054)
     Aug 27 08:28:31 localhost vdr: [3049] [general.error] failed open /var/lib/vdr/plugins/sc/SoftCam.Key: No such file or directory
     Aug 27 08:28:31 localhost vdr: [3049] [general.error] failed open /var/lib/vdr/plugins/sc/smartcard.conf: No such file or directory
     Aug 27 08:28:31 localhost vdr: [3049] [general.error] failed open /var/lib/vdr/plugins/sc/cardslot.conf: No such file or directory
     Aug 27 08:28:31 localhost vdr: [3049] [general.error] failed open /var/lib/vdr/plugins/sc/override.conf: No such file or directory
     Aug 27 08:28:31 localhost vdr: [3049] [general.error] no keys loaded for softcam!
     ...

This should yield the following lines in /var/log/oscam/oscam.log:

    2011/08/27  8:28:31   2966 s   client(1) connect from 127.0.0.1 (pid=3053, pipfd=14)
    2011/08/27  8:28:31   3053 c01 encrypted newcamd:15050-client 127.0.0.1 granted (user2, au(auto)=reader1)
    2011/08/27  8:28:31   3053 c01 user user2 authenticated successfully (generic)
    2011/08/27  8:28:31   3053 c01 AU enabled for user user2 on reader reader1

> Scanning channels

    $ scan /usr/share/dvb/dvb-t/nl-All -o vdr

Then copy and paste from the terminal to /var/lib/vdr/channels.conf:

    Nederland 1;Digitenne:474000:I999B8C12D12M64T8G4Y0:T:27500:7011:7012:7013:0:1101:8720:0:0
    Nederland 2;Digitenne:474000:I999B8C12D12M64T8G4Y0:T:27500:7021:7022:7023:0:1102:8720:0:0
    Nederland 3;Digitenne:474000:I999B8C12D12M64T8G4Y0:T:27500:7031:7032:7033:0:1103:8720:0:0
    TV Rijnmond;Digitenne:474000:I999B8C12D12M64T8G4Y0:T:27500:7041:7042:7043:0:1104:8720:0:0
    Radio Rijnmond;Digitenne:474000:I999B8C12D12M64T8G4Y0:T:27500:0:7112:0:0:1111:8720:0:0
    Radio 1;Digitenne:474000:I999B8C12D12M64T8G4Y0:T:27500:0:7122:0:0:1112:8720:0:0
    Radio 2;Digitenne:474000:I999B8C12D12M64T8G4Y0:T:27500:0:7132:0:0:1113:8720:0:0
    3FM;Digitenne:474000:I999B8C12D12M64T8G4Y0:T:27500:0:7142:0:0:1114:8720:0:0
    Radio 4;Digitenne:474000:I999B8C12D12M64T8G4Y0:T:27500:0:7152:0:0:1115:8720:0:0
    Radio 5;Digitenne:474000:I999B8C12D12M64T8G4Y0:T:27500:0:7162:0:0:1116:8720:0:0
    Radio 6;Digitenne:474000:I999B8C12D12M64T8G4Y0:T:27500:0:7172:0:0:1117:8720:0:0
    FunX;Digitenne:474000:I999B8C12D12M64T8G4Y0:T:27500:0:7192:0:0:1119:8720:0:0
    Veronica/Disney XD;Digitenne:498000:I999B8C23D999M64T8G4Y0:T:27500:3011:3012:3013:0:31:0:0:0
    RTL 8;Digitenne:498000:I999B8C23D999M64T8G4Y0:T:27500:3021:3022:3023:0:32:0:0:0
    ��n;Digitenne:498000:I999B8C23D999M64T8G4Y0:T:27500:3031:3032:3033:0:33:0:0:0
    Ketnet/Canvas;Digitenne:498000:I999B8C23D999M64T8G4Y0:T:27500:3041:3042:3043:0:34:0:0:0
    KinderNet/Comedy Central;Digitenne:498000:I999B8C23D999M64T8G4Y0:T:27500:3051:3052:3053:0:35:0:0:0
    Discovery Channel;Digitenne:498000:I999B8C23D999M64T8G4Y0:T:27500:3061:3062:3063:0:36:0:0:0
    Eurosport;Digitenne:498000:I999B8C23D999M64T8G4Y0:T:27500:3071:3072:0:0:37:0:0:0
    Meiden van Holland Hard;Digitenne:498000:I999B8C23D999M64T8G4Y0:T:27500:3081:3082:0:0:38:0:0:0
    Nederland 1;Digitenne:618000:I999B8C12D999M64T8G4Y0:T:27500:7011:7012:7013:0:1101:0:0:0
    Nederland 2;Digitenne:618000:I999B8C12D999M64T8G4Y0:T:27500:7021:7022:7023:0:1102:0:0:0
    Nederland 3;Digitenne:618000:I999B8C12D999M64T8G4Y0:T:27500:7031:7032:7033:0:1103:0:0:0
    TV Noord-Holland;Digitenne:618000:I999B8C12D999M64T8G4Y0:T:27500:7041:7042:7043:0:1104:0:0:0
    Radio Noord-Holland;Digitenne:618000:I999B8C12D999M64T8G4Y0:T:27500:0:7112:0:0:1111:0:0:0
    Radio 1;Digitenne:618000:I999B8C12D999M64T8G4Y0:T:27500:0:7122:0:0:1112:0:0:0
    Radio 2;Digitenne:618000:I999B8C12D999M64T8G4Y0:T:27500:0:7132:0:0:1113:0:0:0
    3FM;Digitenne:618000:I999B8C12D999M64T8G4Y0:T:27500:0:7142:0:0:1114:0:0:0
    Radio 4;Digitenne:618000:I999B8C12D999M64T8G4Y0:T:27500:0:7152:0:0:1115:0:0:0
    Radio 5;Digitenne:618000:I999B8C12D999M64T8G4Y0:T:27500:0:7162:0:0:1116:0:0:0
    Radio 6;Digitenne:618000:I999B8C12D999M64T8G4Y0:T:27500:0:7172:0:0:1117:0:0:0
    FunX;Digitenne:618000:I999B8C12D999M64T8G4Y0:T:27500:0:7192:0:0:1119:0:0:0
    Nederland 1;Digitenne:722000:I999B8C12D999M64T8G4Y0:T:27500:7011:7012:7013:0:1101:0:0:0
    Nederland 2;Digitenne:722000:I999B8C12D999M64T8G4Y0:T:27500:7021:7022:7023:0:1102:0:0:0
    Nederland 3;Digitenne:722000:I999B8C12D999M64T8G4Y0:T:27500:7031:7032:7033:0:1103:0:0:0
    TV West;Digitenne:722000:I999B8C12D999M64T8G4Y0:T:27500:7041:7042:7043:0:1104:0:0:0
    Radio West;Digitenne:722000:I999B8C12D999M64T8G4Y0:T:27500:0:7112:0:0:1111:0:0:0
    Radio 1;Digitenne:722000:I999B8C12D999M64T8G4Y0:T:27500:0:7122:0:0:1112:0:0:0
    Radio 2;Digitenne:722000:I999B8C12D999M64T8G4Y0:T:27500:0:7132:0:0:1113:0:0:0
    3FM;Digitenne:722000:I999B8C12D999M64T8G4Y0:T:27500:0:7142:0:0:1114:0:0:0
    Radio 4;Digitenne:722000:I999B8C12D999M64T8G4Y0:T:27500:0:7152:0:0:1115:0:0:0
    Radio 5;Digitenne:722000:I999B8C12D999M64T8G4Y0:T:27500:0:7162:0:0:1116:0:0:0
    Radio 6;Digitenne:722000:I999B8C12D999M64T8G4Y0:T:27500:0:7172:0:0:1117:0:0:0
    FunX;Digitenne:722000:I999B8C12D999M64T8G4Y0:T:27500:0:7192:0:0:1119:0:0:0
    Eredivisie Live 1;Digitenne:762000:I999B8C23D999M64T8G4Y0:T:27500:2011:2012:0:0:21:0:0:0
    Eredivisie 2/AT5;Digitenne:762000:I999B8C23D999M64T8G4Y0:T:27500:2021:2022:0:0:22:0:0:0
    BBC One;Digitenne:762000:I999B8C23D999M64T8G4Y0:T:27500:2031:2032:0:0:23:0:0:0
    MTV;Digitenne:762000:I999B8C23D999M64T8G4Y0:T:27500:2041:2042:2043:0:24:0:0:0
    Animal Planet / TLC;Digitenne:762000:I999B8C23D999M64T8G4Y0:T:27500:2051:2052:0:0:25:0:0:0
    CNN;Digitenne:762000:I999B8C23D999M64T8G4Y0:T:27500:2061:2062:0:0:26:0:0:0
    BBC Two;Digitenne:762000:I999B8C23D999M64T8G4Y0:T:27500:2071:2072:0:0:27:0:0:0
    National Geographic;Digitenne:762000:I999B8C23D999M64T8G4Y0:T:27500:2081:2082:0:0:28:0:0:0
    BNR Nieuwsradio;Digitenne:762000:I999B8C23D999M64T8G4Y0:T:27500:0:2172:0:0:217:0:0:0
    Arrow Classic Rock;Digitenne:762000:I999B8C23D999M64T8G4Y0:T:27500:0:2182:0:0:218:0:0:0
    Radio 538;Digitenne:762000:I999B8C23D999M64T8G4Y0:T:27500:0:2192:0:0:219:0:0:0
    RTL 4;Digitenne:818000:I999B8C12D999M64T8G4Y0:T:27500:1011:1012:1013:0:11:0:0:0
    RTL 5;Digitenne:818000:I999B8C12D999M64T8G4Y0:T:27500:1021:1022:1023:0:12:0:0:0
    RTL 7;Digitenne:818000:I999B8C12D999M64T8G4Y0:T:27500:1031:1032:1033:0:13:0:0:0
    SBS 6;Digitenne:818000:I999B8C12D999M64T8G4Y0:T:27500:1041:1042:1043:0:14:0:0:0
    NET5;Digitenne:818000:I999B8C12D999M64T8G4Y0:T:27500:1051:1052:1053:0:15:0:0:0
    SLAM!FM;Digitenne:818000:I999B8C12D999M64T8G4Y0:T:27500:0:1112:0:0:111:0:0:0
    Radio 10 Gold;Digitenne:818000:I999B8C12D999M64T8G4Y0:T:27500:0:1122:0:0:112:0:0:0
    Q-Music;Digitenne:818000:I999B8C12D999M64T8G4Y0:T:27500:0:1132:0:0:113:0:0:0
    100%NL;Digitenne:818000:I999B8C12D999M64T8G4Y0:T:27500:0:1142:0:0:114:0:0:0
    Classic FM;Digitenne:818000:I999B8C12D999M64T8G4Y0:T:27500:0:1152:0:0:115:0:0:0
    SkyRadio 101 FM;Digitenne:818000:I999B8C12D999M64T8G4Y0:T:27500:0:1162:0:0:116:0:0:0
    Radio Veronica;Digitenne:818000:I999B8C12D999M64T8G4Y0:T:27500:0:1172:0:0:117:0:0:0
    Nickelodeon/TeenNick;Digitenne:522000:I999B8C12D12M64T8G4Y0:T:27500:4011:4012:4013:0:41:8720:2244:0
    13th Street;Digitenne:522000:I999B8C12D12M64T8G4Y0:T:27500:4021:4022:0:0:42:8720:2244:0
    SLAM!TV;Digitenne:522000:I999B8C12D12M64T8G4Y0:T:27500:4031:4032:0:0:43:8720:2244:0
    TV Drenthe  tijdelijk;Digitenne:522000:I999B8C12D12M64T8G4Y0:T:27500:4041:4042:4043:0:44:8720:2244:0
    BBC Radio 1;Digitenne:522000:I999B8C12D12M64T8G4Y0:T:27500:0:4112:0:0:411:8720:2244:0
    BBC Radio 2;Digitenne:522000:I999B8C12D12M64T8G4Y0:T:27500:0:4122:0:0:412:8720:2244:0
    BBC Radio 3;Digitenne:522000:I999B8C12D12M64T8G4Y0:T:27500:0:4132:0:0:413:8720:2244:0
    BBC Radio 4;Digitenne:522000:I999B8C12D12M64T8G4Y0:T:27500:0:4142:0:0:414:8720:2244:0 

> Watch TV

First (re)start oscam and vdr, so it picks up the new channel
configuration:

    #/etc/rc.d/oscam restart
    #/etc/rc.d/vdr restart

Now you can start the frontend. This has to be done as the same user
that started the X server:

    $ vdr-sxfe

The first time you try to watch an encrypted channel, it may take up to
15 minutes for vdr to start asking keys from oscam. This is only seen
the first time, the second time vdr is started, it takes a few seconds
to start playing.

  

Mythtv Integration
------------------

First install Mythtv als described here:
https://wiki.archlinux.org/index.php/MythTV_HOWTO

> Mythtv-setup

Make sure mysqld, oscam en sasc-ng are started:

    # /etc/rc.d/mysqld start
    # /etc/rc.d/oscam start
    # /etc/rc.d/sasc-ng start

Then start mythtv-setup, and set up the following pages:

    $mythtv-setup

1. General

In this menu, there are no settings that affect digitenne.

2. Capture cards

    Card type: DVB DVT capture card (v3.x)
    DVB Device Number: /dev/dvb/adapter1/frontend0
    Frontend ID: DiBcom 7000PC Subtype: DVB-T
    Signal Timeout (ms): 1000
    Tuning Timeout (ms): 3000
    Recording Options:
     Max recordings: 5
     [don't] Wait for SEQ start header
     [don't] Open DVB card on demand
     [do] Use DVB card for active EIT scan
     DVB tuning delay (msec): 0

3. Video sources

    Video source name: digitenne_eit
    Listings grabber: Transmitted guide only (EIT)
    Channel frequency table: europe-west

4. Input connections

    [DVB : /dev/adapter1/frontend0 ] (DVBInput) -> digitenne_eit 
    Capture device: [DVB:/dev/dvb/adapter1/frontend0 ]
    Input: DVBInput
    Display name (optional): digitenne
    Video source: digitenne_eit
    Use quick tuning: Never
    [don't] Use DishNet long-term EIT data
    Scan for channels
     Video Source: digitenne_eit
     Input: [DVB : /dev/adapter1/frontend0 ] (DVBInput)
     Desired Services: TV
     [don't] Only Free
     [don't] Test Decryptability
     Scan type: Full Scan
     Country: Germany (The Nederlands does not exist)  
    Starting channel: 1
    Input priority: 0
    Input Group 1: DVB_/dev/dvb/adapter0/frontend0
    Input Group 2: Generic

5. Channel Editor

Here the channels should be present that have been found in screen 4
(Input connections).

6. Storage Directories

In this menu, there are no settings that affect digitenne.

7. System events

In this menu, there are no settings that affect digitenne.

> Start mythtv

Make sure mysqld, oscam en sasc-ng are started:

    # /etc/rc.d/mysqld start
    # /etc/rc.d/oscam start
    # /etc/rc.d/sasc-ng start

Then start mythbackend:

    $ mythbackend

And start mythfrontend in a different terminal:

    $ mythfrontend

Now it should be possible to watch live TV. It will take some time for
the channel to be decrypted. Changing the channel also takes a long
time, especially when the new channel is on a different frequency
(transport).

The best way is just to record everything you want to see, and then
watch the recorings. In this way all the decryption happens in the
background.

References
----------

Sat4All:
http://www.sat4all.com/forums/ubbthreads.php/topics/1967886/digitenne_kijken_via_oscam_en_#Post1967886
(Dutch link)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Digitenne&oldid=257788"

Category:

-   Audio/Video

-   This page was last modified on 19 May 2013, at 13:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
