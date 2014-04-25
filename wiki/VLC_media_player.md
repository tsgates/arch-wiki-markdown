VLC media player
================

From the project home page:

VLC is a free and open source cross-platform multimedia player and
framework that plays most multimedia files as well as DVD, Audio CD,
VCD, and various streaming protocols.

Contents
--------

-   1 Installation
-   2 Language
-   3 Skins
-   4 Web interface
-   5 Tips and tricks
    -   5.1 File association in GNOME
    -   5.2 Control using hotkeys or cli
    -   5.3 Preventing multiple instances
    -   5.4 Harware acceleration support
-   6 Troubleshooting
    -   6.1 PulseAudio lag
    -   6.2 Video broken or other issue after upgrade
    -   6.3 Segmentation fault
    -   6.4 Missing icons in dropdown menus
-   7 See also

Installation
------------

Install vlc from the official repositories.

Notable variants are:

-   vlc-git - Development branch.

If you want to play audio CDs, you should also install libcddb.

Language
--------

It seems VLC does not offer an option to change language in its
Preferences menu. But you can use the LANGUAGE= prefix. For instance,
modify the /usr/share/applications/vlc.desktop line:

    Exec=/usr/bin/vlc %U

to:

    Exec=LANGUAGE=fr /usr/bin/vlc %U

to switch VLC interface to French.

Skins
-----

VLC can be "skinned" for a different look and feel. You can obtain new
skins for VLC from http://www.videolan.org/vlc/skins.php.

Installation of skins is simple just download the skin you wish to use
and copy it to:

    ~/.local/share/vlc/skins2

Open up VLC, click Tools > Preferences. When the preferences window
opens up you should be in the "Interface" tab

Choose the "Use custom skin" radio button, and browse to the location of
the downloaded skin.

Restart VLC for the change to take effect.

Note: You need to install libtar from the official repositories to use
the skinnable interface module.

Web interface
-------------

Run VLC with the parameter --extraintf=http to use both the desktop and
web interface. The --http-host parameter specifies the address to, which
is localhost by default. To set a password, use --http-password,
otherwise VLC will not allow you to log in.

    # vlc --extraintf=http --http-host 0.0.0.0:8080 --http-password 'yourpasswordhere'

Or you can enable this feature in the UI by navigating to View > Add
Interface > Web Interface.

VLC defaults to port 8080: http://127.0.0.1:8080

Edit /usr/share/vlc/lua/http/.hosts to allow remote connections. You
will need to restart VLC in order for changes to take effect.

Tips and tricks
---------------

> File association in GNOME

Copy the system desktop file to the local one (local .desktop files
supersede the global ones):

    $ cp /usr/share/applications/vlc.desktop ~/.local/share/applications/

Define its mime types (known playback file type abilities) by doing:

    sed -i 's|^Mimetype.*$|MimeType=video/dv;video/mpeg;video/x-mpeg;video/msvideo;video/quicktime;video/x-anim;video/x-avi;video/x-ms-asf;video/x-ms-wmv;video/x-msvideo;video/x-nsv;video/x-flc;video/x-fli;application/ogg;application/x-ogg;application/x-matroska;audio/x-mp3;audio/x-mpeg;audio/mpeg;audio/x-wav;audio/x-mpegurl;audio/x-scpls;audio/x-m4a;audio/x-ms-asf;audio/x-ms-asx;audio/x-ms-wax;application/vnd.rn-realmedia;audio/x-real-audio;audio/x-pn-realaudio;application/x-flac;audio/x-flac;application/x-shockwave-flash;misc/ultravox;audio/vnd.rn-realaudio;audio/x-pn-aiff;audio/x-pn-au;audio/x-pn-wav;audio/x-pn-windows-acm;image/vnd.rn-realpix;video/vnd.rn-realvideo;audio/x-pn-realaudio-plugin;application/x-extension-mp4;audio/mp4;video/mp4;video/mp4v-es;x-content/video-vcd;x-content/video-svcd;x-content/video-dvd;x-content/audio-cdda;x-content/audio-player;|' ~/.local/share/applications/vlc.desktop

Then in System Settings > Details > Default Applications and on the
Video drop-down menu, select Open VLC media player.}}

> Control using hotkeys or cli

Install netcat-openbsd.

Get script at:
http://crunchbang.org/forums/viewtopic.php?pid=112035%23p112035#p112035

Follow instructions in script to setup a socket for VLC.

Either run the script from the command line or register the script with
keyboard shortcuts through your desktop.

> Preventing multiple instances

The default settings for VLC is to open a new instance of the program
for each file that is opened. This can be annoying if you are using VLC
for something like playing your music collection. To remedy the problem
you can do the following:

1.  Open VLC.
2.  Go to Tools > Preferences (Ctrl+P).
3.  Go to the Interface tab and find the "Instances" section.
4.  Tick "Allow only one instance".
5.  Optionally tick "Enqueue files when in one instance mode". This will
    keep the current file playing and add any newly opened files to the
    current playlist.

> Harware acceleration support

To enable hardware acceleration since version 2.1.x: Tools > Preferences
> Input & Codecs, then choose under Hardware-accelerated decoding the
suitable item, e.g. Video Acceleration (VA) API or
Video Decode and Presentation API for Unix (VDPAU).

To enable hardware acceleration in previous versions: Tools >
Preferences > Input & Codecs, then check Use GPU accelerated decoding.

Troubleshooting
---------------

> PulseAudio lag

When using PulseAudio as the audio output module, you might encounter
audio/video sync problems. These problems can usually be fixed by
editing /etc/pulse/default.pa or  ~/.pulse/default.pa to reflect the
following changes. However, this can cause a new audio stuttering
problem in some applications such as flash.

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

     # /usr/lib/vlc/vlc-cache-gen -f usr/lib/vlc/plugins

Then reinstall VLC.

> Missing icons in dropdown menus

This can happen under XFCE, there will be no more icons in dropdown
menus, like the or the PCI card icon.

Execute these commands to reactivate these icons:

    $ gconftool-2 --type boolean --set /desktop/gnome/interface/buttons_have_icons true
    $ gconftool-2 --type boolean --set /desktop/gnome/interface/menus_have_icons true

See also
--------

-   List of Applications#Multimedia
-   VLC homepage
-   Control VLC via a browser

Retrieved from
"https://wiki.archlinux.org/index.php?title=VLC_media_player&oldid=303478"

Category:

-   Player

-   This page was last modified on 7 March 2014, at 13:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
