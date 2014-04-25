Asus EEE PC 1025c
=================

Warning:I am learning linux with arch and my Eee PC. So my solutions may
be not the best.

Contents
--------

-   1 Bootloader
-   2 Audio
    -   2.1 Mono Issues
        -   2.1.1 Mono on PulseAudio
-   3 HDMI
    -   3.1 Video
    -   3.2 Audio
        -   3.2.1 Global
        -   3.2.2 User specific
        -   3.2.3 Dynamic
-   4 Screen Brightness
    -   4.1 acpi
        -   4.1.1 FN Keys
        -   4.1.2 AC plug / unplug

Bootloader
----------

You have to use an i686 boot ISO even though the Intel ARK says that the
computer's CPU supports Intel 64. If you're using the dual-architecture
ISO (which is downloaded by default), then the ISO will auto-detect it
as i686.

The BIOS doesn't seem to support EFI boot on an ArchISO USB stick, even
though it detects it as a UEFI bootable medium. Install with a BIOS
bootloader unless you know what you're doing. If you are able to boot in
UEFI mode, then please add a tutorial.

Audio
-----

> Mono Issues

Maybe you want hear some MP3 files in stereo format and you'll noted
missed voices or instruments. The solution is change some settings to
play all sounds in mono format. So only using the Alsa you have to
create a file called .asoundrc (if you have this file, so make a backup
for safety) and put this content below:

    ~/.asoundrc

    pcm.card0 {
      type hw
      card 0
    }

    ctl.card0 {
      type hw
      card 0
    }

    pcm.monocard {
      slave.pcm card0
      slave.channels 2
    #  type plug
      type route
      ttable {
       # Copy both input channels to output channel 0 (Left). 
        0.0 1
        1.0 1
       # Send nothing to output channel 1 (Right). 
        0.1 0
        1.1 0
      }
    }

    ctl.monocard {
      type hw
      card 0
    } 

    pcm.!default monocard

Save on your home directory and restart Alsa.

Mono on PulseAudio

To set mono in a PulseAudio system. Run on terminal:

     $ pacmd list-sinks | grep name | head -n1 

To get the master device name. The output of command will look like
this:

     name: <alsa_output.pci-0000_00_1b.0.analog-stereo>

Put device name (in my case alsa_output.pci-0000_00_1b.0.analog-stereo)
in field 'master' of the command below:

     $ pacmd load-module module-remap-sink sink_name=mono master=alsa_output.pci-0000_00_1b.0.analog-stereo channels=2 channel_map=front-right,mono

So this command just will work if PulseAudio is already started.

To make this permanent, (as root) put the argument of pacmd command on
last line of file /etc/pulse/default.pa:

     # echo "load-module module-remap-sink sink_name=mono master=alsa_output.pci-0000_00_1b.0.analog-stereo channels=2 channel_map=front-right,mono" >> /etc/pulse/default.pa

Warning: Be sure, of don't run an audio application with this
configuration above (Maybe mpg123 to start a sound theme in a session of
Xfce) before PulseAudio starts, in a session. It's probably the
PulseAudio will not working.

And after, reboot your machine and every session startup, this will
work.

HDMI
----

> Video

You have to change the video driver. If the HDMI cable is plugged in on
boot it is enabled automatically. If it is plugged in after boot you can
use xrandr to enable the second monitor:

    # xrandr --output DVI-0 --auto

> Audio

You need to know the number of your sound card and the the number of
HDMI device:

    aplay -l

     **** Liste der Hardware-Geräte (PLAYBACK) ****
    Karte 0: Intel [HDA Intel], Gerät 0: ALC269VB Analog [ALC269VB Analog]
      Sub-Geräte: 1/1
      Sub-Gerät #0: subdevice #0
    Karte 0: Intel [HDA Intel], Gerät 3: HDMI 0 [HDMI 0]
      Sub-Geräte: 1/1
      Sub-Gerät #0: subdevice #0

Global

In /usr/shared/alsa/alsa.conf search the lines

    default.pcm.card 0
    default.pcm.device 0

If you change the numbers to your card and device (in my case card is 0
and device is 3) and reboot the audio output switches to HDMI.

User specific

do this and reboot

Dynamic

The audio device can also be configured with /etc/asound.conf So you can
create a script that links asound.conf to a configuration depending on
the hdmi cable plugged in or not: (for some reason my HDMI device is
listed as DVI)

    hdmi_switched.sh

    #! /bin/bash
    hdmi_status="$(cat /sys/class/drm/card0-DVI-D-1/status)"
    ln -f "/etc/alsa/hdmi_$hdmi_status" /etc/alsa/asound.conf
    alsactl restore

Configuration files:

    hdmi_connected

    pcm.!default {
          type hw
          card 0
          device 3 
    }

    hdmi_disconnected

    pcm.!default {
          type hw
          card 0
          device 0 
    }

Create a symbolic link to /etc/asound.conf

    ln -s /etc/alsa/asound.conf /etc/asound.conf

If the user is allowed to run the hdmi_switch.sh script and is also
allowed to change files in /etc/alsa folder you can bind that script to
a key :D If you also want to change to monitor read this.

Screen Brightness
-----------------

> acpi

Setting brightness in /sys/class/backlight/acpi_video0/ with the scripts
for acpid change the values of the files brightness and
actual_brightness but do not have any effect on current screen
brightness.

Set the following as kernel parameters in your bootloader

    acpi_osi=Linux acpi_backlight=vendor

To make this permant see here

FN Keys

Now there is a folder eeepc-wmi in /sys/class/backlight and the scripts
need to be updated

    /etc/acpi/actions/bl_up.sh

      #!/bin/sh
      bl_device=/sys/class/backlight/eeepc-wmi/brightness
      echo $(($(cat $bl_device)+1)) >$bl_device

    /etc/acpi/actions/bl_down.sh

      #!/bin/sh
      bl_device=/sys/class/backlight/eeepc-wmi/brightness
      echo $(($(cat $bl_device)-1)) >$bl_device

The scripts change the screen brightness everytime I run them.
Unfortunately the acpi events for brightnessup and brightnessdown are
not available anymore although the brightnessup key sets brightness to
maximum and the brightnessdown key sets the brightness to
max_brightness-1 :( (do not now where this happens) --> this may help

When using the Enlightenment 17 window manager, the brightness keys will
work without any additional configuration and the backlight can be
adjusted using the built-in backlight widget.

AC plug / unplug

    /etc/acpi/handler.sh

     ..
     ac_adapter)
            case "$2" in
                ACPI0003:00)
                    case "$4" in
                        00000000)
                            logger 'AC unpluged'
                            echo $(($(cat /sys/class/backlight/eeepc-wmi/max_brightness)/2)) > /sys/class/backlight/eeepc-wmi/brightness
    			;;
                        00000001)
                            logger 'AC pluged'
                            echo $(($(cat /sys/class/backlight/eeepc-wmi/max_brightness)-1)) > /sys/class/backlight/eeepc-wmi/brightness
    			;;
                    esac
                    ;;
                *)
                    logger "AC Adapter ACPI action undefined: $2"
    		;;
            esac
            ;;
     ..

Retrieved from
"https://wiki.archlinux.org/index.php?title=Asus_EEE_PC_1025c&oldid=291983"

Category:

-   ASUS

-   This page was last modified on 8 January 2014, at 02:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
