Moc
===

Music On Console is a lightweight music player. It consists of 2 parts,
a server (Moc) and the player/interface (Mocp). This is similar to mpd,
but unlike mpd, Moc comes with an interface.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Usage                                                              |
| -   4 Development versions                                               |
| -   5 last.fm support                                                    |
| -   6 Front-ends                                                         |
| -   7 Troubleshooting                                                    |
|     -   7.1 moc fails to start                                           |
|                                                                          |
| -   8 Additional resources                                               |
+--------------------------------------------------------------------------+

Installation
------------

Sync and install with pacman:

    # pacman -S moc

Configuration
-------------

The package includes a sample configuration file at
/usr/share/doc/moc/config.example. To configure moc, copy this file to
~/.moc/config and edit it.

For instructions about customizing the keybindings, read
/usr/share/doc/moc/keymap.example.

If you want to use Moc with OSS v4.1, see OSS#MOC.

Usage
-----

To start moc:

    $ mocp

This will start the server and interface. You will enter player
interface. Some useful shortcuts to use mocp (case sensitive):

  --------------------------------------- ------------
  Start playing a track                   Enter

  Pause track                             Space or p

  Play next track                         n

  Play previous track                     b

  Switch from playlist browsing to        tab
   filesystem browsing (and vice versa)   

  Add one track to the playlist           a

  Remove track from playlist              d

  Add a folder recursively to playlist    A

  Clear playlist                          C

  Increase volume 5%                      . (dot)

  Decrease volume 5%                      , (comma)

  Increase volume 1%                      >

  Decrease volume 1%                      <

  Change volume to 10%                    meta + 1

  Change volume to 20%                    meta + 2

  Quit player                             q
  --------------------------------------- ------------

NOTE: To shut down the server, use the shift (capital) Q key or:

    $ mocp -x

Development versions
--------------------

You can obtain these from the AUR. MOC 2.4.0 (stable) was released in
2006. Features since then are in 2.5, but are not yet blessed “stable”
as of writing.

-   moc-svn (latest development code)
-   moc-devel (old alpha version for next release)

last.fm support
---------------

If you want scrobble songs to last.fm (moc >= 2.5.0 needed), install
lastfmsubmitd. It is a daemon which is available in the "community"
repository. First edit /etc/lastfmsubmitd.conf and enable both services
lastfmsubmitd and lastmp with systemctl.

If services do not exists create them first:

create /etc/systemd/system/lastmp.service file and add following in it:

    [Unit]
    Description=LastMP
    After=mpd.service

    [Service]
    ExecStart=/usr/bin/lastmp --no-daemon

    [Install]
    WantedBy=multi-user.target

create /etc/systemd/system/lastfmsubmitd.service file and add following
in it:

    [Unit]
    Description=LastFM Submit daemon
    After=network.target

    [Service]
    ExecStart=/usr/bin/lastfmsubmitd --no-daemon

    [Install]
    WantedBy=multi-user.target

  
 Now add the following line to the moc configuration file:

    ~/.moc/config

    OnSongChange = "/usr/lib/lastfmsubmitd/lastfmsubmit --artist %a --title %t --length %d --album %r"

change permission:

    $ sudo chmod -R 777 /var/spool/lastfm

that's all.

Front-ends
----------

-   dmenu_mocp is a dmenu frontend for moc
-   mocicon GTK panel applet
-   moc-tray is a perl GTK dock that gives you access to moc functions

Troubleshooting
---------------

> moc fails to start

If moc fails to start, it's most probably because of something wrong in
~/.moc/. You can try to fix it, or simply delete the whole folder.

Additional resources
--------------------

-   Official documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Moc&oldid=253619"

Category:

-   Player
