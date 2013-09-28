Ncmpcpp
=======

Summary

Covers installation and usage of ncmpcpp (ncmpc++)

Related

mpd - Music Player Daemon

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
| -   3 (Very) Basic configuration                                         |
| -   4 Enabling visualization                                             |
| -   5 Basic Usage                                                        |
|     -   5.1 Loading ncmpc++                                              |
|     -   5.2 Remapping keys                                               |
|     -   5.3 Different views                                              |
|     -   5.4 Other UI keys                                                |
|     -   5.5 Playback modes                                               |
+--------------------------------------------------------------------------+

Introduction
------------

Ncmpcpp or ncmpc++ is an mpd client with a UI very similar to ncmpc, but
it provides new useful features such as support for regular expressions
in search engine, extended song format, items filtering, last.fm
support, ability to sort playlist, local filesystem browser and other
minor functions. To use it, a functional mpd must be present on the
system since ncmpcpp/mpd work together in a client/server relationship.

The shell "GUI" for ncmpcpp is highly customizable. Edit
~/.ncmpcpp/config to your liking. For inspiration, see the following
resources:

-   Show your .ncmpcpp/config with Screenshot forum thread
-   Project screenshots page

Installation
------------

The official package resides in [community]

    # pacman -S ncmpcpp

(Very) Basic configuration
--------------------------

After installation a sample configuration file can be found in
/usr/share/doc/ncmpcpp/config

If, after installation, ~/.ncmpcpp/config has not been created, you
could copy the sample config, change owner and edit at the very least
the following three configuration options:

-   mpd_host (should point to the host on which mpd resides, can be
    "localhost" or "127.0.0.1" if on the same machine)
-   mpd_port (unless you've changed the defaults of mpd, this should be
    "6600")
-   mpd_music_dir (the same directory value as specified in
    "music_directory" in mpd.conf)

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
    visualizer_sync_interval = "1"
    #visualizer_type = "wave" (spectrum/wave)
    visualizer_type = "spectrum" (spectrum/wave)

Users can choose between either a spectrum analyzer or wave form.

Basic Usage
-----------

> Loading ncmpc++

Load ncmpc++ in a shell

    $ ncmpcpp

> Remapping keys

A listing of keys and their respective functions is available from
within npmpcpp itself via hitting 1. Users may remap any of the default
keys simply by copying /usr/share/doc/ncmpcpp/keys to ~/.ncmpcpp/ and
editing it. Ncmpcpp-git users have to copy
/usr/share/doc/ncmpcpp/bindings instead.

> Different views

Partial list of views within ncmpc++

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

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ncmpcpp&oldid=248502"

Category:

-   Audio/Video
