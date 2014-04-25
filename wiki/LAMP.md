LAMP
====

Related articles

-   MariaDB
-   PhpMyAdmin
-   Adminer
-   Xampp
-   mod_perl

LAMP refers to a common combination of software used in many web
servers: Linux, Apache, MySQL/MariaDB, and PHP. This article describes
how to set up the Apache HTTP Server on an Arch Linux system. It also
tells you how to optionally install PHP and MariaDB and integrate these
in the Apache server.

If you only need a web server for development and testing, Xampp might
be a better and easier option.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Apache
        -   2.1.1 User directories
        -   2.1.2 SSL
        -   2.1.3 Virtual Hosts
            -   2.1.3.1 Managing lots of virtual hosts
        -   2.1.4 Advanced Options
        -   2.1.5 Troubleshooting
    -   2.2 PHP
        -   2.2.1 Advanced options
        -   2.2.2 Using php5 with php-fpm, mod_proxy_fcgi and
            mod_proxy_handler
        -   2.2.3 Using php5 with apache2-mpm-worker and mod_fcgid
    -   2.3 MariaDB
-   3 External links

Installation
------------

This document assumes you will install Apache, PHP and MariaDB together.
If desired however, you may install Apache, PHP, and MariaDB separately
and simply refer to the relevant sections below.

You can install apache, php, php-apache and mariadb from the official
repositories.

Configuration
-------------

> Apache

For security reasons, as soon as Apache is started by the root user
(directly or via startup scripts) it switches to the UID/GID specified
in /etc/httpd/conf/httpd.conf. The default is user http and it is
created automatically during installation.

Change httpd.conf and optionally extra/httpd-default.conf to your liking
and start httpd.service using systemd.

Apache should now be running. Test by visiting http://localhost/ in a
web browser. It should display a simple Apache test page.

User directories

User directories are available by default through
http://localhost/~yourusername/ and show the contents of ~/public_html
(this can be changed in /etc/httpd/conf/extra/httpd-userdir.conf).

If you do not want user directories to be available on the web, comment
out the following line in /etc/httpd/conf/httpd.conf:

    Include conf/extra/httpd-userdir.conf

You must make sure that your home directory permissions are set properly
so that Apache can get there. Your home directory and ~/public_html/
must be executable for others ("rest of the world"). This seems to be
enough:

    $ chmod o+x ~
    $ chmod o+x ~/public_html

Restart httpd.service to apply any changes.

SSL

To use SSL, you will need to install openssl.

Create a self-signed certificate (you can change the key size and the
number of days of validity):

    # cd /etc/httpd/conf
    # openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out server.key
    # chmod 600 server.key
    # openssl req -new -key server.key -out server.csr
    # openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

Then, in /etc/httpd/conf/httpd.conf, uncomment the following three
lines:

    LoadModule ssl_module modules/mod_ssl.so
    LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
    Include conf/extra/httpd-ssl.conf

Restart httpd.service to apply any changes.

Virtual Hosts

If you want to have more than one host, uncomment the following line in
/etc/httpd/conf/httpd.conf:

    Include conf/extra/httpd-vhosts.conf

In /etc/httpd/conf/extra/httpd-vhosts.conf set your virtual hosts. The
default file contains an elaborate example that should help you get
started.

To test the virtual hosts on you local machine, add the virtual names to
your /etc/hosts file:

    127.0.0.1 domainname1.dom 
    127.0.0.1 domainname2.dom

If you want to use SSL on vhosts, copy the file httpd-ssl.conf to a
custom named *.conf file, copy the <VirtualHost .. </VirtualHost> block
to the number of vhosts, edit the file so it matches with the
httpd-vhosts.conf file and change line SSL
Include conf/extra/httpd-ssl.conf inside /etc/httpd/conf/httpd.conf:

    cp -R /etc/httpd/conf/extra/httpd-ssl.conf /etc/httpd/conf/extra/httpd-ssl-vhosts.conf

Restart httpd.service to apply any changes.

Managing lots of virtual hosts

If you have a huge amount of virtual hosts, you may want to easily
disable and enable them. It is recommended to create one configuration
file per virtual host and store them all in one folder, eg:
/etc/httpd/conf/vhosts.

First create the folder:

    # mkdir /etc/httpd/conf/vhosts

Then place the single configuration files in it:

    # nano /etc/httpd/conf/vhosts/domainname1.dom
    # nano /etc/httpd/conf/vhosts/domainname2.dom
    ...

In the last step, Include the single configurations in your
/etc/httpd/conf/httpd.conf:

    #Enabled Vhosts:
    Include conf/vhosts/domainname1.dom
    Include conf/vhosts/domainname2.dom

You can enable and disable single virtual hosts by commenting or
uncommenting them.

Advanced Options

These options in /etc/httpd/conf/httpd.conf might be interesting for
you:

    Listen 80

This is the port Apache will listen to. For Internet-access with router,
you have to forward the port.

If you want to setup Apache for local development you may want it to be
only accessible from your computer. Then change this line to
Listen 127.0.0.1:80.

    ServerAdmin you@example.com

This is the admin's email address which can be found on e.g. error
pages.

    DocumentRoot "/srv/http"

This is the directory where you should put your web pages.

Change it, if you want to, but do not forget to also change
<Directory "/srv/http"> to whatever you changed your DocumentRoot too,
or you will likely get a 403 Error (lack of privileges) when you try to
access the new document root. Do not forget to change the
Require all denied line, otherwise you will get a 403 Error.

    AllowOverride None

This directive in <Directory> sections causes Apache to completely
ignore .htaccess files. If you intend to use mod_rewrite or other
settings in .htaccess files, you can allow which directives declared in
that file can override server configuration. For more info refer to the
Apache documentation.

Tip:If you have issues with your configuration you can have Apache check
the configuration with: apachectl configtest

More settings can be found in /etc/httpd/conf/extra/httpd-default.conf:

To turn off your server's signature:

    ServerSignature Off

To hide server information like Apache and PHP versions:

    ServerTokens Prod

Troubleshooting

If you encounter Error: PID file /run/httpd/httpd.pid not readable
(yet?) after start.

Comment out the unique_id_module:

     #LoadModule unique_id_module modules/mod_unique_id.so

> PHP

Note:libphp5.so included with php-apache does not work with
mod_mpm_event (FS#39218). You'll have to use mod_mpm_prefork instead.
Otherwise you will get the following error:

    Apache is running a threaded MPM, but your PHP Module is not compiled to be threadsafe.  You need to recompile PHP.
    AH00013: Pre-configuration failed
    httpd.service: control process exited, code=exited status=1

To use mod_mpm_prefork, open /etc/httpd/conf/httpd.conf and replace

    LoadModule mpm_event_module modules/mod_mpm_event.so

with

    LoadModule mpm_prefork_module modules/mod_mpm_prefork.so

As an alternative, you can use mod_proxy_handler (see #Using php5 with
php-fpm, mod_proxy_fcgi and mod_proxy_handler below).

To enable PHP, add these lines to /etc/httpd/conf/httpd.conf:

-   Place this in the LoadModule list anywhere after
    LoadModule dir_module modules/mod_dir.so:

    LoadModule php5_module modules/libphp5.so

-   Place this at the end of the Include list:

    Include conf/extra/php5_module.conf

If your DocumentRoot is not /srv/http, add it to open_basedir in
/etc/php/php.ini as such:

    open_basedir=/srv/http/:/home/:/tmp/:/usr/share/pear/:/path/to/documentroot

Restart httpd.service using systemd

To test whether PHP was correctly configured: create a file called
test.php in your Apache DocumentRoot directory (e.g. /srv/http/ or
~/public_html) with the following contents:

    <?php phpinfo(); ?>

To see if it works go to: http://localhost/test.php or
http://localhost/~myname/test.php

Advanced options

-   It is recommended to set your timezone (list of timezones) in
    /etc/php/php.ini like so:

    date.timezone = Europe/Berlin

-   If you want to display errors to debug your PHP code, change
    display_errors to On in /etc/php/php.ini:

    display_errors=On

-   If you want the libGD module, install php-gd and uncomment
    extension=gd.so in /etc/php/php.ini:

    extension=gd.so

Note:Pay attention to which extension you uncomment, as this extension
is sometimes mentioned in an explanatory comment before the actual line
you want to uncomment.

-   If you want the mcrypt module, install php-mcrypt and uncomment
    extension=mcrypt.so in /etc/php/php.ini:

    extension=mcrypt.so

-   Remember to add a file handler for .phtml, if you need it, in
    /etc/httpd/conf/extra/php5_module.conf:

    DirectoryIndex index.php index.phtml index.html

Using php5 with php-fpm, mod_proxy_fcgi and mod_proxy_handler

Note:Unlike the widespread setup with ProxyPass, the proxy configuration
with mod_proxy_handler and SetHandler respects other Apache directives
like DirectoryIndex. This ensures a better compatibility with software
designed for libphp5, mod_fastcgi and mod_fcgid. If you still want to
try ProxyPass, experiment with a line like this:

    ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000/srv/http/$1

-   Install php-fpm and mod_proxy_handler

-   Set listen in /etc/php/php-fpm.conf like this:

    ; use ip/port instead of unix socket, mod_proxy_fcgi does not support it
    listen = 127.0.0.1:9000
    ;listen = /run/php-fpm/php-fpm.sock

    listen.allowed_clients = 127.0.0.1

-   Append following to /etc/httpd/conf/httpd.conf:

    LoadModule proxy_handler_module modules/mod_proxy_handler.so
    <FilesMatch \.php$>
        SetHandler "proxy:fcgi://127.0.0.1:9000/"
    </FilesMatch>
    <IfModule dir_module>
        DirectoryIndex index.php index.html
    </IfModule>

-   Restart the restart apache php-fpm daemon again.

    # systemctl restart httpd.service php-fpm.service

Using php5 with apache2-mpm-worker and mod_fcgid

-   Uncomment following in /etc/conf.d/apache:

    HTTPD=/usr/bin/httpd.worker

-   Uncomment following in /etc/httpd/conf/httpd.conf:

    Include conf/extra/httpd-mpm.conf

-   Install the mod_fcgid and php-cgi packages from the official
    repositories.

-   Create /etc/httpd/conf/extra/php5_fcgid.conf with following content:

    /etc/httpd/conf/extra/php5_fcgid.conf

    # Required modules: fcgid_module

    <IfModule fcgid_module>
    	AddHandler php-fcgid .php
    	AddType application/x-httpd-php .php
    	Action php-fcgid /fcgid-bin/php-fcgid-wrapper
    	ScriptAlias /fcgid-bin/ /srv/http/fcgid-bin/
    	SocketPath /var/run/httpd/fcgidsock
    	SharememPath /var/run/httpd/fcgid_shm
            # If you don't allow bigger requests many applications may fail (such as WordPress login)
            FcgidMaxRequestLen 536870912
            # Path to php.ini – defaults to /etc/phpX/cgi
            DefaultInitEnv PHPRC=/etc/php/
            # Number of PHP childs that will be launched. Leave undefined to let PHP decide.
            #DefaultInitEnv PHP_FCGI_CHILDREN 3
            # Maximum requests before a process is stopped and a new one is launched
            #DefaultInitEnv PHP_FCGI_MAX_REQUESTS 5000
            <Location /fcgid-bin/>
    		SetHandler fcgid-script
    		Options +ExecCGI
    	</Location>
    </IfModule>

-   Create the needed directory and symlink it for the PHP wrapper:

    # mkdir /srv/http/fcgid-bin
    # ln -s /usr/bin/php-cgi /srv/http/fcgid-bin/php-fcgid-wrapper

-   Edit /etc/httpd/conf/httpd.conf:

    #LoadModule php5_module modules/libphp5.so
    LoadModule fcgid_module modules/mod_fcgid.so
    Include conf/extra/php5_fcgid.conf

and restart httpd.

Note:As of Apache 2.4 you can now use mod_proxy_fcgi (part of the
official distribution) with PHP-FPM (and the new event MPM). See this
configuration example.

> MariaDB

Configure MySQL/MariaDB as described in MariaDB.

Uncomment at least one of the following lines in /etc/php/php.ini:

    extension=pdo_mysql.so
    extension=mysqli.so

Warning:As of PHP 5.5, mysql.so is deprecated and will fill up your log
files.

You can add minor privileged MySQL users for your web scripts. You might
also want to edit /etc/mysql/my.cnf and uncomment the skip-networking
line so the MySQL server is only accessible by the localhost. You have
to restart MySQL for changes to take effect.

Restart httpd.service using systemd

Tip:You may want to install a tool like phpMyAdmin, Adminer or
mysql-workbench to work with your databases.

External links
--------------

-   Apache Official Website
-   PHP Official Website
-   MariaDB Official Website
-   Tutorial for creating self-signed certificates
-   Apache Wiki Troubleshooting

Retrieved from
"https://wiki.archlinux.org/index.php?title=LAMP&oldid=305909"

Category:

-   Web Server

-   This page was last modified on 20 March 2014, at 17:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
