ASUS Eee PC 1005HA
==================

  --------------- --------- ------------------
  Device          Status    Modules
  Intel 945GME    Working   xf86-video-intel
  Ethernet        Working   
  Wireless        Working   
  Audio           Working   snd_hda_intel
  Camera          Working   uvcvideo
  Card Reader     Working   
  Function Keys   Working   
  --------------- --------- ------------------

Contents
--------

-   1 Installation
-   2 Display and input settings
    -   2.1 DPI Settings
    -   2.2 Keyboard
    -   2.3 Touchpad
    -   2.4 xrandr
-   3 Powersaving and ACPI
    -   3.1 laptop-mode-tools
        -   3.1.1 Installation and setup
        -   3.1.2 LCD brightness
        -   3.1.3 CPU Powersaving
        -   3.1.4 USB suspend
    -   3.2 CPU frequency scaling
    -   3.3 Hotkeys
        -   3.3.1 Wifi toggle
        -   3.3.2 Sound volume hotkeys
        -   3.3.3 Sleep
    -   3.4 Display settings
-   4 Hardware
    -   4.1 Ethernet
    -   4.2 WiFi
    -   4.3 Camera
    -   4.4 Microphone
-   5 Hardware Info
    -   5.1 lspci

Installation
============

For an in-depth guide on the installation see the Beginners' guide.

Display and input settings
==========================

If not already installed, you need xorg and xf86-video-intel to have X
working, and also drivers for keyboard and touchpad:

    # pacman -S xorg-server xf86-video-intel xf86-input-evdev xf86-input-synaptics

See Intel for more information.

DPI Settings
------------

In general the autodetected DPI does not fit the smaller resolution very
well at all. A good comfortable setting would be 96dpi or 75dpi if you
like your fonts really small. An easy way to set your DPI would be to
add this to the end of your xserverrc (located in /etc/X11/xinit/).

     exec /usr/bin/X -nolisten tcp -dpi 96

Keyboard
--------

To set the keybord layout and other options, edit or create the file
/etc/X11/xorg.conf.d/keyboard.conf, and add the following:

    Section "InputClass"
      Identifier "Keyboard defaults"
      MatchIsKeyboard "yes"
      Option "XkbLayout" "us"
      Option "XkbModel" "asus_laptop"
      Option "XkbOptions" "terminate:ctrl_alt_bksp"
    EndSection

This gives you a US layout, more layouts can be found at
/usr/share/X11/xkb/rules/base.lst. Other options, like using
ctrl-alt-backspace to kill the X-server can also be setup here.

Touchpad
--------

Comment out the touchpad section of /etc/X11/xorg.conf.d/10-evdev.conf,
and edit /etc/X11/xorg.d/10-synaptics.conf to your liking. This example
gives you two finger scroll

    Section "InputClass"
       Identifier "touchpad catchall"
       Driver "synaptics"
       MatchIsTouchpad "on"
         Option "VertTwoFingerScroll" "true"
         Option "EmulateTwoFingerMinZ" "40"
         Option "EmulateTwoFingerMinW" "5"
    EndSection

For more information, see Touchpad Synaptics and the synaptics man file.

xrandr
------

For a nice GUI tool, try lxrandr; it is very simple to use!

Switch to External Monitor:

    xrandr --output LVDS --off --output VGA --auto

Switch back to eeepc's LCD:

    xrandr --output LVDS --auto --output VGA --off

Powersaving and ACPI
====================

Start off your powersaving adventures by installing Powertop. This is
basically a program to see how much power stuff is using, but it also
gives you tips on what to change.

    # pacman -S powertop

A good starting point is to disable the hardware you do not plan on
using. Reboot and enter the BIOS by pressing F2. Disable for example the
card reader, camera, ethernet but only if you do not need them of
course.

According to Powertop the 1005HA uses around 7-10 Watts on maximum
powersave (using Laptop mode tools and cpufreq and the above hardware
disabled, using Wifi and writing this). Idle around 5-6 W. Please report
how to get it lower!

laptop-mode-tools
-----------------

Laptop mode is a nice and easy way to setup most of the availiable power
saving options on the 1005HA. These include spinning down the hard drive
and adjusting the power saving modes of the harddrive and CPU, as well
as autosuspending of the USB-ports and screen brightness etc. It
provides a great centralized configuration file as well as separate
configuration files for the various power saving modules managed by
Laptop mode tools.

> Installation and setup

Install the package with

    # pacman -S laptop-mode-tools

The main configuration file is /etc/laptop-mode/laptop-mode.conf but
there are more configuration files located in the directory
/etc/laptop-mode/conf.d/ Be sure to read them and set them up
accordingly.

Note the option in laptop-mode.conf to automatically start many of the
other modules.

1005HA specific options for a few of the modules below (there are many
more):

> LCD brightness

For lcd-brightness, edit the file
/etc/laptop-mode/conf.d/lcd-brightness.conf and adjust it as suits you.
The darkest is 0 and brightest 15, this is a suggested setup:

    BATT_BRIGHTNESS_COMMAND="echo 1"
    LM_AC_BRIGHTNESS_COMMAND="echo 15"
    NOLM_AC_BRIGHTNESS_COMMAND="echo 15"
    BRIGHTNESS_OUTPUT="/proc/acpi/video/VGA/LCDD/brightness"

> CPU Powersaving

The eeepc "Super Hybrid Engine" as it's known under windows has a
significant effect on powersaving. This underclocks the FSB for
powersave/overclocks for performance and can be controlled via
/sys/devices/platform/eeepc/cpufv which is provided by the module
eeepc_laptop. It is included in the laptop-mode-tools package, and is
activated and configured in the file
/etc/laptop-mode/conf.d/eee-superhe.conf See also this forum thread.

As of the relase of kernel 2.6.32 the needed module eeepc_laptop doesn't
work, to get this working you will need to add the following to the
kernel line in the GRUB config (eg. /boot/grub/menu.lst):

    acpi_osi=Linux

The CPU frequency can be controlled by the file cpufreq.conf provided by
laptop mode tools. A good value is ”T2” (75% speed) when on battery and
”minimum” (full speed) when on AC. However, using the cpufrequtils
package (see below) is normally a better option, as the ondemand option
automatically changes between the specified modes depending on system
load.

> USB suspend

Tip: make use of the option to disable the suspending of some USB
hardware (eg. 3g modems) by using lsusb to get the ID and then insert it
in the configuration file.

CPU frequency scaling
---------------------

See cpufrequtils.

Hotkeys
-------

To get the hotkeys working (fn+F1 etc, touchpad lock, powerbutton
shutdown, Super hybrid engine toggle), install the acpi-eeepc-generic
package from AUR. Configuration is done in the file
/etc/conf.d/acpi-eeepc-generic.conf.

> Wifi toggle

To enable the toggling of the Wifi by pressing fn+f2, edit the
acpi-eeepc-generic config file and change

    COMMANDS_WIFI_TOGGLE=("/etc/acpi/eeepc/acpi-generic-toggle-wifi.sh")

to

    COMMANDS_WIFI_TOGGLE=()

Source.

> Sound volume hotkeys

In order to get the hotkeys for muting and raising and lowering of the
sound volume, edit /etc/conf.d/acpi-eeepc-generic.conf and replace the
lines:

    COMMANDS_MUTE=("alsa_toggle_mute")
    COMMANDS_VOLUME_DOWN=("alsa_set_volume 5%-")
    COMMANDS_VOLUME_UP=("alsa_set_volume 5%+")

with

    COMMANDS_MUTE=("@amixer set Master toggle")
    COMMANDS_VOLUME_DOWN=("@amixer set Master 10%-")
    COMMANDS_VOLUME_UP=("@amixer set Master 10%+")

Note that the value 10% can be any value you prefer, see the man page of
amixer.

> Sleep

If you have problems with the script provided in acpi-eeepc-generic, try
pm-suspend instead.

To substitute pm-suspend for the acpi sleep script, edit
/etc/conf.d/acpi-eeepc-generic.conf and comment out the line that reads:

    COMMANDS_SLEEP=("/etc/acpi/eeepc/acpi-eeepc-generic-suspend2ram.sh")

Replace it with:

    COMMANDS_SLEEP=("/usr/sbin/pm-suspend")

Display settings
----------------

Create the /etc/X11/xorg.conf file and add the following to it to enable
Intel's framebuffer compression, which according to Lesswats.org is
supposed to save quite some power.

    Section "Device"
     Identifier "Builtin Default intel Device 0"
     Driver	 "intel"
     Option	 "FramebufferCompression" "on"
     Option	 "AccelMethod" "EXA"
     Option	 "Tiling" "on"
    EndSection

Hardware
========

Ethernet
--------

Works with the stock 2.6.32 kernel, if you use an earlier kernel you
might need to install the driver from the AUR.

WiFi
----

WiFi works out of the box with the stock kernel (tested with 2.6.30 and
2.6.32).

Camera
------

To enable/disable the camera:

     # enable
     echo 1 > /sys/devices/platform/eeepc/camera
     # disable
     echo 0 > /sys/devices/platform/eeepc/camera

If you really want camera to be disabled, take a look in devices section
of BIOS.

Make sure that the module uvcvideo is loaded

To record video and take photos, you may use cheese or the wxcam
package.

To simply test the camera, you may use mplayer:

     mplayer -fps 15 tv://

The webcam works with Skype.

Microphone
----------

The microphone works out of the box, it's just a matter of
configuration. Run:

    $ alsamixer

Press <F4> to go to the 'Capture' section. Navigate to the 'Capture'
item using the right and left arrow keys and make sure 'LR Capture'
appears. If it doesn't, press <Space>. The 'Capture' and 'Digital'
levels are a trade-off between gain and static. I recommend setting to
70 and 75 (using the up and down arrow keys), respectivelly, but you can
ajust this to your liking. Exit alsamixer pressing <ESC> and test it:

    $ arecord /tmp/record.wav

Say something close enough to the microphone and hit <Ctrl+C> to stop
recording. Play it with:

    $ aplay /tmp/record.wav 

If everything went well, save your settings (as root):

    # alsactl store

Source: [1]

Hardware Info
=============

lspci
-----

Note that this is the 1005HA-M version.

    $ lspci

    00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03)
    00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02) 
    00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02) 
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02) 
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02) 
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02) 
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02) 
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02) 
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) 
    00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02) 
    00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA AHCI Controller (rev 02) 
    01:00.0 Ethernet controller: Attansic Technology Corp. Atheros AR8132 / L1c Gigabit Ethernet Adapter (rev c0) 
    02:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_1005HA&oldid=304878"

Category:

-   ASUS

-   This page was last modified on 16 March 2014, at 08:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
