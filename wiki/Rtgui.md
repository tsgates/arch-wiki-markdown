Rtgui
=====

rtGui is a web based front end for rTorrent - the Linux command line
BitTorrent client. It is written in PHP and uses XML-RPC to communicate
with the rTorrent client.

Contents
--------

-   1 Set up
    -   1.1 Apache configuration
    -   1.2 PHP configuration
    -   1.3 rTorrent configuration
    -   1.4 Restart Apache
    -   1.5 rtGui installation

Set up
------

First install dependencies: rtorrent, apache, php, php-apache and
mod_scgi.

> Apache configuration

Add mod_scgi module to /etc/httpd/conf/httpd.conf in LoadModule section:

    LoadModule scgi_module modules/mod_scgi.so

Append at the end of the file:

    LoadModule php5_module modules/libphp5.so
    Include conf/extra/php5_module.conf
    SCGIMount /RPC2 127.0.0.1:5000

> PHP configuration

Uncomment these extensions in /etc/php/php.ini:

    extension=sockets.so
    extension=xmlrpc.so

Change the value of these settings from off to on:

    allow_url_fopen = On
    allow_url_include = On

> rTorrent configuration

You need to adjust the .rtorrent.rc and add the following line:

    scgi_port = localhost:5000

> Restart Apache

    # systemctl restart httpd.service

> rtGui installation

Download and extract rtgui from source:

    cd /srv/http/
    tar xvzf rtgui-x.x.x.tgz
    cd rtgui/
    cp config.php.example config.php

Modify config.php to suit your needs

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rtgui&oldid=302654"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
