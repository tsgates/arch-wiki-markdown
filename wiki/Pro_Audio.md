Pro Audio
=========

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: describe         
                           irqbalance (Discuss)     
  ------------------------ ------------------------ ------------------------

Summary

Information on using Arch Linux for (semi-)professional audio

Related

Unofficial User Repositories

envy24control

ArchAudio

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
|     -   1.1 Pro Audio on Arch Linux                                      |
|                                                                          |
| -   2 Getting Started                                                    |
|     -   2.1 System Configuration                                         |
|     -   2.2 JACK                                                         |
|         -   2.2.1 FireWire                                               |
|         -   2.2.2 Jack Flash                                             |
|         -   2.2.3 Quickscan Jack script                                  |
|                                                                          |
|     -   2.3 A General Example                                            |
|                                                                          |
| -   3 Realtime Kernel                                                    |
|     -   3.1 ABS                                                          |
|     -   3.2 AUR                                                          |
|                                                                          |
| -   4 MIDI                                                               |
| -   5 Environment Variables                                              |
| -   6 Tips and Tricks                                                    |
| -   7 Hardware                                                           |
|     -   7.1 M-Audio Delta 1010                                           |
|     -   7.2 M-Audio Fast Track Pro                                       |
|     -   7.3 PreSonus Firepod                                             |
|                                                                          |
| -   8 Restricted Software                                                |
|     -   8.1 Steinberg's SDKs                                             |
|                                                                          |
| -   9 Arch Linux Pro Audio Project                                       |
| -   10 Linux and Arch Linux Pro Audio in the News                        |
+--------------------------------------------------------------------------+

Introduction
------------

Modern Linux systems are more than capable of supporting your
(semi-)professional audio needs. Latencies of 5ms down to even as low as
1ms can be achieved with good hardware and proper configuration. You
could even run an industrial laser alongside your DAW (Digital audio
workstation).

We believe Arch Linux provides competent users the right "framework" to
sculpt their very own dedicated machines for recording, mixing,
mastering, sound-design, DSP programming, and what have you. More often
than not, when a "linux audio user" thinks of "sculpting", he thinks of
"Gentoo". It is unknown what has led to such fallacious thinking, but
needless to say, "compiling", "learning" and "performance" have as much
to do with each other as "differences in rendering quality between
Cubase and Pro Tools".

> Pro Audio on Arch Linux

-   Binary-based

Arch is primarily a (meta-)distribution comprising binary packages, with
a system for easy source-based package management as well. No need to
waste time/CPU cycles, you just work™. This leads to "Third-party
Repositores" below.

-   KISS

The philosophy of Arch requires packages to remain as vanilla as
possible. You get what upstream software developers want you to get,
including no-nonsense and straightforward package names with all
headers. No more headaches due to missing development files when
building a new Linux audio application.

-   Rolling-release

Arch is fast-paced in releasing updates and deprecating the old,
following upstream schedules. Linux Audio is, to a certain extent, an
experimental paradigm. Arch allows you to be up-to-date in order to keep
up with your favourite audio software.

-   Pragmatic

Arch is agnostic with regards to licenses of software - it includes
packages in the official repositories which "taint" the freedom of a
distribution, but otherwise are popular and/or useful. This is also
possible because Arch is not a complete "distribution", i.e releases are
in fact only snapshots of the system with base packages only. License
information is clearly available with every package without the need for
installation, so it is up to the user to decide what he or she installs.

-   ABS

Arch provides a simple BSD Ports-like source packaging system, allowing
the user to easily compile software via a buildscript ("recipe") and
pass the resulting binary to the package manager. This way, any and all
kinds of software, regardless of where they are from, can be monitored
by the system. The number of new Linux audio software is always growing,
so this is definitely a plus if the only way to get them is to build
them from source.

-   AUR

Arch has an "unsupported" repository (AUR) of buildscripts open to all
registered users for contribution, with thousands of ready-to-compile
packages. Made for and by Arch Linux users. If something was released
yesterday that would significantly help a number of users like you,
chances are that today it has already been uploaded to the AUR.

-   Third-party Repositories

Arch in no way interrupts users when it comes to unofficial repositories
that offer ready-to-run binary packages. It is simply a matter of adding
one to the current list, and this is just in one file. No confusing
"Whory Warthong", "Denim Jacket", "sources.list", or "source.keys" to
worry about when you come across a new audio repository. We can afford
to skip PEBKAC safeguards, because we expect users to know what they are
doing. This means deciding on whether using a particular binary
repository is "safe". For third-party Arch Linux binaries of audio
software, we have this.

Q: So should I use Arch Linux (as my DAW)? I have been using Distro X so
far..

A: If such is your question, we are sorry to inform you that the answer
is negative.

"Arch Linux does not find Archers, Archers find Arch Linux." - Hercules
on Arch and Archers

Getting Started
---------------

Some of the major pro audio applications are already available from the
official and community Arch Linux repositories. For anything which is
not, you can either add a binary repository (see further down below) or
if you prefer to compile, search the AUR. Nothing stops you from
building directly off of upstream releases, but then you might as well
run LFS.

Start by installing either jack or jack2 (see below) from the official
repositories.

The following packages are a good start to build a full-featured pro
audio system:

-   qjackctl
-   patchage
-   ardour
-   qtractor
-   hydrogen
-   rosegarden
-   qsynth
-   jsampler
-   lmms
-   dssi

Additionally, if you are on a 64-bit installation and need to run 32-bit
applications that require jack or jack2, install lib32-jack or
jack2-multilib from the multilib repository, respectively.

Other packages you may need that are available from the AUR:

-   traverso
-   qsampler (also see Linuxsampler)
-   fst-git
-   jost
-   wineasio

> System Configuration

Tip:You may want to consider the following often seen system
optimizations:

-   Install linux-rt kernel and include threadirqs in your kernel boot
    line (also possible with regular kernels >=2.6.39).
-   Install the systemd-rtirq package and enable the rtirq service using
    systemd.
-   Add yourself to the audio group.
-   Set the cpufreq governor to performance.
-   Add noatime to the filesystem mount options (see Maximizing
    Performance).

Realtime configuration has mostly been automated. There is no longer any
need to edit files like /etc/security/limits.conf for realtime access.
However, if you must change the settings, see
/etc/security/limits.d/99-audio.conf and
/lib/udev/rules.d/40-hpet-permissions.rules (these files are provided by
jack or jack2). Additionaly, you may want to increase the highest
requested RTC interrupt frequency (default is 64 Hz) by adding to
/etc/rc.local something like this:

    echo 2048 > /sys/class/rtc/rtc0/max_user_freq
    echo 2048 > /proc/sys/dev/hpet/max-user-freq

By default, swap frequency defined by "swappiness" is set to 60. By
reducing this number to 10, the system will wait much longer before
trying to write to disk. Then, there's inotify which watches for changes
to files and reports them to applications requesting this information.
When working with lots of audio data, a lot of watches will need to be
kept track of, so they will need to be increased. These two settings can
be adjusted in /etc/sysctl.conf (file owned by procps).

    vm.swappiness = 10
    fs.inotify.max_user_watches = 524288

You may also want to maximize the PCI latency timer of the PCI sound
card and raise the latency timer of all other PCI peripherals (default
is 64).

    $ setpci -v -d *:* latency_timer=b0
    $ setpci -v -s $SOUND_CARD_PCI_ID latency_timer=ff # eg. SOUND_CARD_PCI_ID=03:00.0 (see below)

The SOUND_CARD_PCI_ID can be obtained like so:

    $ lspci ¦ grep -i audio
    03:00.0 Multimedia audio controller: Creative Labs SB Audigy (rev 03)
    03:01.0 Multimedia audio controller: VIA Technologies Inc. VT1720/24 [Envy24PT/HT] PCI Multi-Channel Audio Controller (rev 01)

The steps below are mostly to double-check that you have a working
multimedia system:

-   Have I set up sound properly? See ALSA or OSS.

    $ speaker-test

-   Am I in the audio group? See ALSA or OSS.

    $ groups | grep audio

-   Is PulseAudio, OSS or something else grabbing my device?

    $ lsof +c 0 /dev/snd/pcm* /dev/dsp*

-OR-

    $ fuser -fv /dev/snd/pcm* /dev/dsp*  

-   Is PAM-security and realtime working OK?

See: Realtime for Users (Pay special attention especially if you do not
run KDM, GDM or Slim.)

-   Have I rebooted after having done all that?

> JACK

The aim here is to find the best possible combination of buffer size and
periods, given the hardware you have. Frames/Period = 256 is a sane
starter. For onboard and USB devices, try Periods/Buffer = 3. Commonly
used values are: 256/3, 256/2, 128/3.

Also, the sample rate must match the hardware sample rate. To check what
sample and bit rates your device supports:

    $ cat /proc/asound/card0/codec#0

Replace card0 and codec#0 depending on what you have. You will be
looking for rates or VRA in Extended ID. A common sample rate across
many of today's devices is 48000 Hz. Others common rates include 44100
Hz and 96000 Hz.

Almost always, when recording or sequencing with external gear is
concerned, realtime is a must. Also, you may like to set maximum
priority (at least 10 lower than system limits defined in
/etc/security/limits.d/99-audio.conf); the highest is for the device
itself).

Start jack with the options you just found out:

    $ /usr/bin/jackd -R -P89 -dalsa -dhw:0 -r48000 -p256 -n3

qjackctl and patchage are two GUI front-ends. For jack2 qjackctl is not
nessesary, a lightweight alternative with less features can be
sufficient, since applications like ardour or patchage already take care
of client connections and smoothly adjusting the buffer size.

Note:Once you set up JACK, try different audio applications to test your
configuration results. I spent days trying to troubleshoot JACK xrun
issues with LMMS which in the end turned out to be the problem with the
latter.

Further reading:
http://w3.linux-magazine.com/issue/67/JACK_Audio_Server.pdf

FireWire

Note:Nothing much is needed to be done as most things have been
automated, especially with the introduction of the new FireWire stack,
deprecation of HAL and more focus on udev. You should not need to edit
device permissions, but if you suspect that your device may not be
working due to such issues, see /lib/udev/rules.d/60-ffado.rules and if
needed, create and put your changes into
/etc/udev/rules.d/60-ffado.rules. Most often than not, your device will
work with the libffado-svn development version of the driver.

JACK(2) is built against FFADO, you only need to install it with the
libffado package.

To test whether you have any chances of getting FireWire devices to
work:

-   Ensure the proper kernel modules are loaded:

    # modprobe firewire-core firewire-ohci

-   Is my chipset sane enough to initiate a device?

http://www.ffado.org/?q=node/622

-   Is my chipset sane enough to make a device work to its capacity?

We cannot say for sure, particularly for those based on Ricoh
(cross-platform issue). Most of the time, your device will run fine, but
on occasion you will be faced with funny quirks. For unlucky ones, you
will be facing hell.

Jack Flash

If after getting jack setup you will find that Flash has no audio.

In order to get flash to work with jack you will need to install
libflashsupport-jack from the AUR.

You can also use more flexible method to allow Alsa programs (including
Flash) play sound while jack is running:

First you must install the jack plugin for Alsa by installing
alsa-plugins from the official repositories. Enable it by editing (or
creating) /etc/asound.conf (system wide settings) to have these lines:

    # convert alsa API over jack API
    # use it with
    # % aplay foo.wav

    # use this as default
    pcm.!default {
        type plug
        slave { pcm "jack" }
    }

    ctl.mixer0 {
        type hw
        card 1
    }

    # pcm type jack
    pcm.jack {
        type jack
        playback_ports {
            0 system:playback_1
            1 system:playback_2
        }
        capture_ports {
            0 system:capture_1
            1 system:capture_2
        }
    }

You do not need to restart your computer or anything. Just edit the alsa
config files, start up jack.

Quickscan Jack script

Most people will probably want to run jack in realtime mode, there are
however a lot of knobs and buttons to press in order for that to happen.

A great way to quickly diagnose your system and find out what it is
missing in order to have jack work properly in real time mode is to run
the Quickscan script.

http://realtimeconfigquickscan.googlecode.com/hg/realTimeConfigQuickScan.pl

(or just install realtimeconfigquickscan from AUR)

The output should tell you where your system is lacking and will point
you to places to find more information.

> A General Example

A general configuration example is here.

Realtime Kernel
---------------

Since a while ago, the stock Linux kernel has proven to be adequate for
realtime uses. The stock kernel (with CONFIG_PREEMPT=y, default in Arch)
can operate with a worst case latency of upto 10ms (time between the
moment an interrupt occurs in hardware, and the moment the corresponding
interrupt-thread gets running), although some device drivers can
introduce latency much worse than that. So depending on your hardware
and driver (and requirement), you might want a kernel with hard realtime
capabilities.

The RT_PREEPMT patch by Ingo Molnar and Thomas Gleixner is an
interesting option for hard and firm realtime applications, reaching
from professional audio to industrial control. Most audio-specific
distro Linux ships with this patch applied. A realtime-preemptible
kernel will also make it possible to tweak priorities of IRQ handling
threads and help ensure smooth audio almost regardless of the load.

If you are going to compile your own kernel, remember that removing
modules/options does not equate to a "leaner and meaner" kernel. It is
true that the size of the kernel image is reduced, but in today's
systems it is not as much of an issue as it was back in 1995.

In any way, you should also ensure that:

-   Timer Frequency is set to 1000Hz (CONFIG_HZ_1000=y; if you do not do
    MIDI you can ignore this)
-   APM is DISABLED (CONFIG_APM=n; Troublesome with some hardware -
    default in x86_64)

If you truly want a slim system, we suggest you go your own way and
deploy one with static /devs. You should, however, set your CPU
architecture. Selecting "Core 2 Duo" for appropriate hardware will allow
for a good deal of optimisation, but not so much as you go down the
scale.

General issue(s) with (realtime) kernels:

-   Hyperthreading (if you suspect, disable in BIOS)

There are ready-to-run/compile patched kernels available in the ABS and
AUR.

Note:Before you decide to use a patched kernel, see
http://jackaudio.org/realtime_vs_realtime_kernel.

> ABS

You can use ABS to recompile linux with the patch. However, this is not
the most useful of methods since updates will overwrite your custom
kernel (at least you should add IgnorePkg=linux to /etc/pacman.conf).

> AUR

From the AUR itself, you have the following options:

-   linux-rt
-   linux-rt-lts (Long Term Support, stable release)
-   linux-rt-ice

The first two are standard kernels with the CONFIG_PREEMPT_RT patch,
while -ice includes patches some may consider to be nasty, while to
others are a blessing.

See: Real-Time Linux Wiki

MIDI
----

To work with MIDI you can it is highly recommended that you install a2j,
a bridge between alsa midi and jack midi. It allows you to connect
applications that only communicate with alsa midi to applications that
only use jack midi. Laditray can also start/stop a2j.

See: JACK#MIDI

Environment Variables
---------------------

If you install things to non-standard directories, it is often necessary
to set environment path variables so that applications know where to
look (for plug-ins and other libraries). This usually affects only VST
since users might have a Wine or external Windows location.

We would usually not have Linux plug-ins (LADSPA, LV2, DSSI, LXVST)
beyond standard paths, so it is not necessary to export them. But if you
do, be sure to include those standard paths as well since Arch does not
do anything for dssi or ladspa, and some applications like dssi-vst will
not look anywhere else if it finds predefined paths.

    ~/.bashrc

    ...
    export VST_PATH=/usr/lib/vst:/usr/local/lib/vst:~/.vst:/someother/custom/dir
    export LXVST_PATH=/usr/lib/lxvst:/usr/local/lib/lxvst:~/.lxvst:/someother/custom/dir
    export LADSPA_PATH=/usr/lib/ladspa:/usr/local/lib/ladspa:~/.ladspa:/someother/custom/dir
    export LV2_PATH=/usr/lib/lv2:/usr/local/lib/lv2:~/.lv2:/someother/custom/dir
    export DSSI_PATH=/usr/lib/dssi:/usr/local/lib/dssi:~/.dssi:/someother/custom/dir

Tips and Tricks
---------------

-   IRQ issues can occur and cause problems. An example is video
    hardware reserving the bus, causing needless interrupts in the
    system I/O path. See discussion at FFADO IRQ Priorities How-To. If
    you have a realtime or a recent kernel, you can use this helpful
    script rtirq to adjust priorities of IRQ handling threads. Also
    available as systemd-rtirq.

-   Do not use the irqbalance daemon, or do so carefully [1].

-   Some daemons/processes can unexpectedly cause xruns. If you do not
    need it - kill it. No questions asked.

    $ ls /var/run/daemons
    $ top # or htop, ps aux, whatever you are comfortable with
    $ killall -9 $processname
    # systemctl stop $daemonname

-   If you are facing a lot of xruns especially with nvidia, disable
    your GPU throttling. This can be done via the card's control applet
    and for nvidia it is "prefer maximum performance" (thanks to a mail
    in LAU by Frank Kober).

-   You may like to read more on ALSA:
    http://www.volkerschatz.com/noise/alsa.html

Hardware
--------

> M-Audio Delta 1010

The M-Audio Delta series cards are based on the VIA Ice1712 audio
chipset. Cards using this chip require that you install the alsa-tools
package, because it contains the envy24control program. Envy24control is
a hardware level mixer/controller. You can use alsa-mixer but you will
save yourself some hassle not to try it. Note that this section has no
information on MIDI setup or usage.

Open the mixer application:

    $ envy24control

This application can be more than a bit confusing; see envy24control for
guidance on its use. That said, here is a very simple working setup for
multitracking with Ardour.

1.  On the "Monitor Inputs" and "Monitor PCMs" tabs, set all monitor
    inputs and monitor PCM's to around 20.
2.  On the "Patchbay / Router" tab, set all to PCM out.
3.  On the "Hardware Settings" tab, verify that the Master Clock setting
    matches what is set in Qjackctl. If these do not match you will have
    xruns out of control!

> M-Audio Fast Track Pro

The M-Audio Fast Track Pro is an USB 4x4 audio interface, working at
24bit/96kHz. Due to limitation of USB 1, this device requires additional
setup to get access to all its features. Device works in one of two
configuration:

-   Configuration 1, or "Class compliant mode" - with reduced
    functionality, only 16bit, 48kHz, analogue input (2 channels) and
    digital/analogue output (4 channels).
-   Configuration 2 - with access to all features of interface.

Currently with stock kernel it runs in configuration 2, but if you want
to make sure in what mode you are, you can check kernel log for entries:

    usb-audio: Fast Track Pro switching to config #2
    usb-audio: Fast Track Pro config OK

The interface also needs extra step of cofiguration to switch modes. It
is done using option device_setup during module loading. The recommended
way to setup the interface is using file in modprobe.d:

    /etc/modprobe.d/ftp.conf

    options snd_usb_audio vid=0x763 pid=0x2012 device_setup=XXX index=YYY enable=1

where vid and pid are vendor and product id for M-Audio Fast Track Pro,
index is desired device number and device_setup is desired device setup.
Possible values for device_setup are:

  device_setup value   bit depth   frequency   analog output   digital output   analog input   digital input   IO mode
  -------------------- ----------- ----------- --------------- ---------------- -------------- --------------- ------------
  0x0                  16 bit      48kHz       +               +                +              +               4x4
  0x9                  24 bit      48kHz       +               +                +              -               2x4
  0x13                 24 bit      48kHz       +               +                -              +               2x4
  0x5                  24 bit      96kHz       *               *                *              *               2x0 or 0x2

  :  device modes

The 24 bit/96kHz mode is special: it provides all input/output, but you
can open only one of 4 interfaces at a time. If you for example open
output interface and then try to open second output or input interface,
you will see error in kernel log:

    cannot submit datapipe for urb 0, error -28: not enough bandwidth

which is perfectly normal, because this is USB 1 device and cannot
provide enough bandwidth to support more than single (2 channel)
destination/source of that quality at a time.

Depending on the value of index it will setup two devices: hwYYY:0 and
hwYYY:1, which will contain available inputs and outputs. First device
is most likely to contain analog output and digital input, while second
one will contain analog input and digital output. To find out which
devices are linked where and if they are setup correctly, you can check
/proc/asound/cardYYY/stream{0,1} . Below is list of important endpoints
that will help in correctly identifying card connections (it easy to
mistake analog and digital input or output connections before you get
used to the device):

    EP 3 (analgoue output = TRS on back, mirrored on RCA outputs 1 and 2 on back)
    EP 4 (digital output = S/PDIF output on back, mirrored on RCA outputs 3 and 4 on back)
    EP 5 (analogue input = balanced TRS or XLR microphone, unbalanced TS line on front)
    EP 6 (digital input = S/PDIF input on back)

> PreSonus Firepod

1.  Startup: Either from command line or QjackCtl, the driver is called
    firewire.
2.  Specs: The card contains 8/8 preamp'ed XLR plus a stereo pair, in
    total 10 channels.
3.  Linking: Cards can be linked together without any problems.
4.  Hardware Settings: Nothing particular, tweak the settings in
    QjackCtl to your likings.

Volume levels are hardware and routing can be done through QjackCtl,
even with more cards linked together, this is not a problem. The
ffadomixer does not work with this card yet, hopefully in the future we
can control more aspects of the card through a software interface like
that.

Restricted Software
-------------------

> Steinberg's SDKs

It is very clear - we can distribute neither the VST nor the ASIO
headers in binary package form. However, whenever you are building a
program which would host Windows .dll VST plug-ins, check for the
following hints (that do not require use of any SDK):

-   dssi-vst
-   fst
-   vestige

With that said, if you are building a program which would host native
.so VST plug-ins, then there is no escape. For such cases, Arch yet
again allows us to maintain a uniform local software database. We can
"install" the SDK system-wide - you simply have to download it yourself
and place it in the packaging directory.

Get them from AUR

Note: Steinberg does not forbid redistribution of resulting products,
nor dictate what license they can be under. There are many GPL-licensed
VST plug-ins. As such, distributing binary packages of software built
with these restricted headers is not a problem, because the headers are
simply buildtime dependencies.

Arch Linux Pro Audio Project
----------------------------

Yes, we have one. Think of "Planet CCRMA" or "Pro Audio Overlay", less
the academic connotations of the former: ArchAudio.

What this means is that the repositories are add-ons, i.e you need to
have a running, sane Arch Linux installation.

It is a relatively new effort although the initiative has been around
since 2006/2007.

History: https://bbs.archlinux.org/viewtopic.php?id=30547

For all your Arch- and ArchAudio-related audio issues hop on to IRC:
#archaudio @ Freenode

Linux and Arch Linux Pro Audio in the News
------------------------------------------

-   Build a Serious Multimedia Production Workstation with Arch -
    Linux.com article, July 2012

-   An Arch Tale - Article by fellow musician and writer Dave Phillips,
    October 2011

-   From Windows to Linux: a sound decision - Interview with Geoff
    "songshop" Beasley, February 2010

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pro_Audio&oldid=254108"

Category:

-   Audio/Video
