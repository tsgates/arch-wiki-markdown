Audacious
=========

Audacious is a free and advanced audio player based on GTK+. It's
focused on audio quality and supports a wide variety of audio codecs,
and is easily extensible through third-party plugins.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Interfaces
        -   2.1.1 Adding Winamp skins
-   3 Tips and tricks
    -   3.1 Audtool
    -   3.2 MP3 problems
-   4 See also

Installation
------------

audacious is available from official repositories. Install it with
pacman. If you want audio CD support, install libcdio.

Configuration
-------------

> Interfaces

Note:GTK+ is now the default interface in Audacious 2.4 and above.

Audacious currently provides two interfaces:

-   Winamp classic interface
-   GTK+ interface.

One may switch between two interfaces in Audacious.

Adding Winamp skins

Adding Winamp skins to Audacious is very simple. Just copy your skin
file (.zip, .wsz, .tgz, .tar.gz, or .tar.bz2 file) to either
~/.local/share/audacious/Skins (affect your user only) or
/usr/share/audacious/Skins (affects every user), and then you can browse
and select it from Skinned Interface tab in Preferences. Another way is
dragging the skin file directly into the list view of available skins.

Tips and tricks
---------------

> Audtool

Audacious is shipped with a powerful management tool called Audtool.
Audtool could be used to retrieve information or to control the player.

For example, to retrieve current song title or artist, issue the
following command:

    $ audtool current-song
    $ audtool current-song-tuple-data artist

There are also functions to control playback, manipulate the playlist,
equalizer and main window. For the whole option list, see:

    $ audtool --help

> MP3 problems

Install mpg123.

See also
--------

-   Audacious official site

Retrieved from
"https://wiki.archlinux.org/index.php?title=Audacious&oldid=303511"

Category:

-   Player

-   This page was last modified on 7 March 2014, at 17:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
