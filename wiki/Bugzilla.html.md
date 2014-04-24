Bugzilla
========

Related articles

-   LAMP
-   MariaDB
-   Sqlite

Bugzilla is server software designed to help you manage software
development.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Apache
-   3 See also

Installation
------------

You can install bugzilla from the official repositories.

It requires a bunch of perl modules to be installed too, but some
required modules still need to be installed manually

Configuration
-------------

Make a module check first:

    $ cd /srv/http/bugzilla
    $ ./checksetup.pl --check-modules

Check the screen output, you will learn which module is required and
which is optional, for missing modules, it will also show you the shell
command to install them.

Install all required and optional modules using:

    $ perl install-module.pl -all

Next, some more configuration to let bugzilla know how to connect mysql
and create initial tables in it.

Run checksetup.pl again, this time without the –check-modules switch:

    $ ./checksetup.pl

A file called "localconfig" is generated if everything is ok. Then edit
it, modify some parameters there:

    $webservergroup = 'http';
    $db_driver = 'DATABASE_TO_USE_HERE';
    $db_name = 'DATABASE_NAME_HERE';
    $db_user = 'DATABASE_USER_HERE';
    $db_pass = 'YOUR_PASSWORD_HERE';

> Apache

Finally, configure apache to run bugzilla using mod_cgi (also can be
configured using mod_perl, refer this for details)

Add following lines to /etc/httpd/conf/httpd.conf:

    <Directory /srv/http/bugzilla>
      AddHandler cgi-script .cgi
      Options +Indexes +ExecCGI
      DirectoryIndex index.cgi
      AllowOverride Limit
    </Directory>

Now restart apache and required modules

Access http://server-domain-or-ip/bugzilla/ using your web browser.

See also
--------

-   bugzilla documentation
-   http://blog.samsonis.me/2009/04/bugzilla-on-archlinux/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bugzilla&oldid=290955"

Categories:

-   Web Server
-   Development

-   This page was last modified on 30 December 2013, at 18:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
