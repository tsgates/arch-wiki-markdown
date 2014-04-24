Lenovo ThinkPad T530
====================

Contents
--------

-   1 Base System
-   2 Sound
-   3 GUI (X)
    -   3.1 Intel HD 4000
        -   3.1.1 Backlight Control
    -   3.2 NVIDIA NVS 5400M
-   4 Input
    -   4.1 TrackPoint
    -   4.2 Hotkeys (Media Keys)
-   5 Networking
-   6 Thinkpad Specific Modules
-   7 Battery Usage for T530
-   8 See also

Base System
-----------

-   You can follow the Beginners' guide for this
    -   Basically everything that is there is what is needed, I will
        expand on the extra configs and weird tweaks that may be needed.
    -   Go up to not through the GUI configurations, since we may be
        changing some things.

Sound
-----

Note:With linux 3.11.x, this seems not to be necessary any more.

Note:As of linux 3.6.x, auto-mute may have to be disabled for working
sound.

Temporary Fix Options:

1.  launch the Alsa Mixer CLI interface (in the terminal just type
    alsamixer) and then hit "F6". Select HDA Intel PCH and scroll over
    to "Auto-Mute" and hit the down arrow.
2.  Just enter this in the terminal /usr/bin/amixer -c 0 sset "Auto-Mute
    Mode" Disabled

Permanent Fix Options:

1.  Make the above command (/usr/bin/amixer -c 0 sset "Auto-Mute Mode"
    Disabled) launch at login.
    -   Gnome/Cinnamon: Alt+F2, gnome-session-properties, add the
        command and title/describe it as you wish)
    -   Mate: Follow "Gnome/Cinnamon" with "mate-session-properties"
        instead.
    -   Openbox: Add the command to the ~/.openbox/autorun file.

  
 Internal speakers and headphones (including optional auto-mute and
DisplayPort audio) work out-of-the-box.

  
 To enable sound you need to configure the kernel module

    /etc/modprobe.d/alsa-base.conf

    options snd-hda-intel model=thinkpad

(see Lenovo ThinkPad T400s)

GUI (X)
-------

You should install the xorg-server xorg-xinit and xorg-server-utils
packages.

Also, I am going to assume that you have the same set-up as me so you'll
need to do the following items.

I was in process of configuring Bumblebee, but after trying it both ways
on my T530 - I don't really see a huge gain for the pain. So I dropped
it. In my specific case, if I really need the extension to the battery
life, you can just turn off the Dedicated card in the BIOS.

> Intel HD 4000

You will need to install the xf86-video-intel package.

    # pacman -S xf86-video-intel

Backlight Control

If backlight control does not work properly (eg in KDE), check
/sys/class/backlight:

    # ls /sys/class/backlight/

    acpi_video0 intel_backlight

If the output looks similar to the above (ie more than one backlight
device), your Desktop Environment might choose the wrong device for
backlight control.

You can try creating a configuration file for Xorg specifying the device
to use. Create the file /etc/X11/xorg.conf.d/20-intel.conf with the
following contents:

    /etc/X11/xorg.conf.d/20-intel.conf

    Section "Device" 
            Identifier      "HD 4000" 
            Driver  "Intel" 
            Option "Backlight" "intel_backlight" 
    EndSection

This tells Xorg to use intel_backlight for controlling backlight. After
a reboot, you should be able to control the backlight and get OSD
notifications about it (KDE).

> NVIDIA NVS 5400M

Now you have a few options as far as what driver to use.

Arch recommends the xf86-video-nouveau driver, which is Open Source.
However, while it has fast 2D, it only has basic 3D support and does not
fully support power saving at this point.

    # pacman -S xf86-video-nouveau

The other option is the nvidia package, which supports 3D and provides
power saving. That being said, however, it will take some configuration
to get it right. See the nvidia page for config.

When in discrete graphics mode, The backlight does not work while in
UEFI Mode. This limitation does not exist in Legacy Mode.

Probably a waste, but I disabled this card in the BIOS for when I don't
use it. Took battery from ~2hrs to ~4.5hrs

Input
-----

> TrackPoint

You need to add a new XORG Config file to handle the TrackPoint events
(mostly the Middle Button handling horizontal and vertical scrolling,
the MiddleClick works by default).

Create /etc/X11/xorg.conf.d/10-trackpoint.conf with these contents:

       # vim /etc/X11/xorg.conf.d/10-trackpoint.conf
       Section "InputClass"
           Identifier      "Trackpoint Wheel Emulation"
           MatchProduct    "TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device"
           MatchDevicePath "/dev/input/event*"
           Option          "EmulateWheel"          "true"
           Option          "EmulateWheelButton"    "2"
           Option          "Emulate3Buttons"       "false"
           Option          "XAxisMapping"          "6 7"
           Option          "YAxisMapping"          "4 5"
       EndSection

  
 Once you reboot - you should be good-to-go with both vertical and
horizontal scrolling while holding the middle TrackPoint button.

> Hotkeys (Media Keys)

Media keys that work out of the box:

-   Wireless On/Off
-   Backlight Brightness (If you use the nVidia driver, configuration
    will be needed - documented on the Nvidia wiki page)
-   Thinklight / Keyboard Backlighting
-   Sleep

Keys that do not work out of the box, depending on your DE (you can bind
them):

-   Mute
-   Vol+/-
-   Prev/PlayPause/Next
-   Lock
-   Mic Mute (doesn't even register on my keymapper)
-   Fn+F7 - Display Toggle (Projector?)
-   Fn+F6 - WebCam Toggle
-   Launcher (right of the Mic Mute)

XFCE-users could install xfce4-volumed from AUR instead of bind the
mute/volume-keys.

Keybindings

Install the xbindkeys packages from the community repo. To run
xbindkeys, it will want you to have a .xbindkeysrc file and will offer
the default. Personally, I think the default options are terrible for a
US layout (example: Rebinding Ctrl-F to not be find). So I just make my
own to make it to my liking.

Here are the main ones, just open your preferred file editor and save
the following as ~/.xbindkeysrc:

    # Volume Controls
    "amixer set Master 5%+"
       XF86AudioRaiseVolume
    "amixer set Master 5%-"
       XF86AudioLowerVolume
    "amixer set Master toggle"
       XF86AudioMute
    # Lock (Fn+F3)
    "gnome-screensaver-command -l"
       XF86ScreenSaver
    # I use banshee for my audio
    "banshee --next"
       XF86AudioNext
    "banshee --restart-or-prev"
       XF86AudioPrev
    "banshee --toggle-playing"
       XF86AudioPlay
    # Launcher (right of the Mic Mute)
    "action"
       XF86Launch1

Be sure to set xbindkeys to run at startup, and any time you edit the
file you need to restart the process. In Gnome/Cinnamon hit Alt+F2 and
type "gnome-session-properties" and hit enter. Click "Add" and type in
xbindkeys for the command. You can call it and describe it however you
want.

If I get time, I plan to make a script that will change the program the
PlayPause/Prev/Next control. This will just do banshee in my example,
but I would like to expand that to control VLC if it is open and banshee
is not.

Networking
----------

Both the Ethernet and wireless are supported by Arch out of the box. All
the available Intel wireless cards are very well supported, including
good powersaving. The Lenovo branded (Realtek) card does not work as
well and does not support powersaving on Linux.

Thinkpad Specific Modules
-------------------------

While many of the system resources will be realized by the system, you
may want to add the thinkpad_acpi module to boot.

      sudo echo thinkpad_acpi > /etc/modules-load.d/thinkpad.conf

This will let you check fan speeds and such with

      cat /proc/acpi/ibm/fan

Battery Usage for T530
----------------------

As a barometer, my Arch system uses about 6.9 watts (as per Powertop) at
idle with minimum screen brightness wifi connected. My Fedora install
uses about 10 watts idle, and my Windows 7 install uses about 8 watts
idle according to the lenovo power manager. Tips to extend battery life:

-   Install powertop and run it as root. Pay special attention to any
    applications (as opposed to system processes) which cause CPU
    wakeups. I have had a clipboard manager use .5 watts on its own, so
    pay special attention to any apps or services you use. Also pay
    attention to bluetooth and network devices so you can disable them.

-   Use Integrated Graphics mode under Display in the BIOS setup. Even
    with Nvidia Optimus selected, no applications launched with
    'optirun' and the card OFF as listed by

      cat /proc/acpi/bbswitch

Powertop still consistently reports .3 watts more idle usage than with
Integrated Graphics only mode set in BIOS. If you run Optimus, use

      cat /proc/acpi/bbswitch 

to check the power status of the nvidia card, and use

      echo OFF >> /proc/acpi/bbswitch

to disable it. The power consumption is noticeably less than having the
discrete card enabled, but still higher than the Intel card alone. NOTE:
You may have to unload the nvidia module first before turning it off:
'rmmod nvidia' as root...

-   Laptop-mode-tools: Install/enable as per the wiki. Nearly all
    options work fine for the T530. For some reason, the ethernet device
    (enp0s25) uses upwards of a watt on my system. Laptop-mode-tools
    doesnt seem to disable this by default, even with
    /etc/laptop-mode/conf.d/ethernet.conf properly labeled with my
    ethernet device. If powertop reports such usage, go to
    /etc/laptop-mode/conf.d/exec-commands.conf and change:

      BATT_EXEC_COMMAND_0="
      LM_AC_EXEC_COMMAND_0=""
      NOLM_AC_EXEC_COMMAND_0=""

to

      BATT_EXEC_COMMAND_0="ip link set enp0s25 down"
      LM_AC_EXEC_COMMAND_0="ip link set enp0s25 up"
      NOLM_AC_EXEC_COMMAND_0="ip link set enp0s25 up"

-   profile-sync-daemon available in the AUR. When using the web browser
    on battery, write operations for cache, etc will wakeup the hard
    drive. profile-sync-daemon allows all write operations to go to RAM
    (as the profile is stored there), and then syncs to disk every hour
    (configurable). This will also reduce the wear on your hard drive,
    make the web browser feel faster, and reduce write cycles for SSD
    users.

-   Use 'noatime' in /etc/fstab if access times arent important to you.
    This is another way to reduce write cycles, and thereby disk
    wakeups.

-   Dont use any compositing at all. I tried using compton for panel
    transparency and this increased power consumption consistently by
    4-4.5 watts idle using just the Intel card. Powertop will inform you
    of gpu operations as well.

  

See also
--------

-   Technical specifications

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_T530&oldid=305197"

Category:

-   Lenovo

-   This page was last modified on 16 March 2014, at 19:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
