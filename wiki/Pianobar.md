Pianobar
========

Related articles

-   List of Applications/Multimedia

Pianobar is a free/open-source, console-based client for the
personalized online radio Pandora.

Features

-   play and manage (create, add more music, delete, rename, ...)
    stations
-   rate songs and explain why they have been selected
-   upcoming songs/song history
-   customize keybindings and text output
-   remote control and eventcmd interface (send tracks to last.fm, for
    example)
-   proxy support for listeners outside the USA

Tip:Since Pianobar is a command line interface based program it can be
placed in a different vterm than your desktop and be left to run.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Troubleshooting
-   4 See also

Installation
------------

Pianobar can be installed from the Official repositories with the
package pianobar.

Configuration
-------------

First, you need to create a configuration file for Pianobar. This should
be located at $XDG_CONFIG_HOME/pianobar/config or
~/.config/pianobar/config

    $ man pianobar

    CONFIGURATION
           The  configuration file consists of simple key = value lines, each ter‐
           minated with a newline (\n) character. Note that keys  and  values  are
           both  case  sensitive, and there must be exactly one space on each side
           of the equals sign.

           act_* keys control pianobar's key-bindings.  Every  one-byte  character
           except for \x00 and the special value disabled are allowed here.

Here is an example configuration file. See man pandora for more
configuration options.

    $ ~/.config/pianobar/config

    audio_quality = {high, medium, low}
    autostart_station = stationid

    password = plaintext_password
    user = your@user.name

Troubleshooting
---------------

If you are experiencing sound/quality issues when running pianobar, and
you are currently using ALSA as your sound driver, the following fixes
may be useful.

Warning:The provided fixes may affect other applications that use audio
as the default driver is being changed.

1.  Install alsa-oss. See the ALSA page for more information.
    -   Change the default libao driver from alsa to oss.
    -   # /etc/libao.conf
            default_driver=oss

    -   Now run pianobar
        -   $ aoss pianobar

2.  Alternatively, you can use pulseaudio.
    -   # /etc/libao.conf
            default_driver=pulse

Note:Be sure to remove the dev=default option of the alsa driver or
adjust it to specify a specific Pulse sink name or number.

See also
--------

-   Project's homepage
-   Project's GitHub
-   http://ketan.lithiumfox.com/doku.php/pianobar

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pianobar&oldid=301686"

Category:

-   Audio/Video

-   This page was last modified on 24 February 2014, at 12:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
