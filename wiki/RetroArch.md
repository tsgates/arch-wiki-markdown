RetroArch
=========

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Poor structure   
                           and out of date.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

RetroArch is a modular, command-line driven, multi-system emulator that
is designed to be fast, lightweight, and portable. It has features few
other emulators frontends have, such as real-time rewinding and
game-aware shading based on the libretro API.

Contents
--------

-   1 Installation
-   2 Usage
-   3 Configuration
-   4 Troubleshooting
    -   4.1 No keyboard/mouse input
    -   4.2 Video Problems

Installation
------------

Install retroarch-git from the AUR.

A GTK+/Qt frontend, retroarch-phoenix-git, is also available.

Usage
-----

RetroArch employs the use of separate emulator cores (or emulator
implementations) available from both the AUR and the libretro github.

Each package from the AUR will install an emulator core to
/usr/lib/libretro/[system].so, thus to use retroarch with your preferred
system simply launch it with the -L parameter. E.g.

    retroarch -L /usr/lib/libretro/libretro-snes9x-next.so ~/path/to/game

Tip:It is possible to run directly from .zip files using the
retroarch-zip shell wrapper, however, keep in mind that this is not
supported within the implementation.

This emulation core can also be defined in the retroarch.cfg, thus
obviating the need to specify it on the command line.

    /etc/retroarch.cfg

    libretro_path = "/usr/lib/libretro/libretro-snes9x-next.so"

There are currently several emulation cores available including snes9x,
bsnes, visual boy advance and final burn alpha. See this AUR search for
more.

Configuration
-------------

RetroArch provides a skeleton configuration file located at
/etc/retroarch.cfg and is very well commented.

It is capable of supporting split configuration files using the
#include "foo.cfg" directive within the main retroarch.cfg file.
Alternatively, extra configuration files can be appended on the command
line which override the default settings in retroarch.cfg. This can be
achieved by using --appendconfig /path/to/config and is beneficial if
different keybinds, video configurations or audio settings are required
for the various implementations.

Tip:retroarch is capable of loading bsnes xml filters [1] and cg shaders
[2]. They can be defined in retroarch.cfg as video_bsnes_shader and
video_cg_shader respectively.

Note:retroarch-git requires nvidia-cg-toolkit in order to use the cg
shaders.

Warning:When using the alsa driver make sure audio_out_rate is equal to
your system's default output rate. This is usually 48000.

  

Troubleshooting
---------------

> No keyboard/mouse input

If you are having no keyboard input in an X-less environment, this is
due to the fact that the /dev/input nodes are root-only. You can set up
a udev rule which makes these accessible to non-root. To
/etc/udev/rules.d/99-evdev.rules, add

    KERNEL=="event*", NAME="input/%k", MODE="666"

Then reload the udev rules with:

    sudo udevadm control --reload-rules

Until next reboot (or replugging devices), you can force permissions
with sudo chmod 666 /dev/input/event*.

> Video Problems

If your video driver has very bad performance, it is possible to run it
on a thread to avoid almost all video driver overhead. Set
video_threaded = true in ~/.config/retroarch/retroarch.cfg

Butter smooth VSync behavior in this case is impossible however, and
latency might increase slighly. Use only if you cannot obtain full speed
or if changing video resolution/refresh rate settings seem to not work.

Retrieved from
"https://wiki.archlinux.org/index.php?title=RetroArch&oldid=306056"

Categories:

-   Gaming
-   Emulators

-   This page was last modified on 20 March 2014, at 17:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
