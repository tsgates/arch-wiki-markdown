Audacious
=========

Audacious is a free and advanced audio player based on GTK+. It's
focused on audio quality and supports a wide variety of audio codecs,
and is easily extensible through third-party plugins.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Interfaces                                                   |
|         -   2.1.1 Adding winamp skins                                    |
|                                                                          |
|     -   2.2 Playing audio CD                                             |
|                                                                          |
| -   3 Tips and tricks                                                    |
|     -   3.1 Audtool                                                      |
|     -   3.2 MP3 Problems                                                 |
|                                                                          |
| -   4 More resources                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Audacious is available from official repository. Install it with pacman:

    # pacman -S audacious

Configuration
-------------

> Interfaces

Note:GTK+ is now the default interface in audacious 2.4 and above.

Audacious currently provides two interfaces:

-   Winamp classic interface
-   GTK interface.

One may switch between two interfaces in audacious.

Adding winamp skins

Adding Winamp skins to audacious is very simple. Just copy your skin
file (.zip, .wsz, .tgz, .tar.gz, or .tar.bz2 file) to either
~/.local/share/audacious/Skins (affect your user only) or
/usr/share/audacious/Skins (affects every user), and then you can browse
and select it from Skinned Interface tab in Preferences.

> Playing audio CD

First, install libcdio:

    # pacman -S libcdio

Then, audacious can play Audio CDs.

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

> MP3 Problems

Try to install mpg123

    # pacman -S mpg123

More resources
--------------

-   Audacious Official Site

Retrieved from
"https://wiki.archlinux.org/index.php?title=Audacious&oldid=217830"

Category:

-   Player
