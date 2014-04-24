Habari
======

Contents
--------

-   1 Introduction
-   2 Before You Install
-   3 Installation
    -   3.1 Step 1: Check PHP Configuration
    -   3.2 Step 2: Prepare MySQL Database
    -   3.3 Step 3: Check Apache Configuration
    -   3.4 Step 4: Prepare Habari Directory
    -   3.5 Step 5: Run The Installer
-   4 External Links

Introduction
------------

This document describes how to set up the Habari open source blogging
engine on an Arch Linux system. It also tells how to enable your
.htaccess file and required php modules that would prevent install
errors from occurring.

Before You Install
------------------

Know that Habari is still alpha and there is no package in the main or
AUR repositories. While some would claim that wordpress is better,
wordpress is bloated and habari makes for an excellent alternative fit
for efficient arch user.

Note: This howto assumes you have a LAMP already setup and ready to go.
If you haven't set one up yet, see LAMP.

Installation
------------

> Step 1: Check PHP Configuration

    # vim /etc/php/php.ini

Goto:

    ; available extensions

and enable, if not already enabled:

    extension=gd.so
    extension=gettext.so
    extension=iconv.so
    extension=json.so
    extension=mhash.so
    extension=mysql.so
    extension=pdo.so
    extension=pdo_mysql.so
    extension=session.so
    extension=xmlrpc.so
    extension=zlib.so

> Step 2: Prepare MySQL Database

You need to create a habari database for the blog to write stuff to. One
can choose habaridata for the db name, habari for the username, and
habaripass for the password. Assuming you've already accessed your mysql
install and set a root password:

    $ mysql -u root
    mysql> CREATE DATABASE habaridata;
    mysql> GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON habaridata.* TO 'habari'@'localhost' IDENTIFIED BY 'habaripass';
    mysql> FLUSH PRIVILEGES;

Quit MySQL:

    mysql> QUIT;

> Step 3: Check Apache Configuration

    # vim /etc/httpd/conf/httpd.conf

Look for and uncomment, if commented:

    LoadModule rewrite_module modules/mod_rewrite.so

Change all (just to be safe):

    AllowOverride None

To:

    AllowOverride FileInfo

Add (just to be safe):

    # Habari .htaccess
    <Directory /srv/http/blog>
         AllowOverride FileInfo
    </Directory>

Restart Apache:

    # /etc/rc.d/httpd restart

> Step 4: Prepare Habari Directory

    # cd /srv/http
    # mkdir habari (or whatever you want to call the folder that'll house the habari install (e.g., blog, etc.))
    # cd habari
    # chmod o+w . (this is to make the installation go smoothly, so apache can write to the folder)
    # touch .htaccess
    # touch config.php
    # chmod o+w .htaccess
    # chmod o+w config.php
    # svn checkout http://svn.habariproject.org/habari/trunk/htdocs .
    # mkdir user/files
    # chown http:http user/files
    # chmod o+w user/files
    # chown http:http user/cache
    # chmod o+w user/cache

> Step 5: Run The Installer

Head over to http://yourdomain.com/habari or whatever folder you called
it. The habari installer should come up. This is fairly straightforward.
Input the database information including the username and password. It
is recommended to also have a prefix for the database, if you're mysql
for other programs. The hostname will be localhost 99% of the time. You
can enable all the plugins including the nifty wordpress importer if you
want to migrate from that. The name of the blog can also be specified by
changing the default My Habari. Click the install button at the very
bottom and congratulations; you are now running Habari

External Links
--------------

-   Main Habari Install Resource:
    http://wiki.habariproject.org/en/Installation
-   Habari Troubleshooting:
    http://wiki.habariproject.org/en/Troubleshooting
-   For more info on mysql database preparation, see
    https://help.ubuntu.com/community/PunBB
-   Habari Themes: http://wiki.habariproject.org/en/Available_Themes

Retrieved from
"https://wiki.archlinux.org/index.php?title=Habari&oldid=286551"

Category:

-   Web Server

-   This page was last modified on 6 December 2013, at 14:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
