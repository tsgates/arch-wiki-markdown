Rygel
=====

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Rygel is         
                           available in one of the  
                           Arch repos now. It also  
                           uses a different         
                           configuration format.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Rygel is a streaming media server compatible with many DLNA/UPnP clients
including the Sony PlayStation 3, Microsoft Xbox 360, smart televisions,
DLNA speakers and many smartphones. Rygel will automatically transcode
media to a format compatible with the client device. It can also utilise
published media hierarchies from external applications like Rhythmbox
and DVB Daemon through the D-Bus MediaServer specification. It is under
active development and is a part of the Gnome project.

Installation
------------

Install rygel from the gnome-extra repository.

Configuration
-------------

Rygel can be configured globally (/etc/rygel.conf) or per-user
($HOME/.config/rygel.conf). Some of the common configuration options
include:

    # Set it to 'false' if you want to disable transcoding support.
    enable-transcoding=true

    # Where video files should be saved if allow-upload is true.
    # Defaults to @VIDEOS@, the standard videos folder (typically ${HOME}/Videos).
    video-upload-folder=@VIDEOS@

    # Where music files should be saved if allow-upload is true
    # Defaults to @MUSIC@, the standard music folder (typically ${HOME}/Music).
    music-upload-folder=@MUSIC@

    # Where picture files should be saved if allow-upload is true
    # Defaults to @PICTURES@, the standard picture folder (typically ${HOME}/Pictures).
    picture-upload-folder=@PICTURES@

    # Tracker's indexing options can be configured with tracker-preferences
    [Tracker]
    enabled=true
    share-pictures=true
    share-videos=true
    share-music=true
    strict-sharing=false
    title=@REALNAME@'s media        # whatever name you choose

    [MediaExport]
    enabled=true
    title=@REALNAME@'s media        # whatever name you choose
    # List of URIs to export.
    uris=@MUSIC@;@VIDEOS@;@PICTURES@
    extract-metadata=true
    monitor-changes=true            # watch the URIs above for new/changed media
    virtual-folders=true

    [Playbin]
    enabled=true
    title=Audio/Video playback on @HOSTNAME@        # whatever name you choose

More information on these and other configuration options can be found
with man rygel.conf.

Troubleshooting
---------------

When starting Rygel from the command line, there are several options
that might help you troubleshoot any strange behaviour. Find out more
about these options with man rygel.

-g, --log-level=LIST
    Comma-separated list of of DOMAIN:LEVEL pairs. DOMAIN can be "*",
    "rygel" or the name of a plugin. Levels are 1 for critical, 2 for
    error, 3 for warning, 4 for info and 5 for debug.

-d, --disable-plugin=PLUGIN
    Disable PLUGIN

-t, --disable-transcoding
    Disable transcoding.

-c, --config=CONFIG_FILE
    Load the specified config file instead of /etc/rygel.conf or
    $HOME/.config/rygel.conf

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rygel&oldid=268073"

Category:

-   Streaming

-   This page was last modified on 26 July 2013, at 14:11.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
