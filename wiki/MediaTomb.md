MediaTomb
=========

Summary

An introduction to MediaTomb, covering installation and basic
configuration of the open source UPnP MediaServer.

Related

Streaming media

From MediaTomb - Free UPnP MediaServer:

MediaTomb is an open source (GPL) UPnP MediaServer with a nice web user
interface, it allows you to stream your digital media through your home
network and listen to/watch it on a variety of UPnP compatible devices.

MediaTomb enables users to stream digital media to UPnP compatible
devices like the PlayStation 3 (the Xbox 360 is not yet supported).
Several alternatives exist, such as FUPPES, ps3mediaserver, and uShare.
One of MediaTomb's distinguishing features is the ability to customize
the server layout based on extracted metadata (scriptable virtual
containers); MediaTomb is highly flexible.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Usage                                                              |
| -   4 Hiding full paths from media players                               |
| -   5 Systemd Integration                                                |
+--------------------------------------------------------------------------+

Installation
------------

MediaTomb is available in the AUR via mediatomb.

The latest development version is also available in the AUR via
mediatomb-svn.

Mediatomb can use its own database, or your local mysql server. For more
information about the MySQL integration visit the Documentation.

Configuration
-------------

The default settings may be sufficient for many users, though changes
are required for PlayStation 3 support. MediaTomb may be configured and
run per-user or as a system-wide daemon. Following installation, either
run

    $ mediatomb

to start MediaTomb as the current user and generate a default
configuration in ~/.mediatomb/config.xml, or

    # /etc/rc.d/mediatomb start

to start the MediaTomb daemon and generate a default configuration in
/var/lib/mediatomb/.mediatomb/config.xml. The following notes assume
MediaTomb is running as a system-wide daemon.

For PlayStation 3 support, users must set <protocolInfo extend="yes"/>.
An "avi" mimetype mapping should also be uncommented for DivX support.

    /var/lib/mediatomb/.mediatomb/config.xml

    ...

    <protocolInfo extend="yes"/>

    ...

    <map from="avi" to="video/divx"/>

    ...

When importing media to the database, MediaTomb will create a virtual
container layout as defined by the <virtual-layout type="..."> option.
That is, media will be organized according to metadata (album, artist,
etc.) through creation of virtual database objects. If your media is
already organized on the file system, you may disable this feature to
significantly improve import performance:

    /var/lib/mediatomb/.mediatomb/config.xml

    ...

    <virtual-layout type="disabled">

    ...

Users may customize the import script to fine-tune the virtual layout.
The Scripting section of the MediaTomb wiki provides several examples.
Starting with the built-in script available at
/usr/share/mediatomb/js/import.js:

    $ cp /usr/share/mediatomb/js/import.js /var/lib/mediatomb/.mediatomb/

... and edit /var/lib/mediatomb/.mediatomb/import.js as desired. To
utilize the customized script, users must set <virtual-layout type="js">
and specify the script's location.

    /var/lib/mediatomb/.mediatomb/config.xml

    ...

    <virtual-layout type="js">
      <import-script>/var/lib/mediatomb/.mediatomb/import.js</import-script>
    </virtual-layout>

    ...

You may have to specify an interface before MediaTomb will be
recognized:

    /var/lib/mediatomb/.mediatomb/config.xml

    <server>
    ...
      <interface>eth0</interface>
    ...
    </server>

... replacing eth0 with the interface you connect on.

Usage
-----

After configuring MediaTomb to your liking, restart the server by
running

    # /etc/rc.d/mediatomb restart

The daemon listens on port 50500 by default. To access the web interface
and begin importing media, navigate to http://127.0.0.1:50500/ in your
favorite browser (JavaScript required).

If running per-user instances of MediaTomb, the default port is 49152.
However, it is possible that the port will change upon server restart.
The URL for the web interface is output during startup. Users may also
specify the port manually:

    $ mediatomb -p 50500

Hiding full paths from media players
------------------------------------

By default, full directory paths will be shown on devices when they are
browsing through folders.

For example, if you add the directory
/media/my_media/video_data/videos/movies, anyone connecting will have to
navigate to the 'movies' directory from the root.

To hide all of that and only show the directory added, you can change
the import script.

For example, this script will automatically truncate the whole directory
structure specified in the variable video_root. Any directories added
directly under the video root path will show up on UPnP devices starting
from the that folder rather than /.

    function addVideo(obj)
    {
       var video_root = "/media/main_core/Server_Core_Folder/FTP_Services/Media/";

       var absolute_path = obj.location;

       var relative_path = absolute_path;

       if(absolute_path.indexOf(video_root) == 0)
          relative_path = absolute_path.replace(video_root, "")

      var chain = new Array();

      var pathSplit = relative_path.split("/");

      for(var i = 0; i < pathSplit.length - 1; i++) 
          chain.push(pathSplit[i]);

      addCdsObject(obj, createContainerChain(chain));
    }

To also hide the default PC Directory folder from UPnP device directory
listings, add the following directly under the server node of your
config.xml file.

    <pc-directory upnp-hide="yes"/>

Systemd Integration
-------------------

Using mediatomb with systemd can be done by using the following service
file: (Using MySQL)

    /usr/lib/systemd/system/mediatomb.service 

    [Unit]
    Description=MediaTomb Daemon
    After=mysql.target network.target

    [Service]
    EnvironmentFile=/etc/conf.d/mediatomb
    ExecStart=/usr/bin/mediatomb --config $MEDIATOMB_CONFIG  --user $MEDIATOMB_USER --group $MEDIATOMB_GROUP $MEDIATOMB_OPTIONS
    Restart=on-failure
    RestartSec=5

    [Install]
    WantedBy=multi-user.target

and the corresponding config file

    /etc/conf.d/mediatomb

    # See the mediatomb(1) manpage for more info.

    # Run MediaTomb as this user.
    # NOTE: For security reasons do not run MediaTomb as root.
    MEDIATOMB_USER="mediatomb"

    # Run MediaTomb as this group.
    # NOTE: For security reasons do not run MediaTomb as root.
    MEDIATOMB_GROUP="mediatomb"

    # Path to MediaTomb config file.
    MEDIATOMB_CONFIG="...path to config"

    # Other options you want to pass to MediaTomb.
    # Add "--interface ${MEDIATOMB_INTERFACE}" to bind to a named interface.
    MEDIATOMB_OPTIONS=""

Ensure that the specified user and group exists and has access to the
config file and database.

Retrieved from
"https://wiki.archlinux.org/index.php?title=MediaTomb&oldid=247108"

Categories:

-   Audio/Video
-   Networking
