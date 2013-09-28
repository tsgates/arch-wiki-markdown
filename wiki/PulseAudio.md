PulseAudio
==========

PulseAudio is the default sound server that serves as a proxy to sound
applications using existing kernel sound components like ALSA or OSS.
Since ALSA is included in Arch Linux by default so the most common
deployment scenarios include PulseAudio with ALSA.

Summary

PulseAudio is a general purpose sound server. For a list of features,
see Wikipedia:PulseAudio#Features.

Related Articles

PulseAudio/Examples

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Running                                                            |
| -   3 Equalizer                                                          |
|     -   3.1 Load equalizer sink module                                   |
|     -   3.2 Install and run the gui frontend                             |
|     -   3.3 Load equalizer module on every boot                          |
|                                                                          |
| -   4 Backend Configuration                                              |
|     -   4.1 ALSA                                                         |
|     -   4.2 ALSA/dmix without grabbing hardware device                   |
|     -   4.3 OSS                                                          |
|         -   4.3.1 ossp                                                   |
|         -   4.3.2 padsp wrapper (part of PulseAudio)                     |
|                                                                          |
|     -   4.4 GStreamer                                                    |
|     -   4.5 OpenAL                                                       |
|     -   4.6 libao                                                        |
|     -   4.7 ESD                                                          |
|                                                                          |
| -   5 Desktop Environments                                               |
|     -   5.1 General X11                                                  |
|     -   5.2 GNOME                                                        |
|     -   5.3 KDE 3                                                        |
|     -   5.4 KDE Plasma Workspaces and Qt4                                |
|     -   5.5 Xfce                                                         |
|                                                                          |
| -   6 Applications                                                       |
|     -   6.1 Audacious                                                    |
|     -   6.2 Java/OpenJDK 6                                               |
|     -   6.3 Music Player Daemon (MPD)                                    |
|     -   6.4 MPlayer                                                      |
|     -   6.5 Skype (x86_64 only)                                          |
|                                                                          |
| -   7 Troubleshooting                                                    |
|     -   7.1 No sound after install                                       |
|         -   7.1.1 Muted audio device                                     |
|         -   7.1.2 Bad configuration files                                |
|         -   7.1.3 Flash Content                                          |
|         -   7.1.4 No cards                                               |
|         -   7.1.5 The only device shown is "dummy output"                |
|         -   7.1.6 KDE4                                                   |
|         -   7.1.7 Failed to create sink input: sink is suspended         |
|                                                                          |
|     -   7.2 Bluetooth headset replay problems                            |
|     -   7.3 Automatically switch to Bluetooth or USB headset             |
|     -   7.4 Pulse overwrites ALSA settings                               |
|     -   7.5 Prevent Pulse from restarting after being killed             |
|     -   7.6 Daemon startup failed                                        |
|     -   7.7 padevchooser                                                 |
|     -   7.8 Glitches, skips or crackling                                 |
|     -   7.9 Setting the default fragment number and buffer size in       |
|         Pulseaudio                                                       |
|         -   7.9.1 Finding out your audio device parameters (1/4)         |
|         -   7.9.2 Calculate your fragment size in msecs and number of    |
|             fragments (2/4)                                              |
|         -   7.9.3 Restart pulseaudio to apply the new settings (4/5)     |
|         -   7.9.4 Finally check by recording and playing it back (5/5)   |
|                                                                          |
|     -   7.10 My Bluetooth device is paired but does not play any sound   |
|     -   7.11 Subwoofer stops working after end of every song             |
|     -   7.12 Pulseaudio uses wrong microphone                            |
|     -   7.13 Choppy Sound with Analog Surround Sound Setup               |
|     -   7.14 No sound below a volume cutoff                              |
|     -   7.15 Low volume for internal mic                                 |
|                                                                          |
| -   8 External links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

-   Required PKG: pulseaudio
-   Optional GTK GUIs: paprefs and pavucontrol
-   Optional volume control via mapped keyboard keys: pulseaudio_ctl
-   Optional console mixer: ponymix-git and pamixer-git
-   Optional system tray icon: pasystray-git
-   Optional KDE plasma applet: kdemultimedia-kmix and
    kdeplasma-applets-veromix

Running
-------

Note:Pulseaudio requires D-Bus to function.

Note:Most X11 environments start pulseaudio automatically with the X11
session.

In the unlikely event that pulseaudio is not automatically called upon
entering X, it can can be started with:

    $ pulseaudio --start

PulseAudio can be stopped with:

    $ pulseaudio -k

Equalizer
---------

Newer pulseaudio versions have an intergrated 10-band equalizer system.
In order to use the equalizer do the following:

> Load equalizer sink module

    $ pactl load-module module-equalizer-sink

> Install and run the gui frontend

    # pacman -S --needed python2-pyqt

    $ qpaeq

Note:If qpaeq has no effect, install pavucontrol and change "ALSA
Playback on" to "FFT based equalizer on ..." while the media player is
running.

> Load equalizer module on every boot

Edit the file /etc/pulse/default.pa with your favorite editor and append
the following lines:

    ### Load the integrated pulseaudio equalizer module
    load-module module-equalizer-sink

Backend Configuration
---------------------

> ALSA

-   Recommended PKG: pulseaudio-alsa
-   Optional PKGs: lib32-libpulse and lib32-alsa-plugins

Note:Optional PKGs are needed only if running x86_64 and wanting to have
sound for 32 bit programs (like Wine).

For the applications that do not support PulseAudio and support ALSA it
is recommended to install the PulseAudio plugin for ALSA. This package
also contains the necessary /etc/asound.conf for configuring ALSA to use
PulseAudio.

To prevent applications from using ALSA's OSS emulation and bypassing
Pulseaudio (thereby preventing other applications from playing sound),
make sure the module snd_pcm_oss is not being loaded at boot. If it is
currently loaded (lsmod|grep oss), disable it by executing:

    # rmmod snd_pcm_oss

> ALSA/dmix without grabbing hardware device

Note:This section describes alternative configuration, which is
generally NOT recommended.

You may want to use ALSA directly in most of your applications and to be
able to use other applications, which constantly require PulseAudio at
the same time. The following steps allow you to make PulseAudio use dmix
instead of grabbing ALSA hardware device.

-   Remove package pulseaudio-alsa, which provides compatibility layer
    between ALSA applications and PulseAudio. After this your ALSA apps
    will use ALSA directly without being hooked by Pulse.

    $ sudo pacman -R pulseaudio-alsa

-   Edit /etc/pulse/default.pa.

Find and uncomment lines which load backend drivers. Add device
parameters as follows. Then find and comment lines which load autodetect
modules.

    load-module module-alsa-sink device=dmix
    load-module module-alsa-source device=dsnoop
    # load-module module-udev-detect
    # load-module module-detect

-   Optional: If you use kdemultimedia-kmix you may want to control ALSA
    volume instead of PulseAudio volume:

    $ echo export KMIX_PULSEAUDIO_DISABLE=1 > ~/.kde4/env/kmix_disable_pulse.sh
    $ chmod +x ~/.kde4/env/kmix_disable_pulse.sh

-   Now, reboot your computer and try running alsa and pulseaudio
    applications at the same time. They both should produce sound
    simultaneously.

Use pavucontrol to control PulseAudio volume if needed.

> OSS

There are multiple ways of making OSS-only programs play to PulseAudio:

ossp

Start ossp with:

    # systemctl start osspd

padsp wrapper (part of PulseAudio)

Programs using OSS can work with PulseAudio by starting it with padsp:

    $ padsp OSSprogram

A few examples:

    $ padsp aumix
    $ padsp sox foo.wav -t ossdsp /dev/dsp

You can also add a custom wrapper script like this:

    /usr/local/bin/OSSProgram

    #!/bin/sh
    exec padsp /usr/bin/OSSprogram "$@"

Make sure /usr/local/bin comes before /usr/bin in your PATH.

> GStreamer

To make GStreamer use PulseAudio, you need to install gst-plugins-good
or gstreamer0.10-good-plugins.

> OpenAL

OpenAL Soft should use PulseAudio by default, but can be explicitly
configured to do so:

    /etc/openal/alsoft.conf

    drivers=pulse,alsa

> libao

Edit the libao configuration file:

    /etc/libao.conf

    default_driver=pulse

Be sure to remove the dev=default option of the alsa driver or adjust it
to specify a specific Pulse sink name or number. Alternatively, note
that you could keep the libao standard of outputting to the alsa driver
and its default device if you install pulseaudio-alsa since the ALSA
default device then is PulseAudio.

> ESD

PulseAudio is a drop-in replacement for the enlightened sound daemon
(ESD). While PulseAudio is running, ESD clients should be able to output
to it without configuration.

Desktop Environments
--------------------

> General X11

Note:As mentioned previously, PulseAudio is very likely launched
automatically via either /etc/X11/xinit/xinitrc.d/pulseaudio or the
files in /etc/xdg/autostart/ if users have some DE installed.

Check to see if PulseAudio is running:

    $ ps aux | grep pulse
    facade   1794  0.0  0.0 360464  6532 ?        S<l  15:33   0:00 /usr/bin/pulseaudio --start
    facade   1827  0.0  0.0  68888  2608 ?        S    15:33   0:00 /usr/lib/pulse/gconf-helper

If Pulseaudio is not running and users are using X, the following will
start PulseAudio with the needed the X11 plugins manually:

    $ start-pulseaudio-x11

If you are not running Gnome, KDE or XFCE and your ~/.xinitrc does not
source the scripts in /etc/X11/xinit/xinitrc.d (such as is done in the
example file /etc/skel/.xinitrc) then you can launch PulseAudio on boot
with:

    ~/.xinitrc

    /usr/bin/start-pulseaudio-x11

> GNOME

As of GNOME 3, GNOME fully integrates with PulseAudio and no extra
configuration is needed.

> KDE 3

PulseAudio is not a drop-in replacement for aRts. Users of KDE 3 cannot
use PulseAudio. However note, recent versions of PulseAudio may have
eliminated the prohibition:

See: http://www.pulseaudio.org/wiki/PerfectSetup KDE 3 uses the artsd
sound server by default. However, artsd itself can be configured to use
an Esound backend. Edit kcmartsrc (either in /etc/kde or
/usr/share/config for global configuration or .kde/share/config to
configure only one user) like this:

    [Arts]
    Arguments=\s-F 10 -S 4096 -a esd -n -s 1 -m artsmessage -c drkonqi -l 3 -f
    NetworkTransparent=true
    SuspendTime=1

> KDE Plasma Workspaces and Qt4

PulseAudio, it will be used by KDE/Qt4 applications. For more
information see the KDE page in the PulseAudio wiki.

PulseAudio support has been merged into KMix, the default KDE sound
mixer.

If the phonon-gstreamer backend is used for Phonon, GStreamer should
also be configured to use PulseAudio by installing
gstreamer0.10-good-plugins.

One useful tidbit from that page is to add
load-module module-device-manager to /etc/pulse/default.pa.

Additionally, the kdeplasma-applets-veromix is available in the AUR as a
KDE alternative to KMix or pavucontrol.

> Xfce

Applications running under Xfce can take advantage of PulseAudio. To
manage PulseAudio settings you can use pavucontrol.

Applications
------------

> Audacious

Audacious natively supports PulseAudio. In order to use it, set
Audacious Preferences -> Audio -> Current output plugin to 'PulseAudio
Output Plugin'.

> Java/OpenJDK 6

Create a wrapper for the java executable using padsp as seen on the Java
sound with Pulseaudio page.

> Music Player Daemon (MPD)

configure MPD to use PulseAudio. See also
MPD/Tips_and_Tricks#MPD_.26_PulseAudio.

> MPlayer

MPlayer natively supports PulseAudio output with the "-ao pulse" option.
It can also be configured to default to PulseAudio output, in
~/.mplayer/config for per-user, or /etc/mplayer/mplayer.conf for
system-wide:

    /etc/mplayer/mplayer.conf

    ao=pulse

> Skype (x86_64 only)

Install lib32-libpulse, otherwise the following error will occur when
trying to initiate a call: "Problem with Audio Playback".

Troubleshooting
---------------

> No sound after install

Muted audio device

If one experiences no audio output via any means while using ALSA,
attempt to unmute the sound card. To do this, launch alsamixer and make
sure each column has a green 00 under it (this can be toggled by
pressing m):

    $ alsamixer -c 0

Bad configuration files

If after starting pulseaudio, the system outputs no sound, it may be
necessary to delete the contents of ~/.pulse. Pulseaudio will
automatically create new configuration files on its next start.

Flash Content

Since Adobe Flash does not directly support PulseAudio the recommended
way is to configure ALSA to use the virtual PulseAudio soundcard.

Alternatively you may try out libflashsupport-pulse from the AUR.

Note:This may invariably crash the flash plugin.

No cards

If PulseAudio starts, run pacmd list. If no cards are reported, make
sure that the ALSA devices are not in use:

    $ fuser -v /dev/snd/*
    $ fuser -v /dev/dsp

Make sure any applications using the pcm or dsp files are shut down
before restarting PulseAudio.

The only device shown is "dummy output"

This may be caused by different reasons, one of them being the .asoundrc
file in $HOME is taking precedence over the systemwide /etc/asound.conf.

The user file is modified also by the tool asoundconf or by its
graphical variant asoundconf-gtk (the latter is named "Default sound
card" in the menu) as soon as it runs. Prevent the effects of .asoundrc
altogether by commenting the last line like this:

    .asoundrc

    # </home/<yourusername>/.asoundrc.asoundconf>

Maybe some program is monopolizing the audio device:

    # fuser -v /dev/snd/*

                         USER       PID  ACCESS COMMAND
    /dev/snd/controlC0:  root        931 F....  timidity
                         bob        1195 F....  panel-6-mixer
    /dev/snd/controlC1:  bob        1195 F....  panel-6-mixer
                         bob        1215 F....  pulseaudio
    /dev/snd/pcmC0D0p:   root        931 F...m  timidity
    /dev/snd/seq:        root        931 F....  timidity
    /dev/snd/timer:      root        931 f....  timidity

That means timidity blocks pulseaudio from accessing the audio devices.
Just killing timidity will make the sound work again.

Another reason is FluidSynth conclicting with pulseaudio as discussed in
this thread. The solution is to remove FluidSynth:

    # pacman -Rnsc fluidsynth

KDE4

It may be that another output device set as preferred in phonon. Make
sure that every setting reflects the preferred output device at the top,
and check the playback streams tab in kmix to make sure that
applications are using the device for output.

Failed to create sink input: sink is suspended

If you do not have any output sound and receive dozens of errors related
to a suspended sink in your journalctl -b log, then backup first and
then delete your user-specific pulse folders:

    $ rm -r ~/.pulse ~/.pulse-cookie

> Bluetooth headset replay problems

Some user report huge delays or even no sound when the bluetooth
connection does not send any data. This is due to an idle-suspend-module
that puts the related sinks/sources automatically into suspend. As this
can cause problems with headset, the responsible module can be
deactivated.

    $ cp /etc/pulse/default.pa ~/.pulse/default.pa

    ~/.pulse/default.pa

    ; load-module module-suspend-on-idle

    $ pulseaudio -k && pulseaudio --start

More information

> Automatically switch to Bluetooth or USB headset

Add the following:

    /etc/pulse/default.pa

    # automatically switch to newly-connected devices
    load-module module-switch-on-connect

> Pulse overwrites ALSA settings

Pulseaudio usually overwrites the ALSA settings- for example set with
alsamixer- at start up, even when the alsa daemon is loaded. Since there
seems to be no other way to restrict this behaviour, a workaround is to
restore the alsa settings again after pulseaudio had started. Add the
following command to .xinitrc or .bash_profile or any other autostart
file:

    restore_alsa() {
     while [ -z "`pidof pulseaudio`" ]; do
      sleep 0.5
     done
     alsactl -f /var/lib/alsa/asound.state restore 
    }
    restore_alsa &

> Prevent Pulse from restarting after being killed

Sometimes you may wish to temporarily disable Pulse. In order to do so
you will have to prevent Pulse from restarting after being killed.

    $ echo autospawn=no > ~/.pulse/client.conf

> Daemon startup failed

Try resetting PulseAudio:

    $ rm -rf /tmp/pulse* ~/.pulse*
    $ pulseaudio -k
    $ pulseaudio --start

If there is no server running but pulseaudio fails to start with an
error message "User-configured server at ... refusing to
start/autospawn", the issue may be with PulseAudio settings from a
previous login. Check to see if there are any stale properties attached
to the X11 root window with pax11publish -d, and if there are, remove
them with pax11publish -r before trying to start the server. This manual
cleanup is always required when using LXDM because it does not restart
the X server on logout; see LXDM#PulseAudio.

> padevchooser

If one cannot launch the PulseAudio Device Chooser, first (re)start the
Avahi daemon as follows:

    # systemctl restart avahi-daemon

> Glitches, skips or crackling

The newer implementation of PulseAudio sound server uses a timer-based
audio scheduling instead of the traditional interrupt-driven approach.

Timer-based scheduling may expose issues in some ALSA drivers. On the
other hand, other drivers might be glitchy without it on, so check to
see what works on your system.

To turn timer-based scheduling off add tsched=0 in
/etc/pulse/default.pa:

    /etc/pulse/default.pa

    load-module module-udev-detect tsched=0

Then restart the PulseAudio server:

    $ pulseaudio -k
    $ pulseaudio --start

Do the reverse to enable timer-based scheduling, if not already enabled
by default.

Please report any such cards to PulseAudio Broken Sound Driver page

> Setting the default fragment number and buffer size in Pulseaudio

More Information

Finding out your audio device parameters (1/4)

To find your sound card buffering settings:

    $ echo autospawn = no >> ~/.pulse/client.conf
    $ pulseaudio -k
    $ LANG=C timeout --foreground -k 10 -s kill 10 pulseaudio -vvvv 2>&1 | grep device.buffering -B 10
    $ sed -i '$d' ~/.pulse/client.conf

For each sound card detected by Pulseaudio, you will see output similar
to this:

    I: [pulseaudio] source.c:     alsa.long_card_name = "HDA Intel at 0xfa200000 irq 46"
    I: [pulseaudio] source.c:     alsa.driver_name = "snd_hda_intel"
    I: [pulseaudio] source.c:     device.bus_path = "pci-0000:00:1b.0"
    I: [pulseaudio] source.c:     sysfs.path = "/devices/pci0000:00/0000:00:1b.0/sound/card0"
    I: [pulseaudio] source.c:     device.bus = "pci"
    I: [pulseaudio] source.c:     device.vendor.id = "8086"
    I: [pulseaudio] source.c:     device.vendor.name = "Intel Corporation"
    I: [pulseaudio] source.c:     device.product.name = "82801I (ICH9 Family) HD Audio Controller"
    I: [pulseaudio] source.c:     device.form_factor = "internal"
    I: [pulseaudio] source.c:     device.string = "front:0"
    I: [pulseaudio] source.c:     device.buffering.buffer_size = "768000"
    I: [pulseaudio] source.c:     device.buffering.fragment_size = "384000"

Take note the buffer_size and fragment_size values for the relevant
sound card.

Calculate your fragment size in msecs and number of fragments (2/4)

Pulseaudio's default sampling rate and bit depth are set to 44100Hz @
16 bits.

With this configuration, the bit rate we need is 44100*16 = 44100 is
disabled and needs to be changed to 96000:

    # sed 's/; default-sample-rate = 44100/default-sample-rate = 96000/g' -i /etc/pulse/daemon.conf

Restart pulseaudio to apply the new settings (4/5)

    $ pulseaudio -k
    $ pulseaudio --start

Finally check by recording and playing it back (5/5)

Let us record some voice using mic for say 10 seconds. Make sure the mic
is not muted and all

    $ arecord -f cd -d 10 test-mic.wav

After 10 seconds, let us play the recording...

    $ aplay test-mic.wav

Now hopefully, there is no static noise in microphone recording anymore.

> My Bluetooth device is paired but does not play any sound

See the article in Bluetooth section

Starting from PulseAudio 2.99 and bluez 4.101 you should avoid using
Socket interface. Do NOT use:

    /etc/bluetooth/audio.conf

    [General]
    Enable=Socket

If you face problems with A2DP and PA 2.99 make sure you have sbc
library:

    # pacman -S sbc 

> Subwoofer stops working after end of every song

Known issue:
https://bugs.launchpad.net/ubuntu/+source/pulseaudio/+bug/494099

To fix this, must edit: /etc/pulse/daemon.conf and enable
enable-lfe-remixing :

    /etc/pulse/daemon.conf

    enable-lfe-remixing = yes

> Pulseaudio uses wrong microphone

If Pulseaudio uses the wrong microphone, and changing the Input Device
with Pavucontrol did not help, take a look at alsamixer. It seems that
Pavucontrol does not always set the input source correctly.

    $ alsamixer

Press F6 and choose your sound card, e.g. HDA Intel. Now press F5 to
display all items. Try to find the item: Input Source. With the up/down
arrow keys you are able to change the input source.

Now try if the correct microphone is used for recording.

> Choppy Sound with Analog Surround Sound Setup

The low-frequency effects (LFE) channel is not remixed per default. To
enable it the following needs to be set in /etc/pulse/daemon.conf :

    /etc/pulse/daemon.conf

    enable-lfe-remixing = yes

> No sound below a volume cutoff

Known issue (won't fix):
https://bugs.launchpad.net/ubuntu/+source/pulseaudio/+bug/223133

If sound doesn't play when Pulseaudio's volume is set below a certain
level, try ignore_dB=1 in /etc/pulse/default.pa:

    /etc/pulse/default.pa

    load-module module-udev-detect ignore_dB=1

However, be aware that it may cause another bug preventing pulseaudio to
unmute speakers when headphones or other audio devices are unplugged

> Low volume for internal mic

If you experience low volume on internal notebook microphone, try
setting:

    /etc/pulse/default.pa

    set-source-volume 1 300000

External links
--------------

-   http://www.pulseaudio.org/wiki/PerfectSetup - A good guide to make
    your configuration perfect
-   http://www.alsa-project.org/main/index.php/Asoundrc - Alsa wiki on
    .asoundrc
-   http://www.pulseaudio.org/ - PulseAudio official site
-   http://www.pulseaudio.org/wiki/FAQ - PulseAudio FAQ

Retrieved from
"https://wiki.archlinux.org/index.php?title=PulseAudio&oldid=255174"

Categories:

-   Audio/Video
-   Sound
