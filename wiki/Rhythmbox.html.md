Rhythmbox
=========

Rhythmbox is an audio player that plays and helps organize digital
music. It is designed to work well under the GNOME desktop using the
GStreamer media framework.

Contents
--------

-   1 Installation
-   2 Tips
    -   2.1 Playing remote media from Internet sources (blip.tv,
        Jamendo, SHOUTcast)
    -   2.2 How to activate the Cover Art plugin
    -   2.3 What to do when the little red icon shows when you try to
        play radio stations
    -   2.4 How to activate the DAAP Music Sharing
-   3 Troubleshooting
    -   3.1 What to do if you see an "Unknown Playback Error" message
        -   3.1.1 Unknown Playback when streaming from an online radio
            station
        -   3.1.2 Unknown Playback when streaming or playing from
            regular files
    -   3.2 "Error, impossible to activate plugin 'Audio CD Recorder'"
        shows up every time I start Rhythmbox
    -   3.3 Slow start and "Unable to start mDNS browsing: MDNS service
        is not running" output
    -   3.4 Can't activate "context pane" plugin
    -   3.5 Rhythmbox Startup is Slow
    -   3.6 No cover are shown in the dedicated box
    -   3.7 Cannot enable MTP device support

Installation
------------

Install rhythmbox from the official repositories.

Tips
----

> Playing remote media from Internet sources (blip.tv, Jamendo, SHOUTcast)

Rhythmbox takes advantage of the Grilo framework to browse external
sources such as SHOUTcast webradios and more.

You need to install the grilo and grilo-plugins packages. Then, be sure
to enable the Grilo Media Browser plugin into Rhythmbox ("Edit" >
"Plugins").

> How to activate the Cover Art plugin

If you want to use the cover art plugin, but are unable to do so, you
need to install gnome-python.

After you do that, restart Rhythmbox.

This requirement also affects the Song Lyrics and Magnitune plugins, as
well as serveral others.

> What to do when the little red icon shows when you try to play radio stations

First thing to do when the stop sign icon shows is to right-click the
name of the station you are trying to listen to and open the Properties
dialog box. Rhythmbox should give a bit more explanation about why it
was unable to start playing the audio stream.

> How to activate the DAAP Music Sharing

1) First, install the libdmapsharing package that is required for DAAP
sharing.

2) You'll need the avahi-daemon running. See Avahi for full details on
how to install and configure it. Here are some advices:

a) install avahi and nss-mdns

b) You also need to edit /etc/nsswitch.conf to configure hostname
resolution. Change the line

    hosts: files myhostname dns

to:

    hosts: files myhostname mdns_minimal [NOTFOUND=return] dns

c) start it Set avahi-daemon to start at boot:

    systemctl enable avahi-daemon.service

or start it manually

    systemctl start avahi-daemon.service

Troubleshooting
---------------

> What to do if you see an "Unknown Playback Error" message

Unknown Playback when streaming from an online radio station

If you click on the radio stations and are shown a "Unknown Playback
Error" error message. you probably do not have a gstreamer gnomevfs
installed.

The package is called gstreamer0.10-base-plugins-gnomevfs and is
available in the AUR

After you install it, restart Rhythmbox.

Unknown Playback when streaming or playing from regular files

Alternatively, Rhythmbox will display the same error message when it
does not have the correct codec to play that stream. You will need to
identify what format the stream is (by looking at the command line error
messages that Rhythmbox displays) and then install the correct Gstreamer
codec for that particular audio stream.

If you do not know which gstreamer plugin servers what audio formats,
ask on IRC or just google it.

> "Error, impossible to activate plugin 'Audio CD Recorder'" shows up every time I start Rhythmbox

You have two options:

1.  install brasero
2.  disable the cd recording plugin: Run dconf-editor, navigate to
    /org/gnome/rhythmbox/plugins/ and remove cd-recorder from
    active-plugins.

> Slow start and "Unable to start mDNS browsing: MDNS service is not running" output

You have two options:

1.  activate the DAAP Music Sharing (see #How to activate the DAAP Music
    Sharing above)
2.  disable the DAAP plugin: Run dconf-editor, navigate to
    /org/gnome/rhythmbox/plugins/ and remove DAAP from active-plugins.

> Can't activate "context pane" plugin

You have to install python-mako and pywebkitgtk.

> Rhythmbox Startup is Slow

This can be easily fixed by disabling some of the plugins. For example,
if you do not use a mediaplayer gnome-shell extension you don't need the
MRPIS and D-bus plugins enabled.

> No cover are shown in the dedicated box

Creating a lastFM account and login in with the rhythmbox plugin can
solve the problem.

> Cannot enable MTP device support

Install gvfs-mtp.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rhythmbox&oldid=302381"

Category:

-   Player

-   This page was last modified on 28 February 2014, at 09:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
