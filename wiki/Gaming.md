Gaming
======

> Summary

Provides information about running games and related system
configuration tips.

> Related

List of Applications/Games

Netbook Games

Xorg

NVIDIA#Gaming using Twinview

This page only contains information about running games and related
system configuration tips. For lists of popular games for GNU/Linux see
List of Applications/Games and Netbook Games.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Game Environments                                                  |
| -   2 Getting games                                                      |
|     -   2.1 Native                                                       |
|     -   2.2 Wine                                                         |
|     -   2.3 Flash                                                        |
|     -   2.4 Java                                                         |
|                                                                          |
| -   3 Running games in Arch                                              |
|     -   3.1 Multi-screen setups                                          |
|     -   3.2 Keyboard Grabbing                                            |
|     -   3.3 Starting games in a separate X server                        |
|     -   3.4 Adjusting mouse detections                                   |
|     -   3.5 HRTF filters with OpenAL                                     |
|     -   3.6 Tuning Pulseaudio                                            |
|         -   3.6.1 Enabling realtime priority and negative nice level     |
|         -   3.6.2 Using higher quality remixing for better sound         |
|         -   3.6.3 Matching hardware buffers to Pulse's buffering         |
|                                                                          |
|     -   3.7 Cgroups                                                      |
|         -   3.7.1 Option 1 - Systemd (Recommended)                       |
|         -   3.7.2 Option 2 - Ulatencyd                                   |
|                                                                          |
|     -   3.8 Double check your CPU frequency scaling settings             |
|                                                                          |
| -   4 Improving framerates and responsiveness with scheduling policies   |
|     -   4.1 For Wine programs                                            |
|     -   4.2 For everything else                                          |
|         -   4.2.1 Policies                                               |
|         -   4.2.2 Nice levels                                            |
|         -   4.2.3 Core affinity                                          |
|         -   4.2.4 General case                                           |
|         -   4.2.5 Optimus, and other helping programs                    |
|                                                                          |
| -   5 Using alternate kernels                                            |
|     -   5.1 Using BFQ                                                    |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Game Environments
-----------------

Different environments exist to play games in Linux:

-   Native – Games written for Linux (usually Free & Open Source).
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
    running software designed for other architectures or systems (Heed
    the copyright laws of your country!)
    -   Wine – allows running of some Windows games, as well as a large
        amount of Windows software.
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

A good number are available in the Official repositories or in the AUR.
Loki provides installers for several games. Desura can be considered
good source of games (if you don't care about security and bugs too
much).

> Wine

-   Centralized source of information about running games (and other
    applications) in Wine is Wine AppDB.
-   See also Category:Wine.

> Flash

Several huge flash games portals exists, among them are:

-   https://armorgames.com/
-   https://www.kongregate.com/
-   https://www.newgrounds.com/

> Java

-   Lots of games smaller than 4kb (some are real masterpieces of game
    design) can be found at http://www.java4k.com.
-   https://www.pogo.com/ – biggest casual Java gaming portal
-   The Java Game Tome - huge database of primarily casual games

Running games in Arch
---------------------

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

> Keyboard Grabbing

Many games grab the keyboard, noticeably preventing you from switching
windows (also known as alt-tabbing). Download sdl-nokeyboardgrab to gain
the ability to use keyboard commands while in SDL games. If you wish to
turn it up to 11, you can disable keyboard grabbing at X11 level using
libx11-nokeyboardgrab, or with more fine-grained control with
libx11-ldpreloadnograb using the LD_PRELOAD environment variable to run
applications with particular grab prevention. Wine/lib32 users should
also look at the respective lib32 libraries.

Note: SDL is known to sometimes not be able to grab the input system. In
such a case, it may succeed in grabbing it after a few seconds of
waiting.

> Starting games in a separate X server

In some cases like those mentioned above, it may be necessary or desired
to run a second X server. Running a second X server has multiple
advantages such as better performance, the ability to "tab" out of your
game by using CTRL-ALT-F7 / CTRL-ALT-F8, no crashing your primary X
session (which may have open work on) in case a game conflicts with the
graphics driver. To start a second X server (using Nexuiz as an example)
you can simply do:

    xinit /usr/bin/nexuiz-glx -- :1

This can further be spiced up by usi ng a seperate X configuration file:

    xinit /usr/bin/nexuiz-glx -- :1 -xf86config xorg-game.conf 

A good reason to provide an alternative xorg.conf here may be that your
primary configuration makes use of NVIDIA's Twinview which would render
your 3D games like Nexuiz in the middle of your multiscreen setup,
spanned across all screens. This is undesirable, thus starting a second
X with an alternative config where the second screen is disabled is
advised.

A game starting script making use of Openbox for your home directory or
/usr/local/bin may look like this:

    $ cat ~/game.sh
    if [ $# -ge 1 ]; then
      game="`which $1`"
      openbox="`which openbox`"
      tmpgame="/tmp/tmpgame.sh"
      DISPLAY=:1.0
      echo -e "${openbox} &\n${game}" > ${tmpgame}
      echo "starting ${game}"
      xinit ${tmpgame} -- :1 -xf86config xorg-game.conf || exit 1
    else
      echo "not a valid argument"
    fi

So after a chmod +x you would be able to use this script like:

    $ ~/game.sh nexuiz-glx

> Adjusting mouse detections

For games that require exceptional amount of mouse skill, adjusting the
response rate can help improve accuracy. Read more here.

> HRTF filters with OpenAL

For games using OpenAL, if you use headphones you may get much better
positional audio using OpenAL's HRTF filters. To enable, edit
/etc/openal/alsoft.conf (Or copy the example configuration file if it
doesn't exist) and change:

    #hrtf = false

to

    hrtf = true

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

Option 1 - Systemd (Recommended)

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
simply install and add to your DAEMONS in rc.conf.

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
Cpufrequtils#Improving_on-demand_performance.

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

wine-rt is a patched version of WINE that implements scheduling policies
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
one tool known as schedtool, and it's associated daemon schedtoold
(available on the AUR) can handle many of these tasks automatically. To
edit what programs relieve what policies, simply edit
/etc/schedtoold.conf and add the program followed by the schedtool
arguments desired.

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
number of modern games, and any WINE program which is running without
GLSL disabled. To select a single core and allow only the driver to
handle this process, simply use the -a 0x# flag:

    bit.trip.runner -a 0x1 #Use cores 1

Some CPUs are hyperthreaded and have only 2 or 4 cores but show up as 4
or 8, and are best accounted for:

    bit.trip.runner -a 0x5 #Use virtual cores 0101, or 1 and 3

General case

For most games which require high framerates and low latency, usage of
all of these flags seems to work best. Affinity should be checked
per-program, however, as most native games can understand the correct
usage. For a general case:

    bit.trip.runner -I -n -4
    Amnesia.bin64 -I -n -4
    hl2.exe -I -n -4 -a 0x1 #Wine with GLSL enabled

etc, etc.

Optimus, and other helping programs

As a general rule, any other process which the game requires to operate
should be reniced to a level above that of the game itself. Strangely,
Wine has a problem known as 'reverse scheduling', it can often have
benefits when the more important processes are set to a higher nice
level. Wineserver also seems unconditionally to benefit from SCHED_FIFO,
since rarely consumes the whole CPU and needs higher prioritization when
possible.

    optirun -I -n -5
    wineserver -F -p 20 -n 19
    steam.exe -I -n -5

Using alternate kernels
-----------------------

The stock ARCH kernel provides a very good baseline for general usage.
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
-   Games on Linux - Commercial Games On Linux
-   Gaming on Linux - An active Linux gaming news and editorial source
    and community

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gaming&oldid=254710"

Category:

-   Gaming
