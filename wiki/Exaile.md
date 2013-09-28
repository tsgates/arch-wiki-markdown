Exaile
======

Exaile is a music manager and player for GTK+ written in Python. It
incorporates automatic fetching of album art, lyrics fetching, Last.fm
scrobbling, support for many portable media players, internet radio such
as shoutcast, and tabbed playlists.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Enabling cover art, lyrics, and guitar tablature             |
|     -   1.2 Playing audio CDs                                            |
|                                                                          |
| -   2 Enabling multimedia keys irrespective of DE/WM                     |
| -   3 Troubleshooting                                                    |
|     -   3.1 Progress bar stuck at 0:00                                   |
|     -   3.2 "Playback error encountered! Configured audiosink bin0 is    |
|         not working"                                                     |
|     -   3.3 Playing from SMB share                                       |
|     -   3.4 "Last.fm Loved Tracks" plugin not working                    |
+--------------------------------------------------------------------------+

Installation
------------

Exaile is available in the AUR.

If you use ALSA and want to use alsasink instead of the default one,
install gstreamer0.10-base-plugins available in the Official
Repositories. This may solve problem if no sound is heard after
installation and also when trying to play several sources
simultaneously.

> Enabling cover art, lyrics, and guitar tablature

While installing Exaile via Pacman will also install any needed runtime
dependencies, two additional packages gnome-python-extras & libgtkhtml
will be needed to enable the cover art, lyrics, guitar tablature, and
wiki features of Exaile.

    pacman -S gnome-python-extras libgtkhtml

> Playing audio CDs

Exaile requires 'python-cddb' to play audio cd's. The correct package
for this is cddb-py.

Enabling multimedia keys irrespective of DE/WM
----------------------------------------------

First, run xev and retrieve the keycodes for the Previous, Next, Play,
Stop, and Mute keys. Then create a textfile and add lines in the
following format: keycode 173 = XF86AudioPrev. Replace the keycode (173)
with your own keycode for the Previous key. Repeat the process for the
other keys, substituting 'Prev' for 'Next', 'Play', 'Stop', and 'Mute'.

Then edit ~/.xinitrc and add the line xmodmap <file name> prior to the
'exec' command (if there is one) for the DE/WM, where <file name> is the
path to the text file created above.

Finally, in Exaile, go to Edit → Preferences → Plugins, and enable the
XKeys plugin. After a restart, multimedia keys should work.

Troubleshooting
---------------

> Progress bar stuck at 0:00

First, make sure there are no problems with your sound architecture
(ALSA, OSS, etc.). And your playback sink in Exaile is set correctly.
Try setting it to automatic first.

If you're trying to listen to an MP3 file, try playing an audio file
encoded in a different format, such as .ogg or .flac. If these play
correctly then try installing gstreamer-ugly.

    pacman -S gstreamer0.10-ugly gstreamer0.10-ugly-plugins

> "Playback error encountered! Configured audiosink bin0 is not working"

If you're getting a message like this, or "Configured audiosink bin1 is
not working" (or with another number after 'bin'), it may be because
Flash is blocking the use of ALSA by Exaile. You can fix this by running

    killall npviewer.bin

In certain cases (such as if a YouTube video has finished playing),
Flash may be blocking the use of ALSA even if an 'npviewer.bin' process
is not running. In that case, refreshing the offending page while using
a Flash blocking browser extension should fix the problem.

> Playing from SMB share

Unfortunately, Exaile does NOT support smb protocol.

> "Last.fm Loved Tracks" plugin not working

When launched from console, Exaile emits a warning in the command line:

    WARNING : Error while connecting to Last.fm network: 'module' object has no attribute 'LastFMNetwork'

You need to install the python2-pylast package from AUR.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Exaile&oldid=247369"

Category:

-   Player
