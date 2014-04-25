Music Player Daemon
===================

Related articles

-   MPD/Tips and Tricks
-   MPD/Troubleshooting

MPD (music player daemon) is an audio player that has a server-client
architecture. It plays audio files, organizes playlists and maintains a
music database all while using very few resources. In order to interface
with it, a separate client is needed.

Contents
--------

-   1 Installation
-   2 Setup
    -   2.1 Global configuration
        -   2.1.1 Music directory
        -   2.1.2 Start MPD
        -   2.1.3 Configure audio
        -   2.1.4 Changing user
        -   2.1.5 Timeline of MPD startup
    -   2.2 Local configuration (per user)
        -   2.2.1 Autostart on tty login
        -   2.2.2 Autostart in X
        -   2.2.3 Autostart with systemd
        -   2.2.4 Scripted configuration
    -   2.3 Multi-mpd setup
-   3 Clients
    -   3.1 Console
    -   3.2 Graphical
    -   3.3 Web
-   4 See also

Installation
------------

The latest stable version of mpd is available in the official
repositories.

Should users wish to run an experimental version, the AUR offers several
from which to choose. For example, mpd-git.

Note:An alternative plug-in based implementation called Mopidy exists.
It is available in the AUR as mopidy and mopidy-git. Be warned that is
not a complete MPD drop-in relacement.

Setup
-----

MPD is able to run locally (per user settings), globally (settings apply
to all users), and in multiple instances. The way of setting up mpd
depends on the way it is intended to be used: a local configuration may
prove more useful on a desktop system, for example.

In order for MPD to be able to play back audio, ALSA or OSS (optionally
with PulseAudio) needs to be setup and working.

MPD is configured in mpd.conf. The location of this file depends on how
you want to run MPD (see the sections below). These are commonly used
configuration options:

-   pid_file - The file where mpd stores its process ID
-   db_file - The music database
-   state_file - MPD's current state is noted here
-   playlist_directory - The folder where playlists are saved into
-   music_directory - The folder that MPD scans for music
-   sticker_file - The sticker database

Note:The files must already exist (the path is specified in the
configuration file) with proper permissions, otherwise MPD will fail to
start.

> Global configuration

Warning:Users of PulseAudio with a local mpd have to implement a
workaround in order to run mpd as its own user!

The default /etc/mpd.conf keeps the setup in /var/lib/mpd and uses mpd
as default user. However, /var/lib/mpd is owned by root by default, we
need to change this so mpd can write here:

    # chown -R mpd /var/lib/mpd

Edit /etc/mpd.conf and add a music_directory line with the path to your
music directory:

    music_directory /path/to/music

Music directory

MPD needs to have +x permissions on all parent directories to the music
collection.

If the music directory is located outside of /var/lib/mpd, you will most
likely need to remount the music directory under a directory that the
MPD user (mpd by default) has access to:

    # mkdir /var/lib/mpd/music
    # echo "/path/to/music/dir /var/lib/mpd/music none bind" >> /etc/fstab
    # mount -a

Also see this forum thread.

An additional solution would be to just create a symbolic link into
/var/lib/mpd/music.

    # mkdir /var/lib/mpd/music
    # ln -s /path/to/music/dir /var/lib/mpd/music/

If the music collection is contained under multiple directories, create
symbolic links under the main music directory in /var/lib/mpd. Remember
to set permissions accordingly on the directories being linked.

Start MPD

MPD can be controlled with mpd.service using systemd. The first startup
can take some time as MPD will scan your music directory.

Test everything by starting a client application (ncmpc is a light and
easy to use client), and play some music!

Configure audio

To change the volume for mpd independent from other programs, uncomment
or add this switch in mpd.conf:

    /etc/mpd.conf

    mixer_type			"software"

Users of ALSA will want to have the following device definition, which
allows software volume control in the MPD client to control the volume
separately from other applications.

    /etc/mpd.conf

    audio_output {
            type            "alsa"
            name            "My Sound Card"
            mixer_type      "software"      # optional
    }

Users of PulseAudio will need to make the following modification:

    /etc/mpd.conf

    audio_output {
            type            "pulse"
            name            "pulse audio"
    }

PulseAudio supports multiple advanced operations, e.g. transferring the
audio to a different machine. For advanced configuration with MPD see
Music Player Daemon Community Wiki.

Changing user

Changing the group that MPD runs as may result in errors like
output: Failed to open "My ALSA Device",
[alsa]: Failed to open ALSA device "default": No such file or directory
or
player_thread: problems opening audio device while playing "Song Name.mp3".

This is because the MPD users need to be part of the audio group to
access sound devices under /dev/snd/. To fix it add user make the MPD
user part of the audio group:

    # gpasswd -a mpd audio

Timeline of MPD startup

To depict when MPD drops its superuser privileges and assumes those of
the user set in the configuration, the timeline of a normal MPD startup
is listed here:

1.  Since MPD is started as root by systemd, it first reads the
    /etc/mpd.conf file.
2.  MPD reads the user variable in the /etc/mpd.conf file, and changes
    from root to this user.
3.  MPD then reads the contents of the /etc/mpd.conf file and configures
    itself accordingly.

Notice that MPD changes the running user from root to the one named in
the /etc/mpd.conf file. This way, uses of ~ in the configuration file
point correctly to the home user's directory, and not root's directory.
It may be worthwhile to change all uses of ~ to /home/username to avoid
any confusion over this aspect of MPD's behavior.

> Local configuration (per user)

MPD can be configured per user (rather than the typical method of
configuring MPD globally). Running MPD as a normal user has the benefits
of:

-   A single directory ~/.config/mpd/ (or any other directory under
    $HOME) that will contain all the MPD configuration files.
-   Easier to avoid unforeseen read/write permission errors.

Good practice is to create a single directory for the required files and
playlists. It can be any directory for which you have read and write
access, e.g. ~/.config/mpd/ or ~/.mpd/. This section assumes it is
~/.config/mpd/, which corresponds to the default value of
$XDG_CONFIG_HOME (part of XDG Base Directory Specification).

MPD searches for a config file in $XDG_CONFIG_HOME/mpd/mpd.conf and then
~/.mpdconf. It is also possible to pass other path as command line
argument.

Copy the example configuration file to desired location, for example:

    $ cp /usr/share/doc/mpd/mpdconf.example ~/.config/mpd/mpd.conf

Edit ~/.config/mpd/mpd.conf and specify the required files:

    ~/.config/mpd/mpd.conf

    # Required files
    db_file            "~/.config/mpd/database"
    log_file           "~/.config/mpd/log"

    # Optional
    music_directory    "~/music"
    playlist_directory "~/.config/mpd/playlists"
    pid_file           "~/.config/mpd/pid"
    state_file         "~/.config/mpd/state"
    sticker_file       "~/.config/mpd/sticker.sql"

Create all the files and directories as configured above:

    $ mkdir ~/.config/mpd/playlists
    $ touch ~/.config/mpd/{database,log,pid,state,sticker.sql}

When the paths of required files are configured, MPD can be started. To
specify custom location of the configuration file:

    $ mpd config_file

Autostart on tty login

To start MPD on login add the following to ~/.profile (or another
autostart file):

    # MPD daemon start (if no other user instance exists)
    [ ! -s ~/.config/mpd/pid ] && mpd

Autostart in X

If you use a desktop environment, place the following file in
~/.config/autostart/:

    ~/.config/autostart/mpd.desktop

    [Desktop Entry]
    Encoding=UTF-8
    Type=Application
    Name=Music Player Daemon
    Comment=Server for playing audio files
    Exec=mpd
    StartupNotify=false
    Terminal=false
    Hidden=false
    X-GNOME-Autostart-enabled=false

If you do not use a DE, place the line from #Autostart on tty login in
your autostart file.

Autostart with systemd

Note:It is assumed that you already have systemd user-session manager
running. See the systemd/User page for details.

The package mpd provides user service file in
/usr/lib/systemd/user/mpd.service. The configuration file is expected to
exist either in ~/.mpdconf or ~/.config/mpd/mpd.conf, see
systemd#Editing provided unit files if you would like to use different
path. The process is not started as root, so you should not use the user
and group variables in the MPD configuration file, the process already
has user permissions and therefore it is not necessary to change them
further.

All you have to do is enable and start the mpd user service.

> Note:

-   mpd provides also system service file in
    /usr/lib/systemd/system/mpd.service, but as the process is started
    as root, it does not read the user configuration file and falls back
    to /etc/mpd.conf. Global configuration is described in other
    section.
-   Make sure to disable every other method of starting mpd you used
    before.

Scripted configuration

Rasi has written a script that will create the proper directory
structure, configuration files and prompt for the location of the user's
Music directory; it can be downloaded here.

> Multi-mpd setup

Useful if running an icecast server.

For a second MPD (e.g., with icecast output to share music over the
network) using the same music and playlist as the one above, simply copy
the above configuration file and make a new file (e.g.,
/home/username/.mpd/config-icecast), and only change the log_file,
error_file, pid_file, and state_file parameters (e.g., mpd-icecast.log,
mpd-icecast.error, and so on); using the same directory paths for the
music and playlist directories would ensure that this second mpd would
use the same music collection as the first one e.g., creating and
editing a playlist under the first daemon would affect the second daemon
as well. Users do not have to create the same playlists all over again
for the second daemon. Call this second daemon the same way from
~/.xinitrc above. (Just be sure to have a different port number, so as
to not conflict with the first mpd daemon).

Clients
-------

A separate client is needed to control mpd. See a long list of clients
at the mpd wiki. Popular options are:

> Console

-   mpc — Simple KISS client. All basic functionality available

http://mpd.wikia.com/wiki/Client:Mpc || mpc

-   ncmpc — Ncurses client for mpd

http://mpd.wikia.com/wiki/Client:Ncmpc || ncmpc

-   ncmpcpp — Almost exact clone of ncmpc with some new features written
    in C++ (tag editor, search engine)

http://unkart.ovh.org/ncmpcpp/ || ncmpcpp

-   pms — Highly configurable and accessible ncurses client

http://pms.sourceforge.net/ || pmus

-   vimpc — Ncurses based MPD client with vi-like key bindings

http://sourceforge.net/projects/vimpc/ || vimpc

> Graphical

-   Ario — Very feature-rich GTK2 GUI client for mpd, inspired by
    Rhythmbox

http://ario-player.sourceforge.net/ || ario

-   QmpdClient — GUI client written with Qt 4.x

http://bitcheese.net/wiki/QMPDClient || qmpdclient

-   Sonata — Elegant Python GTK+ client

http://sonata.berlios.de/ || sonata

-   gmpc — GTK2 frontend for Music Player Daemon. It is designed to be
    lightweight and easy to use, while providing full access to all of
    MPD's features. Users are presented with several different methods
    to browse through their music. It can be extended by plugins, of
    which many are available.

http://gmpc.wikia.com/wiki/Gnome_Music_Player_Client || gmpc

-   Dmpc — Dmenu-based MPC client with a playlist manager and
    state-saving on playlist changes

http://wintervenom.mine.nu/ || dmpc

-   Cantata — High-feature, Qt4/KDE4 client for MPD with very
    configurable interface

https://code.google.com/p/cantata/ || cantata-qt

> Web

-   Patchfork — Web client for MPD written in PHP and Ajax

http://mpd.wikia.com/wiki/Client:Pitchfork || patchfork-git.

See also
--------

-   MPD Forum
-   MPD User Manual
-   Wikipedia article

Retrieved from
"https://wiki.archlinux.org/index.php?title=Music_Player_Daemon&oldid=302063"

Category:

-   Player

-   This page was last modified on 25 February 2014, at 14:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
