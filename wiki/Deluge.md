Deluge
======

Summary help replacing me

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
in Python 2. It has a variety of features, including but not limited to:
a client/server model, DHT support, magnet links, a plugin system, UPnP
support, full-stream encryption, proxy support, and three different
client applications. When the server daemon is running, users can
connect to it via a console client, a GTK+-based GUI, or a Web-based UI.
A full list of features can be viewed here.

Contents
--------

-   1 Installation
-   2 Daemon setup
    -   2.1 System service
    -   2.2 User service
-   3 Configuration
    -   3.1 Firewall
-   4 Clients
    -   4.1 Console
    -   4.2 GTK+
    -   4.3 Web
        -   4.3.1 System service
        -   4.3.2 User service
        -   4.3.3 Setup
-   5 Headless setup
    -   5.1 Create a user
    -   5.2 Allow remote
    -   5.3 Firewall
    -   5.4 Connect
        -   5.4.1 SSH Tunnel
-   6 See Also

Installation
------------

deluge is available from the official repositories.

The GTK+ UI requires additional dependencies as does the Web UI. Inspect
the pacman output to determine which are right for the intended
application:

    python2-notify: libnotify notifications
    pygtk: needed for gtk ui
    librsvg: needed for gtk ui
    python2-mako: needed for web ui

Daemon setup
------------

Warning:If multiple users are running a daemon, the default port (58846)
will need to be changed for each user.

Deluge comes with a daemon called deluged. If it is not running when one
of the clients is run, it will be started. It is useful, however, to
have it started with systemd to allow torrents to run without starting a
client and/or Xorg. This can be accomplished in one of two ways: a
system service or a user service.

> System service

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

> User service

A user service will allow deluged to run when systemd --user is started.
This is accomplished by creating a user service file:

    /etc/systemd/user/deluged.service

    [Unit]
    Description=Deluge Daemon
    After=network.target

    [Service]
    ExecStart=/usr/bin/deluged -d -P %h/.config/deluge/deluge.pid

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

> GTK+

Note:If you plan on using the daemon (server) functionality, it is wise
to disable Classic Mode in Edit -> Preferences -> Interface, then
restart the client.

The GTK+ client can be run with:

    $ deluge-gtk

or:

    $ deluge

The GTK+ client has a number of useful plugins:

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
-   WebUi - Allows the Web UI to be started via the GTK+ client

> Web

Note:It is recommended that you use https for the Web client.

> Warning:

-   If multiple users are running a daemon, the default port (8112) will
    need to be changed for each user.
-   The deluge Web client comes with a default password. See the Setup
    section.

The Web UI can be started by running deluge-web, through a plugin in the
GTK+ UI, or via systemd. It has many of the same features of the GTK+
UI, including the plugin system.

System service

Deluge comes with a system service file called deluge-web.service. The
process for this is the same as starting deluged.service, except with
deluge-web instead of deluged. This service will also run as the deluge
user unless the service file is modified in the same way as
deluged.service.

User service

A user service will allow deluge-web to run when systemd --user is
started. This is accomplished by creating a user service file:

    /etc/systemd/user/deluge-web.service

    [Unit]
    Description=Deluge Web UI
    After=deluged.service

    [Service]
    ExecStart=/usr/bin/deluge-web --ssl

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
SHA1 and salted. The default password is "deluge". On the first visit,
you will be advised to change the password.

You will also be greeted by a warning from your browser that the SSL
certificate is untrusted. You must add an exception to this in your
browser to continue on. See the OpenSSL page for information on creating
your own certificate.

Headless setup
--------------

Deluge is quite useful on a headless system, often referred to as a seed
box, because of its client/server model. To set up deluge on a headless
system, set up the daemon as shown above.

> Create a user

To allow interaction with the server remotely, create a user in
$HOME/.config/deluge/auth. For example:

    $ echo "delugeuser:p422WoRd:10" >> $HOME/.config/deluge/auth

> Note:

-   The user/password created does not have to match any system users,
    and to maintain good security practices it should not!
-   The user/password in this file are not hashed or salted like in the
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

> Allow remote

The default settings disallow remote connections. Change the
"allow_remote" setting in $HOME/.config/deluge/core.conf:

    "allow_remote": true,

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

In the GTK+ client, Edit > Connection Manager > Add.

In the Web client, Connection Manager > Add.

SSH Tunnel

An SSH tunnel can be created to use an encrypted connection on any
client. This requires an extra loopback address to be added, but this
can be automated at boot. The actual command to establish an SSH tunnel
cannot because it requires user input. There are a few possible ways to
go about doing that.

    /etc/systemd/system/extra_lo_addr.service

    [Unit]
    Description=extra loopback address
    Wants=network.target

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/sbin/ip addr add 127.0.0.2/8 dev lo
    ExecStop=/sbin/ip addr del 127.0.0.2/8 dev lo

    [Install]
    WantedBy=multi-user.target

    $ ssh -fNL 127.0.0.2:58846:localhost:58846 <ssh host>

The port 58846 should be replaced with the port the deluge server is
running on and <ssh host> should be replaced with the server hosting
both deluge and the SSH server.

See Also
--------

-   Deluge homepage
-   Deluge wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Deluge&oldid=302631"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
