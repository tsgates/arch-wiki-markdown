Transmission
============

Transmission is a light-weight and cross-platform BitTorrent client. It
is the default BitTorrent client in many Linux distributions.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Run as a daemon                                              |
|         -   2.1.1 Changing daemon user                                   |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

There are several options in Official Repositories:

transmission-cli
    includes CLI tools, daemon and web client.

transmission-gtk
    GTK+ GUI.

transmission-qt
    Qt GUI.

Configuration
-------------

For transmission-gtk and transmission-qt, the default path of
configuration files is ~/.config/transmission.

For transmission-cli, default configuration path is
~/.config/transmission-daemon.

> Run as a daemon

First install transmission-cli. Then start the transmission daemon.

Navigate to http://127.0.0.1:9091 in your web browser to see the web
client.

You can edit the main configuration file
~/.config/transmission-daemon/settings.json to fit your preference. You
need to stop the daemon before editing configuration files, or your
edits will not be saved. By default, the daemon will run as the user
transmission, whose home directory is /var/lib/transmission/. This means
the default location for the configuration file is
/var/lib/transmission/.config/transmission-daemon/settings.json.

Note:If you cannot find the ~/.config/transmission-daemon folder, run
transmission-daemon once to create it.

If you change your download location, make sure the transmission user
has rw privileges to your download directory.

Changing daemon user

If you use systemd, you have to override the user in both the service
file (/usr/lib/systemd/system/transmission.service) and the tmpfile
(/usr/lib/tmpfiles.d/transmission.conf). To do so, copy both files to
the appropriate directory in /etc:

    # cp /usr/lib/systemd/system/transmission.service /etc/systemd/system/
    # cp /usr/lib/tmpfiles.d/transmission.conf /etc/tmpfiles.d/

Create a new group named for example, transmission:

    # groupadd transmission

Add your custom user to the newly created [group] ie. transmission:

    # gpasswd -a [user] [group]

Then change User= to your custom user in the service file and edit the
tmpfile to the following:

    /etc/tmpfiles.d/transmission.conf

    d /run/transmission - [user] [group] -

Then run systemd-tmpfiles --create transmission.conf and restart the
transmission service.

You may need to reload service files after editing:

    # systemctl daemon-reload

Don't forget to change permissions to 777 on folder '/run/transmission'.

If you would use Transmission daemon with its own group, you have to
give the writing permission to transmission group in your download's
directory. For this you need to run:

    # chgrp transmission /path/to/download
    # chmod g+w /path/to/download

See also
--------

-   Transmission wiki
-   HeadlessUsage

Retrieved from
"https://wiki.archlinux.org/index.php?title=Transmission&oldid=250764"

Category:

-   Internet Applications
