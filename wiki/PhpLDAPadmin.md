phpLDAPadmin
============

phpLDAPadmin is an web-based LDAP adminstration interface.

Contents
--------

-   1 Pre-Installation
-   2 Installation
-   3 Configuration
    -   3.1 Apache
    -   3.2 PHP
    -   3.3 phpLDAPadmin configuration
-   4 Accessing your phpLDAPadmin installation

Pre-Installation
----------------

See LAMP for a guide to setting up Apache, MySQL, and PHP.

Installation
------------

Install the package phpldapadmin from the official repositories.

Configuration
-------------

> Apache

Create the Apache configuration file:

    # /etc/httpd/conf/extra/httpd-phpldapadmin.conf

    Alias /phpldapadmin "/usr/share/webapps/phpldapadmin"
    <Directory "/usr/share/webapps/phpldapadmin">
        DirectoryIndex index.html index.php
        AllowOverride All
        Options FollowSymlinks
        Require all granted
    </Directory>

And include it in /etc/httpd/conf/httpd.conf:

    # phpLDAPadmin configuration
    Include conf/extra/httpd-phpldapadmin.conf

By default, everyone can see the phpLDAPadmin page, to change this, edit
/etc/httpd/conf/extra/httpd-phpldapadmin.conf to your liking. For
example, if you only want to be able to access it from the same machine,
replace Require all granted by Require local.

> PHP

You need to enable the php-ldap extension in PHP by editing
/etc/php/php.ini and uncommenting the line

    ;extension=ldap.so

You need to make sure that PHP can access /etc/webapps. Add it to
open_basedir in /etc/php/php.ini if necessary:

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/:/etc/webapps

> phpLDAPadmin configuration

phpLDAPadmin's configuration file is located at
/etc/webapps/phpldapadmin/config.php. If you have a local LDAP server,
it should be usable without making any modifications.

If your LDAP server is not on the localhost, uncomment and edit the
following line:

    $servers->setValue('server','host','127.0.0.1');

Although not strictly necessary you can name your server by editing the
following line:

    $servers->setValue('server','name','My LDAP server');

Accessing your phpLDAPadmin installation
----------------------------------------

Your phpLDAPadmin installation is now complete. Before start using it
you need to restart Apache.

You can access your phpLDAPadmin installation by going to
http://localhost/phpldapadmin/

Retrieved from
"https://wiki.archlinux.org/index.php?title=PhpLDAPadmin&oldid=303732"

Category:

-   Web Server

-   This page was last modified on 9 March 2014, at 09:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
