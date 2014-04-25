Xampp
=====

XAMPP is an easy to install Apache distribution containing MySQL, PHP
and Perl. It contains: Apache, MySQL, PHP & PEAR, Perl, ProFTPD,
phpMyAdmin, OpenSSL, GD, Freetype2, libjpeg, libpng, gdbm, zlib, expat,
Sablotron, libxml, Ming, Webalizer, pdf class, ncurses, mod_perl,
FreeTDS, gettext, mcrypt, mhash, eAccelerator, SQLite and IMAP C-Client.

Contents
--------

-   1 Installation
    -   1.1 AUR installation
    -   1.2 Manual installation
-   2 Configuration
-   3 Usage
-   4 Hosting files outside the htdocs directory
-   5 Debugging and profiling with Xdebug and Xampp
-   6 PhpMyAdmin 403 Access Forbidden
-   7 Local test server security

Installation
------------

> AUR installation

Install xampp from AUR.

Note:If you are running 64-bit arch, you must install lib32-glibc and
gcc-libs-multilib from the multilib repository.

To avoid being forced to install the prerequisites, you can opt for a
manual installation.

> Manual installation

1.  Download the latest version from here.
2.  The downloaded file is an installer script. Make it executable and
    run it by typing:

    # chmod +x xampp-linux-x64-1.8.2-1-installer.run
    # ./xampp-linux-x64-1.8.2-1-installer.run

assuming version 1.8.2-1. Otherwise adapt the correct version number

Removal

Be sure to stop all lampp services.

    # /opt/lampp/lampp stop

All the files needed by Xampp to be installed are located in the
previous /opt/lampp folder. So, to uninstall Xampp, consider this
command.

    # rm -rf /opt/lampp

Note:If you created symlinks, you may need to destroy them too.

Configuration
-------------

Setting the individual parts of XAMPP can by made by editing following
files:

/opt/lampp/etc/httpd.conf - Apache configuration. For example you can
change folder with web page's source files.

/opt/lampp/etc/php.ini - PHP configuration.

/opt/lampp/phpmyadmin/config.inc.php - phpMyAdmin configuration.

/opt/lampp/etc/proftpd.conf - proFTP configuration.

/opt/lampp/etc/my.cnf - MySQL configuration.

If you would like to set up security of server, you can do it simply by
this command:

    # /opt/lampp/lampp security

You will be asked step by step to choose passwords for web page's
access, user "pma" for phpMyAdmin, user "root" for MySQL and user
"nobody" for proFTP.

Usage
-----

Use the following commands to control XAMPP:

    # /opt/lampp/lampp start,stop,restart

If you get this error when you start it:

    Starting XAMPP for Linux 1.7.7...
    /opt/lampp/lampp: line 21: netstat: command not found
    /opt/lampp/lampp: line 21: netstat: command not found
    XAMPP: Starting Apache with SSL (and PHP5)...
    /opt/lampp/lampp: line 241: /bin/hostname: No such file or directory
    /opt/lampp/lampp: line 21: netstat: command not found
    XAMPP: Starting MySQL...
    /opt/lampp/bin/mysql.server: line 263: hostname: command not found
    /opt/lampp/lampp: line 21: netstat: command not found
    XAMPP: Starting ProFTPD...
    XAMPP for Linux started.

Install net-tools and inetutils from the official repositories and you
are good to go.

Hosting files outside the htdocs directory
------------------------------------------

The document root (web root) directory is located at /opt/lampp/htdocs/.
All files placed in this directory will be processed by the web server.

To host other files on your system with XAMPP, you can configure an
alias with apache.

-   Edit apache's httpd.conf with your favorite editor.

    # nano /opt/lampp/etc/httpd.conf

-   Find "DocumentRoot", you will see something like:

    DocumentRoot "/opt/lampp/htdocs"
    <Directory "/opt/lampp/htdocs">
        ...    
        ...

    </Directory>

-   In the next line after "</Directory>" paste this:

    <Directory "/yourDirectory/">
        Options Indexes FollowSymLinks ExecCGI Includes
        AllowOverride All
        Require all granted
    </Directory>

-   Next find the "<IfModule alias_module>":

    <IfModule alias_module>

        #
        # Redirect: Allows you to tell clients about documents that used to 
        # exist in your server's namespace, but do not anymore. The client 
        # will make a new request for the document at its new location.
        # Example:
        # Redirect permanent /foo http://www.example.com/bar
      ...
    </IfModule>

-   And before the "</IfModule>" paste this:

    Alias /yourAlias /yourDirectory/

-   Now do not forget to restart Apache:

    # /opt/lampp/lampp restart

This will allow you to host files from your home directory (or any other
directory) with XAMPP.

In the above example, you can access the files by pointing your web
browser to localhost/yourAlias.

Debugging and profiling with Xdebug and Xampp
---------------------------------------------

For detailed instructions go here.

You must first download the Xampp Development Tools from the same
download page here.

Extract this into your Xampp directory:

    # tar xvfz xampp-linux-devel-x.x.x.tar.gz -C /opt

You should be able to successfully run

    /opt/lampp/bin/phpize

in your xdebug folder.

PhpMyAdmin 403 Access Forbidden
-------------------------------

If your http://localhost/phpmyadmin returns "403 Access Forbidden", you
need to edit the following settings in
/opt/lampp/etc/extra/httpd-xampp.conf:

    <Directory "/opt/lampp/phpmyadmin">
    	AllowOverride AuthConfig Limit
    	#Order allow,deny
    	#Allow from all
    	Require all granted
    </Directory>

Local test server security
--------------------------

Apache and MySQL can be configured so that they only listen to requests
from your own computer. For most test systems this is fine and it
greatly reduces the risk because the services are not reachable from the
Internet.

Before you start XAMPP for the first time find and edit these files:

For Apache edit the files xampp\apache\conf\httpd.conf and
xampp\apache\conf\extra\httpd-ssl.conf. Look for lines starting with
"Listen" such as

    Listen 80

and replace them with

    Listen 127.0.0.1:80

For MySQL open the file xampp\mysql\bin\my.cnf find the section
"[mysqld]" and add this line

    bind-address=localhost

After starting the services, verify the result by going to a command
window and start and execute:

    netstat -a -n

For the entries marked as LISTEN in the last column, look at the Listen
column. It should always start with 127.0.0.1 or ::1 but not with
0.0.0.0.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xampp&oldid=277411"

Category:

-   Web Server

-   This page was last modified on 3 October 2013, at 06:48.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
