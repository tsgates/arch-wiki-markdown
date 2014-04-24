Advanced Linux Sound Architecture
=================================

Related articles

-   Sound system
-   Disable PC Speaker Beep
-   Advanced Linux Sound Architecture/Example Configurations

The Advanced Linux Sound Architecture (ALSA) is a Linux kernel component
which replaced the original Open Sound System (OSSv3) for providing
device drivers for sound cards. Besides the sound device drivers, ALSA
also bundles a user space library for application developers who want to
use driver features with a higher level API than direct interaction with
the kernel drivers.

Note:For an alternative sound environment, see the Open Sound System
page.

Contents
--------

-   1 Installation
    -   1.1 User-space utilities
-   2 Unmuting the channels
-   3 Configuration
    -   3.1 Set the default sound card
        -   3.1.1 Select the default PCM via environment variable
        -   3.1.2 Alternative method
    -   3.2 Making sure the sound modules are loaded
    -   3.3 Getting SPDIF output
    -   3.4 System-wide equalizer
        -   3.4.1 Using AlsaEqual (provides UI)
            -   3.4.1.1 Managing AlsaEqual states
        -   3.4.2 Using mbeq
-   4 High quality resampling
-   5 Upmixing/downmixing
    -   5.1 Upmixing
    -   5.2 Downmixing
-   6 Mixing
    -   6.1 Manually enabling dmix
-   7 Troubleshooting
    -   7.1 No sound in VirtualBox
    -   7.2 Sound skipping while using dynamic frequency scaling
    -   7.3 Problems with availability to only one user at a time
    -   7.4 Simultaneous playback problems
    -   7.5 Random lack of sound on startup
        -   7.5.1 Timidity
    -   7.6 Specific program problems
    -   7.7 Model settings
    -   7.8 Conflicting PC speaker
    -   7.9 No microphone input
    -   7.10 Crackling in microphone
    -   7.11 Setting the default microphone/capture device
    -   7.12 Internal microphone not working
    -   7.13 No sound with onboard Intel sound card
    -   7.14 No headphone sound with onboard Intel sound card
    -   7.15 No sound when S/PDIF video card is installed
    -   7.16 Poor sound quality or clipping
    -   7.17 Pops when starting and stopping playback
    -   7.18 S/PDIF output does not work
    -   7.19 HDMI output does not work
    -   7.20 HDMI multi-channel PCM output does not work (Intel)
    -   7.21 HP TX2500
    -   7.22 Skipping sound when playing MP3
    -   7.23 Using a USB headset and external USB sound cards
        -   7.23.1 Crackling sound with USB devices
        -   7.23.2 Hot-plugging a USB sound card
    -   7.24 Error 'Unknown hardware' appears after a kernel update
    -   7.25 HDA analyzer
    -   7.26 ALSA with SDL
    -   7.27 Low sound workaround
    -   7.28 Popping sound after resuming from suspension
    -   7.29 Mute after reboot
    -   7.30 Volume too low
    -   7.31 alsamixer F3 and F4 key issue
    -   7.32 Removing old ALSA state file (asound.state)
    -   7.33 HDMI 5.1 sound goes to wrong speakers
-   8 See also

Installation
------------

ALSA is included in the default Arch kernel as a set of modules, so
installing it is not necessary.

udev will automatically probe your hardware at boot, loading the
corresponding kernel module for your audio card. Therefore, your sound
should already be working, but upstream sources mute all channels by
default.

Users with a local login (at a virtual terminal or a display manager)
have permission to play audio and change mixer levels. To allow this for
a remote login, the user has to be added to the audio group. Membership
in the audio group also allows direct access to devices, which can lead
to applications grabbing exclusive output (breaking software mixing) and
breaks fast-user-switching, and multiseat. Therefore, adding a user to
the audio group is not recommended, unless you specifically need to[1].

> User-space utilities

Install the alsa-utils package from the official repositories which
contains the alsamixer user-space tool, which allows for configuration
of the sound device from the console or terminal. Also install the
alsa-plugins package if you want high quality resampling,
upmixing/downmixing and other advanced features.

If you want OSS applications to work with dmix (software mixing), also
install the alsa-oss package. Load the snd_seq_oss, snd_pcm_oss and
snd_mixer_oss kernel modules to enable the OSS emulation modules.

Unmuting the channels
---------------------

The current version of ALSA installs with all channels muted by default.
You will need to unmute the channels manually.

It is easiest to use alsamixer ncurses UI to accomplish this:

    $ alsamixer

Alternatively, use amixer from the command-line:

    $ amixer sset Master unmute

In alsamixer, the MM label below a channel indicates that the channel is
muted, and 00 indicates that it is open.

Scroll to the Master and PCM channels with the ← and → keys and unmute
them by pressing the m key. Use the ↑ key to increase the volume and
obtain a value of 0 dB gain. The gain can be found in the upper left
next to the Item: field. Higher values of gain will produce distorted
sound.

To get full 5.1 or 7.1 surround sound you likely need to unmute other
channels such as Front, Surround, Center, LFE (subwoofer) and Side
(these are the names of the channels with Intel HD Audio, they may vary
with different hardware). Please take note that this will not
automatically upmix stereo sources (like most music). In order to
accomplish that, see #Upmixing/Downmixing.

To enable your microphone, switch to the Capture tab with F4 and enable
a channel with Space.

Leave alsamixer by pressing Esc.

> Note:

-   Some cards need to have digital output muted/turned off in order to
    hear analog sound. For the Soundblaster Audigy LS mute the IEC958
    channel.
-   Some machines, (like the Thinkpad T61), have a Speaker channel which
    must be unmuted and adjusted as well.
-   Some machines, (like the Dell E6400) may also require the Front and
    Headphone channels to be unmuted and adjusted.
-   If your volume adjustments seems to be lost when you reboot, try
    running alsamixer as root.

Next, test to see if sound works:

    $ speaker-test -c 2

Change -c to fit your speaker setup. Use -c 8 for 7.1, for instance:

    $ speaker-test -c 8

If it does not work, proceed to Configuration and then Troubleshooting
to solve your problems.

The alsa-utils package includes alsa-restore.service and
alsa-store.service, which are preconfigured to run at boot and shutdown
respectively. For reference, ALSA stores its settings in
/var/lib/alsa/asound.state.

Configuration
-------------

> Set the default sound card

If your sound card order changes on boot, you can specify their order in
any file ending with .conf in /etc/modprobe.d
(/etc/modprobe.d/alsa-base.conf is suggested). For example, if you want
your mia sound card to be #0:

    /etc/modprobe.d/alsa-base.conf

    options snd slots=snd_mia,snd_hda_intel
    options snd_mia index=0
    options snd_hda_intel index=1

Use $ cat /proc/asound/modules to get the loaded sound modules and their
order. This list is usually all that is needed for the loading order.
Use $ lsmod | grep snd to get a devices & modules list. This
configuration assumes you have one mia sound card using snd_mia and one
(e.g. onboard) card using snd_hda_intel.

You can also provide an index of -2 to instruct ALSA to never use a card
as the primary one. Distributions such as Linux Mint and Ubuntu use the
following settings to avoid USB and other "abnormal" drivers from
getting index 0:

    /etc/modprobe.d/alsa-base.conf

    options bt87x index=-2
    options cx88_alsa index=-2
    options saa7134-alsa index=-2
    options snd-atiixp-modem index=-2
    options snd-intel8x0m index=-2
    options snd-via82xx-modem index=-2
    options snd-usb-audio index=-2
    options snd-usb-caiaq index=-2
    options snd-usb-ua101 index=-2
    options snd-usb-us122l index=-2
    options snd-usb-usx2y index=-2
    options snd-pcsp index=-2
    options snd-usb-audio index=-2

These changes require a system reboot.

Select the default PCM via environment variable

In your configuration file, preferably global, add:

     pcm.!default {
       type plug
       slave.pcm {
         @func getenv
         vars [ ALSAPCM ]
         default "hw:Audigy2"
       }
     }

You need to replace the default line with the name of your card (in the
example is Audigy2). You can get the names with aplay -l or you can also
use PCMs like surround51. But if you need to use the microphone it is a
good idea to select full-duplex PCM as default.

Now you can start programs selecting the sound card just changing the
environment variable ALSAPCM. It works fine for all program that do not
allow to select the card, for the others ensure you keep the default
card. For example, assuming you wrote a downmix PCM called mix51to20 you
can use it with mplayer using the commandline
ALSAPCM=mix51to20 mplayer example_6_channel.wav

Alternative method

First you will have to find out the card and device id that you want to
set as the default by running aplay -l:

    $ aplay -l

    **** List of PLAYBACK Hardware Devices ****
    card 0: Intel [HDA Intel], device 0: CONEXANT Analog [CONEXANT Analog]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 0: Intel [HDA Intel], device 1: Conexant Digital [Conexant Digital]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 1: JamLab [JamLab], device 0: USB Audio [USB Audio]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 2: Audio [Altec Lansing XT1 - USB Audio], device 0: USB Audio [USB Audio]
      Subdevices: 1/1
      Subdevice #0: subdevice #0

For example, the last entry in this list has the card ID 2 and the
device ID 0. To set this card as the default, you can either use the
system-wide file /etc/asound.conf or the user-specific file ~/.asoundrc.
You may have to create the file if it does not exist. Then insert the
following options with the corresponding card.

    pcm.!default {
    	type hw
    	card 2
    }

    ctl.!default {
    	type hw           
    	card 2
    }

Note:For the Asus U32U serie it seems that card should be set to 1 for
both pcm and ctl.

In most cases it is recommended to use sound card names instead of
number references, which also solves boot order problem. Therefore the
following would be correct for the above example.

    pcm.!default {
    	type hw
    	card Audio
    }

    ctl.!default {
    	type hw           
    	card Audio
    }

To get card names use one of those commands:

    $ aplay -l | awk -F \: '/,/{print $2}' | awk '{print $1}' | uniq
    $ cat /proc/asound/card*/id

    Intel
    JamLab
    Audio

Note:This method could be problematic if system has several cards of the
same (alsa)name.

The 'pcm' options affect which card and device will be used for audio
playback while the 'ctl' option affects which card is used by control
utilities like alsamixer .

The changes should take effect as soon as you (re-)start an application
(MPlayer etc.). You can also test with a command like aplay.

    $ aplay -D default your_favourite_sound.wav

If you receive an error regarding your asound configuration, check the
upstream documentation for possible changes to the config file format.

Simply setting a type hw as default card is equivalent to addressing
hardware directly, which leaves the device unavailable to other
applications. This method is only recommended if it is a part of a more
sophisticated setup ~/.asoundrc or if user deliberately wants to address
sound card directly (digital output through eic958 or dedicated music
server for example).

> Making sure the sound modules are loaded

You can assume that udev will autodetect your sound properly. You can
check this with the command

    $ lsmod | grep '^snd' | column -t

    snd_hda_codec_hdmi     22378   4
    snd_hda_codec_realtek  294191  1
    snd_hda_intel          21738   1
    snd_hda_codec          73739   3  snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel
    snd_hwdep              6134    1  snd_hda_codec
    snd_pcm                71032   3  snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
    snd_timer              18992   1  snd_pcm
    snd                    55132   9  snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
    snd_page_alloc         7017    2  snd_hda_intel,snd_pcm

If the output looks similar, your sound drivers have been successfully
autodetected.

Note:Since udev>=171, the OSS emulation modules
(snd_seq_oss, snd_pcm_oss, snd_mixer_oss) are not loaded by default:
Load them manually if they are needed.

You might also want to check the directory /dev/snd/ for the right
device files:

    $ ls -l /dev/snd

    total 0
    crw-rw----  1 root audio 116,  0 Apr  8 14:17 controlC0
    crw-rw----  1 root audio 116, 32 Apr  8 14:17 controlC1
    crw-rw----  1 root audio 116, 24 Apr  8 14:17 pcmC0D0c
    crw-rw----  1 root audio 116, 16 Apr  8 14:17 pcmC0D0p
    crw-rw----  1 root audio 116, 25 Apr  8 14:17 pcmC0D1c
    crw-rw----  1 root audio 116, 56 Apr  8 14:17 pcmC1D0c
    crw-rw----  1 root audio 116, 48 Apr  8 14:17 pcmC1D0p
    crw-rw----  1 root audio 116,  1 Apr  8 14:17 seq
    crw-rw----  1 root audio 116, 33 Apr  8 14:17 timer

Note:If requesting help on IRC or the forums, please post the output of
the above commands.

If you have at least the devices controlC0 and pcmC0D0p or similar, then
your sound modules have been detected and loaded properly.

If this is not the case, your sound modules have not been detected
properly. To solve this, you can try loading the modules manually:

-   Locate the module for your sound card: ALSA Soundcard Matrix The
    module will be prefixed with 'snd-' (for example: snd-via82xx).
-   Load the module.
-   Check for the device files in /dev/snd (see above) and/or try if
    alsamixer or amixer have reasonable output.
-   Configure snd-NAME-OF-MODULE and snd-pcm-oss to load at boot.

> Getting SPDIF output

(from gralves from the Gentoo forums)

-   In GNOME Volume Control, under the Options tab, change the IEC958 to
    PCM. This option can be enabled in the preferences.
-   If you do not have GNOME Volume Control installed,
    -   Edit /var/lib/alsa/asound.state. This file is where alsasound
        stores your mixer settings.
    -   Find a line that says: 'IEC958 Playback Switch'. Near it you
        will find a line saying value:false. Change it to value:true.
    -   Now find this line: 'IEC958 Playback AC97-SPSA'. Change its
        value to 0.
    -   Restart ALSA.

As of Feb 2, 2014, the above method does not seem to work. See below.

Alternative way to enable SPDIF output automatically on login:

-   add following line to ~/.xinitrc:

    amixer -c 0 cset name='IEC958 Playback Switch' on

You can see the name of your card's digital output with:

     $ amixer scontrols

> System-wide equalizer

Using AlsaEqual (provides UI)

Install alsaequal from the AUR.

Note: If you have a x86_64-system and are using a 32bit-flashplugin the
sound in flash will not work. Either you have to disable alsaequal or
build alsaequal for 32bit.

After installing the package, insert the following into your ALSA
configuration file (~/.asoundrc or /etc/asound.conf):

    ctl.equal {
     type equal;
    }

    pcm.plugequal {
      type equal;
      # Modify the line below if you do not
      # want to use sound card 0.
      #slave.pcm "plughw:0,0";
      #by default we want to play from more sources at time:
      slave.pcm "plug:dmix";
    }
    #pcm.equal {
      # If you do not want the equalizer to be your
      # default soundcard comment the following
      # line and uncomment the above line. (You can
      # choose it as the output device by addressing
      # it with specific apps,eg mpg123 -a equal 06.Back_In_Black.mp3)
    pcm.!default {
      type plug;
      slave.pcm plugequal;
    }

And you are ready to change your equalizer using command

    $ alsamixer -D equal

Note that configuration file is different for each user (until not
specified else) it is saved in ~/.alsaequal.bin. so if you want to use
AlsaEqual with mpd or another software running under different user, you
can configure it using

    # su mpd -c 'alsamixer -D equal'

or for example, you can make a symlink to your .alsaequal.bin in his
home...

Managing AlsaEqual states

Install alsaequal-mgr from the AUR (or alternatively from Xyne's repos).

Configure the equalizer as usual with

    $ alsamixer -D equal

When you are satisfied with the state, you may give it a name ("foo" in
this example) and save it:

    $ alsaequal-mgr save foo

The state "foo" can then be restored at a later time with

    $ alsaequal-mgr load foo

You can thus create different equalizer states for games, movies, music
genres, VoIP apps, etc. and reload them as necessary.

See the project page and the help message for more options.

Using mbeq

Note:This method requires the use of a ladspa plugin which might use
quite a bit of CPU when sound plays. In addition, this was made with
stereophonic sound (e.g. headphones) in mind.

Install the alsa-plugins, ladspa and swh-plugins packages if you do not
already have them.

-   If you have not already created either an ~/.asoundrc or a
    /etc/asound.conf file, then create either one and insert the
    following:

    /etc/asound.conf

    pcm.eq {
      type ladspa

      # The output from the EQ can either go direct to a hardware device
      # (if you have a hardware mixer, e.g. SBLive/Audigy) or it can go
      # to the software mixer shown here.
      #slave.pcm "plughw:0,0"
      slave.pcm "plug:dmix"

      # Sometimes you may need to specify the path to the plugins,
      # especially if you have just installed them.  Once you have logged
      # out/restarted this should not be necessary, but if you get errors
      # about being unable to find plugins, try uncommenting this.
      #path "/usr/lib/ladspa"

      plugins [
        {
          label mbeq
          id 1197
          input {
            #this setting is here by example, edit to your own taste
            #bands: 50hz, 100hz, 156hz, 220hz, 311hz, 440hz, 622hz, 880hz, 1250hz, 1750hz, 25000hz,
            #50000hz, 10000hz, 20000hz
            controls [ -5 -5 -5 -5 -5 -10 -20 -15 -10 -10 -10 -10 -10 -3 -2 ]
          }
        }
      ]
     }

     # Redirect the default device to go via the EQ - you may want to do
     # this last, once you are sure everything is working.  Otherwise all
     # your audio programs will break/crash if something has gone wrong.

     pcm.!default {
      type plug
      slave.pcm "eq"
     }

     # Redirect the OSS emulation through the EQ too (when programs are running through "aoss")

     pcm.dsp0 {
      type plug
      slave.pcm "eq"
     }

-   You should be good to go (if not, ask in the forum).

High quality resampling
-----------------------

When software mixing is enabled, ALSA is forced to resample everything
to the same frequency (48000 by default when supported). dmix uses a
poor resampling algorithm which produces noticeable sound quality loss.

Install alsa-plugins and libsamplerate.

Change the default rate converter to libsamplerate:

    /etc/asound.conf

    defaults.pcm.rate_converter "samplerate_best"

or:

    ~/.asoundrc

    defaults.pcm.rate_converter "samplerate_best"

samplerate_best offers the best sound quality, but you need a decent CPU
to be able to use it as it requires a lot of CPU cycles for real-time
resampling. You may also need to adjust buffer_size in your dmix
settings from the basic 4096 to 8192 or 16384. There are other
algorithms available (samplerate, etc.) but they may not provide much of
an improvement over the default resampler.

Warning:On some systems, enabling samplerate_best may cause a problem
where you get no sound from flashplayer.

Upmixing/downmixing
-------------------

> Upmixing

In order for stereo sources like music to be able to saturate a 5.1 or
7.1 sound system, you need to use upmixing. In darker days this used to
be tricky and error prone but nowadays plugins exist to easily take care
of this task. We will use the upmix plugin, included in alsa-plugins.

Then add the following to your ALSA configuration file of choice (either
/etc/asound.conf or ~/.asoundrc):

    pcm.upmix71 {
        type upmix
        slave.pcm "surround71"
        delay 15
        channels 8
    }

You can easily change this example for 7.1 upmixing to 5.1 or 4.0.

This adds a new pcm that you can use for upmixing. If you want all sound
sources to go through this pcm, add it as a default below the previous
definition like so:

    pcm.!default "plug:upmix71"

The plugin automatically allows multiple sources to play through it
without problems so setting is as a default is actually a safe choice.
If this is not working, you have to setup your own dmixer for the
upmixing PCM like this:

    pcm.dmix6 {
        type asym
        playback.pcm {
            type dmix
            ipc_key 567829
            slave {
                pcm "hw:0,0"
                channels 6
            }
        }
    }

and use "dmix6" instead of "surround71". If you experience skipping or
distorted sound, consider increasing the buffer_size (to 32768, for
example) or use a high quality resampler.

> Downmixing

If you want to downmix sources to stereo because you, for instance, want
to watch a movie with 5.1 sound on a stereo system, use the vdownmix
plugin, included in alsa-plugins..

Again, in your configuration file, add this:

    pcm.!surround51 {
        type vdownmix
        slave.pcm "default"
    }
    pcm.!surround40 {
        type vdownmix
        slave.pcm "default"
    }

Note:This might not be enough to make downmixing working, see [2]. So,
you might also need to add pcm.!default "plug:surround51" or
pcm.!default "plug:surround40". Only one vdownmix plug can be used; if
you have 7.1 channels, you will need to use surround71 instead the
configuration above. A good example, which includes a configuration that
makes both vdownmix and dmix working, can be found here.

Mixing
------

Mixing enables multiple applications to output sound at the same time.
Most discrete sound cards support hardware mixing, which is enabled by
default if available. Integrated motherboard sound cards (such as Intel
HD Audio), usually do not support hardware mixing. On such cards,
software mixing is done by an ALSA plugin called dmix. This feature is
enabled automatically if hardware mixing is unavailable.

> Manually enabling dmix

Note:For ALSA 1.0.9rc2 and higher on analog sound outputs you do not
need to setup dmix. Dmix is enabled as default for soundcards which do
not support hardware mixing.

To manually enable dmix is a matter of simply creating a .asoundrc file
in your home folder with the following contents.

    pcm.dsp {
        type plug
        slave.pcm "dmix"
    }

This should enable software mixing and allows more than one application
to make use of the soundcard. If not, try replacing all /etc/asound.conf
content with the above.

For a digital sound output such as S/PDIF, the ALSA package still does
not enable dmix by default. Thus, the dmix configuration above can be
used to enable dmix for S/PDIF devices.

See #Troubleshooting for common problems and solutions.

Troubleshooting
---------------

> No sound in VirtualBox

If you experience problems with VirtualBox, the following command might
be helpful:

    $ alsactl init


    Found hardware: "ICH" "SigmaTel STAC9700,83,84" "AC97a:83847600" "0x8086" "0x0000"
    Hardware is initialized using a generic method

You might need to activate the ALSA output in your audio software as
well.

> Sound skipping while using dynamic frequency scaling

Some combinations of ALSA drivers and chipsets may cause audio from all
sources to skip when used in combination with a dynamic frequency
scaling governor such as ondemand or conservative. Currently, the
solution is to switch back to the performance governor.

Refer to the CPU Frequency Scaling for more information.

> Problems with availability to only one user at a time

You might find that only one user can use the dmixer at a time. This is
probably ok for most, but for those who run mpd as a separate user this
poses a problem. When mpd is playing a normal user cannot play sounds
though the dmixer. While it's quite possible to just run mpd under a
user's login account, another solution has been found. Adding the line
ipc_key_add_uid 0 to the pcm.dmixer block disables this locking. The
following is a snippet of the asound.conf, the rest is the same as
above.

    ...
    pcm.dmixer {
     type dmix
     ipc_key 1024
     ipc_key_add_uid 0
     ipc_perm 0660
    slave {
    ...

> Simultaneous playback problems

If you are having problems with simultaneous playback, and if PulseAudio
is installed (i.e. by GNOME), its default configuration is set to
"hijack" the soundcard. Some users of ALSA may not want to use
PulseAudio and are quite content with their current ALSA settings. One
fix is to edit /etc/asound.conf and comment out the following lines:

    # Use PulseAudio by default
    #pcm.!default {
    #  type pulse
    #  fallback "sysdefault"
    #  hint {
    #    show on
    #    description "Default ALSA Output (currently PulseAudio Sound Server)"
    #  }
    #}

Commenting the following out also may help:

    #ctl.!default {
    #  type pulse
    #  fallback "sysdefault"
    #}

This may be a much simpler solution than completely uninstalling
PulseAudio.

Effectively, here is an example of a working /etc/asound.conf:

    pcm.dmixer {
            type dmix
            ipc_key 1024
            ipc_key_add_uid 0
            ipc_perm 0660
    }
    pcm.dsp {
            type plug
            slave.pcm "dmix"
    }

Note:This /etc/asound.conf file was intended for and used successfully
with a global MPD configuration. See this section on multiple users

> Random lack of sound on startup

You can quickly test sound by running speaker-test. If there is no
sound, the error message might look something like

     ALSA lib pcm_dmix.c:1022:(snd_pcm_dmix_open) unable to open slave
     Playback open error: -16
     Device or resource busy

If you have no sound on startup, this may be because your system has
multiple sound cards, and their order may sometimes change on startup.
If this is the case, try setting the default sound card.

If you use mpd and the configuration tips above do not work for you, try
reading this instead.

Timidity

Timidity can be the cause of missing audio. Try running:

    $ systemctl status timidity

If it failed, try # killall -9 timidity. If this solves the issue, then
you should disable the timidity daemon to be started at boot.

> Specific program problems

For other programs who insist on their own audio setup, e.g., XMMS or
MPlayer, you would need to set their specific options.

For MPlayer, open up a configuration file and add the following line:

    ao=alsa

For mpv append the same line in one of its configuration files.

For XMMS/Beep Media Player, go into their options and make sure the
sound driver is set to Alsa, not oss.

To do this in XMMS:

-   Open XMMS
    -   Options > Preferences.
    -   Choose the ALSA output plugin.

For applications which do not provide a ALSA output, you can use aoss
from the alsa-oss package. To use aoss, when you run the program, prefix
it with aoss, eg:

    aoss realplay

pcm.!default{ ... } doesnt work for me anymore. but this does:

     pcm.default pcm.dmixer

> Model settings

Although Alsa detects your soundcard through the BIOS at times Alsa may
not be able to recognize your model type. The soundcard chip can be
found in alsamixer (e.g. ALC662) and the model can be set in
/etc/modprobe.d/modprobe.conf or /etc/modprobe.d/sound.conf. For
example:

    options snd-hda-intel model=MODEL

There are other model settings too. For most cases Alsa defaults will
do. If you want to look at more specific settings for your soundcard
take a look at the Alsa Soundcard List find your model, then Details,
then look at the "Setting up modprobe..." section. Enter these values in
/etc/modprobe.d/modprobe.conf. For example, for an Intel AC97 audio:

    # ALSA portion
    alias char-major-116 snd
    alias snd-card-0 snd-intel8x0
    # module options should go here

    # OSS/Free portion
    alias char-major-14 soundcore
    alias sound-slot-0 snd-card-0

    # card #1
    alias sound-service-0-0 snd-mixer-oss
    alias sound-service-0-1 snd-seq-oss
    alias sound-service-0-3 snd-pcm-oss
    alias sound-service-0-8 snd-seq-oss
    alias sound-service-0-12 snd-pcm-oss

> Conflicting PC speaker

If you are sure nothing is muted, that your drivers are installed
correctly, and that your volume is right, but you still do not hear
anything, then try adding the following line to
/etc/modprobe.d/modprobe.conf:

    options snd-NAME-OF-MODULE ac97_quirk=0

The above fix has been observed to work with via82xx

    options snd-NAME-OF-MODULE ac97_quirk=1

The above fix has been reported to work with snd_intel8x0

> No microphone input

In alsamixer, make sure that all the volume levels are up under
recording, and that CAPTURE is toggled active on the microphone (e.g.
Mic, Internal Mic) and/or on Capture (in alsamixer, select these items
and press space). Try making positive Mic Boost and raising Capture and
Digital levels higher; this make make static or distortion, but then you
can adjust them back down once you are hearing something when you record

As the pulseaudio wrapper is shown as "default" in alsamixer, you may
have to press F6 to select your actual soundcard first. You may also
need to enable and increase the volume of Line-in in the Playback
section.

To test the microphone, run these commands (see arecord's man page for
further information):

    $ arecord -d 5 test-mic.wav
    $ aplay test-mic.wav

If all fails, you may want to eliminate hardware failure by testing the
microphone with a different device.

For at least some computers, muting a microphone (MM) simply means its
input does not go immediately to the speakers. It still receives input.

Many Dell laptops need "-dmic" to be appended to the model name in
/etc/modprobe.d/modprobe.conf:

     options snd-hda-intel model=dell-m6-dmic

Some programs use try to use OSS as the main input software. If you have
enabled the snd_pcm_oss, snd_mixer_oss or snd_seq_oss kernel modules
previously (they are not loaded by default), try unloading them.

See also:

-   http://www.alsa-project.org/main/index.php/SoundcardTesting
-   http://alsa.opensrc.org/Record_from_mic

> Crackling in microphone

If you're getting a crackling or popping from your microphone that can't
be resolved with ALSA settings or cleaning your microphone jack, try
adding the following line to /etc/modprobe.d/modprobe.conf:

    options snd-hda-intel model=MODEL position_fix=3

This option will fix crackling on pure Alsa, but will cause issues to
pulseaudio. To let Pulse use these settings effectively, edit
/etc/pulse/default.pa and find this line:

    load-module module-udev-detect

And change it to this:

    load-module module-udev-detect tsched=0

See the DMA-Position Problem in the kernel docs.

-   HD-audio Kernel Docs

> Setting the default microphone/capture device

Some applications (Pidgin, Adobe Flash) do not provide an option to
change the capture device. It becomes a problem if your microphone is on
a separate device (e.g. USB webcam or microphone) than your internal
sound card. To change only the default capture device, leaving the
default playback device as is, you can modify your ~/.asoundrc file to
include the following:

    pcm.usb
    {
        type hw
        card U0x46d0x81d
    }

    pcm.!default
    {
        type asym
        playback.pcm
        {
            type plug
            slave.pcm "dmix"
        }
        capture.pcm
        {
            type plug
            slave.pcm "usb"
        }
    }

Replace "U0x46d0x81d" with your capture device's card name in ALSA. You
can use arecord -L to list all the capture devices detected by ALSA.

> Internal microphone not working

First make sure all the volume levels are up under recording in
alsamixer. In my case adding the following option to /etc/sound.conf and
reloading the snd-* module produced a new volume setting called Capture
which was capturing for the internal mic. For eg, for snd-hda-intel add

    options snd-hda-intel enable_msi=1

Then reload the module (as below), up the recording volume of Capture
and then test.

    # rmmod snd-hda-intel && modprobe snd-hda-intel

> No sound with onboard Intel sound card

There may be a problem with two conflicting modules loaded, namely
snd_intel8x0 and snd_intel8x0m. In this case, blacklist snd_intel8x0m:

    /etc/modprobe.d/modprobe.conf

    blacklist snd_intel8x0m

Muting the "External Amplifier" in alsamixer or amixer may also help.
See the ALSA wiki.

Unmuting the "Mix" setting in the mixer might help, also.

> No headphone sound with onboard Intel sound card

With Intel Corporation 82801 I (ICH9 Family) HD Audio Controller on
laptop, you may need to add this line to modprobe or sound.conf:

    options snd-hda-intel model=model

Where model is any one of the following (in order of possibility to
work, but not merit):

-   dell-vostro
-   olpc-xo-1_5
-   laptop
-   dell-m6
-   laptop-hpsense

Note:It may be necessary to put this "options" line below (after) any
"alias" lines about your card.

You can see all the available models in the kernel documentation. For
example here, but check that it is the correct version of that document
for your kernel version.

A list of available models is also available here. To know your chip
name type the following command (with * being corrected to match your
files). Note that some chips could have been renamed and do not directly
match the available ones in the file.

    $ grep Codec /proc/asound/card*/codec*

Note that there is a high chance none of the input devices (all internal
and external mics) will work if you choose to do this, so it is either
your headphones or your mic. Please report to ALSA if you are affected
by this bug.

And also, if you have problems getting beeps to work (pcspkr):

    options snd-hda-intel model=$model enable=1 index=0

> No sound when S/PDIF video card is installed

Discover available modules and their order:

    $ cat /proc/asound/modules

     0 snd_hda_intel
     1 snd_ca0106

Disable the undesired video card audio codec in
/etc/modprobe.d/modprobe.conf:

    # /etc/modprobe.d/modprobe.conf
    #
    install snd_hda_intel /bin/false

If both devices use the same module then we can use the *enable*
parameter from snd-hda-intel module, it's an array of booleans that can
enable/disable the desired sound card.

e.g

    options snd-hda-intel enable=1,0

the following gives you the list of cards

    cat /proc/asound/cards

> Poor sound quality or clipping

If you experience poor sound quality, try setting the PCM volume (in
alsamixer) to a level such that gain is 0.

If snd-usb-audio driver has been loaded, you could try to enable softvol
in /etc/asound.conf file. Example configuration for the first audio
device:

     pcm.!default {
       type plug
       slave.pcm "softvol"
     }
     pcm.dmixer {
          type dmix
          ipc_key 1024
          slave {
              pcm "hw:0"
              period_time 0
              period_size 4096
              buffer_size 131072
              rate 50000
          }
          bindings {
              0 0
              1 1
          }
     }
     pcm.dsnooper {
          type dsnoop
          ipc_key 1024
          slave {
              pcm "hw:0"
              channels 2
              period_time 0
              period_size 4096
              buffer_size 131072
              rate 50000
          }
          bindings {
              0 0
              1 1
          }
     }
     pcm.softvol {
          type softvol
          slave { pcm "dmixer" }
          control {
              name "Master"
              card 0
          }
     }
     ctl.!default {
       type hw
       card 0
     }
     ctl.softvol {
       type hw
       card 0
     }
     ctl.dmixer {
       type hw
       card 0
     }

> Pops when starting and stopping playback

Some modules (e.g. snd_ac97_codec and snd_hda_intel) can power off your
sound card when not in use. This can make an audible noise (like a
crack/pop/scratch) when turning on/off your sound card. Sometimes even
when move the slider volume, or open and close windows (KDE4). If you
find this annoying try modinfo snd_MY_MODULE, and look for a module
option that adjusts or disables this feature.

Example: disable the power saving mode and solve cracking sound trough
speakers problem, using snd_hda_intel add in
/etc/modprobe.d/modprobe.conf:

    options snd_hda_intel power_save=0

or:

    options snd_hda_intel power_save=0 power_save_controller=N

You can also try it with modprobe snd_hda_intel power_save=0 before.

You may also have to unmute the 'Line' ALSA channel for this to work.
Any value will do (other than '0' or something too high).

Example: on an onboard VIA VT1708S (using the snd_hda_intel module)
these cracks occured even though 'power_save' was set to 0. Unmuting the
'Line' channel and setting a value of '1' solved the problem.

Source:
https://www.kernel.org/doc/Documentation/sound/alsa/powersave.txt

If you use a laptop, pm-utils will change power_save back to 1 when you
go onto battery power even if you disable power saving in
/etc/modprobe.d. Disable this for pm-utils by disabling the script that
makes the change (see Disabling a hook for more information):

    # touch /etc/pm/power.d/intel-audio-powersave

> S/PDIF output does not work

If the optical/coaxial digital output of your motherboard/sound card is
not working or stopped working, and have already enabled and unmuted it
in alsamixer, try running

    # iecset audio on

You can also put this command in an enabled systemd service as it
sometimes it may stop working after a reboot.

> HDMI output does not work

The procedure described below can be used to test HDMI audio. Before
proceeding, make sure you have enabled and unmuted the output with
alsamixer.

Note:If you are using an ATI card and linux kernel >=3.0, a necessary
kernel module is disabled by default. See ATI#HDMI_audio.

Connect your PC to the Display via HDMI cable and enable the display
with a tool such as xrandr or arandr. For example:

    $ xrandr # list outputs
    $ xrandr --output DVI-D_1 --mode 1024x768 --right-of PANEL # enable output

Use aplay -l to get the discover the card and device number. For
example:

    $ aplay -l
    **** List of PLAYBACK Hardware Devices ****
    card 0: SB [HDA ATI SB], device 0: ALC892 Analog [ALC892 Analog]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 0: SB [HDA ATI SB], device 1: ALC892 Digital [ALC892 Digital]
      Subdevices: 1/1
      Subdevice #0: subdevice #0
    card 1: Generic [HD-Audio Generic], device 3: HDMI 0 [HDMI 0]
      Subdevices: 1/1
      Subdevice #0: subdevice #0

Send sound to the device. Following the example in the previous step,
you would send sound to card 1, device 3:

    $ aplay -D plughw:1,3 /usr/share/sounds/alsa/Front_Center.wav

If aplay does not output any errors, but still no sound is heared,
"reboot" the receiver, monitor or tv set. Since the HDMI interface
executes a handshake on connection, it might have noticed before that
there was no audio stream embedded, and disabled audio decoding. In
particular, if you are using a standalone window manager (don’t know
about Gnome or KDE), you may need to have some sound playing while
plugging in the HDMI cable.

mplay and other application could be configured to use special HDMI
device as audio output. But flashplugin could only use default device.
The following method is used to override default device. But you need to
change it back when your TV is disconnected from HDMI port.

If the test is successful, create or edit your ~/.asoundrc file to set
HDMI as the default audio device.

    ~/.asoundrc

    pcm.!default {
      type hw
      card 0
      device 3
    }

Or you above config does not work try:

    ~/.asoundrc

    defaults.pcm.card 0
    defaults.pcm.device 3
    defaults.ctl.card 0

> HDMI multi-channel PCM output does not work (Intel)

As of Linux 3.1 multi-channel PCM output through HDMI with a Intel card
(Intel Eaglelake, IbexPeak/Ironlake,SandyBridge/CougarPoint and
IvyBridge/PantherPoint) is not yet supported. Support for it has been
recently added and expected to be available in Linux 3.2. To make it
work in Linux 3.1 you need to apply the following patches:

-   drm: support routines for HDMI/DP ELD
-   drm/i915: pass ELD to HDMI/DP audio driver

> HP TX2500

Add these 2 lines into /etc/modprobe.d/modprobe.conf:

    options snd-cmipci mpu_port=0x330 fm_port=0x388
    options snd-hda-intel index=0 model=toshiba position_fix=1

    options snd-hda-intel model=hp (works for tx2000cto)

> Skipping sound when playing MP3

If you have sound skipping when playing MP3 files and you have more then
2 speakers attached to your computer (i.e. more than 2 speaker system),
run alsamixer and disable the channels for the speakers that you do not
have (i.e. do not enable the sound for the center speaker if you do not
have a center speaker.

> Using a USB headset and external USB sound cards

If you are using a USB headset with ALSA you can try using asoundconf
(currently only available from the AUR) to set the headset as the
primary sound output. Before running make sure you have usb audio module
enabled (modprobe snd_usb_audio).

    # asoundconf is-active
    # asoundconf list
    # asoundconf set-default-card chosen soundcard

Crackling sound with USB devices

If you experience crackling sound on USB devices, you can try tuning the
snd-usb-audio for minimal latency.

Add this to your /etc/modprobe.d/modprobe.conf:

    options snd-usb-audio nrpacks=1

source:
http://alsa.opensrc.org/Usb-audio#Tuning_USB_devices_for_minimal_latencies

Hot-plugging a USB sound card

In order to automatically make a USB Sound Card the primary output
device, when the card is plugged in, you can use the following udev
rules (e.g. add the following two lines to
/etc/udev/rules.d/00-local.rules and reboot).

    KERNEL=="pcmC[D0-9cp]*", ACTION=="add", PROGRAM="/bin/sh -c 'K=%k; K=$${K#pcmC}; K=$${K%%D*}; echo defaults.ctl.card $$K > /etc/asound.conf; echo defaults.pcm.card $$K >>/etc/asound.conf'"
    KERNEL=="pcmC[D0-9cp]*", ACTION=="remove", PROGRAM="/bin/sh -c 'echo defaults.ctl.card 0 > /etc/asound.conf; echo defaults.pcm.card 0 >>/etc/asound.conf'"

> Error 'Unknown hardware' appears after a kernel update

The following messages may be displayed during the start-up ALSA after
the kernel update:

    Unknown hardware "foo" "bar" ...
    Hardware is initialized using a guess method
    /usr/bin/alsactl: set_control:nnnn:failed to obtain info for control #mm (No such file or directory)

or:

    Found hardware: "HDA-Intel" "VIA VT1705" "HDA:11064397,18490397,00100000" "0x1849" "0x0397"
    Hardware is initialized using a generic method
    /usr/bin/alsactl: set_control:1328: failed to obtain info for control #1 (No such file or directory)
    /usr/bin/alsactl: set_control:1328: failed to obtain info for control #2 (No such file or directory)
    /usr/bin/alsactl: set_control:1328: failed to obtain info for control #25 (No such file or directory)
    /usr/bin/alsactl: set_control:1328: failed to obtain info for control #26 (No such file or directory)

Simply store ALSA mixer settings again:

    # alsactl -f /var/lib/alsa/asound.state store

It may be necessary configure ALSA again with alsamixer

> HDA analyzer

If the mappings to your audio pins(plugs) do not correspond but ALSA
works fine, you could try HDA Analyzer -- a pyGTK2 GUI for HD-audio
control can be found at the ALSA wiki. Try tweaking the Widget Control
section of the PIN nodes, to make microphones IN and headphone jacks
OUT. Referring to the Config Defaults heading is a good idea.

> Note:

-   The script is done by such way that it is incompatible with Python 3
    (which is now shipped with Arch Linux) but tries to use it. The
    workaround is: open "run.py", find all occurences of "python" (2
    occurences - one on the first line, and the second on the last line)
    and replace them all by "python2".
-   The script requires root acces, but running it via su/sudo is bogus.
    Run it via kdesu or gksu.

> ALSA with SDL

If you get no sound via SDL and ALSA cannot be chosen from the
application. Try setting the environmental variable SDL_AUDIODRIVER to
alsa.

    # export SDL_AUDIODRIVER=alsa

> Low sound workaround

If you are facing low sound even after maxing out your
speakers/headphones, you can give the softvol plugin a try. Add the
following to /etc/asound.conf.

    pcm.!default {
          type plug
          slave.pcm "softvol"
      }

    pcm.softvol {
        type softvol
        slave {
            pcm "dmix"
        }
        control {
            name "Pre-Amp"
            card 0
        }
        min_dB -5.0
        max_dB 20.0
        resolution 6
    }

Note:You will probably have to restart the computer, as restarting the
alsa daemon did not load the new configuration for me. Also, if the
configuration does not work even after restarting, try changing plug
with hw in the above configuration.

After the changes are loaded successfully, you will see a Pre-Amp
section in alsamixer. You can adjust the levels there.

> Note:

-   Setting a high value for Pre-Amp can cause sound distortion, so
    adjust it according to the level that suits you.
-   Some audio codecs may need to have settings adjusted in the HDA
    Analyzer (see above) in order to achieve proper volume without
    distortion. Checking the HP option under widget control in the
    Playback Switch (Node[0x14] PIN in the ALC892 codec, for instance)
    can sometimes improve audio quality and volume significantly.

> Popping sound after resuming from suspension

You might hear a popping sound after resuming the computer from
suspension. This can be fixed by editing /etc/pm/sleep.d/90alsa and
removing the line that says aplay -d 1 /dev/zero

> Mute after reboot

After reboot, sound setting by alsamixer can not restore. Maybe you can
restore by command : sudo alsactl restore. Please check the Auto-Mute
toggle status in alsamixer : set Enabled to Disabled.

> Volume too low

The first thing to try is run alsamixer and try to increase the value of
the sliders, possibly unmuting channels if necessary. Note that if you
have many sliders, you may have to scroll to the right to see any
missing sliders.

If all the sliders are maxed out, and the volume is still too low, you
can try running the script at
http://www.alsa-project.org/hda-analyzer.py to reset your codec
settings:

    $ wget http://www.alsa-project.org/hda-analyzer.py
    $ sudo python2 hda-analyzer.py

(Note that the script assumes "python" refers to Python 2, but on a
typical ArchLinux installation, "python" refers to Python 3. Therefore,
you may need to edit the last line of the script from
os.system("python %s" % TMPDIR + '/' + FILES[0] + ' ' + ' '.join(sys.argv[1:]))
to
os.system("python2 %s" % TMPDIR + '/' + FILES[0] + ' ' + ' '.join(sys.argv[1:])).

Close the analyzer, and when prompted as to whether you want to reset
the codecs, say "yes".

If the volume is *still* too low, run alsamixer again: resetting the
codecs may have caused new sliders to become enabled, and some of them
may be set to a low value.

> alsamixer F3 and F4 key issue

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: This issue dates 
                           back to 2005 and is      
                           reported to not happen   
                           anymore in talk page.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

In urxvt, the alsamixer quits when F2/F3/F4 key is pressed. F3/F4 is
used to switch to playback/capture view. But in Xterm, F3/F4 could work
normally and switch to playback/capture view. This abnormal behavior
maybe caused by different escape codes sent by different term, see
http://aperiodic.net/phil/archives/Geekery/term-function-keys.html for
detail.

> Removing old ALSA state file (asound.state)

The alsa-utils package provides alsa-store.service which automatically
stores the current ALSA state to /var/lib/alsa/asound.state upon system
shutdown. This can be problematic for users who are trying to reset
their current ALSA state as the asound.state file will be recreated with
the current state upon every shutdown (e.g., attempting to remove
user-defined channels from the mixer). The alsa-store.service service
may be temporarily disabled by creating the following empty file:

    # mkdir -p /etc/alsa
    # touch /etc/alsa/state-daemon.conf

The presence of state-daemon.conf prevents alsa-store.service from
saving asound.state during shutdown. After disabling this service, the
asound.state file may be removed as such:

    # rm /var/lib/alsa/asound.state

After rebooting, the previous ALSA state should be lost and the current
state should be reset to defaults. Re-enable alsa-store.service by
deleting the condition file we created:

    # rm /etc/alsa/state-daemon.conf

On the next shutdown, the asound.state file should be recreated with
ALSA defaults. The file may also be generated immediately using:

    # alsactl store

> HDMI 5.1 sound goes to wrong speakers

If your HDMI 5.1 output sends the sound to the wrong speakers, you can
redirect it to the correct ones using a remap. Add the following to
/etc/asound.conf.

    pcm.!hdmi-remap {
      type asym
      playback.pcm {
        type plug
        slave.pcm "remap-surround51"
      }
    }
     
    pcm.!remap-surround51 {
      type route
      slave.pcm "hw:0,3"
      ttable {
        0.0= 1
        1.1= 1
        2.4= 1
        3.5= 1
        4.2= 1
        5.3= 1
      }
    }

See also
--------

-   Advanced ALSA module configuration
-   Unofficial ALSA wiki
-   HOWTO: compile driver from svn
-   A close look at ALSA: ALSA concept introduction

Retrieved from
"https://wiki.archlinux.org/index.php?title=Advanced_Linux_Sound_Architecture&oldid=304086"

Categories:

-   Sound
-   Audio/Video

-   This page was last modified on 12 March 2014, at 03:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
