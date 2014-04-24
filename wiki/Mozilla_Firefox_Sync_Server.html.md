Mozilla Firefox Sync Server
===========================

From Wikipedia:

Firefox Sync, originally branded Mozilla Weave, is a browser
synchronization feature that allows users to partially synchronize
bookmarks, browsing history, preferences, passwords, filled forms,
add-ons and the last 25 opened tabs across multiple computers.

It keeps user data on Mozilla servers, but the data is encrypted in such
a way that no third party, not even Mozilla, can access user
information. It is also possible for the user to host their own Firefox
Sync servers, or indeed, for any entity to do so.

This page details how you should proceed to host your own (Mozilla)
Firefox Sync Server (shortened to FFSync).

Note:Mozilla Firefox Sync will be deprecated in Firefox 29 in favor of
Firefox Accounts. See the following links for details:

-   https://wiki.mozilla.org/Identity/Firefox_Accounts
-   https://blog.mozilla.org/blog/2014/02/07/introducing-mozilla-firefox-accounts/
-   https://blog.mozilla.org/services/2014/02/07/a-better-firefox-sync/
-   https://blog.mozilla.org/futurereleases/2014/02/07/test-the-new-firefox-sync-and-customize-the-new-ui-in-firefox-aurora/

Contents
--------

-   1 Installation
-   2 Server configuration
    -   2.1 Basic configuration
    -   2.2 Disable debug mode
    -   2.3 Set email
    -   2.4 Storage backend
    -   2.5 Disk quota
    -   2.6 Running behind a Web Server
        -   2.6.1 Apache combined with mod_wsgi
        -   2.6.2 nginx with Gunicorn
    -   2.7 Not recommended setup with default web server
-   3 Client configuration
-   4 See also

Installation
------------

mozilla-firefox-sync-server-hg is available in the AUR.

The setup creates an isolated Python environment in which all necessary
dependencies are downloaded and installed. Afterwards, running the
server only relies on the isolated Python environment, independently of
the system-wide Python.

Server configuration
--------------------

Two files are used to configure a FFsync server:
/opt/mozilla-firefox-sync-server/development.ini and
/opt/mozilla-firefox-sync-server/etc/sync.conf.

> Basic configuration

The fallback node URL must reflect the server's visible URL (here
https://example.com/ffsync/). In
/opt/mozilla-firefox-sync-server/etc/sync.conf, change:

    [nodes]
    fallback_node = http://localhost:5000/

to:

    [nodes]
    fallback_node = https://example.com/ffsync/

> Disable debug mode

In /opt/mozilla-firefox-sync-server/development.ini, set:

    [DEFAULT]
    debug = False

> Set email

In /opt/mozilla-firefox-sync-server/etc/sync.conf, set:

    [smtp]
    sender = ffsync@example.com

> Storage backend

The default storage backend is sqlite which should be fine if you don't
have a lot of users. To split the various databases into several files,
edit the sqluri fields in
/opt/mozilla-firefox-sync-server/etc/sync.conf.

The Official FFsync server Howto details setup with MySQL or LDAP as a
backend.

> Disk quota

The default disk quota is quite restrictive and will quickly be filled
if a lot of bookmarks are stored. Bump the disk quota from 5 to 25 MB in
/opt/mozilla-firefox-sync-server/etc/sync.conf:

    [storage]
    ...
    quota_size = 25600
    ...

> Running behind a Web Server

The default configuration runs a built-in server which should not be
used in production.

Apache combined with mod_wsgi

See the Official FFsync server Howto.

nginx with Gunicorn

The PKGBUILD available in the AUR installs the Gunicorn server, in the
python virtualenv, by default. Enable it by changing the following lines
in /opt/mozilla-firefox-sync-server/development.ini:

    [server:main]
    use = egg:gunicorn#main
    host = unix:/run/ffsync/syncserver.sock
    use_threadpool = True
    threadpool_workers = 60

Create the /etc/tmpfiles.d/ffsync.conf file to create the /run/ffsync/
folder at boot:

    D /run/ffsync 0750 ffsync http

Create this folder now by running:

    # systemd-tmpfiles --create ffsync.conf

Enable and start the Gunicorn serveur using the systemd service unit
provided in mozilla-firefox-sync-server-hg:

    # systemctl enable ffsync
    # systemctl start ffsync

Use this config extract to configure nginx:

    # Firefox sync config
    location /ffsync/ {
        rewrite  ^/ffsync(.+)$ $1 break;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://unix:/run/ffsync/syncserver.sock;
    }

> Not recommended setup with default web server

(Outdated) systemd service unit:

    /etc/systemd/system/ffsync.service

    [Unit]
    Description=Mozilla Firefox Syn Server
    After=network.target

    [Service]
    Type=simple
    User=ffsync
    Group=ffsync
    WorkingDirectory=/opt/mozilla-firefox-sync-server
    ExecStart=/opt/mozilla-firefox-sync-server/bin/python2 /opt/mozilla-firefox-sync-server/bin/paster serve /opt/mozilla-firefox-sync-server/development.ini
    StandardOutput=/var/log/ffsync/sync-messages.log

    [Install]
    WantedBy=multi-user.target
    Alias=ffsync.service

Client configuration
--------------------

Use the Sync Configuration Wizard in Firefox' Settings to create a new
account on the server. Don't forget to choose "Custom server..." in the
list, and input the server address: https://example.com/ffsync/

The "Advanced Settings" button allows fine tuning of the synchronized
elements list, and the definition of the client hostname.

See also
--------

-   Official Mozilla Firefox Sync Server Howto

-   Howto with Apache support by Eric Hameleers
-   Howto with nginx and systemd support by Timothée Ravier
-   Howto with nginx support
-   Howto using MySQL

-   Owncloud has mozilla sync server application (looks outdated)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mozilla_Firefox_Sync_Server&oldid=296716"

Category:

-   Web Server

-   This page was last modified on 10 February 2014, at 02:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
