JACK Audio Connection Kit
=========================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Install                                                            |
|     -   1.1 JACK2                                                        |
|     -   1.2 JACK                                                         |
|                                                                          |
| -   2 Basic Configuration                                                |
|     -   2.1 GUI                                                          |
|     -   2.2 Setup                                                        |
|         -   2.2.1 Overview                                               |
|         -   2.2.2 A Shell-Based Example Setup                            |
|             -   2.2.2.1 Details of the Shell-Based Example Setup         |
|                                                                          |
|         -   2.2.3 A GUI-Based Example Setup                              |
|         -   2.2.4 More                                                   |
|                                                                          |
| -   3 Jack for a multi-user system                                       |
|     -   3.1 Playing nice with ALSA                                       |
|     -   3.2 gstreamer                                                    |
|     -   3.3 PulseAudio                                                   |
|                                                                          |
| -   4 MIDI                                                               |
| -   5 Troubleshooting                                                    |
|     -   5.1 "Cannot lock down memory area (Cannot allocate memory)"      |
|         message on startup                                               |
|     -   5.2 jack2-dbus and qjackctl errors                               |
|     -   5.3 Problems with specific applications                          |
|         -   5.3.1 VLC - no audio after starting JACK                     |
|                                                                          |
| -   6 Related Articles                                                   |
+--------------------------------------------------------------------------+

Install
-------

In order for jack to work, your user needs to be added to the audio
group for direct access to hardware.

> JACK2

JACK2 is rewritten explicitly towards multiprocessor hardware. Install
it with jack2, available from the official repositories.

Also available is also Jack2 with D-Bus. It can be installed with
jack2-dbus. It is controlled by the jack_control utility. The important
commands are listed below:

    jack_control start  -  starts the jack server
    jack_control stop  - stops the jack server
    jack_control ds alsa  -  selects alsa as the driver (backend)
    jack_control eps realtime True  -  set engine parameters, such as realtime
    jack_control dps period 256  -  set the driver parameter period to 256

You may also need to play with the driver parameters nperiods and rate.

> JACK

Alternatively, there is the older JACK, installable with jack, available
from the official repositories.

Basic Configuration
-------------------

> GUI

No matter which JACK edition you are using, you will want a GUI
configurator. Probably the de facto standard right now, is qjackctl,
installable with the package qjackctl, available in the official
repositories.

> Setup

Overview

This Linux Magazine article is a very good general overview, although do
not worry about manual compilations, quite a few JACK tools work right
off the wire now, after JACK is configured correctly.

Most tutorials are advising a realtime kernel, which is quite helpful
for live synthesis and FX; but for purposes of recording and editing it
is not necessary, as long as you set up for non-realtime latencies --
10-40+ ms (100-500+ ms for older hardware).

The right configuration for your hardware and application needs, depends
on several factors.

A Shell-Based Example Setup

The D-Bus edition of JACK2 can make startup much easier. Formerly, we
had to have qjackctl start it for us, or use a daemonizer, or some other
method. But as long as jack2-dbus is installed and dbus is running
(which it should be in Arch), we can create a shell script as follows,
to be run at X login:

    start_jack.sh

    #!/bin/bash
    jack_control start
    sudo schedtool -R -p 20 `pidof jackdbus`
    jack_control eps realtime true
    jack_control ds alsa
    jack_control dps device hw:HD2
    jack_control dps rate 48000
    jack_control dps nperiods 2
    jack_control dps period 64
    sleep 10
    /usr/bin/a2jmidid -e &
    sleep 10
    sudo schedtool -R -p 20 `pidof a2jmidid`
    qjackctl &
    sleep 10
    sudo schedtool -R -p 20 `pidof qjackctl`
    qmidiroute /home/jeb/All2MIDI1.qmr &
    sleep 10
    sudo schedtool -R -p 20 `pidof qmidiroute`
    yoshimi -S &
    sleep 10
    sudo schedtool -R -p 20 `pidof yoshimi`

The above will start a complete realtime JACK live-synthesis setup,
integrating several tools. Details of each line follow. When discovering
your own best configuration, it is helpful to do trial and error using
QJackCTL's GUI with a non-D-Bus JACK2 version.

Details of the Shell-Based Example Setup

    jack_control start

Starts JACK if it is not already started.

    sudo schedtool -R -p 20 `pidof jackdbus`

Set JACK to realtime mode in the Linux kernel, priority 20 (options
range 1-99).

    jack_control eps realtime true

Sets JACK to realtime mode in its own internal setup.

    jack_control ds alsa

Sets JACK to use the ALSA driver set.

    jack_control dps device hw:HD2

Sets JACK to use ALSA-compatible sound card named HD2. One can find the
names with 'ls /proc/asound/cards'. Most ALSA tutorials and default
configurations use card numbers, but this can get confusing when
external MIDI devices are in use; names make it easier.

    jack_control dps rate 48000

Sets JACK to use 48000 khz sampling. Happens to work very well with this
card. Some cards only do 44100, many will go much higher. The higher you
go, the lower your latency, but the better your card and your CPU has to
be, and software has to support this as well.

    jack_control dps nperiods 2

Sets JACK to use 2 periods. 2 is right for motherboard, PCI, PCI-X,
etc.; 3 for USB.

    jack_control dps period 64

Sets JACK to use 64 periods per frame. Lower is less latency, but the
setting in this script gives 2.67 ms latency, which is nicely low
without putting too much stress on the particular hardware this example
was built for. If a USB sound system were in use it might be good to try
32. Anything less than 3-4 ms should be fine for realtime synthesis
and/or FX, 5 ms is the smallest a human being can detect. There are many
cases of perfect-storm-gorgeous hardware which can handle 1 ms latency
without stressing the CPU, but definitely this is not always the case!
QJackCTL will tell you how you are doing; at no-load, which means no
clients attached, you will want a max of 3-5% CPU usage, and if you
cannot get that without xruns (the red numbers which mean the system
cannot keep up with the demands), you will have to improve your
hardware. There are many inexpensive USB sound systems which produce
very good quality at very low latency if the USB is good on the
motherboard, but not all.

    sleep 10

Wait for the above to settle.

    /usr/bin/a2jmidid -e &

Start the ALSA-to-JACK MIDI bridge. Good for mixing in applications
which take MIDI input through ALSA but not JACK.

    sleep 10

Wait for the above to settle.

    sudo schedtool -R -p 20 `pidof a2jmidid`

Set a2jmidid to realtime scheduling in the Linux kernel.

    qjackctl &

Load QJackCTL. GUI configuration tells it to run in the system tray. It
will pick up the JACK session started by D-Bus just fine, and very
smoothly too. It maintains the patchbay, the connections between these
applications and any other JACK-enabled apps to be started manually. The
patchbay is set up using manual GUI, but connections pre-configured in
the patchbay are automatically created by qjackctl itself when apps are
started.

    sleep 10

Wait for the above to settle.

    sudo schedtool -R -p 20 `pidof qjackctl`

Set qjackctl to realtime scheduling in the Linux kernel.

    qmidiroute /home/username/All2MIDI1.qmr &

Load qmidiroute, loading a custom-created configuration file which will
rewrite all MIDI events on all channels to channel 1. This is useful
when plugging the PC into any keyboard anywhere -- no matter what the
keyboard's channel defaults to, qmidiroute will send the signal to the
synth on channel 1, where it needs it. qmidiroute is capable of very
complex and useful configurations of many sorts, including multiple
simultaneous translations, transpositions, signal type rewrites,
etcetera.

    sleep 10

Wait for the above to settle.

    sudo schedtool -R -p 20 `pidof qmidiroute`

Set qmidiroute to realtime scheduling in the Linux kernel.

    yoshimi -S &

Load the Yoshimi synthesizer, using the pre-saved default state.

    sleep 10

Wait for the above to settle.

    sudo schedtool -R -p 20 `pidof yoshimi`

Set Yoshimi to realtime scheduling in the Linux kernel.

With all of the above in a script run at logon, and with the QJackCtl
patchbay set correctly, all we have to do is plug the PC/laptop into a
MIDI keyboard using a USB-to-MIDI adapter, or simply the USB-in MIDI
capability of many modern keyboards, and you are ready to play!

The essence of QJackCtl is described fairly well in this article.

A GUI-Based Example Setup

The shell-based example above, lays out in detail lots of things you may
well need to know, and it does work well. If you want something much
more GUI, however, do this:

-   Install jack2-dbus.

-   Copy /etc/asound.conf to /etc/asound.conf.ORIGINAL, and replace it
    with this:

    pcm.pulse {
        type pulse
    }
    ctl.pulse {
        type pulse
    }
    pcm.!default {
        type pulse
    }
    ctl.!default {
        type pulse
    }

-   Install pulseaudio.
-   Install pulseaudio-alsa.
-   Install qjackctl, and tell your GUI window/desktop system to run it
    at startup.
-   Make sure qjackctl is told to:
    -   use the D-Bus interface,
    -   run at startup,
    -   save its configuration to the default location,
    -   start the JACK audio server on application startup,
    -   enable the system tray icon, and
    -   start minimized to ssytem tray.

-   Reboot.
-   After logging in, you will see QJackCtl in your system tray.
    Left-click on it.
-   Start tweaking in the QJackCtl GUI. The info embedded in the
    shell-script setup above may be of some help :-) As may be the info
    in this article. Just remember that you have to get your latency
    down to less than 5ms for live tone production or filtration of any
    sort, or the delay will be obvious to player and listener alike.
-   From the AUR, install non-daw. One of the components of this package
    is called non-session-manager; it has the function of setting up
    "sessions": sets of other audio software items which Jack (through
    the QJackCtl patchbay or not!) will wire together. NSM can handle as
    many different sessions as you wish to set up; and as a result, it's
    all GUI, apart from the one rc.local edit in the beginning.

More

Yet more info is in the Pro Audio page.

Jack for a multi-user system
----------------------------

So, you have a decent multiuser system as it was designed more than 20
years ago, and now some developers decided that sound is only for a
mono-user system... No I can not believe it !

Warning:Before following the below instructions, please note that there
is a security risk to any service running as root, and, more
importantly, the developers for jack do not test it for running as root.
In other words, it could eat your babies, data, or both

Fortunately some time ago someone convinced the developers to allow jack
to run as a system wide daemon. Here is the procedure to follow:

Create a /etc/profile.d/jack.sh file containing:

    export JACK_PROMISCUOUS_SERVER=""

Replace /etc/rc.d/jack-audio-connection-kit with the following content

    #!/bin/bash 

    . /etc/rc.conf
    . /etc/rc.d/functions

    # source application-specific settings
    [ -f /etc/conf.d/jack-audio-connection-kit ] && . /etc/conf.d/jack-audio-connection-kit

    PID=`pidof -o %PPID /usr/bin/jackd`

    [ -n "$JACKUSER" ] && HOME="/home/$JACKUSER"
    [ -z "$JACK_PARAMS" ] && JACK_PARAMS=$(sed 's:/usr/bin/jackd ::' $HOME/.jackdrc)

    case "$1" in
      start)
        stat_busy "Starting JACK"
        if [ -z "$PID" ]; then
          if [ -n "$JACKUSER" ]; then
            su - $JACKUSER -c 'export JACK_PROMISCUOUS_SERVER="" && . /etc/conf.d/jack-audio-connection-kit && umask 0000 && /usr/bin/jackd $JACK_PARAMS &> /dev/null &'
          else
    	export JACK_PROMISCUOUS_SERVER=""
    	umask 0000
            /usr/bin/jackd $JACK_PARAMS &> /dev/null &
          fi
        fi

        if [ ! -z "$PID" -o $? -gt 0 ]; then
          stat_fail
        else
          add_daemon jack
          stat_done
        fi
        ;;
      stop)
        stat_busy "Stopping JACK"
        [ ! -z "$PID" ]  && kill $PID &> /dev/null
        if [ $? -gt 0 ]; then
          stat_fail
        else
          rm_daemon jack
          stat_done
        fi
        ;;
      restart)
        $0 stop
        sleep 1
        $0 start
        ;;
      *)
        echo "usage: $0 {sta|stop|restart}"
    esac
    exit 0

Where my /etc/conf.d/jack-audio-connection-kit is

    # Configuration for starting JACK at boot

    # Uncomment this to run as user (recommended)
    #JACKUSER="root"

    # Uncomment this to not source ~/.jackdrc
    JACK_PARAMS="-R -P89 -dalsa -dhw:1 -r48000 -p512 -n3"

> Playing nice with ALSA

To allow Alsa programs to play while jack is running you must install
the jack plugin for alsa:

    pacman -S alsa-plugins

And enable it by editing (or creating) /etc/asound.conf (system wide
settings) to have these lines:

    # convert alsa API over jack API
    # use it with
    # % aplay foo.wav

    # use this as default
    pcm.!default {
        type plug
        slave { pcm "jack" }
    }

    ctl.mixer0 {
        type hw
        card 1
    }

    # pcm type jack
    pcm.jack {
        type jack
        playback_ports {
            0 system:playback_1
            1 system:playback_2
        }
        capture_ports {
            0 system:capture_1
            1 system:capture_2
        }
    }

You need not restart your computer or anything. Just edit the alsa
config files, start up jack, and there you go...

Remember to start it as a user. If you start it with "jackd -d alsa" as
user X, it will not work for user Y.

> gstreamer

Example: watching a live stream without gconf

    gst-launch-0.10 playbin2 uri=http://streamer.stackingdwarves.net/bewerungeroom.ogv audio-sink="jackaudiosink"

Setting gstreamer to use jack using gconftool-2

    gconftool-2 --type string --set /system/gstreamer/0.10/audio/default/audiosink "jackaudiosink buffer-time=2000000"
    gconftool-2 --type string --set /system/gstreamer/0.10/audio/default/musicaudiosink "jackaudiosink buffer-time=2000000"
    gconftool-2 --type string --set /system/gstreamer/0.10/audio/default/chataudiosink "jackaudiosink buffer-time=2000000"

Further information: http://jackaudio.org/gstreamer_via_jack

> PulseAudio

If you need to keep pulseaudio installed (in the event it is required by
other packages, like gnome-settings-daemon), you may want to prevent it
from spawning automatically with X and taking over from JACK.

Edit /etc/pulse/client.conf, uncomment "autospawn" and set it to "no":

    ;autospawn = yes
    autospawn = no

If you want both to play along, see:
PulseAudio/Examples#PulseAudio_through_JACK_the_new_new_way

MIDI
----

JACK can handle one soundcard very well, and an arbitrary number of MIDI
devices (connected e.g. via USB). If you start JACK and want to use a
MIDI keyboard or a synthesizer or some other pure MIDI device, you have
to start JACK with a proper soundcard (one that actually outputs or
inputs PCM sound). As soon you have done that, you can connect the MIDI
device. E.g. with QjackCtl (qjackctl), you click on the connect button
and you will find your device listed under JACK-MIDI or ALSA-MIDI,
depending on the driver.

For JACK-MIDI, you may want to set the MIDI Driver to seq or raw in
QjackCtl Setup > Settings. This should make your MIDI device appear
under the MIDI tab. You can also change the name of the client (from a
generic "midi_capture_1" to something more descriptive), if you enable
Setup > Display > Enable client/port aliases and then Enable client/port
aliases editing (rename).

For ALSA-MIDI, make sure to turn on Enable ALSA Sequencer support in
QjackCtl Setup > Misc. This will add the ALSA tab in QjackCtl Connect
window where your MIDI controller will show up.

For bridging ALSA-MIDI to JACK-MIDI, you may consider using a2jmidid
(a2jmidid). The following command will export all available ALSA MIDI
ports to JACK MIDI ports:

    $ a2jmidid -e

They will be visible in QjackCtl under the MIDI tab labelled "a2j"
client. You can automate starting of a2jmidid by adding to QjackCtl
Setup > Options > Execute script after Startup: /usr/bin/a2jmidid -e &

Note:When connecting MIDI keyboard controllers in QjackCtl, make sure to
Expand All first and connect the desired Output Ports (below the
Readable Clients) to the Input Ports (below the Writable Clients). As a
shortcut, if you select a writable client instead of individual ports as
your destination, it should connect all its currently displayed output
ports underneath.

-   Q: What is the difference between JACK-MIDI and ALSA-MIDI?
-   A: The former has improved timing and sample accurate MIDI event
    alignment. It extends or may even replace the latter but at this
    point they both co-exist.

To install some M-Audio MIDI keyboards, you will need the firmware
package midisport-firmware in the AUR. Also, the snd_usb_audio module
has to be available. For more information about specific USB MIDI
devices, see http://alsa.opensrc.org/USBMidiDevices.

Troubleshooting
---------------

> "Cannot lock down memory area (Cannot allocate memory)" message on startup

See Realtime for Users#Add user to audio group.

> jack2-dbus and qjackctl errors

Still having the "Cannot allocate memory" and/or "Cannot connect to
server socket err = No such file or directory" error(s) when pressing
qjackctl's start button (assuming that you have package jack2-dbus
installed) ?

Please delete ~/.jackdrc, ~/.config/jack/conf.xml,
~/.config/rncbc.org/QjackCtl.conf. Kill jackdbus and restart from
scratch :) (Thanks to nedko)

> Problems with specific applications

VLC - no audio after starting JACK

Run VLC and change the following menu options:

-   Tools > Preferences
-   Show settings: All
-   Audio > Output modules > Audio output module: JACK audio output
-   Audio > Output modules > JACK: Automatically connect to writable
    clients (enable)

Related Articles
----------------

-   Pro Audio

Retrieved from
"https://wiki.archlinux.org/index.php?title=JACK_Audio_Connection_Kit&oldid=252133"

Category:

-   Audio/Video
