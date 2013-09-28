Suphp
=====

suPHP is a tool for executing PHP scripts with the permissions of their
owners. It consists of an Apache module (mod_suphp) and a setuid root
binary (suphp) that is called by the Apache module to change the uid of
the process executing the PHP interpreter.

Tip:With suPHP you are able, for example, to manage php applications in
user's home directories without worry about permissions problems (when
creating directories, files or uploads)

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Additional information                                             |
| -   4 suPHP and mod_php                                                  |
|     -   4.1 suPHP in user directories                                    |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

> Installation

In order to install suPHP, you need to install its dependencies from the
Official Repositories:

    # pacman -S apache php-cgi apr-util

Install suPHP from AUR here suphp

> Configuration

To activate mod_suphp for the appropriate Virtual Hosts add a line like
in your /etc/http/conf/http.conf file:

    /etc/http/conf/http.conf

    #suPHP
    LoadModule suphp_module modules/mod_suphp.so

To use suPHP to parse PHP-Files you must add also this:

    /etc/http/conf/http.conf

     AddType application/x-httpd-php .php

Then, for actually turn on mod_suphp add this line:

    /etc/http/conf/http.conf

     suPHP_Engine on

Finally, you have to specify at least one suPHP_AddHandler directive,
because mod_suphp by default handles no mime-type.

    /etc/http/conf/http.conf

    suPHP_AddHandler application/x-httpd-php

Finally your suPHP installation is complete. Before start using it you
need to restart your apache server by following command:

    # rc.d restart httpd

Note:If these changes are made in global Apache-configuration file, this
will activate mod_suphp for all Virtual Hosts..

> Additional information

Please note, that running mod_suphp and mod_php concurrently should be
avoided. The same applies to CGI scripts which are run with webserver
privileges.

suPHP should only be used if you are using no CGI scripts or if all CGI
scripts are run using suExec.

Warning:If you use suphp module instead of mod_php (php-apache) one, you
won't be able to use phpMyadmin and some other applications because
incompatibilities with php-cgi interpeter.

suPHP and mod_php
-----------------

In order to use suPHP along side mod_php (for use phpMyAdmin for
instance). The only way to go is configure suPHP and mod_php in
differents Virtual Hosts or Directories.

> suPHP in user directories

The following instructions intent to show how to configure suPHP just to
work in users public_html directories and mod_php for everything else.

First of all, you need to change the suPHP handler name to avoid
confilcts with php_module. Change this line in /etc/suphp/suphp.conf

    /etc/suphp/suphp.conf

    [handlers]
    ;Handler for php-scripts
    application/x-httpd-suphp="php:/usr/bin/php-cgi"

Add or modify this line in your /etc/http/conf/http.conf file:

    /etc/http/conf/http.conf

    #suPHP
    LoadModule suphp_module modules/mod_suphp.so

Then, in order to set the suPHP module for user directories, add this to
your /etc/http/conf/extra/http-userdir.conf file:

    /etc/httpd/conf/extra/httpd-userdir.conf

    <Directory "/home/*/public_html">
    ...
        DirectoryIndex index.php index.html
        suPHP_Engine on
        AddHandler application/x-httpd-suphp .php
        suPHP_AddHandler application/x-httpd-suphp
    ...
    </Directory>

Finally you need to restart your apache server by following command:

    # rc.d restart httpd

See also
--------

-   MySQL - Article for MySQL
-   LAMP - Guide to setting up Apache, MySQL, and PHP.
-   PhpMyAdmin - Web frontend for MySQL typically found in LAMP
    environments
-   Adminer - A full-featured database management tool which is
    available for MySQL, PostgreSQL, SQLite, MS SQL and Oracle
-   Xampp - Self contained web-server that supports PHP, Perl, and MySQL
-   mod_perl - Apache + Perl

Retrieved from
"https://wiki.archlinux.org/index.php?title=Suphp&oldid=226533"

Category:

-   Web Server
