HP Folio 13
===========

  --------------- ------------------- ------------------------------------
  Device          Status              Modules
  Intel           Working             xf86-video-intel
  HDMI            Working             xf86-video-intel
  Ethernet        Working             
  Wireless        Working             broadcom-wl (brcmsmac not working)
  Bluetooth       Working             btusb (needs tweaking to work)
  Audio           Working             snd_hda_intel
  Touchpad        Partially Working   xf86-input-synaptics-led
  Camera          Working             uvcvideo
  USB 3.0         Working             xhci-hcd
  USB 2.0         Working             ehci-hcd
  eSATA           Working             
  Card Reader     Working             
  Function Keys   Working             
  --------------- ------------------- ------------------------------------

Contents
--------

-   1 Hardware
-   2 Configuration
    -   2.1 Installation
    -   2.2 CPU
    -   2.3 Video
    -   2.4 Audio
        -   2.4.1 HDMI
    -   2.5 Touchpad
    -   2.6 Suspend to RAM
    -   2.7 Webcam
    -   2.8 Function Keys
    -   2.9 Bluetooth
    -   2.10 Wireless

Hardware
--------

CPU Intel Core i5-2467M (1.60 GHz Dual-core, 3 MB Cache). i3 Model
available too.

Mainboard Intel HM65

RAM 4GB 1333MHz DDR3 (single DIMM slot, no spare slots)

Display 13.3" HD LED (1366x768)

Graphics adapter Intel HD3000

Soundcard Intel HD Audio

Network Realtek Semiconductor Co., Ltd. RTL8111/8168B, Broadcom
Corporation BCM4313 802.11b/g/n

Hard disk 128GB SSD

Webcam HP Truevision HD

Touchpad Synaptics touchpad with multi-touch gestures.

Configuration
-------------

This article refers to the HP Folio 13 ultrabook. The model specifically
is the dm3-1008TU, which is the i5 variant. An i3 variant is also
available with otherwise the same hardware (13-1016TU). For more:
http://www.hp.com/united-states/campaigns/folio13/index.html#.T3RIaNXK3co

> Installation

The Folio 13 lacks an optical drive, so you will need to create a USB
install media and boot from the USB (hit F9 at startup to select USB as
boot drive). The following notes refer to Arch x86_64 installed using a
nightly netinstall ISO (March 17 nightly). As noted below, you will need
to alter the kernel boot line in order to prevent the display from
blacking out once the kernel loads. This applies to the install media
and 1st boot once installation is done.

If you experience PGP package signing errors during the package download
and install phase of installation, you may need to do the foloowing:
after selecting packages, but before installing packages, go to TTY3
(Alt-F3), login as root, and edit /tmp/pacman.conf. Add the following
line after "Architecture = auto" - SigLevel = Never. You may also need
to generate pacman's signature keys using the command "pacman-key
--init".

If you wish to have all 128GB of space available on the SSD, first
backup the factory partition using HP's backup tool (available when you
login to the pre-installed Win 7) - you will need a 16GB USB drive to do
so. You can then totally wipe/repartition the SSD during Arch
installation, with the 16GB USB available to do a factory reinstall
(although why would you want to!?). Of course if you don't want a backup
USB, go ahead and just repartition the drive.

> CPU

Works out of the box. See CPU Frequency Scaling for more information on
power saving. Both cpufrequtils and cpupower work. Latter is recommended
for additional features.

> Video

This laptop has integrated HD3000 Intel Video. Works with xorg-intel
driver (see above). Plays HD video fine, no graphical anomalies on the
desktop (gnome-shell tested). Visual effects work fine.

Note:In order to prevent the screen from turning off/black at startup,
you need to add i915.modeset=1 acpi_backlight=vendor to Kernel
parameters

As the brightness adjustment Fn keys don't work [updated: as of kernel
3.10 brightness and other Fn keys do all work], and the laptop defaults
to 100% brightness, in order to save power and extend battery life, you
may want to reduce the screen brightness at boot up. To do so, enter the
following into /etc/rc.local:

     echo 3500 > /sys/class/backlight/intel_backlight/brightness

The value '3500' can be adjusted higher or lower (increasing or
decreasing brightness respectively) as preferred. '3500' corresponds to
around 75%.

> Audio

Works out of the box, including built-in microphone (good for your
Skype!).

HDMI

Works out of the box.

> Touchpad

More correctly, the HP Folio has what is known as a clickpad i.e. no
actual physical buttons exist. It mostly works out of the box with a few
niggles: the pointer can jump around a bit (this seems improved in
recent drivers) and the button areas are quite stiff (it does improve
with use).

The right-click area on the clickpad does not work out of the box -
although the xf86-input-synaptics driver (in [Extra]) supports
right-click functionality with a small edit to the config file as per
the Synaptics Arch Wiki [1].

You can also enable two-finger tap gesture as right-click functionality,
but this can be annoying when trying to two-finger scroll and an
accidental right-click is triggered - YMMV. A third way of restoring a
right-click button is to install the xf86-input-synaptics-led package
from the AUR[2].

Finally, there is currently no functionality to enable/disable the
trackpad by double-tapping the top left corner of the pad (a function
provided for by the windows drivers). The LED light of the clickpad also
doesn't work (even using the synaptics-led package [3] from AUR).

UPDATE: As of 21/5/12, the default xf86-input-synaptics does have
1-button click (either left or right) + drag functionality restored.
This means, for example, that you can left-click and drag to select text
and right-click and drag to perform mouse gestures (assuming you have
enabled the right button as above).

> Suspend to RAM

Suspending manually (pm-suspend) works, comes back with all devices OK.
Lid switch ACPI events do not work. However, the state of the lid is
reported in the file `/proc/acpi/button/lid/LID0/state.` Though this is
not the preferred way to manage services, it is possible to read this
file in an infinite loop and trigger a command to sleep or hibernate
when the lid is closed. An example script might look like this:

     #!/bin/bash
     
     delay_time="2.5"
     cmd="pm-hibernate"
     
     while true ; do
       state=( $(</proc/acpi/button/lid/LID0/state) )
       [[ ${state[1]} = "closed" ]] && $cmd
       sleep $delay_time
     done

Save this file to `/usr/local/bin/lid` and mark as executable with:

     # chmod +x /usr/local/bin/lid`

It is preferable to run this script as a daemon (see systemd).
Alternatively, it is possible to launch this in userspace, such as in
~/.xinitrc or other startup system. If so, the `cmd` variable may need
to be prefixed with `sudo` and one must allow the command to be executed
by a regular user as detailed at
Pm-utils#Suspend.2FHibernate_as_regular_user. Users may increase the
delay_time to decrease system calls or change the command to be executed
when the lid is closed.

This is a hacky solution, only to be used, if at all, until acpid
registers lid events. Nonetheless, the HP Folio 13 is sufficiently
powerful that the extra load created by checking a file every few
seconds has no perceptible impact on the user experience.

> Webcam

Works out of the box.

> Function Keys

Mostly work. The screen brightness function keys don't work and neither
does the wireless on-off key. The sound level/mute and keyboard
backlight on-off keys do all work.

Update: the sound level/mute keys no longer seem to work with kernel
3.6.x. This is a known bug related to GNOME, and has a fix in GNOME 3.6
[testing] as of 19/10/12.

Update 29 July 2013: Function keys now all work. This update/fix
appeared around kernel 3.10.

> Bluetooth

Does not work out of the box. You will need to add the following to
/etc/rc.local:

    modprobe btusb &&
    echo "0a5c 21e3" >> /sys/bus/usb/drivers/btusb/new_id

Finally, you will need to add 'bluetooth' to your rc.conf daemons.

> Wireless

The Broadcom BCM4313 suffers from a very weak wireless signal when using
the stock out-of-the-box 'brcmsmac' driver and is a known bug. In order
to get normal, useable wireless strength back, you will need to
blacklist the following modules by creating a file
'/etc/modprobe.d/broadcom-wl.conf'and editing it to read:

    blacklist b43
    blacklist bcma
    blacklist ssb
    blacklist brcmsmac

Using the wired ethernet connection, install 'broadcom-wl' from AUR.
There is no need to edit the modules line in rc.conf, it should load the
wl driver automagically.

Other model use Intel Centrino Wireless-N 1030, iwlwifi module included
in kernel. Not works in NetworkManager for me, but it does in Wicd.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Folio_13&oldid=270566"

Category:

-   HP

-   This page was last modified on 10 August 2013, at 02:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
