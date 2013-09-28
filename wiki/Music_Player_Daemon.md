Music Player Daemon
===================

Summary

Installation, configuration and basic troubleshooting of MPD.

Related Articles

MPD/Tips and Tricks

MPD/Troubleshooting

Other sources

Wikipedia article

MPD (music player daemon) is an audio player that has a server-client
architecture. It plays audio files, organizes playlists and maintains a
music database all while using very few resources. In order to interface
with it, a separate client is needed.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Stable version                                               |
|     -   1.2 Git version                                                  |
|                                                                          |
| -   2 Setup                                                              |
|     -   2.1 Local Configuration (per user)                               |
|         -   2.1.1 Autostart with systemd                                 |
|         -   2.1.2 Scripted Configuration                                 |
|                                                                          |
|     -   2.2 Global Configuration                                         |
|         -   2.2.1 Music directory                                        |
|         -   2.2.2 Start MPD                                              |
|         -   2.2.3 Configure audio                                        |
|         -   2.2.4 Changing user                                          |
|         -   2.2.5 Timeline of MPD startup                                |
|                                                                          |
|     -   2.3 Multi-mpd setup                                              |
|                                                                          |
| -   3 Clients                                                            |
|     -   3.1 Console                                                      |
|     -   3.2 Graphical                                                    |
|     -   3.3 Web                                                          |
|                                                                          |
| -   4 External links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

> Stable version

The latest stable version of mpd is available in the official
repositories.

> Git version

Should users wish to run an experimental version, the AUR offers several
from which to choose. For example, mpd-git.

Setup
-----

MPD is able to run locally (per user settings), globally (settings apply
to all users), and in multiple instances. The way of setting up mpd
depends on the way it is intended to be used: a local configuration may
prove more useful on a desktop system, for example.

For a proper MPD operation these are the necessary files and
directories:

-   mpd.db - The music database
-   mpd.pid - The file where mpd stores its process ID
-   mpd.log - mpd logs here
-   mpdstate - mpd's current state is noted here
-   playlists - the folder where playlists are saved into

In order for MPD to be able to play back audio, ALSA, PulseAudio or OSS
needs to be setup and working.

> Local Configuration (per user)

MPD can be configured per user (rather than the typical method of
configuring MPD globally). Running MPD as a normal user has the benefits
of:

-   A single directory ~/.mpd (or any other directory under
    /home/$USER/) that will contain all the MPD configuration files.
-   Easier to avoid unforeseen read/write permission errors.

To setup: create a directory for the required files and the playlists;
copy the example configuration locally; create all of the requisite
files:

    mkdir -p ~/.mpd/playlists
    cp /usr/share/doc/mpd/mpdconf.example ~/.mpd/mpd.conf
    touch ~/.mpd/{database,log,state}

Edit ~/.mpd/mpd.conf and specify the requisite files:

    ~/.mpd/mpd.conf

    music_directory    "~/music"          # Can keep commented if XDG music dir.
    playlist_directory "~/.mpd/playlists"
    db_file            "~/.mpd/database"
    log_file           "~/.mpd/log"
    pid_file           "~/.mpd/pid"
    state_file         "~/.mpd/state"

MPD can now be started by typing mpd on the command line (mpd first
searches for ~/.mpd.conf, then ~/.mpd/mpd.conf, and then for
/etc/mpd.conf [there is no support for XDG-config directory
~/.config/mpd/mpd.conf]). To specify the location of the configuration
file :

    mpd ~/.config/mpd/mpd.conf

To start MPD on login add to ~/.profile (or another Autostart file):

    # MPD daemon start (if no other user instance exists)
    [ ! -s ~/.mpd/mpd.pid ] && mpd

To start with the X.org server add to either xprofile or xinitrc. Some
DEs ignore these files (GNOME does) and a desktop file must be placed in
~/.config/autostart/mpd.desktop:

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

Autostart with systemd

Note:As of 2013-03-20 this functionality is still in development (forum
thread). However, there is a workaround though it is peculiar as it
requires a running X.org server to work.

Expected setup

-   Start user-session service (e.g.
    sudo systemctl enable user-session@USERNAME).
-   Add local service file ~/.config/systemd/user/mpd.service (see
    below).
-   Start local systemd systemd --user &; enable service file
    systemctl --user enable mpd; start it systemctl --user start  mpd.
-   Add systemd --user & to ~/.profile or another autostart file.
-   Reboot and MPD start.

    [Unit]
    Description=Music Player Daemon

    [Service]
    ExecStart=/usr/bin/mpd %h/.config/mpd/mpd.conf --no-daemon
    ExecStop= /usr/bin/mpd %h/.config/mpd/mpd.conf --kill

    [Install]
    WantedBy=default.target

Current setup (this hasn't worked for everybody)

As recommended above, it is best to use MPD as a service per user. In
this case, we will use ~/.mpd/mpd.conf and not start mpd.service as a
daemon for the whole system and all users. We will NOT use the
/usr/lib/systemd/system/mpd.service which is intended to start the
mpd.service as root and for all users.

Note:It is recommended to follow the instructions in the Systemd/User
page fully, and to have your whole session managed by systemd --user.

If you already enabled it, just disable it first:

     # systemctl disable mpd.service

If you used to start mpd inside your ~/.xinitrc, comment or delete the
line

    mpd ~/.mpdconf

Then, edit a new file ~/.config/systemd/user/mpd.service

    ~/.config/systemd/user/mpd.service

    [Unit]
    Description = Music Player Daemon

    [Service]
    ExecStart = /usr/bin/mpd --no-daemon
    Restart = always

    [Install]
    WantedBy = default.target

Then, add this line to .xinitrc before any exec <session-command>

    ~/.xinitrc

    #run systemd as user instance
    systemd --user &

Log out, log in your xsession. Let's first check mpd is not running. If
yes, just kill it. If not, continue to the next step.

    $ ps -ef | grep mpd

Now, enable and start mpd.service as per user

    $ systemctl --user enable mpd
    $ systemctl --user start mpd

Check the mpd status and see if mpd.service is correctly enabled and
started

    $ systemctl --user status mpd

Scripted Configuration

Rasi has written a script that will create the proper directory
structure, configuration files and prompt for the location of the user's
Music directory; it can be downloaded here.

> Global Configuration

Warning:Users of PulseAudio with a local mpd have to implement a
workaround in order to run mpd as its own user!

The default Arch install keeps the setup in /var/lib/mpd and uses mpd as
default user.

Edit /etc/mpd.conf to reflect as such:

    /etc/mpd.conf

    music_directory       "/path/to/music/dir"
    playlist_directory    "/var/lib/mpd/playlists"
    db_file               "/var/lib/mpd/mpd.db"
    log_file              "syslog"
    pid_file              "/run/mpd/mpd.pid"
    state_file            "/var/lib/mpd/mpdstate"
    user                  "mpd"

We just configured MPD to run as the mpd user, but /var/lib/mpd is owned
by root by default, we need to change this so mpd can write here:

    # chown -R mpd /var/lib/mpd

Music directory

MPD needs to have +x permissions on all parent directories to the music
collection (ie. if it's located outside of /var/lib/mpd). Thus users
will most likely need to remount the music directory under a directory
that mpd has access to -- this only applies if running as the 'mpd'
user.

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

MPD can be controlled with the mpd daemon. The first startup can take
some time as MPD will scan your music directory.

Test everything by starting a client application (ncmpc is a light and
easy to use client), and play some music!

Configure audio

Note:Everything should work by default, only change this if it doesn't
work for you!

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

Changing user

Note:This is only required if you change the user!

Changing the group that MPD runs as may result in errors like "output:
Failed to open "My ALSA Device"" "[alsa]: Failed to open ALSA device
"default": No such file or directory" "player_thread: problems opening
audio device while playing "Song Name.mp3""

This is because by default MPD runs as member of audio group and the
sound devices under /dev/snd/ are owned by this group, so add user mpd
to group audio.

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

A separate client is needed to control mpd. Popular options are:

> Console

-   mpc — Simple KISS client. All basic functionality available

http://mpd.wikia.com/wiki/Client:Mpc || mpc

-   ncmpc — A NCurses client for mpd

http://mpd.wikia.com/wiki/Client:Ncmpc || ncmpc

-   ncmpcpp — An almost exact clone of ncmpc with some new features
    written in C++ (tag editor, search engine)

http://unkart.ovh.org/ncmpcpp/ || ncmpcpp

-   pms — Highly configurable and accessible ncurses client

http://pms.sourceforge.net/ || pmus

-   vimpc — ncurses based MPD client with vi-like key bindings

http://sourceforge.net/projects/vimpc/ || vimpc

> Graphical

-   Ario — A very feature-rich GTK2 GUI client for mpd, inspired by
    Rhythmbox

http://ario-player.sourceforge.net/ || ario

-   QmpdClient — A GUI client written with Qt 4.x

http://bitcheese.net/wiki/QMPDClient || qmpdclient

-   Sonata — An elegant Python GTK+ client

http://sonata.berlios.de/ || sonata

-   gmpc — GNOME Client

http://gmpc.wikia.com/wiki/Gnome_Music_Player_Client || gmpc

-   Dmpc — Dmenu-based MPC client with a playlist manager and
    state-saving on playlist changes

http://wintervenom.mine.nu/ || dmpc

-   Cantata — High-feature, Qt4/KDE4 client for MPD with very
    configurable interface

https://code.google.com/p/cantata/ || cantata-qt

> Web

-   Patchfork — web client for MPD written in PHP and Ajax

http://mpd.wikia.com/wiki/Client:Pitchfork || patchfork-git.

See a long list of clients at the mpd wiki.

External links
--------------

-   Sorted List of MPD Clients
-   MPD forum

Retrieved from
"https://wiki.archlinux.org/index.php?title=Music_Player_Daemon&oldid=251810"

Category:

-   Player
