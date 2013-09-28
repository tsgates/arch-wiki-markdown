MPlayer
=======

MPlayer is a popular movie player for GNU/Linux. It has support for
pretty much every video and audio format out there and is hence very
versatile, even though most people use it for viewing videos.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Additional installation tips                                       |
|     -   2.1 Frontends/GUIs                                               |
|     -   2.2 Browser integration                                          |
|         -   2.2.1 Firefox                                                |
|         -   2.2.2 Konqueror                                              |
|         -   2.2.3 Chromium                                               |
|                                                                          |
| -   3 Usage                                                              |
|     -   3.1 Configuration                                                |
|     -   3.2 Key Bindings                                                 |
|                                                                          |
| -   4 Tips and Tricks                                                    |
|     -   4.1 Automatic resuming from where you left off                   |
|     -   4.2 Enabling VDPAU (for modern NVIDIA cards only)                |
|         -   4.2.1 Using a configuration file                             |
|         -   4.2.2 Using a wrapper script                                 |
|                                                                          |
|     -   4.3 Translucent video with Radeon cards and Composite enabled    |
|     -   4.4 SMPlayer: No video issue                                     |
|     -   4.5 SMPlayer: Fail to resume playback after pause                |
|     -   4.6 SMPlayer: No video when using transparency in GNOME          |
|     -   4.7 SMPlayer: OSD font too big / Subtitle text too small         |
|     -   4.8 Watching streamed video                                      |
|     -   4.9 MPlayer with DVDNav support                                  |
|     -   4.10 MPlayer with JACK support                                   |
|     -   4.11 MPlayer fails to open files with spaces                     |
|                                                                          |
| -   5 External links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

MPlayer can be installed by three different packages from the official
repositories:

-   mplayer: the standard package.
-   mplayer-vaapi: a VAAPI-enabled version of MPlayer.
-   mplayer2: a fork of MPlayer with several new features.

Development versions are also available in the AUR:

-   mplayer-svn: development version of MPlayer.
-   mplayer2-git: development version of MPlayer2.

For differences between the two see MPlayer2 vs MPlayer.

Additional installation tips
----------------------------

> Frontends/GUIs

There are several GUIs for MPlayer.

-   GNOME MPlayer — A simple GTK+-based GUI for MPlayer.

http://kdekorte.googlepages.com/gnomemplayer || gnome-mplayer

-   KMPlayer — A video player plugin for Konqueror and basic
    MPlayer/Xine/ffmpeg/ffserver/VDR frontend for KDE.

http://kmplayer.kde.org/ || kmplayer

-   Pymp — A PyGTK frontend for MPlayer.

http://jdolan.dyndns.org/trac/wiki/Pymp || pymp

-   SMPlayer — A middleweight Qt front-end for MPlayer with additional
    patches.

http://smplayer.sourceforge.net/ || smplayer

-   UMPlayer — A SMPlayer fork with extra features (CSS themes, YouTube
    integration, ShoutCast support, etc.).

http://www.umplayer.com/ || umplayer

-   Xt7-Player — A graphical user interface for MPlayer written in
    Gambas, with a huge list of features.

http://xt7-player.sourceforge.net/xt7forum/ || xt7-player

> Browser integration

If you want to let MPlayer control video viewing in your favorite web
browser, install one of the following plugins for your browser.

Firefox

A browser plugin is available in the official repositories with the
gecko-mediaplayer package.

Note:Depends on gnome-mplayer, which provides a complete frontend to
MPlayer.

Konqueror

A plugin for Konqueror can be found in the AUR with the kmplayer
package.

Note:kmplayer Also provides a complete frontend to MPlayer.

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

    # use X11 for video output
    vo=xv

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

    # skip  displaying  some  frames  to  maintain  A/V sync on slow systems
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

> Key Bindings

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

Tips and Tricks
---------------

> Automatic resuming from where you left off

To get this behavior, you can install the mplayer-resumer package from
the AUR. The package contains a Perl wrapper script for MPlayer which
will allow you to autoresume playback from the point it was last
stopped.

To use it, simply call the wrapper script in place of MPlayer:

    $ mplayer-resumer [options] [path/to/file]

If this script is restarted within a short amount of time after closing
MPayer (default 5 seconds) then it will delete the file used to keep
track of the videos resume position, effectively starting the video from
the beginning.

If the video file to be played is on a read-only filesystem, or
otherwise lives in a location that cannot be written to, resume will
fail. This is because the current implementation uses a file parallel to
the video file to store the timecode.

> Enabling VDPAU (for modern NVIDIA cards only)

For a complete list of VDPAU capable hardware, see this table. Ensure
the nvidia driver is installed and consider one of the following two
methods to automatically enable VDPAU for playback.

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

> Translucent video with Radeon cards and Composite enabled

To get translucent video output in X you have to enable textured video
in MPlayer:

    $ mplayer -vo xv:adaptor=1 <file>

Or add the following line to ~/.mplayer/config:

    vo=xv:adaptor=1

You can use xvinfo to check which video modes your graphic card
supports.

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

> SMPlayer: Fail to resume playback after pause

SMPlayer might stop playing a video after pausing it if your audio
output driver is incorrectly set. You can fix this by specifically
setting your audio driver. For example, if you use PulseAudio, this can
be done by starting MPlayer with the -ao pulse argument or by adding the
following to your ~/.mplayer/config file:

     ao=pulse

You can also change this from SMPlayer by going to Options > Preferences
> General > Audio and setting the Output Driver option to pulse.

> SMPlayer: No video when using transparency in GNOME

This problem may arise under GNOME when using Compiz to provide
transparency: SMPlayer starts with a transparent screen with audio
playing, but no video. To fix this, create (as root) a file with the
contents:

    /usr/bin/smplayer.helper

    export XLIB_SKIP_ARGB_VISUALS=1
    exec smplayer.real "$@"

Then do the following:

    # chmod 755 /usr/bin/smplayer.helper
    # mv /usr/bin/smplayer{,.real}
    # ln -sf smplayer.helper /usr/bin/smplayer

> SMPlayer: OSD font too big / Subtitle text too small

Since SMPlayer 0.8.2.1 (with MPlayer2 20121128-1}}, the ratio of the
subtitle font to the OSD font is very strange. This can result in the
OSD text filling the whole screen while the subtitles are very small and
unreadable. This problem can be solved by adding:

    -subfont-osd-scale 2

or to the extra options passed to MPlayer from SMPlayer. These options
are found in Options > Preferences > Advanced > Options for MPlayer.
This can also be achieved by adding the following line to
~/.mplayer/config:

    subfont-osd-scale=2

> Watching streamed video

If you want to play a video stream (e.g an ASX link) use:

    $ mplayer -playlist link-to-stream.asx

The -playlist option is necessary because these streams are actually
playlists and cannot be played without it.

> MPlayer with DVDNav support

If you want to use MPlayer with DVDNav (to enable the menus on DVDs),
start it with the following options:

    $ mplayer -nocache dvdnav://

> MPlayer with JACK support

To have MPlayer audio output directed to JACK as its default behavior,
edit ~/.mplayer/config and add:

    ao=jack

If you don't have JACK running all the time, you can have MPlayer output
to JACK on an as-needed basis by invoking MPlayer from the command line
as such:

    $ mplayer -ao jack [path/to/file]

> MPlayer fails to open files with spaces

MPlayer can fail to open a file with spaces (e.g. 'The Movie') by saying
that it could not open the file file:///The%20Movie (where all spaces
are converted to %20). This can be fixed by editing
/usr/share/applications/mplayer.desktop to changing the following line
from:

    Exec=mplayer %U

To:

    Exec=mplayer "%F"

If you use a frontend/GUI for MPlayer, enter its name in
Exec=gui_name "%F".

External links
--------------

-   Official MPlayer website
-   MPlayer FAQ
-   MPlayer notes
-   MPlayer tips
-   How to configure MPlayer

Retrieved from
"https://wiki.archlinux.org/index.php?title=MPlayer&oldid=251841"

Category:

-   Player
