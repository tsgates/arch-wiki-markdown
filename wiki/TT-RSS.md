TT-RSS
======

Tiny Tiny RSS is an open source web-based news feed (RSS/Atom)
aggregator, designed to allow you to read news from any location, while
feeling as close to a real desktop application as possible.

Installation
------------

Install tt-rss from the official repositories.

tt-rss is installed into /usr/share/webapps/tt-rss/; you'll need to make
this directory available from your web server. The simplest way is to do

    # ln -s /usr/share/webapps/tt-rss /srv/http/tt-rss 

> Set up php and database

You'll need to set up a database, either MySQL or postgresql. Create a
user and database, e.g. with mysql:

    $ mysql -p -u root
    mysql> CREATE USER 'ttrss'@'localhost' IDENTIFIED BY 'somepassword';
    mysql> CREATE DATABASE ttrss;
    mysql> GRANT ALL PRIVILEGES ON ttrss.* TO "ttrss"@"localhost" IDENTIFIED BY 'somepassword';

You also need to add some paths to /etc/php/php.ini:

    ...
    include_path = "... :/etc/webapps/tt-rss"
    ...
    open_basedir = ... :/usr/share/webapps/:/etc/webapps/:/var/lib/tt-rss
    ...

In the same file, enable the following modules:

    extension=curl.so
    extension=iconv.so
    extension=mysql.so
    extension=posix.so
    extension=soap.so

You should now be able to navigate to (your-servers-root)/tt-rss and
proceed with the installer.

> Set up an update daemon

See http://tt-rss.org/redmine/projects/tt-rss/wiki/UpdatingFeeds – but
you should be able to simply

    # systemctl enable tt-rss

Do

    $ systemctl status tt-rss

to check that it's running fine.

Retrieved from
"https://wiki.archlinux.org/index.php?title=TT-RSS&oldid=305314"

Category:

-   Internet applications

-   This page was last modified on 17 March 2014, at 11:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
