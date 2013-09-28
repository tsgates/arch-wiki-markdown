Lenovo ThinkPad T530
====================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Base System                                                        |
| -   2 Sound                                                              |
| -   3 GUI (X)                                                            |
|     -   3.1 Intel HD 4000                                                |
|     -   3.2 NVIDIA NVS 5400M                                             |
|                                                                          |
| -   4 Input                                                              |
|     -   4.1 TrackPoint                                                   |
|     -   4.2 Hotkeys (Media Keys)                                         |
|                                                                          |
| -   5 Networking                                                         |
| -   6 Thinkpad Specific Modules                                          |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Base System
-----------

-   You can follow the Beginners' Guide for this
    -   Basically everything that is there is what is needed, I will
        expand on the extra configs and weird tweaks that may be needed.
    -   Go up to not through the GUI configurations, since we may be
        changing some things.

Sound
-----

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

> NVIDIA NVS 5400M

Now you have a few options as far as what driver to use.

Arch recommends the xf86-video-nouveau driver, which is Open Source.
However, while it has fast 2D, it only has basic 3D support and does not
fully support power saving at this point.

    # pacman -S xf86-video-nouveau

The other option is the nvidia package, which supports 3D and provides
power saving. That being said, however, it will take some configuration
to get it right. See the nvidia page for config.

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

See also
--------

-   Technical specifications

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_T530&oldid=243632"

Category:

-   Lenovo
