HP Mini 5101
============

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Video                                                              |
| -   2 Audio                                                              |
| -   3 Network                                                            |
|     -   3.1 Wireless Driver (Broadcom)                                   |
|         -   3.1.1 Driver Overview                                        |
|                                                                          |
| -   4 Bluetooth                                                          |
| -   5 Touchpad                                                           |
| -   6 Webcam                                                             |
| -   7 ACPI                                                               |
|     -   7.1 Suspend on Lid                                               |
|     -   7.2 Power Button                                                 |
|     -   7.3 Hotkeys                                                      |
|         -   7.3.1 Display toggle                                         |
|         -   7.3.2 Mute, browser button, volume down, etc...              |
|                                                                          |
| -   8 Hard disk shock protection                                         |
+--------------------------------------------------------------------------+

Video
-----

Install xf86-video-intel or xf86-video-intel-newest. Make sure to
configure KMS correctly.

Audio
-----

Typical Intel HD Audio. Just follow ALSA.

Make sure you have the latest version of alsa-utils, alsa-lib and
alsa-firmware.

Network
-------

Swapping eth0/eth1 can confuse Wicd, assigning static names helps.

> Wireless Driver (Broadcom)

See Broadcom_wireless for driver setup.

It may be necessary to load the driver (wl as an axample here) manually:

    /etc/rc.conf 

    MODULES=(... wl ...)

Problem with reconnecting after suspending might be solved by:

    /etc/pm/config.d/01-modules 

    SUSPEND_MODULES="wl"

Driver Overview

1.  brcmsmac: Works best but the red/blue led isn't working.
2.  broadcom-wl: Needs to be compiled newly from the AUR
    (broadcom-wifi-builder or broadcom-wl) after each kernel upgrade.
    LED works but reconnecting problem after suspending.
3.  b43: Alternatively your network chip may be supported by b43 (kernel
    > 2.6.32).

Bluetooth
---------

See: Bluetooth

Touchpad
--------

Works out of the box.

Webcam
------

Works out of the box.

ACPI
----

> Suspend on Lid

This here works quite fine: Suspend to RAM#Automatic Suspend, the Hard
Way

It might be necessary to use "/etc/acpi/events/lm_lid" instead of
"/etc/acpi/events/lid". (laptop-mode?)

Just change the "LID" to it's actual value. For me it was C1D0.

    /etc/acpi/actions/lid_handler.sh

    if grep closed /proc/acpi/button/lid/C1D0/state >/dev/null ; then 

> Power Button

Shutting_system_down_by_pressing_the_power_button

> Hotkeys

Display toggle

ACPI_hotkeys

    # acpi_listen
    (Press fn+f2)
    video C088 00000080 00000000

So we have to edit

    /etc/acpi/handler.sh

like this

    /etc/acpi/handler.sh 

    case "$1" in
        .
        .
        .
        video)
            arandr #or path to your shell script for switching display mode
            ;;
        .
        .
        .
    esac

Mute, browser button, volume down, etc...

Extra_Keyboard_Keys

Hard disk shock protection
--------------------------

Install hpfall from AUR and add it to rc.conf:

    /etc/rc.conf 

    DAEMONS=(... hpfall ...)

See also Shock protection for HP/Compaq laptops.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Mini_5101&oldid=238818"

Category:

-   HP
