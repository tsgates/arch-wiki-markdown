MPlayer
=======

MPlayer is a popular movie player for GNU/Linux. It has support for
pretty much every video and audio format out there and is hence very
versatile, even though most people use it for viewing videos.

Contents
--------

-   1 Installation
-   2 Additional installation tips
    -   2.1 Frontends/GUIs
    -   2.2 Browser integration
        -   2.2.1 Firefox
        -   2.2.2 Konqueror
        -   2.2.3 Chromium
-   3 Usage
    -   3.1 Configuration
    -   3.2 Key bindings
-   4 Tips and tricks
    -   4.1 Automatic resuming from where you left off
    -   4.2 Enabling VDPAU
        -   4.2.1 Using a configuration file
        -   4.2.2 Using a wrapper script
    -   4.3 Enabling VA-API
    -   4.4 Translucent video with Radeon cards and Composite enabled
    -   4.5 Watching streamed video
        -   4.5.1 DVD playing
        -   4.5.2 DVB-T Streaming
    -   4.6 JACK support
-   5 Troubleshooting
    -   5.1 MPlayer fails to open files with spaces
    -   5.2 MPlayer has black or strange colored font for OSD and
        Subtitles
    -   5.3 SMPlayer: No video issue
    -   5.4 SMPlayer: fail to resume playback after pause
    -   5.5 SMPlayer: no video when using transparency in GNOME
    -   5.6 SMPlayer: OSD font too big / subtitle text too small
-   6 See also

Installation
------------

Various flavours of MPlayer can be installed from the official
repositories or from the AUR:

-   mplayer - Official package.

Notable variants are:

-   mplayer-vaapi - VAAPI-enabled version.
-   mplayer-svn - Development version.
-   mplayer2 - Fork of MPlayer. with few enhancements.
-   mplayer2-git - Development version of mplayer2.

Note:mplayer2 development seems to be ceased in favour of mpv, which is
focused on speed and quality of development, though this breaks
compatibility with old hardware and software. Be aware of its
differences if you want to use it.

Additional installation tips
----------------------------

> Frontends/GUIs

-   Deepin Media Player — Rich GTK2/Python interface for the Deepin
    desktop.

http://www.linuxdeepin.com/ || deepin-media-player

-   GNOME MPlayer — Simple GTK+-based GUI for MPlayer.

http://kdekorte.googlepages.com/gnomemplayer || gnome-mplayer

-   KMPlayer — Video player plugin for Konqueror and basic
    MPlayer/Xine/ffmpeg/ffserver/VDR frontend for KDE.

http://kmplayer.kde.org/ || kmplayer

-   Pymp — PyGTK frontend for MPlayer.

http://jdolan.dyndns.org/trac/wiki/Pymp || pymp

-   Rosa Media Player — Multimedia player based on SMPlayer with clean
    and elegant UI.

http://www.rosalab.com/ || rosa-media-player

-   SMPlayer — Qt multimedia player with extra features (CSS themes,
    YouTube integration, etc.).

http://smplayer.sourceforge.net/ || smplayer

-   Xt7-Player — Graphical user interface for MPlayer written in Gambas,
    with a huge list of features.

http://xt7-player.sourceforge.net/xt7forum/ || xt7-player

> Browser integration

If you want to let MPlayer control video viewing in your favorite web
browser, install one of the following plugins for your browser.

Firefox

A browser plugin is available in the official repositories with the
gecko-mediaplayer package.

Note:It depends on gnome-mplayer, which provides a complete frontend to
MPlayer.

Konqueror

A plugin for Konqueror can be found in the AUR with the kmplayer
package.

Note:kmplayer also provides a complete frontend to MPlayer.

Chromium

The gecko-mediaplayer plugin for Firefox also works in Chromium.

Usage
-----

> Configuration

System-wide configuration is located in /etc/mplayer/mplayer.conf,
whereas the user-local settings are stored in ~/.mplayer/config. The
file /etc/mplayer/example.conf is a good starting point.

An example configuration:

    /etc/mplayer/example.conf

    # default configuration that applies to every file
    [default]

    # use X11 for video output, use a framebuffer as fallback
    vo=xv,directfb

    # use alsa for audio output, choose oss4 as fallback
    ao=alsa,oss

    # multithreaded decoding of H264/MPEG-1/2 (valid: 1-8)
    lavdopts=threads=2

    # prefer using six channels audio
    channels = 6

    # scale the subtitles to the 3% of the screen size
    subfont-text-scale = 3

    # never use font config
    nofontconfig = 1

    # set the window title using the media filename, when not set with --title.
    use-filename-title=yes

    # add black borders so the movies have the same aspect ratio of the monitor
    # for wide screen monitors
    vf-add=expand=::::1:16/9:16

    # for non wide screen traditional monitors
    #vf-add=expand=::::1:4/3:16

    # disable screensaver
    heartbeat-cmd="xscreensaver-command -deactivate &" # stop xscreensaver
    stop-xscreensaver="yes" # stop gnome-screensaver

    # correct pitch when speed is faster or slower than 1.0
    af=scaletempo

    # allow to seek in a file which is still downloading whilst watching it
    idx=yes

    # allow to increase the maximal volume
    #softvol=1
    #softvol-max=600

    # skip displaying some frames to maintain A/V sync on slow systems
    framedrop=yes

    # more intense frame dropping (breaks decoding)
    #hardframedrop=yes

    # profile for up-mixing two channels audio to six channels
    # use -profile 2chto6ch to activate
    [2chto6ch]
    af-add=pan=6:1:0:.4:0:.6:2:0:1:0:.4:.6:2

    # profile to down-mixing six channels audio to two channels
    # use -profile 6chto2ch to activate
    [6chto2ch]
    af-add=pan=2:0.7:0:0:0.7:0.5:0:0:0.5:0.6:0.6:0:0

> Key bindings

System key bindings are configured via /etc/mplayer/input.conf. Personal
key bindings are stored in ~/.mplayer/input.conf. This is a list of some
basic default MPlayer keys. For a complete list of keyboard shortcuts
look at man mplayer.

  Key         Description
  ----------- -------------------------------------------
  p           Toggle pause/play.
  Space       Toggle pause/play.
  Backspace   Return to menu when using dvdnav.
  ←           Seek backward ten seconds.
  →           Seek forward ten seconds.
  ↓           Seek backward one minute.
  ↑           Seek forward one minute.
  <           Go back in the playlist.
  >           Go forward in the playlist.
  m           Mute the sound.
  0           Volume up.
  9           Volume down.
  f           Toggle fullscreen mode.
  o           Toggle OSD state.
  v           Toggle subtitle visibility.
  I           Show filename.
  1, 2        Adjust contrast.
  3, 4        Adjust brightness.
  j           Cycle through the available subtitles.
  #           Cycle through the available audio tracks.

Tips and tricks
---------------

> Automatic resuming from where you left off

To get this behavior, you can install the mplayer-resumer package from
the AUR. The package contains a Perl wrapper script for MPlayer which
will allow you to autoresume playback from the point it was last
stopped.

To use it, simply call the wrapper script in place of MPlayer:

    $ mplayer-resumer options path/to/file

If this script is restarted within a short amount of time after closing
MPayer (default 5 seconds) then it will delete the file used to keep
track of the videos resume position, effectively starting the video from
the beginning.

If the video file to be played is on a read-only filesystem, or
otherwise lives in a location that cannot be written to, resume will
fail. This is because the current implementation uses a file parallel to
the video file to store the timecode.

> Enabling VDPAU

For a complete list of NVIDIA VDPAU capable hardware, see this table.
Ensure the nvidia driver is installed and consider one of the following
two methods to automatically enable VDPAU for playback.

For Intel/AMD, you can use libvdpau-va-gl — VAAPI backend for VDPAU. For
AMD you should also install xvba-video. To use it, create:

    /etc/profile.d/vdpau_vaapi.sh

    #!/bin/sh
    export VDPAU_DRIVER=va_gl

and make it executable:

    # chmod +x /etc/profile.d/vdpau_vaapi.sh

and reboot or relogin.

Using a configuration file

Append the following to either the system-wide
(/etc/mplayer/mplayer.conf) or user-specific (~/.mplayer/config)
configuration files:

    vo=vdpau,
    vc=ffh264vdpau,ffmpeg12vdpau,ffodivxvdpau,ffwmv3vdpau,ffvc1vdpau,

Note:The trailing commas are important! They tell MPlayer to fall back
on other drivers and codecs should the specified ones not be found.

Warning:The ffodivxvdpau codec is only supported by the most recent
series of NVIDIA hardware. Consider omitting it based on your specific
hardware. See the NVIDIA page for more information.

Using a wrapper script

The AUR contains a trivial Bash script called mplayer-vdpau-auto that
detects which video codec to use and when to use VDPAU as the video
output.

Another simple wrapper is mplayer-vdpau-shell-git, which can recover
from a VDPAU FATAL error. This wrapper uses the "-include" option to
include a VDPAU configuration, so it will ignore any VDPAU specific
settings in your ~/.mplayer/config file.

> Enabling VA-API

Mainline MPlayer does not have VA-API support. There is however a the
mplayer-vaapi fork, available in the official repositories.

MPlayer based players:

-   gnome-mplayer: To enable hardware acceleration: Edit > Preferences >
    Player, then set Video Output to vaapi.
-   smplayer: To enable hardware acceleration: Options > Preferences >
    General > Video, then set Output driver to vaapi.

> Translucent video with Radeon cards and Composite enabled

To get translucent video output in X you have to enable textured video
in MPlayer:

    $ mplayer -vo xv:adaptor=1 file

Or add the following line to ~/.mplayer/config:

    vo=xv:adaptor=1

You can use xvinfo to check which video modes your graphic card
supports.

> Watching streamed video

If you want to play a video stream (e.g an ASX link) use:

    $ mplayer -playlist link-to-stream.asx

The -playlist option is necessary because these streams are actually
playlists and cannot be played without it.

DVD playing

To play a DVD with MPlayer:

    $ mplayer dvd://N

where N is the desired title number. Start at 1 and work up if unsure.
To start at a specific chapter use the '-chapter' flag. For example,
adding '-chapter 5' to the command starts the dvd playing at chapter
five of the title.

Mplayer checks /dev/dvd by default. Tell it to use /dev/sr0 with the
dvd-device option at the command line, or the dvd-device variable in
~/.mplayer/config.

To play a DVD image file:

    $ mplayer -dvd-device movie.iso dvd://N

To enable the DVD menu use:

    $ mplayer dvdnav://

Note:You use arrow keys to navigate and the Enter key to choose.

To enable mouse support in DVD menus use:

    $ mplayer -mouse-movements dvdnav://

To find the audio language, start MPlayer with the -v switch to output
audio IDs. An audio track is selected with -aid audio_id. Set a default
audio language by editing ~/.mplayer/config and adding the line alang=en
for English.

With MPlayer, the DVD could be set to a low volume. To increase the
maximum volume to 400%, use softvol=yes and softvol-max=400. The startup
volume defaults to 100% of software volume and the global mixer levels
will remain untouched. Using the {ic|9}} and 0 keys, volume can be
adjusted between 0 and 400 percent.

    alang=en
    softvol=yes
    softvol-max=400

DVB-T Streaming

See DVB-T for more info.

> JACK support

To have MPlayer audio output directed to JACK as its default behavior,
edit ~/.mplayer/config and add:

    ao=jack

If you don't have JACK running all the time, you can have MPlayer output
to JACK on an as-needed basis by invoking MPlayer from the command line
as such:

    $ mplayer -ao jack path/to/file

Troubleshooting
---------------

> MPlayer fails to open files with spaces

MPlayer can fail to open a file with spaces (e.g. 'The Movie') by saying
that it could not open the file file:///The%20Movie (where all spaces
are converted to %20). This can be fixed by editing
/usr/share/applications/mplayer.desktop to changing the following line
from:

    Exec=mplayer %U

to:

    Exec=mplayer "%F"

If you use a frontend/GUI for MPlayer, enter its name in
Exec=gui_name "%F".

> MPlayer has black or strange colored font for OSD and Subtitles

There appears to be an issue with OSD and Subtitle colors when using
vdpau output, which mplayer may be using by default. You can get around
this issue by using xv instead of vdpau:

As a command line option:

    mplayer -vo xv

Adding the following line to your ~/.mplayer/config file :

    vo=xv

See the original forums thread for details.

> SMPlayer: No video issue

SMPlayer may have trouble opening some MP4 (and probably FLV) videos. If
it plays only audio without any video, a possible fix is to add the
following lines to your ~/.mplayer/config file:

    [extension.mp4]
    demuxer=mov

If problem persists after doing so, it is because SMPlayer is keeping
settings for that specific file. Deleting the settings for all the files
that SMPlayer is keeping will solve this problem:

    $ rm -rf ~/.config/smplayer/file_settings

> SMPlayer: fail to resume playback after pause

SMPlayer might stop playing a video after pausing it if your audio
output driver is incorrectly set. You can fix this by specifically
setting your audio driver. For example, if you use PulseAudio, this can
be done by starting MPlayer with the -ao pulse argument or by adding the
following to your ~/.mplayer/config file:

    ao=pulse

You can also change this from SMPlayer by going to Options > Preferences
> General > Audio and setting the Output Driver option to pulse.

> SMPlayer: no video when using transparency in GNOME

This problem may arise under GNOME when using Compiz to provide
transparency: SMPlayer starts with a transparent screen with audio
playing, but no video. To fix this, create (as root) a file with the
contents:

    /usr/local/bin/smplayer.helper

    export XLIB_SKIP_ARGB_VISUALS=1
    exec smplayer.real "$@"

Then do the following:

    # chmod 755 /usr/local/bin/smplayer.helper
    # ln -sf /usr/local/bin/smplayer.helper /usr/local/bin/smplayer

> SMPlayer: OSD font too big / subtitle text too small

Since SMPlayer 0.8.2.1 (with MPlayer2 20121128-1), the ratio of the
subtitle font to the OSD font is very strange. This can result in the
OSD text filling the whole screen while the subtitles are very small and
unreadable. This problem can be solved by adding:

    -subfont-osd-scale 2

or to the extra options passed to MPlayer from SMPlayer. These options
are found in Options > Preferences > Advanced > Options for MPlayer.
This can also be achieved by adding the following line to
~/.mplayer/config:

    subfont-osd-scale=2

See also
--------

-   Official MPlayer website
-   Official MPlayer2 website
-   MPlayer FAQ
-   MPlayer notes
-   MPlayer tips
-   How to configure MPlayer

Retrieved from
"https://wiki.archlinux.org/index.php?title=MPlayer&oldid=305533"

Category:

-   Player

-   This page was last modified on 18 March 2014, at 23:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
