VDR
===

  Summary
  -----------------------------------------------
  Information on installing and configuring VDR

VDR stands for Video Disk Recorder, an open source software application
to turn any PC into a digital video recorder. These initials do not
fully explain what VDR is capable of. VDR does also implement all the
functions of a modern set-top box to watch either live television or
recordings. With the extensive amount of available plugins almost
countless features can be added, e.g., play DVDs, play audio and video
files, view your photo collection, check your email account...

With its flexibility Arch Linux is perfectly suited for setting VDR up
and customizing it. AUR, the Arch Linux User-Community Repository, and
the ArchVDR team provide PKGBUILDs for VDR and its most commonly used
plugins and addons.

This article is divided into three parts. In the first part I am going
to show you how to install VDR on your PC and how to get it up and
running. The second part of the article is about how to extend VDR by
adding new features like playing DVDs or controlling VDR over the
Internet. The third part is about rather advanced features like how to
automatically detect and mark commercial breaks in your recordings or
how to stream VDR over the Internet.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Initial Steps                                                      |
|     -   1.1 Hardware Requirements                                        |
|     -   1.2 Installation                                                 |
|         -   1.2.1 Prepare for compilation                                |
|         -   1.2.2 Getting the pkgbuilds                                  |
|         -   1.2.3 Install ttf-vdrsymbols                                 |
|         -   1.2.4 start-stop-daemon                                      |
|         -   1.2.5 vdr                                                    |
|         -   1.2.6 libblueray                                             |
|         -   1.2.7 xine-lib                                               |
|         -   1.2.8 vdr-plugin-xineliboutput-git                           |
|                                                                          |
|     -   1.3 DVB Card Kernel Modules and Firmware                         |
|     -   1.4 Starting VDR                                                 |
|                                                                          |
| -   2 Extending VDR                                                      |
|     -   2.1 Plugins                                                      |
|         -   2.1.1 How to Setup a Plugin                                  |
|                                                                          |
|     -   2.2 Remote Control                                               |
|         -   2.2.1 LIRC                                                   |
|         -   2.2.2 Remote Plugin                                          |
|                                                                          |
|     -   2.3 Configuring VDR                                              |
|         -   2.3.1 Channel Scan                                           |
|         -   2.3.2 Controlling and Displaying VDR                         |
|             -   2.3.2.1 TVtime - Full-Featured Cards Only                |
|             -   2.3.2.2 Xineliboutput - Full-Featured and Budget Cards   |
|                 -   2.3.2.2.1 Configuring vdr-xineliboutput              |
|                                                                          |
| -   3 Special Features                                                   |
|     -   3.1 Augment VDR's EPG                                            |
|         -   3.1.1 xmltv2vdr                                              |
|         -   3.1.2 vdraepg                                                |
|                                                                          |
|     -   3.2 Streaming VDR                                                |
|         -   3.2.1 Over the Local Area Network (LAN)                      |
|         -   3.2.2 Over the Internet                                      |
|             -   3.2.2.1 StreamDev Plugin                                 |
|                 -   3.2.2.1.1 Server                                     |
|                 -   3.2.2.1.2 Client                                     |
|                                                                          |
|             -   3.2.2.2 VLC                                              |
|                 -   3.2.2.2.1 Server                                     |
|                 -   3.2.2.2.2 Client                                     |
|                                                                          |
|         -   3.2.3 Streaming to iPhone, iPad and iPod                     |
|                                                                          |
| -   4 Conclusion                                                         |
| -   5 References                                                         |
+--------------------------------------------------------------------------+

Initial Steps
-------------

This part of the guide is about how to install VDR and how to get it up
and running.

> Hardware Requirements

VDR is designed to work with a huge variety of DVB cards. See the VDR
Wiki for whether or not your specific card will be supported. Let me
just tell you that so called budget cards, i.e., cards without a
hardware MPEG decoder, work perfectly fine with VDR thanks to plugins
like vdr-xineliboutput. At present, HDTV - mainly via DVB-S2 - is
becoming more and more popular and the good news is that VDR supports a
wide range of such cards, e.g. internal PCI cards. A widely used HDTV
card is Hauppauge's Nova-HD-S2, which comes with a remote control that
can be used in VDR, more about that later. Ok then, lets get into more
detail.

> Installation

Even though you can install VDR from AUR, it is recommendable to use the
up-do-date PKGBUILD for VDR, its plugins and addons provided by the
ArchVDR team. The Wiki explains further details on how to get the files.

Prepare for compilation

First step is to install the needed packages:

    # pacman -S subversion fakeroot patch sudo linuxtv-dvb-apps at make
    # pacman -S autoconf automake git pkg-config
    # pacman -S libvdpau libogg flac libvorbis libmng libtheora a52dec
    # pacman -S faad2 faac x264 ffmpeg libdca libpulse mercurial
    # pacman -S ffmpeg cvs libdca mesa freeglut
    # pacman -S w3m gcc libtool
    # pacman -S fontconfig xorg-font-utils libjpeg

Getting the pkgbuilds

Now issue the following commands to get the pkgbuilds:

    $ svn co https://archvdr.svn.sourceforge.net/svnroot/archvdr archvdr
    $ cd archvdr/trunk/archvdr/

Install ttf-vdrsymbols

First install ttf-vdrsymbols:

    $ cd ttf-vdrsymbols/
    $ makepkg
    # pacman -U ttf-vdrsymbols-20100612-1-i686.pkg.tar.xz
    $ cd ..

start-stop-daemon

    $ cd start-stop-daemon/
    $ makepkg
    # pacman -U start-stop-daemon-1.15.8.11-1-i686.pkg.tar.xz
    $ cd ..

vdr

    $ cd vdr-1.7.23/
    $ makepkg
    # pacman -U vdr-1.7.23-1-i686.pkg.tar.xz
    $ cd ..

libblueray

    $ cd libbluray/
    $ makepkg
    # pacman -U libbluray-20110620-1-i686.pkg.tar.xz
    $ cd ..

xine-lib

    $ cd xine-lib-1.2/
    $ makepkg
    # pacman -U xine-lib-1.2-11678-7-i686.pkg.tar.xz
    $ cd ..

vdr-plugin-xineliboutput-git

    $ cd vdr-plugin-xineliboutput-git/
    $ makepkg
    # pacman -U vdr-plugin-xineliboutput-git-20110620-1-i686.pkg.tar.xz

The VDR package's install script will create a special user called vdr,
especially for running VDR. The vdr user will be added to the video
group so that it can access DVB cards and should own VDR's configuration
files in /etc/vdr and the recordings and Electronic Programme Guide
(EPG) directories /var/spool/video and /var/spool/epg.

> DVB Card Kernel Modules and Firmware

If you own one of the famous full-featured DVB-S cards (with hardware
MPEG decoder) from Technotrend (identical in construction to Hauppauge
Nexus, Technisat Skystar 1 and Fujitsu-Siemens DVB-S), you might have to
do a little extra work since, at least on my computer, a wrong module
gets control of the card. On my computer the command "lspci -k" shows
the following output:

    03:02.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
    	Subsystem: Technotrend Systemtechnik GmbH Technotrend/Hauppauge DVB card rev2.3
    	Kernel driver in use: dvb
    	Kernel modules: dvb-ttpci, snd-aw2

As you can see, two modules, dvb-ttpci and snd-aw2, are assigned to the
DVB card while only the former should take control. Simply add the
unwanted one to the list in /etc/rc.conf:

    MODULES=(... !snd-aw2 ...)

A restart of the computer should do the rest. Another two things you
might do before the restart: if you own one of those full-featured cards
(perhaps also for some other cards), you will also need a firmware for
the card to work. For the full-featured Technotrend cards the firmware
is dvb-ttpci-01.fw and has to be placed into the folder /lib/firmware.
Instead of restarting the computer you just can unload and load the
kernel module dvb_ttpci. The second thing which requires at least a new
login to take effect is to add yourself to the group "video" (gpasswd -a
<username> video).

Also other cards, like the already mentioned DVB-S2 card Nova-HD-S2 from
Hauppauge require a firmware to be put into /lib/firmware, in the case
of the Nova-HD-S2 the firmware's name is dvb-fe-cx24116.fw. Do not
forget to eiter reload the card's module or to restart the computer.

> Starting VDR

You can now start vdr:

    # /etc/rc.d/vdr start

VDR logs to /var/log/everything.log:

    # tail -f /var/log/everything.log

Now connect to vdr with xine. This must be done by the same user that
has started the X server, not the user vdr. This should yield a screen
with "no signal"

    $ vdr-sxfe

VDR can be automatically started when the PC is booted by adding it to
/etc/rc.conf:

    DAEMONs=(... @vdr)

If you want to change the user running VDR, the destination of the video
directory or the configuration files, you can do so by editing the VDR's
configuration file (/etc/default/vdr):

    OPTIONS="-u franz -c /video -v /video -E /video/epg.data -w 60"

Extending VDR
-------------

> Plugins

As already mentioned in the introduction, the functionality of VDR can
be extended with plugins. The following set of plugins, all available
from ArchVDR, will make a usable basic VDR installation

-   vdr-epgsearch, a replacement schedule with extended functionality.
    The epgearch plugin is being used by the plugin vdr-live.
-   vdr-extrecmenu, a replacement recordings menu with extended
    functionality.
-   vdr-femon, a frontend status monitor.
-   vdr-streamdev, a streaming server/client. Easy to set up with
    vdradmin-am.
-   vdr-live, a web interface that can be used to control VDR, view and
    search the EPG, schedule recordings and stream live TV.
-   vdr-xineliboutput, which provides a frontend for VDR and can be used
    with cards without a hardware MPEG decoder.

VDR does not support MHEG-5 teletext ("The Red Button" in the UK), so
the vdr-rssreader plugin can make a useful alternative.

How to Setup a Plugin

The command line syntax for running a plugin with VDR is

    vdr -P"name [OPTIONS]"

and the quickest way to find out what options each installed plugin has
is to run

    $ vdr --help

Once installed, the plugins are loaded automatically when VDR is being
started. If you want to alter the configuration of a plugin, you can do
so editing the according config file in /etc/vdr/plugins/.

> Remote Control

You might want to control VDR not only by keyboard but using a remote
control while relaxing on the couch. On one hand, there is LIRC, which
works with every DVB card, because it works independently from your DVB
card. On the other hand, provided that your DVB device has an integrated
IR-reciever, you might give the plugin vdr-remote a try. Both
possibilities will be described here.

LIRC

To setup VDR to make use of your LIRC remote control you have to adjust
the file /etc/vdr/remote.conf. The labeling after "LIRC.", e.g., "Up"
has to correspond with the labeling in /etc/lircd.conf. The second
column stands for the correspondent VDR command.

    LIRC.Up         	Up
    LIRC.Down       	Down
    LIRC.Menu       	Menu
    LIRC.Ok			Ok
    LIRC.Back       	Back
    LIRC.Left       	Left
    LIRC.Right      	Right
    LIRC.Red        	Red
    LIRC.Green      	Green
    LIRC.Yellow     	Yellow
    LIRC.Blue       	Blue
    LIRC.0          	0
    LIRC.1          	1
    LIRC.2          	2
    LIRC.3          	3
    LIRC.4          	4
    LIRC.5          	5
    LIRC.6          	6
    LIRC.7          	7
    LIRC.8          	8
    LIRC.9          	9
    LIRC.Power      	Power
    LIRC.Volume+   		Volume+
    LIRC.Volume-   	 	Volume-
    LIRC.Mute       	Mute
    LIRC.Audio      	Audio
    LIRC.Recordings 	Recordings
    LIRC.Info       	Info

Finally, make sure to add the option "--lirc" to the VDR command line

    $ vdr ... --lirc

or enable LIRC in /etc/runvdr.conf if you are using runvdr-extreme

    # Use a LIRC remote control device. If set to 1, vdr uses /var/run/lirc/lircd.
    # If not set, or set to 0, do not use LIRC.
    LIRC=1

Remote Plugin

This plugin only works with cards with build-in IR-recievers, as on
Technotrend's full-featured cards or on the Hauppauge Nova-HD-S2.
Install the package vdr-remote from ArchVDR and use the guide on the VDR
Wiki to set it up.

> Configuring VDR

Channel Scan

Make sure that the file channels.conf in /etc/vdr concurs with the
satellite your dish is pointing at. Linowsat provides up-to-date channel
lists for all satellites out there.

If you own a DVB-T or DVB-C card then either the scan utility from
linuxtv-dvb-apps or w_scan, which is available from the AUR, will be
your friend. (You might have to use translate.google.com for translating
w_scan's German wiki into English.) If you live in the UK then scan has
the advantage over w_scan because it can output channels in Logical
Channel Number order for VDR, i.e. channel 1 will be BBC ONE, 2 will be
BBC TWO etc.

    $ scan -o vdr -e 3 -p -x 0 -t 3 -u -U -q -q <path_to_initial_tuning_data_file> > channels.conf

    $ cat /etc/vdr/channels.conf
    :@1 
    BBC ONE;BBC:505833:C34D34M16B8T2G32Y0:T:27500:600:601=eng,602=eng:0:0:4164:9018:4100:0
    :@2 
    BBC TWO;BBC:505833:C34D34M16B8T2G32Y0:T:27500:610:611=eng,612=eng:0:0:4228:9018:4100:0
    :@3 
    ITV1;ITV:481833:C23D12M64B8T2G32Y0:T:27500:520:521=eng,522=eng:0:0:8261:9018:8197:0
    :@4 
    Channel 4;Channel 4 TV:481833:C23D12M64B8T2G32Y0:T:27500:560:561=eng,562=eng:0:0:8384:9018:8197:0
    :@5 
    FIVE;five:481833:C23D12M64B8T2G32Y0:T:27500:540:541=eng,542=eng:0:0:8500:9018:8197:0

Controlling and Displaying VDR

Eventually, we want to make sure that we can submit controls to and can
see the output (live tv and menu) of VDR.

Full-featured cards have got a VGA connector on the card in order to
connect an external TV set, alternatively this role can be taken over by
DXR 3/Hollywood+ cards. Nevertheless, these possibilities are getting
less important nowadays. On one hand with the advent of computer screens
with 24 or even more inches the computer screen itself has become very
attractive for watching TV, on the other hand, new TV sets do also have
an implemented DVI, HDMI, or even DisplayPort input allowing the
computer's graphics board to become the output device.

Therefore, this guide focuses on the VDR output on an X-server. BTW, to
make us of the VGA output of your full-featured card you simply have to
connect your TV set using an adequate VGA cable.

For testing purposes it makes sense to control VDR with the keyboard.
For how to control VDR by remote control see below. If you have a
full-featured card there are two ways of dispaying the VDR screen and to
control VDR by keyboard, if you own a budget card, one possibility will
be given.

TVtime - Full-Featured Cards Only

TVtime is a TV application which can be used to display VDR's screen.
Install the packages tvtime and the wrapper script vdr-tvtime from AUR.
To control VDR, adjust the first column of the file /etc/tvtime/maps.txt
according to your liking. Here is an example:

    m	Menu
    Enter	Ok
    Backspace	Back
    F1	Red
    F2	Green
    F3	Yellow
    F4	Blue
    +	Channel+
    -	Channel-
    u	Volume+
    d	Volume-
    c	Channels
    t	Timers
    r	Recordings
    s	Setup
    a	Audio
    n	Info
    f	TVTIME_f

Now you can start VDR (/etc/rc.d/runvdr start). Then execute the script
"vdr-tvtime.pl". TVtime should display the VDR screen and you should
also be able to control VDR with the keyboard.

Xineliboutput - Full-Featured and Budget Cards

The plugin vdr-xineliboutput enables VDR to be used with cards without a
hardware MPEG decoder chip such as the often mentioned Hauppauge
Nova-HD-S2.

Configuring vdr-xineliboutput

There are some xine configuration changes that can improve performance
with VDR. Make sure that xine is not running then edit the following in
${HOME}/.xine/config

    # number of audio buffers
    # numeric, default: 230
    engine.buffers.audio_num_buffers:500

    # number of video buffers
    # numeric, default: 500
    engine.buffers.video_num_buffers:1000

    # default number of video frames
    # numeric, default: 15
    engine.buffers.video_num_frames:22

    # method to sync audio and video
    # { metronom feedback  resample }, default: 0
    audio.synchronization.av_sync_method:resample

    # enable resampling
    # { auto  off  on }, default: 0
    audio.synchronization.resample_mode:on

Using xine-ui-vdr you can also use your keyboard to control VDR. Start
Xine once and close it so that the file ~/.xine/keymap is going to be
created. Edit this file so that at least the basic keys for controlling
VDR will work, e.g.,

    # jump to media Menu
    Menu {
    	key = m
    	modifier = none
    }

    # menu navigate up
    EventUp {
    	key = Up
    	modifier = none
    }

    # menu navigate down
    EventDown {
    	key = Down
    	modifier = none
    }

    # menu navigate left
    EventLeft {
    	key = Left
    	modifier = none
    }

    # menu navigate right
    EventRight {
    	key = Right
    	modifier = none
    }

    # menu select
    EventSelect {
    	key = Return
    	modifier = none
    }

    # VDR Red button
    VDRButtonRed {
    	key = F1
    	modifier = none
    }

    # VDR Green button
    VDRButtonGreen {
    	key = F2
    	modifier = none
    }

    # VDR Yellow button
    VDRButtonYellow {
    	key = F3
    	modifier = none
    }

    # VDR Blue button
    VDRButtonBlue {
    	key = F4
    	modifier = none
    }

    # VDR Command back
    VDRBack {
    	key = BackSpace
    	modifier = none
    }

    # menu select
    Alias {
    	entry = EventSelect
    	key = KP_Enter
    	modifier = none
    }

Also remember that you will get an error if you assign a key twice, make
sure therefore to change for instance the key for "SpeedFaster" from
"Up" to "VOID". It is possible, however, to assign two keys to the same
event, you do so with the "Alias" keyword. More information on the Xine
website.

Start Xine with the following command:

    $ xine "xvdr+tcp://<VDR's IP address>:37890#nocache" 

By adding the option "-D" (deinterlace) the picture quality is
increased.

It might be necessary to adjust the plugin's configuration
(/etc/vdr/plugins/plugin.xinliboutput.conf)

    --local=none
    --primary     
    --remote=<VDR's IP address>:37890 

Special Features
----------------

This part is meant for advanced users of VDR who might get some little
hint on how to enhance their VDR installation.

> Augment VDR's EPG

xmltv2vdr

Some channels like BBC or ITV do only provide EPG information for the
current and the next broadcast which is somewhat unspectacular compared
to the standards set by other broadcasting services like ARD (Germany)
or ORF (Austria). Fortunately, XMLTV can step into the breach as it is
able to get TV-listings for one ore even more weeks in advance. You can
follow this guide to install and configure XMLTV.

The XML-file created by XMLTV has to be converted in order that VDR can
use the data. For this purpose the script xmltv2vdr has been written, it
is availabe on AUR. Install it and follow the README in
/usr/share/doc/xmltv2vdr/. The example file channels.conf has been
prepared in /etc/xmltv2vdr:

    BBC 1 London;BSkyB:10773:h:S28.2E:22000:5000:5001=eng,5002=NAR:5003:1:6301:2:2045:0:london.bbc1.bbc.co.uk
    BBC 2 England;BSkyB:10773:h:S28.2E:22000:5100:5101=eng,5102=NAR:5103:1:6302:2:2045:0:london.bbc2.bbc.co.uk
    BBC THREE;BSkyB:10773:hC56:S28.2E:22000:5200:5201=eng,5202=NAR:5203:0:6319:2:2045:0:bbcthree.bbc.co.uk
    BBC FOUR;BSkyB:10773:hC56:S28.2E:22000:5300:5301=eng,5302=NAR:5303:0:6316:2:2045:0:bbcfour.bbc.co.uk
    BBC NEWS;BSkyB:11954:hC23:S28.2E:27500:5000:5001=eng:5003:0:6704:2:2013:0:news-24.bbc.co.uk
    CBBC Channel;BSkyB:10773:h:S28.2E:22000:5200:5201=eng,5202=NAR:5203:0:6317:2:2045:0:cbbc.bbc.co.uk
    CBeebies;BSkyB:10773:h:S28.2E:22000:5300:5301=eng,5302=NAR:5303:0:6318:2:2045:0:cbeebies.bbc.co.uk
    ITV1 London;BSkyB:10759:vC56:S28.2E:22000:2305:2312=eng,2314=NAR:2315:0:10060:2:2044:0:carlton.com
    ITV2;BSkyB:10759:vC56:S28.2E:22000:2352:2354=eng,2356=NAR:2358:0:10070:2:2044:0:itv2.itv.co.uk
    ITV3;BSkyB:10906:vC56:S28.2E:22000:2362:2356=eng,2357=NAR:2359:0:10260:2:2054:0:itv3.itv.co.uk
    ITV4;BSkyB:10759:vC56:S28.2E:22000:2359:2360=eng,2361=NAR:2362:0:10072:2:2044:0:itv4.itv.co.uk
    Film4;BSkyB:10714:hC56:S28.2E:22000:2346:2347=eng,2348=NAR:2349:0:9220:2:2041:0:filmfour.channel4.com
    More4;BSkyB:10729:vC56:S28.2E:22000:2361:2362=eng,2363=NAR:2364:0:8340:2:2042:0:more4.channel4.com
    E4;BSkyB:10729:vC56:S28.2E:22000:2315+2306:2317=eng,2319=NAR:2321:0:8305:2:2042:0:e4.channel4.com

You can create a cronjob to get the updating of the EPG data done
automatically, your crontab could look like this:

    00 00 * * * tv_grab_uk_rt --config-file ~/.xmltv/tv_grab_uk_rt.conf --quiet > /tmp/uk.xml
    05 00 * * * xmltv2vdr.pl -x /tmp/uk.xml -c /etc/xmltv2vdr/channels.conf

vdraepg

vdraepg is a Ruby-script which transfers EPG-data from one channel to
another, i.e., the data is not being downloaded from the Internet as
with XMLTV, but is already present in VDR's EPG-information.

This makes sense in some cases when, for example, a channel is available
on DVB-T, but does not have as elaborate an EPG as the same channel on
DVB-S (which, for instance, might even be encrypted). The script can
also be used to change the time information. So the script can transfer
EPG-data from, e.g., ITV2 to ITV2+1, just by adding one hour to the
EPG-information from ITV2.

You can install the package vdraepg from AUR. Read the file
/usr/share/doc/vdraepg/README.en for instructions on how to set vdreapg
up. An example configuration has been prepared
(etc/vdraepg/vdraepg.conf)

    #source-channel, target-channel, time-adjustment
    S28.2E-2-2044-10070, S28.2E-2-2041-10172, 60 #itv2, itv2+1
    S28.2E-2-2054-10260, S28.2E-2-2054-10261, 60 #itv3, itv3+1
    S28.2E-2-2042-8335, S28.2E-2-2042-8330, 60 #film4, film4+1
    S19.2E-1-1101-28106, T-0-562-1, 0 #ARD, DVBS --> DVB-T

Again it might make sense for you to have vdraepg run as a cronjob:

    10 00 * * * vdraepg.rb

> Streaming VDR

Over the Local Area Network (LAN)

Imagine having your computer running VDR somewhere in your study, living
room, or even in your cellar and watching live tv and recordings
provided by the same VDR on a deck chair in your garden. This whish can
be put into practice.

The very same plugin that we already used with budget cards we are going
to use again to show the VDR frontend on any computer on the LAN or
WLAN: vdr-plugin-xineliboutput.

On the remote computer the packages xine-lib-vdr and xine-ui-vdr,
availabe on AUR, have to be installed.

Adjust the file ~/.xine/keymap as described above to control VDR with
the keyboard.

Now watch your favorite movies any place in and around your house:

    xine "xvdr+tcp://<VDR's IP address>:37890#nocache" -D

Over the Internet

Theoretically, the concept of streaming VDR over LAN or WLAN with the
plugin vdr-xine can also be adopted to the Internet. The point is,
though, that the requirements in terms of bandwith will only be
fullfilled in very rare cases. To stream VDR without further compression
you are going to need an upstream speed of three or even more Mbit/s,
according to the bitrate of the broadcast. Therefore, John Doe has to
use highly optimized codecs like H.264 AVC and this is exactly what this
part of the tutorial about streaming VDR over the Internet will be
about.

Even though the quality of the video is visibly diminished, the result
looks startlingly great and you can watch live TV and recordings with
hardly any cutback.

You can control the remote VDR with either the [| LIVE plugin] or SVDRP
software like "VDR Remote Control" (unsecure, since the SVDRP port has
to be forwarded on your router). You can even use your iPhone or iPod
Touch with the application ZapperPro, available in the Apple Store. As a
requirement you need access to to the Internet through WLAN. Be careful
regarding the security issue when opening the SVDRP port to the
Internet.

Two concepts will be provided, since using the same techniques, the
quality of the resulting stream should be similar.

StreamDev Plugin

An easy approach and also the recommended one is to set up the plugin
Streamdev from ArchVDR.

Server

The plugin's config file (/etc/vdr/plugins/plugin.streamdev-server.conf)
has to have a reference to the file externremux.sh.

    -r /usr/bin/externremux.sh

That is the content of the file /usr/bin/externremux.sh, adjust it to
your liking:

    # externremux.sh

    # CONFIG START
      TMP=/tmp/externremux-${RANDOM:-$$}
      STREAMQUALITY="150"
    # CONFIG END

    mkdir -p $TMP
    mkfifo $TMP/out.avi
    (trap "rm -rf $TMP" EXIT HUP INT TERM ABRT; cat $TMP/out.avi) &

    case ${1:-$STREAMQUALITY} in
         "100") exec mencoder -ovc x264 -srate 22050 -x264encopts bitrate=100:vbv_maxrate=180:vbv_bufsize=300:ratetol=0.1:threads=3 -oac mp3lame -lameopts cbr:br=32:q=2:mode=3 -vf pp=ci,scale -zoom -xy 320 -o $TMP/out.avi -- - &>$TMP/out.log ;;
         "150") exec mencoder -ovc x264 -srate 22050 -x264encopts bitrate=150:vbv_maxrate=180:vbv_bufsize=300:ratetol=0.1:threads=3 -oac mp3lame -lameopts cbr:br=32:q=2:mode=3 -vf pp=ci,scale -zoom -xy 320 -o $TMP/out.avi -- - &>$TMP/out.log ;;
         "200") exec mencoder -ovc x264 -srate 22050 -x264encopts bitrate=200:vbv_maxrate=180:vbv_bufsize=300:ratetol=0.1:threads=3 -oac mp3lame -lameopts cbr:br=32:q=2:mode=3 -vf pp=ci,scale -zoom -xy 360 -o $TMP/out.avi -- - &>$TMP/out.log ;;
         "250") exec mencoder -ovc x264 -srate 22050 -x264encopts bitrate=250:vbv_maxrate=180:vbv_bufsize=300:ratetol=0.1:threads=3 -oac mp3lame -lameopts cbr:br=48:q=2:mode=3 -vf pp=ci,scale -zoom -xy 400 -o $TMP/out.avi -- - &>$TMP/out.log ;;
         "300") exec mencoder -ovc x264 -srate 22050 -x264encopts bitrate=300:vbv_maxrate=180:vbv_bufsize=300:ratetol=0.1:threads=3 -oac mp3lame -lameopts cbr:br=48:q=2:mode=3 -vf pp=ci,scale -zoom -xy 440 -o $TMP/out.avi -- - &>$TMP/out.log ;;
         "350") exec mencoder -ovc x264 -srate 22050 -x264encopts bitrate=350:vbv_maxrate=180:vbv_bufsize=300:ratetol=0.1:threads=3 -oac mp3lame -lameopts cbr:br=48:q=2:mode=3 -vf pp=ci,scale -zoom -xy 440 -o $TMP/out.avi -- - &>$TMP/out.log ;;
         "400") exec mencoder -ovc x264 -srate 22050 -x264encopts bitrate=400:vbv_maxrate=180:vbv_bufsize=300:ratetol=0.1:threads=3 -oac mp3lame -lameopts cbr:br=64:q=2:mode=3 -vf pp=ci,scale -zoom -xy 480 -o $TMP/out.avi -- - &>$TMP/out.log ;;
         "450") exec mencoder -ovc x264 -srate 22050 -x264encopts bitrate=450:vbv_maxrate=180:vbv_bufsize=300:ratetol=0.1:threads=3 -oac mp3lame -lameopts cbr:br=64:q=2:mode=3 -vf pp=ci,scale -zoom -xy 480 -o $TMP/out.avi -- - &>$TMP/out.log ;;
         "500") exec mencoder -ovc x264 -srate 22050 -x264encopts bitrate=500:vbv_maxrate=180:vbv_bufsize=300:ratetol=0.1:threads=3 -oac mp3lame -lameopts cbr:br=128:q=2:mode=3 -vf pp=ci,scale -zoom -xy 480 -o $TMP/out.avi -- - &>$TMP/out.log ;;
         "750") exec mencoder -ovc x264 -srate 22050 -x264encopts bitrate=750:vbv_maxrate=180:vbv_bufsize=300:ratetol=0.1:threads=3 -oac mp3lame -lameopts cbr:br=128:q=2:mode=3 -vf pp=ci -o $TMP/out.avi -- - &>$TMP/out.log ;;
         "1000") exec mencoder -ovc x264 -srate 22050 -x264encopts bitrate=1000:vbv_maxrate=180:vbv_bufsize=300:ratetol=0.1:threads=3 -oac mp3lame -lameopts cbr:br=128:q=2:mode=3 -vf pp=ci -o $TMP/out.avi -- - &>$TMP/out.log ;;

    	   *) touch $TMP/out.avi ;;
    esac

Client

On the client side only VLC has to be installed, you can start the
streaming process with

    vlc "http://<VDR's public IP>:3000/extern;250/19"

In this example, channel 19 is being streamed with the "250" option
resulting in 250 Kbit Video and 48 Kbit Audio streaming. Make sure to
forward port 3000 to the computer running VDR.

VLC

VLC is not only a well known multimedia player, but is also perfectly
suited to encode and stream video and audio. Therefore, we use it to
grab audio and video in order to encode and stream VDR over the
Internet. VLC has to be installed on the server as well as on the
client.

Server

Adjust "vb=250" (video bit rate) and "ab=48" (audio bit rate) in the
following commands according to your upload speed. The two values in the
example work great with an upstream of 384 Kbit/sec.

Full-Featured Cards Only

Start the video streaming on the computer running VDR with the following
command (for easy access you can include the command in
/etc/vdr/commands.conf):

    /usr/bin/cvlc -d v4l:// :v4l-vdev="/dev/video0" :v4l-adev="/dev/dsp" :v4l-norm=3 :v4l-frequency=-1 --sout #transcode{vcodec=h264,vb=250,scale=0.5,acodec=mp4a,ab=48,channels=1}:duplicate{dst=std{access=http,mux=ts,dst=0.0.0.0:1234}}'

Full-Featured and Budget Cards

You need to install the plugin vdr-xineliboutput, available on AUR. You
start the video streaming with the following command:

    cvlc http://localhost:37890 :http-caching=3000 :sout="#transcode{vcodec=h264,vb=200,scale=0.5,acodec=mp4a,ab=48,channels=1}:duplicate{dst=std{access=http,mux=ts,dst=0.0.0.0:1234}}"

Client

On the remote computer you can open the stream with the following
command. If the computer running VDR is behind a router, make sure the
port 1234 is being forwarded.

    vlc http://<VDR's public IP>:1234

Make sure to forward port 1234 to the computer running VDR.

Streaming to iPhone, iPad and iPod

Wouldn't it be great to access your VDR on the go, e.g., on the train or
just in a boring meeting ;-) Well, iStreamDev makes exactly that
possible. iStreamDev is a relatively new project with the aim of
watching live TV, playing VDR's recordings and even streaming arbitraty
video and audio files from your PC at home to Apple's mobile devices,
over Wifi as well as over UMTS. The setup is rather simple, just follow
the guide. To ensure you are motivated to get started, have a look at
some screenshots. Believe me, it is as awesome as it looks!

When configuring Apache and PHP, make sure to add your VDR video
directory to the open_basedir line in /etc/php/php_ini, e.g.

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/video/

As for now, to make it work on the iPad you have to use the git version.

Conclusion
----------

I remember having almost given up on setting up VDR on Arch Linux at the
very beginning because of the problem mentioned above with the wrongly
loaded module for my full-featured card. This guide might help some of
you to also get beyond the point of only trying to get VDR up and
running.

This guide is not intended to be complete and it never will be.
Hopefully, with the cooperation of you guys it will become more and more
detailed and useful.

References
----------

-   VDR Homepage
-   VDR Wiki
-   German User Forum

Retrieved from
"https://wiki.archlinux.org/index.php?title=VDR&oldid=239286"

Category:

-   Audio/Video
