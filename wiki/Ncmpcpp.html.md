Ncmpcpp
=======

Related articles

-   mpd

Ncmpcpp or ncmpcpp is an mpd client (compatible with mopidy) with a UI
very similar to ncmpc, but it provides new useful features such as
support for regular expressions in search engine, extended song format,
items filtering, last.fm support, ability to sort playlist, local
filesystem browser and other minor functions.

To use it, a functional mpd must be present on the system since
ncmpcpp/mpd work together in a client/server relationship.

Contents
--------

-   1 Installation
-   2 Basic configuration
-   3 Enabling visualization
-   4 Basic usage
    -   4.1 Loading ncmpcpp
    -   4.2 Different views
    -   4.3 Other UI keys
    -   4.4 Playback modes
-   5 Remapping keys
-   6 See also

Installation
------------

Install ncmpcpp from the official repositories.

Basic configuration
-------------------

The shell "GUI" for ncmpcpp is highly customizable. Edit
~/.ncmpcpp/config to your liking. If, after installation,
~/.ncmpcpp/config has not been created, you could copy the sample
config, change owner and edit at the very least the following three
configuration options:

-   mpd_host - Should point to the host on which mpd resides, can be
    "localhost" or "127.0.0.1" if on the same machine
-   mpd_port - Unless you've changed the defaults of mpd, this should be
    "6600"
-   mpd_music_dir - The same directory value as specified in
    "music_directory" in mpd.conf

For inspiration, see the following resources:

-   Sample configuration file in /usr/share/doc/ncmpcpp/config.
-   Show your .ncmpcpp/config with screenshot forum thread
-   Project screenshots page

Enabling visualization
----------------------

For visualization, add a few lines to /etc/mpd.conf to enable the
generation of the fast Fourier transform data for the visualization:

    audio_output {
        type                    "fifo"
        name                    "my_fifo"
        path                    "/tmp/mpd.fifo"
        format                  "44100:16:2"
    }

Additional lines need to be added to ~/.ncmpcpp/config

    visualizer_fifo_path = "/tmp/mpd.fifo"
    visualizer_output_name = "my_fifo"
    visualizer_sync_interval = "30" 
    visualizer_in_stereo = "yes"
    #visualizer_type = "wave" (spectrum/wave)
    visualizer_type = "spectrum" (spectrum/wave)

-   visualizer_sync_interval - Set the interval for synchronizing the
    visualizer with the audio output from mpd. It should be set to
    greater than 10 to avoid trying to synchronize too frequently, which
    freezes the visualization. The recommended value is 30, but it can
    be reduced if the audio becomes desynced with the visualization.
-   visualizer_type - Set the visualization to either a spectrum
    analyzer or wave form.

Basic usage
-----------

> Loading ncmpcpp

Load ncmpcpp in a shell:

    $ ncmpcpp

> Different views

Partial list of views within ncmpcpp:

-   0 - Clock
-   1 - Help
-   2 - Current playlist
-   3 - Filesystem browser
-   4 - DB search
-   5 - Library
-   6 - Playlist editor
-   7 - Tag editor (very powerful!)
-   9 - Music visualizer

> Other UI keys

-   \ - Switch between classic and alternative views
-   # - Display bitrate of file
-   i - Show song info
-   I - Show artist info (saved in ~/.ncmpcpp/artists/ARTIST.txt)
-   L - Shuffle between available lyric databases
-   l - Retrieve song lyrics for current song Show/hide lyrics

> Playback modes

Noticed the control panel in the upper right; shown in alternative mode:

    1:40/4:16 1082 kbps                            ──┤ Criminal ├──                                       Vol: 98%
    [playing]                             Disturbed - Indestructible (2008)                               [-z-c--]

And again in classic mode:

    ─────────────────────────────────────────────────────────────────────────────────────────────────────────[zc]─

This corresponds to the playback modes; ordered from left to right, they
are:

-   r - repeat mode [r-----]
-   z - random mode [-z----]
-   y - single mode [--s---]
-   R - consume mode [---c--]
-   x - crossfade mode [----x-]

The final "-" is only active when the user forces an update to the
datebase via u.

Remapping keys
--------------

A listing of keys and their respective functions is available from
within npmpcpp itself via hitting 1. Users may remap any of the default
keys simply by copying /usr/share/doc/ncmpcpp/keys to ~/.ncmpcpp/ and
editing it. ncmpcpp-git users have to copy
/usr/share/doc/ncmpcpp/bindings instead.

See also
--------

dotshare.it configurations

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ncmpcpp&oldid=303315"

Category:

-   Audio/Video

-   This page was last modified on 6 March 2014, at 09:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
