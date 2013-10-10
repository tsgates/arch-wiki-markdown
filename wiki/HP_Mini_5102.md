HP Mini 5102
============

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Contains         
                           old/deprecated           
                           information (Discuss)    
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Specifications                                                     |
| -   2 Hardware                                                           |
|     -   2.1 Kernel                                                       |
|     -   2.2 Video                                                        |
|     -   2.3 Webcam                                                       |
|     -   2.4 Audio                                                        |
|     -   2.5 Touchpad                                                     |
|     -   2.6 Wired Network                                                |
|         -   2.6.1 Wireless Driver                                        |
|                                                                          |
|     -   2.7 Built in WWAN or 3G modem                                    |
|     -   2.8 Bluetooth                                                    |
|     -   2.9 ACPI                                                         |
|         -   2.9.1 Suspend on Lid                                         |
|         -   2.9.2 Power Button                                           |
|         -   2.9.3 Hotkeys                                                |
|             -   2.9.3.1 Display toggle                                   |
|             -   2.9.3.2 Mute, browser button, volume down, etc...        |
+--------------------------------------------------------------------------+

Specifications
--------------

For full specifications see the HP Mini 5102 specifications page.

Device

HP Mini 5102

Processor

Intel Atom N450 Processor (1.66 GHz, 512 KB L2 cache, 667 MHz FSB)

Architecture

x86_64

Screen

10.1" (1024x600) OR

10.1" (1366x768)

RAM

Up to 2GB

HDD

160GB to 320GB 7200RPM hdd OR

80 GB Solid State Drive

Optical Drive

None

Graphics

Intel Graphics Media Accelerator HD (3150) (it's part of the
Atom/pineview CPU)

Ethernet

SysKonnect Yukon2 Gigabit Ethernet

Wireless

Broadcom 4353 802.11a/b/g/n

Hardware
--------

The HP Mini 5102 has a newer 'pinetrail' 64 bit Atom. ( Intel(R)
Atom(TM) CPU N450 'pinetrail' x86_64 )

Arch Linux boot media does not have the correct network module ( amongst
others) so I ended up using a SMC usb to ethernet adapter to get an
install done.

> Kernel

I used http://code.google.com/p/kernel-netbook/ and will assume from
here on in that you are using this kernel too.

I have submitted a patch so this kernel works in 64bit mode.

This patch and other notes of interest is currently in the forums.

Edit: works with generic kernel as well.(2.6.34 x86_64)

> Video

> tested

Install xf86-video-intel(tested with this one) or
xf86-video-intel-newest.

Make sure to configure KMS correctly.

Let hal take care of everything and have no /etc/X11/xorg.conf

Works fine, Xorg is running.

> Webcam

> tested

UDev loads the correct driver. Works just fine with skype. Not sure of
brands etc here but lsmod shows it is detected

     [lunix@munix kernel-netbook]$ lsmod | grep video
     Module                  Size  Used by
     uvcvideo               51293  0
     videodev               30480  1 uvcvideo
     v4l1_compat            11024  2 uvcvideo,videodev

> Audio

> tested

Typical Intel HD Audio. Just follow ALSA. Works.

Make sure you have the latest version of alsa-utils, alsa-lib and
alsa-firmware.

> Touchpad

Works out of the box with GPM

     GPM_ARGS="-m  /dev/input/mice -t imps2"

> Wired Network

    $ lspci -vnn | grep Ethernet
    43:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd. Device [11ab:4381] (rev 11)

This is a 'SysKonnect Yukon2' and works fine after installing the
'kernel-netbook' kernel mentioned above

Wireless Driver

    $ lspci -vnn | grep Broadcom
     01:00.0 Network controller [0280]: Broadcom Corporation Device [14e4:4353] (rev 01)

This is a Broadcom 4353 and works fine with the Broadcom-wl drivers.

This works after upgrading to 'kernel-netbook' mentioned above in the
kernel section.

By default the wireless interface is named eth1 and not wlan0 as some
may be used to.

A quick hack with udev should fix this.

EDIT: Mine came with BCM4312, just follow: Broadcom BCM4312

> Built in WWAN or 3G modem

not tested

This is an optional extra and uses a Qualcomm mobile internet device

You will need to enable

     drivers - usb - serial - USB Qualcomm Serial modem

in the kernel and re-compile.

This will allow the device to show up in lsmod however it will still not
have a device special file in /dev yet as it needs to have the firmware
loaded. The following external page has some more info about this. Gobi
linux information

> Bluetooth

deteced but not tested

See: Bluetooth

* * * * *

Below this line is directly copied from HP_Mini_5101 and is not tested
at all. I will update soon.

* * * * *

> ACPI

Suspend on Lid

This here works quite fine: Suspend to RAM#Automatic Suspend, the Hard
Way

It might be necessary to use "/etc/acpi/events/lm_lid" instead of
"/etc/acpi/events/lid". (laptop-mode?)

Just change the "LID" to it's actual value. For me it was C1D0.

    /etc/acpi/actions/lid_handler.sh

    if grep closed /proc/acpi/button/lid/C1D0/state >/dev/null ; then 

Power Button

Shutting system down by pressing the power button

Hotkeys

Display toggle

ACPI hotkeys

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

Extra Keyboard Keys

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Mini_5102&oldid=238393"

Category:

-   HP
