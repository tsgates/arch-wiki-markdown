Gaming
======

Related articles

-   List of games
-   Xorg
-   NVIDIA#Gaming using Twinview

This page only contains information about running games and related
system configuration tips. For lists of popular games for GNU/Linux see
List of games.

Contents
--------

-   1 Game environments
-   2 Getting games
    -   2.1 Native
    -   2.2 Digital distributions
    -   2.3 Flash
    -   2.4 Java
    -   2.5 Wine
-   3 Running games
    -   3.1 Multi-screen setups
    -   3.2 Keyboard grabbing
    -   3.3 Starting games in a separate X server
    -   3.4 Adjusting mouse detections
    -   3.5 Binaural Audio with OpenAL
    -   3.6 Tuning Pulseaudio
        -   3.6.1 Enabling realtime priority and negative nice level
        -   3.6.2 Using higher quality remixing for better sound
        -   3.6.3 Matching hardware buffers to Pulse's buffering
    -   3.7 Cgroups
        -   3.7.1 Option 1 - systemd (recommended)
        -   3.7.2 Option 2 - Ulatencyd
    -   3.8 Double check your CPU frequency scaling settings
-   4 Improving framerates and responsiveness with scheduling policies
    -   4.1 For Wine programs
    -   4.2 For everything else
        -   4.2.1 Policies
        -   4.2.2 Nice levels
        -   4.2.3 Core affinity
        -   4.2.4 General case
        -   4.2.5 Optimus, and other helping programs
-   5 Using alternate kernels
    -   5.1 Using BFQ
-   6 See also

Game environments
-----------------

Different environments exist to play games in Linux:

-   Native – Games written for Linux (usually free and open source).
-   Browser – you need only browser and Internet connection to play
    these types of games.
    -   Plugin-based – you need to install plugin to play.
        -   Java Webstart – used to install cross-platform games very
            easily.
        -   Flash games are very common on the Web.
        -   Unity – specialized game plugin for browsers. Currently
            works only in Google Chrome. Most games are commercial
            and/or closed-source.
    -   HTML 5 games use brand new canvas and WebGL technologies and
        work in all modern browsers but can be very slow on weak
        machines.
-   Specialized environments (software emulators) – – Required for
    running software designed for other architectures or systems, (Heed
    the copyright laws of your country!). Check the list of emulators
    for more details.
    -   Wine – allows running of some Windows games, as well as a large
        amount of Windows software. Wine does not slowdown most games
        (even speeds up some), so most games with low system
        requirements that run in Windows work in Wine too. Consult Wine
        AppDB for game-specific compability information.
    -   Crossover Games – members of the Codeweavers team are prime
        supporters of Wine. Using Crossover Games makes the installation
        & setting up of some games easier, more reliable & even
        possible, when compared to using other methods. Crossover is a
        paid commercial product, which also provides a forum where the
        developers are very much involved in the community.
    -   Cedega – game-oriented Wine derivative. Its packaged version is
        not free of charge unlike its CVS version.
    -   DosBox – DOS emulator
    -   scummvm – emulates games based on the SCUMM game engine, which
        ran many classic adventure games.
-   Hardware emulators – emulate the whole device instead of software
    environment. The same thing about Copyright here.

Getting games
-------------

> Native

A good number are available in the official repositories or in the AUR.
Loki provides installers for several games.

> Digital distributions

-   Desura — Digital distribution platform featuring indie games. It can
    be considered good source of games (if you don't care about security
    and bugs too much).

http://www.desura.com/ || desura

-   Steam — Famous digital distribution and communications platform
    developed by Valve, featuring popular games recently ported to Linux
    (by the company itself). It has a large library that includes Source
    (Half-Life 2) and Goldsource (HL1) engine games, Serious Sam 3,
    Brutal Legend, many of the games from Humble Bundles and some other
    indie titles.

http://store.steampowered.com || steam

-   Steam under Linux.
-   See linux-games catalog.

-   The Humble Store

-   itch.io

> Flash

Several huge Flash games portals exists, among them are:

-   https://armorgames.com/
-   https://www.kongregate.com/
-   https://www.newgrounds.com/

> Java

-   Lots of games smaller than 4kb (some are real masterpieces of game
    design) can be found at http://www.java4k.com.
-   https://www.pogo.com/ – biggest casual Java gaming portal
-   The Java Game Tome - huge database of primarily casual games

> Wine

-   Centralized source of information about running games (and other
    applications) in Wine is Wine AppDB.
-   See also Category:Wine.

Running games
-------------

Certain games or game types may need special configuration to run or to
run as expected. For the most part, games will work right out of the box
in Arch Linux with possibly better performance than on other
distributions due to compile time optimizations. However, some special
setups may require a bit of configuration or scripting to make games run
as smoothly as desired.

> Multi-screen setups

Running a multi-screen setup may lead to problems with fullscreen games.
In such a case, running a second X server is one possible solution.
Another solution may be found in the NVIDIA article (may also apply to
non-NVIDIA users).

> Keyboard grabbing

Many games grab the keyboard, noticeably preventing you from switching
windows (also known as alt-tabbing).

Some SDL games (e.g. Guacamelee) let you disable grabbing by pressing
Ctrl-g.

You can also download sdl-nokeyboardgrab to gain the ability to use
keyboard commands while in SDL games. If you wish to turn it up to 11,
you can disable keyboard grabbing at X11 level using
libx11-nokeyboardgrab, or with more fine-grained control with
libx11-ldpreloadnograb using the LD_PRELOAD environment variable to run
applications with particular grab prevention. Wine/lib32 users should
also look at the respective lib32 libraries.

Note:SDL is known to sometimes not be able to grab the input system. In
such a case, it may succeed in grabbing it after a few seconds of
waiting.

> Starting games in a separate X server

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Running     
                           program in separate X    
                           display.                 
                           Notes: same topic        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

In some cases like those mentioned above, it may be necessary or desired
to run a second X server. Running a second X server has multiple
advantages such as better performance, the ability to "tab" out of your
game by using Ctrl+Alt+F7/Ctrl+Alt+F8, no crashing your primary X
session (which may have open work on) in case a game conflicts with the
graphics driver. The new X server will be akin a remote access login for
the ALSA, so your user need to be part of the audio group to be able to
hear any sound.

To start a second X server (using Xonotic as an example) you can simply
do:

    $ xinit /usr/bin/xonotic-glx -- :1 vt$XDG_VTNR

This can further be spiced up by using a seperate X configuration file:

    $ xinit /usr/bin/xonotic-glx -- :1 -xf86config xorg-game.conf vt$XDG_VTNR

A good reason to provide an alternative xorg.conf here may be that your
primary configuration makes use of NVIDIA's Twinview which would render
your 3D games like Xonotic in the middle of your multiscreen setup,
spanned across all screens. This is undesirable, thus starting a second
X with an alternative config where the second screen is disabled is
advised.

A game starting script making use of Openbox for your home directory or
/usr/local/bin may look like this:

    ~/game.sh

    if [ $# -ge 1 ]; then
            game="$(which $1)"
            openbox="$(which openbox)"
            tmpgame="/tmp/tmpgame.sh"
            DISPLAY=:1.0
            echo -e "${openbox} &\n${game}" > ${tmpgame}
            echo "starting ${game}"
            xinit ${tmpgame} -- :1 -xf86config xorg-game.conf || exit 1
    else
            echo "not a valid argument"
    fi

So after a chmod +x you would be able to use this script like:

    $ ~/game.sh xonotic-glx

> Adjusting mouse detections

For games that require exceptional amount of mouse skill, adjusting the
mouse polling rate can help improve accuracy.

> Binaural Audio with OpenAL

For games using OpenAL, if you use headphones you may get much better
positional audio using OpenAL's HRTF filters. To enable, run the
following command:

    echo "hrtf = true" >> ~/.alsoftrc

Alternatively, install openal-hrtf from the AUR, and edit the options in
/etc/openal/alsoftrc.conf

For Source games, the ingame setting `dsp_slow_cpu` must be set to `1`
to enable HRTF, otherwise the game will enable it's own processing
instead. You will also either need to set up Steam to use native
runtime, or link its copy of openal.so to your own local copy. For
completeness, also use the following options:

    dsp_slow_cpu 1 # Disable in-game spatialiazation
    snd_spatialize_roundrobin 1 # Disable spatialization 1.0*100% of sounds
    dsp_enhance_stereo 0 # Disable DSP sound effects. You may want to leave this on, if you find it doesn't interfere with your perception of the sound effects.
    snd_pitchquality 1 # Use high quality sounds

> Tuning Pulseaudio

If you're using Pulseaudio, you may wish to tweak some default settings
to make sure it's running optimally.

Enabling realtime priority and negative nice level

Pulseaudio is built to be run with realtime priority, being an audio
daemon. However, because of security risks of it locking up the system,
it's scheduled as a regular thread by default. To adjust this, first
make sure you're in the audio group. Then, uncomment and edit the
following lines in /etc/pulse/daemon.conf:

    high-priority = yes
    nice-level = -11

    realtime-scheduling = yes
    realtime-priority = 5

and restart pulseaudio.

Using higher quality remixing for better sound

Pulseaudio on Arch uses speex-float-0 by default to remix channels,
which is considered a 'medium-low' quality remixing. If your system can
handle the extra load, you may benefit from setting it to one of the
following instead:

    resample-method = speex-float-10
    resample-method = src-sinc-best-quality

Matching hardware buffers to Pulse's buffering

Matching the buffers can reduce stuttering and increase performance
marginally. See here for more details.

> Cgroups

Cgroups are a kernel adjustment that allows processes to be grouped
together and prioritized in userspace, allowing for minimum latency.
They adjust several factors, such as IO prioritization and CPU
prioritization.

Option 1 - systemd (recommended)

Systemd is able to handle Cgroups less specifically by itself, in order
to make the system run smoothly with any number of threads running.

Simply install it to take advantage of this improvement.

Option 2 - Ulatencyd

Note:Ulatencyd seems to sometimes over-prioritize, especially when it
comes to block IO, which can often starve other threads from the same
process or process group. Systemd provides a much more lightweight
approach.

Ulatencyd is a daemon which uses dynamic cgroups to give the kernel
hints to reduce latency in the system. It comes with a number of
configs, and is extensively helpful in prioritizing disk I/O. Installing
it will again increase responsiveness and reduce input lag. To use,
simply install it and enable the ulatencyd systemd service.

In addition, Ulatencyd has it's own method for specifically reducing
latency in games, by focusing in on that one individual process. To take
advantage of this, add entries into /etc/ulatencyd/simple.d/games.conf:

    bit.trip.runner user.game
    hl2.exe         user.game
    /opt/cogs/*     user.game inherit=1

If you are using an SSD or simply have changed the default scheduler for
any block devices, it may be advisable to edit the default settings, as
Ulatencyd reverts the default scheduler back to cfq.

However, CFQ does seem to be best at load balancing when multiple
threads are involved, which is a very common arrangement for games. It's
best to try all available schedulers before settling on any particular
one.

> Double check your CPU frequency scaling settings

If your system is currently configured to properly insert its own cpu
frequency scaling driver, the system sets the default governor to
Ondemand. By default, this governor only adjusts the clock if the system
is utilizing 95% of its CPU, and then only for a very short period of
time. This saves power and reduces heat, but has a noticeable impact on
performance. You can instead only have the system downclock when it is
idle, by tuning the system governor. To do so, see
Cpufrequtils#Improving on-demand performance.

Improving framerates and responsiveness with scheduling policies
----------------------------------------------------------------

Most every game can benefit if given the correct scheduling policies for
the kernel to prioritize the task. However, without the help of a
daemon, this rescheduling would have to be carried out manually or
through the use of several daemons for each policy. These policies
should ideally be set per-thread by the application itself, but not all
developers implement these policies. There are several methods for
getting them to work anyway:

> For Wine programs

wine-rt is a patched version of Wine that implements scheduling policies
on a per-thread basis, using the equivalent of what the Windows
developers had intended the threads to be run at. The default patch is
more oriented towards professional audio users, and tends to be too
heavy-handed of an approach for gaming. You may instead wish to use this
patch, which also includes nice levels and uses more than one policy
decision. Be warned that it uses SCHED_ISO, which is only properly
implemented on Linux-ck, and will simply renice
THREAD_PRIORITY_ABOVE_NORMAL threads if your system does not support it.

> For everything else

For programs which do not implement scheduling policies on their own,
one tool known as schedtool, and it's associated daemon schedtoold can
handle many of these tasks automatically. To edit what programs relieve
what policies, simply edit /etc/schedtoold.conf and add the program
followed by the schedtool arguments desired.

Policies

First and foremost, setting the scheduling policy to SCHED_ISO will not
only allow the process to use a maximum of 80 percent of the CPU, but
will attempt to reduce latency and stuttering wherever possible.
SCHED_ISO requires Linux-ck to operate, as it has only been implemented
in that kernel. Linux-ck itself provides a hefty latency reduction, and
should ideally be installed Most if not all games will benefit from
this:

    bit.trip.runner -I

For users not using Linux-ck, SCHED_FIFO provides an alternative, that
can even work better. You should test to see if your applications run
more smoothly with SCHED_FIFO, in which case by all means use it
instead. Be warned though, as SCHED_FIFO runs the risk of starving the
system! Use this in cases where -I is used below:

    bit.trip.runner -F -p 15

Nice levels

Secondly, the nice level sets which tasks are processed first, in
ascending order. A nice level of -4 is reccommended for most multimedia
tasks, including games:

    bit.trip.runner -n -4

Core affinity

There is some confusion in development as to whether the driver should
be multithreading, or the program. In any case where they both attempt
it, it causes drops in framerate and crashes. Examples of this include a
number of modern games, and any Wine program which is running without
GLSL disabled. To select a single core and allow only the driver to
handle this process, simply use the -a 0x# flag, where # is the core
number, e.g.:

    bit.trip.runner -a 0x1

uses first core. Some CPUs are hyperthreaded and have only 2 or 4 cores
but show up as 4 or 8, and are best accounted for:

    bit.trip.runner -a 0x5

which use virtual cores 0101, or 1 and 3.

General case

For most games which require high framerates and low latency, usage of
all of these flags seems to work best. Affinity should be checked
per-program, however, as most native games can understand the correct
usage. For a general case:

    bit.trip.runner -I -n -4
    Amnesia.bin64 -I -n -4
    hl2.exe -I -n -4 -a 0x1 #Wine with GLSL enabled

etc.

Optimus, and other helping programs

As a general rule, any other process which the game requires to operate
should be reniced to a level above that of the game itself. Strangely,
Wine has a problem known as reverse scheduling, it can often have
benefits when the more important processes are set to a higher nice
level. Wineserver also seems unconditionally to benefit from SCHED_FIFO,
since rarely consumes the whole CPU and needs higher prioritization when
possible.

    optirun -I -n -5
    wineserver -F -p 20 -n 19
    steam.exe -I -n -5

Using alternate kernels
-----------------------

The stock Arch kernel provides a very good baseline for general usage.
However, if your system has less than 16 cores and is intended for use
primarily as a workstation, you can sacrifice a small amount of
throughput on batch workloads and gain a significant boost to
interactivity by using Linux-ck. If you prefer not to compile your own
kernel, you can instead add Repo-ck and use one of their kernels. Using
a pre-optimized kernel will most definitely offset any loss of
throughput that may have occurred as a result, so be sure to select the
appropriate kernel for your architecture.

> Using BFQ

BFQ is an io-scheduler that comes as a feature of Linux-ck, and is
optimized to be much more simplistic, but provides better interactivity
and throughput for non-server workloads. To enable, see
Linux-ck#How_to_Enable_the_BFQ_I.2FO_Scheduler. It is important to note
that although most guides recommend using either noop or deadline for
SSDs for their raw throughput, they are actually detrimental to
interactivity when more than one thread is attempting to access the
device. It's best to use bfq unless you desperately need the throughput
advantage.

See also
--------

-   LinuxGames - News on linux games
-   Free Gamer - Open source games blog
-   FreeGameDev - Free/open source game development community
-   SIG/Games - OS/Linux gaming news sites and lists at Fedora's wiki
-   live.linux-gamers - Arch-based live gaming distro
-   Games on Linux - Commercial games on Linux
-   Gaming on Linux - Active Linux gaming news and editorial source and
    community

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gaming&oldid=305830"

Category:

-   Gaming

-   This page was last modified on 20 March 2014, at 11:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
