Advanced Linux Sound Architecture
=================================

The Advanced Linux Sound Architecture (ALSA) is a Linux kernel component
which replaced the original Open Sound System (OSSv3) for providing
device drivers for sound cards. Besides the sound device drivers, ALSA
also bundles a user space library for application developers who want to
use driver features with a higher level API than direct interaction with
the kernel drivers.

Note:For an alternative sound environment, see the Open Sound System
page.

Summary

Using, configuring and troubleshooting ALSA.

Related

Sound system

Disable PC Speaker Beep

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 User-space utilities                                         |
|                                                                          |
| -   2 Unmuting the channels                                              |
| -   3 Configuration                                                      |
|     -   3.1 No sound in virtualbox                                       |
|     -   3.2 Set the default sound card                                   |
|     -   3.3 Making sure the sound modules are loaded                     |
|     -   3.4 Getting SPDIF Output                                         |
|     -   3.5 System-Wide Equalizer                                        |
|         -   3.5.1 Using AlsaEqual (provides UI)                          |
|             -   3.5.1.1 Managing AlsaEqual States                        |
|                                                                          |
|         -   3.5.2 Using mbeq                                             |
|                                                                          |
| -   4 High quality resampling                                            |
| -   5 Upmixing/Downmixing                                                |
|     -   5.1 Upmixing                                                     |
|     -   5.2 Downmixing                                                   |
|                                                                          |
| -   6 Mixing                                                             |
|     -   6.1 Software mixing (dmix)                                       |
|     -   6.2 Hardware mixing                                              |
|         -   6.2.1 Support                                                |
|         -   6.2.2 Fixes                                                  |
|                                                                          |
| -   7 Troubleshooting                                                    |
|     -   7.1 Sound Skipping While Using Dynamic Frequency Scaling         |
|     -   7.2 Problems with Availability to Only One User at a Time        |
|     -   7.3 Simultaneous Playback Problems                               |
|     -   7.4 Random Lack of Sound on Startup                              |
|         -   7.4.1 Timidity                                               |
|                                                                          |
|     -   7.5 Specific Program Problems                                    |
|     -   7.6 Model Settings                                               |
|     -   7.7 Conflicting PC Speaker                                       |
|     -   7.8 No Microphone Input                                          |
|     -   7.9 Setting the default Microphone/Capture Device                |
|     -   7.10 Internal Microphone not working                             |
|     -   7.11 No Sound with Onboard Intel Sound Card                      |
|     -   7.12 No Headphone Sound with Onboard Intel Sound Card            |
|     -   7.13 No sound when S/PDIF video card is installed                |
|     -   7.14 Poor sound quality or clipping                              |
|     -   7.15 Pops When Starting and Stopping Playback                    |
|     -   7.16 S/PDIF Output Does Not Work                                 |
|     -   7.17 HDMI Output Does Not Work                                   |
|     -   7.18 HDMI Multi-channel PCM output does not work (Intel)         |
|     -   7.19 HP TX2500                                                   |
|     -   7.20 Skipping Sound When Playing MP3                             |
|     -   7.21 Using a USB Headset and External USB Sound Cards            |
|         -   7.21.1 Crackling sound with USB devices                      |
|         -   7.21.2 Hot-plugging a USB Sound Card                         |
|                                                                          |
|     -   7.22 Error 'Unknown hardware' Appears After a Kernel Update      |
|     -   7.23 HDA Analyzer                                                |
|     -   7.24 ALSA with SDL                                               |
|     -   7.25 Low Sound Workaround                                        |
|     -   7.26 Popping sound after resuming from suspension                |
|                                                                          |
| -   8 Example configurations                                             |
| -   9 See also                                                           |
+--------------------------------------------------------------------------+

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

From official repositories:

-   Install the alsa-utils package which contains the alsamixer
    user-space tool, which allows for configuration of the sound device
    from the console or terminal.
-   Install the alsa-oss package if you want OSS applications to work
    with dmix (software mixing).

Note:Since udev >= 171, the OSS emulation modules (snd_seq_oss,
snd_pcm_oss, snd_mixer_oss) are not automatically loaded by default.

-   Install the alsa-plugins package if you want high quality
    resampling, upmixing/downmixing and other advanced features.

Unmuting the channels
---------------------

The current version of ALSA installs with all channels muted by default.
You will need to unmute the channels manually.

It is easiest to use alsamixer ncurses UI to accomplish this:

    $ alsamixer

Alternatively, use amixer from the command-line:

    $ amixer sset Master unmute

m In alsamixer, the MM label below a channel indicates that the channel
is muted, and 00 indicates that it is open.

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

Note:

-   Some cards need to have digital output muted/turned off in order to
    hear analog sound. For the Soundblaster Audigy LS mute the IEC958
    channel.
-   Some machines, (like the Thinkpad T61), have a Speaker channel which
    must be unmuted and adjusted as well.
-   Some machines, (like Dell E6400) may also require the Front and
    Headphone channels to be unmuted and adjusted.

Next, test to see if sound works:

    $ speaker-test -c 2

Change -c to fit your speaker setup. Use -c 8 for 7.1, for instance:

    $ speaker-test -c 8

If it does not work, proceed to #Configuration and then #Troubleshooting
to solve your problems.

The alsa-utils package includes alsa-restore.service and
alsa-store.service, which are preconfigured to run at boot and shutdown
respectively.

Configuration
-------------

> No sound in virtualbox

If you experience problems with virtualbox, the following command might
be helpful:

    $ alsactl init


    Found hardware: "ICH" "SigmaTel STAC9700,83,84" "AC97a:83847600" "0x8086" "0x0000"
    Hardware is initialized using a generic method

You might need to activate the ALSA output in your audio software as
well.

> Set the default sound card

If your sound card order changes on boot, you can specify their order in
any file ending with .conf in /etc/modprobe.d
(/etc/modprobe.d/alsa-base.conf is suggested). For example, if you want
your mia sound card to be #0:

    /etc/modprobe.d/alsa-base.conf

    options snd slots=snd_mia,snd_hda_intel
    options snd_mia index=0
    options snd_hda_intel index=1

lsmod | grep snd to get a devices list

snd_mia and snd_hda_intel are the modules used by the respective cards.
This configuration assumes you have one mia sound card and one card
using snd_hda_intel (e.g. onboard).

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
    # Keep snd-pcsp from being loaded as first soundcard
    options snd-pcsp index=-2
    # Keep snd-usb-audio from beeing loaded as first soundcard
    options snd-usb-audio index=-2

These changes require a system reboot.

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: These            
                           instructions may not     
                           work. (Discuss)          
  ------------------------ ------------------------ ------------------------

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
following options with the corresponding card and device id.

    defaults.pcm.card 2
    defaults.pcm.device 0
    defaults.ctl.card 2

The 'pcm' options affect which card and device will be used for audio
playback while the 'ctl' option affects which card is used by control
utilities like alsamixer .

The changes should take effect as soon as you (re-)start an application
(mplayer etc.).

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

> Getting SPDIF Output

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

Alternative way to enable SPDIF output automatically on login (tested on
SoundBlaster Audigy):

-   add following lines to /etc/rc.local:

     # Use COAX-digital output
     amixer set 'IEC958 Optical' 100 unmute
     amixer set 'Audigy Analog/Digital Output Jack' on

You can see the name of your card's digital output with:

     $ amixer scontrols

> System-Wide Equalizer

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

Managing AlsaEqual States

Install alsaequal-mgr from Xyne's repos or the AUR.

Configure the equalizer as usual with

    $alsamixer -D equal

When you are satisfied with the state, you may give it a name ("foo" in
this example) and save it:

    $alsaequal-mgr save foo

The state "foo" can then be restored at a later time with

    $alsaequal-mgr load foo

You can thus create different equalizer states for games, movies, music
genres, VoIP apps, etc. and reload them as necessary.

See the project page and the help message for more options.

Using mbeq

Note: This method requires the use of a ladspa plugin which might use
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

or

    ~/.asoundrc

    defaults.pcm.rate_converter "samplerate_best"

samplerate_best offers the best sound quality, but you need a decent CPU
to be able to use it as it requires a lot of CPU cycles for real-time
resampling. There are other algorithms available (samplerate, etc.) but
they may not provide much of an improvement over the default resampler.

Warning:On some systems, enabling samplerate_best may cause a problem
where you get no sound from flashplayer.

Upmixing/Downmixing
-------------------

> Upmixing

In order for stereo sources like music to be able to saturate a 5.1 or
7.1 sound system, you need to use upmixing. In darker days this used to
be tricky and error prone but nowadays plugins exist to easily take care
of this task. Thus, install alsa-plugins.

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
to watch a movie with 5.1 sound on a stereo system, you need to use the
vdownmix plugin that alsa provides in the same package.

Again, in your configuration file, add this:

    pcm.!surround51 {
        type vdownmix
        slave.pcm "default"
    }
    pcm.!surround40 {
        type vdownmix
        slave.pcm "default"
    }

Mixing
------

> Software mixing (dmix)

Note:For ALSA 1.0.9rc2 and higher on analog sound outputs you do not
need to setup dmix. Dmix is enabled as default for soundcards which do
not support hardware mixing.

If that does not work however, it is a matter of simply creating a
.asoundrc file in your home folder with the following contents.

    pcm.dsp {
        type plug
        slave.pcm "dmix"
    }

This should enable software mixing and allows more than one application
to make use of the soundcard.

For a digital sound output such as S/PDIF, the ALSA package still does
not enable dmix by default. Thus, the dmix configuration above can be
used to enable dmix for S/PDIF devices.

See #Troubleshooting for common problems and solutions.

> Hardware mixing

Support

If you have an audio chipset that supports mixing in hardware, then no
configuration is necessary. Almost every onboard audio chipset does not
support hardware mixing, and requires mixing to be done in software (see
above). Many sound cards do support hardware mixing, and the ones best
supported on Linux are listed below:

-   Creative SoundBlaster Live! (5.1 model)
-   Creative SoundBlaster Audigy (some models)
-   Creative SoundBlaster Audidy 2 (ZS models)
-   Creative SoundBlaster Audigy 4 (Pro models)

Note:The low end variants of above cards, (Audigy SE, Audigy 2 NX,
SoundBlaster Live! 24bit and SoundBlaster Live! 7.1) do not support
hardware mixing as they use other chips.

Note:The onboard VIA8237 chip supports 4-stream hardware mixing,
however, it does only 3 for some motherboards (the 4th makes no sound)
or is just broken. Even if it works, the quality is not good compared to
other solutions.

Fixes

If you are using 64-bit Arch and the Intel Corporation 82801I (ICH9
Family) HD Audio Controller (rev 02), you can get sound working for
Enemy Territory with the following:

    echo "et.x86 0 0 direct" > /proc/asound/card0/pcm0p/oss
    echo "et.x86 0 0 disable" > /proc/asound/card0/pcm0c/oss

Troubleshooting
---------------

> Sound Skipping While Using Dynamic Frequency Scaling

Some combinations of ALSA drivers and chipsets may cause audio from all
sources to skip when used in combination with a dynamic frequency
scaling governor such as ondemand or conservative. Currently, the
solution is to switch back to the performance governor.

Refer to the CPU Frequency Scaling for more information.

> Problems with Availability to Only One User at a Time

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

> Simultaneous Playback Problems

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

> Random Lack of Sound on Startup

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

Timidity can be the cause of missing audio. Try running

     systemctl | grep timidity

If the result looks like:

     timidity.service            loaded failed failed    TiMidity++ Daemon

then try sudo killall -9 timidity. If this solves the issue, then you
should disable the timidity daemon to be started at boot.

> Specific Program Problems

For other programs who insist on their own audio setup, eg, XMMS or
Mplayer, you would need to set their specific options.

For mplayer, open up ~/.mplayer/config (or /etc/mplayer/mplayer.conf for
global setting) and add the following line:

    ao=alsa

For XMMS/Beep Media Player, go into their options and make sure the
sound driver is set to Alsa, not oss.

To do this in XMMS:

-   Open XMMS
    -   Options -> preferences.
    -   Choose the Alsa output plugin.

For applications which do not provide a ALSA output, you can use aoss
from the alsa-oss package. To use aoss, when you run the program, prefix
it with aoss, eg:

    aoss realplay

pcm.!default{ ... } doesnt work for me anymore. but this does:

     pcm.default pcm.dmixer

> Model Settings

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

> Conflicting PC Speaker

If you are sure nothing is muted, that your drivers are installed
correctly, and that your volume is right, but you still do not hear
anything, then try adding the following line to
/etc/modprobe.d/modprobe.conf:

    options snd-NAME-OF-MODULE ac97_quirk=0

The above fix has been observed to work with via82xx

    options snd-NAME-OF-MODULE ac97_quirk=1

The above fix has been reported to work with snd_intel8x0

> No Microphone Input

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

     arecord -d 5 test-mic.wav
     aplay test-mic.wav

If all fails, you may want to eliminate hardware failure by testing the
microphone with a different device.

For at least some computers, muting a microphone (MM) simply means its
input does not go immediately to the speakers. It still receives input.

Many Dell laptops need "-dmic" to be appended to the model name in
/etc/modprobe.d/modprobe.conf:

     options snd-hda-intel model=dell-m6-dmic

Some programs use try to use OSS as the main input software. Add the
following lines to /etc/modprobe.d/modprobe.conf to prevent OSS modules
from being loaded:

Note:The OSS modules are no longer autoloaded anyway.

    blacklist snd_pcm_oss
    blacklist snd_mixer_oss
    blacklist snd_seq_oss

See also:

-   http://www.alsa-project.org/main/index.php/SoundcardTesting
-   http://alsa.opensrc.org/Record_from_mic

> Setting the default Microphone/Capture Device

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

> Internal Microphone not working

First make sure all the volume levels are up under recording in
alsamixer. In my case adding the following option to /etc/sound.conf and
reloading the snd-* module produced a new volume setting called Capture
which was capturing for the internal mic. For eg, for snd-hda-intel add

     options snd-hda-intel enable_msi=1

Then reload the module (as below), up the recording volume of Capture
and then test.

    # rmmod snd-hda-intel && modprobe snd-hda-intel

> No Sound with Onboard Intel Sound Card

There may be a problem with two conflicting modules loaded, namely
snd_intel8x0 and snd_intel8x0m. In this case, blacklist snd_intel8x0m:

    /etc/modprobe.d/modprobe.conf

    blacklist snd_intel8x0m

Muting the "External Amplifier" in alsamixer or amixer may also help.
See the ALSA wiki.

Unmuting the "Mix" setting in the mixer might help, also.

> No Headphone Sound with Onboard Intel Sound Card

With Intel Corporation 82801 I (ICH9 Family) HD Audio Controller on
laptop, you may need to add this line to modprobe or sound.conf:

    options snd-hda-intel model=$model

Where $model is any one of the following (in order of possibility to
work, but not merit):

-   dell-vostro
-   olpc-xo-1_5
-   laptop
-   dell-m6
-   laptop-hpsense

Note: It may be necessary to put this "options" line below (after) any
"alias" lines about your card.

You can see all the available models in the kernel documentation. For
example here, but check that it is the correct version of that document
for your kernel version.

A list of available models is also available here. To know your chip
name type the following command (with * being corrected to match your
files). Note that some chips could have been renamed and do not directly
match the available ones in the file.

    cat /proc/asound/card*/codec* | grep Codec

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

If both devices use the same module, it might be possible to disable one
of them in the BIOS.

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

> Pops When Starting and Stopping Playback

Some modules (e.g. snd_ac97_codec and snd_hda_intel) can power off your
sound card when not in use. This can make an audible noise (like a
crack/pop/scratch) when turning on/off your sound card. Sometimes even
when move the slider volume, or open and close windows (KDE4). If you
find this annoying try modinfo snd_MY_MODULE, and look for a module
option that adjusts or disables this feature.

Example: to disable the power saving mode and solve cracking sound
trough speakers problem, using snd_hda_intel add in
/etc/modprobe.d/modprobe.conf

    options snd_hda_intel power_save=0

or

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

> S/PDIF Output Does Not Work

If the optical/coaxial digital output of your motherboard/sound card is
not working or stopped working, and have already enabled and unmuted it
in alsamixer, try running

    # iecset audio on

as root.

You can also put this command in rc.local as it sometimes it may stop
working after a reboot.

> HDMI Output Does Not Work

If the HDMI output of your motherboard/sound card is not working or
stopped working, and have already enabled and unmuted it in alsamixer,
try the following.

Query for Playback Devices:

     $ aplay -l
     **** List of PLAYBACK Hardware Devices ****
     card 0: NVidia [HDA NVidia], device 0: ALC1200 Analog [ALC1200 Analog]
       Subdevices: 1/1
       Subdevice #0: subdevice #0
     card 0: NVidia [HDA NVidia], device 1: ALC1200 Digital [ALC1200 Digital]
       Subdevices: 1/1
       Subdevice #0: subdevice #0
     card 0: NVidia [HDA NVidia], device 3: NVIDIA HDMI [NVIDIA HDMI]
       Subdevices: 0/1
       Subdevice #0: subdevice #0

Now that we have the info for the HDMI device, try a test, In the
example below, 0 is the card number and 3 is the device number.

     $ aplay -D plughw:0,3 /usr/share/sounds/alsa/Front_Center.wav

If aplay does not output any errors, but still no sound is heared,
"reboot" the receiver, monitor or tv set. Since the HDMI interface
executes a handshake on connection, it might have noticed before that
there was no audio stream embedded, and disabled audio decoding. In
particular, if you are using a standalone window manager (don’t know
about Gnome or KDE), you may need to have some sound playing while
plugging in the HDMI cable.

Note:If you are using an ATI card and linux 3.0, check your kernel/grub
settings, you most likely need to use the 'radeon.audio=1' boot
parameter, or alternatively set up the option in your modprobe
configuration files. It's important to note that before trying, is to
check the Radeon Feature Matrix to see if it's actually supported. At
the moment this is written (march 29th, 2013), some chipsets of the S.
Islands (namely HD7750 through HD7970) doesn't (still) support HDMI
Audio.

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

> HDMI Multi-channel PCM output does not work (Intel)

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

> Skipping Sound When Playing MP3

If you have sound skipping when playing MP3 files and you have more then
2 speakers attached to your computer (i.e. > 2 speaker system), run
alsamixer and disable the channels for the speakers that you DO NOT have
(i.e. do not enable the sound for the center speaker if you do not have
a center speaker.

> Using a USB Headset and External USB Sound Cards

If you are using a USB headset with ALSA you can try using asoundconf
(currently only available from the AUR) to set the headset as the
primary sound output. Before running make sure you have usb audio module
enabled (modprobe snd-usb-audio).

    # asoundconf is-active
    # asoundconf list
    # asoundconf set-default-card <chosen soundcard>

Crackling sound with USB devices

If you experience crackling sound on USB devices, you can try tuning the
snd-usb-audio for minimal latency.

Add this to your /etc/modprobe.d/modprobe.conf:

    options snd-usb-audio nrpacks=1

source:
http://alsa.opensrc.org/Usb-audio#Tuning_USB_devices_for_minimal_latencies

Hot-plugging a USB Sound Card

In order to automatically make a USB Sound Card the primary output
device, when the card is plugged in, you can use the following udev
rules (e.g. add the following two lines to
/etc/udev/rules.d/00-local.rules and reboot).

    KERNEL=="pcmC[D0-9cp]*", ACTION=="add", PROGRAM="/bin/sh -c 'K=%k; K=$${K#pcmC}; K=$${K%%D*}; echo defaults.ctl.card $$K > /etc/asound.conf; echo defaults.pcm.card $$K >>/etc/asound.conf'"
    KERNEL=="pcmC[D0-9cp]*", ACTION=="remove", PROGRAM="/bin/sh -c 'echo defaults.ctl.card 0 > /etc/asound.conf; echo defaults.pcm.card 0 >>/etc/asound.conf'"

> Error 'Unknown hardware' Appears After a Kernel Update

The following messages may be displayed during the start-up ALSA after
the kernel update:

    Unknown hardware "foo" "bar" ...
    Hardware is initialized using a guess method
    /usr/sbin/alsactl: set_control:nnnn:failed to obtain info for control #mm (No such file or directory)

or

    Found hardware: "HDA-Intel" "VIA VT1705" "HDA:11064397,18490397,00100000" "0x1849" "0x0397"
    Hardware is initialized using a generic method
    /usr/sbin/alsactl: set_control:1328: failed to obtain info for control #1 (No such file or directory)
    /usr/sbin/alsactl: set_control:1328: failed to obtain info for control #2 (No such file or directory)
    /usr/sbin/alsactl: set_control:1328: failed to obtain info for control #25 (No such file or directory)
    /usr/sbin/alsactl: set_control:1328: failed to obtain info for control #26 (No such file or directory)

Simply store ALSA mixer settings again (as root):

    # alsactl -f /var/lib/alsa/asound.state store

It may be necessary configure ALSA again with alsamixer

> HDA Analyzer

If the mappings to your audio pins(plugs) do not correspond but ALSA
works fine, you could try HDA Analyzer -- a pyGTK2 GUI for HD-audio
control can be found at the ALSA wiki. Try tweaking the Widget Control
section of the PIN nodes, to make microphones IN and headphone jacks
OUT. Referring to the Config Defaults heading is a good idea.

NOTE: the script is done by such way that it is incompatible with
python3 (which is now shipped with ArchLinux) but tries to use it. The
workaround is: open "run.py", find all occurences of "python" (2
occurences - one on the first line, and the second on the last line) and
replace them all by "python2".

NOTE2: the script requires root acces, but running it via su/sudo is
bogus. Run it via kdesu or gksu.

> ALSA with SDL

If you get no sound via SDL and ALSA cannot be chosen from the
application. Try setting the environmental variable SDL_AUDIODRIVER to
alsa.

    # export SDL_AUDIODRIVER=alsa

> Low Sound Workaround

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

Note: You will probably have to restart the computer, as restarting the
alsa daemon did not load the new configuration for me. Also, if the
configuration does not work even after restarting, try changing plug
with hw in the above configuration.

After the changes are loaded successfully, you will see a Pre-Amp
section in alsamixer. You can adjust the levels there.

Note:Setting a high value for Pre-Amp can cause sound distortion, so
adjust it according to the level that suits you.

> Popping sound after resuming from suspension

You might hear a popping sound after resuming the computer from
suspension. This can be fixed by editing /etc/pm/sleep.d/90alsa and
removing the line that says aplay -d 1 /dev/zero

Example configurations
----------------------

See Advanced Linux Sound Architecture/Example Configurations.

See also
--------

-   Advanced ALSA module configuration
-   Unofficial ALSA Wiki
-   HOWTO: Compile driver from svn

Retrieved from
"https://wiki.archlinux.org/index.php?title=Advanced_Linux_Sound_Architecture&oldid=255456"

Categories:

-   Sound
-   Audio/Video
