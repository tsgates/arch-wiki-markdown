Mpv
===

From the development page:

Movie player based on MPlayer and mplayer2. It supports a wide variety
of video file formats, audio and video codecs, and subtitle types. If
you are wondering what's different from mplayer2 and MPlayer you can
read more about the changes.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Example configuration
    -   2.2 Hardware Decoding
    -   2.3 Key bindings
        -   2.3.1 Automatic resuming from where you left off
        -   2.3.2 Quick aspect ratio change
-   3 Tips and Tricks
    -   3.1 Drawing to root window

Installation
------------

Install mpv from the official repositories or mpv-git from the AUR.
Alternatively install cmplayer or cmplayer-git Qt5 frontend which
provides its own mpv.

Configuration
-------------

System-wide configuration is located in /etc/mpv/mpv.conf, whereas the
user-local settings are stored in ~/.mpv/config. The complete list of
options is located here.

Tip:If you prefer a custom location for configurations, set the MPV_HOME
variable as you like in your shell configuration file. A predictable
choice is MPV_HOME=$XDG_CONFIG_HOME/mpv.

See the official example, or alternatively, the one below.

Tip:If you have a laptop computer and cannot get a good loud sound, set
softvol-max in your configuration file to a reasonable amount.
softvol-max=600 can be a good value. Remember: in default configuration,
0 key turns the volume up.

> Example configuration

    # default configuration that applies to every file
    [default]

    # try to use high quality opengl output, with standard opengl, classic xv, and wayland as fallbacks
    # note: opengl has numerous quality/performance trade-off options.
    # as per the mpv(1), "opengl-hq" is just an alias for "opengl:lscale=lanczos2:dither-depth=auto:fbo-format=rgb16"
    vo=opengl-hq,opengl,xv,wayland

    # use alsa for audio output, choose pulse, or oss4 as fallback
    ao=alsa,pulse,oss

    # prefer using 5.1 channels audio (defaults to 2 - see mpv --channels=help) 
    # mixing is handled by libavcodec unless using "--af-add=pan" (see below)
    channels=5.1

    # scale the subtitles to the 3% of the screen size
    sub-scale=3

    # set the window title using the media filename (see Property Expansion section of mpv(1))
    title="${filename}"

    # add black borders so the movies have the same aspect ratio of the monitor
    # for wide screen monitors
    vf=expand=::::1:16/9:16

    # for non wide screen traditional monitors, alternative to the above item
    #vf=expand=::::1:4/3:16

    # disable screensaver
    stop-screensaver="yes"

    # execute a command every 30 seconds
    # useful to disable a non-standard-compliant screensavers and to work around buggy behaviours
    # BE WARNED: to avoid dangerous commands is your responsibility
    #heartbeat-cmd="xscreensaver-command -deactivate &" # stop xscreensaver

    # custom heartbeat frequency in seconds
    #heartbeat-interval=600

    # correct pitch when speed is faster or slower than 1.0
    af=scaletempo

    # allow to seek in a file which is still downloading whilst watching it
    # from manpage:"this switch has no effect in the typical case" (usually done automatically by demuxers)
    #idx=yes

    # allow to increase the maximal volume to 600%
    #softvol-max=600

    # skip displaying some frames to maintain A/V sync on slow systems
    framedrop=yes
    # more intense frame dropping (breaks decoding)
    #framedrop=hard

    # gapless audio play
    gapless-audio

    # custom terminal seek bar
    term-osd-bar-chars = "──╼ ·"

    # profile for up-mixing two channels audio to six channels
    # use --profile 2chto6ch to activate
    [2chto6ch]
    af-add=pan=6:1:0:.4:0:.6:2:0:1:0:.4:.6:2

    # profile to down-mixing six channels audio to two channels
    # use --profile 6chto2ch to activate
    [6chto2ch]
    af-add=pan=2:0.7:0:0:0.7:0.5:0:0:0.5:0.6:0.6:0:0

> Hardware Decoding

You can reduce the CPU usage (and extend mobile battery life) by
enabling GPU hardware decoding for common video codecs. Unlike MPlayer
and mplayer2, mpv has both VDPAU and VAAPI built-in. To enable hardware
decoding, add --hwdec=method to the mpv command line, where method is
one of auto, vdpau, vaapi. To make this persistent, add the line
hwdec=method to the configuration file. With hardwarde decoding
--hwdec=[vdpau|vaapi], the video output must be specified as --vo=opengl
(preferred) or --vo=[vdpau|vaapi]. While --vo=opengl should generally be
of better quality, --vo=vdpau may give better frame timings, and
--vo=vaapi may use less power. If hardware decoding cannot be used, mpv
will automatically fallback to software decoding.

Hardware deinterlacing is also supported through the VA-API video
post-processing API:

    $ mpv --vo=opengl --hwdec=vaapi --vf=vavpp=deint=bob foobar.mkv

To use VA-API with any other video output methods requires the less
efficient vaapi-copy method:

    $ mpv --vo=wayland --hwdec=vaapi-copy foobar.mkv

This copies the decoded video back to main memory. It is also necssary
for non-VAVPP filters:

    $ mpv --vo=opengl --hwdec=vaapi-copy --vf=pp=hb/vb/dr/al/fd  foobar.mkv

> Key bindings

System key bindings are configured via /etc/mpv/input.conf. Personal key
bindings are stored in ~/.mpv/input.conf. Available keybinds and
configuration are explained in the manual pages.

Automatic resuming from where you left off

The default key to quit saving the video advance state is Q. This
behaviour is controlled by the quit_watch_later string in the key
bindings configuration file.

Quick aspect ratio change

Append to your input.conf:

    F1 set aspect 1.3333
    F2 set aspect 1.6
    F3 set aspect 1.7777
    F4 set aspect 1.85
    F5 set aspect 0

Now you are able to change the aspect ratio with F1 to F5.

Tips and Tricks
---------------

> Drawing to root window

The mplayer option --rootwin got dropped. Hand over window-id zero
instead. It's hardcoded to draw to the rootwindow (i.e. dynamic
backgrounds).

    $ mpv --wid=0 file.mp4

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mpv&oldid=305518"

Category:

-   Player

-   This page was last modified on 18 March 2014, at 18:46.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
