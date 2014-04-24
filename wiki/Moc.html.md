Moc
===

Music On Console is a lightweight music player. It consists of 2 parts,
a server (Moc) and the player/interface (Mocp). This is similar to mpd,
but unlike mpd, Moc comes with an interface, although its server doesn't
support access through net.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Usage
-   4 Development versions
-   5 last.fm support
-   6 Front-ends
-   7 Troubleshooting
    -   7.1 MOC fails to start
    -   7.2 Strange characters
-   8 Additional resources

Installation
------------

Install moc from the official repositories.

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
lastfmsubmitd. First edit /etc/lastfmsubmitd.conf and enable
lastfmsubmitd with systemctl.

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

> MOC fails to start

If MOC fails to start, it's most probably because of something wrong in
~/.moc/. You can try to fix it, or simply delete the whole folder.

> Strange characters

If you see strange-like characters displayed in moc instead of the
normal lines (vertical lines to separate space, etc.) likely you've a
font set which MOC doesn't play nice with. You can either change the
font you have selected for your terminal or edit the MOC config file
(search config file for something about use ASII only).

Additional resources
--------------------

-   Official documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Moc&oldid=298804"

Category:

-   Player

-   This page was last modified on 18 February 2014, at 18:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
