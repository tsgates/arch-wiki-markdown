Deluge
======

> Summary

A lightweight, full-featured BitTorrent application with a client/server
model

> Related

rTorrent

systemd

systemd/User

iptables

OpenSSL

External Links

Deluge Homepage

Deluge Wiki

Deluge is a lightweight but full-featured BitTorrent application written
in python2. It has a variety of features, including but not limited to:
a client/server model, DHT support, magnet links, a plugin system, UPnP
support, full-stream encryption, proxy support, and three different
client applications. When the server daemon is running, users can
connect to it via a console client, a gtk-based GUI, or a Web-based UI.
A full list of features can be viewed here.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Daemon Setup                                                       |
|     -   2.1 System Service                                               |
|     -   2.2 User Service                                                 |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Firewall                                                     |
|                                                                          |
| -   4 Clients                                                            |
|     -   4.1 Console                                                      |
|     -   4.2 Gtk                                                          |
|     -   4.3 Web                                                          |
|         -   4.3.1 System Service                                         |
|         -   4.3.2 User Service                                           |
|         -   4.3.3 Setup                                                  |
|                                                                          |
| -   5 Headless Setup                                                     |
|     -   5.1 Create a User                                                |
|     -   5.2 Firewall                                                     |
|     -   5.3 Connect                                                      |
|                                                                          |
| -   6 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

deluge is available from the official repositories.

    # pacman -S deluge

The gtk UI requires additional dependencies as does the Web UI. Inspect
the pacman output to determine which are right for the intended
application.

    python2-notify: libnotify notifications
    pygtk: needed for gtk ui
    librsvg: needed for gtk ui
    python2-mako: needed for web ui

Daemon Setup
------------

Warning:If multiple users are running a daemon, the default port (58846)
will need to be changed for each user.

Deluge comes with a daemon called deluged. If it is not running when one
of the clients is run, it will be started. It is useful, however, to
have it started with systemd to allow torrents to run without starting a
client and/or Xorg. This can be accomplished in one of two ways: a
system service or a user service.

> System Service

A system service will allow deluged to run at boot without the need to
start Xorg or a client. Deluge comes with a system service called
deluged.service, which can be started and enabled without change:

    # systemctl start deluged
    # systemctl enable deluged

This will run the deluge daemon as the deluge user, which is created by
the deluge package. If you wish to run the daemon as another user, copy
/usr/lib/systemd/system/deluged.service to
/etc/systemd/system/deluged.service and change the User parameter within
the file, such as the torrent user:

    User=torrent

In that case, you will have to create a user called torrent.

> User Service

A user service will allow deluged to run when systemd --user is started.
This is accomplished by creating a user service file:

    /etc/systemd/user/deluged.service

    [Unit]
    Description=Deluge Daemon
    After=network.target

    [Service]
    Exec=/usr/bin/deluged -d -P %h/.config/deluge/deluge.pid

    [Install]
    WantedBy=default.target
     

The deluge user service can now be started and enabled by the user:

    $ systemctl --user start deluged
    $ systemctl --user enable deluged

The deluged user service can also be placed in
$HOME/.config/systemd/user/. See systemd/User for more information on
user services.

Configuration
-------------

Deluge can be configured through any of the clients as well as by simply
editting the JSON-formatted configuration files located in
$HOME/.config/deluge/. $HOME refers to the home directory of the user
that deluged is running as. This means that if the daemon is running as
the deluge user, the default home directory is /srv/deluge/.

> Firewall

Deluge requires at least one port open for TCP and UDP to allow incoming
connections for seeding. If deluge is informing you that it cannot open
a port for incoming connections, you must open ports you wish to use. In
this example, ports 56881 through 56889 are opened for TCP and UDP:

    # iptables -A INPUT -p tcp --dport 56881:56889 -j ACCEPT
    # iptables -A INPUT -p udp --dport 56881:56889 -j ACCEPT

If you are behind a NAT router/firewall, port forwards are also required
there. UPnP may also be used, but that will not work with the local
firewall on the system that the daemon is running on because it requires
predefined ports.

Note:You can limit this to just one port, but you must open any ports
for both TCP and UDP.

Clients
-------

> Console

The console client can be run with:

    $ deluge-console

Enter the help command for a list of available commands.

> Gtk

Note:If you plan on using the daemon (server) functionality, it is wise
to disable Classic Mode in Edit -> Preferences -> Interface. This
requires a restart of the client.

The gtk client can be run with:

    $ deluge-gtk

or:

    $ deluge

The gtk client has a number of useful plugins:

-   AutoAdd - Monitors directories for .torrent files
-   Blocklist - Downloads and imports an IP blocklist
-   Execute - Event-based command execution
-   Extractor - Extracts archived files upon completion (beware of
    random high disk I/O usage)
-   Label - Allows labels to be assigned to torrents, as well as state,
    tracker, and keyword filters
-   Notifications - Provides notifications (email, pop-up, blink, sound)
    for events as well as other plugins
-   Scheduler - Limits active torrents and their speed on a per-hour,
    per-day basis
-   WebUi - Allows the Web UI to be started via the gtk client

> Web

Warning:If multiple users are running a daemon, the default port (8112)
will need to be changed for each user.

Note:It is recommended that you use https for the Web client.

Warning:The deluge Web client comes with a default password. See the
Setup section.

The Web UI can be started by running deluge-web, through a plugin in the
gtk UI, or via systemd. It has many of the same features of the gtk UI,
including the plugin system.

System Service

Deluge comes with a system service file called deluge-web.service. The
process for this is the same as starting deluged.service, except with
deluge-web instead of deluged. This service will also run as the deluge
user unless the service file is modified in the same way as
deluged.service.

User Service

A user service will allow deluge-web to run when systemd --user is
started. This is accomplished by creating a user service file:

    /etc/systemd/user/deluge-web.service

    [Unit]
    Description=Deluge Web UI
    After=deluged.service

    [Service]
    Exec=/usr/bin/deluge-web --ssl

    [Install]
    WantedBy=default.target
     

The deluge user service can now be started and enabled by the user:

    $ systemctl --user start deluge-web
    $ systemctl --user enable deluge-web

The deluge-web user service can also be placed in
$HOME/.config/systemd/user/. See systemd/User for more information on
user services.

Setup

When deluge-web is initially started, it will create
$HOME/.config/deluge/web.conf. The password in this file is hashed with
SHA1 and salted. The default password is deluge. On the first visit, you
will be advised to change the password.

You will also be greeted by a warning from your browser that the SSL
certificate is untrusted. You must add an exception to this in your
browser to continue on. See the OpenSSL page for information on creating
your own certificate.

Headless Setup
--------------

Deluge is quite useful on a headless system, often referred to as a seed
box, because of its client/server model. To set up deluge on a headless
system, set up the daemon as shown above.

> Create a User

To allow interaction with the server remotely, create a user in
$HOME/.config/deluge/auth. For example:

    $ echo "delugeuser:p422WoRd:10" >> $HOME/.config/deluge/auth

Note:The user/password created does not have to match any system users,
and to maintain good security practices it should NOT!

Note:The user/password in this file are not hashed or salted like in the
web client config.

The number 10 corresponds to a level of Admin. Refer to the following
table for additional values:

  Level Name   Level Value
  ------------ -------------
  None         0
  Read Only    1
  Normal       5
  Admin        10

Note:In Deluge 1.35, these values have no effect, but multiuser options
are under development.

> Firewall

You will need to open the port for remote access. The following example
uses the default daemon port (58846):

    # iptables -A INPUT -p tcp --dport 58846 -j ACCEPT

See iptables for more information on firewall rules.

If you are behind a NAT router/firewall, a port forward is also required
there to access the daemon from outside the network.

> Connect

In the console client:

    connect <host>[:<port>] <user> <password>

In the gtk client, Edit -> Connection Manager -> Add.

In the Web client, Connection Manager -> Add.

See Also
--------

-   Deluge homepage
-   Deluge wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Deluge&oldid=250639"

Category:

-   Internet Applications
