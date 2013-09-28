Sound system
============

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: describe usage   
                           of schedtool/nice with   
                           sound server (Discuss)   
  ------------------------ ------------------------ ------------------------

This article is about basic sound management. For advanced topics see
Pro Audio.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 General information                                                |
| -   2 Drivers and Interface                                              |
| -   3 Sound servers                                                      |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

General information
-------------------

Arch sound system consists of several levels:

-   Drivers and interface – hardware support and control

-   Usermode API (libraries) – utilized and required by applications

-   (optional) Usermode sound servers – best for the complex desktop,
    needed for multiple simultaneous audio apps, and vital for more
    advanced capabilities e.g. pro audio

-   (optional) Sound frameworks – higher-level application environments
    not involving server processes

Default Arch installation already includes kernel sound system, namely
ALSA, and lots of utilities for it, to be installed from official
repositories. Ones who want additional features can switch to another
one (namely OSS) or install one of several sound servers.

Drivers and Interface
---------------------

-   The Advanced Linux Sound Architecture (ALSA) — A Linux kernel
    component providing device drivers and lowest-level support for
    audio hardware.

http://www.alsa-project.org/ || present in stock kernel

-   The Open Sound System (OSS) — An alternative sound architecture for
    Unix-like and POSIX-compatible systems. OSS version 3 was the
    original sound system for Linux and is in the kernel, but was
    superceded by ALSA in 2002 when OSS version 4 became proprietary
    software. OSSv4 became free software again in 2007 when 4Front
    Technologies released its source code and provided it under the GPL.
    Does not support as wide a variety of hardware as ALSA, but does
    better for some.

http://www.opensound.com/ || oss

Sound servers
-------------

-   PulseAudio — A very popular sound server, usable by most common
    desktop Linux applications today. Very good at handling multiple
    simultaneous inputs, and can do network audio as well. Very easy to
    get working, in fact very often all one has to do is install the
    package and it will automatically run. Not intended for pro audio
    low-latency applications.

http://www.pulseaudio.org/ || pulseaudio

-   The Jack-Audio-Connection-Kit — The older edition of a sound server
    for pro audio use, especially for low-latency applications including
    recording, effects, realtime synthesis, and many others. Although
    this edition is the older, it retains a very active and devoted
    development team, and which edition to use is not clear, trial and
    error is often helpful.

http://jackaudio.org/ || jack

-   JACK2 — This is the newer edition of JACK, designed explicitly
    towards multi-processor systems, and also includes transport over
    network.

http://trac.jackaudio.org/wiki/Q_differenc_jack1_jack2 || jack2

-   JACK2 with D-Bus — This is JACK2 with a different startup
    architecture, capable of running well at all times in coexistence
    with PulseAudio and non-JACK applications, which is a problem for
    the other two categories of JACK setup.

http://trac.jackaudio.org/wiki/WalkThrough/User/jack_control ||
jack2-dbus

-   NAS — This is a sound server supported by some major applications.

http://www.radscan.com/nas/nas-links.html || nas

See also
--------

-   MIDI
-   Codecs
-   Disable PC Speaker Beep

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sound_system&oldid=251587"

Categories:

-   Sound
-   Audio/Video
