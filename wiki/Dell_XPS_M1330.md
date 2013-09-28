Dell XPS M1330
==============

Dell XPS M1330 works quite well out of the box with Arch and GNU/Linux
in general, just like his big brother Dell XPS M1530. Here you can find
(or put !) information to configure your laptop and become a mobile
Archer.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Sound                                                              |
| -   2 Touchpad Synaptics                                                 |
| -   3 Fingerprint reader                                                 |
| -   4 Network                                                            |
|     -   4.1 Ethernet Setup                                               |
|     -   4.2 Wireless Setup                                               |
|     -   4.3 Bluetooth                                                    |
|                                                                          |
| -   5 nVidia Graphics                                                    |
|     -   5.1 Compiz Fusion                                                |
|     -   5.2 GPU Temperature                                              |
|                                                                          |
| -   6 Suspend                                                            |
| -   7 Hard Drive                                                         |
| -   8 SD Card Reader                                                     |
| -   9 Webcam                                                             |
| -   10 Sensors / Hardware info                                           |
| -   11 Extra media keys                                                  |
| -   12 BIOS                                                              |
|     -   12.1 History of BIOS Revisions                                   |
|                                                                          |
| -   13 Battery Usage                                                     |
| -   14 External Resources                                                |
+--------------------------------------------------------------------------+

Sound
-----

Sound should now work out of the box. Just be sure to unmute all
channels in alsamixer. To get the microphone working, you may have to
change the digital input source (right now I have Digital Mic 1 but this
could change in a new alsa version).

I suggest muting the PC speaker using alsamixer, as it makes an annoying
squeak otherwise.

With the current Linux kernel 3.0 and ALSA 1.0.24, do not mess around
with the snd-hda-intel module, like supposed in different Threads (
model=3stack etc. ). Automatic detection works fine.

Touchpad Synaptics
------------------

To configure the touchpad, you can refer to: Touchpad Synaptics Page.

Fingerprint reader
------------------

As of today, the device manufacturer is SGS Thomson Microelectronics
(you can check with a lsusb). Install it using ThinkFinger.

If you can't get thinkfinger going, try fprint

Install fprint.

Add yourself to the scanner group

     # gpasswd -a username scanner

Enroll your finger print

     $ sudo pam_fprint_enroll

If you want to use your fingerprint with sudo, edit the PAM config file
for sudo, /etc/pam.d/sudo, as follows:

    auth    sufficient    pam_fprint.so
    auth    required    pam_unix.so try_first_pass nullok_secure 
    auth    required    pam_nologin.so

When you do something with sudo, it should ask you to swipe your finger

Network
-------

Ethernet Setup

the ethernet card is recognized by the kernel, simply load the network
module to use it, or use a connection manager (see Wireless Setup for a
list of programs)

Wireless Setup

Note: M1330 has been shipped with many different wireless chipset. You
can find out what your card is with 'hwdetect --show-net' or 'lshwd'.
Check also Arch Wireless Setup.

-   Intel chipset : 4965agn

This is the most common chipset, the correct wireless driver to install
is iwlwifi-4965-ucode.  
 To get the Wi-Fi LED working, you can install compat-wireless from AUR.
See this forum thread (some versions can freeze your system !).

Using NetworkManager makes the wireless and wired GUI connection
interface in GNOME easy. It is possible to disable the annoying
'feature' whereby the GNOME Keyring keeps asking for a password at login
by editing /etc/pam.d/login in addition to the other edits suggested to
/etc/pam.d/gdm NetworkManager#PolicyKit_issues. You can also try
deleting ~/.gnome2/keyrings. This is especially useful if you do not use
gdm to login, rather login straight from the shell. YMMV if you use KDE
or another DE.

-   Intel chipset : 3945abg

The correct wireless driver to install is iwlwifi-3945-ucode.

-   Broadcom chipset : bcm43xx or b43 or bcm4312

See this or this or this.

Note:The Broadcom 4310 chipset is unsupported by bcm43xx and b43, but is
now supported by the official broadcom driver BCM4312, check this wiki
entry.

Note:For getting the Dell Wireless 1395 802.11g Mini Card to work (or
any other card with the 4310 chipset), I have made a brief guide for
getting this card to work.

Note:Arch 64 with Dell Wireless 1395 (Broadcom 4312 chipset): Use the
bcm4312 driver referenced above, works like a charm with Arch 64.
Wireless will be called eth1 instead of wlan0, so be sure to change all
references of wlan0 to eth1 (like in Wicd if you're using it.)

Bluetooth

Warning:If you have had Windows Vista installed, MAKE SURE YOU SWITCH
THE BLUETOOTH MODULE 'ON' IN VISTA! Failure to do this can render the
bluetooth device (Wireless 355 Bluetooth Module) unuseable in Arch or
any other O/S such as Windows 7 or XP. This is despite enabling the
module in the BIOS, or even reflashing the BIOS. The Bluetooth module
remains firmly 'off'. Annoying.

Before taking drastic measures however, ensure the transmitter switch is
'On' - it's the switch on the right-hand side of the laptop next to the
slot loading DVD Drive. If this switch is 'off' then wifi won't work
either.

If you're unfortunate to find yourself with Arch installed and a
'switched off' bluetooth device your only solution may be to reinstall
Vista and switch the module back on before re-installing Linux. You can
safely delete Vista again once you have switched the module back on.
Another option is to install Windows 7 or XP then re-enable the module
using the Dell patch (R159805.EXE) as described here:
http://codereflect.com/2009/01/17/what-you-can-do-if-your-dell-laptop-doesnt-show-bluetooth-device-after-re-installing-windows-vista/

Once you've enabled your Bluetooth module, you can then install the
relevant software.

Install bluez-utils & bluez-libs from extra repository.

Edit /etc/conf.d/bluetooth:

    DAEMON_ENABLE="true"
    HIDD_ENABLE="true"

Restart bluetooth service:

    # rc.d restart bluetooth

A list of utilities for bluetooth managing is present in AUR database.

If the above solutions do not work, for example, your Logitech BT Travel
Mouse is detected the first time only, then fails to be detected, you
can try removing bluez-utils and installing blueman instead.

nVidia Graphics
---------------

For those of you with the nVidia 8400GM chipset, using the nVidia driver
package works fine.

Compiz Fusion

Works just great with the nVidia chipset. You might like to tweak the
nVidia Powermizer for maximum battery life. I have forced my graphics
chipset to the lowest performance level and Compiz-Fusion runs
satisfactorily with a little slowdown here and there. See this part of
the Arch nVidia wiki for more details on how to set this up.

To have better performance with nVidia drivers, you should try "loose
binding" in Compiz Fusion (bug with Geforce 8 series). If you use Fusion
Icon, just right click it, then "Compiz Options"->"Loose Binding".

GPU Temperature

Starting with drives > 256.53 the reported GPU Temperature is about 10°
higher then before. It *may* be a driver problem resulting in higher
battery usage, as higher Temperature = More Power, but it also may be
something else. Hope that it doesn't shorten the life of the card. Using
the 256.53 driver with Kernels newer X-Servers > 1.10 does not work, so
there is a problem.

Suspend
-------

Note:If you have suspend problems, try nvidia-prerelease driver 180.25,
it seems to solve the problem described below.

With 180.x series of proprietary NVidia driver, suspend does not work
properly, using 177.x series helps but it's slower in 2d rendering.
Hibernate also works with 180.x series.

Note:This only works since kernel 2.6.25.x (stock Arch kernel). In
former versions, force unloading modules is not provided and you have to
recompile your kernel with this option.

With acpi-freq running, you might notice that CPU1 is deactivated after
using pm-suspend. To fix this you have to unload acpi-freq module each
time pm-suspend is called.

Put this in /etc/pm/sleep.d/66dummy:

    #!/bin/bash
    case $1 in
        suspend)
            rmmod -f acpi_cpufreq
            ;;
        resume)
            modprobe acpi_cpufreq
            ;;
        *)  echo "somebody is calling me totally wrong."
            ;;
    esac

Then make it executable :

    # chmod +x /etc/pm/sleep.d/66dummy

Solution was provided by this forum topic.

Hard Drive
----------

If your hard drive clicks regurlarly, you may suffer from this problem.
To fix it, add these lines to your /etc/rc.local:

    hdparm -B 254 /dev/sdX >> /dev/null

or :

    hdparm -B 224 /dev/sdX >> /dev/null

(replace X in sdX by the letter of your drive, e.g. sda)

When resuming from a pm-suspend, you might notice that the hard drive is
clicking again. To fix this, modify your /etc/pm/sleep.d/66dummy to put
the lines above. Following the last example in previous suspend section:

    case $1 in
        suspend)
            rmmod -f acpi_cpufreq
            ;;
        resume)
            modprobe acpi_cpufreq
            hdparm -B 224 /dev/sda >> /dev/null
            ;;
        *)  echo "somebody is calling me totally wrong."
            ;;
    esac

If not already done, make the file executable.

SD Card Reader
--------------

The device is recognized by the kernel. The Adapter module is: sdhci

The card will be availabe for mounting under the device:

    /dev/mmcblk0p1

Webcam
------

Note: The uvc modules are now compiled as part of the kernel (as of
2.6.26), so it should no longer be necessary to install uvc separately.

Note: Some m1330's come without a webcam, or the camera cable may be
damaged or have become detached internally. If in doubt (and before
pulling your hair out trying to figure out why the camera won't work
despite trying every software trick), run the built-in diagnostics
(available by pushing 'F12' during the POST screen, then selecting
'Diagnostics'). If no camera is hooked up or the cable is damaged,
you'll receive the following message: "Hardware Detect Error - Auxiliary
LCD cable not detected."

If this is the case, you can try to fix / replace / install the needed
hardware according the following: [1], [2], [3]

For kernels prior to 2.6.26,you have to install linux-uvc drivers to
have a working webcam (works for both VGA webcam from LED display and HD
webcam from CCFL display apparently). You can find them in the AUR.

Then you have to load corresponding modules:

    # modprobe usbvision
    # modprobe uvcvideo

If you want them to be loaded at startup, put usbvision and uvcvideo in
the MODULES section of /etc/rc.conf.

Sensors / Hardware info
-----------------------

Install i8k packages: i8kmon and i8kutils.

This will provide many useful information (temperature, fan speed,
BIOS...) and utilities (fan monitor, BIOS update...). For CPU temps, use
Lm sensors.

Extra media keys
----------------

-   They are recognized by default with evdev so you can directly bind
    them.

If you use GNOME, go in System->Preferences->Keyboard Shortcuts.

The remote control should work fine too.

-   If you are not using evdev you can still map those keys with
    xmodmap.

First you need to identify the corresponding keycodes, for instance,
running xev, and map them with an ~/.Xmodmap file. Here is my ~/.Xmodmap
file that you can copy (it may not work on your own machine - try xev
first):

    keycode 144 = XF86AudioPrev
    keycode 153 = XF86AudioNext
    keycode 160 = XF86AudioMute
    keycode 162 = XF86AudioPause
    keycode 164 = XF86AudioStop
    keycode 174 = XF86AudioLowerVolume
    keycode 176 = XF86AudioRaiseVolume
    keycode 222 = XF86PowerDown

You can now load the mappings with:

    xmodmap ~/.Xmodmap

If you are using a lightweight window manager like Openbox or Awesome
then you might want to use xbindkeys to set the mapped keys to functions
like so:

    "amixer set Master mute"
        m:0x0 + c:121
        XF86AudioMute
    "amixer set Master 1dB+ unmute"
        m:0x0 + c:122
        XF86AudioLowerVolume
    "amixer set Master 1dB+ unmute"
        m:0x0 + c:123
        XF86AudioRaiseVolume

Now use xbindkeys -mk to get your own codes and assign functions to them
and put them in .xbindkeysrc and also load xmodmap and xbindkeys in your
.xinitrc:

    xmodmap $HOME/.Xmodmap &
    xbindkeys &

If you are running XFCE, you'll notice that XF86AudioLowerVolume,
XF86AudioRaiseVolume and XF86AudioMute are binded to the aumix command.
So you'll need to install it (package aumix-gtk).

Or remap them to something like this "amixer sset PCM 5+" for instance.

-   KDE 3.5.x/4.x.x.

First of all in KDE you can enable the multimedia keys by choosing the
"Dell Laptop/notebook 6xxx/8xxx" layout in System Settings -> Regional
and Language -> Keyboard Layout. Alternatively, you can disable keyboard
layouts in KDE and add the following in the "InputDevice" section for
your keyboard:

    Option         "XkbLayout" <your preferred language here, e.g., "us">
    Option         "XkbModel" "inspiron"
    Option         "XkbRules" "xorg"
    #Option         "XkbVariant" "nodeadkeys" # Variant options, if you need them

Next, you can bind the multimedia-key actions to your needs with
Keyboard Shortcuts in System Settings (different places depending on KDE
version), e.g., in KMix bind "Toggle Mute - Front, HDA Intel" to the
mute button etc..

-   In KDE 3.5.x/4.x.x I experience the multimedia keys repeat 2-4 times
    on each keypress.

This may apply to other DE's as well.

The problem is related to the autorepeat settings for the keyboard, as
each keypress on the multimedia-keys lasts ~660ms, which is below the
default keyrepeat hold-time setting.

Add the following setting to the "InputDevice" section for your
keyboard:

    Option         "AutoRepeat" "700 20" # First time is the hold-time in ms before autorepeat starts,
                                         # second is the repeats per second.
                                         # Experiment with hold-times of ~680-700ms to find the lowest possible.

In KDE 3.5.x the autorepeat settings can be set in System Settings
instead. I think the KDE 4.x.x system (needs confirmation) does not
agree to the autorepeat setting in xorg.conf and you cannot set them in
System Settings currently (<= 4.1.2).

In my case (KDE 4.x.x), the autorepeat still makes the auto-repeat
activate when pressing the multimedia keys. I found out though, that the
setting in gnome-control-center -> Keyboard -> Repeat Keys settings
actually make the multimedia keys work as they should, after adjusting
the Delay slider. Even on the default setting, they work, the GNOME
settings just have to be activated, which gnome-settings-daemon may take
care of. Thus, add gnome-settings-daemon to you autostarts in KDE and
you have nice auto-repeat settings and your multimedia keys actually
work!

The latter feature/bug? with the gnome-control-center fixing it, lost my
attention for a long while, so I hope this can help others solving this
annoyance faster.

BIOS
----

Note: Updating your BIOS is always a dangerous operation (even if it is
safer on a laptop with a battery). Perform it at your own risks.

You can perform BIOS updates under GNU/Linux! Just install i8kutils!

Download latest BIOS (A15) here (.hdr file). This BIOS is for device ID
0x0209. You can check your device ID by installing libsmbios and then
running:

    smbios-sys-info-lite

You can find other bios fitting your system ID there.

Then go in the directory where you downloaded the BIOS file and type as
root:

    modprobe dell_rbu

    dellBiosUpdate-combat -u -f bios.hdr

Reboot, stare at the white frightening screen saying "BIOS update" for
an endless minute. Listen to the sweet vacuum-like full speed sound of
your fans just before it reboots automatically. Then observe the boot
screen with Dell logo displayed much longer than usual. Sweep the sweat
on your forehead. You are done!

> History of BIOS Revisions

Check this thread from NoteBook Review for detailed info.

A10 : May '08

-   The only enhancement I noticed with this bios is that you can now
    eject a CD/DVD without freezing your system (this was really a weird
    behaviour !). Please upgrade to A11 or A12 if you are currently
    using A10 !

A11 : Jun '08

-   Fixing overheating issues introduced with A10 bios.

A12 : Jul '08

-   Other thermal enhancements. Temperatures are lower for me but the
    fan is always running.

A13 : Oct '08 (removed-from-the-official-list)

-   Added support for new versions of Intel CPUs.
-   Added support for 8GB memory.

A14 : Nov '08

-   Added enhancement for Wifi sniffer function.

A15 : Jan '09

-   Enhance Fn+F8 function (probably only for Intel integrated graphics)
-   Support for 8GB memory is... back!

Battery Usage
-------------

I have been monitoring the battery usage for while. Test setting is
quite easy: Get as Low as Possible with display on and X-Server running,
values are reported by Powertop.

    Kernel 3.4.4-3-ARCH and NVidia Driver 304.37, 2,4 Ghz undervolted, Crucial M4 SSD, 9,75 W. Device is 5 years old now.
    Kernel 3.0-ARCH and NVidia Driver 275.xx 2,4 Ghz, OCZ SSD, pci_aspm=force on kernel line, 10,8 W. Guess that is near the technical minimum.
    Kernel 2.6.37-ARCH and NVidia Driver 270.xx, 2.4 Ghz, OCZ SSD: 11,6 W
    Kernel 2.6.36-ARCH and NVidia Driver 256.xx, 1.8 Ghz, Samsung HDD: 11,0 W

External Resources
------------------

This page describes all of the various driver modules required to make
the hardware in the XPS M1330 work.

French speaking people can also refer to these articles.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_XPS_M1330&oldid=238192"

Category:

-   Dell
