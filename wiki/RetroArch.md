RetroArch
=========

RetroArch is a modular, command-line driven, multi-system emulator that
is designed to be fast, lightweight, and portable. It has features few
other emulators frontends have, such as real-time rewinding and
game-aware shading based on the libretro API.

Installation
------------

Install retroarch-git from the AUR.

A GTK+/Qt frontend, retroarch-phoenix-git, is also available.

Usage
-----

RetroArch employs the use of separate emulator cores (or
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

Retrieved from
"https://wiki.archlinux.org/index.php?title=RetroArch&oldid=251952"

Categories:

-   Gaming
-   Emulators
