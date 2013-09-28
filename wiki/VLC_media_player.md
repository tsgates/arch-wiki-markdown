VLC media player
================

  Summary
  -------------------------------------------------------
  Installing and configuring the VLC multimedia player.

VLC is a media player by the VideoLAN team designed to emphasize
portability and compatibility. Historically, it was groundbreaking for
Linux media software by being the first player to ship with libdvdcss,
letting it play encrypted DVDs. This is now a feature that almost all
players include, and is no longer an advantage.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Language                                                           |
| -   3 Skins                                                              |
| -   4 Web Interface                                                      |
| -   5 Control using hotkeys or cli                                       |
| -   6 Preventing multiple instances                                      |
| -   7 Troubleshooting                                                    |
|     -   7.1 PulseAudio Lag                                               |
|     -   7.2 Video broken or other issue after upgrade                    |
|     -   7.3 Segmentation fault                                           |
|                                                                          |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

To install, simply run

    # pacman -S vlc

If you want to play audio CDs, you should also install libcddb.

Language
--------

It seems VLC does not offer an option to change language in its
Preferences menu. But you can use the LANGUAGE= prefix. For instance:

    $ LANGUAGE=fr vlc %U

will switch VLC interface to french.

Skins
-----

VLC can be "skinned" for a different look and feel. You can obtain new
skins for VLC from http://www.videolan.org/vlc/skins.php.

Installation of skins is simple just download the skin you wish to use
and copy it to:

    ~/.local/share/vlc/skins2

Open up VLC, click tools->preferences. When the preferences window opens
up you should be in the "Interface" tab

Choose the "Use custom skin" radio button, and browse to the location of
the downloaded skin.

Restart VLC for the change to take effect.

Web Interface
-------------

Run VLC with the parameter "--extraintf=http" to use both the desktop
and web interface.

    # vlc --extraintf=http

Or you can enable this feature in the UI by navigating to "View" > "Add
Interface" > "Web Interface".

VLC defaults to port 8080: http://127.0.0.1:8080

Edit /usr/share/vlc/lua/http/.hosts to allow remote connections. You
will need to restart VLC in order for changes to take effect.

Control using hotkeys or cli
----------------------------

install netcat-openbsd

Get script at:
http://crunchbang.org/forums/viewtopic.php?pid=112035%23p112035#p112035

Follow instructions in script to setup a socket for vlc.

Either run the script from the command line or register the script with
keyboard shortcuts through your desktop.

Preventing multiple instances
-----------------------------

The default settings for VLC is to open a new instance of the program
for each file that is opened. This can be annoying if you are using VLC
for something like playing your music collection. To remedy the problem
you can do the following:

1.  Open VLC
2.  Go to Tools -> Preferences (Ctrl+P)
3.  Go to the Interface tab and find the "Instances" section.
4.  Tick "Allow only one instance"
5.  Optionally tick "Enqueue files when in one instance mode" - This
    will keep the current file playing and add any newly opened files to
    the current playlist.

Troubleshooting
---------------

> PulseAudio Lag

When using PulseAudio as the audio output module, you might encounter
audio/video sync problems. These problems can usually be fixed by
editing /etc/pulse/default.pa or  ~/.pulse/default.pa to reflect the
following changes.

    .ifexists module-udev-detect.so
    load-module module-udev-detect tsched=0
    .else

> Video broken or other issue after upgrade

Now and then VLC will have some issues with configuration even in minor
releases. Before making bug reports, remove or rename your configuration
located at ~/.config/vlc and confirm whether the issue is still there.

> Segmentation fault

When starting VLC you can get a segfault, a possible workaround to this
is running the following:

    /usr/lib/vlc/vlc-cache-gen -f usr/lib/vlc/plugins

And reinstalling the VLC with:

    pacman -S vlc

See also
--------

-   Common Applications#Multimedia
-   VLC homepage
-   Control VLC via a browser

Retrieved from
"https://wiki.archlinux.org/index.php?title=VLC_media_player&oldid=247177"

Category:

-   Player
