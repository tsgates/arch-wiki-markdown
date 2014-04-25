WTorrent
========

wTorrent is a web interface to rTorrent, a high performance console
based BitTorrent client. It uses rTorrent's build-in XMLRPC server to
communicate with it.

wTorrent is programmed in PHP using Smarty templates and XMLRPC for PHP
library. wTorrent also uses javascript for rendering the page with AJAX,
Scriptaculous and ShadedBorders.

Contents
--------

-   1 wTorrent with Apache
    -   1.1 Installation
        -   1.1.1 mod_scgi
    -   1.2 Configuration
        -   1.2.1 Adding mod_scgi to httpd.conf
        -   1.2.2 Enabling SQLite in php.ini
        -   1.2.3 Final steps
-   2 wTorrent with lighttpd
    -   2.1 Installation
    -   2.2 Configuration
-   3 FAQ
    -   3.1 Q: Why, when I turn to
        http://localhost/wtorrent/install.php, it returns not the
        wTorrent setup page but a plain text page?

wTorrent with Apache
--------------------

See also Apache.

> Installation

Install wtorrent-svn and its the dependencies: rtorrent, apache, php,
php-apache, php-sqlite, php-curl, mod_scgi.

mod_scgi

After you install the packages you need to install the mod_scgi module
for Apache:

    $ wget http://quixote.python.ca/releases/scgi-1.13.tar.gz 

or:

    $ wget http://python.ca/scgi/releases/scgi-1.13.tar.gz

Then:

    $ tar xf scgi-1.13.tar.gz
    $ cd scgi-1.13/apache2
    $ sudo apxs -i -c mod_scgi.c

> Configuration

Adding mod_scgi to httpd.conf

Edit /etc/httpd/conf/httpd.conf.

Locate the LoadModule lines and add:

    LoadModule scgi_module modules/mod_scgi.so

Add to the end of the file:

    SCGIMount /RPC2 127.0.0.1:5000

Save the file and quit.

Enabling SQLite in php.ini

Edit /etc/php/php.ini.

Locate and uncomment the following:

    extension=pdo.so
    extension=pdo_sqlite.so
    extension=curl.so
    extension=xmlrpc.so
    extension=sqlite.so
    extension=sqlite3.so

PHP

PHP is practically available out of the box now.

-   Add these lines in /etc/httpd/conf/httpd.conf:

Note:Place them at the end of "LoadModule" list or bottom of the file.

    LoadModule php5_module modules/libphp5.so
    Include conf/extra/php5_module.conf

-   Restart the Apache service to make changes take effect.

Final steps

Add the following to your ~/.rtorrent.rc:

    scgi_port = localhost:5000

Get the latest version of wTorrent and install to your web directory:

    # cd /srv/http
    # git clone https://github.com/wtorrent/wtorrent.git
    # mv wtorrent wtorrent.git
    # mv wtorrent.git/wtorrent/ .
    # rm -rf wtorrent.git/
    # chmod -R 777 wtorrent

Start rTorrent (most common to open a screen and type rtorrent)

Point your browser to http://localhost/wtorrent/install.php and add a
username & password. After you click the "Try configuration" and it
gives you no errors click the "Save configuration"

wTorrent with lighttpd
----------------------

See also Lighttpd.

> Installation

Install rtorrent, lighttpd, php, sqlite3.

> Configuration

http://www.wtorrent-project.org/trac/wiki/wTorrentInstall#UsingLighttpd

FAQ
---

Q: Why, when I turn to http://localhost/wtorrent/install.php, it returns not the wTorrent setup page but a plain text page?

A: You should check whether or not PHP is working on your Apache. Add
following lines to /etc/httpd/conf/httpd.conf:

In LoadModule Section, add:

    LoadModule php5_module modules/libphp5.so

In Supplemental configuration section add:

    # php5
    Include conf/extra/php5_module.conf

And make sure that SCGIMount /RPC2 127.0.0.1:5000 is added after the
Supplemental configuration section.

Retrieved from
"https://wiki.archlinux.org/index.php?title=WTorrent&oldid=302675"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
