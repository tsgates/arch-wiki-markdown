Rtgui
=====

rtGui is a web based front end for rTorrent - the Linux command line
BitTorrent client. It is written in PHP and uses XML-RPC to communicate
with the rTorrent client.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Apache configuration                                               |
| -   3 PHP configuration                                                  |
| -   4 rTorrent configuration                                             |
| -   5 Restart Apache                                                     |
| -   6 rtGui installation                                                 |
+--------------------------------------------------------------------------+

Installing
----------

Installing via pacman

     $ pacman -S rtorrent apache php php-apache

The Apache module mod_scgi is currently only available through the AUR.
You could build it yourself or install it with a AUR helper such as
yaourt.

     $ yaourt -S mod_scgi

Apache configuration
--------------------

Adding the mod_scgi module to httpd.conf

     $ sudo nano /etc/httpd/conf/httpd.conf

Find the LoadModule section and add:

      LoadModule scgi_module modules/mod_scgi.so

At the end of the file:

     LoadModule php5_module modules/libphp5.so
     Include conf/extra/php5_module.conf
     SCGIMount /RPC2 127.0.0.1:5000

PHP configuration
-----------------

PHP adjust per php.ini

     $ sudo nano /etc/php/php.ini

uncomment these extensions

     extension=sockets.so
     extension=xmlrpc.so

change the value of these settings from off to on

     allow_url_fopen = On
     allow_url_include = On

rTorrent configuration
----------------------

You need to adjust the .rtorrent.rc and add the following line

     scgi_port = localhost:5000

Restart Apache
--------------

     $ sudo /etc/rc.d/httpd restart

rtGui installation
------------------

Download and extract rtgui from source, then copy and edit the
config.php

     cd /srv/http/
     tar xvzf rtgui-x.x.x.tgz 
     cd rtgui/
     cp config.php.example config.php 
     nano config.php

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rtgui&oldid=206494"

Category:

-   Internet Applications
