LAMP
====

Summary

This page explains the installation and configuration of a complete LAMP
server.

Related

MariaDB

PhpMyAdmin

Adminer

Xampp

mod_perl

LAMP refers to a common combination of software used in many web
servers: Linux, Apache, MySQL/MariaDB, and PHP. This article describes
how to set up the Apache HTTP Server on an Arch Linux system. It also
tells you how to optionally install PHP and MariaDB and integrate these
in the Apache server.

If you only need a web server for development and testing, Xampp might
be a better and easier option.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Apache                                                       |
|         -   2.1.1 User directories                                       |
|         -   2.1.2 SSL                                                    |
|         -   2.1.3 Virtual Hosts                                          |
|         -   2.1.4 Advanced Options                                       |
|                                                                          |
|     -   2.2 PHP                                                          |
|         -   2.2.1 Advanced options                                       |
|         -   2.2.2 Using php5 with apache2-mpm-worker and mod_fcgid       |
|                                                                          |
|     -   2.3 MariaDB                                                      |
|                                                                          |
| -   3 External links                                                     |
+--------------------------------------------------------------------------+

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
and start the httpd daemon using systemd.

Apache should now be running. Test by visiting http://localhost/ in a
web browser. It should display a simple Apache test page.

User directories

-   User directories are available by default through
    http://localhost/~user/ and show the contents of ~/public_html (this
    can be changed in /etc/httpd/conf/extra/httpd-userdir.conf).

-   If you do not want user directories to be available on the web,
    comment out the following line in /etc/httpd/conf/httpd.conf:

    Include conf/extra/httpd-userdir.conf

-   You must make sure that your home directory permissions are set
    properly so that Apache can get there. Your home directory and
    ~/public_html/ must be executable for others ("rest of the world").
    This seems to be enough:

    $ chmod o+x ~
    $ chmod o+x ~/public_html

-   A more secure way to share your home folder with Apache is to add
    the http user to the group that owns your home folder. For example,
    if your home folder and other sub-folders in your home folder belong
    to group piter, all you have to do is following:

    # usermod -aG piter http

-   Of course, you have to give read and execute permissions on ~/,
    ~/public_html, and all other sub-folders in ~/public_html to the
    group members (group piter in our case). Do something like the
    following (modify the commands for your specific case):

    $ chmod g+xr-w /home/yourusername
    $ chmod -R g+xr-w /home/yourusername/public_html

Note:This way you do not have to give access to your folder to every
single user in order to give access to http user. Only the http user and
other potential users that are in the piter group will have access to
your home folder.

Restart httpd to apply any changes.

SSL

-   Create a self-signed certificate (you can change the key size and
    the number of days of validity):

    # cd /etc/httpd/conf
    # openssl genrsa -out server.key 2048
    # chmod 600 server.key
    # openssl req -new -key server.key -out server.csr
    # openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

-   Then, in /etc/httpd/conf/httpd.conf, uncomment the line containing:

    Include conf/extra/httpd-ssl.conf

Restart httpd to apply any changes.

Virtual Hosts

-   If you want to have more than one host, uncomment the following line
    in /etc/httpd/conf/httpd.conf:

    Include conf/extra/httpd-vhosts.conf

-   In /etc/httpd/conf/extra/httpd-vhosts.conf set your virtual hosts
    according the example, e.g.:

    /etc/httpd/conf/extra/httpd-vhosts.conf

    NameVirtualHost *:80

    #this first virtualhost enables: http://127.0.0.1, or: http://localhost, 
    #to still go to /srv/http/*index.html(otherwise it will 404_error).
    #the reason for this: once you tell httpd.conf to include extra/httpd-vhosts.conf, 
    #ALL vhosts are handled in httpd-vhosts.conf(including the default one),
    # E.G. the default virtualhost in httpd.conf is not used and must be included here, 
    #otherwise, only domainname1.dom & domainname2.dom will be accessible
    #from your web browser and NOT http://127.0.0.1, or: http://localhost, etc.
    #

    <VirtualHost *:80>
        DocumentRoot "/srv/http"
        ServerAdmin root@localhost
        ErrorLog "/var/log/httpd/127.0.0.1-error_log"
        CustomLog "/var/log/httpd/127.0.0.1-access_log" common
        <Directory /srv/http/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          Allow from all
        </Directory>
    </VirtualHost>

    <VirtualHost *:80>
        ServerAdmin your@domainname1.dom
        DocumentRoot "/home/username/yoursites/domainname1.dom/www"
        ServerName domainname1.dom
        ServerAlias domainname1.dom
        <Directory /home/username/yoursites/domainname1.dom/www/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          Allow from all
    </Directory>
    </VirtualHost>

    <VirtualHost *:80>
        ServerAdmin your@domainname2.dom
        DocumentRoot "/home/username/yoursites/domainname2.dom/www"
        ServerName domainname2.dom
        ServerAlias domainname2.dom
        <Directory /home/username/yoursites/domainname2.dom/www/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          Allow from all
    </Directory>
    </VirtualHost>

-   Add your virtual host names to your /etc/hosts file (not necessary
    if a DNS server is serving these domains already, but will not hurt
    to do it anyway):

    127.0.0.1 domainname1.dom 
    127.0.0.1 domainname2.dom

Restart httpd to apply any changes.

-   If you setup your virtual hosts to be in your user directory,
    sometimes it interferes with Apache's Userdir settings. To avoid
    problems disable Userdir by comment the following line in:

    #Include conf/extra/httpd-userdir.conf

-   As said above, ensure that you have the proper permissions:

    # chmod 0775 /home/yourusername/

-   If you have a huge amount of virtual hosts, you may want to easily
    disable and enable them. It is recommended to create one
    configuration file per virtual host and store them all in one
    folder, eg: /etc/httpd/conf/vhosts.

-   First create the folder:

    # mkdir /etc/httpd/conf/vhosts

-   Then place the single configuration files in it:

    # nano /etc/httpd/conf/vhosts/domainname1.dom
    # nano /etc/httpd/conf/vhosts/domainname2.dom
    ...

-   In the last step, Include the single configurations in your
    /etc/httpd/conf/httpd.conf:

    #Enabled Vhosts:
    Include conf/vhosts/domainname1.dom
    Include conf/vhosts/domainname2.dom

-   You can enable and disable single virtual hosts by commenting or
    uncommenting them.

Advanced Options

These options in /etc/httpd/conf/httpd.conf might be interesting for
you.

    # Listen 80

-   This is the port Apache will listen to. For Internet-access with
    router, you have to forward the port.

If you setup Apache for local development you may want it to be only
accessible from your computer. Then change this line to:

    # Listen 127.0.0.1:80

-   This is the admin's email address which can be found on e.g. error
    pages:

    # ServerAdmin you@example.com

-   This is the directory where you should put your web pages:

    # DocumentRoot "/srv/http"

Change it, if you want to, but do not forget to also change

    <Directory "/srv/http">

to whatever you changed your DocumentRoot too, or you will likely get a
403 Error (lack of privileges) when you try to access the new document
root. Do not forget to change the Deny from all line, otherwise you will
get a 403 Error.

    # AllowOverride None

-   This directive in <Directory> sections causes Apache to completely
    ignore .htaccess files. If you intend to use mod_rewrite or other
    settings in .htaccess files, you can allow which directives declared
    in that file can override server configuration. For more info refer
    to the Apache documentation.

Note:If you have issues with your configuration you can have Apache
check the configuration with: apachectl configtest

-   More settings in /etc/httpd/conf/extra/httpd-default.conf:

-   To turn off your server's signature:

    ServerSignature Off

-   To hide server information like Apache and PHP versions:

    ServerTokens Prod

> PHP

-   To enable PHP, add these lines to /etc/httpd/conf/httpd.conf:

Place this in the LoadModule list anywhere after
LoadModule dir_module modules/mod_dir.so:

     LoadModule php5_module modules/libphp5.so

Place this at the end of the Include list:

     Include conf/extra/php5_module.conf

Make sure that the following line is uncommented in the
<IfModule mime_module> section:

     TypesConfig conf/mime.types

Uncomment the following line (optional):

     MIMEMagicFile conf/magic

-   Add this line in /etc/httpd/conf/mime.types:

     application/x-httpd-php       php    php5

Note:If you do not see libphp5.so in the Apache modules directory
(/etc/httpd/modules), you may have forgotten to install php-apache.

-   If your DocumentRoot is not /srv/http, add it to open_basedir in
    /etc/php/php.ini as such:

     open_basedir=/srv/http/:/home/:/tmp/:/usr/share/pear/:/path/to/documentroot

-   Restart the httpd daemon.

-   To test whether PHP was correctly configured: create a file called
    test.php in your Apache DocumentRoot directory (e.g. /srv/http/ or
    ~/public_html) and inside it put:

    <?php phpinfo(); ?>

To see if it works go to: http://localhost/test.php or
http://localhost/~myname/test.php

If the PHP code is not executed (you see plain text in test.php), check
that you have added Includes to the Options line for your root directory
in /etc/httpd/conf/httpd.conf. Moreover, check that
TypesConfig conf/mime.types is uncommented in the <IfModule mime_module>
section, you may also try adding the following to the
<IfModule mime_module> in httpd.conf:

    AddHandler application/x-httpd-php .php

Advanced options

-   It is recommended to set your timezone (list of timezones) in
    /etc/php/php.ini like so:

    date.timezone = Europe/Berlin

-   If you want to display errors to debug your PHP code, change
    display_errors to On in /etc/php/php.ini:

    display_errors=On

-   If you want the libGD module, install php-gd and uncomment
    extension=gd.so in /etc/php/php.ini:

Note:php-gd requires libpng, libjpeg-turbo, and freetype2.

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

Using php5 with apache2-mpm-worker and mod_fcgid

-   Uncomment following in /etc/conf.d/apache:

    HTTPD=/usr/sbin/httpd.worker

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
            PHP_Fix_Pathinfo_Enable 1
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

-   Make sure /etc/php/php.ini has the directive enabled:

    cgi.fix_pathinfo=1

and restart httpd.

Note:As of Apache 2.4 (the apache24 package is available in the AUR) you
can now use mod_proxy_fcgi (part of the official distribution) with
PHP-FPM (and the new event MPM). See this configuration example.

> MariaDB

-   Configure MySQL/MariaDB as described in MariaDB.

-   Uncomment at least one of the following lines in /etc/php/php.ini:

    extension=pdo_mysql.so
    extension=mysqli.so
    extension=mysql.so

-   You can add minor privileged MySQL users for your web scripts. You
    might also want to edit /etc/mysql/my.cnf and uncomment the
    skip-networking line so the MySQL server is only accessible by the
    localhost. You have to restart MySQL for changes to take effect.

-   Restart the httpd daemon.

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
"https://wiki.archlinux.org/index.php?title=LAMP&oldid=254986"

Category:

-   Web Server
