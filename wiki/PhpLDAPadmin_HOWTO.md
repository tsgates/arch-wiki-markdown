PhpLDAPadmin HOWTO
==================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Pre-Installation                                                   |
| -   2 Adding php-ldap                                                    |
| -   3 Installation                                                       |
| -   4 Configuration                                                      |
| -   5 Accessing your phpMyAdmin installation                             |
+--------------------------------------------------------------------------+

Pre-Installation
----------------

See LAMP for a guide to setting up Apache, MySQL, and PHP.

Adding php-ldap
---------------

PHP needs the php-ldap extension to work with phpLDAPadmin

    pacman -S php-ldap

then edit /etc/php/php.ini and uncomment the line

    ;extension=ldap.so

by removing the ";" so it will look like this

    extension=ldap.so

Now add

    :/usr/share/webapps/phpldapadmin/lib/

to the "open_basedir" line.

Installation
------------

Simply do

    pacman -S phpldapadmin

Configuration
-------------

phpLDAPadmin comes with a usable configuration file located at:

    /etc/webapps/phpldapadmin/config.php

Although not strictly neccessary you can edit config.php and name your
server with the line

    $servers->setValue('server','host','127.0.0.1');

phpLDAPadmin now installs to /usr/share/webapps. This means some changes
to the configuration are required.

Copy the configuration file as follows:

    sudo cp /etc/webapps/phpldapadmin/apache.example.conf /etc/httpd/conf/extra/httpd-phpldapadmin.conf

It should look like this:

      Alias /phpldapadmin "/usr/share/webapps/phpldapadmin"
      <Directory "/usr/share/webapps/phpldapadmin">
        AllowOverride All
        Options FollowSymlinks
        Order allow,deny
        Allow from all
        php_admin_value open_basedir "/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:/usr/share/pear/"
      </Directory>

Note:If you are getting 403 errors, make sure the 'A' is correct case:
phpldapadmin instead of phpldapAdmin.

Add the following lines to /etc/httpd/conf/httpd.conf:

    # phpldapadmin configuration
    Include conf/extra/httpd-phpldapadmin.conf

Edit /usr/share/webapps/phpldapadmin/.htaccess and comment out deny from
all, otherwise you will receive a 403 access denied error. It should
look like this:

    #deny from all

Accessing your phpMyAdmin installation
--------------------------------------

Finally your phpLDAPadmin installation is complete. Before start using
it you need to restart your apache server by following command:

    # /etc/rc.d/httpd restart

You can access your phpLDAPadmin installation using the following url:

    http://serverip/phpldapadmin
    or
    http://localhost/phpldapadmin

Note: 'localhost' is the hostname in your /etc/rc.conf file.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PhpLDAPadmin_HOWTO&oldid=204293"

Category:

-   Web Server
