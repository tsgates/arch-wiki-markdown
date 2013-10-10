CherryMusic
===========

> Summary

Installation, configuration, tips & tricks and basic troubleshooting of
CherryMusic - a music streaming server.

Other sources

CherryMusic website

CherryMusic on GitHub

CherryMusic is a music streaming server based on CherryPy and jPlayer.
It can be run remotely or on a single computer and is designed to handle
huge music libraries (3 TB and more) but also works well with small
collections. In contrast to MPD, Icecast and the like, CherryMusic
allows multiple users to (individually) login via HTTP/HTTPS using a web
browser, browse/search the music database and create/edit playlists and
stream music to the browser. From the website:

"CherryMusic is a standalone music server written in python based on
CherryPy and jPlayer. It is intended to be an alternative to Last.fm,
Spotify, Grooveshark... you name it."

The project is developed on GitHub.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Stable version                                               |
|     -   1.2 Git version                                                  |
|     -   1.3 Dependencies                                                 |
|         -   1.3.1 Required                                               |
|         -   1.3.2 Optional                                               |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Quick start                                                  |
|     -   2.2 Manual setup                                                 |
|     -   2.3 Fine tuning                                                  |
|                                                                          |
| -   3 Tips & Tricks                                                      |
|     -   3.1 Symlinks in "basedir"                                        |
|     -   3.2 Systemd service file                                         |
|     -   3.3 Running in a GNU Screen session                              |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Deactivate flash blocker                                     |
+--------------------------------------------------------------------------+

Installation
------------

CherryMusic is available in the AUR. There are two packages, the stable
release and the development version. If you do not depend on a
completely stable version, the development version is recommended, but
needs Git for installation.

> Stable version

The latest stable version of cherrymusic is available in the AUR.

> Git version

For a more up-to-date version with experimental features the CherryMusic
development version, cherrymusic-devel-git, can be chosen. In order to
build this version, you need Git.

Note:This AUR package needs pacman > = 4.1!

> Dependencies

Required

Required dependencies are:

python, python-cherrypy.

Optional

Optional dependencies are:

lame, vorbis-tools, flac, faad2, mpg123, ffmpeg (For live transcoding),
python3-stagger-svn (For ID3-Tag reading), imagemagick (For automatic
image resizing on displayed cover art)

Configuration
-------------

> Quick start

To just get it up and running with a basic setup, issue:

     $ cherrymusic --setup --port 8080

and open the address "localhost:8080" in your browser (e.g. with
Firefox):

     $ firefox localhost:8080

This will let you configure the most important options from within the
browser and you can set up the admin account.

If you want CherryMusic to run as a system service and to automatically
start on boot, see systemd service file.

> Manual setup

Start CherryMusic for the initial setup:

     $ cherrymusic

On first startup CherryMusic will create its data and configuration
files in ~/.local/share/cherrymusic/ and ~/.config/cherrymusic/, print a
note to stdout and exit. Now, edit the configuration file in
~/.config/cherrymusic/cherrymusic.confand change the following lines to
match your setup:

    ~/.config/cherrymusic/cherrymusic.conf

    [...]
    basedir = /path/to/your/music
    [...]
    port = 8080
    [...]

Open the address "localhost:8080" in your browser (e.g. with Firefox) to
create an admin account:

     $ firefox localhost:8080

After logging in, populate the search database by clicking Update Music
Library in the Admin panel.

If you want CherryMusic to run as a system service and to automatically
start on boot, see systemd service file.

There are many more options to configure, please see this section.

> Fine tuning

CherryMusic comes with well-documented manpages. see

     $ man cherrymusic

or

     $ man cherrymusic.conf

Tips & Tricks
-------------

> Symlinks in "basedir"

Note:This is only useful if your music is in different locations, e.g.
on an internal hard drive and an external hard dirve.

Probably, the most modular and flexible way of populating CherryMusic's
music directory (called "basedir") is to create a dedicated directory
and only symlink all paths to your music collections into that
directory, e.g.:

     $ mkdir ~/.local/share/cherrymusic/basedir
     $ ln -s /path/to/musicdir1 ~/.local/share/cherrymusic/basedir/musicdir1
     $ ln -s /path/to/musicdir2 ~/.local/share/cherrymusic/basedir/musicdir2

> Systemd service file

CherryMusic does not come with a daemon yet, but both CherryMusic AUR
packages provide a systemd service file. If you want CherryMusic to run
as a system service and to automatically start on boot, simply do:

Note:Replace "USER" with the user that should run CherryMusic (do not
use root!).

    $ sudo systemctl start cherrymusic@USER.service
    $ sudo systemctl enable cherrymusic@USER.service

Note that although the CherryMusic service is now run as the user
"USER", the service calls still have to be given as root.

> Running in a GNU Screen session

To keep CherryMusic running after logout, it can be run in a GNU Screen
session.

     $ screen -d -m -S cherrymusic cherrymusic

Since CherryMusic only writes the output to the GNU Screen session,
there is nothing to control from within the session. It may be more
convenient to use a systemd service file. However, this may still be
useful for debugging.

To run it in a GNU Screen session after boot, the following systemd
service file can also be used:

    /usr/lib/systemd/system/cherrymusic@.service

    [Unit]
    Description = CherryMusic server
    Requires = network.target
    After = network.target

    [Service]
    User = %I
    Type = simple
    ExecStart = /usr/bin/screen -d -m -S cherrymusic /usr/bin/cherrymusic
    ExecStop = /usr/bin/screen -X -S cherrymusic quit
    StandardOutput = null
    PrivateTmp = true
    Restart = always

    [Install]
    WantedBy = multi-user.target

This file has to be placed into /usr/lib/systemd/system/:

     $ sudo cp cherrymusic@.service /usr/lib/systemd/system/cherrymusic@.service

and the permissions should be changed:

     $ sudo chmod 644 /usr/lib/systemd/system/cherrymusic@.service

To finally enable and start the service, see systemd service file.

Troubleshooting
---------------

> Deactivate flash blocker

An active flash blocker can interfere with the web frontend. If you have
trouble with things like track selection or playback, try whitelisting
the server in your browser's flash blocker/plugin manager.

Retrieved from
"https://wiki.archlinux.org/index.php?title=CherryMusic&oldid=253445"

Categories:

-   Web Server
-   Player
-   Internet Applications
