Backlight
=========

Screen brightness can often be tricky to control. On many machines,
physical hardware switches are missing and software solutions may or may
not work well. Make sure to find a working method for your hardware! Too
bright screens can cause eye strain.

There are many ways to adjust the screen backlight of a monitor, laptop
or integrated panel (such as the iMac) using software, but depending on
hardware and model, sometimes only some options are available. This
article aims to summarize all possible ways to adjust the backlight.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Overview                                                           |
| -   2 ACPI                                                               |
| -   3 Switching off the backlight                                        |
| -   4 Backlight utilities                                                |
|     -   4.1 xbacklight                                                   |
|     -   4.2 xcalib                                                       |
|     -   4.3 redshift                                                     |
|     -   4.4 relight                                                      |
|     -   4.5 setpci (use with great care)                                 |
|     -   4.6 Calise                                                       |
|     -   4.7 brightd                                                      |
|                                                                          |
| -   5 KDE                                                                |
| -   6 NVIDIA Settings                                                    |
| -   7 Backlight PWM modulation frequency (Intel i915 only)               |
+--------------------------------------------------------------------------+

Overview
--------

There are many ways to control brightness. According to this
discussion[1] and this wiki page [2], the control method could be
divided into these categories:

-   brightness is controlled by vendor specified hotkey. And there is no
    interface for OS to adjust brightness.
-   brightness is controlled by OS:
    -   brightness could be controlled by ACPI
    -   brightness could be controlled by graphic driver.

All methods expose themselves to the user by /sys/class/brightness. And
xrandr/xbacklight could use this folder and choose one method to control
brightness. But it is still not very clear which one xbacklight prefers
by default. See FS#27677 for xbacklight, if you get "No outputs have
backlight property." There is a temporary fix if xrandr/xbacklight does
not choose the right directory in /sys/class/brightness: You can specify
the one you want in xorg.conf by setting the "Backlight" option of the
Device section to the name of that directory (see
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=651741 at the bottom of
the page for details).

-   brightness is controlled by HW register throught setpci

ACPI
----

It is often possible to adjust the backlight by ACPI. This controls the
actual LEDs or cathodes of the screen. When this ACPI option is
available, the illumination is controllable using a GUI slider in the
Display/Screen system settings or by simple commands on the CLI.

Different cards might manage this differently. Check
/sys/class/backlight to find out:

    # ls /sys/class/backlight/

    intel_backlight

So this particular backlight is managed by an Intel card. It is called
acpi_video0 on an ATI card. In the following example, acpi_video0 is
used.

The directory contains the following files and folders:

    actual_brightness  brightness         max_brightness     subsystem/    uevent             
    bl_power           device/            power/             type

The maximum brightness (often 15) can be found by running cat:

    # cat /sys/class/backlight/acpi_video0/max_brightness
    15

Brightness can then be set (as root) with echo. Obviously you cannot go
any higher than your screen's maximum brightness. The values for maximum
brightness and brightness in general vary wildly among cards.

    # echo 5 > /sys/class/backlight/acpi_video0/brightness

Sometimes ACPI does not work well due to different motherboard
implementations and ACPI quirks. This include some models with dual
graphics (e.g. Nvidia-optimus/Radeon with intel (i915)) and some
examples with this problem in notebooks such as Dell Studio, Dell XPS
14/15/17 and some Lenovo series, Kamal Mostafa kernel developer make
patches for solved this issue included after 3.1 kernel version. You can
try adding the following kernel parameters in your bootloader(grub,
syslinux...) to adjust ACPI model:

    acpi_osi=Linux acpi_backlight=vendor

or

    acpi_osi=Linux acpi_backlight=legacy

acpi_backlight=vendor will prefer vendor specific driver (e.g.
thinkpad_acpi, sony_acpi, etc.) instead of the ACPI video.ko driver.

Switching off the backlight
---------------------------

Switching off the backlight (for example when one locks the notebook)
can be useful to conserve battery energy. Ideally the following command
inside of a graphical session should work:

    sleep 1 && xset dpms force off

The backlight should switch on again on mouse movement or keyboard
input. If the previous command does not work, there is a chance that
vbetool works. Note, however, that in this case the backlight must be
manually activated again. The command is as follows:

    vbetool dpms off

To activate the backlight again:

    vbetool dpms on

For example, this can be put to use when closing the notebook lid as
outlined in the entry for Acipd.

  

Backlight utilities
-------------------

> xbacklight

You can adjust the backlight through the xorg-server command xbacklight.
The utility is provided by the xorg-xbacklight package in [extra].

A useful demonstration was posted by gotbletu on YouTube. He suggests
the following commands to adjust the backlight:

-   brighten up:

    xbacklight -inc 40

-   dim down:

    xbacklight -dec 40

> xcalib

The program xcalib can be downloaded from AUR and used to dim the
screen. Again, the user gotbletu posted a demonstration on Youtube. This
program can correct gamma, invert colors and reduce contrast, the latter
of which we use in this case:

-   dim down:

    xcalib -co 40 -a

This program uses ICC technology to interact with X11 and while the
screen is dimmed, you may find that the mouse cursor is just as bright
as before.

> redshift

The program redshift in the community repository uses randr to adjust
the screen brightness depending on the time of day and your geographic
position. It can also do RGB gamma corrections and set color
temperatures. As with xcalib, this is very much a software solution and
the look of the mouse cursor is unaffected. To execute a single quick
adjustment of the brightness, try something like this:

    redshift -o -l 0:0 -b 0.8 -t 6500:6500

Tip:If your longitude is west or your latitude is south, you should
input it as negative.

Example for Berkeley, CA:

    gtk-redshift -l 37.8717:-122.2728 

> relight

relight is available in Xyne's repos and the AUR. The package provides a
service to automatically restore previous backlight settings during
reboot along using the ACPI method explained above. The package also
contains a dialog-based menu for selecting and configuring backlights
for different screens.

> setpci (use with great care)

It is possible to set the register of the graphic card to adjust the
backlight. It means you adjust the backlight by manipulating the
hardware directly, which can be risky and generally is not a good idea.
Not all of the graphic cards support this method.

When using this method, you need to use lspci first to find out where
your graphic card is.

    # setpci -s 00:02.0 F4.B=0

> Calise

The software calise can be found in AUR.

-   Stable version: calise
-   Development version: calise-git

It basically computes ambient brightness, and set screen's correct
backlight, simply making captures from the webcam, for laptop without
light sensor. For more information, calise has its own wiki: Calise
wiki.

The main features of this program are that it's very precise, very light
on resource usage, and with the daemon version (.service file for
systemd users available too), it has practically no impact on battery
life.

> brightd

Macbook-inspired brightd automatically dims (but doesn't put to standby)
the screen when there is no user input for some time. A good companion
of Display Power Management Signaling so that the screen doesn't blank
out in a sudden.

KDE
---

KDE users can adjust the backlight via System Settings -> Power
Management -> Power Profiles. If you want set backlight before kdm just
put in /usr/share/config/kdm/Xsetup :

    xbacklight -inc 10

NVIDIA Settings
---------------

Users of NVIDIA's proprietary drivers users can change display
brightness via the nvidia-settings utility under "X Server Color
Correction." However, note that this has absolutely nothing to do with
backlight (intensity), it merely adjusts the color output. (Reducing
brightness this way is a power-inefficient last resort when all other
options fail; increasing brightness spoils your color output completely,
in a way similar to overexposed photos.)

Backlight PWM modulation frequency (Intel i915 only)
----------------------------------------------------

Laptops with LED backlight are known to have screen flicker sometimes.
The reason for this, is that it is hard enough to dim LEDs by limiting
direct current flowing through. It is easier to control brightness by
switching LEDs on and off fast enough.

However, frequency of the switching (so-called PWM modulation frequency)
is not high enough actually, and some people may notice flicker either
explicitly or by feeling headache and eyestrain.

If you have an Intel i915 GPU, then it may be possible to adjust PWM
modulation frequency to eliminate flicker.

Install intel-gpu-tools from community repo

    # pacman -S intel-gpu-tools

Get value of the register, that determines PWM modulation frequency

    # intel_reg_read 0xC8254
    0xC8254 : 0x12281228

The value returned represents period of PWM modulation. So to increase
PWM modulation frequency, value of the register has to be reduced. For
example, to double frequency from the previous listing, execute

    # intel_reg_write 0xC8254 0x09140914

You can use online calculator to calculate desired value
http://devbraindom.blogspot.com/2013/03/eliminate-led-screen-flicker-with-intel.html

Refer to dedicated topic for details
https://bbs.archlinux.org/viewtopic.php?pid=1245913

Retrieved from
"https://wiki.archlinux.org/index.php?title=Backlight&oldid=256133"

Categories:

-   Laptops
-   Power management
