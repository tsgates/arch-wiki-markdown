Asus EEE PC 1025c
=================

Caution:I am learning linux with arch and my Eee PC. So my solutions may
be not the best.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 HDMI                                                               |
|     -   1.1 Video                                                        |
|     -   1.2 Audio                                                        |
|         -   1.2.1 Global                                                 |
|         -   1.2.2 User specific                                          |
|         -   1.2.3 Dynamic                                                |
|                                                                          |
| -   2 Screen Brightness                                                  |
|     -   2.1 acpi                                                         |
|         -   2.1.1 FN Keys                                                |
|         -   2.1.2 AC plug / unplug                                       |
+--------------------------------------------------------------------------+

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
"https://wiki.archlinux.org/index.php?title=Asus_EEE_PC_1025c&oldid=240738"

Category:

-   ASUS
