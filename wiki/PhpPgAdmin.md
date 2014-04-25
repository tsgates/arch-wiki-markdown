phpPgAdmin
==========

Related articles

-   PostgreSQL

phpPgAdmin is a web-based tool to help manage PostgreSQL databases using
an Apache/PHP frontend. It requires a working LAMP setup.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 PHP
    -   2.2 Web severs
        -   2.2.1 Apache
        -   2.2.2 Lighttpd Configuration
        -   2.2.3 NGINX Configuration
    -   2.3 phpPgAdmin configuration
-   3 Accessing your phpPgAdmin installation
-   4 Troubleshooting Login disallowed for security reasons

Installation
------------

Install the phppgadmin package from the official repositories.

Configuration
-------------

> PHP

You need to enable the pgsql extension in PHP by editing
/etc/php/php.ini and uncommenting the following line:

    extension=pgsql.so

You need to make sure that PHP can access /etc/webapps. Add it to
open_basedir in /etc/php/php.ini if necessary:

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/:/etc/webapps

> Web severs

Apache

Create the Apache configuration file:

    # /etc/httpd/conf/extra/httpd-phppgadmin.conf

    Alias /phppgadmin "/usr/share/webapps/phppgadmin"
    <Directory "/usr/share/webapps/phppgadmin">
        DirectoryIndex index.html index.php
        AllowOverride All
        Options FollowSymlinks
        Require all granted
    </Directory>

And include it in /etc/httpd/conf/httpd.conf:

    # phpPgAdmin configuration
    Include conf/extra/httpd-phppgadmin.conf

By default, everyone can see the phpPgAdmin page, to change this, edit
/etc/httpd/conf/extra/httpd-phppgadmin.conf to your liking. For example,
if you only want to be able to access it from the same machine, replace
Require all granted by Require local.

Lighttpd Configuration

The php setup for lighttpd is exactly the same as for apache. Make an
alias for phppgadmin in your lighttpd config.

     alias.url = ( "/phppgadmin" => "/usr/share/webapps/phppgadmin/")

Then enable mod_alias, mod_fastcgi and mod_cgi in your config (
server.modules section )

Update open_basedir in /etc/php/php.ini and add "/usr/share/webapps/".

     open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/

Make sure lighttpd is setup to serve php files, Lighttpd#FastCGI

Restart lighttpd and browse to http://localhost/phppgadmin/index.php

NGINX Configuration

Also similar to apache configuration (and Lighttpd, for that matter).

Create a symbolic link to the /usr/share/webapps/phppgadmin directory
from whichever directory your vhost is serving files from, e.g.
/srv/http/<domain>/public_html/

     sudo ln -s /usr/share/webapps/phppgadmin /srv/http/<domain>/public_html/phppgadmin

You can also setup a sub domain with a server block like so (if using
php-fpm):

     server {
             server_name     phppgadmin.<domain.tld>;
             access_log      /srv/http/<domain>/logs/phppgadmin.access.log;
             error_log       /srv/http/<domain.tld>/logs/phppgadmin.error.log;
     
             location / {
                     root    /srv/http/<domain.tld>/public_html/phppgadmin;
                     index   index.html index.htm index.php;
             }
     
             location ~ \.php$ {
                     root            /srv/http/<domain.tld>/public_html/phppgadmin;
                     fastcgi_pass    unix:/var/run/php-fpm/php-fpm.sock;
                     fastcgi_index   index.php;
                     fastcgi_param   SCRIPT_FILENAME  /srv/http/<domain.tld>/public_html/phppgadmin/$fastcgi_script_name;
                     include         fastcgi_params;
             }
     }

> phpPgAdmin configuration

phpPgAdmin's configuration file is located at
/etc/webapps/phppgadmin/config.inc.php. If you have a local MySQL
server, it should be usable without making any modifications.

If your PostgreSQL server is not on the localhost, edit the following
line:

    $conf['servers'][0]['host'] = ;

Accessing your phpPgAdmin installation
--------------------------------------

Your phpPgAdmin installation is now complete. Before start using it you
need to restart your apache server by following command:

    # systemctl restart httpd.service

You can access your phpPgAdmin installation by going to
http://localhost/phppgadmin/

Troubleshooting Login disallowed for security reasons
-----------------------------------------------------

If extra login security is true, then logins via phpPgAdmin with no
password or certain usernames (pgsql, postgres, root, administrator)
will be denied. Only set this to false once you have read the FAQ and
understand how to change PostgreSQL's pg_hba.conf to enable passworded
local connections.

Edit /usr/share/webapps/phppgadmin/conf/config.inc.php and change the
following line

     $conf['extra_login_security'] = true;

to

     $conf['extra_login_security'] = false;

Retrieved from
"https://wiki.archlinux.org/index.php?title=PhpPgAdmin&oldid=305324"

Category:

-   Web Server

-   This page was last modified on 17 March 2014, at 12:48.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
