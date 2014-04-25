Terratec Aureon 7.1
===================

The Terratec Aureon 7.1 USB is an affordable external sound card which
supports optical and digital output through S/PDIF with full 5.1/7.1
surround sound. To use this card, install ALSA (which has support for
this sound card). To configure the card for usage, follow these steps:

Contents
--------

-   1 Set the card as the default device
-   2 Enable volume control
-   3 Hotkeys
-   4 Configure mplayer for surround sound (optional)
-   5 Tips

Set the card as the default device

If you have multiple sound cards, you need to set the Terratec card as a
default. Create the following file

    /etc/modprobe.d/alsa.conf

    options snd slots=snd_usb_audio

Rebooting or restarting the ALSA (sudo /etc/rd.d/alsa restart) may be
required for the changes to take effect.

Enable volume control

This card doesn't have hardware volume control, so you need to create
software Master control. Create the following file in your home folder

    .asoundrc

    pcm.softvol {
            type softvol
            slave {
                    pcm "dmix"
            }
            control {
                    name "Master"
                    card 0
            }
    }

    pcm.!default {
            type plug
            slave.pcm "softvol"
    }

Again, restart alsa, then open a music player, play a file and close the
player. Then check alsamixer, as you should have a Master volume
control.

Hotkeys

The sound card has external hotkeys for volume change and mute. You can
capture the button presses by installing Xbindkeys and using the
following config:

    .xbindkeysrc

    #Volume up
    "amixer set 'Master' 5+"
        m:0x0 + c:123
        XF86AudioRaiseVolume

    #Volume down
    "amixer set 'Master' 5-"
        m:0x0 + c:122
        XF86AudioLowerVolume

    #Mute
    "/media/disk/programs/mute.sh"
        m:0x0 + c:121
        XF86AudioMute

As you can see, alsamixer doesn't handle mute for this mixer, which is
why you can use a simple mute.sh script, which stores the volume level
in volume.txt. Be sure to change the file path to mute.sh accordingly.

    #!/bin/bash
    var=$(amixer get Master | grep "Front Left:")
    var=$(echo "$var" | sed -ne 's/^[^[]*\[\([^]]*\)\].*/\1/p')
    if [ $var == "0%" ]
    then
            volume=$(cat volume.txt)
            amixer set 'Master' $volume
    else
            rm volume.txt
            echo $var > volume.txt
            amixer set 'Master' 0%
    fi

Configure mplayer for surround sound (optional)

Add the following codec settings for mplayer

    .mplayer/config

    ac=hwac3,hwdts,a52,dts,
    ao=alsa

I recommend using XBMC for media playback, as most receivers do no
support the AAC codec. XBMC will re-encode AAC to a common codec (AC3
probably) in realtime, so you can watch most surround sound media files.
XBMC has a self-explanatory configuration system using a GUI.

Tips

To change volume using amixer and hotkeys, use the following command
(for example): amixer set 'Master' 5+.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Terratec_Aureon_7.1&oldid=262593"

Category:

-   Sound

-   This page was last modified on 13 June 2013, at 07:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
