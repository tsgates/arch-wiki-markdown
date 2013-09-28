Xampp
=====

XAMPP is an easy to install Apache distribution containing MySQL, PHP
and Perl. It contains: Apache, MySQL, PHP & PEAR, Perl, ProFTPD,
phpMyAdmin, OpenSSL, GD, Freetype2, libjpeg, libpng, gdbm, zlib, expat,
Sablotron, libxml, Ming, Webalizer, pdf class, ncurses, mod_perl,
FreeTDS, gettext, mcrypt, mhash, eAccelerator, SQLite and IMAP C-Client.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 AUR                                                          |
|     -   1.2 Manual                                                       |
|                                                                          |
| -   2 Configuration                                                      |
| -   3 Usage                                                              |
| -   4 Removal                                                            |
| -   5 Hosting files outside the htdocs directory                         |
| -   6 Debugging and Profiling with Xdebug and Xampp                      |
| -   7 PhpMyAdmin 403 Access Forbidden                                    |
+--------------------------------------------------------------------------+

Installation
------------

> AUR

-   Xampp package in the AUR

> Manual

1.  Download the latest version from here.
2.  In the terminal run the following from the folder where the archive
    was downloaded to:

        # tar xvfz xampp-linux-*.tar.gz -C /opt

Note:If you are running 64-bit arch, you must install lib32-glibc and
gcc-libs-multilib.

    # pacman -S lib32-glibc gcc-libs-multilib

to do this you must have activated the multilib repository in
/etc/pacman.conf

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

Install net-tools and inetutils from [core] and you are good to go:

    # pacman -S net-tools inetutils

Removal
-------

Be sure to stop all lampp services.

    # /opt/lampp/lampp stop

All the files needed by Xampp to be installed are located in the
previous /opt/lampp folder. So, to uninstall Xampp, consider this
command.

    # rm -rf /opt/lampp

NOTE:If you had create symlinks, you need to destroy them too!

Hosting files outside the htdocs directory
------------------------------------------

The document root (web root) directory is located at /opt/lampp/htdocs/.
All files placed in this directory will be processed by the web server.

To host other files on your system with XAMPP, you can configure an
alias with apache.

1.  Edit apache's httpd.conf with your favorite editor.

        nano /opt/lampp/etc/httpd.conf

2.  In the Alias section, add an alias:

    <IfModule alias_module>
        Alias /test /home/web
            <directory /home/web>
                AllowOverride FileInfo Limit Options Indexes
                Order allow,deny
                Allow from all
                Require all granted
            </directory>

        ...    
        ...

    </IfModule>

You also have to change the permissions. You can use your own username,
and leave the group setting alone. In that case, any folder where you
have access will work. Another way is to leave the user setting, and
change the group to something else which your user is part of (for when
you want to restrict a folder to be group-writable only). Yet another
way is to just change both user and group to 'http', which should
already exist. In this case, all folders you want to allow for
processing must belong to at least the 'http' group.

    <IfModule !mpm_netware_module>
    User http
    Group http
    </IfModule>

Now do not forget to restart apache:

    # /opt/lampp/lampp restart

This will allow you to host files from your home directory (or any other
directory) with XAMPP.

In the above example, you can access the files by pointing your web
browser to localhost/test.

Debugging and Profiling with Xdebug and Xampp
---------------------------------------------

For detailed instructions go here.

You must first download the Xampp Development Tools from the same
download page here.

Extract this into your Xampp directory.

    tar xvfz xampp-linux-devel-x.x.x.tar.gz -C /opt

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

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xampp&oldid=243167"

Category:

-   Web Server
