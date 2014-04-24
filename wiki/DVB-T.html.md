DVB-T
=====

Related articles

-   DVB-S
-   LIRC
-   RTL-SDR

DVB-T is the worldwide standard for transmitting terrestrial digital
video broadcast. It is possible to receive DVB-T using several different
hardware setups, however this article will focus on DVB-T USB dongles
based on the RTL2832U chipset (which are also very popular as cheap
software defined radios using RTL-SDR).

Contents
--------

-   1 Driver
-   2 Utilities
    -   2.1 Scanning
-   3 Clients
    -   3.1 VLC
    -   3.2 MPlayer
    -   3.3 ffmpeg
-   4 Troubleshooting

Driver
------

The main driver in use is dvb_usb_rtl28xxu, and exists in the latest
kernels. If it is not loaded, do so manually:

    # modprobe dvb_usb_rtl28xxu

You might also need to load rtl2832 or rtl2830:

    # modprobe rtl2830
    # modprobe rtl2832

Warning:If you have RTL-SDR installed, note that it conflicts with this
driver, and therefore blacklists it. Make sure to remove any necessary
blacklists before loading the driver. The default location for the
blacklist file is in /etc/modprobe.d/rtlsdr.conf.

After plugging the device in, dmesg should show something like this:

    [ 4009.326338] usb 7-5: new high-speed USB device number 4 using ehci-pci
    [ 4009.466712] usb 7-5: dvb_usb_v2: found a 'Realtek RTL2832U reference design' in warm state
    [ 4009.531594] usb 7-5: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
    [ 4009.531613] DVB: registering new adapter (Realtek RTL2832U reference design)
    [ 4009.534554] usb 7-5: DVB: registering adapter 0 frontend 0 (Realtek RTL2832 (DVB-T))...
    [ 4009.534627] r820t 4-001a: creating new instance
    [ 4009.546177] r820t 4-001a: Rafael Micro r820t successfully identified
    [ 4009.552681] Registered IR keymap rc-empty
    [ 4009.552783] input: Realtek RTL2832U reference design as /devices/pci0000:00/0000:00:1d.7/usb7/7-5/rc/rc1/input20
    [ 4009.552854] rc1: Realtek RTL2832U reference design as /devices/pci0000:00/0000:00:1d.7/usb7/7-5/rc/rc1
    [ 4009.553275] input: MCE IR Keyboard/Mouse (dvb_usb_rtl28xxu) as /devices/virtual/input/input21
    [ 4009.554466] rc rc1: lirc_dev: driver ir-lirc-codec (dvb_usb_rtl28xxu) registered at minor = 0
    [ 4009.554474] usb 7-5: dvb_usb_v2: schedule remote query interval to 400 msecs
    [ 4009.565930] usb 7-5: dvb_usb_v2: 'Realtek RTL2832U reference design' successfully initialized and connected

Note:in this case we see that the dongle has a R820T tuner, but there
are several other popular tuners that you might run into. Also note the
IR sensor device that was recognized that, properly configured, can be
used with the device remote control. See LIRC for more information.

Additionally, you should now see the adapter device under
/dev/dvb/adapter0.

Utilities
---------

Various DVB utilities can be found in the linuxtv-dvb-apps package.

> Scanning

w_scan allows for automatic scanning of channels without configuration.
Install it then issue:

    # w_scan -ft -c [country_code] > ~/channels.conf

More advanced scanning options can be found under DVB-S#Scanning
channels.

Clients
-------

> VLC

Viewing the DVB-T stream throgh VLC can be done using:

    $ vlc dvb://frequency=543000000

where the frequency is set in Hz, and should match the base frequency
for the transmissions in your area.

VLC also accepts various command line arguments, for example if you want
to tune into a different program:

    $ vlc dvb://frequency=543000000 :program=3

> MPlayer

For DVB streaming, MPlayer requires a channels configuration file at
~/.mplayer/channels.conf. Follow #Scanning for instructions on how to
generate it, but make sure to use the -M flag to generate the proper
format for MPlayer, if you're using w_scan:

    $ w_scan -ft -c [country_code] -M > ~/.mplayer/channels.conf

Then, you can simply run:

    $ mplayer dvb://"STREAM NAME"

with a valid STREAM NAME from the channels conf. You might need to use
-demuxer lavf or -demuxer mpegts in order to properly receive the
stream.

> ffmpeg

ffmpeg can take DVB-T MPEG streams as input, but requires tzap to do so.

Note:This might not necessarily be the case, if a better method is
known, please update.

First, generate a tzap-compatible channels.conf file, using w_scan:

    $ w_scan -ft -A1 -X > ~/.tzap/channels.conf

Then, you can run:

    $ tzap -r "CHANNEL NAME"

which, if setup correctly should yield an output similar to:

    $ tzap -r "CHANNEL NAME"
    using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
    reading channels from file '/home/user/.tzap/channels.conf'
    Version: 5.10  	 FE_CAN { DVB-T }
    tuning to 506000000 Hz
    video pid 0x0a21, audio pid 0x0a22
    status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc 00007fbd | 
    status 1f | signal 0000 | snr 0126 | ber 00000000 | unc 00007fbd | FE_HAS_LOCK
    status 1f | signal 0000 | snr 0129 | ber 0000000f | unc 00007fbd | FE_HAS_LOCK
    status 1f | signal 0000 | snr 0120 | ber 00000003 | unc 00007fbd | FE_HAS_LOCK
    status 1f | signal 0000 | snr 0125 | ber 00000011 | unc 00007fbd | FE_HAS_LOCK
    # ....

More information on tzap is available on the zap wiki page.

Once tzap is encoding the stream, /dev/dvb/adapter0/dvr0 should be
available to ffmpeg (or any other program).

A simple command to stream a program, without addditional encoding might
look like so:

    $ ffmpeg -f mpegts -i /dev/dvb/adapter0/dvr0 out.mp4

Troubleshooting
---------------

If you bump into problems, try these tools to help debug:

-   dvbsnoop is an advanced tool that can show all the necessary data
    regarding the bandwidth, signal, frontend, etc.
-   femon -H shows signal statistics

Retrieved from
"https://wiki.archlinux.org/index.php?title=DVB-T&oldid=292549"

Category:

-   Audio/Video

-   This page was last modified on 12 January 2014, at 13:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
