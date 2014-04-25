PulseAudio
==========

Related articles

-   PulseAudio/Examples

PulseAudio is a sound server commonly used by desktop environments like
GNOME or KDE. It serves as a proxy to sound applications using existing
kernel sound components like ALSA or OSS. Since ALSA is included in Arch
Linux by default, the most common deployment scenarios include
PulseAudio with ALSA.

Contents
--------

-   1 Installation
-   2 Running
-   3 Equalizer
    -   3.1 Load equalizer sink and dbus-protocol module
    -   3.2 Install and run the GUI front-end
    -   3.3 Load equalizer and dbus module on every boot
-   4 Back-end configuration
    -   4.1 ALSA
    -   4.2 ALSA/dmix without grabbing hardware device
    -   4.3 OSS
        -   4.3.1 ossp
        -   4.3.2 padsp wrapper (part of PulseAudio)
    -   4.4 GStreamer
    -   4.5 OpenAL
    -   4.6 libao
    -   4.7 ESD
-   5 Desktop environments
    -   5.1 General X11
    -   5.2 GNOME
    -   5.3 KDE 3
    -   5.4 KDE Plasma Workspaces and Qt4
    -   5.5 Xfce
-   6 Applications
    -   6.1 Audacious
    -   6.2 Java/OpenJDK 6
    -   6.3 Music Player Daemon (MPD)
    -   6.4 MPlayer
    -   6.5 Skype (x86_64 only)
-   7 Troubleshooting
    -   7.1 No sound after install
        -   7.1.1 Muted audio device
        -   7.1.2 Auto-Mute Mode
        -   7.1.3 Bad configuration files
        -   7.1.4 Flash content
        -   7.1.5 No cards
        -   7.1.6 The only device shown is "dummy output"
        -   7.1.7 No HDMI 5/7.1 Selection for Device
        -   7.1.8 KDE Plasma Workspaces
        -   7.1.9 Failed to create sink input: sink is suspended
    -   7.2 No HDMI sound output after some time with the monitor turned
        off
    -   7.3 Can't update configuration of sound device in pavucontrol
    -   7.4 Simultaneous output to multiple sound cards / devices
    -   7.5 Simultaneous output to multiple sinks on the same sound card
        not working
    -   7.6 Disable Bluetooth support
    -   7.7 Bluetooth headset replay problems
    -   7.8 Automatically switch to Bluetooth or USB headset
    -   7.9 Pulse overwrites ALSA settings
    -   7.10 Prevent Pulse from restarting after being killed
    -   7.11 Daemon startup failed
        -   7.11.1 inotify issue
    -   7.12 Glitches, skips or crackling
    -   7.13 Setting the default fragment number and buffer size in
        PulseAudio
        -   7.13.1 Finding out your audio device parameters (1/4)
        -   7.13.2 Calculate your fragment size in msecs and number of
            fragments (2/4)
        -   7.13.3 Modify PulseAudio's configuration file (3/4)
        -   7.13.4 Restart the PulseAudio daemon (4/4)
    -   7.14 Laggy sound
    -   7.15 Choppy, overdriven sound
    -   7.16 Volume adjustment does not work properly
    -   7.17 Per-application volumes change when the Master volume is
        adjusted
    -   7.18 Volume gets louder every time a new application is started
    -   7.19 No microphone on ThinkPad T400/T500/T420
    -   7.20 No microphone input on Acer Aspire One
    -   7.21 Sound output is only mono on M-Audio Audiophile 2496 sound
        card
    -   7.22 Static noise in microphone recording
        -   7.22.1 Determine sound cards in the system (1/5)
        -   7.22.2 Determine sampling rate of the sound card (2/5)
        -   7.22.3 Setting the sound card's sampling rate into
            PulseAudio configuration (3/5)
        -   7.22.4 Restart PulseAudio to apply the new settings (4/5)
        -   7.22.5 Finally check by recording and playing it back (5/5)
    -   7.23 My Bluetooth device is paired but does not play any sound
    -   7.24 Subwoofer stops working after end of every song
    -   7.25 PulseAudio uses wrong microphone
    -   7.26 Choppy sound with analog surround sound setup
    -   7.27 No sound below a volume cutoff
    -   7.28 Low volume for internal microphone
    -   7.29 Clients alter master output volume (a.k.a. volume jumps to
        100% after running application)
    -   7.30 Realtime scheduling
    -   7.31 No sound after resume from suspend
    -   7.32 ALSA channels mute when headphones are plugged/unplugged
        improperly
    -   7.33 pactl "invalid option" error with negative percentage
        arguments
    -   7.34 Daemon already running
-   8 See also

Installation
------------

-   Required package: pulseaudio
-   Optional GTK GUIs: paprefs and pavucontrol
-   Optional volume control via mapped keyboard keys: pulseaudio-ctl
-   Optional console (CLI) mixers: ponymix and pamixer-git
-   Optional web volume control: PaWebControl
-   Optional system tray icon: pasystray-git
-   Optional KDE plasma applet: kdemultimedia-kmix and
    kdeplasma-applets-veromix

Running
-------

Warning:If you have per-user copies of configuration files (such as
client.conf, daemon.conf or default.pa) in ~/.config/pulse/ or
~/.pulse/, make sure you keep them in sync with changes to the packaged
files in /etc/pulse/. Otherwise, PulseAudio may refuse to start due to
configuration errors.

> Note:

-   PulseAudio requires D-Bus to function.
-   Most X11 environments start PulseAudio automatically with the X11
    session.

In the unlikely event that PulseAudio is not automatically started upon
entering X, it can can be started with:

    $ pulseaudio --start

PulseAudio can be stopped with:

    $ pulseaudio -k

Equalizer
---------

Newer PulseAudio versions have an integrated 10-band equalizer system.
In order to use the equalizer do the following:

> Load equalizer sink and dbus-protocol module

    $ pactl load-module module-equalizer-sink
    $ pactl load-module module-dbus-protocol

> Install and run the GUI front-end

Install python-pyqt4 and execute:

    $ qpaeq

Note:If qpaeq has no effect, install pavucontrol and change "ALSA
Playback on" to "FFT based equalizer on ..." while the media player is
running.

> Load equalizer and dbus module on every boot

Edit the file /etc/pulse/default.pa with your favorite editor and append
the following lines:

    ### Load the integrated PulseAudio equalizer and D-Bus module
    load-module module-equalizer-sink
    load-module module-dbus-protocol

Back-end configuration
----------------------

> ALSA

-   Recommended package: pulseaudio-alsa
-   Optional packages: lib32-libpulse and lib32-alsa-plugins

Note:Optional packages are needed only if running x86_64 and wanting to
have sound for 32-bit programs (like Wine).

For the applications that do not support PulseAudio and support ALSA it
is recommended to install the PulseAudio plugin for ALSA. This package
also contains the necessary /etc/asound.conf for configuring ALSA to use
PulseAudio.

To prevent applications from using ALSA's OSS emulation and bypassing
PulseAudio (thereby preventing other applications from playing sound),
make sure the module snd_pcm_oss is not being loaded at boot. If it is
currently loaded ( grep oss), disable it by executing:

    # rmmod snd_pcm_oss

> ALSA/dmix without grabbing hardware device

Note:This section describes alternative configuration, which is
generally not recommended.

You may want to use ALSA directly in most of your applications and to be
able to use other applications, which constantly require PulseAudio at
the same time. The following steps allow you to make PulseAudio use dmix
instead of grabbing ALSA hardware device.

-   Remove package pulseaudio-alsa, which provides compatibility layer
    between ALSA applications and PulseAudio. After this your ALSA apps
    will use ALSA directly without being hooked by Pulse.

-   Edit /etc/pulse/default.pa.

Find and uncomment lines which load back-end drivers. Add device
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

-   Now, reboot your computer and try running ALSA and PulseAudio
    applications at the same time. They both should produce sound
    simultaneously.

Use pavucontrol to control PulseAudio volume if needed.

> OSS

There are multiple ways of making OSS-only programs play to PulseAudio:

ossp

Install ossp package and start osspd service.

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

    # /etc/libao.conf

    default_driver=pulse

Be sure to remove the dev=default option of the alsa driver or adjust it
to specify a specific Pulse sink name or number.

Note:You could possibly also keep the libao standard of outputting to
the alsa driver and its default device if you install pulseaudio-alsa
since the ALSA default device then is PulseAudio.

> ESD

PulseAudio is a drop-in replacement for the enlightened sound daemon
(ESD). While PulseAudio is running, ESD clients should be able to output
to it without configuration.

Desktop environments
--------------------

> General X11

Note:As mentioned previously, PulseAudio is very likely launched
automatically via either /etc/X11/xinit/xinitrc.d/pulseaudio or the
files in /etc/xdg/autostart/ if users have some DE installed.

Check to see if PulseAudio is running:

    $ ps aux | grep pulse

     facade   1794  0.0  0.0 360464  6532 ?        S<l  15:33   0:00 /usr/bin/pulseaudio --start
     facade   1827  0.0  0.0  68888  2608 ?        S    15:33   0:00 /usr/lib/pulse/gconf-helper

If PulseAudio is not running and users are using X, the following will
start PulseAudio with the needed the X11 plugins manually:

    $ start-pulseaudio-x11

If you are not running GNOME, KDE, or Xfce, and your ~/.xinitrc does not
source the scripts in /etc/X11/xinit/xinitrc.d (such as is done in the
example file /etc/skel/.xinitrc), then you can launch PulseAudio on boot
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

If KMix/Veromix fail to connect to PulseAudio at boot you may need to
edit /etc/pulse/client.conf to include autospawn = yes instead of
autospawn = no.

> Xfce

Applications running under Xfce can take advantage of PulseAudio. To
manage PulseAudio settings, you can use pavucontrol.

Applications
------------

> Audacious

Audacious natively supports PulseAudio. In order to use it, set
Audacious Preferences -> Audio -> Current output plugin to 'PulseAudio
Output Plugin'.

> Java/OpenJDK 6

Create a wrapper for the Java executable using padsp as seen on the Java
sound with PulseAudio page.

> Music Player Daemon (MPD)

configure MPD to use PulseAudio. See also MPD/Tips and Tricks#MPD and
PulseAudio.

> MPlayer

MPlayer natively supports PulseAudio output with the -ao pulse option.
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

Note:alsamixer will not tell you which output device is set as the
default. One possible cause of no sound after install is that PulseAudio
detects the wrong output device as a default. Install pavucontrol and
check if there is any output on the pavucontrol panel when playing a
.wav file.

Auto-Mute Mode

Auto-Mute Mode may be enabled. It can be disabled using alsamixer.

See http://superuser.com/questions/431079/how-to-disable-auto-mute-mode
for more.

Bad configuration files

After starting PulseAudio, if the system outputs no sound, it may be
necessary to delete the contents of ~/.pulse. PulseAudio will
automatically create new configuration files on its next start.

Flash content

Since Adobe Flash does not directly support PulseAudio, the recommended
way is to configure ALSA to use the virtual PulseAudio sound card.

Alternatively you may try out libflashsupport-pulse from the AUR.

Note:This may invariably crash the Flash plugin.

If you find audio from flash is being laggy, you might like to have
flash access ALSA directly. This fixes this problem in some cases. To do
this, configure PulseAudio to use dmix.

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

    # </home/yourusername/.asoundrc.asoundconf>

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

That means timidity blocks PulseAudio from accessing the audio devices.
Just killing timidity will make the sound work again.

Another reason is FluidSynth conflicting with PulseAudio as discussed in
this thread. The solution is to remove FluidSynth:

    # pacman -Rnsc fluidsynth

No HDMI 5/7.1 Selection for Device

If you are unable to select 5/7.1 channel output for a working HDMI
device, then turning off 'stream detection' in /etc/pulse/default.pa
might help.

    load-module module-stream-restore restore_device=false

KDE Plasma Workspaces

It may be that another output device set as preferred in phonon. Make
sure that every setting reflects the preferred output device at the top,
and check the playback streams tab in kmix to make sure that
applications are using the device for output.

To see your default audio device, you can run:

    pactl stat

To see available audio devices:

    pactl list

To set your default audio device, use "pacmd" or add to
/etc/pulse/default.pa:

    set-default-sink alsa_output.analog-stereo

Failed to create sink input: sink is suspended

If you do not have any output sound and receive dozens of errors related
to a suspended sink in your journalctl -b log, then backup first and
then delete your user-specific pulse folders:

    $ rm -r ~/.pulse ~/.pulse-cookie

> No HDMI sound output after some time with the monitor turned off

The monitor is connected via HDMI/DisplayPort, and the audio jack is
plugged in the headphone jack of the monitor, but PulseAudio insists
that it is unplugged:

    pactl list sinks

    ...
    hdmi-output-0: HDMI / DisplayPort (priority: 5900, not available)
    ...

This leads to no sound coming from HDMI output. A workaround for this is
to switch to another TTY and back again. This problem has been reported
by ATI/Nvidia/Intel users.

> Can't update configuration of sound device in pavucontrol

pavucontrol is a handy GUI utility for configuring PulseAudio. Under its
'Configuration' tab, you can select different profiles for each of your
sound devices e.g. analogue stereo, digital output (IEC958), HDMI 5.1
Surround etc.

However, you may run into an instance where selecting a different
profile for a card results in the pulse daemon crashing and auto
restarting without the new selection "sticking". If this occurs, use the
other useful GUI tool, paprefs, to check under the "Simultaneous Output"
tab for a virtual simultaneous device. If this setting is active
(checked), it will prevent you changing any card's profile in
pavucontrol. Uncheck this setting, then adjust your profile in
pavucontrol prior to re-enabling simultaneous output in paprefs.

> Simultaneous output to multiple sound cards / devices

Simultaneous output to two different devices can be very useful. For
example, being able to send audio to your A/V receiver via your graphics
card's HDMI output, while also sending the same audio through the
analogue output of your motherboard's built-in audio. This is much less
hassle than it used to be (in this example, we are using GNOME desktop).

Using paprefs, simply select "Add virtual output device for simultaneous
output on all local sound cards" from under the "Simultaneous Output"
tab. Then, under GNOME's "sound settings", select the simultaneous
output you have just created.

If this doesn't work, try adding the following to ~/.asoundrc:

    pcm.dsp {
       type plug
       slave.pcm "dmix"
    }

> Simultaneous output to multiple sinks on the same sound card not working

This can be useful for users who have multiple sound sources and want to
play them on different sinks/outputs. An example use-case for this would
be if you play music and also voice chat and want to output music to
speakers (in this case Digital S/PDIF) and voice to headphones. (Analog)

This is sometimes auto detected by PulseAudio but not always. If you
know that your sound card can output to both Analog and S/PDIF at the
same time and PulseAudio does not have this option in it's profiles in
pavucontrol, or veromix then you probably need to create a configuration
file for your sound card.

More in detail you need to create a profile-set for your specific sound
card. This is done in two steps mostly.

-   Create udev rule to make PulseAudio choose your PulseAudio
    configuration file specific to the sound card.
-   Create the actual configuration.

Create a pulseadio udev rule.

Note: This is only an example for Asus Xonar Essence STX. Read udev to
find out the correct values.

Note: Your configuration file should have lower number than the original
PulseAudio rule to take effect.

    /usr/lib/udev/rules.d/90-pulseaudio-Xonar-STX.rules

    ACTION=="change", SUBSYSTEM=="sound", KERNEL=="card*", \
    ATTRS{subsystem_vendor}=="0x1043", ATTRS{subsystem_device}=="0x835c", ENV{PULSE_PROFILE_SET}="asus-xonar-essence-stx.conf" 

Now, create a configuration file. If you bother, you can start from
scratch and make it saucy. However you can also use the default
configuration file, rename it, and then add your profile there that you
know works. Less pretty but also faster.

To enable multiple sinks for Asus Xonar Essence STX you need only to add
this in.

Note:asus-xonar-essence-stx.conf also includes all code/mappings from
default.conf.

    /usr/share/pulseaudio/alsa-mixer/profile-sets/asus-xonar-essence-stx.conf

    [Profile analog-stereo+iec958-stereo]
    description = Analog Stereo Duplex + Digital Stereo Output
    input-mappings = analog-stereo
    output-mappings = analog-stereo iec958-stereo
    skip-probe = yes

This will auto-profile your Asus Xonar Essence STX with default profiles
and add your own profile so you can have multiple sinks.

You need to create another profile in the configuration file if you want
to have the same functionality with AC3 Digital 5.1 output.

See PulseAudio article about profiles

> Disable Bluetooth support

If you do not use Bluetooth, you may experience the following error in
your journal:

    bluez5-util.c: GetManagedObjects() failed: org.freedesktop.DBus.Error.ServiceUnknown: The name org.bluez was not provided by any .service files

To disable Bluetooth support in PulseAudio, make sure that the following
lines are commented out in the configuration file in use
(~/.config/pulse/default.pa or /etc/pulse/default.pa):

    ~/.config/pulse/default.pa

    ### Automatically load driver modules for Bluetooth hardware
    #.ifexists module-bluetooth-policy.so
    #load-module module-bluetooth-policy
    #.endif

    #.ifexists module-bluetooth-discover.so
    #load-module module-bluetooth-discover
    #.endif

> Bluetooth headset replay problems

Some user reports huge delays or even no sound when the Bluetooth
connection does not send any data. This is due to the
module-suspend-on-idle module, which automatically suspends
sinks/sources on idle. As this can cause problems with headset, the
responsible module can be deactivated.

To disable loading of the module-suspend-on-idle module, comment out the
following line in the configuration file in use
(~/.config/pulse/default.pa or /etc/pulse/default.pa):

    ~/.config/pulse/default.pa

    ### Automatically suspend sinks/sources that become idle for too long
    #load-module module-suspend-on-idle

Finally restart PulseAudio to apply the changes.

> Automatically switch to Bluetooth or USB headset

Add the following:

    /etc/pulse/default.pa

    # automatically switch to newly-connected devices
    load-module module-switch-on-connect

> Pulse overwrites ALSA settings

PulseAudio usually overwrites the ALSA settings — for example set with
alsamixer — at start-up, even when the ALSA daemon is loaded. Since
there seems to be no other way to restrict this behaviour, a workaround
is to restore the ALSA settings again after PulseAudio has started. Add
the following command to .xinitrc or .bash_profile or any other
autostart file:

    restore_alsa() {
     while [ -z "$(pidof pulseaudio)" ]; do
      sleep 0.5
     done
     alsactl -f /var/lib/alsa/asound.state restore 
    }
    restore_alsa &

> Prevent Pulse from restarting after being killed

Sometimes you may wish to temporarily disable Pulse. In order to do so
you will have to prevent Pulse from restarting after being killed.

    ~/.config/pulse/client.conf

    # Disable autospawning the PulseAudio daemon
    autospawn = no

> Daemon startup failed

Try resetting PulseAudio:

    $ rm -rf /tmp/pulse* ~/.pulse*
    $ pulseaudio -k
    $ pulseaudio --start

If there is no server running but PulseAudio fails to start with an
error message "User-configured server at ... refusing to
start/autospawn", the issue may be with PulseAudio settings from a
previous login. Check to see if there are any stale properties attached
to the X11 root window with pax11publish -d, and if there are, remove
them with pax11publish -r before trying to start the server. This manual
cleanup is always required when using LXDM because it does not restart
the X server on logout; see LXDM#PulseAudio.

inotify issue

If the previous fix doesn't work, see if you get an error like this:

    $ pulseaudio -vvvv

    E: [pulseaudio] module-udev-detect.c: You apparently ran out of inotify watches, probably because Tracker/Beagle took them all away. I wished people would do their homework first and fix inotify before using it for watching whole directory trees which is something the current inotify is certainly not useful for. Please make sure to drop the Tracker/Beagle guys a line complaining about their broken use of inotify.

In which case you have run out of inotify watches.

This can quickly be resolved by:

    # echo 100000 > /proc/sys/fs/inotify/max_user_watches

To have it permanently changed, use:

    /etc/sysctl.d/99-sysctl.conf

    # Increase inotify max watchs per user
    fs.inotify.max_user_watches = 100000

> Glitches, skips or crackling

The newer implementation of the PulseAudio sound server uses timer-based
audio scheduling instead of the traditional, interrupt-driven approach.

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

> Setting the default fragment number and buffer size in PulseAudio

More Information

Finding out your audio device parameters (1/4)

To find your sound card buffering settings:

    $ echo autospawn = no >> ~/.pulse/client.conf
    $ pulseaudio -k
    $ LANG=C timeout --foreground -k 10 -s kill 10 pulseaudio -vvvv 2>&1 | grep device.buffering -B 10
    $ sed -i '$d' ~/.pulse/client.conf

For each sound card detected by PulseAudio, you will see output similar
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

PulseAudio's default sampling rate and bit depth are set to 44100Hz @
16 bits.

With this configuration, the bit rate we need is 44100*16 = 705600 bits
per second. That's 1411200 bps for stereo.

Let's take a look at the parameters we have found in the previous step:

    device.buffering.buffer_size = "768000" => 768000/1411200 = 0.544217687075s = 544 msecs
    device.buffering.fragment_size = "384000" => 384000/1411200 = 0.272108843537s = 272 msecs

Modify PulseAudio's configuration file (3/4)

    /etc/pulse/daemon.conf

    ; default-fragments = X
    ; default-fragment-size-msec = Y

In the previous step, we calculated the fragment size parameter. The
number of fragments is simply buffer_size/fragment_size, which in this
case (544/272) is 2:

    /etc/pulse/daemon.conf

    ; default-fragments = '''272'''
    ; default-fragment-size-msec = '''2'''

Restart the PulseAudio daemon (4/4)

    $ pulseaudio -k
    $ pulseaudio --start

For more information, see: Linux Mint topic

> Laggy sound

This issue is due to incorrect buffer sizes.

Either disable any modifications (if any) to these entries, or, if issue
still exists, uncomment:

    /etc/pulse/daemon.conf

    default-fragments = 8
    default-fragment-size-msec = 5

> Choppy, overdriven sound

Choppy sound in PulseAudio can result from wrong settings for the sample
rate. Try:

    /etc/pulse/daemon.conf

    default-sample-rate = 48000

and restart the PulseAudio server.

If one experiences choppy sound in applications using openAL, change the
sample rate in /etc/openal/alsoft.conf:

    frequency = 48000

Setting the PCM volume above 0 dB can cause clipping of the audio
signal. Running alsamixer -c0 will allow you to see if this is the
problem and if so fix it.

> Volume adjustment does not work properly

Check: /usr/share/pulseaudio/alsa-mixer/paths/analog-output.conf.common

If the volume does not appear to increment/decrement properly using
alsamixer or amixer, it may be due to PulseAudio having a larger number
of increments (65537 to be exact). Try using larger values when changing
volume (e.g. amixer set Master 655+).

> Per-application volumes change when the Master volume is adjusted

This is because PulseAudio uses flat volumes by default, instead of
relative volumes, relative to an absolute master volume. If this is
found to be inconvenient, asinine, or otherwise undesireable, relative
volumes can be enabled by disabling flat volumes in the PulseAudio
daemon's configuration file:

    /etc/pulse/daemon.conf

    flat-volumes = no

and then restarting PulseAudio by executing

    $ pulseaudio -k
    $ pulseaudio --start

  

> Volume gets louder every time a new application is started

Per default, it seems as if changing the volume in an application sets
the global system volume to that level instead of only affecting the
respective application. Applications setting their volume on startup
will therefore cause the system volume to "jump".

Fix this by disabling flat volumes, as demonstrated in the previous
section. When Pulse comes back after a few seconds, applications will
not alter the global system volume anymore but have their own volume
level again.

Note:A previously installed and removed pulseaudio-equalizer may leave
behind remnants of the setup in ~/.pulse/default.pa which can also cause
maximized volume trouble. Comment that out as needed.

> No microphone on ThinkPad T400/T500/T420

Run:

    alsamixer -c 0

Unmute and maximize the volume of the "Internal Mic".

Once you see the device with:

    arecord -l

you might still need to adjust the settings. The microphone and the
audio jack are duplexed. Set the configuration of the internal audio in
pavucontrol to Analog Stereo Duplex.

> No microphone input on Acer Aspire One

Install pavucontrol, unlink the microphone channels and turn down the
left one to 0. Reference:
http://getsatisfaction.com/jolicloud/topics/deaf_internal_mic_on_acer_aspire_one#reply_2108048

> Sound output is only mono on M-Audio Audiophile 2496 sound card

Add the following:

    /etc/pulseaudio/default.pa

    load-module module-alsa-sink sink_name=delta_out device=hw:M2496 format=s24le channels=10 channel_map=left,right,aux0,aux1,aux2,aux3,aux4,aux5,aux6,aux7
    load-module module-alsa-source source_name=delta_in device=hw:M2496 format=s24le channels=12 channel_map=left,right,aux0,aux1,aux2,aux3,aux4,aux5,aux6,aux7,aux8,aux9
    set-default-sink delta_out
    set-default-source delta_in

> Static noise in microphone recording

If we are getting static noise in Skype, gnome-sound-recorder, arecord,
etc.'s recordings, then the sound card sample rate is incorrect. That is
why there is static noise in Linux microphone recordings. To fix this,
we need to set the sampling rate in /etc/pulse/daemon.conf for the sound
hardware.

Determine sound cards in the system (1/5)

This requires alsa-utils and related packages to be installed:

    $ arecord --list-devices

    **** List of CAPTURE Hardware Devices ****
    card 0: Intel [HDA Intel], device 0: ALC888 Analog [ALC888 Analog]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 0: Intel [HDA Intel], device 2: ALC888 Analog [ALC888 Analog]
      Subdevices: 1/1
      Subdevice #0: subdevice #0

Sound card is hw:0,0.

Determine sampling rate of the sound card (2/5)

    arecord -f dat -r 60000 -D hw:0,0 -d 5 test.wav

    "Recording WAVE 'test.wav' : Signed 16 bit Little Endian, Rate 60000 Hz, Stereo
    Warning: rate is not accurate (requested = 60000Hz, got = 96000Hz)
    please, try the plug plugin

observe, the got = 96000Hz. This is the maximum sampling rate of our
card.

Setting the sound card's sampling rate into PulseAudio configuration (3/5)

The default sampling rate in PulseAudio:

    $ grep "default-sample-rate" /etc/pulse/daemon.conf

    ; default-sample-rate = 44100

44100 is disabled and needs to be changed to 96000:

    # sed 's/; default-sample-rate = 44100/default-sample-rate = 96000/g' -i /etc/pulse/daemon.conf

Restart PulseAudio to apply the new settings (4/5)

    $ pulseaudio -k
    $ pulseaudio --start

Finally check by recording and playing it back (5/5)

Let us record some voice using a microphone for, say, 10 seconds. Make
sure the microphone is not muted and all

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
library.

> Subwoofer stops working after end of every song

Known issue:
https://bugs.launchpad.net/ubuntu/+source/pulseaudio/+bug/494099

To fix this, must edit: /etc/pulse/daemon.conf and enable
enable-lfe-remixing :

    /etc/pulse/daemon.conf

    enable-lfe-remixing = yes

> PulseAudio uses wrong microphone

If PulseAudio uses the wrong microphone, and changing the Input Device
with Pavucontrol did not help, take a look at alsamixer. It seems that
Pavucontrol does not always set the input source correctly.

    $ alsamixer

Press F6 and choose your sound card, e.g. HDA Intel. Now press F5 to
display all items. Try to find the item: Input Source. With the up/down
arrow keys you are able to change the input source.

Now try if the correct microphone is used for recording.

> Choppy sound with analog surround sound setup

The low-frequency effects (LFE) channel is not remixed per default. To
enable it the following needs to be set in /etc/pulse/daemon.conf :

    /etc/pulse/daemon.conf

    enable-lfe-remixing = yes

> No sound below a volume cutoff

Known issue (won't fix):
https://bugs.launchpad.net/ubuntu/+source/pulseaudio/+bug/223133

If sound does not play when PulseAudio's volume is set below a certain
level, try setting ignore_dB=1 in /etc/pulse/default.pa:

    /etc/pulse/default.pa

    load-module module-udev-detect ignore_dB=1

However, be aware that it may cause another bug preventing PulseAudio to
unmute speakers when headphones or other audio devices are unplugged.

> Low volume for internal microphone

If you experience low volume on internal notebook microphone, try
setting:

    /etc/pulse/default.pa

    set-source-volume 1 300000

> Clients alter master output volume (a.k.a. volume jumps to 100% after running application)

If changing the volume in specific applications or simply running an
application changes the master output volume this is likely due to flat
volumes mode of pulseaudio. Before disabling it, KDE users should try
lowering their system notifications volume in System Settings ->
Application and System Notifications -> Manage Notifications under the
Player Settings tab to something reasonable. Changing the Event Sounds
volume in KMix or another volume mixer application will not help here.
This should make the flat-volumes mode work out as intended, if it does
not work, some other application is likely requesting 100% volume when
its playing something. If all else fails, you can try to disable
flat-volumes:

    /etc/pulse/daemon.conf

    flat-volumes = no

Then restart PulseAudio daemon:

    # pulseaudio -k
    # pulseaudio --start

> Realtime scheduling

If rtkit does not work, you can manually set up your system to run
PulseAudio with real-time scheduling, which can help performance. To do
this, add the following lines to /etc/security/limits.conf:

    @pulse-rt - rtprio 9
    @pulse-rt - nice -11

Afterwards, you need to add your user to the pulse-rt group:

    # gpasswd -a <user> pulse-rt

> No sound after resume from suspend

If audio generally works, but stops after resume from suspend, try
"reloading" PulseAudio by executing:

    $ /usr/bin/pasuspender /bin/true

This is better than completely killing and restarting it (pulseaudio -k
followed by pulseaudio --start), because it doesn't break already
running applications.

If the above fixes your problem, you may wish to automate it, by
creating a systemd service file.

1. Create the template service file in
/etc/systemd/system/resume-fix-pulseaudio@.service:

    [Unit]
    Description=Fix PulseAudio after resume from suspend
    After=suspend.target

    [Service]
    User=%I
    Type=oneshot
    Environment="XDG_RUNTIME_DIR=/run/user/%U"
    ExecStart=/usr/bin/pasuspender /bin/true

    [Install]
    WantedBy=suspend.target

2. Enable it for your user account

    # systemctl enable resume-fix-pulseaudio@YOUR_USERNAME_HERE.service

3. Reload systemd

    # systemctl --system daemon-reload

> ALSA channels mute when headphones are plugged/unplugged improperly

If when you unplug your headphones or plug them in the audio remains
muted in alsamixer on the wrong channel due to it being set to 0%, you
may be able to fix it by opening /etc/pulse/default.pa and commenting
out the line:

    load-module module-switch-on-port-available

> pactl "invalid option" error with negative percentage arguments

pactl commands that take negative percentage arguments will fail with an
'invalid option' error. Use the standard shell '--' pseudo argument to
disable argument parsing before the negative argument. e.g.
pactl set-sink-volume 1 -- -5%.

> Daemon already running

On some systems, PulseAudio may be started multiple times. journalctl
will report:

    [pulseaudio] pid.c: Daemon already running.

Make sure to use only one method of autostarting applications.
pulseaudio includes these files:

-   /etc/X11/xinit/xinitrc.d/pulseaudio
-   /etc/xdg/autostart/pulseaudio.desktop
-   /etc/xdg/autostart/pulseaudio-kde.desktop

Also check user autostart files and directories, such as xinitrc,
~/.config/autostart/ etc.

See also
--------

-   http://www.alsa-project.org/main/index.php/Asoundrc - ALSA wiki on
    .asoundrc
-   http://www.pulseaudio.org/ - PulseAudio official site
-   http://www.pulseaudio.org/wiki/FAQ - PulseAudio FAQ

Retrieved from
"https://wiki.archlinux.org/index.php?title=PulseAudio&oldid=304588"

Categories:

-   Audio/Video
-   Sound

-   This page was last modified on 15 March 2014, at 10:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
