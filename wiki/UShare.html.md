uShare
======

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: initscripts are  
                           deprecated (Discuss)     
  ------------------------ ------------------------ ------------------------

Related articles

-   Streaming media

Note:As uShare is unmaintained, users may wish to use MiniDLNA, which is
actively developed and just as simple to set up, and does not require
manually refreshing its database.

uShare is a UPnP program developed by GeeXboX that allows you to stream
media from your computer to your Xbox 360 or PlayStation 3 along with
other media devices. While there are other UPnP programs available, such
as FUPPES, ps3mediaserver, MediaTomb and MiniDLNA (each of which are
available in [community] or the AUR if you so choose), uShare is
relatively easy to configure and works well out of the box.

Contents
--------

-   1 Shortcomings
-   2 Installation
-   3 Starting uShare
-   4 Configuration
    -   4.1 Firewall
-   5 Troubleshooting
    -   5.1 xvid/divx

Shortcomings
------------

Note that uShare is a minimalist server; it keeps all media metadata in
memory, and therefore needs to re-scan all your files at start. If you
have lots of files (e.g. music), this can take a while. Also, as
packaged in Arch now, uShare runs as ushare user (see USHARE_USER in
/etc/conf.d/ushare). uShare is currently unmaintained.

Installation
------------

uShare can be installed with the ushare package, available from the
official repositories.

Starting uShare
---------------

To start ushare you can simply run:

    # ushare

If you would like ushare to run as a daemon on boot you need to add the
ushare daemon to your DAEMONS array in /etc/rc.conf. You also need to
set USHARE_USER in /etc/conf.d/ushare to your username.

Configuration
-------------

After the installation is complete it is time to move on to the
configuration of uShare. This is very simple in the sense that you only
have one file to edit, /etc/ushare/ushare.conf:

    # /etc/ushare/ushare.conf
    # Configuration file for uShare

    # uShare UPnP Friendly Name (default is 'uShare').
    USHARE_NAME=

    # Interface to listen to (default is eth0).
    # Ex : USHARE_IFACE=eth1
    USHARE_IFACE=

    # Port to listen to (default is random from IANA Dynamic Ports range)
    # Ex : USHARE_PORT=49200
    USHARE_PORT=

    # Port to listen for Telnet connections
    # Ex : USHARE_TELNET_PORT=1337
    USHARE_TELNET_PORT=

    # Directories to be shared (space or CSV list).
    # Ex: USHARE_DIR=/dir1,/dir2
    USHARE_DIR=

    # Use to override what happens when iconv fails to parse a file name.
    # The default uShare behaviour is to not add the entry in the media list
    # This option overrides that behaviour and adds the non-iconv'ed string into
    # the media list, with the assumption that the renderer will be able to
    # handle it. Devices like Noxon 2 have no problem with strings being passed
    # as is. (Umlauts for all!)
    # 
    # Options are TRUE/YES/1 for override and anything else for default behaviour
    USHARE_OVERRIDE_ICONV_ERR= 

    # Enable Web interface (yes/no)
    USHARE_ENABLE_WEB=

    # Enable Telnet control interface (yes/no)
    USHARE_ENABLE_TELNET=

    # Use XboX 360 compatibility mode (yes/no)
    USHARE_ENABLE_XBOX=yes

    # Use DLNA profile (yes/no)
    # This is needed for PlayStation3 to work (among other devices)
    USHARE_ENABLE_DLNA=

-   ex: USHARE_NAME=Archlinux
    -   Set this to whatever you want, it is the name you will see when
        selecting the server

-   ex: USHARE_IFACE=eth0
    -   Default is eth0 so only change it if yours is something
        different

-   ex: USHARE_PORT= 49200
    -   I set this to 49200 so it was always the same port but you can
        leave it blank if you want it to randomly set it each time

-   ex: USHARE_DIR=/media/Share
    -   I found uShare has problems with more than one directory.
        Setting this to a directory of symlinks works well for sharing a
        number of different unrelated directories.

-   USHARE_OVERRIDE_ICONV_ERR=
    -   Unless you feel like overriding the default I would leave it
        blank

-   Web interface and Telnet service I put as no because I like to do
    everything from a command line but you can set this however you like

-   USHARE_ENABLE_XBOX=yes

-   USHARE_ENABLE_DLNA=
    -   Enable this if you are connecting to a Playstation 3 otherwise
        it is safe to say no here

> Firewall

The tcp/USHARE_PORT and udp/1900 need to be added to your firewall. It
is recommended that you turn your firewall off during the initial setup
and turn it back on once ushare is working properly.

Troubleshooting
---------------

The only issue I have run into is running uShare as a daemon. When in
daemon mode, I have found that my Xbox complains about invalid video
formats. To fix this I have found that changing the line:

    [ -z "$PID" ] && /usr/bin/ushare -D $PARAMS

in /etc/rc.d/ushare to:

    [ -z "$PID" ] && /usr/bin/ushare -x -D $PARAMS

works for me, but I cannot confirm that this is a general fix for all
computers or that this is an issue to anyone other than myself.

> xvid/divx

If you have problems with xvid/divx files, a possible work around would
be to change mime types from avi files from
/usr/share/mime/packages/freedesktop.xml from "video/x-msvideo" to
"video/x-ms-wmv", update database with `update-mime-database
/usr/share/mime/` and restart ushare. This procedure was taken from This
blog post and this mail.

Retrieved from
"https://wiki.archlinux.org/index.php?title=UShare&oldid=290868"

Category:

-   Streaming

-   This page was last modified on 30 December 2013, at 08:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
