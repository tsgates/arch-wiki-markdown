PulseAudio/Examples
===================

Contents
--------

-   1 Defaulting to an analog output source
-   2 Simultaneous HDMI and analog output
-   3 HDMI output configuration
    -   3.1 Finding HDMI output
    -   3.2 Testing for the correct card
    -   3.3 Manually configuring PulseAudio to detect the Nvidia HDMI
-   4 Surround sound systems
    -   4.1 Splitting front/rear
    -   4.2 LFE remixing
-   5 PulseAudio over network
    -   5.1 TCP support (networked sound)
    -   5.2 TCP support with anonymous clients
    -   5.3 Zeroconf (Avahi) publishing
    -   5.4 Switching the PulseAudio server used by local X clients
    -   5.5 When everything else seems to fail
-   6 ALSA monitor source
-   7 PulseAudio through JACK
    -   7.1 The new new way
    -   7.2 The new way
    -   7.3 The old way
        -   7.3.1 QjackCtl with start-up/shutdown scripts
-   8 PulseAudio through OSS
-   9 PulseAudio from within a chroot (e.g. 32-bit chroot in 64-bit
    install)
-   10 Disabling automatic spawning of PulseAudio server
-   11 Remap stereo to mono

Defaulting to an analog output source
-------------------------------------

Note: To list devices, aplay is used. This program is part of the
alsa-utils package and is NOT required to output to multiple sources. It
is required to list playback devices therefore users can remove this
package when finished with it.

To select an alternative source as the default output (for example,
analog), first list all sources:

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

On this machine, the analog source is card 0, device 0. Edit
/etc/pulse/default.pa and append the following to add the analog source:

    load-module module-alsa-sink device=hw:0,0

Determine the correct index of the new source:

    $ pacmd list-sinks | less

Note the index number that corresponds to the 'alsa_output.hw_0_0' sink.

Finally, add a 2nd line to /etc/pulse/default.pa defining the analog
output to be used by default:

    set-default-sink 2

Either logout/login or restart PulseAudio manually for these changes to
take effect.

Simultaneous HDMI and analog output
-----------------------------------

PulseAudio allows for simultaneous output to multiple sources. In this
example, some applications are configured to use HDMI while others are
configured to use analog. Multiple applications are able to receive
audio at the same time.

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

Now start a program that will use PulseAudio such as MPlayer, VLC, mpd,
etc. and switch to the "Playback" tab. A drop-down list should be
available for the running program to select one of the three sources.

Also see this thread for a variation on this theme and PulseAudio FAQ.

HDMI output configuration
-------------------------

As outlined in
ftp://download.nvidia.com/XFree86/gpu-hdmi-audio-document/gpu-hdmi-audio.html#_issues_in_pulseaudio
unless the HDMI port is the first output, PulseAudio will not be able to
have any audio when using certain graphics cards with HDMI audio
support. This is because of a bug in PulseAudio where it will only
select the first HDMI output on a device. A work around posted further
down is to first find which HDMI output is working by using the aplay
utility from ALSA.

The original title for this section indicated the problem is specific to
nVidia cards. As seen in this forum thread other cards are affected as
well. The rest of the section will use an nVidia card as a case-study
but the solution should carry over for people using other affected
cards.

> Finding HDMI output

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

> Testing for the correct card

Now a list of the detected cards is known, users will need to test for
which one is outputting to the TV/monitor

    # aplay -D plughw:1,3 /usr/share/sounds/alsa/Front_Right.wav

where 1 is the card and 3 is the device substitute in the values listed
from the previous section. If there is no audio, then try substituting a
different device (on my card I had to use card 1 device 7)

> Manually configuring PulseAudio to detect the Nvidia HDMI

Having identified which HDMI device is working, PulseAudio can be forced
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

Then, open the output tab. There should now be two HDMI outputs for the
graphics card. Test which one works by selecting one of them, and then
using a program to play audio. For example, use VLC to play a movie, and
if it does not work, then select the other.

Surround sound systems
----------------------

Many people have a surround sound card, but have speakers for just two
channels, so PulseAudio cannot really default to a surround sound setup.
To enable all of the channels, edit /etc/pulse/daemon.conf: uncomment
the default-sample-channels line (i.e. remove the semicolon from the
beginning of the line) and set the value to 6. For a 5.1 setup, or 8 for
a 7.1 setup etc.

    # Default
    default-sample-channels=2
    # For 5.1
    default-sample-channels=6
    # For 7.1
    default-sample-channels=8

After doing the edit, restart PulseAudio.

> Splitting front/rear

Connect speakers to front analog output and headphones to rear output.
It would be useful to split front/rear to separate sinks. Add to
/etc/pulse/default.pa:

     load-module module-remap-sink sink_name=speakers remix=no master=alsa_output.pci-0000_05_00.0.analog-surround-40 channels=2 master_channel_map=front-left,front-right channel_map=front-left,front-right
     load-module module-remap-sink sink_name=headphones remix=no master=alsa_output.pci-0000_05_00.0.analog-surround-40 channels=2 master_channel_map=rear-left,rear-right   channel_map=front-left,front-right

(replace alsa_output.pci-0000_05_00.0.analog-surround-40 in the sound
card name shown from 'pacmd list-sinks')

Switch player between speakers and headphones.

> LFE remixing

By default, PulseAudio remixes the number of channels to the
default-sample-channels; however, it dose not do this for the LFE
channel. To enable LFE remixing, uncomment the line:

    ; enable-lfe-remixing = no

and replace no with yes:

    enable-lfe-remixing = yes

then restart Pulseaudio.

PulseAudio over network
-----------------------

One of PulseAudio's unique features is its ability to stream audio from
clients over TCP to a server running the PulseAudio daemon reliably
within a LAN.

To accomplish this, one needs to enable module-native-protocol-tcp.

> TCP support (networked sound)

To enable the TCP module, add this to (or uncomment, if already there)
/etc/pulse/default.pa on both the client and server:

    load-module module-native-protocol-tcp

For this to work, it is a requirement that both the client and server
share the same cookie. Ensure that the clients and server share the same
cookie file found under ~/.config/pulse/cookie. It does not matter whose
cookie file you use (the server or a client's), just that the server and
client(s) share the same one.

Note: If experiencing trouble connecting, use (on server)

    pacmd list-modules

> TCP support with anonymous clients

If it is undesirable to copy the cookie file from clients, anonymous
clients can access the server by giving these parameters to
module-native-protocol-tcp on the server (again in
/etc/pulse/default.pa):

     load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1;192.168.0.0/24 auth-anonymous=1

Change the LAN IP subnet to match that of the those clients you wish to
have access to the server.

> Zeroconf (Avahi) publishing

For the remote PulseAudio server to appear in the PulseAudio Device
Chooser (pasystray), load the appropriate zeroconf modules, and enable
the Avahi daemon.

On both machines, run:

    $ systemctl start avahi-daemon
    $ systemctl enable avahi-daemon

On the server, add load-module module-zeroconf-publish to
/etc/pulse/default.pa, on the client, add
load-module module-zeroconf-discover to /etc/pulse/default.pa. Now
redirect any stream or complete audio output to the remote PulseAudio
server by selecting the appropriate sink.

If you have issues with the remote syncs appearing on the client, try
restarting the Avahi daemon on the server to rebroadcast the available
interfaces.

> Switching the PulseAudio server used by local X clients

To switch between servers on the client from within X, the pax11publish
command can be used. For example, to switch from the default server to
the server at hostname foo:

    $ pax11publish -e -S foo

Or to switch back to the default:

    $ pax11publish -e -r

Note that for the switch to become apparent, the programs using Pulse
must be restarted.

> When everything else seems to fail

The following is a quick fix and NOT a permanent solution

On the server:

     $ paprefs 

Go to Network Access -> Enable access to local sound devices (Also check
both 'Allow discover' and 'Don't require authentication').

On the client:

     $ export PULSE_SERVER=server.ip && mplayer test.mp3

ALSA monitor source
-------------------

To be able to record from a monitor source (a.k.a. "What-U-Hear",
"Stereo Mix"), use pactl list to find out the name of the source in
PulseAudio (e.g. alsa_output.pci-0000_00_1b.0.analog-stereo.monitor).
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

Alternatively, you can use pavucontrol to do this: make sure you have
set up the display to "All input devices", then select "Monitor of [your
sound card]" as the recording source.

PulseAudio through JACK
-----------------------

> The new new way

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

If it still does not work, check with pavucontrol in the playback tab
and make sure the relevant programs are outputting to PulseAudio JACK
Sink instead of your audio card (which JACK has control of, so it will
not work).

> The new way

The basic idea is that killing PulseAudio is a bad idea because it may
crash any apps using PulseAudio and disrupt any audio playing.

The flow of how this setup works:

1.  PulseAudio releases the sound card
2.  JACK grabs sound card and starts up
3.  script redirects PulseAudio to JACK
4.  manually send PulseAudio apps to JACK output (pavucontrol may come
    in helpful for this)
5.  use JACK programs etc
6.  via script, stop redirecting PulseAudio to JACK
7.  stop JACK and release sound card
8.  PulseAudio grabs sound card and reroutes audio to it directly

With QJackCTL, set up these scripts:

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

> The old way

The JACK-Audio-Connection-Kit is popular for audio work, and is widely
supported by Linux audio applications. It fills a similar niche as
PulseAudio, but with more of an emphasis on professional audio work. In
particular, audio applications such as Ardour and Audacity (recently)
work well with Jack.

PulseAudio provides module-jack-source and module-jack-sink which allow
PulseAudio to be run as a sound server above the JACK daemon. This
allows the usage of per-volume adjustments and the like for the apps
which need it, play-back apps for movies and audio, while allowing
low-latency and inter-app connectivity for sound-processing apps which
connect to JACK. However, this will prevent PulseAudio from directly
writing to the sound card buffers, which will increase overall CPU
usage.

To just try PA on top of JACK, have PA load the necessary modules on
start:

    pulseaudio -L module-jack-sink -L module-jack-source

To use PulseAudio with JACK, JACK must be started before PulseAudio,
using whichever method one prefers. PulseAudio then needs to be started
loading the two relevant modules. Edit /etc/pulse/default.pa, and change
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
module-udev-detect will always try to grab the sound card (JACK has
already done that, so this will cause an error). Also, the JACK source
and sink must be explicitly loaded.

QjackCtl with start-up/shutdown scripts

Using the settings listed above, use QjackCtl to execute a script upon
startup and shutdown to load/unload PulseAudio. Part of the reason users
may wish to do this is that the above changes disable PulseAudio's
automatic hardware detection modules. This particular setup is for using
PulseAudio in an exclusive fashion with JACK, though the scripts could
be modified to unload and load an alternate non-JACK setup, but killing
and starting PulseAudio while programs might be using it would become
problematic.

Note:padevchooser in the following example is deprecated. It is replaced
by pasystray

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

PulseAudio through OSS
----------------------

Add the following to /etc/pulse/default.pa:

    load-module module-oss

Then start PulseAudio as usual, making sure that sinks and sources are
defined for OSS devices.

PulseAudio from within a chroot (e.g. 32-bit chroot in 64-bit install)
----------------------------------------------------------------------

Since a chroot sets up an alternative root for the running/jailing of
applications, PulseAudio must be installed within the chroot itself
(pacman -S pulseaudio within the chroot environment).

PulseAudio, if not set up to connect to any specific server (this can be
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

PulseAudio selects the path to the socket via XDG_RUNTIME_DIR, so be
sure to drag it along when you chroot as a normal user using sudo (see
Sudo#Environment_variables).

For specific direction on accomplishing the appropriate mounts, please
refer to the wiki on installing a bundled 32-bit system, especially the
additional section specific to PulseAudio.

Disabling automatic spawning of PulseAudio server
-------------------------------------------------

Some users may prefer to manually start the PulseAudio server before
running certain programs and then stop the PulseAudio server when they
are finished. A simple way to accomplish this is to edit
/etc/pulse/client.conf and change autospawn = yes to autospawn = no, and
set daemon-binary = /bin/true. Make sure the two lines are uncommented
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

Remap stereo to mono
--------------------

Remap a stereo input-sink to a mono sink by creating a virtual sink. It
would be useful if you only have one speaker. Add to
/etc/pulse/default.pa:

    load-module module-remap-sink master=alsa_output.pci-0000_00_1f.5.analog-stereo sink_name=mono channels=2 channel_map=mono,mono
    # Optiona: Select new remap as default
    set-default-sink mono

(replace alsa_output.pci-0000_00_1f.5.analog-stereo in the sound card
name shown from pacmd list-sinks)

Switch player between virtual mono sink and real stereo sink.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PulseAudio/Examples&oldid=303471"

Category:

-   Audio/Video

-   This page was last modified on 7 March 2014, at 11:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
