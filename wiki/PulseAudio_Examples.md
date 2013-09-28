PulseAudio/Examples
===================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Simultaneous HDMI and Analog Output                                |
| -   2 Surround sound systems                                             |
|     -   2.1 Splitting front/rear                                         |
|     -   2.2 LFE remixing                                                 |
|                                                                          |
| -   3 Advanced ALSA Configuration                                        |
|     -   3.1 ALSA Monitor source                                          |
|                                                                          |
| -   4 HDMI output configuration                                          |
|     -   4.1 Finding HDMI output                                          |
|     -   4.2 Testing for the correct card                                 |
|     -   4.3 Manually configuring pulseaudio to detect the Nvidia HDMI    |
|                                                                          |
| -   5 PulseAudio over network                                            |
|     -   5.1 TCP support (networked sound)                                |
|     -   5.2 TCP support with anonymous clients                           |
|     -   5.3 Zeroconf (Avahi) publishing                                  |
|     -   5.4 Switching the PulseAudio server used by local X clients      |
|     -   5.5 When everything else seems to fail                           |
|                                                                          |
| -   6 PulseAudio through JACK the new new way                            |
| -   7 PulseAudio through JACK the new way                                |
| -   8 Pulseaudio through JACK the old way                                |
|     -   8.1 QjackCtl with Startup/Shutdown Scripts                       |
|                                                                          |
| -   9 Pulseaudio through OSS                                             |
| -   10 Pulseaudio from within a chroot (ex. 32-bit chroot in 64-bit      |
|     install)                                                             |
| -   11 System-wide Equalizer                                             |
|     -   11.1 pulseaudio-equalizer                                        |
|     -   11.2 qpaeq                                                       |
|                                                                          |
| -   12 Disabling Auto Spawning of PulseAudio Server                      |
+--------------------------------------------------------------------------+

> Simultaneous HDMI and Analog Output

PulseAudio allows for simultaneous output to multiple sources. In this
example, some applications are configured to use HDMI while others are
configured to use analog. Multiple applications are able to receive
audio at the same time.

Note: To list devices aplay is used. This program is part of the
alsa-utils package and is NOT required to output to multiple sources. It
is required to list playback devices therefore users can remove this
package when finished with it.

First, users need to understand the system's audio layout. This is
accomplished using aplay which is part of the alsa-utils package.

    $ aplay -l
    **** List of PLAYBACK Hardware Devices ****
    card 0: Intel [HDA Intel], device 0: ALC889A Analog [ALC889A Analog]
      Subdevices: 0/1
      Subdevice #0: subdevice #0
    card 0: Intel [HDA Intel], device 1: ALC889A Digital [ALC889A Digital]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 0: Intel [HDA Intel], device 3: HDMI 0 [HDMI 0]
      Subdevices: 0/1
      Subdevice #0: subdevice #0

The key to a configuration like this is to understand that whatever is
selected in pavucontrol under Configuration>Internal AUdio is the
default device. Load pavucontrol>Configuration and select HDMI as the
profile.

Add the following to /etc/pulse/default.pa to setup the analog as a
secondary source:

    ### Load analog device
    load-module module-alsa-sink device=hw:0,0
    load-module module-combine-sink sink_name=combined
    set-default-sink combined

Restart PulseAudio, run pavucontrol and select the "Output Devices" tab.
Three settings should be displayed:

1.  Internal Audio Digital Stereo (HDMI)
2.  Internal Audio
3.  Simultaneous output to Internal Audio Digital Stereo (HDMI),
    Internal Audio

Now start a program that will use pulseaudio such as mplayer, vlc, mpd,
etc. and switch to the "Playback" tab. A pulldown should be available
for the running program to select one of the three sources.

Also see this thread for a variation on this theme and PulseAudio FAQ.

> Surround sound systems

Many people have a surround card, but have speakers for just two
channels, so PulseAudio cannot really default to a surround setup. To
enable all the channels, edit /etc/pulse/daemon.conf: uncomment the
default-sample-channels line (i.e. remove the semicolon from the
beginning of the line) and set the value to 6 For a 5.1 setup, or 8 for
a 7.1 setup etc.

    # Default
    default-sample-channels=2
    # For 5.1
    default-sample-channels=6
    # For 7.1
    default-sample-channels=8

After doing the edit, restart Pulseaudio.

Splitting front/rear

Connect speakers to front analog output and headphones to rear output.
It would be usefull to split front/rear to separate sinks. Add to
/etc/pulse/default.pa:

     load-module module-remap-sink sink_name=speakers remix=no master=alsa_output.pci-0000_05_00.0.analog-surround-40 channels=2 master_channel_map=front-left,front-right channel_map=front-left,front-right
     load-module module-remap-sink sink_name=headphones remix=no master=alsa_output.pci-0000_05_00.0.analog-surround-40 channels=2 master_channel_map=rear-left,rear-right   channel_map=front-left,front-right

(replace alsa_output.pci-0000_05_00.0.analog-surround-40 in the sound
card name shown from 'pacmd list-sinks')

Switch player between speakers and headphones.

LFE remixing

By default Pulseaudio remixes the number of channels to the
default-sample-channels, however it dose not do this for the LFE
channel. To enable LFE remixing uncomment the line:

    ; enable-lfe-remixing = no

and replace no with yes:

    enable-lfe-remixing = yes

then restart Pulseaudio.

> Advanced ALSA Configuration

In order for ALSA to use PulseAudio it needs a special /etc/asound.conf
(system wide settings) (recommended) or ~/.asoundrc (settings on a per
user basis):

    /etc/asound.conf

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

Omission of the last two groups will cause Pulseaudio not to be used by
default. Change the ALSA device to "pulse" in the applications to make
it work.

Note:The above configuration is provided by the package pulseaudio-alsa.

ALSA Monitor source

To be able to record from a monitor source (a.k.a. "What-U-Hear",
"Stereo Mix"), use pactl list to find out the name of the source in
Pulseaudio (e.g. alsa_output.pci-0000_00_1b.0.analog-stereo.monitor).
Then add lines like the following to /etc/asound.conf or ~/.asoundrc:

    pcm.pulse_monitor {
      type pulse
      device alsa_output.pci-0000_00_1b.0.analog-stereo.monitor
    }

    ctl.pulse_monitor {
      type pulse
      device alsa_output.pci-0000_00_1b.0.analog-stereo.monitor
    }

Now you can select pulse_monitor as a recording source.

Alternatively, you can use pavucontrol to do this : make sure you've set
up the display to "All input Devices", then select "Monitor of [your
soundcard]" as the recording source.

> HDMI output configuration

As outlined in
ftp://download.nvidia.com/XFree86/gpu-hdmi-audio-document/gpu-hdmi-audio.html#_issues_in_pulseaudio
unless the hdmi port is the first output, PulseAudio will not be able to
have any audio when using certain graphics cards with hdmi audio
support. This is because of a bug in pulseaudio where it will only
select the first HDMI output on a device. A work around posted further
down is to first find which hdmi output is working by using the aplay
utility from alsa.

The original title for this section indicated the problem is specific to
nVidia cards. As seen in this forum thread other cards are affected as
well. The rest of the section will use an nVidia card as a case-study
but the solution should carry over for people using other affected
cards.

Finding HDMI output

Then find the working output by listing the available cards

    # aplay -l

    sample output:
     **** List of PLAYBACK Hardware Devices ****
     card 0: NVidia [HDA NVidia], device 0: ALC1200 Analog [ALC1200 Analog]
       Subdevices: 1/1
       Subdevice #0: subdevice #0
     card 0: NVidia [HDA NVidia], device 3: ALC1200 Digital [ALC1200 Digital]
       Subdevices: 1/1
       Subdevice #0: subdevice #0
     card 1: NVidia_1 [HDA NVidia], device 3: HDMI 0 [HDMI 0]
       Subdevices: 1/1
       Subdevice #0: subdevice #0
     card 1: NVidia_1 [HDA NVidia], device 7: HDMI 0 [HDMI 0]
       Subdevices: 0/1
       Subdevice #0: subdevice #0
     card 1: NVidia_1 [HDA NVidia], device 8: HDMI 0 [HDMI 0]
       Subdevices: 1/1
       Subdevice #0: subdevice #0
     card 1: NVidia_1 [HDA NVidia], device 9: HDMI 0 [HDMI 0]
       Subdevices: 1/1
       Subdevice #0: subdevice #0

Testing for the correct card

Now a list of the detected cards is known, users will need to test for
which one is outputing to the tv/monitor

    # aplay -D plughw:1,3 /usr/share/sounds/alsa/Front_Right.wav

where 1 is the card and 3 is the device substitute in the values listed
from the previous section. If there is no audio then try substituting a
different device (on my card I had to use card 1 device 7)

Manually configuring pulseaudio to detect the Nvidia HDMI

Having identified which HDMI device is working, PulseAudio can be fored
to use it via an edit to

    /etc/pulse/default.pa

:

    # load-module module-alsa-sink device=hw:1,7

where the 1 is the card and the 7 is the deivce found to work in the
previous section

restart pulse audio

    # killall pulseaudio

open the sound settings manager, make sure that under the hardware tab
the graphics cards HDMI audio is set to "Digital Stereo (HDMI) Output" (
My graphics card audio is called "GF100 High Definition Audio
Controller"

Then open the output tab there should now be two HDMI outputs for the
graphics card test which one works by selecting one of them and then
using a program to play audio i.e use vlc to play a movie if it doesn't
work the select the other.

> PulseAudio over network

One of PulseAudio's magnificent features is the possibility to stream
audio from clients over TCP to the server running the PulseAudio daemon,
allowing sound to be streamed through the LAN.

To accomplish this, one needs to enable module-native-protocol-tcp, and
copy the pulse-cookie to the clients.

TCP support (networked sound)

To enable the TCP module, add this to (or uncomment, if already there)
/etc/pulse/default.pa:

    load-module module-native-protocol-tcp

Note: If experiencing trouble connecting, use (on server)

    pacmd list-modules

TCP support with anonymous clients

If it is undesirable to copy the pulse-cookies from clients, allow
anonymous clients, by giving these parameters to
module-native-protocol-tcp (again in /etc/pulse/default.pa):

     load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1;192.168.0.0/24 auth-anonymous=1

Remember to change the LAN ip prefix should it be different from
192.168.0.0.

Zeroconf (Avahi) publishing

For the remote Pulseaudio server to appear in the PulseAudio Device
Chooser (padevchooser), load the appropriate zeroconf modules, and
enable the Avahi daemon.

On both machines run:

    $ systemctl start avahi-daemon.service
    $ systemctl enable avahi-daemon.service

On the server, add load-module module-zeroconf-publish to
/etc/pulse/default.pa, on the client, add
load-module module-zeroconf-discover to /etc/pulse/default.pa. Now
redirect any stream or complete audio output to the remote pulseaudio
server by selecting the appropriate sink.

Switching the PulseAudio server used by local X clients

To switch between servers on the client from within X, the pax11publish
command can be used. For example, to switch from the default server to
the server at hostname foo:

    $ pax11publish -e -S foo

Or to switch back to the default:

    $ pax11publish -e -r

Note that for the switch to become apparent, the programs using Pulse
must be restarted.

When everything else seems to fail

The following is a quickfix and NOT a permanent solution

On the Server:

     $ paprefs 

Go to Network Access -> Enable access to local sound devices (Also check
both 'Allow discover' and 'Don't require authentication').

On the Client:

     $ export PULSE_SERVER=server.ip && mplayer test.mp3

> PulseAudio through JACK the new new way

This configuration only works with jackdbus (JACK2 compiled with D-Bus
support). Add to /etc/pulse/default.pa:

    load-module module-jackdbus-detect

As described on the Jack-DBUS Packaging page:

Server auto-launching is implemented as D-Bus call that auto-activates
JACK D-Bus service, in case it is not already started, and starts the
JACK server. Correct interaction with PulseAudio is done using a D-Bus
based audio card "acquire/release" mechanism. When JACK server starts,
it asks this D-Bus service to acquire the audio card and PulseAudio will
unconditionally release it. When JACK server stops, it releases the
audio card that can be grabbed again by PulseAudio.

module-jackdbus-detect.so dynamically loads and unloads module-jack-sink
and module-jack-source when jackdbus is started and stopped.

If PulseAudio sound does not work, check with pavucontrol to see if the
relevant programs appear in the playback tab. If not, add the following
to ~/.asound.conf or /etc/asound.conf to redirect ALSA to PulseAudio:

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

If it still doesn't work, check with pavucontrol in the playback tab and
make sure the relevant programs are outputting to PulseAudio JACK Sink
instead of your audio card (which JACK has control of, so it won't
work).

> PulseAudio through JACK the new way

The basic idea is that killing PulseAudio is bad idea, it may crash any
apps using PulseAudio, and disrupt any audio playing

the flow of how this setup works:

1.  PulseAudio releases the sound card
2.  JACK grabs sound card and starts up
3.  script redirects PulseAudio to JACK
4.  manually send PulseAudio apps to JACK output (pavucontrol may come
    in helpful for this)
5.  use JACK programs etc
6.  via script, stop redirecting PulseAudio to JACK
7.  stop JACK and release soundcard
8.  PulseAudio grabs sound card and reroutes audio to it directly

with QJackCTL setup these scripts:

pulse-jack-pre-start.sh set it up as the execute script on startup
script

    #!/bin/bash
    pacmd suspend true

pulse-jack-post-start.sh set this one up as execute script after startup

    #!/bin/bash
    pactl load-module module-jack-sink channels=2
    pactl load-module module-jack-source channels=2
    pacmd set-default-sink jack_out
    pacmd set-default-source jack_in

pulse-jack-pre-stop.sh "execute script on shutdown"

    #!/bin/bash
    SINKID=$(pactl list | grep -B 1 "Name: module-jack-sink" | grep Module | sed 's/[^0-9]//g')
    SOURCEID=$(pactl list | grep -B 1 "Name: module-jack-source" | grep Module | sed 's/[^0-9]//g')
    pactl unload-module $SINKID
    pactl unload-module $SOURCEID
    sleep 5

pulse-jack-post-stop.sh "execute script after shutdown"

    #!/bin/bash
    pacmd suspend false

> Pulseaudio through JACK the old way

The JACK-Audio-Connection-Kit is popular for audio work, and is widely
supported by Linux audio applications. It fills a similar niche as
Pulseaudio, but with more of an emphasis on professional audio work. In
particular, audio applications such as Ardour and Audacity (recently)
work well with Jack.

Pulseaudio provides module-jack-source and module-jack-sink which allow
Pulseaudio to be run as a sound server above the JACK daemon. This
allows the usage of per-volume adjustments and the like for the apps
which need it, play-back apps for movies and audio, while allowing
low-latency and inter-app connectivity for sound-processing apps which
connect to JACK. However, this will prevent Pulseaudio from directly
writing to the sound card buffers, which will increase overall CPU
usage.

To just try PA on top of jack, have PA load the necessary modules on
start:

    pulseaudio -L module-jack-sink -L module-jack-source

To use pulseaudio with JACK, JACK must be started up before Pulseaudio,
using whichever method one prefers. sPulseaudio then needs to be started
loading the 2 relevant modules. Edit /etc/pulse/default.pa, and change
the following region:

    ### Load audio drivers statically (it is probably better to not load
    ### these drivers manually, but instead use module-hal-detect --
    ### see below -- for doing this automatically)
    #load-module module-alsa-sink
    #load-module module-alsa-source device=hw:1,0
    #load-module module-oss device="/dev/dsp" sink_name=output source_name=input
    #load-module module-oss-mmap device="/dev/dsp" sink_name=output source_name=input
    #load-module module-null-sink
    #load-module module-pipe-sink

    ### Automatically load driver modules depending on the hardware available
    .ifexists module-udev-detect.so
    load-module module-udev-detect
    .else
    ### Alternatively use the static hardware detection module (for systems that
    ### lack udev support)
    load-module module-detect
    .endif

to the following:

    ### Load audio drivers statically (it is probably better to not load
    ### these drivers manually, but instead use module-hal-detect --
    ### see below -- for doing this automatically)
    #load-module module-alsa-sink
    #load-module module-alsa-source device=hw:1,0
    #load-module module-oss device="/dev/dsp" sink_name=output source_name=input
    #load-module module-oss-mmap device="/dev/dsp" sink_name=output source_name=input
    #load-module module-null-sink
    #load-module module-pipe-sink
    load-module module-jack-source
    load-module module-jack-sink

    ### Automatically load driver modules depending on the hardware available
    #.ifexists module-udev-detect.so
    #load-module module-udev-detect
    #.else
    ### Alternatively use the static hardware detection module (for systems that
    ### lack udev support)
    #load-module module-detect
    #.endif

Basically, this prevents module-udev-detect from loading.
module-udev-detect will always try to grab the sound-card (JACK has
already done that, so this will cause an error). Also, the jack source
and sink must be explicitly loaded.

QjackCtl with Startup/Shutdown Scripts

Using the settings listed above, use QjackCtl to execute a script upon
startup and shutdown to load/unload PulseAudio. Part of the reason users
may wish to do this is that the above changes disable PulseAudio's
automatic hardware detection modules. This particular setup is for using
PulseAudio in an exclusive fashion with JACK, though the scripts could
be modified to unload and load an alternate non-JACK setup, but killing
and starting PulseAudio while programs might be using it would become
problematic.

The following example could be used and modified as necessary as a
startup script that daemonizes PulseAudio and loads the padevchooser
program (optional, needs to be built from AUR) called jack_startup:

    #!/bin/bash
    #Load PulseAudio and PulseAudio Device Chooser

    pulseaudio -D
    padevchooser&

as well as a shutdown script to kill PulseAudio and the Pulse Audio
Device Chooser, as another example called jack_shutdown also in the home
directory:

    #!/bin/bash
    #Kill PulseAudio and PulseAudio Device Chooser

    pulseaudio --kill
    killall padevchooser

Both scripts need to be made executable:

    chmod +x jack_startup jack_shutdown

then with QjackCtl loaded, click on the Setup button and then the
Options tab and tick both "Execute Script after Startup:" And "Execute
Script on Shutdown:" and put either use the ... button or type the path
to the scripts (assuming the scripts are in the home directory)
~/jack_startup and ~/jack_shutdown making sure to save the changes.

> Pulseaudio through OSS

Add the following to /etc/pulse/default.pa:

     load-module module-oss

Then start Pulseaudio as usual making sure that sinks and sources are
defined forOSS devices.

> Pulseaudio from within a chroot (ex. 32-bit chroot in 64-bit install)

Since a chroot sets up an alternative root for the running/jailing of
applications, pulseaudio must be installed within the chroot itself
(pacman -S pulseaudio within the chroot environment).

Pulseaudio, if not set up to connect to any specific server (this can be
done in /etc/pulse/client.conf, through the PULSE_SERVER environment
variable, or through publishing to the local X11 properties using
module-x11-publish), will attempt to connect to the local pulse server,
failing which it will spawn a new pulse server. Each pulse server has a
unique ID based on the machine-id value in /var/lib/dbus. To allow for
chrooted apps to access the pulse server, the following directories must
be mounted within the chroot:-

    /var/run
    /var/lib/dbus
    /tmp
    ~/.pulse

/dev/shm should also be mounted for efficiency and good performance.
Note that mounting /home would normally also allow sharing of the
~/.pulse folder.

For specific direction on accomplishing the appropriate mounts, please
refer to the wiki on installing a bundled 32-bit system, especially the
additional section specific to Pulseaudio.

> System-wide Equalizer

Pulseaudio can be configured to sound much better through the use of a
system-wide equalizer. There are a few tools to do this. Extra
information on the cons of each here . Individual apps can be excluded
via pavucontrol .

pulseaudio-equalizer

A simple, user-friendly gtk tool in the AUR: here.

Note: If users remove pulseaudio-equalizer, be sure should comment out
the respective generated section in  $HOME/.pulse/default.pa or risk
strange issues.

Note:If users have trouble with the volume resetting to the maximum
level or making harsh noise upon switching sound sources, do this and
then find the "Equalized audio configuration" section in
 $HOME/.pulse/default.pa and comment out only the "set-sink-volume" line
there.

qpaeq

A simple qt tool that comes with pulseaudio and includes support for
more bands than pulseaudio-equalizer (just resize the window
horizontally), but presently lacks easily accessible presets and may
need to be set as the default manually. Located at /usr/bin/qpaeq and
requires python2-pyqt to run.

Note: If qpaeq crashes at startup, be sure that
load-module module-equalizer-sink is in /etc/pulse/default.pa or
$HOME/.pulse/default.pa

Note: If the equalizer has no effect (e.g., setting the qpaeq preamp bar
to zero doesn't mute all sound), check that a link to applications'
audio sinks to the equalizer. Do this by adding the line
set-default-sink equalized to /etc/pulse/default.pa or
$HOME/.pulse/default.pa.

> Disabling Auto Spawning of PulseAudio Server

Some users may prefer to manually start the pulseaudio server before
running certain programs and then stop the pulseaudio server when they
are finished. A simple way to accomplish this is to edit
/etc/pulse/client.conf and change autospawn = yes to autospawn = no, and
set daemon-binary to /bin/true. Make sure the two lines are uncommented
as well.

    /etc/pulse/client.conf

    autospawn = no
    daemon-binary = /bin/true 

Now you can manually start the pulseaudio server with

    $ pulseaudio --start

and stop it with

    $ pulseaudio --kill

You may also have to move or delete a .desktop file in
/etc/xdg/autostart if it exists.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PulseAudio/Examples&oldid=254707"

Category:

-   Audio/Video
