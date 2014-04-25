Steam/Game-specific troubleshooting
===================================

Note:Steam installs library dependencies of a game to a library
directory, but some are missing at the moment. Report bugs involving
missing libraries on Valve's bug tracker on their GitHub page before
adding workarounds here, and then provide a link to the bug so it can be
removed as the problems are fixed.

Tip:If a game fails to start, a possible reason is that it is missing
required libraries. You can find out what libraries it requests by
running ldd game_executable. game_executable is likely located somewhere
in ~/.steam/root/SteamApps/common/. Please note that most of these
"missing" libraries are actually already included with Steam, and do not
need to be installed globally.

Contents
--------

-   1 Amnesia: The Dark Descent
    -   1.1 Dependencies
-   2 And Yet It Moves
    -   2.1 Dependencies
    -   2.2 Compatibility
-   3 Anodyne
    -   3.1 Dependencies
    -   3.2 Compatibility
-   4 Aquaria
    -   4.1 Troubleshooting
        -   4.1.1 Mouse pointer gets stuck in one direction
-   5 Cities in Motion 2
    -   5.1 Troubleshooting
        -   5.1.1 Dialog boxes fail to display properly
-   6 Crusader Kings II
    -   6.1 Mods
    -   6.2 DLC
    -   6.3 Troubleshooting
        -   6.3.1 No audio
-   7 Defender's Quest: Valley of the Forgotten
    -   7.1 Dependencies
    -   7.2 Troubleshooting
        -   7.2.1 Game does not start
-   8 Don't Starve
    -   8.1 Dependencies (x86_64)
    -   8.2 Troubleshooting
        -   8.2.1 No sound
-   9 Dota 2
    -   9.1 Dependencies (x86_64)
    -   9.2 Troubleshooting
        -   9.2.1 In-game font is unreadable
        -   9.2.2 Everything seems OK but the game doesn't start
        -   9.2.3 Game runs on the wrong screen
        -   9.2.4 Game does not start with libxcb-dri3 error message
-   10 Dwarfs F2P
    -   10.1 Dependencies
    -   10.2 Troubleshooting
        -   10.2.1 Game does not start
        -   10.2.2 Game crashes
-   11 Dynamite Jack
    -   11.1 Dependencies
    -   11.2 Troubleshooting
        -   11.2.1 Sound Issues
        -   11.2.2 Game does not start
-   12 FORCED
    -   12.1 Dependencies
-   13 FTL: Faster than Light
    -   13.1 Dependencies
    -   13.2 Compatibility
    -   13.3 Problems with open-source video driver
-   14 Game Dev Tycoon
    -   14.1 Troubleshooting
        -   14.1.1 Game does not start
-   15 Garry's Mod
    -   15.1 Troubleshooting
        -   15.1.1 Game does not start
-   16 Half-Life 2 & episodes
    -   16.1 Cyrillic fonts problem
-   17 Hammerwatch
    -   17.1 Troubleshooting
        -   17.1.1 The game not starting from Steam GUI
-   18 Harvest: Massive Encounter
    -   18.1 Dependencies
    -   18.2 Compatibility
-   19 Joe Danger 2: The Movie
    -   19.1 Dependencies
    -   19.2 Compatibility
-   20 Kerbal Space Program
    -   20.1 Troubleshooting
    -   20.2 Game never progresses past initial loading
    -   20.3 No text display
    -   20.4 Graphics flickering when using primusrun
    -   20.5 Game crashes when accessing settings or saves on 64 bit
        systems on Steam
    -   20.6 Screen resolution
    -   20.7 Locale settings
    -   20.8 No audio on 64-bit systems
-   21 Killing Floor
    -   21.1 Troubleshooting
        -   21.1.1 Screen resolution
        -   21.1.2 Windowed mode
-   22 Metro: Last Light
    -   22.1 Attempted fixes
    -   22.2 Hacky solution
    -   22.3 Possible solutions
-   23 Natural Selection 2
    -   23.1 No Sound
-   24 Multiwinia
    -   24.1 Dependencies
-   25 Penumbra: Overture
    -   25.1 Dependencies
    -   25.2 Troubleshooting
        -   25.2.1 Windowed mode
-   26 Portal 2 (beta)
    -   26.1 Opt into open Beta
    -   26.2 Game not starting
-   27 Revenge of the Titans
    -   27.1 Dependencies
-   28 Serious Sam 3: BFE
    -   28.1 Dependencies
    -   28.2 Troubleshooting
        -   28.2.1 No audio
-   29 Sir, you are being hunted
    -   29.1 Dependencies
-   30 Spacechem
    -   30.1 Dependencies
    -   30.2 Troubleshooting
        -   30.2.1 Game crash
-   31 Space Pirates and Zombies
    -   31.1 Dependencies
    -   31.2 Troubleshooting
        -   31.2.1 No audio
-   32 Splice
    -   32.1 Dependencies
-   33 Steel Storm: Burning Retribution
    -   33.1 Troubleshooting
        -   33.1.1 Start with black screen
        -   33.1.2 No English fonts
-   34 Strike Suite Zero
    -   34.1 Dependencies
-   35 Superbrothers: Sword & Sworcery EP
    -   35.1 Dependencies
-   36 Team Fortress 2
    -   36.1 Dependencies
    -   36.2 Making HRTF work
    -   36.3 Troubleshooting
        -   36.3.1 Loading screen freeze
        -   36.3.2 No audio
        -   36.3.3 Slow loading textures
-   37 The Book of Unwritten Tales
    -   37.1 Dependencies
-   38 The Book of Unwritten Tales: The Critter Chronicles
-   39 The Clockwork Man
    -   39.1 Dependencies
-   40 The Polynomial
    -   40.1 Dependencies
    -   40.2 Troubleshooting
        -   40.2.1 Segfaults during program start on 64-bit systems
-   41 Trine 2
    -   41.1 Dependencies
    -   41.2 Troubleshooting
-   42 Unity of Command
    -   42.1 Dependencies
    -   42.2 Troubleshooting
        -   42.2.1 No audio
-   43 World of Goo
    -   43.1 Changing resolution
-   44 Worms Reloaded
    -   44.1 Dependencies
-   45 Towns / Towns Demo
    -   45.1 Crash on launch

Amnesia: The Dark Descent
-------------------------

> Dependencies

-   lib32-freealut
-   lib32-glu
-   lib32-libxmu
-   lib32-sdl_ttf

And Yet It Moves
----------------

> Dependencies

-   lib32-libtheora
-   lib32-libjpeg6
-   lib32-libtiff4
-   lib32-libpng12

> Compatibility

Game refuses to launch and one of the following messages can be observed
on console

     readlink: extra operand ‘Yet’
     Try 'readlink --help' for more information.

OR

     This script must be run as a user with write priviledges to game directory

To fix this, use:

    ~/.steam/root/SteamApps/common/And Yet It Moves/AndYetItMovesSteam.sh

    #ayim_dir="$(dirname "$(readlink -f ${BASH_SOURCE[0]})")"
    ayim_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

Anodyne
-------

> Dependencies

-   adobe-air-sdk
-   xterm (probably not actually required)

> Compatibility

Follow the same steps as Defender's Quest

Aquaria
-------

> Troubleshooting

Mouse pointer gets stuck in one direction

If the mouse pointer gets stuck in any one direction, the game becomes
unplayable. You may try:

    ~/.local/share/Steam/SteamApps/common/Aquaria/usersettings.xml

    #<JoystickEnabled on=”1″ />
    <JoystickEnabled on=”0″ />

If that does not fix the issue, unplug any joystick or joystick adapter
devices you may have plugged in.

Cities in Motion 2
------------------

> Troubleshooting

Dialog boxes fail to display properly

You won't be able to read or see anything and you'll have this in your
logs:

    Fontconfig error: "/etc/fonts/conf.d/10-scale-bitmap-fonts.conf", line 69: non-double matrix element
    Fontconfig error: "/etc/fonts/conf.d/10-scale-bitmap-fonts.conf", line 69: wrong number of matrix elements

Workaround for the bug FS#35039 is available [here
http://bpaste.net/show/167019/] (replace
/etc/fonts/conf.d/10-scale-bitmap-fonts.conf).

Crusader Kings II
-----------------

Game is installed into $HOME/Steam/SteamApps/common/Crusader Kings II.
Game can be started directly, without need of running Steam on
background, using command
$HOME/Steam/SteamApps/common/Crusader Kings II/ck2.

Saves are stored in
$HOME/Documents/Paradox Interactive/Crusader Kings II/save games/. In
the newest version 2.03 savefiles seem to be stored to
$HOME/.paradoxinteractive/Crusader Kings II/, if your documents folder
is empty, try looking there.

> Mods

Linux version doesn't have a launcher in opposite of Windows one.

For using mods, you need to put them into game settings directory
(~/Documents/Paradox Interactive/Crusader Kings II/mod/) and launch the
game with special key -mod=<mod_path>. For example:

    -mod=mod/CK2_rus_full_v1.092.mod -mod=mod/Extendedtitlesmod.mod

If mods don't load for you, try creating a mod folder in
$HOME/.paradoxinteractive/Crusader Kings II/ and put your mods there.

> DLC

All DLC that you have bought on Steam is enabled by default. As with
mods, due to lack of a launcher you need to use a launch option to
disable one. The option is -exclude-dlc with an argument of the
corresponding .dlc file in
~/.steam/steam/SteamApps/common/Crusader Kings II/dlc/. For example, to
disable Sunset Invasion, use:

    -exclude-dlc=dlc/dlc018.dlc

> Troubleshooting

No audio

The default audio driver used by Crusader Kings 2 is for PulseAudio, so
an override is necessary:

    ~/.pam_environment

    SDL_AUDIODRIVER=alsa

Defender's Quest: Valley of the Forgotten
-----------------------------------------

> Dependencies

-   adobe-air-sdk
-   xterm
-   lib32-libcanberra

> Troubleshooting

Game does not start

-   Package adobe-air-sdk installs Adobe Air not in the place where the
    game expects it to be, fix this by creating a symlink (requires root
    permissions):

    $ ln -s /opt/adobe-air-sdk/runtimes/air/linux/Adobe\ AIR /opt/Adobe\ AIR

-   Adobe AIR will want to check whether the EULA was accepeted and fail
    in doing so. To fix it, issue the following commands (from under
    your user, not under root):

    $ mkdir -p ~/.appdata/Adobe/AIR
    $ echo 2 > ~/.appdata/Adobe/AIR/eulaAccepted

Note:By issuing these commands you're accepting Adobe Air's EULA.

Don't Starve
------------

> Dependencies (x86_64)

-   lib32-flashplugin
-   lib32-alsa-plugins (Looks like it fixes sound in some cases. See
    this github issue for details)

> Troubleshooting

No sound

Right click on Don't Starve on your game list, click on Properties,
click on SET LAUNCH OPTIONS, then add this:

    LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH" %command%

On the game, go to the option and set all audio to the proper volume.

Dota 2
------

> Dependencies (x86_64)

-   lib32-openal
-   lib32-libpulse (if you use pulse)

> Troubleshooting

In-game font is unreadable

Start Steam (or Dota 2) with the environment variable:

    MESA_GL_VERSION_OVERRIDE=2.1

Everything seems OK but the game doesn't start

If you run the game from the terminal and, although no error is shown,
the disabling: Steam > Settings > In-Game > Enable Steam Community
In-Game. Apparently the game The Book of Unwritten Tales has the same
problem. It also describes a workaround that is untested in Dota 2.

Game runs on the wrong screen

GitHub Dota 2 issue #11

Game does not start with libxcb-dri3 error message

After a recent Mesa update, Dota 2 stopped working. The error message
is:

    SDL_GL_LoadLibrary(NULL) failed: Failed loading libGL.so.1: /usr/lib32/libxcb-dri3.so.0: undefined symbol: xcb_send_fd

Simply remove the bundled libxcb to force Steam to use the system-wide
version. Restart Steam to apply.

    $ find ~/.local/share/Steam -name libxcb* -type f | grep -v installed | xargs rm

GitHub Steam issue #3204

Dwarfs F2P
----------

> Dependencies

-   lib32-libgdiplus

> Troubleshooting

Game does not start

There was a bug that stopped Steam from fetching all the needed files.
It should be resolved, if you still bump into this problem, try
verifying integrity of game cache from game properties, local files tab.

If the game still crashes at startup, edit
~/.local/share/Steam/SteamApps/common/Dwarfs - F2P/Run.sh and change

    export LD_LIBRARY_PATH=.:${LD_LIBRARY_PATH}

to

    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:.

Note:This file may be overwritten by updates or by verifying integrity
of game cache. You may need to modify it again.

If these do not help, you may have outdated libraries in the game
installation folder that are crashing the game on startup. Try
moving/removing the following files out of
~/.local/share/Steam/SteamApps/common/Dwarfs - F2P/ to fix it:

    libX11.so.6, libsteam.so libtier0_s.so, libvstdlib_s.so, steamclient.so

Game crashes

In some cases, the game crashes about 2 minutes before the end of every
arcade. This bug has been reported, but there's no known solution to it.

Dynamite Jack
-------------

> Dependencies

-   lib32-sdl1.2

> Troubleshooting

Sound Issues

When running on 64-bit Arch Linux, there may be "pops and hisses" when
running Dynamite Jack. This could be caused by not having

Template error:are you trying to use the = sign? Visit
Help:Template#Escape template-breaking characters for workarounds.

set. (However, even with

Template error:are you trying to use the = sign? Visit
Help:Template#Escape template-breaking characters for workarounds.

set, the game may still sometimes start with this issue. Exiting and
restarting the game seems to make the problem go away.)

Game does not start

If running steam with the

Template error:are you trying to use the = sign? Visit
Help:Template#Escape template-breaking characters for workarounds.

, Dynamite Jack may have a problem starting. The error could be caused
by not having the lib32-sdl1.2 library. Check the steam error messages
for this message:

    /home/<USER>/.local/share/Steam/SteamApps/common/Dynamite Jack/bin/main: error while loading shared libraries: libSDL-1.2.so.0: cannot open shared object file: No such file or directory

Install the lib32-sdl1.2 AUR library and Dynamite Jack should start up.

FORCED
------

This game has 32-bit and 64-bit binaries. For unknown reason, steam will
launch the 32-bit binary even on 64-bit Arch Linux. When manually
launching the 64-bit binary, the game starts, but cannot connect to
Steam account, so you cannot play. So install 32-bits dependencies, and
launch the game from Steam.

> Dependencies

-   lib32-alsaplugin
-   lib32-glu

FTL: Faster than Light
----------------------

> Dependencies

Libraries are downloaded and and placed in the game's data directory for
both architectures. As long as you run FTL by the launcher script (or
via the shortcut in Steam) you should not need to download any further
libraries.

> Compatibility

After installation, FTL may fail to run due to a 'Text file busy' error
(characterised in Steam by your portrait border going green then blue
again). The easiest way to mend this is to just reboot your system. Upon
logging back in FTL should run.

The Steam overlay in FTL does not function as it is not a 3D accelerated
game. Because of this the desktop notifications will be visible. If
playing in fullscreen, therefore, these notifications in some systems
may steal focus and revert you back to windowed mode with no way of
going back to fullscreen without relaunching. The binaries for FTL on
Steam have no DRM and it is possible to run the game without Steam
running, so in some cases that may be optimum - just ensure that you
launch FTL via the launcher script in
~/.steam/root/SteamApps/common/FTL Faster than Light/data/ rather than
the FTL binary in the $arch directory.

> Problems with open-source video driver

FTL may fail to run if you are using an opensource driver for your video
card. There are two solutions: install a proprietary video driver or
delete (rename if you are unsure) the library "libstdc++.so.6" inside
~/.steam/root/SteamApps/common/FTL\ Faster\ Than\ Light/data/amd64/lib.
This is if you are using a 64bit system. In case you are using a 32bit
system you have to remove (rename) the same library located into
~/.steam/root/SteamApps/common/FTL\ Faster\ Than\ Light/data/x86/lib.

Game Dev Tycoon
---------------

> Troubleshooting

Game does not start

Error about missing libudev.so.0 might appear, solution:

     # ln -s /lib/libudev.so /lib/libudev.so.0

Garry's Mod
-----------

> Troubleshooting

Game does not start

Error about missing client.so might appear, solution:

     cd SteamLibrary/SteamApps/common/GarrysMod/bin/
     ln -s libawesomium-1-7.so.0 libawesomium-1-7.so.2
     ln -s ../garrysmod/bin/client.so ./

Half-Life 2 & episodes
----------------------

> Cyrillic fonts problem

This problem can be solved by deleting "Helvetica" font.

Hammerwatch
-----------

> Troubleshooting

The game not starting from Steam GUI

Right click on Hammerwatch on your game list, click on Properties, click
on SET LAUNCH OPTIONS, then add this:

    LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH" %command%

Harvest: Massive Encounter
--------------------------

> Dependencies

-   lib32-gtk2
-   lib32-libvorbis
-   lib32-openal
-   lib32-nvidia-cg-toolkit
-   lib32-libjpeg6

> Compatibility

Game refuses to launch and throws you to library installer loop. Just
edit
 ~/.steam/root/SteamApps/common/Harvest Massive Encounter/run_harvest
and remove everything but

     #!/bin/bash
     exec ./Harvest

Joe Danger 2: The Movie
-----------------------

> Dependencies

-   lib32-libpulse
-   lib32-alsa-plugins

> Compatibility

Game only worked after obtaining from the Humble Bundle directly and
lib32-libpulse was installed.

Kerbal Space Program
--------------------

> Troubleshooting

> Game never progresses past initial loading

To fix this, set:

    LC_ALL=C

> No text display

The game requires Arial and Arial Black fonts, provided in the
ttf-ms-fonts AUR package.

> Graphics flickering when using primusrun

Run with PRIMUS_SYNC=2 (but you will get reduced frame rate this way)

> Game crashes when accessing settings or saves on 64 bit systems on Steam

In the properties for Kerbal Space program, set a launch option of:

    LC_ALL=C %command%_64

> Screen resolution

KSP runs fine in all resolutions, but fullscreen is NOT working on a up
to date KDE (14.04.2013).

.steam/steam/SteamApps/common/Kerbal Space Programm/settings.cfg had to
be deleted after checking the Fullscreen box. See:
https://bugs.kerbalspaceprogram.com/issues/533

> Locale settings

See https://bugs.kerbalspaceprogram.com/issues/504 if you have troubles
with building Ships.

> No audio on 64-bit systems

Run the 64-bit Executable.

Steam launches the KSP.x86 executable vs the KSP.x86_64 executable.
Navigate to

    /home/$USER/.local/share/Steam/SteamApps/common/Kerbal\ Space\ Program/ 

Launch with

    ./KSP.x86_64

Or you can simply right click on Kerbal Space Program on your game list,
click on Properties, click on SET LAUNCH OPTIONS, then add this:

    LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH" LC_ALL=C %command%_64

Killing Floor
-------------

> Troubleshooting

Screen resolution

Killing Floor runs pretty much from scratch, although you might have to
change in-game resolution screen as the default one is 800x600 and a 4:3
screen format. If you try to modify screen resolution in-game, it might
crash your desktop enviroment. To fix this, please set the desired
resolution screen size by modifing your
~/.killingfloor/System/KillingFloor.ini with your prefered editor.

    ~/.killingfloor/System/KillingFloor.ini

    ...

    [WinDrv.WindowsClient]
    WindowedViewportX=????
    WindowedViewportY=????
    FullscreenViewportX=????
    FullscreenViewportY=????
    MenuViewportX=???
    MenuViewportY=???

    ...

    [SDLDrv.SDLClient]
    WindowedViewportX=????
    WindowedViewportY=????
    FullscreenViewportX=????
    FullscreenViewportY=????
    MenuViewportX=????
    MenuViewportY=????

    ...

Note:Replace all the ???? with the corresponding numbers according the
desired resolution. If you have an 1366x768 screen and want to use it at
it's fullest, change all the Viewport fields to something like
ViewportX=1366 and ViewportY=768 in the corresponding areas.

Note: The dots in the middle indicate that there are more fields in that
.ini file. But for screen resolution troubleshooting, you do not need to
modify anything else.

Save the file and restart the game, it should work now.

Windowed mode

Uncheck fullscreen in the options menu, and use Ctrl+g to stop mouse
capturing (that was non-obvious to discover..). This way you can easily
minimize it and do other other things..and let your WM handle things.

Metro: Last Light
-----------------

This game is not allowing to change its resolution on a multimonitor
setup on GNOME with Catalyst drivers.

> Attempted fixes

Various changes to the games config file was tried without success.
wmctrl was not able to force the games resolution.

> Hacky solution

Disabled the side monitors.

> Possible solutions

Jason over at unencumbered by fact is using Nvidia drivers on his
multimonitor setup. However he notes he is using a single display server
setup. This is being explored.

Natural Selection 2
-------------------

Game mostly works out of the box.

> No Sound

If there is no sound in-game. Try installing lib32-sdl, lib32-sdl2, and
lib32-alsa-plugins

Multiwinia
----------

> Dependencies

-   lib32-openal

Penumbra: Overture
------------------

> Dependencies

(Taken from penumbra-collection and penumbra-overture-ep1-demo)

-   lib32-glu
-   lib32-libxft
-   lib32-libvorbis
-   lib32-openal
-   lib32-sdl_ttf
-   lib32-sdl_image

> Troubleshooting

Windowed mode

There is no in-game option to change to the windowed mode, you will have
to edit ~/.frictionalgames/Penumbra/Overture/settings.cfg to activate
it. Find FullScreen="true" and change it to FullScreen="false", after
this the game should start in windowed mode.

Portal 2 (beta)
---------------

Game is currently in an open beta. No known dependencies for x86_64.

> Opt into open Beta

right click on game 'Portal 2 (Beta)' -> properties -> Betas -> Opt into
'Beta - Beta' -> Close

> Game not starting

If game fails to start, double check that you have enrolled in the beta.
Game name in library should be "Portal 2 (Beta)[Beta]". Note that beta
is stated twice.

Revenge of the Titans
---------------------

> Dependencies

-   libxtst and lib32-libxtst

Serious Sam 3: BFE
------------------

> Dependencies

-   lib32-alsa-plugins

> Troubleshooting

No audio

Try running:

    # mkdir -p /usr/lib/i386-linux-gnu/alsa-lib/
    # ln -s /usr/lib32/alsa-lib/libasound_module_pcm_pulse.so /usr/lib/i386-linux-gnu/alsa-lib/

If that does not work, try tweaking ~/.alsoftrc as proposed by the Steam
community (Serious Sam 3: BFE uses OpenAL to output sound). If you are
not using Pulse Audio, you may want to write the following
configuration:

    ~/.alsoftrc

    [general]
    drivers = alsa
    [alsa]
    device = default
    capture = default
    mmap = true

Sir, you are being hunted
-------------------------

> Dependencies

-   lib32-alsa-plugins

Spacechem
---------

> Dependencies

-   lib32-sqlite
-   lib32-sdl_image
-   lib32-sdl_mixer

> Troubleshooting

Game crash

The shipped x86 version of Spacechem does not work on x64 with the
game's own libSDL* files, and crashes with some strange output.

To solve this just remove or move the three files libSDL-1.2.so.0,
libSDL_image-1.2.so.0, libSDL_mixer-1.2.so.0 from
~/.steam/root/SteamApps/common/SpaceChem

Space Pirates and Zombies
-------------------------

> Dependencies

-   lib32-alsa-plugins
-   lib32-openal

> Troubleshooting

No audio

Try running:

    # mkdir -p /usr/lib/i386-linux-gnu/alsa-lib/
    # ln -s /usr/lib32/alsa-lib/libasound_module_pcm_pulse.so /usr/lib/i386-linux-gnu/alsa-lib/

If that does not work, try tweaking ~/.alsoftrc as proposed by the Steam
community (Serious Sam 3: BFE uses OpenAL to output sound). If you are
not using Pulse Audio, you may want to write the following
configuration:

    ~/.alsoftrc

    [general]
    drivers = alsa
    [alsa]
    device = default
    capture = default
    mmap = true

Splice
------

Splice comes with both x86 and x64 binaries. Steam does not have to be
running to launch this game.

> Dependencies

-   glu

Steel Storm: Burning Retribution
--------------------------------

> Troubleshooting

Start with black screen

The game tries to launch in 1024x768 resolution with fullscreen mode by
default. It is impossible on some devices. (for example laptop Samsung
Series9 with intel hd4000 video).

You can launch the game in windowed mode. To do this open game
Properties in Steam, in General tab select "Set launch options..." and
type "-window".

Now you can change the resolution in game.

No English fonts

If you use Intel video card, just disable S3TC in DriConf.

Strike Suite Zero
-----------------

> Dependencies

-   lib32-alsaplugin

Superbrothers: Sword & Sworcery EP
----------------------------------

> Dependencies

-   lib32-glu
-   lib32-alsa-plugins

Team Fortress 2
---------------

> Dependencies

-   lib32-libpng12

> Making HRTF work

Assuming HRTF has been set up properly in the operating system, hrtf
won't be enabled unless you disable the original processing. To do so,
use

       dsp_slow_cpu 1

For best results, also change the following:

       snd_spatialize_roundrobin 1
       dsp_enhance_stereo 0
       snd_pitchquality 1

> Troubleshooting

Loading screen freeze

If you are a non-english (speaking) user, you have to enable
"en_US.UTF-8" in the locale.gen! Generate a new locale after that.

No audio

It happens if there is no PulseAudio in your system. If you want to use
ALSA, you need to launch Steam or the game directly with
SDL_AUDIODRIVER=alsa (From SteamCommunity).

If it still does not work, you may also need to set the environment
variable AUDIODEV. For instance AUDIODEV=Live. Use aplay -l to list the
available sound cards.

Slow loading textures

If you are using Chris' FPS Configs or any other FPS config, you may
have set mat_picmip to 2. This spawns multiple threads for texture
loading, which may cause more jittering and lag on Linux, especially on
alternative kernels. Try setting it to -1, the default.

The Book of Unwritten Tales
---------------------------

If the game does not start, uncheck: Properties > Enable Steam Community
In-Game.

The game may segfault upon clicking the Setting menu and possibly during
or before gameplay. This is a known problem and you will unfortunately
have to wait for a fix from the developer. A workaround (taken from the
Steam forums) is to replace the game's RenderSystem_GL.so with one from
Debian's repositories. To do that download this deb file, extract it
(with dpkg -x libogre-*.deb outdir) and replace
~/.local/share/Steam/SteamApps/common/The Book of Unwritten Tales/lib/32/RenderSystem_GL.so
{with the one that comes with the .deb package.

> Dependencies

-   lib32-libxaw
-   lib32-jasper

The Book of Unwritten Tales: The Critter Chronicles
---------------------------------------------------

Because it's based on the same engine, the things that apply to The Book
of Unwritten Tales also apply for this game.

The Clockwork Man
-----------------

> Dependencies

-   lib32-libidn

The Polynomial
--------------

> Dependencies

-   ilmbase102-libs
-   openexr170-libs

Steam for Linux issue #2721

> Troubleshooting

Segfaults during program start on 64-bit systems

The game segfaults during program start because of the LD_LIBRARY_PATH
setting in the launcher script. Edit
~/.local/share/Steam/SteamApps/common/ThePolynomial/Polynomial64, and
comment out the LD_LIBRARY_PATH variable. Make sure to put the
./bin/Polynomial64 "$@" command on a new line.

Trine 2
-------

> Dependencies

-   lib32-glu
-   lib32-libxxf86vm
-   lib32-openal
-   xorg-xwininfo

> Troubleshooting

-   If colors are wrong with FOSS drivers (r600g at least), try to run
    the game in windowed mode, rendering will be corrected. (bugreport)
-   If sound plays choppy, try:

    /etc/openal/alsoft.conf

    drivers=pulse,alsa
    frequency=48000

-   If the game resolution is wrong when using a dual monitor setup and
    you can't see the whole window edit ~/.frozenbyte/Trine2/options.txt
    and change the options ForceFullscreenWidth and
    ForceFullscreenHeight to the resolution of your monitor on which you
    want to play the game.

Unity of Command
----------------

> Dependencies

-   lib32-pango
-   lib32-alsa-plugins

> Troubleshooting

-   If squares are shown instead of text, try removing
    $HOME/Steam/SteamApps/common/Unity of Command/bin/libpangoft2-1.0.so.0.

No audio

If you get this error:

    ALSA lib dlmisc.c:254:(snd1_dlobj_cache_get) Cannot open shared library /usr/lib/i386-linux-gnu/alsa-lib/libasound_module_pcm_pulse.so

Try running:

    # mkdir -p /usr/lib/i386-linux-gnu/alsa-lib/
    # ln -s /usr/lib32/alsa-lib/libasound_module_pcm_pulse.so /usr/lib/i386-linux-gnu/alsa-lib/

World of Goo
------------

> Changing resolution

-   To change the game resolution edit the section "Graphics display" in
    the configuration file
    $HOME/Steam/SteamApps/common/World of Goo/properties/config.txt. For
    example, see below:

     <param name="screen_width" value="1680" />
     <param name="screen_height" value="1050" />
     <param name="color_depth" value="0" />
     <param name="fullscreen" value="true" />
     <param name="ui_inset" value="10" />

Worms Reloaded
--------------

> Dependencies

-   lib32-alsa-plugins

Towns / Towns Demo
------------------

> Crash on launch

Ensure you have Java installed.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Steam/Game-specific_troubleshooting&oldid=306086"

Category:

-   Gaming

-   This page was last modified on 20 March 2014, at 17:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
