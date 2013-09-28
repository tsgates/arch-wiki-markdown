WTorrent
========

  Summary
  -------------------------------------------------------------------------------------------------------------------------------
  This article covers the installation of the wTorrent program as well as its potential configuration with Lighttpd and Apache.

wTorrent is a web interface to rtorrent a high performance console based
BitTorrent client. It uses rtorrent's build-in xmlrpc server to
communicate with it.

wTorrent is programmed in php using Smarty templates and XMLRPC for PHP
library. wTorrent also uses javascript for rendering the page with AJAX,
Scriptaculous and ShadedBorders.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 wTorrent with Apache                                               |
|     -   1.1 Installation                                                 |
|         -   1.1.1 Using pacman                                           |
|         -   1.1.2 mod_scgi                                               |
|                                                                          |
|     -   1.2 Configuration                                                |
|         -   1.2.1 Adding mod_scgi to httpd.conf                          |
|         -   1.2.2 Enabling SQLite in php.ini                             |
|         -   1.2.3 Final steps                                            |
|                                                                          |
| -   2 wTorrent with Lighttpd                                             |
|     -   2.1 Installation                                                 |
|     -   2.2 Configuration                                                |
|                                                                          |
| -   3 FAQ                                                                |
+--------------------------------------------------------------------------+

wTorrent with Apache
--------------------

> Installation

Using pacman

    # pacman -S rtorrent apache php php-apache php-sqlite php-curl

Install mod_scgi from the AUR.

mod_scgi

After you install the packages you need to install the mod_scgi module
for Apache:

    $ wget http://quixote.python.ca/releases/scgi-1.13.tar.gz 

or

    $ wget http://python.ca/scgi/releases/scgi-1.13.tar.gz

    $ tar xf scgi-1.13.tar.gz
    $ cd scgi-1.13/apache2
    $ sudo apxs -i -c mod_scgi.c

> Configuration

Adding mod_scgi to httpd.conf

    $ sudo vi /etc/httpd/conf/httpd.conf

Locate the LoadModule lines and add:

    LoadModule scgi_module modules/mod_scgi.so

Add to the end of the file:

    SCGIMount /RPC2 127.0.0.1:5000

Save the file and quit (:wq)

Enabling SQLite in php.ini

    $ sudo vi /etc/php/php.ini

Locate & un-comment the following:

    extension=pdo.so
    extension=pdo_sqlite.so
    extension=curl.so
    extension=xmlrpc.so
    extension=sqlite.so
    extension=sqlite3.so

PHP

PHP is practically available out of the box now.

-   Add these lines in /etc/httpd/conf/httpd.conf:

NOTE: Place them at the end of "LoadModule" list or bottom of the file.

    LoadModule php5_module modules/libphp5.so
    Include conf/extra/php5_module.conf

-   Restart the Apache service to make changes take effect (as root):

Restart Apache

    $ sudo /etc/rc.d/httpd restart

Final steps

Add the following to your ~/.rtorrent.rc

    scgi_port = localhost:5000

Get the latest version of wtorrent & install to your web directory:

    # cd /srv/http
    # svn co http://svn.wtorrent-project.org/wtorrent/trunk/wtorrent/
    # chmod -R 777 wtorrent

Start rtorrent (most common to open a screen and type rtorrent)

Point your browser to http://localhost/wtorrent/install.php and add a
username & password. After you click the "Try configuration" and it
gives you no errors click the "Save configuration"

wTorrent with Lighttpd
----------------------

> Installation

     # pacman -S rtorrent lighttpd php sqlite3

> Configuration

http://www.wtorrent-project.org/trac/wiki/wTorrentInstall#UsingLighttpd

FAQ
---

1. Apache refuses to start when I use "sudo /etc/rc.d/httpd restart",
why?

Use the following to watch out whether your 80 port has been taken by
other apps:

    # ss -tnap | grep ':80'

And terminate that apps then you should start your apache now. You can
use the following to screen the errors of apache:

    $ tail -f /var/log/httpd/error_log

2. Why, when I turn to http://localhost/wtorrent/install.php, it returns
not the wtorrent setup page but a plain text page?

You should check whether or not php is working on your apache. Add
following lines to /etc/httpd/conf/httpd.conf: In LoadModule Section,
add:

    LoadModule php5_module modules/libphp5.so

  
 In Supplemental configuration section add:

    # php5
    Include conf/extra/php5_module.conf

And make sure that

    SCGIMount /RPC2 127.0.0.1:5000

is added after the Supplemental configuration section.

Retrieved from
"https://wiki.archlinux.org/index.php?title=WTorrent&oldid=249128"

Category:

-   Internet Applications
