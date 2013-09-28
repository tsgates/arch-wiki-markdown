RuTorrent
=========

  Summary
  --------------------------------------------------------------------------------
  This article covers the installation of ruTorrent and configuring with Apache.

ruTorrent is a web interface to rtorrent (a console based BitTorrent
client). It uses rtorrent's build-in xmlrpc server to communicate with
it.

It is lightweight, highly extensible, and is designed to look similar to
uTorrent.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Web Server Configuration                                           |
|     -   2.1 Apache                                                       |
|                                                                          |
| -   3 ruTorrent Configuration                                            |
| -   4 See Also                                                           |
| -   5 External Links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install rutorrent and optionally rutorrent-plugins from the AUR.

Web Server Configuration
------------------------

> Apache

Install and configure Apache with PHP according to the LAMP page.

-   Edit the open_basedir value in /etc/php/php.ini to include:

    /etc/webapps/rutorrent/conf/:/usr/share/webapps/rutorrent/php/:/usr/share/webapps/rutorrent/

Install mod_scgi from the AUR.

-   Load the SCGI module in /etc/httpd/conf/httpd.conf:

    LoadModule scgi_module modules/mod_scgi.so

-   Enable the rTorrent XMLRPC interface: rTorrent#XMLRPC_interface

-   Enable SCGI on the port you chose for rTorrent by adding this to
    /etc/httpd/conf/httpd.conf:

    SCGIMount /RPC2 127.0.0.1:5000

-   Lastly, add the ruTorrent folder to /etc/httpd/conf/httpd.conf with
    something similar to this:

    <IfModule alias_module>
      Alias /rutorrent /usr/share/webapps/rutorrent
      <Directory "/usr/share/webapps/rutorrent">
        Order allow,deny
        Allow from all
      </Directory>
    </IfModule>

Note:You should enable authentication through Apache if your site is
public.

ruTorrent Configuration
-----------------------

See upstream wiki here.

See Also
--------

-   LAMP
-   rtorrent

External Links
--------------

-   http://code.google.com/p/rutorrent/wiki/TableOfContents?tm=6
-   http://httpd.apache.org/docs/2.2/configuring.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=RuTorrent&oldid=248774"

Category:

-   Internet Applications
